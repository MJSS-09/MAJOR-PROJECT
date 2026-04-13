module ticket_selection(
    input wire clk,
    input wire reset,
    input wire transaction_done, // Clear after transaction
    input wire path_1,      // Route 1 selection
    input wire path_2,      // Route 2 selection
    input wire pri3,        // Price option 3 rupees
    input wire pri4,        // Price option 5 rupees
    input wire pri5,        // Price option 10 rupees 
    input wire qua_1,       // Quantity: 1 ticket
    input wire qua_2,       // Quantity: 2 tickets
    output reg [1:0] PATH,  // Selected path output
    output reg [4:0] COST,  // Total cost output
    output reg [1:0] PIN,   // Quantity output
    output reg [3:0] PRI    // Price per ticket output
);

    always @(posedge clk or posedge reset) begin
        if (reset || transaction_done) begin
            PATH <= 2'b00;
            COST <= 5'b00000;
            PIN <= 2'b00;
            PRI <= 4'b0000;
        end else begin
            // Path selection - latch when pressed
            if (path_1)
                PATH <= 2'b01;  // Route 1
            else if (path_2)
                PATH <= 2'b10;  // Route 2
            // Hold previous value if neither pressed
            
            // Price selection - latch when pressed
            if (pri3)
                PRI <= 4'd3;
            else if (pri4)
                PRI <= 4'd5;
            else if (pri5)
                PRI <= 4'd10;
            // Hold previous value if none pressed
            
            // Quantity selection - latch when pressed
            if (qua_1)
                PIN <= 2'b01;   // 1 ticket
            else if (qua_2)
                PIN <= 2'b10;   // 2 tickets
            // Hold previous value if neither pressed
            
            // Calculate total cost based on current PRI and PIN
            if (PIN == 2'b01)
                COST <= PRI;
            else if (PIN == 2'b10)
                COST <= PRI << 1;  // PRI * 2
            else
                COST <= 5'd0;
        end
    end

endmodule
