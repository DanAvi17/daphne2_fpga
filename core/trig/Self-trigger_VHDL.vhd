----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Edgar Rincon-Gil
-- 
-- Create Date: 11/17/2022 09:58:39 AM
-- Design Name: self-trigger
-- Module Name: Self-trigger_VHDL - Behavioral
-- Project Name: DAPHNE-DUNE
-- Target Devices: DAPHNE - xc7a200t-fbg676-3
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_signed.all; 


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
use work.daphne2_package.all;
--entity Self-trigger_VHDL is
----  Port ( );
--end Self-trigger_VHDL;

--architecture Behavioral of Self-trigger_VHDL is

--begin


--end Behavioral;
entity self_trigger is
 generic(
  g_INPUT_WIDTH : natural := 14;
  g_SUM_WIDTH   : natural := 14;
  g_MULT_WIDTH  : natural := 28
 );
 port(
  clk  : in  std_logic;
  rst : in std_logic;
  i_data  : in  std_logic_vector(g_INPUT_WIDTH - 1 downto 0);
  o_data : out std_logic_vector(g_SUM_WIDTH - 1 downto 0);
  o_trigger : out std_logic
 );
end self_trigger;

architecture Behavioral of self_trigger is
    component highPass_FirstOrder
        generic(
            Data_Size: integer := 14;
            Coefficient_Resolution : integer := 17 -- One more than decimal desired
        );
        port(
            rst : in std_logic; -- Reset for the filter
            clk : in std_logic; -- Clock for the filter
            x_in : in std_logic_vector((Data_Size - 1) downto 0); -- Input vector from AFEs
            y_out : out std_logic_vector((Data_Size - 1) downto 0) -- Output vector from Filter
        );            
    end component;
    
    signal data_hpf         : std_logic_vector(13 downto 0);
    --signal data_self_trigger: std_logic_vector(13 downto 0);
