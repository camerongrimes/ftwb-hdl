
module uart_rx
    #(parameter CLKS_PER_BIT)
    (
        input        i_clock,
        input        i_rx,
        output       o_data_available,
        output [7:0] o_data_byte 
    );

    enum int unsigned { IDLE = 0, START = 1, GET = 2, STOP = 3 } state, next_state;

    reg rx_buffer = 1'b1;
    reg rx        = 1'b1;

    reg [15:0] counter = 0;
    reg [2:0]  bit_index = 0;
    reg data_available;
    reg [7:0] data_byte = 0;

    assign o_data_available = data_available;
    assign o_data_byte = data_byte;

    always @(posedge i_clock)
        begin
            rx_buffer = i_rx;
            rx <= rx_buffer;
        end

    always @(posedge i_clock)

        begin

            case (state)

                IDLE:
                    begin
                        data_available <= 0;
                        counter <= 0;
                        bit_index <= 0;

                        // Once rx drops low then start checking for data.
                        if (rx == 0)
                            state <= START;
                        else
                            state <= IDLE;
                    end

                START:
                    begin
                        if (counter == (CLKS_PER_BIT - 1 ) / 2)
                            begin
                                if (rx == 0)
                                    begin
                                        counter <= 0;
                                        state <= GET;
                                    end
                                else
                                    begin
                                        state <= IDLE;
                                    end
                            end
                        else
                            begin
                                counter <= counter + 16'b1;
                                state <= START;
                            end
                    end

                GET:
                    begin
                        if (counter < CLKS_PER_BIT-1)
                            begin
                                counter <= counter + 16'b1;
                                state <= GET;
                            end
                        else
                            begin
                                counter <= 0;
                                data_byte[bit_index] <= rx;

                                $display("Captured bit %0d = %b", bit_index, rx);

                                if (bit_index < 7)
                                    begin
                                        bit_index <= bit_index + 3'b1;
                                        state <= GET;
                                    end
                                else
                                    begin
                                        bit_index <= 0;
                                        state <= STOP;
                                    end
                            end
                    end

                STOP:
                    begin
                        if (counter < CLKS_PER_BIT - 1)
                            begin
                                counter <= counter + 16'b1;
                                state <= STOP;
                            end
                        else
                            begin
                                data_available <= 1;
                                counter <= 0;
                                state <= IDLE;
                            end
                    end

                default:
                    state <= IDLE;

            endcase

        end

endmodule

