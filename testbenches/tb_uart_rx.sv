`timescale 1ns / 1ps

module tb_uart_rx;

    // Parameters
    parameter CLKS_PER_BIT = 5208;

    // Testbench signals
    reg i_clock = 0;
    reg i_rx = 1;  // Idle line is high in UART
    wire o_data_available;
    wire [7:0] o_data_byte;

    // Clock generation
    always #10 i_clock = ~i_clock; // 100 MHz clock (10 ns period)

    // Instantiate the UART receiver
    uart_rx #(CLKS_PER_BIT) uut (
        .i_clock(i_clock),
        .i_rx(i_rx),
        .o_data_available(o_data_available),
        .o_data_byte(o_data_byte)
    );

    // Task to send a UART byte
    task send_uart_byte(input [7:0] data);
        integer i;
        begin
            // Start bit
            i_rx = 0;
            #(CLKS_PER_BIT * 20);  // hold for 1 bit time

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                i_rx = data[i];
                #(CLKS_PER_BIT * 20);
            end

            // Stop bit
            i_rx = 1;
            #(CLKS_PER_BIT * 20);
        end
    endtask

    // Test sequence
    initial begin
        $display("Starting UART RX Testbench...");
        $dumpfile("tb_uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        // Wait some time before starting transmission
        #(CLKS_PER_BIT * 2000);

        // Send byte 0xAA (10101010)
        send_uart_byte(8'hAA);

        // Wait to observe result
        #(CLKS_PER_BIT * 3000);

        if (o_data_available && o_data_byte == 8'haa)
            $display("PASS: Received byte = 0x%02X", o_data_byte);
        else
            $display("FAIL: Expected 0xaa, got 0x%02X", o_data_byte);

        
                // Send byte 0xAA (10101010)
        send_uart_byte(8'hBB);

        // Wait to observe result
        #(CLKS_PER_BIT * 3000);

        if (o_data_available && o_data_byte == 8'hbb)
            $display("PASS: Received byte = 0x%02X", o_data_byte);
        else
            $display("FAIL: Expected 0xbb, got 0x%02X", o_data_byte);


        #1000000
        

        $finish;
    end

endmodule
