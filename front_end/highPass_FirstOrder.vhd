----------------------------------------------------------------------------------
-- Company: Universidad EIA
-- Engineer: Daniel Avila Gomez
-- 
-- Create Date: 13.06.2023 07:26:37
-- Design Name: High Pass Filter DSP Slice
-- Module Name: highPass_FirstOrder_Oldv2 - Behavioral
-- Project Name: DAPHNE V1 - SELF TRIGGER MODULE
-- Target Devices: XC7A200T-1SBG484C
-- Tool Versions: 2022.2
-- Description: 
-- Instantiates a DSP48EC1 Slice
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Makes an approximation fo the output last value by truncating only some bits, instead of a full round
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL; 

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity highPass_FirstOrder is
    Generic (
        Data_Size : integer := 14;
        Coefficient_Resolution : integer := 17 -- One more than decimal desired
    );
    Port (
        rst : in std_logic; -- Reset for the filter
        clk : in std_logic; -- Clock for the filter
        x_in : in std_logic_vector((Data_Size - 1) downto 0); -- Input vector from AFEs
        y_out : out std_logic_vector((Data_Size - 1) downto 0) -- Output vector from Filter
    );
end highPass_FirstOrder;

architecture hp_firstOrd_arch of highPass_FirstOrder is

-- Coefficients used by the filter
--------------------------------------------------------------------------------------------------
-- Coefficients array (2 for a total of order 1)
--type coefficients is array(0 to 1) of signed(15 downto 0);
---- Numerator coefficients
--constant num_coef: coefficients := ( 
--    to_signed(integer(32743), 16), 
--    to_signed(integer(-32743), 16)
--);
---- Denominator coefficients
--constant den_coef: coefficients := ( 
--    to_signed(integer(1), 16), 
--    to_signed(integer(-32719), 16)
--);
-- Since the numerator uses the same constant but in a change of signs, we may only use one 
constant num_c1: signed(17 downto 0) := to_signed(integer(130973), Coefficient_Resolution + 1); -- Original 32743, changed to but this value should be modified according to the real multiplication of the coeff and the number representation
-- The denominator uses only one as the first coefficient 1 is a Bypass of the signal
constant den_c1: signed(17 downto 0) := to_signed(integer(130874), Coefficient_Resolution + 1); -- Original 32719, changed to but this value should be modified according to the real multiplication of the coeff and the number representation

-- Components used by the filter
--------------------------------------------------------------------------------------------------
-- Instantiates the DSP Slice component
component dsp_slice 
    Generic (
        A_Input, B_Input : string := "DIRECT";
        Use_Dport : boolean := FALSE;
        Use_Mult : string := "MULTIPLY";
        Use_SIMD : string := "ONE48";
        AutoRst_PatDet : string := "NO_RESET";
        Mask : bit_vector := X"3fffffffffff";
        Pattern : bit_vector := X"000000000000";
        Sel_Mask : string := "MASK";
        Sel_Pattern : string := "PATTERN";
        Use_Pattern_Det : string := "NO_PATDET";
        AReg, BReg, CReg, DReg, ADReg, MReg, PReg : integer := 1;
        ACascReg, BCascReg, ALUModeReg, CarryInReg, CarryInSelReg : integer := 1;                                     
        InModeReg, OPModeReg : integer := 1                     
    );
    Port ( 
        -- Reset for both the input and internal registers
        RstA, RstAllCarryIn, RstALUMode, RstB, RstC, RstCtrl, RstD, RstInMode, RstM, RstP : in std_logic;
        -- Data and Cascade: 30-bit (each) input: Data Ports
        A, ACIn : in std_logic_vector(29 downto 0); 
        B, BCIn : in std_logic_vector(17 downto 0); 
        C : in std_logic_vector(47 downto 0); 
        CarryIn, CarryCascIn : in std_logic;
        D : in std_logic_vector(24 downto 0); 
        -- Cascade: 30-bit (each) input: Cascade Ports
        MultSignIn: in std_logic;
        PCIn : in std_logic_vector(47 downto 0); 
        -- Control: 4-bit (each) input: Control Inputs/Status Bits
        ALUMode : in std_logic_vector(3 downto 0); 
        CarryInSel : in std_logic_vector(2 downto 0); 
        Clk: in std_logic;
        InMode : in std_logic_vector(4 downto 0); 
        OPMode : in std_logic_vector(6 downto 0);  
        -- Clock Enables for input registers and internal registers
        CEA1, CEA2, CEAD, CEALUMode, CEB1, CEB2, CEC, CECarryIn, CECtrl, CED, CEInMode, CEM, CEP: in std_logic;
        -- Cascade: 30-bit (each) output: Cascade Ports
        ACOut : out std_logic_vector(29 downto 0);
        BCOut : out std_logic_vector(17 downto 0);                 
        CarryCascOut, MultSignOut : out std_logic;
        -- Data: 4-bit (each) output: Data Ports
        CarryOut : out std_logic_vector(3 downto 0);  
        -- Data and Cascade: 48-bit (each) output: Data and Cascade Ports
        P, PCOut : out std_logic_vector(47 downto 0); 
        -- Control: 1-bit (each) output: Control Inputs/Status Bits
        Overflow, PatternBDetect, PatternDetect, Underflow: out std_logic   
    );
