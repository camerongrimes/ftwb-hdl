
module counter 
(
    input  logic clk,
    input  logic rst_n,
	input  logic [3:0] speed,
    output logic toggle
);

    localparam logic [31:0] clockFreq = 50_000_000;

    logic [31:0] count;

    always_ff @(posedge clk or negedge rst_n) 
        begin
            // If reset stop counting and disable toggle.
            if (!rst_n) 
                begin
                    count <= 0;
                    toggle <= 0;
                end
            else
                begin
                    // Toggle LED if clockFreq / speed value met.
                    if (count == clockFreq / speed) 
                        begin
                            toggle <= ~toggle;
                            count <= 0;
                        end
                    // Otherwise continue the count.
                    else 
                        begin
                            count <= count + 1;
                        end
                end
        end
endmodule
