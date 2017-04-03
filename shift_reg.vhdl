library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
port(	I:	in std_logic_vector (3 downto 0);
		SHIFT_LEFT_INPUT: in std_logic;				-- replaces the newly vacant rightmost bit
		SHIFT_RIGHT_INPUT: in std_logic;				-- replaces the newly vacant leftmost bit
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic;							-- positive level triggering in problem 3
		enable:		in std_logic;							 -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0);
		I_shift_out : out std_logic
);
end shift_reg;

architecture behavioral of shift_reg is
	
	signal register_content : std_logic_vector(3 downto 0) := I;
	signal overflow : std_logic;
	
begin

	-- shift register must be rising edge triggered
	compute_output : process(clock, enable) is
	
	begin 											-- process body
	if (enable = '1') then 					-- shift register is enabled
		if rising_edge(clock) then 		-- rising edge of clock signal
			if sel = "00" then register_content <= I;
			overflow <= 'U';
			
			elsif sel = "01" then 
			overflow <= I(3);
			--I_shift_out <= I(3);
			register_content(3) <= I(2);
			register_content(2) <= I(1);
			register_content(1) <= I(0);
			register_content(0) <= SHIFT_LEFT_INPUT;
			
			-- may have to add check to make sure that the input is initialized

			elsif sel = "10" then 
			overflow <= I(0);
			--I_shift_out <= I(0);
			register_content(0) <= I(1);
			register_content(1) <= I(2);
			register_content(2) <= I(3);
			register_content(3) <= SHIFT_RIGHT_INPUT;
			
			else 
			register_content <= "0000";
			overflow <= 'U';
			
			end if;
		end if;
	end if;
	
	end process compute_output;
	
	O <= register_content;					-- CSA for output
	I_shift_out <= overflow;
	
end architecture behavioral;

