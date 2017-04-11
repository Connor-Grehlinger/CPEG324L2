library ieee;
use ieee.std_logic_1164.all;

entity mux is
    port(   ina, inb, inc, ind :   in std_logic_vector;
            sel : in std_logic_vector(1 downto 0);
            op  :   out std_logic_vector
        );
end entity mux;
 
architecture behavioral of mux is
begin
    -- op <= ina and inb;
    op <=
        ina when sel = "00" else
        inb when sel = "01" else
        inc when sel = "10" else
        ind when sel = "11" else "00";
    
end architecture;
 
library ieee;
use ieee.std_logic_1164.all;

use work.all;
 
entity testbench is
end entity testbench;
 
architecture dataflow of testbench is
    signal inpone, inptwo, inpthree, inpfour:std_logic_vector(7 downto 0);
    signal sel : std_logic_vector(1 downto 0);
    signal outp : std_logic_vector(7 downto 0);
begin
    portmaps : entity mux port map(inpone, inptwo, inpthree, inpfour, sel, outp);
    testprocess: process is
    begin
        inpone      <= x"01";
        inptwo      <= x"02";
        inpthree    <= x"03";
        inpfour     <= x"04";
        sel         <= "00";
        wait for 10 ns;
		assert outp = inpone report "bad output value" severity error;
        sel <= "01";
        wait for 10 ns;
   		assert outp = inptwo report "bad output value" severity error;
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
    end process testprocess;
end architecture dataflow;
