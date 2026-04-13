//------------------------------------------------------------------------------
// 4. MODULE 6 COUNTER (for Display Interface)
//------------------------------------------------------------------------------
module counter_mod6(
    input wire clk,
    input wire reset,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'b000;
        else if (count == 3'b101)  // When count reaches 5
            count <= 3'b000;        // Reset to 0
        else
            count <= count + 1;
    end

endmodule
