library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity progmem_interface is
	port (
		byte_address : in std_logic_vector(31 downto 0);
		clock : in std_logic;
		output_data : out std_logic_vector(31 downto 0)
	);
end entity progmem_interface;

architecture behavioural of progmem_interface is

	signal memory_address : std_logic_vector(31 downto 0) := X"00000000";

begin
	address_acquirement : process (byte_address)
	begin
		memory_address <= std_logic_vector(shift_right(unsigned(byte_address), 2)); --Dividing by 4 since 32 = 4*8
	end process;

	progmem_0 : progmem port map(memory_address(7 downto 0), clock, X"00000000", '0', output_data);

end architecture behavioural;