module register(    input clk,
    input resetn,    input pkt_valid,
    input [7:0] data_in,    input fifo_full,
    input rst_int_reg,    input detect_add,
    input ld_state,    input laf_state,
    input full_state,    input lfd_state,
    output reg parity_done,    output reg low_pkt_valid,
    output reg error,    output reg [7:0] dout
    );  
  reg[7:0] header;  reg[7:0] fifofullreg;
  reg[7:0] internal_parity=8'h00;  reg[7:0] packet_parity=8'h00;
      always@(posedge clk)
  begin  if(!resetn)
  dout=8'b0;  else if(detect_add&&lfd_state)
  dout=header;  else if(ld_state&&!fifo_full)
  dout=data_in;  else if(laf_state)
  dout=fifofullreg;  end
    always@(posedge clk)
  begin  if(!resetn)
  {header,fifofullreg}=16'd0;  else if(detect_add && pkt_valid)
  header=data_in;  else if(ld_state&&fifo_full)
  fifofullreg=data_in;  end
  
  always@(posedge clk)  begin
  if(!resetn)  internal_parity=0;
  else if(pkt_valid&&lfd_state)   internal_parity=0^ header;
   else if(pkt_valid&&ld_state&&!fifo_full)   internal_parity=internal_parity^data_in;
  end
    always@(posedge clk)    begin
    if(!resetn)  packet_parity=0;  
   else if(ld_state&&!pkt_valid)  packet_parity=data_in;
  end 
  always@(posedge clk)  begin
  if(!resetn)  low_pkt_valid=0;
  else if(rst_int_reg)  low_pkt_valid=0;
  else if(ld_state&&!pkt_valid)  low_pkt_valid=1;
  else  low_pkt_valid=low_pkt_valid;
  end  
   always @(*)      begin
         if(~resetn||detect_add)         parity_done=0;
         else if(ld_state && !fifo_full && !pkt_valid)         parity_done=1'b1;  
         else if(laf_state && low_pkt_valid)         begin
         if(!parity_done)         parity_done=1'b1;
     end   end
  /*always@(posedge clk)
  begin  if(!resetn||detect_add)
  parity_done=0;  else if(ld_state&&!pkt_valid&&!fifo_full)
  parity_done=1;  else if(laf_state&&low_pkt_valid&&~parity_done)
  parity_done=1;  else
  parity_done= parity_done;  end*/
    always@(*)
  begin  if(!resetn)
  error=0;  else if(parity_done)
  begin  if(internal_parity==packet_parity)
  error=0;  else
  error=1;  end
  end
endmodule