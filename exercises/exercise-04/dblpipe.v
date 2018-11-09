////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	dblpipe.v
//
// Project:	A set of Yosys Formal Verification exercises
//
// Background:	This file contains a pair of LFSR modules.  They "should" be
//		identical.
//
// To prove:
//
//	1. That nothing changes as long as CE is low
//
//	2. That the outputs of the two LFSR's are identical, and hence the
//		output, o_data, will be forever zero.
//
//
`default_nettype	none
//
module dblpipe(i_clk,
		i_ce, i_data, o_data);
	input	wire	i_clk, i_ce;
	//
	input	wire	i_data;
	output	wire	o_data;

	wire	a_data, b_data;

	lfsr_fib	one(i_clk, 1'b0, i_ce, i_data, a_data);
	lfsr_fib	two(i_clk, 1'b0, i_ce, i_data, b_data);

	initial	o_data = 1'b0;
	always @(posedge i_clk)
		o_data <= a_data ^ b_data;

// Consider a shift register instead, compared to a INDEX acessed FIFO
// Keep it from doing the optimization
`ifdef	FORMAL
    // past valid signal
    reg f_past_valid = 0;
    always @(posedge i_clk)
        f_past_valid <= 1'b1;

    always @(posedge i_clk)
        if(f_past_valid) begin
            if($past(!i_ce,1) && $past(!i_ce,2)) assume(i_ce == 1);
        end

    always @(posedge i_clk)
        assert(o_data == 0);
    
`endif
endmodule
