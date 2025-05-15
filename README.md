# MIPS16 Processor on Verilator

This project implements a single-cycle 16-bit MIPS processor using SystemVerilog, simulated using Verilator. It features full instruction fetch, decode, execute, memory access, and write-back logic. The design supports core instructions such as `lw`, `slti`, `beq`, `addi`, and `add`.

## Project Structure

```
mips16-processor/
├── src/              # SystemVerilog modules (ALU, control, datapath, etc.)
├── testbench/        # Verilator-compatible C++ testbench and SV wrapper
├── obj_dir/          # Verilator build artifacts (auto-generated, ignored)
├── .gitignore        # Clean build exclusion
├── CMakeLists.txt    # (Optional) CMake build support
```

## How to Run

```bash
# Clean previous builds
rm -rf obj_dir

# Compile with Verilator
verilator \
  --cc \
  src/mips_16.sv \
  src/control.sv \
  src/alu.sv \
  src/alu_control.sv \
  src/register_file.sv \
  src/data_memory.sv \
  src/instr_mem.sv \
  src/jr_control.sv \
  --exe testbench/main.cpp \
  --top-module mips_16 \
  --Mdir obj_dir \
  -Wall --trace \
  -Isrc \
  -CFLAGS "-std=c++17" \
  --Wno-fatal

# [FIX] Replace Verilator’s incorrect link rule (in obj_dir/Makefile):
# Original:
#   Vmips_16: ... $(VM_PREFIX)__ALL.a ...
# Replace with:
#   Vmips_16: ... $(VM_PREFIX)__ALL.o ...

make -C obj_dir -f Vmips_16.mk
./obj_dir/Vmips_16
```

## Output Proof

The processor executes a loop program from ROM (`instr_mem.sv`), summing values until a condition fails:

```
Cycle   0 | PC: 0x0000 | ALU: 0x0000 | R3: 0x0000 | R4: 0x0000
Cycle   0 | PC: 0x0000 | Instr: 0x8030 | ALU: 0x0000
Cycle   4 | PC: 0x0002 | ALU: 0x0001 | R3: 0x0000 | R4: 0x0000
Cycle   6 | PC: 0x0004 | ALU: 0x0000 | R3: 0x0001 | R4: 0x0000
Cycle   8 | PC: 0x0014 | ALU: 0x0000 | R3: 0x0001 | R4: 0x0000
Cycle  10 | PC: 0x0016 | ALU: 0x0000 | R3: 0x0001 | R4: 0x0000
...
```

This confirms:
- Instruction fetches occur every other cycle.
- Register file is updated (`R3`, `R4`).
- ALU operations and control flow (branch/jump) are functional.

## Notes

- **GTKWave is not used** in this version due to local viewer issues, but `.vcd` traces are generated and usable.
- All test output is visible via `printf()` in the C++ testbench, including ALU results and register values.
- The instruction ROM is hardcoded in `instr_mem.sv` and aligned to 2-byte addresses.

## Next Steps

To move toward a full MIPS32 CPU and HFT-aligned hardware modeling:

### 🔧 Implement MIPS32 (32-bit support)

- [ ] Expand all internal signals and bus widths to 32 bits
- [ ] Redesign register file for 32-bit registers
- [ ] Adjust ALU to handle 32-bit operations
- [ ] Extend instruction memory and decoding logic
- [ ] Support more MIPS instructions (e.g., `sw`, `sub`, `and`, `or`, `j`, `jr`, `jal`)

### ⏱ Add Simulation Features

- [ ] Cycle counter and instruction counting
- [ ] Performance metrics: CPI, instruction throughput
- [ ] Memory access latency modeling

### 🧠 Pipeline or HFT Research-Oriented Work

- [ ] Implement a 5-stage pipeline (IF, ID, EX, MEM, WB)
- [ ] Insert hazard detection, forwarding, and stalling logic
- [ ] Simulate an L1 cache or memory-mapped peripheral model
- [ ] Simulate message-passing protocols or test timestamping logic for FPGA HFT interfacing

---

Feel free to clone this project and extend it into a pipelined or 32-bit system to benchmark low-latency processor behavior.
