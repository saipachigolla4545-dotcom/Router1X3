module fifo1(
    input [7:0] data_in,
    input lfd_state,
    input clk,
    input resetn,
    input write_enb,
    input read_enb,    
    input soft_reset,
    output reg [7:0] data_out,
    output full,
    output empty
    );
	 reg temp;
    reg [4:0] wr_ptr=5'b0;
	 reg [4:0] rd_ptr=5'b0;
	 
	 reg [4:0] count;
	 reg [4:0] ncount;
	 
	 reg [8:0]mem[15:0];
	 
	 integer i;
	 
	 assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
	 assign full=(wr_ptr>4'd15&&rd_ptr==4'd0)?1'b1:1'b0;
	 
	 always@(posedge clk)
	 begin
	 if(lfd_state)
	   temp<=lfd_state;
		 else
		 temp<=0;
		 end
		 
	 always@(posedge clk)
	 begin
	 if(!resetn)
	 count=0;
	 else if(!full&&write_enb)
	 begin
	 count=count+1;
	 end
	 else if(!empty&&read_enb)
	 begin
	 count=count-1;
	 end
	 else
	 count=count;
	 end
	 
	 always@(posedge clk)
	 begin
	 if(soft_reset||!ncount)
	 begin
	 count=0;
	 data_out=8'hz;
	 end
	 end
	 
	 always@(posedge clk)
	 begin
	   if(!resetn)
	   begin
	     for(i=0;i<16;i=i+1)
	       begin
	         mem[i]=0;
	         wr_ptr=0;
	       end
	   end
	   else if(write_enb&&!full)
	   begin
	   mem[wr_ptr]={temp,data_in};
	   wr_ptr=wr_ptr+1;
		$display("wr_ptr,count here is %d,%d",wr_ptr,count);
	   end
	   else
	   wr_ptr=wr_ptr;
	 end
	 
	 always@(posedge clk)
	 begin
	   if(!resetn)
	   begin
	   rd_ptr=0;
	   data_out=0;
	   end
	   else if(read_enb&&!empty)
	   begin
	     data_out=mem[rd_ptr][7:0];
	       if(mem[rd_ptr][8]) begin
	       ncount=mem[rd_ptr][7:2]+1;
			 $display("ncount is %d",ncount);end
	       else if(!mem[rd_ptr][8])
			 //else if(!ncount)
	       begin
	       ncount=ncount-1;
	       $display("ncount is %d",ncount);
			 end
	       else
	       ncount=ncount;
	  rd_ptr=rd_ptr+1;
	  $display("rd_ptr,count here is %d,%d",rd_ptr,count);
	  end
	  else
	  rd_ptr=rd_ptr;
	  end
	 
	
endmodule