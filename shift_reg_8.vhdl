library ieee;
use ieee.std_logic_1164.all;



entity shift_reg_8 is
port(	I_8bit :	in std_logic_vector (7 downto 0);
		SHIFT_LEFT_INPUT_8BIT: in std_logic;				-- replaces the newly vacant rightmost bit
		SHIFT_RIGHT_INPUT_8BIT: in std_logic;				-- replaces the newly vacant leftmost bit
		sel_8bit : in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock_8bit : in std_logic;							-- positive level triggering in problem 3
		enable_8bit : in std_logic;							 -- 0: don't do anything; 1: shift_reg is enabled
		O_8bit : out std_logic_vector(7 downto 0)
);
end shift_reg_8;

architecture structural of shift_reg_8 is

	component shift_reg is 
	port(	I:	in std_logic_vector (3 downto 0);
		SHIFT_LEFT_INPUT: in std_logic;				-- replaces the newly vacant rightmost bit
		SHIFT_RIGHT_INPUT: in std_logic;				-- replaces the newly vacant leftmost bit
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic;							-- positive level triggering in problem 3
		enable:		in std_logic;							 -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0);
		I_shift_out : out std_logic);
	end component shift_reg;
	
	
	--signal left_reg_content : std_logic_vector(3 downto 0) := I_8bit(7 downto 4);
	--signal right_reg_content : std_logic_vector(3 downto 0) := I_8bit(3 downto 0);
	
	signal register_connection_left_in_right_out : std_logic;
	
	signal register_connection_right_in_left_out : std_logic;
	
	signal left_reg_output : std_logic_vector(3 downto 0);
	
	signal right_reg_output : std_logic_vector(3 downto 0);
	
	signal reg_8bit_content : std_logic_vector(7 downto 0);
	
	
begin

	left_reg : shift_reg port map(I => I_8bit(7 downto 4), SHIFT_LEFT_INPUT => register_connection_left_in_right_out,
	SHIFT_RIGHT_INPUT => SHIFT_RIGHT_INPUT_8BIT, sel => sel_8bit, clock => clock_8bit, enable => enable_8bit, 
	O => left_reg_output, I_shift_out => register_connection_right_in_left_out);
	
	right_reg : shift_reg port map(I => I_8bit(3 downto 0), SHIFT_LEFT_INPUT => SHIFT_LEFT_INPUT_8BIT,
	SHIFT_RIGHT_INPUT => register_connection_right_in_left_out, sel => sel_8bit, clock => clock_8bit, enable => enable_8bit, 
	O => right_reg_output, I_shift_out => register_connection_left_in_right_out);
	
	reg_8bit_content(7) <= left_reg_output(3);
	reg_8bit_content(6) <= left_reg_output(2);
	reg_8bit_content(5) <= left_reg_output(1);
	reg_8bit_content(4) <= left_reg_output(0);
	reg_8bit_content(3) <= right_reg_output(3);
	reg_8bit_content(2) <= right_reg_output(2);
	reg_8bit_content(1) <= right_reg_output(1);
	reg_8bit_content(0) <= right_reg_output(0);
	
	
	O_8bit <= reg_8bit_content;
	
	
end architecture structural;