--    signal r_data_0         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_1         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_2         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_3         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_4         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_5         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_6         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_7         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_8         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_9         : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_10        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_11        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_12        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_13        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_14        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_15        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_16        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_17        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_18        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_19        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_20        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_21        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_22        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_23        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_24        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_25        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_26        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_27        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_28        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_29        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_30        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_31        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_32        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_33        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_34        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_35        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_36        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_37        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_38        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_39        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_40        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_41        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_42        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_43        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_44        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_45        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_46        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_47        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_48        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_49        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_50        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_51        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_52        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_53        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_54        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_55        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_56        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_57        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_58        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_59        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_60        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_61        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_62        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
--    signal r_data_63        : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    
    signal r_hpf_data_0     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_1     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_2     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_3     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_4     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_5     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_6     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_7     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_8     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_9     : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_10    : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_11    : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_12    : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_13    : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_14    : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    signal r_hpf_data_15    : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    
    signal r_multdata_0     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_1     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_2     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_3     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_4     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_5     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_6     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_7     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_8     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_9     : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_10    : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_11    : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_12    : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_13    : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_14    : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_multdata_15    : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_16       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_17       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_18       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_19       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_20       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_21       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_22       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_23       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_24       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_25       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_26       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_27       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_28       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_29       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_30       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_31       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_32       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_33       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_34       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_35       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_36       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_37       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_38       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_39       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_40       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_41       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_42       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_43       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_44       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_45       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_46       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_47       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_48       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_49       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_50       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_51       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_52       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_53       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_54       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_55       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_56       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_57       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_58       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_59       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_60       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_61       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_62       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_multdata_63       : signed(g_MULT_WIDTH - 1 downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_sumamult       : signed(g_MULT_WIDTH -1  downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_sumamult1      : signed(g_MULT_WIDTH -1  downto 0):= to_signed(0, g_MULT_WIDTH);
    signal r_sumamult2      : signed(g_MULT_WIDTH -1  downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_sumamult3      : signed(g_MULT_WIDTH -1  downto 0):= to_signed(0, g_MULT_WIDTH);
    -- signal r_sumamult4      : signed(g_MULT_WIDTH -1  downto 0):= to_signed(0, g_MULT_WIDTH);
    
    -- signal r_pedestal      : signed(g_INPUT_WIDTH - 1 downto 0):= to_signed(0, g_INPUT_WIDTH);
    
    -- Constantes
    -- type TEMPLATE is array(0 to 63) of signed(g_INPUT_WIDTH - 1 downto 0);
    -- constant c_templ: template := ( to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(-1),g_INPUT_WIDTH ), 
    --    to_signed(integer(-1), g_INPUT_WIDTH ), to_signed(integer(-2), g_INPUT_WIDTH), to_signed(integer(-2), g_INPUT_WIDTH), 
    --    to_signed(integer(-3), g_INPUT_WIDTH), to_signed(integer(-3), g_INPUT_WIDTH), to_signed(integer(-4), g_INPUT_WIDTH), 
    --    to_signed(integer(-4), g_INPUT_WIDTH), to_signed(integer(-5), g_INPUT_WIDTH), to_signed(integer(-6), g_INPUT_WIDTH), 
    --    to_signed(integer(-6), g_INPUT_WIDTH), to_signed(integer(-7), g_INPUT_WIDTH), to_signed(integer(-8), g_INPUT_WIDTH), 
    --    to_signed(integer(-8), g_INPUT_WIDTH), to_signed(integer(-9), g_INPUT_WIDTH), to_signed(integer(-9), g_INPUT_WIDTH), 
    --    to_signed(integer(-10), g_INPUT_WIDTH), to_signed(integer(-10), g_INPUT_WIDTH), to_signed(integer(-10), g_INPUT_WIDTH), 
    --    to_signed(integer(-10), g_INPUT_WIDTH), to_signed(integer(-9), g_INPUT_WIDTH), to_signed(integer(-8), g_INPUT_WIDTH), 
    --    to_signed(integer(-7), g_INPUT_WIDTH), to_signed(integer(-5), g_INPUT_WIDTH), to_signed(integer(-3), g_INPUT_WIDTH),
    --    to_signed(integer(-1), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH),
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH));
    --type TEMPLATE is array(0 to 63) of signed(g_INPUT_WIDTH - 1 downto 0);
    -- constant c_templ: template := ( to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(1),g_INPUT_WIDTH ), 
    --    to_signed(integer(1), g_INPUT_WIDTH ), to_signed(integer(1), g_INPUT_WIDTH), to_signed(integer(2), g_INPUT_WIDTH), 
    --    to_signed(integer(2), g_INPUT_WIDTH), to_signed(integer(2), g_INPUT_WIDTH), to_signed(integer(3), g_INPUT_WIDTH), 
    --    to_signed(integer(3), g_INPUT_WIDTH), to_signed(integer(4), g_INPUT_WIDTH), to_signed(integer(4), g_INPUT_WIDTH), 
    --    to_signed(integer(5), g_INPUT_WIDTH), to_signed(integer(5), g_INPUT_WIDTH), to_signed(integer(6), g_INPUT_WIDTH), 
    --    to_signed(integer(6), g_INPUT_WIDTH), to_signed(integer(7), g_INPUT_WIDTH), to_signed(integer(7), g_INPUT_WIDTH), 
    --    to_signed(integer(8), g_INPUT_WIDTH), to_signed(integer(8), g_INPUT_WIDTH), to_signed(integer(8), g_INPUT_WIDTH), 
    --    to_signed(integer(9), g_INPUT_WIDTH), to_signed(integer(9), g_INPUT_WIDTH), to_signed(integer(8), g_INPUT_WIDTH), 
    --    to_signed(integer(8), g_INPUT_WIDTH), to_signed(integer(8), g_INPUT_WIDTH), to_signed(integer(7), g_INPUT_WIDTH),
    --    to_signed(integer(6), g_INPUT_WIDTH), to_signed(integer(5), g_INPUT_WIDTH), to_signed(integer(4), g_INPUT_WIDTH), 
    --    to_signed(integer(2), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(-2), g_INPUT_WIDTH), 
    --    to_signed(integer(-5), g_INPUT_WIDTH), to_signed(integer(-7), g_INPUT_WIDTH), to_signed(integer(-10), g_INPUT_WIDTH), 
    --    to_signed(integer(-14), g_INPUT_WIDTH), to_signed(integer(-17), g_INPUT_WIDTH), to_signed(integer(-21), g_INPUT_WIDTH), 
    --    to_signed(integer(-25), g_INPUT_WIDTH), to_signed(integer(-30), g_INPUT_WIDTH), to_signed(integer(-34), g_INPUT_WIDTH), 
    --    to_signed(integer(-39), g_INPUT_WIDTH), to_signed(integer(-44), g_INPUT_WIDTH), to_signed(integer(-48), g_INPUT_WIDTH), 
    --    to_signed(integer(-53), g_INPUT_WIDTH), to_signed(integer(-58), g_INPUT_WIDTH), to_signed(integer(-62), g_INPUT_WIDTH),
    --    to_signed(integer(-66), g_INPUT_WIDTH), to_signed(integer(-70), g_INPUT_WIDTH), to_signed(integer(-73), g_INPUT_WIDTH), 
    --    to_signed(integer(-76), g_INPUT_WIDTH), to_signed(integer(-77), g_INPUT_WIDTH), to_signed(integer(-78), g_INPUT_WIDTH), 
    --    to_signed(integer(-78), g_INPUT_WIDTH), to_signed(integer(-76), g_INPUT_WIDTH), to_signed(integer(-73), g_INPUT_WIDTH), 
    --    to_signed(integer(-69), g_INPUT_WIDTH), to_signed(integer(-62), g_INPUT_WIDTH), to_signed(integer(-54), g_INPUT_WIDTH), 
    --    to_signed(integer(-44), g_INPUT_WIDTH), to_signed(integer(-32), g_INPUT_WIDTH), to_signed(integer(-17), g_INPUT_WIDTH), 
    --    to_signed(integer(0), g_INPUT_WIDTH), to_signed(integer(0), g_INPUT_WIDTH));
        
    type TEMPLATE is array(0 to 15) of signed(g_INPUT_WIDTH - 1 downto 0);
    constant c_templ: template := ( 
    to_signed(integer(-66), g_INPUT_WIDTH), 
    to_signed(integer(-70), g_INPUT_WIDTH), 
    to_signed(integer(-73), g_INPUT_WIDTH), 
    to_signed(integer(-76), g_INPUT_WIDTH),
    to_signed(integer(-77), g_INPUT_WIDTH), 
    to_signed(integer(-78), g_INPUT_WIDTH), 
    to_signed(integer(-78), g_INPUT_WIDTH), 
    to_signed(integer(-76), g_INPUT_WIDTH), 
    to_signed(integer(-73), g_INPUT_WIDTH), 
    to_signed(integer(-69), g_INPUT_WIDTH), 
    to_signed(integer(-62), g_INPUT_WIDTH), 
    to_signed(integer(-54), g_INPUT_WIDTH), 
    to_signed(integer(-44), g_INPUT_WIDTH), 
    to_signed(integer(-32), g_INPUT_WIDTH), 
    to_signed(integer(-17), g_INPUT_WIDTH), 
    to_signed(integer(0), g_INPUT_WIDTH)
    ); 
    
    
    
    begin
    
        hpf_inst: highPass_FirstOrder 
        port map(
            rst => rst,
            clk  => clk,
            x_in => i_data,
            y_out => data_hpf
        );
    --Correr los registros para hacer el buffering
    process(clk)
    begin
        if rising_edge(clk) then
         if (rst = '1') then
