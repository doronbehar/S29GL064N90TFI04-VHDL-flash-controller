library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library flash;
use flash.timings.all;
use flash.components.all;

entity flash_controller is
	port(
		reset		:in std_logic;
		clk200mhz	:in std_logic;
		-- Master's Interface:
		cmd			:in cmd_type;
		datain		:in std_logic(7 downto 0);
		dataout		:out std_logic(7 downto 0);
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
end entity;

architecture arc of flash_controller is
begin
	process(clk200mhz,reset)
		type state_type is (rst,idle,reading,writing);
		variable state:state_type;
		variable counter:integer; --range 0 to 20;
		variable addr	:std_logic_vector(22 downto 0);
	begin
		if reset='0' then
			state:=rst;
			counter:=0;
			FL_RST_N<='0';
		elsif rising_edge(clk200mhz) then
			case state is
				when rst=>
					busy<=true;
					if counter>100 then
						FL_RST_N<='1';
					end if;
					if counter>110 then
						FL_CE_N<='0';
						FL_OE_N<='0';
					end if;
					if counter<120 then
						counter:=counter+1;
					else
						counter:=0;
						state:=idle;
						FL_CE_N<='1';
						FL_OE_N<='1';
						FL_WE_N<='0';
					end if;
				when idle=>
					busy<=false;
					if trigger='1' then
						addr:=address;
						busy<=true;
						case cmd is
							when read=>
								state:=reading;
								FL_OE_N<='1';
								FL_CE_N<='1';
								FL_WE_N<='1';
							when write=>
								state:=writing;
								FL_CE_N<='0';
								FL_WE_N<='0';
								FL_OE_N<='1';
						end case;
					end if;
				when reading=>
					FL_ADDR<=addr;
					if counter>=t.read.ACC-t.read.CE then
						FL_CE_N<='0';
					end if;
					if counter>=t.read.ACC-t.read.OE then
						FL_OE_N<='0';
					end if;
					if counter>=t.read.RC-t.read.CE then
						valid<=true;
						dataout<=DQ;
					end if;
					if counter<t.read.RC then
						counter:=counter+1;
					else
						counter:=0;
						FL_WE_N<='0';
						FL_CE_N<='1';
						FL_OE_N<='1';
						state:=idle;
					end if;
			end case;
		end if;
	end process;
end arc;
