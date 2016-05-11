library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package components is
	type cmd_type is (read,write);
	component flash_controller
		port(
			reset		:in std_logic;
			clk200mhz	:in std_logic;
			-- Master's Interface:
			cmd			:in cmd_type;
			datain		:in std_logic(7 downto 0);
			dataout		:in std_logic(7 downto 0);
			address		:in std_logic(22 downto 0);
			busy		:out boolean;
			valid		:out boolean;
			-- Hardware:
			FL_ADDR		:out std_logic_vector(22 downto 0);
			FL_CE_N		:out std_logic;
			FL_DQ		:inout std_logic_vector(7 downto 0);
			FL_OE_N		:out std_logic;
			FL_RST_N	:out std_logic;
			FL_RY		:in std_logic;
			FL_WE_N		:out std_logic;
			FL_WP_N		:out std_logic
		);
	end component;
end package;
