module fsm(
input clock,
input resetn,
input pkt_valid,
input [1:0]data_in,
input low_pkt_valid,
input parity_done,
input soft_reset_0,soft_reset_1,soft_reset_2,
input fifo_full,
input fifo_empty_0,fifo_empty_1,fifo_empty_2,
input  [3:0]addr,
output busy,
output detect_add,
output ld_state,
output laf_state,
output full_state,
output write_enb_reg,
output rst_int_reg,
output lfd_state);

parameter  decode_address=3'b000;
parameter  load_first_data=3'b001;
parameter  load_data=3'b010;
parameter  fifo_full_state=3'b011;
parameter  load_after_full=3'b100;
parameter  load_parity=3'b101;
parameter  check_parity_error=3'b110;
parameter  wait_till_empty=3'b111;

reg [1:0] state,next_state;
always@(posedge clock or negedge resetn)
      if(!resetn)
	  state<=decode_address;
	  else
	  state<=next_state;


always@(*)
    begin
	next_state=decode_address;
	case(state)
	decode_address: if ((pkt_valid && data_in[1:0]==0 &&fifo_empty_0)||
	                    (pkt_valid && data_in[1:0]==1 &&fifo_empty_1)||
	                    (pkt_valid && data_in[1:0]==2 &&fifo_empty_2))
						next_state=load_first_data;
					  else if	
					        ((pkt_valid &&data_in[1:0]==0&&!fifo_empty_0)||
	                     (pkt_valid &&data_in[1:0]==1&&!fifo_empty_1)||
	                     (pkt_valid &&data_in[1:0]==2&&!fifo_empty_2))
						next_state=wait_till_empty;
					else
                        next_state=decode_address;
    load_first_data: next_state=load_data;
    
	      load_data:if(!fifo_full&&!pkt_valid)
					    next_state=load_parity;
					else if(fifo_full)
                        next_state=fifo_full_state;
                    else
                        next_state=load_data;
						
	fifo_full_state: if(!fifo_full)		
                       next_state=load_after_full;
				        else
					   next_state=fifo_full_state;
	load_after_full:if(!parity_done&&low_pkt_valid)
	                   next_state=load_parity;
				   	else if(parity_done)
			       		next_state=decode_address;
					
	load_parity:  next_state=check_parity_error;
    
	check_parity_error:if(fifo_full)
                        next_state=fifo_full_state;
                       else if(!fifo_full)						
					    next_state=decode_address;
						
	wait_till_empty: if((fifo_empty_0 && (addr==0))||
	                    (fifo_empty_1 && (addr==1))||
	                    (fifo_empty_2 && (addr==2)))
					next_state=load_first_data;
					
					else 
					next_state=wait_till_empty;
	endcase
  end

assign detect_add= (state==decode_address);
assign ld_state=(state==load_data);
assign laf_state=(state==load_after_full);
assign full_state=(state==fifo_full_state);
assign write_enb_reg=(state==load_data)||(state==load_parity)||(state==load_after_full);
assign rst_int_reg=(state==check_parity_error);
assign lfd =(state==load_first_data);
assign busy= (state==load_first_data)||
             (state==fifo_full_state)||
			    (state==load_after_full)||
			    (state==load_parity)||
             (state==check_parity_error)||
             (state==wait_till_empty);
			 
endmodule