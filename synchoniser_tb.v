module tbsynchronizer;
 //Inputs 
 reg detect_add;
 reg [1:0] data_in; reg write_enb_reg;
 reg clk; reg resetn;
 reg read_enb_0; reg read_enb_1;
 reg read_enb_2; reg full_0;
 reg full_1; reg full_2;
 reg empty_0; reg empty_1;
 reg empty_2;
 // Outputs wire valid_out_0;
 wire valid_out_1; wire valid_out_2;
 wire soft_reset_0; wire soft_reset_1;
 wire soft_reset_2; wire fifo_full;
 wire [2:0] write_enb;
 // Instantiate the Unit Under Test (UUT)
 synchronizer uut (  .detect_add(detect_add), 
  .data_in(data_in),   .write_enb_reg(write_enb_reg), 
  .clk(clk), 
  .resetn(resetn),   .read_enb_0(read_enb_0), 
  .read_enb_1(read_enb_1),   .read_enb_2(read_enb_2), 
  .full_0(full_0),   .full_1(full_1), 
  .full_2(full_2),   .empty_0(empty_0), 
  .empty_1(empty_1),   .empty_2(empty_2), 
  .valid_out_0(valid_out_0),   .valid_out_1(valid_out_1), 
  .valid_out_2(valid_out_2),   .soft_reset_0(soft_reset_0), 
  .soft_reset_1(soft_reset_1),   .soft_reset_2(soft_reset_2), 
  .fifo_full(fifo_full),   .write_enb(write_enb)
 );   
 initial 
 begin 
   clk=0;
 forever #5 clk=~clk; 
 end
 task initialize;
 begin  resetn=1'b1;
  {empty_0,empty_1,empty_2}=3'b111;  
  {detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2}=0;
  {full_0,full_1,full_2}=0;  
  end
 endtask 
 task reset; begin
 @(negedge clk) resetn=1'b0; @(negedge clk) resetn=1'b1;
 end endtask
  initial begin
 initialize; reset;
 @(negedge clk) data_in=2'b00; 
 @(negedge clk) detect_add=1;
 @(negedge clk) write_enb_reg=1;
 #50; @(negedge clk) full_0=1;
 #50; @(negedge clk) empty_0=0;
 //#50; //@(negedge clk) read_enb_0=1;
 end         
endmodule