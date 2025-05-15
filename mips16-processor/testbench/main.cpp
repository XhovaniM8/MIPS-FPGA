#include "Vmips_16.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vmips_16__Syms.h" 

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    Vmips_16 *dut = new Vmips_16;

    VerilatedVcdC *tfp = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 99);
    tfp->open("mips_16.vcd");

    dut->clk = 0;
    dut->reset = 1;

    for (int i = 0; i < 200; ++i)
    {
        if (i == 4)
            dut->reset = 0;

        dut->clk ^= 1;
        dut->eval();
        tfp->dump(i);

        // Rising edge — print state every full clock cycle
        if (dut->clk)
        {
            printf("Cycle %3d | PC: 0x%04x | ALU: 0x%04x | R3: 0x%04x | R4: 0x%04x\n",
                   i,
                   dut->pc_out,
                   dut->alu_result,
                   dut->rootp->mips_16__DOT__reg_file__DOT__reg_array[3],
                   dut->rootp->mips_16__DOT__reg_file__DOT__reg_array[4]);
        }

        printf("Cycle %3d | PC: 0x%04x | Instr: 0x%04x | ALU: 0x%04x\n",
               i,
               dut->pc_out,
               dut->instruction,
               dut->alu_result);
    }

    tfp->close();
    delete dut;
    return 0;
}
