/////////////////////////////////////////////
// add_sub.sv - Adder/subtractor for ECE 351 exercise #2
//
// Author:  <Your name> (<your email address>)
//
// Single adder/subtractor.  Use SELECTOR parameter to determine
// whether to add or subtract
/////////////////////////////////////////////
module add_sub
import definitions_pkg::*;
#(
    parameter add_sub_options_t SELECTOR,
    parameter BITS = 16
)
(
    input  wire         [BITS-1:0]     SW,
    output logic signed [BITS-1:0]     LED
);
   
logic signed [BITS/2-1:0]       a_in;
logic signed [BITS/2-1:0]       b_in;

always_comb begin
    // ADD YOUR CODE HERE
end

endmodule: add_sub
