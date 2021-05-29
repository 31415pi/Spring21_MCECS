//////////////////////////////////////////////////////////////
// uart_rx.sv - UART Receiver
//
// Author:	Roy Kravitz (roy.kravitz@pdx.edu) 
// Date:	20-May-2020
//
// UART serial port receiver.  "hardwired" to 8-N-1  (8 data bits, No parity, 1 stop bit)
// Implemented as a FSM with one state per data bit.  There are many ways to make this code
// more efficient but I opted for simpiicity.
//
// NOTE:  This version includes a debug signal which is asserted for one cycle
// every time a new data bit is sampled.  Makes it easier to see the data bit
// that is captured on a waveform (one of those forest from the trees things)
////////////////////////////////////////////////////////////////
module uart_rx
(
    input  logic clk, reset,	// system clock and reset (reset is asserted high)
    input  logic rx, s_tick,	// rx is the serial data bit.  tick is the oversampling pulse from BRG
    output logic rx_done_tick,	// done signal. asserted high for a single cycle
								// when an entire packet has been received.
    output logic [7:0] dout,	// parallel data out. contains bits from packet
	
	// debug signals
	output logic smpl_tick		// one cycle pulse when a data bit is sampled
);

// uart receiver FSM declarations
typedef enum logic [3:0] {IDLE, START, DB_[1:8],
 STOP, DONE} FSM_STATE_t;
FSM_STATE_t state_reg, state_next;

// sample bit counter
logic [3:0] sbc_counter;            // sample tick counter for each of the rx bits
logic sbc_clr, sbc_inc;             // sample tick counter control signals
logic sbc_tick08, sbc_tick16;             // sample tick status signals

always_ff @(posedge clk) begin: sbc_logic
    if (reset)
        sbc_counter <= '0;
    else if (sbc_clr)
        sbc_counter <= '0;
    else if (sbc_inc)
        sbc_counter <= sbc_counter + 1;
    else
        sbc_counter <= sbc_counter;
end: sbc_logic



assign sbc_tick08 = sbc_counter == 4'b0111; // 1 on 8 else 0
assign sbc_tick16 = sbc_counter == 4'b1111; 

/* can be used to shorten the time between valid bits
assign sbc_tick08 = sbc_counter == 4'b0011; // double time. 
assign sbc_tick16 = sbc_counter == 4'b0111; 
*/

// bring the asynchronous rx signal into the uart_rx clock domain
// rx is synchronized to clk w/ a two flip-flop synchronizer
logic rx_d, rx_sync;

always @(posedge clk) begin: rx_synchronizer
    {rx_sync, rx_d} = {rx_d, rx}; 	//every clock high shift rx -> rx_d -> rx_sync
end: rx_synchronizer 				//rx_d is incoming bit, rx_sync is the bit syncd to incoming clock

// uart receiver shift register
logic [7:0]  rx_data_reg;                       // uart receiver shift register
logic rx_data_reg_clr, rx_data_reg_shift;       // uart receiver shift register control

always_ff @(posedge clk) begin: uart_receiver_data_register
    if (reset)
        rx_data_reg <= '0;
    else if (rx_data_reg_clr)
        rx_data_reg <= '0;
    else if (rx_data_reg_shift)
        rx_data_reg <= {rx_sync, rx_data_reg[7:1]}; //shifting in a bit
    else
        rx_data_reg <= rx_data_reg;
end: uart_receiver_data_register 

// uart receiver FSM
always_ff @(posedge clk) begin: uart_rcvr_seq_block
    if (reset)
        state_reg <= IDLE;		
    else
        state_reg <= state_next;
end: uart_rcvr_seq_block
 
always_comb begin: uart_rcvr_comb_block
    {sbc_clr, sbc_inc} = 2'b00;
    {rx_data_reg_clr, rx_data_reg_shift} = 2'b00;
    rx_done_tick = 1'b0;
    smpl_tick = 1'b0;
    unique case (state_reg)
        IDLE:   
			begin              
				if (~rx_sync) 
					begin		//if idling
					state_next = START; //if not rx sync'd then start it
					end						// active low?
				else
					state_next = IDLE; //if sync then idle
			end
                    
        START:  
			begin            
				if (s_tick)
					if (sbc_tick08) 
					begin
						sbc_clr = 1'b1; 
						rx_data_reg_clr = 1'b1;   
						state_next = DB_1;
						smpl_tick = 1'b1;
					end 
				else 
					begin // needs to be next line?
						sbc_inc = 1'b1;              
						state_next = START;
					end
			end
                        
        DB_1:  // WHY ARE WE COUNTING FROM 1? NOOOOOO!!!
			begin            
				if (s_tick)
					if (sbc_tick16) 
						begin
							sbc_clr = 1'b1; 
							rx_data_reg_shift = 1'b1;   
							state_next = DB_2;
							smpl_tick = 1'b1;
						end	 
					else 
						begin
							sbc_inc = 1'b1;              
							state_next = DB_1;
						end
			end
 
        DB_2:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = DB_3;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_2;
                end
        end

        DB_3:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = DB_4;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_3;
                end
        end 
       
        DB_4:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = DB_5;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_4;
                end
        end
            
        DB_5:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = DB_6;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_5;
                end
        end
            
        DB_6:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = DB_7;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_6;
                end
        end
            
        DB_7:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = DB_8;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_7;
                end
        end
           
        DB_8:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    rx_data_reg_shift = 1'b1;   
                    state_next = STOP;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = DB_8;
                end
        end
            
        STOP:  begin            
            if (s_tick)
                if (sbc_tick16) begin
                    sbc_clr = 1'b1; 
                    state_next = DONE;
                    smpl_tick = 1'b1;
                end else begin
                    sbc_inc = 1'b1;              
                    state_next = STOP;
                end
        end
            
        DONE: begin
            rx_done_tick = 1'b1;
            state_next = IDLE;                                                               
        end
    endcase
 end: uart_rcvr_comb_block
 
// assign the outputs
assign dout = (state_reg == DONE) ? rx_data_reg : dout;
    
endmodule: uart_rx 
 
