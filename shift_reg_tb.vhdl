library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_tb is
end shift_reg_tb;

architecture behavioral of shift_reg_tb is
--  Declaration of the component that will be instantiated.
component shift_reg
port(	I:	in std_logic_vector (3 downto 0);
		SHIFT_LEFT_INPUT: in std_logic;				-- replaces the newly vacant rightmost bit
		SHIFT_RIGHT_INPUT: in std_logic;				-- replaces the newly vacant leftmost bit
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic;							-- positive level triggering in problem 3
		enable:		in std_logic;							 -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0)
);
end component;

-- Internal signals (wires for connecting components)
signal i, o : std_logic_vector(3 downto 0);
signal left_shift_in, right_shift_in : std_logic;
signal clk : std_logic;
signal enable : std_logic;
signal sel : std_logic_vector(1 downto 0);

begin
--  Component instantiation.
shift_reg_0: shift_reg port map (I => i, SHIFT_LEFT_INPUT => left_shift_in, 
SHIFT_RIGHT_INPUT => right_shift_in, sel => sel, clock => clk, enable => enable, O => o);

--Non-explicit port mapping example (see if this works)
--shift_reg_0: shift_reg port map (i, left_shift_in, right_shift_in, sel, clk, enable, o);


-- Testing process
test_bench : process  is
--begin


type pattern_type is record
--  The inputs of the shift_reg.
i: std_logic_vector (3 downto 0);
left_shift_in, right_shift_in, clock, enable: std_logic;
sel: std_logic_vector(1 downto 0);

--  The expected outputs of the shift_reg.
o: std_logic_vector (3 downto 0);
end record;

--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
----------- all shift register functionality -----------
-- ("input", 'lefit in', 'right in', 'clock', 'enable', "select", "output")
(("0101", '0', '1', '0', '1', "00", "0101"), 
("0001", '0', '1', '0', '1', "01", "0010"), 	-- bad
("0101", '1', '1', '0', '1', "01", "1011"), 	-- bad
("0101", '0', '0', '0', '1', "10", "0010"),	-- bad	
("0101", '0', '1', '0', '1', "10", "1010"),	-- bad
----------- hold and load only -----------
("1111", '0', '1', '0', '1', "00", "1111"), 
("1111", '0', '1', '0', '0', "00", "1111"),
("1111", '0', '1', '0', '0', "11", "1111"),
("1111", '1', '0', '0', '1', "11", "0000"));


--variable test_result : std_logic_vector(3 downto 0) := "0000";

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
--wait for 40 ns;
wait for 20 ns;

--test_result := o;
--for i in 0 to test_result'LENGTH loop
--report "test_result("&integer'image(i)&") value is" &  std_logic'image(test_result(i));
--end loop;
	   
--  Check the outputs.
assert o = patterns(n).o report "Error: bad output value" severity error;
end loop;

assert false report "End of test. Passed if no errors displayed" severity note;

--  Wait forever; this will finish the simulation.
wait;

end process test_bench;
-- End of testing process

end behavioral;
-- end of bavioral test bench 