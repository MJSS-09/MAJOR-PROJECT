module selector_6to1(
    input wire [2:0] sel,           // Selection signal from counter
    input wire [3:0] data0,         // Path display
    input wire [3:0] data1,         // Price per ticket
    input wire [3:0] data2,         // Quantity
    input wire [3:0] data3,         // Total cost
    input wire [3:0] data4,         // Money inserted
    input wire [3:0] data5,         // Change
    output reg [3:0] out
);

    always @(*) begin
        case (sel)
            3'd0: out = data0;
            3'd1: out = data1;
            3'd2: out = data2;
            3'd3: out = data3;
            3'd4: out = data4;
            3'd5: out = data5;
            default: out = 4'd0;
        endcase
    end

endmodule
