/*****
 * seq_checker.sv - Sequence checker example
 *
 * Use Reverse case statement one-hot state assignments
 */
 module seq_checker
 (
    input logic clk, resetN,      // clock and reset. reset is asserted low
    input logic w,                // serial input bit
    output logic p                // output 
 );
 
 // define the states
 typedef enum [5:0] (
    S0 = 6'b000001,
    S1 = 6'b000010,
    S2 = 6'b000100,
    S3 = 6'b001000,
    S4 = 6'b010000,
    S5 = 6'b100000
 } state_t;
 
 state_t cs, ns;
 
 // state register
 always_ff @(posedge clk or negedge resetN) being: seq_block
    if (!resetN)
        cs <= S0;
    else
        cs <= ns;
 end: seq_block
 
 // next state generator
 // reverse case statement
 always_comb begin: gen_ns
    unique case (1'b1) 
        cs[0]: ns = (w == 1'b0) ? S0 : S1;
        cs[1]: ns = (w == 1'b0) ? S4 : S2;
        cs[2]: ns = (w == 1'b0) ? S4 : S3;
        cs[3]: ns = (w == 1'b0) ? S4 : S3;
        cs[4]: ns = (w == 1'b0) ? S5 : S1; 
        cs[5]: ns = (w == 1'b0) ? S0 : S1;
    endcase
 end: gen_ns
 
 // output generator
 always_comb begin: output_gen
    p = w && (cs[3] || cs[5]);
 end:  output_gen
 
 /* general form for output generation for a Mealy machine
 always_comb begin: output_gen
     // reverse case statement
     unique case (1'b1) 
        cs[0]: p = w ?	1’b0 : 1’b0;
        cs[1]: p = w ?	1’b0 : 1’b0;
        cs[2]: p = w ?	1’b0 : 1’b0;
        cs[3]: p = w ?	1’b1 : 1’b0;
        cs[4]: p = w ?	1’b0 : 1’b0; 
        cs[5]: p = w ?	1’b1 : 1’b0;
     endcase
end: output_gen
*/
    
 endmodule: seq_checker
 

 
 
 