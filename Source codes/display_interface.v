module display_interface(
    input wire clk,
    input wire reset,
    input wire [1:0] path,
    input wire [3:0] price,
    input wire [1:0] quantity,
    input wire [4:0] cost,
    input wire [5:0] money_in,
    input wire [5:0] change,
    output wire [2:0] digit_select,
    output wire [6:0] segments
);

    wire [2:0] counter_out;
    wire [3:0] mux_out;
    
    // Instantiate counter
    counter_mod6 u_counter(
        .clk(clk),
        .reset(reset),
        .count(counter_out)
    );
    
    // Instantiate selector
    selector_6to1 u_selector(
        .sel(counter_out),
        .data0({2'b00, path}),
        .data1(price),
        .data2({2'b00, quantity}),
        .data3({3'b000, cost[4:0]}),
        .data4({2'b00, money_in[3:0]}),
        .data5({2'b00, change[3:0]}),
        .out(mux_out)
    );
    
    // Instantiate 7-segment decoder
    decoder_7seg u_decoder(
        .bcd(mux_out),
        .segments(segments)
    );
    
    assign digit_select = counter_out;

endmodule
