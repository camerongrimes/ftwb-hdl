module counter (
    input  logic clk,
    input  logic rst_n,
    output logic [31:0] count,
    output logic toggle
);

    reg [31:0] clockFreq = 5;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 4'd0;
        else
            count <= count + 1;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (count == clockFreq) begin
            if(toggle == 1)
                toggle <= 0;
            else
                toggle <= 1;

            count <= 0;
        end
    end

endmodule
