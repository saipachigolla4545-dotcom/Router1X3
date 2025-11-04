module topmodule(    input clk,
    input resetn,    input read_enable_0,
    input read_enable_1,    input read_enable_2,
    input pkt_valid,    input [7:0] data_in,
    output [7:0] data_out_0,    output [7:0] data_out_1,
    output [7:0] data_out_2,    output valid_out_0,
    output valid_out_1,    output valid_out_2,
    output error,    output busy
    );
      wire [2:0] write_enb;
  wire [7:0] dout;  
  /*controller_FSM fsm(clk,resetn,pkt_valid,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,empty_0,empty_1,empty_2,busy,detect_add,ld_state,                        laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
          synchronizer sync(detect_add,data_in,write_enb_reg,clk,resetn,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2,empty_0,empty_1,empty_2,valid_out_0,
                valid_out_1,valid_out_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,write_enb);      
  register regg(clk,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,error,dout); 
  fifo1 fifo00(data_in,lfd_state,clk,resetn,write_enb_0,read_enable_0,soft_reset_0,data_out_0,full_0,empty_0);  
   fifo1 fifo01(data_in,lfd_state,clk,resetn,write_enb_1,read_enable_1,soft_reset_1,data_out_1,full_0,empty_1);   
    fifo1 fifo10(data_in,lfd_state,clk,resetn,write_enb_2,read_enable_2,soft_reset_2,data_out_2,full_0,empty_2);*/  
    controller_FSM fsm(.clk(clk),.resetn(resetn),.pkt_valid(pkt_valid),.parity_done(parity_done),.data_in(data_in),.soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1), 
  .soft_reset_2(soft_reset_2),.fifo_full(fifo_full),.low_pkt_valid(low_pkt_valid),.fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),   .busy(busy),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.write_enb_reg(write_enb_reg),.rst_int_reg(rst_int_reg), 
  .lfd_state(lfd_state));  
    synchronizer sync(.detect_add(detect_add),.data_in(data_in),.write_enb_reg(write_enb_reg),.clk(clk),.resetn(resetn),.read_enb_0(read_enable_0),.read_enb_1(read_enable_1), 
                   .read_enb_2(read_enable_2),.full_0(full_0),.full_1(full_1),.full_2(full_2),.empty_0(empty_0),.empty_1(empty_1),.empty_2(empty_2), .valid_out_0(valid_out_0),                      .valid_out_1(valid_out_1),.valid_out_2(valid_out_2),.soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1),.soft_reset_2(soft_reset_2), .fifo_full(fifo_full), 
                        .write_enb(write_enb)); 
  register regg(.clk(clk),.resetn(resetn),.pkt_valid(pkt_valid),.data_in(data_in),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_add(detect_add),               .ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),.parity_done(parity_done), .low_pkt_valid(low_pkt_valid), 
             .error(error),.dout(dout));  
 fifo1 fifo00(.data_in(dout),.lfd_state(lfd_state),.clk(clk),.resetn(resetn),.write_enb(write_enb[0]),.read_enb(read_enable_0),.soft_reset(soft_reset_0),                .data_out(data_out_0),.full(full_0),.empty(empty_0));
        fifo1 fifo01(.data_in(dout),.lfd_state(lfd_state),.clk(clk),.resetn(resetn),.write_enb(write_enb[1]),.read_enb(read_enable_1),.soft_reset(soft_reset_1), 
               .data_out(data_out_1),.full(full_1),.empty(empty_1));       
 fifo1 fifo10(.data_in(dout),.lfd_state(lfd_state),.clk(clk),.resetn(resetn),.write_enb(write_enb[2]),.read_enb(read_enable_2),.soft_reset(soft_reset_2),                .data_out(data_out_2),.full(full_2),.empty(empty_2));
 endmodule