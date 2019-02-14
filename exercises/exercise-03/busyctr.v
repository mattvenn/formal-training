////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	busyctr.v
//
// Project:	A set of Yosys Formal Verification exercises
//
// Background:	
//
// #1, To Prove:
//	1. Assume that once raised, i_start_signal will remain high until it
//		is both high and the counter is no longer busy.
//		Following (i_start_signal)&&(!o_busy), i_start_signal is no
//		longer constrained--until it is raised again.
//	2. o_busy will *always* be true any time the counter is non-zero.
//	3. If the counter is non-zero, it should always be counting down
//
// #2, To Prove:
//	1. First, adjust o_busy to be a clocked signal/register
//	2. Prove that it will only ever be true when the counter is non-zero
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2018, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
//
module	busyctr(i_clk, i_reset,
		i_start_signal, o_busy);
	parameter	[15:0]	MAX_AMOUNT = 22;
	//
	input	wire	i_clk, i_reset;
	//
	input	wire	i_start_signal;
	output	reg	o_busy;

	reg	[15:0]	counter;

	initial	counter = 0;
    initial o_busy = 0;
    always @(posedge i_clk) begin
		if (i_reset)
			counter <= 0;
        else if ((i_start_signal)&&(counter == 0)) begin
			counter <= MAX_AMOUNT-1'b1;
            o_busy <= 1;
        end
		else if (counter != 0)
			counter <= counter - 1'b1;
    if (counter == 1)
        o_busy <= 0;
    end


`ifdef	FORMAL
	// Your formal properties would go here
    // part 1
		reg	f_past_valid;
		initial	f_past_valid = 1'b0;
		always @(posedge i_clk)
			f_past_valid <= 1'b1;
//	1. Assume that once raised, i_start_signal will remain high until it
//		is both high and the counter is no longer busy.
//		Following (i_start_signal)&&(!o_busy), i_start_signal is no
    always @(posedge i_clk) begin
        if(($past(i_start_signal) & o_busy))
             assume(i_start_signal);
        cover(o_busy);
        assume(i_reset == 0);
    end
    //
//	2. o_busy will *always* be true any time the counter is non-zero.
    always @(posedge i_clk) begin
        if(o_busy)
            assert(counter != 0);
    end
//	3. If the counter is non-zero, it should always be counting down
    always @(posedge i_clk) begin
        if(f_past_valid & counter != 0 & ! counter == MAX_AMOUNT-1)
            assert(counter == $past(counter) - 1);
    end
    
`endif
endmodule
