library ieee;
use ieee.std_logic_1164.all;


-- Design and implement a 4 bit integer adder/subtracter. The inputs are signed!
-- The inputs of the components are two 4-bit signal vectors, and its outputs include a 4
-- bit signed signal vector for result, 1 bit carry(overflow) signal and 1 bit underflow signal

entity add_sub_4 is
port(	In1, In2:	in std_logic_vector (3 downto 0);		-- signed 4 bit input signals 
			Output : out std_logic_vector (3 downto 0);		-- signed 4 bit output signal 
			carry, underflow : out std_logic								-- overflow and underflow signal
);
end add_sub_4;

architecture behavioral of add_sub_4 is
	
	-- declare signals needed here
	signal dummy : std_logic_vector(3 downto 0) := "1000";
	signal temp_carry_sig : std_logic := '0';
	
begin

	-- calculate the result of the addition or subtraction 
	compute_output : process(In1, In2) is
	
	variable temp_carry, In1_neg, In2_neg : std_logic := '0';
	variable temp_In1, temp_In2, twos_comp_In1, twos_comp_In2 : std_logic_vector(3 downto 0) := "0000";
	
	begin 
	
	-- first check if either of the inputs is negative 
	if (In1(3) = '1') then 
		In1_neg := '1';
		for  i in 0 to 2 loop
			temp_In1(i) := not In1(i);			-- negate the bits up to the signed bit
			-- have 0111
			-- need 1000
		end loop;
		
		temp_carry := '1';
		
		for j in 0 to 3 loop						--  add a '1'
			twos_comp_In1(j) := temp_In1(j) xor temp_carry;
			temp_carry := temp_carry and temp_In1(j);
		end loop;
		
	
	elsif (In2(3) = '1') then 
		In2_neg := '1';
			for  i in 0 to 2 loop
			temp_In2(i) := not In2(i);			-- negate the bits up to the signed bit
			-- have 0111
			-- need 1000
		end loop;
		
		temp_carry := '1';
		
		for j in 0 to 3 loop						--  add a '1'
			twos_comp_In2(j) := temp_In2(j) xor temp_carry;
			temp_carry := temp_carry and temp_In2(j);
		end loop;
		
	end if;
	
	temp_carry := '0';			-- reset the temp_carry (carry in) to 0
	
	-- compute the output signal with new values 
	if ((In1_neg = '0') and (In2_neg = '0')) then 			-- both numbers positive (add unmodified inputs)
		for k in 0 to 3 loop
			Output(k) <= In1(k) xor In2(k) xor temp_carry;
			temp_carry := ((In1(k) and temp_carry) or (In2(k) and temp_carry) or (In1(k) and In2(k)));
	
		end loop;
		
	--elsif ((In1_neg = '') and (In2_neg = '')) then 
	
	
	
	
	else 																		-- both numbers negative (add two's complement of inputs)
		for k in 0 to 3 loop
			Output(k) <= twos_comp_In1(k) xor twos_comp_In2(k) xor temp_carry;
			temp_carry := ((twos_comp_In1(k) and temp_carry) or 
			(twos_comp_In2(k) and temp_carry) or (twos_comp_In1(k) and twos_comp_In2(k)));
	
		end loop;
		
	end if;
	
	
	end process compute_output;
	

	
end architecture behavioral;

