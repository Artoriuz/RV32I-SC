library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity datapath is
	port (
		clock : in std_logic;
		reset : in std_logic;
		reg_file_read_address_0 : in std_logic_vector(4 downto 0);
		reg_file_read_address_1 : in std_logic_vector(4 downto 0);
		reg_file_write : in std_logic;
		reg_file_write_address : in std_logic_vector(4 downto 0);
		immediate : in std_logic_vector(31 downto 0);
		PC_operation : in std_logic_vector(2 downto 0);
		ALU_operation : in std_logic_vector(3 downto 0);
		ALU_branch : in std_logic;
		ALU_branch_control : in std_logic_vector(2 downto 0);
		data_format : in std_logic_vector(2 downto 0);
		datamem_write : in std_logic;
		mux0_sel : in std_logic_vector(1 downto 0);
		mux1_sel : in std_logic;
		mux2_sel : in std_logic;
		instruction : out std_logic_vector(31 downto 0);
		debug_instruction_address : out std_logic_vector(31 downto 0);
		debug_regfile_x31_output : out std_logic_vector(31 downto 0);
		debug_regfile_x1_output : out std_logic_vector(31 downto 0);
		debug_regfile_x2_output : out std_logic_vector(31 downto 0);
		debug_ALU_output : out std_logic_vector(31 downto 0);
		debug_ALU_input_0 : out std_logic_vector(31 downto 0);
		debug_ALU_input_1 : out std_logic_vector(31 downto 0)
	);
end entity datapath;

architecture structural of datapath is

	signal PC_output : std_logic_vector(31 downto 0);

	signal mux_0_output : std_logic_vector(31 downto 0);
	signal mux_1_output : std_logic_vector(31 downto 0);

	signal register_file_output_0 : std_logic_vector(31 downto 0);
	signal register_file_output_1 : std_logic_vector(31 downto 0);

	signal ALU_branch_response : std_logic;
	signal ALU_output : std_logic_vector(31 downto 0);

	signal datamem_output : std_logic_vector(31 downto 0);

	signal debug_regfile_x31_output_signal : std_logic_vector(31 downto 0);
	signal debug_regfile_x1_output_signal : std_logic_vector(31 downto 0);
	signal debug_regfile_x2_output_signal : std_logic_vector(31 downto 0);

begin

	program_counter_0 : program_counter port map(immediate, register_file_output_0, PC_operation, ALU_branch_response, clock, reset, PC_output);

	mux_0 : mux_3_1 port map(mux0_sel, ALU_output, datamem_output, std_logic_vector(unsigned(PC_output) + 4), mux_0_output);
	mux_1 : mux_2_1 port map(mux1_sel, register_file_output_1, immediate, mux_1_output);

	register_file_0 : register_file port map(mux_0_output, reg_file_write_address, reg_file_read_address_0, reg_file_read_address_1, reg_file_write, clock, reset, register_file_output_0, register_file_output_1, debug_regfile_x31_output_signal, debug_regfile_x1_output_signal, debug_regfile_x2_output_signal);

	ALU_0 : ALU port map(register_file_output_0, mux_1_output, ALU_operation, ALU_branch, ALU_branch_control, ALU_branch_response, ALU_output);

	progmem_module_0 : progmem_interface port map(PC_output, clock, instruction);
	datamem_module_0 : datamem_interface port map(register_file_output_1, ALU_output, data_format, clock, datamem_write, reset, datamem_output);
	
	debug_instruction_address <= PC_output;
	debug_regfile_x31_output <= debug_regfile_x31_output_signal;
	debug_regfile_x1_output <= debug_regfile_x1_output_signal;
	debug_regfile_x2_output <= debug_regfile_x2_output_signal;
	debug_ALU_output <= ALU_output;
	debug_ALU_input_0 <= register_file_output_0;
	debug_ALU_input_1 <= mux_1_output;

end architecture structural;