--                r_data_0 <= b"00000000000000";
--                r_data_1 <= b"00000000000000";
--                r_data_2 <= b"00000000000000";
--                r_data_3 <= b"00000000000000";
--                r_data_4 <= b"00000000000000";
--                r_data_5 <= b"00000000000000";
--                r_data_6 <= b"00000000000000";
--                r_data_7 <= b"00000000000000";
--                r_data_8 <= b"00000000000000";
--                r_data_9 <= b"00000000000000";
--                r_data_10 <= b"00000000000000";
--                r_data_11 <= b"00000000000000";
--                r_data_12 <= b"00000000000000";
--                r_data_13 <= b"00000000000000";
--                r_data_14 <= b"00000000000000";
--                r_data_15 <= b"00000000000000";
--                r_data_16 <= b"00000000000000";
--                r_data_17 <= b"00000000000000";
--                r_data_18 <= b"00000000000000";
--                r_data_19 <= b"00000000000000";
--                r_data_20 <= b"00000000000000";
--                r_data_21 <= b"00000000000000";
--                r_data_22 <= b"00000000000000";
--                r_data_23 <= b"00000000000000";
--                r_data_24 <= b"00000000000000";
--                r_data_25 <= b"00000000000000";
--                r_data_26 <= b"00000000000000";
--                r_data_27 <= b"00000000000000";
--                r_data_28 <= b"00000000000000";
--                r_data_29 <= b"00000000000000";
--                r_data_30 <= b"00000000000000";
--                r_data_31 <= b"00000000000000";
--                r_data_32 <= b"00000000000000";
--                r_data_33 <= b"00000000000000";
--                r_data_34 <= b"00000000000000";
--                r_data_35 <= b"00000000000000";
--                r_data_36 <= b"00000000000000";
--                r_data_37 <= b"00000000000000";
--                r_data_38 <= b"00000000000000";
--                r_data_39 <= b"00000000000000";
--                r_data_40 <= b"00000000000000";
--                r_data_41 <= b"00000000000000";
--                r_data_42 <= b"00000000000000";
--                r_data_43 <= b"00000000000000";
--                r_data_44 <= b"00000000000000";
--                r_data_45 <= b"00000000000000";
--                r_data_46 <= b"00000000000000";
--                r_data_47 <= b"00000000000000";
--                r_data_48 <= b"00000000000000";
--                r_data_49 <= b"00000000000000";
--                r_data_50 <= b"00000000000000";
--                r_data_51 <= b"00000000000000";
--                r_data_52 <= b"00000000000000";
--                r_data_53 <= b"00000000000000";
--                r_data_54 <= b"00000000000000";
--                r_data_55 <= b"00000000000000";
--                r_data_56 <= b"00000000000000";
--                r_data_57 <= b"00000000000000";
--                r_data_58 <= b"00000000000000";
--                r_data_59 <= b"00000000000000";
--                r_data_60 <= b"00000000000000";
--                r_data_61 <= b"00000000000000";
--                r_data_62 <= b"00000000000000";
--                r_data_63 <= b"00000000000000";
                o_data <= b"00000000000000";
               
                r_hpf_data_0 <= b"00000000000000";
                r_hpf_data_1 <= b"00000000000000";
                r_hpf_data_2 <= b"00000000000000";
                r_hpf_data_3 <= b"00000000000000";
                r_hpf_data_4 <= b"00000000000000";
                r_hpf_data_5 <= b"00000000000000";
                r_hpf_data_6 <= b"00000000000000";
                r_hpf_data_7 <= b"00000000000000";
                r_hpf_data_8 <= b"00000000000000";
                r_hpf_data_9 <= b"00000000000000";
                r_hpf_data_10 <= b"00000000000000";                
                r_hpf_data_11 <= b"00000000000000";
                r_hpf_data_12 <= b"00000000000000";
                r_hpf_data_13 <= b"00000000000000";
                r_hpf_data_14 <= b"00000000000000";
                r_hpf_data_15 <= b"00000000000000";
               
            else
                --r_data_0 <= (signed(i_data) - 8000);
