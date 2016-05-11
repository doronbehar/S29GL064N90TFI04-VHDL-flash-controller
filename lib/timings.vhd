library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package timings is
	type read_time_type is record
		OE:integer;
		RC:integer;
		ACC:integer;
		CE:integer;
	end record;
	type program_time_type is record
		WC:integer;
		CS:integer;
		WP:integer;
		DH:integer;
		CH:integer;
		WPH:integer;
		AH:integer;
		AS:integer;
	end record;
	type time_type is record
		read:read_time_type;
		program:program_time_type;
	end record;
	-- Note: All the following timings are
	-- For a 200[mhz] clock, 20 clocks equal
	-- to 100 [ns] because 1/200=T=5[ns].
	constant t:time_type:=(
		read=>(
			OE=>2,
			CE=>4,
			ACC=>5,
			RC=>20
		),program=>(
			WC=>12,
			CS=>5,
			WP=>5,
			DH=>2,
			CH=>2,
			WPH=>8,
			AH=>10,
			AS=>8
		)
	);
end package;
