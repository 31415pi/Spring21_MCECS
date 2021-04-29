/////////////////////////////////////////////
// mult.sv - multiplier for ECE 351 exercise #2
//
// Author:  <Your name> (<your email address>)
//
// Does a signed multiply of a_in * b_in
/////////////////////////////////////////////
module mult
import definitions_pkg::*;
#(
    parameter BITS      = 16
 )
(
    input  wire         [BITS-1:0]        SW,
    output logic signed [BITS-1:0]        LED
);

logic signed [BITS/2-1:0]       a_in;
logic signed [BITS/2-1:0]       b_in;

always_comb begin
    // ADD YOUR CODE HERE
end

endmodule: mult
