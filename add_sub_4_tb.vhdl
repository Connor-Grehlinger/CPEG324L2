library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity add_sub_4_tb is
end add_sub_4_tb;

architecture behavioral of add_sub_4_tb is
--  Declaration of the component that will be instantiated.
component add_sub_4
port(	In1, In2:	in std_logic_vector (3 downto 0);		-- signed 4 bit input 
			Output : out std_logic_vector(3 downto 0);			-- signed 4 bit output
			Carry, Underflow : out std_logic								-- overflow and underflow signal
);
end component add_sub_4;

-- Internal signals (wires for connecting components)
signal in1, in2, output : std_logic_vector(3 downto 0);
signal carry, underflow : std_logic;

begin
--  Component instantiation.
add_sub_4_0: add_sub_4 port map (In1 => in1, In2 => in2, Output => output, Carry => carry, Underflow => underflow); 

-- Testing process
test_bench_add_sub_4 : process  is
--begin

type pattern_type is record
--  The inputs and outputs of the shift_reg.
in1, in2, output : std_logic_vector (3 downto 0);
carry, underflow : std_logic;

end record;

--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
----------- all shift register functionality -----------
-- ("in1", '"n2", "output", 'carry', 'underflow')
(--("1000", "0001", "1001", '0', '0'), 
--("0011", "0100", "0111", '0', '0'), 
("0001", "0001", "0010", '0', '0'), 
--("0001", "0001", "0010", '0', '0'), 
--("0001", "0001", "0010", '0', '0'), 
--("0001", "0001", "0010", '0', '0'), 
--("1110", "1101", "0101", '0', '0'), 			-- pos 5
--("1110", "1101", "1011", '0', '0'), 			-- neg 5
("0010", "0010", "0100", '0', '0'));

variable test_result : std_logic_vector(3 downto 0) := "0000";

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
in1 <= patterns(n).in1;
in2 <= patterns(n).in2;
carry <= patterns(n).carry;
underflow <= patterns(n).underflow;

--clk <= patterns(n).clock, '1' after 10 ns;--, '0' after 20 ns, '1' after 30 ns;	-- should produce 1 rising edge
--output <= patterns(n).output;


--  Wait for the results.
wait for 20 ns;

--test_result := output;
--for i in 0 to test_result'LENGTH loop
--report "test_result("&integer'image(i)&") value is" &  std_logic'image(test_result(i));
--end loop;
	   
--  Check the outputs.
assert output = patterns(n).output report "Error: bad output value" severity error;

end loop;

assert false report "End of 4-bit integer adder/subtracter test. Passed if no errors displayed" severity note;

--  Wait forever; this will finish the simulation.
wait;

end process test_bench_add_sub_4;
-- End of testing process

end architecture;
-- end of bavioral test bench 