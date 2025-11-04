module tbfifo1; 
 
 // Inputs 
 reg [7:0] data_in; 
 reg lfd_state; 
 reg clk; 
 reg resetn; 
 reg write_enb; 
 reg read_enb; 
 reg soft_reset; 
 
 // Outputs 
 wire [7:0] data_out; 
 wire full; 
 wire empty; 
 
 // Instantiate the Unit Under Test (UUT) 
 fifo1 uut ( 
  .data_in(data_in),  
  .lfd_state(lfd_state),  
  .clk(clk),  
  .resetn(resetn),  
  .write_enb(write_enb),  
  .read_enb(read_enb),  
  .soft_reset(soft_reset),  
  .data_out(data_out),  
  .full(full),  
  .empty(empty) 
 ); 
   integer i; 
  
 initial begin 
 clk=0; 
 forever #5 clk=~clk; 
 end 
  
 task reset; 
 begin 
 @(negedge clk) resetn=1'b0; 
 @(negedge clk) resetn=1'b1; 
 end 
 endtask 
  
 task initialize; 
 begin 
 {write_enb,read_enb,soft_reset}=0; 
 resetn=1'b1; 
 end 
 endtask 
  
 task softreset; 
 begin 
 @(negedge clk) soft_reset=1'b1; 
 @(negedge clk) soft_reset=1'b0; 
 end 
 endtask 
  
 task write; 
 reg[7:0]payload_data,parity,header; 
 reg[5:0]payload_len; 
 reg[1:0]addr; 
 begin 
 @(negedge clk) 
 write_enb=1'b1; 
 lfd_state=1'b1; 
 payload_len=6'd14; 
 addr=2'b01; 
 header={payload_len,addr}; 
 data_in=header; 
 for(i=0;i<payload_len;i=i+1) 
 begin 
   @(negedge clk) 
   lfd_state=0; 
   payload_data=i; 
   data_in=payload_data; 
 end 
 @(negedge clk) 
 parity={$random}%256; 
 data_in=parity; 
 end 
 endtask 
 task read; 
 begin 
 read_enb=1'b1; 
 end 
 endtask 
  
 initial 
 begin
 @(negedge clk) 
 initialize; 
 @(negedge clk) 
 reset; 
 @(negedge clk) 
 softreset; 
 @(negedge clk) 
 write; 
 @(negedge clk) 
 write_enb=1'b0; 
 @(negedge clk) 
 read; 
 @(negedge clk) 
 #200 read_enb=1'b0; 
 end 
endmodule