end component dsp_slice;

-- Auxiliar signals to interconnect the module
--------------------------------------------------------------------------------------------------
signal x_A: std_logic_vector(29 downto 0) := (others => '0'); -- was signed
signal x_D: std_logic_vector(24 downto 0) := (others => '0'); -- was signed
signal y_0: std_logic_vector(47 downto 0) := (others => '0');
signal y_1: std_logic_vector(47 downto 0) := (others => '0'); -- Past output value multiplied with the coefficient
signal y_0_resized: std_logic_vector(29 downto 0) := (others => '0'); -- Resized value fo the output, so that it fits the DSP slice multiplication input 
signal y_0_aux: std_logic_vector(47 downto 0) := (others => '0'); -- Refers to the right shifted, integer value of the filter's output
signal y_1_shifted: std_logic_vector(47 downto 0) := (others => '0'); 

begin

    -- Seems that changing the resolution of the coefficients did not do anything, must change the strcuture of the feeback filter multiplication!

    -- Transform the input to a signed type value in order to use in the module 
--------------------------------------------------------------------------------------------------------------------------------------
    x_A <= std_logic_vector(resize(unsigned(x_in),30));
    x_D <= std_logic_vector(resize(unsigned(x_in),25));    
      
    -- Forward FIR Filter (Input Signal and Its Registers)
--------------------------------------------------------------------------------------------------------------------------------------
    -- Requires only one DSP Slice 
    fir_forward : dsp_slice
        generic map (
            Use_Dport => TRUE,
            BReg => 0,
            DReg => 0,
            ADReg => 0,
            MReg => 0,
            PReg => 0,
            BCascReg => 0,
            ALUModeReg => 0,
            CarryInReg => 0,
            CarryInSelReg => 0,                                  
            InModeReg => 0,
            OPModeReg => 0
        )
        port map (
            RstA => rst,
            RstAllCarryIn => '0',
            RstALUMode => '0',
            RstB => '0',
            RstC => rst,
            RstCtrl => '0',
            RstD => '0',
            RstInMode => '0',
            RstM => '0',
            RstP => '0', 
            A => x_A,
            ACIn => b"000000000000000000000000000000",
            B => std_logic_vector(num_c1),
            BCIn => b"000000000000000000",
            C => y_1_shifted, -- X"ffffffffffff", --
            CarryIn => '0',
            CarryCascIn => '0',
            D => x_D,
            MultSignIn => '0',
            PCIn => X"000000000000",
            ALUMode => X"0",
            CarryInSel => b"000",
            Clk => clk,
            InMode => b"01100",
            OPMode => b"0110101", -- Disables the use of the C port b"0000101",  0110101
            CEA1 => '0',
            CEA2 => '1',
            CEAD => '0',
            CEALUMode => '0',
            CEB1 => '0',
            CEB2 => '0',
            CEC => '1',
            CECarryIn => '0', 
            CECtrl => '0',
            CED => '0',
            CEInMode => '0',
            CEM => '0',
            CEP => '0',
            ACOut => open,
            BCOut => open,                
            CarryCascOut => open,
            MultSignOut => open,
            CarryOut => open, 
            P => y_0, 
            PCOut => open,
            Overflow => open,
            PatternBDetect => open,
            PatternDetect => open,
            Underflow => open   
        );
        
    -- Transform the output of the first DSP referring to the actual current y[n] value
    -- Right shift it to turn it into a 14 bit integer with 18 bits in the decimal part (Full size of 32 bits embeded in 48 bits) 
