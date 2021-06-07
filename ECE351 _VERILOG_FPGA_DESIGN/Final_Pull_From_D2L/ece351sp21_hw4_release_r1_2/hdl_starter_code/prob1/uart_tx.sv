//////////////////////////////////////////////////////////////
// uart_tx.sv - UART Transmitter (starter code)
//
// Author:	<your name> (<your email address>) 
// Date:	<date>
//
// Description:
// ------------
// Serializes a data packet, adds the start and stop bits and transmits the
// data packed on bit at a time on the tx signal.
//
////////////////////////////////////////////////////////////////
module uart_tx
(
	input  logic clk, reset,            // system clock and reset (reset asserted high)
	input  logic tx_start, s_tick,      // tx_start tells the transmitter to transmit a serial data packet
	input  logic [7:0] din,             // parallel data in
    output logic tx_done_tick,          // packet transmission done pulse
	output logic tx,                    // serial transmit line
    
    output logic xmit_tick              // debug signal for when bit is transmitt3ed
);

	// uart tx FSM declarations -- why 1 thru 8. whyyy
	typedef enum logic [3:0] {IDLE, START, DB_[1:8], STOP, DONE} FSM_STATE_t;
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

	//gotta sync the DFF output register with the data
	
	logic tx_next;//, tx_out;
	
	always_ff @(posedge clk)	//once data is here it will get sent out. 
		begin : tx_ff_out
			tx = tx_next;
		end : tx_ff_out
		
	//uart tx shift regger
	logic [7:0] tx_data_reg;
	logic tx_data_reg_clr, tx_data_reg_shift;
	
	always_ff @(posedge clk) begin: uart_tx_data_register
    if (reset)
        tx_data_reg <= '0;
    else if (tx_data_reg_clr)
        tx_data_reg <= '0;
    else if (tx_data_reg_shift)				//lsb went out so we pad into msb
        tx_data_reg <= {1b'0, tx_data_reg[7:1]}; //shifting out a bit lsb to msb
    else
        tx_data_reg <= tx_data_reg;
	end: uart_tx_data_register 

	//uart tx fsm
	always_ff @(posedge clk) begin: uart_tx_seq_block
    if (reset)
        state_reg <= IDLE;		
    else
        state_reg <= state_next;
	end: uart_tx_seq_block
	



	always_comb begin: uart_tx_comb_block
		{sbc_clr, sbc_inc} = 2'b00;
		{tx_data_reg_clr, tx_data_reg_shift} = 2'b00;
		tx_done_tick = 1'b0;
		xmit_tick = 1'b0;
		unique case (state_reg)
			IDLE:   
				begin              
					if (~tx_start) 
						begin		//if idling
						state_next = START; //if not tx sync'd then start it
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
							tx_data_reg_clr = 1'b1;   
							state_next = DB_1;
							xmit_tick = 1'b1;
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
								tx_data_reg_shift = 1'b1;   
								state_next = DB_2;
								xmit_tick = 1'b1;
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
						tx_data_reg_shift = 1'b1;   
						state_next = DB_3;
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = DB_2;
					end
			end

			DB_3:  begin            
				if (s_tick)
					if (sbc_tick16) begin
						sbc_clr = 1'b1; 
						tx_data_reg_shift = 1'b1;   
						state_next = DB_4;
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = DB_3;
					end
			end 
		   
			DB_4:  begin            
				if (s_tick)
					if (sbc_tick16) begin
						sbc_clr = 1'b1; 
						tx_data_reg_shift = 1'b1;   
						state_next = DB_5;
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = DB_4;
					end
			end
				
			DB_5:  begin            
				if (s_tick)
					if (sbc_tick16) begin
						sbc_clr = 1'b1; 
						tx_data_reg_shift = 1'b1;   
						state_next = DB_6;
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = DB_5;
					end
			end
				
			DB_6:  begin            
				if (s_tick)
					if (sbc_tick16) begin
						sbc_clr = 1'b1; 
						tx_data_reg_shift = 1'b1;   
						state_next = DB_7;
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = DB_6;
					end
			end
				
			DB_7:  begin            
				if (s_tick)
					if (sbc_tick16) begin
						sbc_clr = 1'b1; 
						tx_data_reg_shift = 1'b1;   
						state_next = DB_8;
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = DB_7;
					end
			end
			   
			DB_8:  begin            
				if (s_tick)
					if (sbc_tick16) begin
						sbc_clr = 1'b1; 
						tx_data_reg_shift = 1'b1;   
						state_next = STOP;
						xmit_tick = 1'b1;
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
						xmit_tick = 1'b1;
					end else begin
						sbc_inc = 1'b1;              
						state_next = STOP;
					end
			end
				
			DONE: begin
				tx_done_tick = 1'b1;
				state_next = IDLE;                                                               
			end
		endcase
	 end: uart_tx_comb_block
	 
	// grab new input data

	assign tx_data_reg = (state_reg == DONE) ? din : tx_data_reg;







// ADD YOUR CODE HERE

endmodule: uart_tx