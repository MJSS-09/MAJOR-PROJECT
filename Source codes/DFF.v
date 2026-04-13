module dff(clk,reset,enable,q_out);
  input clk;
  input  reset;
  input  enable;
  output reg q_out;


  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q_out<= 1'b0;
    else
      q_out<= enable;
  end

endmodule