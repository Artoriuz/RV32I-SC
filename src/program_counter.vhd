library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    Port( 
            offset : in std_logic_vector (31 downto 0);
            register_input : in std_logic_vector (31 downto 0);
            operation : in std_logic_vector (2 downto 0);        
            ALU_branch_response : in std_logic;
            clock : in std_logic;
            clear : in std_logic;
            instruction_address : out std_logic_vector (31 downto 0)
        );
end program_counter;

architecture behavioral of program_counter is
    signal current_address : std_logic_vector (31 downto 0) := X"00000000";
begin
	process (clock, operation, clear, current_address)
	begin
		if (clear = '1') then 
            current_address <= X"00000000";
		elsif rising_edge(clock) then
			case operation is
                when "000" => --Do nothing
                    current_address <= current_address;
                when "001" => --Normal operation, increment by 4 to go to the next instruction
                    current_address <= std_logic_vector(unsigned(current_address) + 4);
				when "010" => --Branching, must check ALU response before proceeding
                    if (ALU_branch_response = '1') then 
                        current_address <= std_logic_vector(unsigned(current_address) + unsigned(offset)); --positive response, can proceed to the branch
                    else
                        current_address <= std_logic_vector(unsigned(current_address) + 4); --normal operation
                    end if;
                when "011" => --Jump to immediate offset 
                    current_address <= std_logic_vector(unsigned(current_address) + unsigned(offset));
				when "100" => --Jump to address in the register plus offset
					current_address <= std_logic_vector(unsigned(register_input) + unsigned(offset));
                when others => --invalid input, processor stalls
                    current_address <= current_address;
            end case;
		end if;
	instruction_address <= current_address;
	end process;
end behavioral;