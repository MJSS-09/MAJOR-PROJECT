module rupees_calculation(
    input wire clk,
    input wire reset,
    input wire five_in,     // 5 rupee note inserted
    input wire ten_in,      // 10 rupee note inserted
    output reg [3:0] five_out,   // Count of 5 rupee notes
    output reg [3:0] ten_out,    // Count of 10 rupee notes
    output reg [5:0] total_out   // Total amount inserted
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            five_out <= 4'd0;
            ten_out <= 4'd0;
            total_out <= 6'd0;
        end else begin
            // Count 5 rupee notes
            if (five_in) begin
                five_out <= five_out + 1;
                total_out <= total_out + 5;
            end
            
            // Count 10 rupee notes
            if (ten_in) begin
                ten_out <= ten_out + 1;
                total_out <= total_out + 10;
            end
        end
    end

endmodule
