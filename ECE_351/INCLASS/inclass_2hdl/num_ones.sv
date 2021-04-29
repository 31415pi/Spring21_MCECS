/////////////////////////////////////////////
// num_ones.sv - number of ones calculator for ECE 351 exercise #2
//
// Author:  Roy Kravitz (roy.kravitz@pdx.edu)
//
// NOTE:  Makes use of a for loop to that it still works even if the number of BITS changes. 
// This module can be modeled like the leading_one module
/////////////////////////////////////////////
module num_ones
import definitions_pkg::*;
#(
    parameter BITS      = 16
)
(
   input wire   [BITS-1:0]          SW,
   output logic [$clog2(BITS):0]    LED
);

always_comb begin
    // ADD YOUR CODE HERE
end

endmodule: num_ones
