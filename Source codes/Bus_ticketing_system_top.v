module bus_ticketing_system_top_EXT(
    input  clk,
    input  reset,
    input en,
    // Ticket selection inputs
    input  path_1,
    input  path_2,
    input  pri3,
    input  pri4,
    input  pri5,
    input  qua_1,
    input  qua_2,
    // Money input
    input  five_in,
    input  ten_in,
    // Confirmation
    input  finish,
    // Outputs
    output  [2:0] digit_select,
    output  [6:0] segments,
    output  [5:0] ticket_leds,
    output  ticket_issued
);

    // Internal signals
    wire [1:0] path;
    wire [4:0] total_cost;
    wire [1:0] quantity;
    wire [3:0] price_per_ticket;
    wire [5:0] money_inserted;
    wire [5:0] change_out;
    
    
    //clk gating
    wire gated_clk;
    flipflop_based_clk s1( en,clk,gated_clk);
    
    // Instantiate ticket selection module
    ticket_selection u_selection(
        .clk(gated_clk),
        .reset(reset),
        .path_1(path_1),
        .path_2(path_2),
        .pri3(pri3),
        .pri4(pri4),
        .pri5(pri5),
        .qua_1(qua_1),
        .qua_2(qua_2),
        .PATH(path),
        .COST(total_cost),
        .PIN(quantity),
        .PRI(price_per_ticket)
    );
    
    // Instantiate rupees calculation module
    rupees_calculation u_calculation(
        .clk(gated_clk),
        .reset(reset),
        .five_in(five_in),
        .ten_in(ten_in),
        .five_out(),  // Not connected in top level
        .ten_out(),   // Not connected in top level
        .total_out(money_inserted)
    );
    
    // Instantiate return processing module
    return_processing u_return(
        .clk(gated_clk),
        .reset(reset),
        .finish(finish),
        .path_in(path),
        .pri_in(price_per_ticket),
        .cost_in(total_cost),
        .coin_in(money_inserted),
        .change(change_out),
        .valid_tic(ticket_leds),
        .disp_tic(ticket_issued)
    );
    
    // Instantiate display interface module
    display_interface u_display(
        .clk(gated_clk),
        .reset(reset),
        .path(path),
        .price(price_per_ticket),
        .quantity(quantity),
        .cost(total_cost),
        .money_in(money_inserted),
        .change(change_out),
        .digit_select(digit_select),
        .segments(segments)
    );

endmodule
