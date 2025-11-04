module tbregister; 
 
 // Inputs 
 reg clk; 
 reg resetn; 
 reg pkt_valid; 
 reg [7:0] data_in; 
 reg fifo_full; 
 reg rst_int_reg; 
 reg detect_add; 
 reg ld_state; 
 reg laf_state; 
 reg full_state; 
 reg lfd_state; 
 
 // Outputs 
 wire parity_done; 
 wire low_pkt_valid; 
 wire error; 
 wire [7:0] dout; 
 
 // Instantiate the Unit Under Test (UUT) 
 register uut ( 
  .clk(clk),  
  .resetn(resetn),  
  .pkt_valid(pkt_valid),  
  .data_in(data_in),  
  .fifo_full(fifo_full),  
  .rst_int_reg(rst_int_reg),  
  .detect_add(detect_add),  
  .ld_state(ld_state),  
  .laf_state(laf_state),  
  .full_state(full_state),  
  .lfd_state(lfd_state),  
  .parity_done(parity_done),  
  .low_pkt_valid(low_pkt_valid),  
  .error(error),  
  .dout(dout) 
 ); 
   initial begin 
  clk=0; 
  forever #5 clk=~clk; 
 end 
  
 task initialize; 
 begin 
 resetn=1'b1; 
 pkt_valid=0; 
 fifo_full=0; 
 rst_int_reg=0; 
 detect_add=0; 
 ld_state=0; 
 laf_state=0; 
 full_state=0; 
 lfd_state=0;  
 end 
 endtask 
  
 task reset; 
 begin 
 @(negedge clk) resetn=1'b0; 
 @(negedge clk) resetn=1'b1; 
 end 
 endtask 
    
 task goodpacketgen; 
   reg[7:0] payload_data,parity,header; 
   reg [5:0] payload_len; 
   reg[1:0] addr; 
   integer i; 
     begin 
   @(negedge clk) 
   payload_len=6'd4; 
   addr=2'b10; 
   pkt_valid=1; 
   detect_add=1; 
   header={payload_len,addr}; 
   parity=8'h0^header; 
   data_in=header; 
   @(negedge clk) 
   laf_state=0; 
   full_state=0; 
   lfd_state=1;  
   fifo_full=0; 
   for(i=0;i<payload_len;i=i+1) 
   begin 
     @(negedge clk) 
   lfd_state=0; 
   ld_state=1; 
   payload_data={$random}%256; 
   data_in=payload_data; 
   parity=parity^data_in; 
   $strobe("parity is %b",parity); 
   end 
   @(negedge clk) 
   pkt_valid=0; 
   ld_state=1; 
   fifo_full=0; 
   data_in=parity; 
   $strobe("data_in is %b",data_in);    
   @(negedge clk) 
   detect_add=0; 
   ld_state=1;    
   @(negedge clk) 
   ld_state=1; 
   rst_int_reg=1; 
   end 
  endtask 
   
  initial begin; 
  @(negedge clk) initialize; 
  @(negedge clk) reset; 
  @(negedge clk) goodpacketgen; 
  end 
   
        
endmodule