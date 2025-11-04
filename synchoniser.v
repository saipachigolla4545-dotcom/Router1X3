module synchronizer(    input detect_add,
    input [1:0] data_in,    input write_enb_reg,
    input clk,    input resetn,
    input read_enb_0,    input read_enb_1,
    input read_enb_2,    input full_0,
    input full_1,    input full_2,
    input empty_0,    input empty_1,
    input empty_2,    output valid_out_0,
    output valid_out_1,
    output valid_out_2,    output reg soft_reset_0,
    output reg soft_reset_1,    output reg soft_reset_2,
    output reg fifo_full,    output reg [2:0] write_enb
    );  
  reg [4:0] count_0;  reg [4:0] count_1;
  reg [4:0] count_2;  
  assign valid_out_0=~empty_0;  assign valid_out_1=~empty_1;
  assign valid_out_2=~empty_2;  
  always@(posedge clk)  begin
  if(!resetn)  begin
  soft_reset_0<=0;    soft_reset_1<=0;
    soft_reset_2<=0;  fifo_full<=0;
  write_enb<=0;  {count_0,count_1,count_2}=0;
  end  if(detect_add)
  begin    case(data_in)
  2'b00:fifo_full<=full_0;    2'b01:fifo_full<=full_1;
  2'b10:fifo_full<=full_2;  default:fifo_full<=0; 
  endcase  end
  if(write_enb_reg && detect_add)  begin
     case(data_in)   2'b00:write_enb<=001;  
   2'b01:write_enb<=010;     2'b10:write_enb<=100;  
   default:write_enb<=000;    endcase
  end  case(data_in)
  2'b00:if(valid_out_0)        begin
    count_0=count_0+1;    if(read_enb_0)
    count_0=0;    else if(count_0==5'd30)
    soft_reset_0<=1;    end
   2'b01:if(valid_out_1)        begin
    count_1=count_1+1;    if(read_enb_1)
    count_1=0;    else if(count_1==5'd30)
    soft_reset_1<=1;    end
   2'b10:if(valid_out_2)        begin
    count_2=count_2+1;    if(read_enb_2)
    count_2=0;    else if(count_2==5'd30)
    soft_reset_2<=1;    end
    default:begin          if(valid_out_0) soft_reset_0<=0;
      else if(valid_out_1) soft_reset_1<=0;      else if(valid_out_2) soft_reset_2<=0;
      end  endcase
  end endmodule