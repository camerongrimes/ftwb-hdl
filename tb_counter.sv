`timescale 10ns/10ps

module tb_counter;

    logic clk;
    logic rst_n;
    logic [3:0] speed;
    logic toggle;

    // Instantiate the counter
    counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .speed(speed),
        .toggle(toggle)
    );

    // Clock generation: 50 MHz, 20ns period.
    always #1 clk = ~clk;

    initial begin
        $dumpfile("counter.vcd");  // optional for waveform viewing in GTKWave
        $dumpvars(0, tb_counter);

        // Initialize signals
        clk = 0;
        rst_n = 0;

        // Reset pulse
        #10 rst_n = 1;

        #10 speed = 15;

        // Let the simulation run for some time
        #2_000_000_000

        $finish;
    end

endmodule

