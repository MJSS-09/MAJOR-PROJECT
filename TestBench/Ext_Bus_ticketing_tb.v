module bus_ticketing_system_tb_EXT;

    reg gated_clk;
    reg en;
    reg reset;
    reg path_1, path_2;
    reg pri3, pri4, pri5;
    reg qua_1, qua_2;
    reg five_in, ten_in;
    reg finish;
    
    wire [2:0] digit_select;
    wire [6:0] segments;
    wire [5:0] ticket_leds;
    wire ticket_issued;
    
   
    // Instantiate DUT
    bus_ticketing_system_top_EXT dut(
        .clk(gated_clk),
        .reset(reset),
        .path_1(path_1),
        .path_2(path_2),
        .pri3(pri3),
        .pri4(pri4),
        .pri5(pri5),
        .qua_1(qua_1),
        .qua_2(qua_2),
        .five_in(five_in),
        .ten_in(ten_in),
        .finish(finish),
        .digit_select(digit_select),
        .segments(segments),
        .ticket_leds(ticket_leds),
        .ticket_issued(ticket_issued) );
    
    // Clock generation
    initial begin
        gated_clk = 0;
        forever #5 gated_clk = ~gated_clk;
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        en=0;
        path_1 = 0; path_2 = 0;
        pri3 = 0; pri4 = 0; pri5 = 0;
        qua_1 = 0; qua_2 = 0;
        five_in = 0; ten_in = 0;
        finish = 0;
        
        #20 reset = 0;
        en=1;
        
        // Test Case 1: Route 1, 10 rupees, 2 tickets (Total: 20 rupees)
        #10 path_1 = 1; pri5 = 1; qua_2 = 1;
        #20 path_1 = 0; pri5 = 0; qua_2 = 0;
        
        // Insert 2x 10 rupee notes
        #10 ten_in = 1;
        #10 ten_in = 0;
        #10 ten_in = 1;
        #10 ten_in = 0;
        
        // Finish transaction
        #10 finish = 1;
        #10 finish = 0;
        
        #50;
        
        // Test Case 2: Route 2, 5 rupees, 1 ticket, pay 10 rupees (Change: 5)
        #10 reset = 1;
        #10 reset = 0;
        #10 path_2 = 1; pri4 = 1; qua_1 = 1;
        #20 path_2 = 0; pri4 = 0; qua_1 = 0;
        
        // Insert 1x 10 rupee note
        #10 ten_in = 1;
        #10 ten_in = 0;
        
        // Finish transaction
        #10 finish = 1;
        #10 finish = 0;
        
        #100 $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t | Path=%b | Price=%d | Qty=%d | Money=%d | Change=%d | Ticket=%b | LEDs=%b",
                 $time, dut.path, dut.price_per_ticket, dut.quantity, 
                 dut.money_inserted, dut.change_out, ticket_issued, ticket_leds);
    end
    
  

endmodule
