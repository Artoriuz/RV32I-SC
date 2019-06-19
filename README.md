# RV32I-SC
This repository contains an extremely simple implementation of the RV32I ISA strongly inspired by [David Patterson's and John Hennessy's Computer Organization and Design RISC-V Edition.](https://www.amazon.com/dp/0128122757) The project is entirely academic, it does not aim to be competitive against complex implementations. The rationale behind it was basically learning about RISC-V, the ISA, and processor design in general. If you want to deploy a RISC-V core, [I strongly recommend using a fully-featured and tested core instead.](https://github.com/riscv/riscv-wiki/wiki/RISC-V-Cores-and-SoCs)  

## Design Choices
- Entirely written in VHDL.
- Requires 5 clock cycles to complete any instruction.
- Not designed with multiple RISC-V harts in mind, the memory model is relaxed.
- FENCE, FENCE.I and CSR instructions are not implemented.
- Unimplemented instructions (including extensions) will be executed as NOPs.

## User Guide
- The repository contains a Quartus II 13.0sp1 project file.
- The repository contains Altera memory files generated for the Cyclone IV GX FPGA. If you wish to use it on a different Altera FPGA you'll have to use the Megawizard plug-in manager to reconfigure them.
- The program memory comes with a simple fibonacci program for quick debugging.
- Outputs that start with "debug" are not mandatory and only exist to make debugging easier.

## Inconveniences
- There's currently no simple way of porting standard RISC-V assembly code to the memory files used by Altera. Which means programmers need to write the machine code themselves.
- The processor does not have any output. Use the debug output or load to memory to move data out of it. 

## To-do List
- Implement a classic 5-stage RISC pipeline.
- Evaluate the implementation of extensions.
- Evaluate switching from RV32I to RV64I.
- Better separate GPIO addresses.
- Write a program that assembles standard RISC-V assembly into an Altera memory file.

## Simplified Schematic
![Schematic](https://raw.githubusercontent.com/Artoriuz/RV32I-SC/master/images/schematic.png)
