----------------------------------------------------------------------------------
-- Company: Universidad EIA
-- Engineer: Daniel Avila Gomez
-- 
-- Create Date: 07.06.2023 08:46:13
-- Design Name: DSP Module Instantiation
-- Module Name: dsp_slice - dspSlice_arch
-- Project Name: DAPHNE V1 - SELF TRIGGER
-- Target Devices: XC7A200T-1SBG484C
-- Tool Versions: 2022.2
-- Description: 
-- Instantiates a DSP48E1 Slice to create multiple arithmetic operations
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
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

entity dsp_slice is
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
        B, BCIn : std_logic_vector(17 downto 0);
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
end dsp_slice;

architecture dspSlice_arch of dsp_slice is
begin

    DSP48E1_inst : DSP48E1
       generic map (
          -- Feature Control Attributes: Data Path Selection
          A_INPUT               => A_Input,                 -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          B_INPUT               => B_Input,                 -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          USE_DPORT             => Use_Dport,               -- Select D port usage (TRUE or FALSE)
          USE_MULT              => Use_Mult,                -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
          USE_SIMD              => Use_SIMD,                -- SIMD selection ("ONE48", "TWO24", "FOUR12")
          -- Pattern Detector Attributes: Pattern Detection Configuration
          AUTORESET_PATDET      => AutoRst_PatDet,          -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
          MASK                  => Mask,                    -- 48-bit mask value for pattern detect (1=ignore)
          PATTERN               => Pattern,                 -- 48-bit pattern match for pattern detect
          SEL_MASK              => Sel_Mask,                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
          SEL_PATTERN           => Sel_Pattern,             -- Select pattern value ("PATTERN" or "C")
          USE_PATTERN_DETECT    => Use_Pattern_Det,         -- Enable pattern detect ("PATDET" or "NO_PATDET")
          -- Register Control Attributes: Pipeline Register Configuration
          ACASCREG              => ACascReg,                -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
          ADREG                 => ADReg,                   -- Number of pipeline stages for pre-adder (0 or 1)
          ALUMODEREG            => ALUModeReg,              -- Number of pipeline stages for ALUMODE (0 or 1)
          AREG                  => AReg,                    -- Number of pipeline stages for A (0, 1 or 2)
          BCASCREG              => BCascReg,                -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
          BREG                  => BReg,                    -- Number of pipeline stages for B (0, 1 or 2)
          CARRYINREG            => CarryInReg,              -- Number of pipeline stages for CARRYIN (0 or 1)
          CARRYINSELREG         => CarryInSelReg,           -- Number of pipeline stages for CARRYINSEL (0 or 1)
          CREG                  => CReg,                    -- Number of pipeline stages for C (0 or 1)
          DREG                  => DReg,                    -- Number of pipeline stages for D (0 or 1)
          INMODEREG             => InModeReg,               -- Number of pipeline stages for INMODE (0 or 1)
          MREG                  => MReg,                    -- Number of multiplier pipeline stages (0 or 1)
          OPMODEREG             => OPModeReg,               -- Number of pipeline stages for OPMODE (0 or 1)
          PREG                  => PReg                     -- Number of pipeline stages for P (0 or 1)
       )
       port map (
          -- Cascade: 30-bit (each) output: Cascade Ports
          ACOUT                 => ACOut,                   -- 30-bit output: A port cascade output
          BCOUT                 => BCOut,                   -- 18-bit output: B port cascade output
          CARRYCASCOUT          => CarryCascOut,            -- 1-bit output: Cascade carry output
          MULTSIGNOUT           => MultSignOut,             -- 1-bit output: Multiplier sign cascade output
          PCOUT                 => PCOut,                   -- 48-bit output: Cascade output
          -- Control: 1-bit (each) output: Control Inputs/Status Bits
          OVERFLOW              => Overflow,                -- 1-bit output: Overflow in add/acc output
          PATTERNBDETECT        => PatternBDetect,          -- 1-bit output: Pattern bar detect output
          PATTERNDETECT         => PatternDetect,           -- 1-bit output: Pattern detect output
          UNDERFLOW             => Underflow,               -- 1-bit output: Underflow in add/acc output
          -- Data: 4-bit (each) output: Data Ports
          CARRYOUT              => CarryOut,                -- 4-bit output: Carry output
          P                     => P,                       -- 48-bit output: Primary data output
          -- Cascade: 30-bit (each) input: Cascade Ports
          ACIN                  => ACIn,                    -- 30-bit input: A cascade data input
          BCIN                  => BCIn,                    -- 18-bit input: B cascade input
          CARRYCASCIN           => CarryCascIn,             -- 1-bit input: Cascade carry input
          MULTSIGNIN            => MultSignIn,              -- 1-bit input: Multiplier sign input
          PCIN                  => PCIn,                    -- 48-bit input: P cascade input
          -- Control: 4-bit (each) input: Control Inputs/Status Bits
          ALUMODE               => ALUMode,                 -- 4-bit input: ALU control input
          CARRYINSEL            => CarryInSel,              -- 3-bit input: Carry select input
          CLK                   => Clk,                     -- 1-bit input: Clock input
          INMODE                => InMode,                  -- 5-bit input: INMODE control input
          OPMODE                => OPMode,                  -- 7-bit input: Operation mode input
          -- Data: 30-bit (each) input: Data Ports
          A                     => A,                       -- 30-bit input: A data input
          B                     => B,                       -- 18-bit input: B data input
          C                     => C,                       -- 48-bit input: C data input
          CARRYIN               => CarryIn,                 -- 1-bit input: Carry input signal
          D                     => D,                       -- 25-bit input: D data input
          -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
          CEA1                  => CEA1,                    -- 1-bit input: Clock enable input for 1st stage AREG
          CEA2                  => CEA2,                    -- 1-bit input: Clock enable input for 2nd stage AREG
          CEAD                  => CEAD,                    -- 1-bit input: Clock enable input for ADREG
          CEALUMODE             => CEALUMode,               -- 1-bit input: Clock enable input for ALUMODE
          CEB1                  => CEB1,                    -- 1-bit input: Clock enable input for 1st stage BREG
          CEB2                  => CEB2,                    -- 1-bit input: Clock enable input for 2nd stage BREG
          CEC                   => CEC,                     -- 1-bit input: Clock enable input for CREG
          CECARRYIN             => CECarryIn,               -- 1-bit input: Clock enable input for CARRYINREG
          CECTRL                => CECtrl,                  -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
          CED                   => CED,                     -- 1-bit input: Clock enable input for DREG
          CEINMODE              => CEInMode,                -- 1-bit input: Clock enable input for INMODEREG
          CEM                   => CEM,                     -- 1-bit input: Clock enable input for MREG
          CEP                   => CEP,                     -- 1-bit input: Clock enable input for PREG
          RSTA                  => RstA,                -- 1-bit input: Reset input for AREG
          RSTALLCARRYIN         => RstAllCarryIn,                -- 1-bit input: Reset input for CARRYINREG
          RSTALUMODE            => RstALUMode,                -- 1-bit input: Reset input for ALUMODEREG
          RSTB                  => RstB,                -- 1-bit input: Reset input for BREG
          RSTC                  => RstC,                -- 1-bit input: Reset input for CREG
          RSTCTRL               => RstCtrl,                -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
          RSTD                  => RstD,                -- 1-bit input: Reset input for DREG and ADREG
          RSTINMODE             => RstInMode,                -- 1-bit input: Reset input for INMODEREG
          RSTM                  => RstM,                -- 1-bit input: Reset input for MREG
          RSTP                  => RstP                 -- 1-bit input: Reset input for PREG
       );

end dspSlice_arch;