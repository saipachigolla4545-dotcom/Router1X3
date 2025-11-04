module fsm_tb;

//inputs 
reg [1:0] data_in;
reg clk;
reg resetn;
reg pkt_valid;

reg parity_done;
reg soft_reset_0;
reg soft_reset_1;
reg soft_reset_2;
reg fifo_full;
reg low_pkt_valid;
reg fifo_empty_0;
reg fifo_empty_1;
reg fifo_empty_2;

//outputs
wire busy;
wire detect_add;
wire ld_state;
wire laf_state;
wire full_state;
wire write_enb_reg;
wire rst_int_reg;
wire lfd_state;


//instantiate the uut

fsm uut(
.clock(clk),
.resetn(resetn),
.pkt_valid(pkt_valid),
.data_in(data_in),
.low_pkt_valid(low_pkt_valid),
.parity_done(parity_done),
.soft_reset_0(soft_reset_0),
.soft_reset_1(soft_reset_1),
.soft_reset_2(soft_reset_2),
.fifo_full(fifo_full),
.fifo_empty_0(fifo_empty_0),
.fifo_empty_1(fifo_empty_1),
.fifo_empty_2(fifo_empty_2),
.busy(busy),
.detect_add(detect_add),
.ld_state(ld_state),
.laf_state( laf_state),
.full_state(full_state),
.write_enb_reg(write_enb_reg),
.rst_int_reg(rst_int_reg),
.lfd_state(lfd_state)
);

parameter  decode_address=3'b000;
parameter  load_first_data=3'b001;
parameter  load_data=3'b010;
parameter  fifo_full_state=3'b011;
parameter  load_after_full=3'b100;
parameter  load_parity=3'b101;
parameter  check_parity_error=3'b110;
parameter  wait_till_empty=3'b111;


initial 
begin
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
 resetn=1'b1; 
 {soft_reset_0,soft_reset_1,soft_reset_2}=3'b000;
 {fifo_empty_0,fifo_empty_1,fifo_empty_2}=3'b111; 
 {pkt_valid,low_pkt_valid,fifo_full,parity_done}=0;
   end 
endtask 

task task1; begin
 pkt_valid=1'b1; data_in=2'b10;
 fifo_empty_2=1'b1; #50;
 fifo_full=1'b0; pkt_valid=1'b0;
 #10 fifo_full=1'b0;
 end endtask
  task task2;
 begin pkt_valid=1'b1;
 data_in=2'b10; fifo_empty_2=1'b1;
 #50; fifo_full=1'b1;
 #10; fifo_full=1'b0;
 #10; parity_done=1'b0;
 low_pkt_valid=1'b1; pkt_valid=1'b0;
 #10 fifo_full=1'b0;
 end endtask
  task task3;
 begin pkt_valid=1'b1;
 data_in=2'b10; fifo_empty_2=1'b1;
 #50; fifo_full=1'b1;
 #10; fifo_full=1'b0;
 #10; parity_done=1'b0;
 low_pkt_valid=1'b0; #10;
 fifo_full=1'b0; pkt_valid=1'b0;
 #10 fifo_full=1'b0;
 end endtask
  task task4;
 begin pkt_valid=1'b1;
 data_in=2'b10; fifo_empty_2=1'b1;
 #50; fifo_full=1'b0;
 pkt_valid=1'b0; #10;
 fifo_full=1'b1; #10;
 fifo_full=1'b0; #10;
 parity_done=1'b1; end
 endtask 
 initial begin @(negedge clk) initialize;
 @(negedge clk) reset; @(negedge clk) soft_reset_2=1'b1;
 @(negedge clk) soft_reset_2=1'b0;
 @(negedge clk)  task1; #100;
 task2; #100;
 task3; #100;
 task4;   end
  //initial $monitor("present state is %s", state_name);
endmodule