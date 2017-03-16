library ieee;
use ieee.std_logic_1164.all;

entity four_one_mux is
port(	I :	in std_logic_vector (3 downto 0);		-- 4 bit input
			I_SHIFT_IN : in std_logic;							-- 1 bit input
			sel : in std_logic_vector(1 downto 0);		-- 00:hold; 01: shift left; 10: shift right; 11: load
			clock : in std_logic; 									-- positive level triggering in problem 3
			enable : in std_logic; 								-- 0: don't do anything; 1: shift_reg is enabled
			O : out std_logic_vector(3 downto 0)
);
end four_one_mux;

architecture behavior of four_one_mux is
-- declare internal signals 
begin
--O <= I;	-- Wrong! You must replace it with your implementation.

-- 00:hold; 01: shift left; 10: shift right; 11: load
process(clock, sel, enable) is 


begin

--if clock'event and clock = '1' then						-- rising edge triggered
	if (sel = "00") then O <= I;
	
	elsif (sel = "01") then 
	
	elsif (sel = "10") then 
	
	else  O <= "0000";
	
	end if;
	
--end if;
end process;

end behavior;

