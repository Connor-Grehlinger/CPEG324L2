library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity demux is
    generic (x : integer :=1 ;
             y : integer :=1 );
    port(   
            inp :   in std_logic_vector(x-1 downto 0);
            en  :   in std_logic;
            sel :   in std_logic_vector(y-1 downto 0);
            op  :   out std_logic_vector(x*(2**y-1)-1 downto 0)
        );
end entity demux;
 
architecture behavioral of demux is
begin
    process (sel, inp, en) is begin

        if en='1' then
            for i in op'range loop
                if(i>=unsigned(sel)*x and i<unsigned(sel)*x+x) then
                    for j in 0 to x-1 loop
                        op(to_integer(unsigned(sel))*x+j)<=inp(j);
                    end loop;
                else 
                    op(i) <= 'Z';
                end if;
            end loop;
        end if;
    end process;
end architecture;
 
library ieee;
use ieee.std_logic_1164.all;

use work.all;
 
entity testbench is
end entity testbench;
 
architecture dataflow of testbench is
    signal inpone:std_logic_vector(4 downto 0);
    signal sel : std_logic_vector(2 downto 0);
    signal en : std_logic;
    signal outp : std_logic_vector(34 downto 0);
begin

    e1: entity demux generic map(5,3) port map(inpone, en, sel, outp);
    testprocess: process is variable x:integer:=1; variable y:integer:=1;
    begin
    inpone      <= b"00001";
    en          <= '1';
    sel         <= b"000";
    wait for 10 ns;
	assert outp = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ00001" report "bad output value" severity error;
    sel <= b"001";
    wait for 10 ns;
	assert outp = "ZZZZZZZZZZZZZZZZZZZZZZZZZ00001ZZZZZ" report "bad output value" severity error;
    sel <= b"010";
    wait for 10 ns;
	assert outp = "ZZZZZZZZZZZZZZZZZZZZ00001ZZZZZZZZZZ" report "bad output value" severity error;
    sel <= b"011";
    wait for 10 ns;
	assert outp = "ZZZZZZZZZZZZZZZ00001ZZZZZZZZZZZZZZZ" report "bad output value" severity error;
    sel <= b"100";
    wait for 10 ns;
	assert outp = "ZZZZZZZZZZ00001ZZZZZZZZZZZZZZZZZZZZ" report "bad output value" severity error;
    sel <= b"101";
    wait for 10 ns;
	assert outp = "ZZZZZ00001ZZZZZZZZZZZZZZZZZZZZZZZZZ" report "bad output value" severity error;
    sel <= b"110";
    wait for 10 ns;
	assert outp = "00001ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" report "bad output value" severity error;
    wait;
    end process testprocess;
end architecture dataflow;
