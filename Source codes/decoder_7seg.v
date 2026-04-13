module decoder_7seg(
    input wire [3:0] bcd,           // 4-bit BCD input
    output reg [6:0] segments       // 7-segment display output (a-g)
);

    always @(*) begin
        case (bcd)
            4'd0: segments = 7'b1111110;  // 0
            4'd1: segments = 7'b0110000;  // 1
            4'd2: segments = 7'b1101101;  // 2
            4'd3: segments = 7'b1111001;  // 3
            4'd4: segments = 7'b0110011;  // 4
            4'd5: segments = 7'b1011011;  // 5
            4'd6: segments = 7'b1011111;  // 6
            4'd7: segments = 7'b1110000;  // 7
            4'd8: segments = 7'b1111111;  // 8
            4'd9: segments = 7'b1111011;  // 9
            default: segments = 7'b0000000;
        endcase
    end

endmodule
