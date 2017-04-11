library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_8_tb is
end shift_reg_8_tb;

architecture behavioral of shift_reg_8_tb is
--  Declaration of the component that will be instantiated.
component shift_reg_8
port(	I_8bit :	in std_logic_vector (7 downto 0);
		SHIFT_LEFT_INPUT_8BIT: in std_logic;				-- replaces the newly vacant rightmost bit
		SHIFT_RIGHT_INPUT_8BIT: in std_logic;				-- replaces the newly vacant leftmost bit
		sel_8bit : in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock_8bit : in std_logic;							-- positive level triggering in problem 3
		enable_8bit : in std_logic;							 -- 0: don't do anything; 1: shift_reg is enabled
		O_8bit : out std_logic_vector(7 downto 0)
);
end component shift_reg_8;

-- Internal signals (wires for connecting components)
signal i, o : std_logic_vector(7 downto 0);
signal left_shift_in, right_shift_in : std_logic;
signal clk : std_logic;
signal enable : std_logic;
signal sel : std_logic_vector(1 downto 0);

begin
--  Component instantiation.
shift_reg_8_0: shift_reg_8 port map (I_8bit => i, SHIFT_LEFT_INPUT_8BIT => left_shift_in, 
SHIFT_RIGHT_INPUT_8BIT => right_shift_in, sel_8bit => sel, clock_8bit => clk, enable_8bit => enable, O_8bit => o);

-- Testing process
test_bench_8bit : process  is
--begin


type pattern_type is record
--  The inputs of the shift_reg.
i: std_logic_vector (7 downto 0);
left_shift_in, right_shift_in, clock, enable: std_logic;
sel: std_logic_vector(1 downto 0);

--  The expected outputs of the shift_reg.
o: std_logic_vector (7 downto 0);
end record;

--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
----------- all shift register functionality -----------
-- ("input", 'left in', 'right in', 'clock', 'enable', "select", "output")
(("01010101", '0', '1', '0', '1', "00", "01010101"), 
("00010000", '0', '1', '0', '1', "01", "00100000"), 
("01010010", '1', '1', '0', '1', "01", "10100101"), 	
("01010010", '0', '0', '0', '1', "10", "00101001"),	
("01010000", '0', '1', '0', '1', "10", "10101000"),	
("10000000", '1', '1', '0', '1', "10", "11000000"),
("10000000", '1', '1', '0', '1', "01", "00000001"),
----------- hold and load only -----------
("11111111", '0', '1', '0', '1', "00", "11111111"), 
("11110101", '0', '1', '0', '0', "00", "11110101"),		-- bad
("11110000", '0', '1', '0', '0', "11", "11110000"),		--bad
("11111111", '1', '0', '0', '1', "11", "00000000"));


--variable test_result : std_logic_vector(7 downto 0) := "00000000";

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i <= patterns(n).i;
left_shift_in <= patterns(n).left_shift_in;
right_shift_in <= patterns(n).right_shift_in;
sel <= patterns(n).sel;
clk <= patterns(n).clock, '1' after 10 ns;--, '0' after 20 ns, '1' after 30 ns;	-- should produce 1 rising edge
enable <= patterns(n).enable;


--  Wait for the results.
wait for 20 ns;

--test_result := o;
--for i in 0 to test_result'LENGTH loop
--report "test_result("&integer'image(i)&") value is" &  std_logic'image(test_result(i));
--end loop;
	   
--  Check the outputs.
assert o = patterns(n).o report "Error: bad output value" severity error;

end loop;

assert false report "End of 8 bit shift register test. Passed if no errors displayed" severity note;

--  Wait forever; this will finish the simulation.
wait;

end process test_bench_8bit;
-- End of testing process

end architecture;
-- end of bavioral test bench 