library ieee;
use ieee.std_logic_1164.all;

entity andgate is
    port(ina, inb : in std_logic; op : out std_logic);
end entity andgate;
 
architecture behavioral of andgate is
begin
    op <= ina and inb;
end architecture;
 
library ieee;
use ieee.std_logic_1164.all;

use work.all;
 
entity testbench is
end entity testbench;
 
architecture dataflow of testbench is
    signal inpone, inptwo, outp : std_logic;
begin
    portmaps : entity andgate port map(inpone, inptwo, outp);
    testprocess: process is
    begin
        inpone <= '0';
        inptwo <= '0';
        wait for 10 ns;
		assert outp = '0';
		report "bad output value" severity error;
		inpone <= '1';
        inptwo <= '1';
        wait for 10 ns;
   		assert outp = '1';
		report "bad output value" severity error;
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
    end process testprocess;
end architecture dataflow;
