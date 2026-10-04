# RV32I RISC-V Processor

This project is a modular **32-bit single-cycle RISC-V processor** written in SystemVerilog.

The current core is based on the RV32I instruction set and uses a **Harvard-style architecture**, with separate instruction memory and data memory. The processor is built from independently verified RTL modules including:

- Program Counter
- Instruction Memory
- Decoder / Control Unit
- 32 × 32-bit Register File
- Immediate Generator
- ALU
- Branch Unit
- Next-PC Logic
- Data Memory
- Writeback Logic

The current datapath supports arithmetic, logical, branch, jump, load/store, and upper-immediate operations including instructions such as ADD, SUB, ADDI, LW, SW, BEQ, JAL, JALR, LUI, and AUIPC.

The processor has been integrated into a complete single-cycle core and has successfully executed a basic RISC-V program end-to-end.

## Planned Extensions

The CPU is intended to become a platform for experimenting with custom hardware extensions and accelerator integration.

### XiCRC Extension

A previously developed XiCRC accelerator will be integrated as a **custom RISC-V instruction extension**. The decoder will recognise custom CRC instructions and route register operands through the CRC hardware before writing the result back into the register file.

Planned support includes CRC byte, halfword, and word operations, as well as comparison between software CRC execution and dedicated hardware acceleration.

### INT8 Neural-Network Accelerator

A previously developed INT8 neural-network accelerator will also be integrated with the processor.

The accelerator contains INT8 multiplication, INT32 accumulation, Processing Elements, systolic arrays, matrix-vector operations, bias addition, ReLU, requantization, buffers, and control logic.

The initial integration is planned through **memory-mapped I/O or a dedicated accelerator interface**, allowing the RISC-V core to configure the accelerator, supply data, start computation, and read results.

### Design-for-Test

The processor will also be used to explore **DFT and semiconductor test concepts**.

Possible future features include:

- Memory Built-In Self-Test (MBIST)
- March memory test algorithms
- Test-mode memory access
- Fault injection
- Internal observability and controllability
- Debug/test registers
- Additional Built-In Self-Test structures

The longer-term goal is to evolve the project from a basic single-cycle CPU into a platform for studying processor architecture, custom ISA extensions, hardware accelerators, and testable digital system design.