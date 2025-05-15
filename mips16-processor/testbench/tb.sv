`timescale 1ns/1ps

module tb;

    // Exposed signals
    logic clk, reset;
    logic [15:0] pc_out, alu_result;

    // DUT instantiation
    mips_16 dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .alu_result(alu_result)
    );

    initial begin
        $dumpfile("mips_16.vcd");
        $dumpvars(0, tb);

        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule
