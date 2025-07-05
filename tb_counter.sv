`timescale 1ns/1ps

module tb_counter;

    logic clk;
    logic rst_n;
    logic [32:0] count;
    logic toggle;

    // Instantiate the counter
    counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .count(count),
        .toggle(toggle)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("counter.vcd");  // optional for waveform viewing in GTKWave
        $dumpvars(0, tb_counter);

        // Initialize signals
        clk = 0;
        rst_n = 0;

        // Reset pulse
        #10 rst_n = 1;

        // Let the simulation run for some time
        #200

        $finish;
    end

endmodule

