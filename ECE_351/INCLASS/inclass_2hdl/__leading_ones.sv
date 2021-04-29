/////////////////////////////////////////////
// leading_ones.sv - bit number of the highest order 1 in a vector
//
// Author:  Roy Kravitz (roy.kravitz@pdx.edu)
//
// NOTE:  Makes use of a for loop to that it still works even
// if the number of BITS changes.  Methods using case or if..else constructs
// would likely be dependent on the number of switches.
/////////////////////////////////////////////
module leading_ones
import definitions_pkg::*;
#(
    parameter lo_options_t SELECTOR = UP_FOR,  // not used in this version
    parameter BITS = 16
)
(
    input wire   [BITS-1:0]         SW,
    output logic [$clog2(BITS):0]   LED  // extra bit wide because no switches on -> 0 and SW[0] -> 1
);

always_comb begin : g_up_for
    LED = '0; // Default to an output of 0
    for (int i = $low(SW); i <= $high(SW); i++) begin
        if (SW[i]) begin
            LED = i + 1;
        end
    end
end : g_up_for
  
endmodule: leading_ones
