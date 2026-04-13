module return_processing(
    input wire clk,
    input wire reset,
    input wire finish,          // Confirmation button
    input wire [1:0] path_in,   // Selected path
    input wire [3:0] pri_in,    // Price per ticket
    input wire [4:0] cost_in,   // Total cost
    input wire [5:0] coin_in,   // Total money inserted
    output reg [5:0] change,    // Change to return
    output reg [5:0] valid_tic, // Ticket type indicators (6 LEDs)
    output reg disp_tic         // Display ticket indicator
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            change <= 6'd0;
            valid_tic <= 6'b000000;
            disp_tic <= 1'b0;
        end else if (finish) begin
            // Check if sufficient payment
            if (coin_in >= cost_in) begin
                // Calculate change
                change <= coin_in - cost_in;
                disp_tic <= 1'b1;
                
                // Determine ticket type and light corresponding LED
                case ({path_in, pri_in})
                    {2'b01, 4'd3}:  valid_tic <= 6'b000001; // Route 1, 3 rupees
                    {2'b01, 4'd5}:  valid_tic <= 6'b000010; // Route 1, 5 rupees
                    {2'b01, 4'd10}: valid_tic <= 6'b000100; // Route 1, 10 rupees
                    {2'b10, 4'd3}:  valid_tic <= 6'b001000; // Route 2, 3 rupees
                    {2'b10, 4'd5}:  valid_tic <= 6'b010000; // Route 2, 5 rupees
                    {2'b10, 4'd10}: valid_tic <= 6'b100000; // Route 2, 10 rupees
                    default:        valid_tic <= 6'b000000;
                endcase
            end else begin
                change <= 6'd0;
                valid_tic <= 6'b000000;
                disp_tic <= 1'b0;
            end
        end
    end

endmodule