--                r_data_0 <= signed(i_data);
--                r_data_1 <= r_data_0;
--                r_data_2 <= r_data_1;
--                r_data_3 <= r_data_2;
--                r_data_4 <= r_data_3;
--                r_data_5 <= r_data_4;
--                r_data_6 <= r_data_5;
--                r_data_7 <= r_data_6;
--                r_data_8 <= r_data_7;
--                r_data_9 <= r_data_8;
--                r_data_10 <= r_data_9;
--                r_data_11 <= r_data_10;
--                r_data_12 <= r_data_11;
--                r_data_13 <= r_data_12;
--                r_data_14 <= r_data_13;
--                r_data_15 <= r_data_14;
--                r_data_16 <= r_data_15;
--                r_data_17 <= r_data_16;
--                r_data_18 <= r_data_17;
--                r_data_19 <= r_data_18;
--                r_data_20 <= r_data_19;
--                r_data_21 <= r_data_20;
--                r_data_22 <= r_data_21;
--                r_data_23 <= r_data_22;
--                r_data_24 <= r_data_23;
--                r_data_25 <= r_data_24;
--                r_data_26 <= r_data_25;
--                r_data_27 <= r_data_26;
--                r_data_28 <= r_data_27;
--                r_data_29 <= r_data_28;
--                r_data_30 <= r_data_29;
--                r_data_31 <= r_data_30;
--                r_data_32 <= r_data_31;
--                r_data_33 <= r_data_32;
--                r_data_34 <= r_data_33;
--                r_data_35 <= r_data_34;
--                r_data_36 <= r_data_35;
--                r_data_37 <= r_data_36;
--                r_data_38 <= r_data_37;
--                r_data_39 <= r_data_38;
--                r_data_40 <= r_data_39;
--                r_data_41 <= r_data_40;
--                r_data_42 <= r_data_41;
--                r_data_43 <= r_data_42;
--                r_data_44 <= r_data_43;
--                r_data_45 <= r_data_44;
--                r_data_46 <= r_data_45;
--                r_data_47 <= r_data_46;
--                r_data_48 <= r_data_47;
--                r_data_49 <= r_data_48;
--                r_data_50 <= r_data_49;
--                r_data_51 <= r_data_50;
--                r_data_52 <= r_data_51;
--                r_data_53 <= r_data_52;
--                r_data_54 <= r_data_53;
--                r_data_55 <= r_data_54;
--                r_data_56 <= r_data_55;
--                r_data_57 <= r_data_56;
--                r_data_58 <= r_data_57;
--                r_data_59 <= r_data_58;
--                r_data_60 <= r_data_59;
--                r_data_61 <= r_data_60;
--                r_data_62 <= r_data_61;
--                r_data_63 <= r_data_62;
                o_data <= i_data;
                
                r_hpf_data_0 <= signed(data_hpf);
                r_hpf_data_1 <= r_hpf_data_0;
                r_hpf_data_2 <= r_hpf_data_1;
                r_hpf_data_3 <= r_hpf_data_2;
                r_hpf_data_4 <= r_hpf_data_3;
                r_hpf_data_5 <= r_hpf_data_4;
                r_hpf_data_6 <= r_hpf_data_5;
                r_hpf_data_7 <= r_hpf_data_6;
                r_hpf_data_8 <= r_hpf_data_7;
                r_hpf_data_9 <= r_hpf_data_8;
                r_hpf_data_10 <= r_hpf_data_9;
                r_hpf_data_11 <= r_hpf_data_10;
                r_hpf_data_12 <= r_hpf_data_11;
                r_hpf_data_13 <= r_hpf_data_12;
                r_hpf_data_14 <= r_hpf_data_13;
                r_hpf_data_15 <= r_hpf_data_14;
            end if;                
        end if;
    end process;
    
    --Sumar los registros para obtener el pedestal
    --    process(clk)
    --    begin
    --        if rising_edge(clk) then
    --            r_pedestal <= shift_right(r_data_0 + r_data_1 + r_data_2 + r_data_3 + 
    --                r_data_4 + r_data_5 + r_data_6 + r_data_7 + r_data_8 +
    --                r_data_9 + r_data_10 + r_data_11 + r_data_12 + r_data_13 +
    --                r_data_14 + r_data_15 + r_data_16 + r_data_17 + r_data_18 +
    --                r_data_19 + r_data_20 + r_data_21 + r_data_22 + r_data_23 +
    --                r_data_24 + r_data_25 + r_data_26 + r_data_27 + r_data_28 +
    --                r_data_29 + r_data_30 + r_data_31 + r_data_32 + r_data_33 +
    --                r_data_34 + r_data_35 + r_data_36 + r_data_37 + r_data_38 +
    --                r_data_39 + r_data_40 + r_data_41 + r_data_42 + r_data_43 +
    --                r_data_44 + r_data_45 + r_data_46 + r_data_47 + r_data_48 +
    --                r_data_49 + r_data_50 + r_data_51 + r_data_52 + r_data_53 +
    --                r_data_54 + r_data_55 + r_data_56 + r_data_57 + r_data_58 +
    --                r_data_59 + r_data_60 + r_data_61 + r_data_62 + r_data_63, 6);
    --        end if;
    --    end process;
    
    --Multiplicar los registros para obtener la correlacion
    process(clk)
    begin     
        if rising_edge(clk) then
            r_multdata_0 <= r_hpf_data_0*c_templ(0);
            r_multdata_1 <= r_hpf_data_1*c_templ(1);
            r_multdata_2 <= r_hpf_data_2*c_templ(2);
            r_multdata_3 <= r_hpf_data_3*c_templ(3);
            r_multdata_4 <= r_hpf_data_4*c_templ(4);
            r_multdata_5 <= r_hpf_data_5*c_templ(5);
            r_multdata_6 <= r_hpf_data_6*c_templ(6);
            r_multdata_7 <= r_hpf_data_7*c_templ(7);
            r_multdata_8 <= r_hpf_data_8*c_templ(8);
            r_multdata_9 <= r_hpf_data_9*c_templ(9);
            r_multdata_10 <= r_hpf_data_10*c_templ(10);
            r_multdata_11 <= r_hpf_data_11*c_templ(11);
            r_multdata_12 <= r_hpf_data_12*c_templ(12);
            r_multdata_13 <= r_hpf_data_13*c_templ(13);
            r_multdata_14 <= r_hpf_data_14*c_templ(14);
            r_multdata_15 <= r_hpf_data_15*c_templ(15);
    --            r_multdata_16 <= r_data_16*c_templ(16);
    --            r_multdata_17 <= r_data_17*c_templ(17);
    --            r_multdata_18 <= r_data_18*c_templ(18);
    --            r_multdata_19 <= r_data_19*c_templ(19);
    --            r_multdata_20 <= r_data_20*c_templ(20);
    --            r_multdata_21 <= r_data_21*c_templ(21);
    --            r_multdata_22 <= r_data_22*c_templ(22);
    --            r_multdata_23 <= r_data_23*c_templ(23);
    --            r_multdata_24 <= r_data_24*c_templ(24);
    --            r_multdata_25 <= r_data_25*c_templ(25);
    --            r_multdata_26 <= r_data_26*c_templ(26);
    --            r_multdata_27 <= r_data_27*c_templ(27);
    --            r_multdata_28 <= r_data_28*c_templ(28);
    --            r_multdata_29 <= r_data_29*c_templ(29);
    --            r_multdata_30 <= r_data_30*c_templ(30);
    --            r_multdata_31 <= r_data_31*c_templ(31);
    --            r_multdata_32 <= r_data_32*c_templ(32);
    --            r_multdata_33 <= r_data_33*c_templ(33);
    --            r_multdata_34 <= r_data_34*c_templ(34);
    --            r_multdata_35 <= r_data_35*c_templ(35);
    --            r_multdata_36 <= r_data_36*c_templ(36);
    --            r_multdata_37 <= r_data_37*c_templ(37);
    --            r_multdata_38 <= r_data_38*c_templ(38);
    --            r_multdata_39 <= r_data_39*c_templ(39);
    --            r_multdata_40 <= r_data_40*c_templ(40);
    --            r_multdata_41 <= r_data_41*c_templ(41);
    --            r_multdata_42 <= r_data_42*c_templ(42);
    --            r_multdata_43 <= r_data_43*c_templ(43);
    --            r_multdata_44 <= r_data_44*c_templ(44);
    --            r_multdata_45 <= r_data_45*c_templ(45);
    --            r_multdata_46 <= r_data_46*c_templ(46);
    --            r_multdata_47 <= r_data_47*c_templ(47);
    --            r_multdata_48 <= r_data_48*c_templ(48);
    --            r_multdata_49 <= r_data_49*c_templ(49);
    --            r_multdata_50 <= r_data_50*c_templ(50);
    --            r_multdata_51 <= r_data_51*c_templ(51);
    --            r_multdata_52 <= r_data_52*c_templ(52);
    --            r_multdata_53 <= r_data_53*c_templ(53);
    --            r_multdata_54 <= r_data_54*c_templ(54);
    --            r_multdata_55 <= r_data_55*c_templ(55);
    --            r_multdata_56 <= r_data_56*c_templ(56);
    --            r_multdata_57 <= r_data_57*c_templ(57);
    --            r_multdata_58 <= r_data_58*c_templ(58);
    --            r_multdata_59 <= r_data_59*c_templ(59);
    --            r_multdata_60 <= r_data_60*c_templ(60);
    --            r_multdata_61 <= r_data_61*c_templ(61);
    --            r_multdata_62 <= r_data_62*c_templ(62);
    --            r_multdata_63 <= r_data_63*c_templ(63);
            
    --            r_sumamult <= shift_right((r_multdata_0 + r_multdata_1 + r_multdata_2 + 
    --                r_multdata_3 + r_multdata_4 + r_multdata_5 + r_multdata_6 + 
    --                r_multdata_7 + r_multdata_8 + r_multdata_9 + r_multdata_10 + 
    --                r_multdata_11 + r_multdata_12 + r_multdata_13 + r_multdata_14 + 
    --                r_multdata_15 + r_multdata_16 + r_multdata_17 + r_multdata_18 +
    --                r_multdata_19 + r_multdata_20 + r_multdata_21 + r_multdata_22 + 
    --                r_multdata_23 + r_multdata_24 + r_multdata_25 + r_multdata_26 + 
    --                r_multdata_27 + r_multdata_28 + r_multdata_29 + r_multdata_30 + 
    --                r_multdata_31 + r_multdata_32 + r_multdata_33 + r_multdata_34 + 
    --                r_multdata_35 + r_multdata_36 + r_multdata_37 + r_multdata_38 +
    --                r_multdata_39 + r_multdata_40 + r_multdata_41 + r_multdata_42 + 
    --                r_multdata_43 + r_multdata_44 + r_multdata_45 + r_multdata_46 + 
    --                r_multdata_47 + r_multdata_48 + r_multdata_49 + r_multdata_50 + 
    --                r_multdata_51 + r_multdata_52 + r_multdata_53 + r_multdata_54 + 
    --                r_multdata_55 + r_multdata_56 + r_multdata_57 + r_multdata_58 +
    --                r_multdata_59 + r_multdata_60 + r_multdata_61 + r_multdata_62 + 
    --                r_multdata_63), 5);
    --            r_sumamult <= (r_multdata_0 + r_multdata_1 + r_multdata_2 + 
    --                r_multdata_3 + r_multdata_4 + r_multdata_5 + r_multdata_6 + 
    --                r_multdata_7 + r_multdata_8 + r_multdata_9 + r_multdata_10 + 
    --                r_multdata_11 + r_multdata_12 + r_multdata_13 + r_multdata_14 + 
    --                r_multdata_15 + r_multdata_16 + r_multdata_17 + r_multdata_18 +
    --                r_multdata_19 + r_multdata_20 + r_multdata_21 + r_multdata_22 + 
    --                r_multdata_23 + r_multdata_24 + r_multdata_25 + r_multdata_26 + 
    --                r_multdata_27 + r_multdata_28 + r_multdata_29 + r_multdata_30 + 
    --                r_multdata_31 + r_multdata_32 + r_multdata_33 + r_multdata_34 + 
    --                r_multdata_35 + r_multdata_36 + r_multdata_37 + r_multdata_38 +
    --                r_multdata_39 + r_multdata_40 + r_multdata_41 + r_multdata_42 + 
    --                r_multdata_43 + r_multdata_44 + r_multdata_45 + r_multdata_46 + 
    --                r_multdata_47 + r_multdata_48 + r_multdata_49 + r_multdata_50 + 
    --                r_multdata_51 + r_multdata_52 + r_multdata_53 + r_multdata_54 + 
    --                r_multdata_55 + r_multdata_56 + r_multdata_57 + r_multdata_58 +
    --                r_multdata_59 + r_multdata_60 + r_multdata_61 + r_multdata_62 + 
    --                r_multdata_63);
    --r_sumamult <= (r_multdata_0 + r_multdata_1 + r_multdata_2 + 
    --                r_multdata_3 + r_multdata_4 + r_multdata_5 + r_multdata_6 + 
    --                r_multdata_7 + r_multdata_8 + r_multdata_9 + r_multdata_10 + 
    --                r_multdata_11 + r_multdata_12 + r_multdata_13 + r_multdata_14 + 
    --                r_multdata_15);
                
			r_sumamult1 <= r_multdata_0 + r_multdata_1 + r_multdata_2 + 
                r_multdata_3 + r_multdata_4 + r_multdata_5 + r_multdata_6 + 
                r_multdata_7;
			r_sumamult2 <= r_multdata_8 + r_multdata_9 + r_multdata_10 + 
                r_multdata_11 + r_multdata_12 + r_multdata_13 + r_multdata_14 + 
                r_multdata_15;
			r_sumamult <= r_sumamult1 + r_sumamult2;
	
	
			-- r_sumamult1 <= r_multdata_0 + r_multdata_1 + r_multdata_2 + 
                -- r_multdata_3;
            -- r_sumamult2 <= r_multdata_4 + r_multdata_5 + r_multdata_6 + 
                -- r_multdata_7; 
            -- r_sumamult3 <= r_multdata_8 + r_multdata_9 + r_multdata_10 + 
                -- r_multdata_11;
            -- r_sumamult4 <=  r_multdata_12 + r_multdata_13 + r_multdata_14 + 
                -- r_multdata_15;
            -- r_sumamult <= r_sumamult1 + r_sumamult2 + r_sumamult3 + r_sumamult4;
			
        end if;    
    end process;
    
    process(clk)
    begin     
        if rising_edge(clk) then
            if (r_sumamult > 10000) then
                o_trigger <= '1';
            else 
                o_trigger <= '0';
            end if;            
        end if;
    end process;    
    --
    -- Type conversion for output
    --
    --pout <= std_logic_vector(p);
    
end Behavioral;