--------------------------------------------------------------------------------------------------------------------------------------
    y_0_aux <= std_logic_vector(shift_right(signed(y_0),6)); -- Was right shifted 15 bits, changed acording to new approximation of the coefficients
    -- Resize the output so that it fits between 30 bits
    y_0_resized <= std_logic_vector(resize(signed(y_0_aux),30));
    
    -- Feedback FIR Filter (Output Signal)
--------------------------------------------------------------------------------------------------------------------------------------
    -- Requires only one DSP Slice 
    fir_feedback : dsp_slice
        generic map (
            AReg => 0,
            BReg => 0,
            ADReg => 0,
            MReg => 0,
            PReg => 0,
            ACascReg => 0,
            BCascReg => 0,
            ALUModeReg => 0,
            CarryInReg => 0,
            CarryInSelReg => 0,                                  
            InModeReg => 0,
            OPModeReg => 0
        )
        port map (
            RstA => '0',
            RstAllCarryIn => '0',
            RstALUMode => '0',
            RstB => '0',
            RstC => '0',
            RstCtrl => '0',
            RstD => '0',
            RstInMode => '0',
            RstM => '0',
            RstP => '0', 
            A => y_0_resized,
            ACIn => b"000000000000000000000000000000",
            B => std_logic_vector(den_c1),
            BCIn => b"000000000000000000",
            C => X"ffffffffffff",
            CarryIn => '0',
            CarryCascIn => '0',
            D => b"1111111111111111111111111",
            MultSignIn => '0',
            PCIn => X"000000000000",
            ALUMode => X"0",
            CarryInSel => b"000",
            Clk => clk,
            InMode => b"00000",
            OPMode => b"0000101",  
            CEA1 => '0',
            CEA2 => '0',
            CEAD => '0',
            CEALUMode => '0',
            CEB1 => '0',
            CEB2 => '0',
            CEC => '0',
            CECarryIn => '0', 
            CECtrl => '0',
            CED => '0',
            CEInMode => '0',
            CEM => '0',
            CEP => '0',
            ACOut => open,
            BCOut => open,                
            CarryCascOut => open,
            MultSignOut => open,
            CarryOut => open, 
            P => y_1, 
            PCOut => open,
            Overflow => open,
            PatternBDetect => open,
            PatternDetect => open,
            Underflow => open   
        );
        
    -- Now that y_1 exists, it has a 48 bit representation, but the actual bits that are being used 
    y_1_shifted <= std_logic_vector(shift_right(signed(y_1),11)); 
    
    -- Finally, let's assign the filter's output 
--------------------------------------------------------------------------------------------------------------------------------------
    -- Output from DSP is 48 bits long, must shift right 15 bits to find the integer part/round (changed to 17 bits later with new coefficient approximation)
    y_out <= std_logic_vector(resize(shift_right(signed(y_0),17),Data_Size)) ;
    
end hp_firstOrd_arch;