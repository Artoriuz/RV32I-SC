library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity riscv_microcontroller is
	port (
		clock : in std_logic;
		reset : in std_logic;
		debug_controller_state : out std_logic_vector(2 downto 0);
		debug_pc_output : out std_logic_vector(31 downto 0);
		debug_regfile_x31_output : out std_logic_vector(31 downto 0);
		debug_regfile_x1_output : out std_logic_vector(31 downto 0);
		debug_regfile_x2_output : out std_logic_vector(31 downto 0);
		debug_ALU_output : out std_logic_vector(31 downto 0);
		debug_regfile_write : out std_logic;
		debug_ALU_input_0 : out std_logic_vector(31 downto 0);
		debug_ALU_input_1 : out std_logic_vector(31 downto 0);
		debug_reg_file_read_address_0 : out std_logic_vector(4 downto 0);
		debug_reg_file_read_address_1 : out std_logic_vector(4 downto 0);
		debug_mux0_sel : out std_logic_vector(1 downto 0);
		debug_immediate : out std_logic_vector(31 downto 0);
		debug_ALU_operation : out std_logic_vector(3 downto 0)

	);
end entity riscv_microcontroller;

architecture structural of riscv_microcontroller is
	signal reg_file_read_address_0 : std_logic_vector(4 downto 0);
	signal reg_file_read_address_1 : std_logic_vector(4 downto 0);
	signal reg_file_write : std_logic;
	signal reg_file_write_address : std_logic_vector(4 downto 0);
	signal immediate : std_logic_vector(31 downto 0);
	signal PC_operation : std_logic_vector(2 downto 0);
	signal ALU_operation : std_logic_vector(3 downto 0);
	signal ALU_branch : std_logic;
	signal ALU_branch_control : std_logic_vector(2 downto 0);
	signal data_format : std_logic_vector(2 downto 0);
	signal datamem_write : std_logic;
	signal mux0_sel : std_logic_vector(1 downto 0);
	signal mux1_sel : std_logic;
	signal mux2_sel : std_logic;
	signal instruction : std_logic_vector(31 downto 0);

begin

	controller_0 : controller port map(clock, reset, instruction, reg_file_read_address_0, reg_file_read_address_1, reg_file_write, reg_file_write_address, immediate, PC_operation, ALU_operation, ALU_branch, ALU_branch_control, data_format, datamem_write, mux0_sel, mux1_sel, debug_controller_state);
	datapath_0 : datapath port map(clock, reset, reg_file_read_address_0, reg_file_read_address_1, reg_file_write, reg_file_write_address, immediate, PC_operation, ALU_operation, ALU_branch, ALU_branch_control, data_format, datamem_write, mux0_sel, mux1_sel, mux2_sel, instruction, debug_pc_output, debug_regfile_x31_output, debug_regfile_x1_output, debug_regfile_x2_output, debug_ALU_output, debug_ALU_input_0, debug_ALU_input_1);

	debug_regfile_write <= reg_file_write;
	debug_reg_file_read_address_0 <= reg_file_read_address_0;
	debug_reg_file_read_address_1 <= reg_file_read_address_1;
	debug_mux0_sel <= mux0_sel;
	debug_immediate <= immediate;
	debug_ALU_operation <= ALU_operation;

end architecture structural;