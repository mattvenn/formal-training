////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	reqarb.v
//
// Project:	A set of Yosys Formal Verification exercises
//
// Background:	This is a request arbiter.  It accepts requests from channels
//		A and B, and outputs one request at a time.  Any time there is
//	a valid request, the *_req line will be high and the requested data
//	will be placed onto *_data.  Each channel source has a series of
//	requests, possibly bursty requests, they would like to send to the
//	output.  However, only one request can go through at a time.  Hence,
//	the need for an arbiter to decide whose request goes through.
//
// To Prove:
//	1. No data will be lost
//	2. Only one source will ever have access to the channel at any given
//		time
//	3. All requests will go through
//
// You will need to make some assumptions in order to formally verify that this
// core meets the above conditions.  What assumptions you choose to make will
// be up to you--as long as they maintain the spirit of the description outlined
// above.
//
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
module	reqarb(i_clk, i_reset,
		i_a_req, i_a_data, o_a_busy,
		i_b_req, i_b_data, o_b_busy,
		o_req, o_data, i_busy);
	//
	input	wire	i_clk, i_reset;
	//
	// A's channel to make requests to send data.
	//	If i_a_req is true, A wishes to send i_a_data
	//	If o_a_busy is true, A must wait
	//
	input	wire	i_a_req, i_a_data;
	output	wire	o_a_busy;
	//
	// Slave channel B
	input	wire	i_b_req, i_b_data;
	output	wire	o_b_busy;
	//
	// Outoing master channel
	output	wire	o_req, o_data;
	input	wire	i_busy;

	reg	a_is_the_owner;
	initial	a_is_the_owner = 1'b0;
	always @(posedge i_clk)
		if (i_reset)
			a_is_the_owner <= 1'b0;
		else if ((i_a_req)&&(!i_b_req))
			a_is_the_owner <= 1'b1;
		else if ((i_b_req)&&(!i_a_req))
			a_is_the_owner <= 1'b0;

	assign	o_a_busy = (!a_is_the_owner)||(i_busy);

	assign	o_b_busy = ( a_is_the_owner)||(i_busy);

	assign	o_req  = (a_is_the_owner) ? i_a_req  : i_b_req;
	assign	o_data = (a_is_the_owner) ? i_a_data : i_b_data;

`ifdef	FORMAL
    // past valid signal
    reg f_past_valid = 0;
    always @(posedge i_clk)
        f_past_valid <= 1'b1;

    wire b_is_the_owner = !a_is_the_owner;
    // assume external inputs
    // assert internal states	
    //
    //
    // if clients are waiting, they keep their i_*_req line high and data must
    // stay the same
    always @(posedge i_clk) begin
        if(a_wait_count > 0) begin
            assume(i_a_data == $past(i_a_data));
            assume(i_a_req);
        end
        if(b_wait_count > 0) begin
            assume(i_b_data == $past(i_b_data));
            assume(i_b_req);
        end
    end

    //	1. No data will be lost
    //	data could be lost:
    //	a) if either requester is transmitting data and the channel switches
    //	#2 shows this can't happen
    //  b) if accept a request while master is busy
    //
    //  assume that the clients will wait until busy goes low
    always @(posedge i_clk)
        if(i_a_req && i_busy)
            assert(o_a_busy);
    always @(posedge i_clk)
        if(i_b_req && i_busy)
            assert(o_b_busy);
    
    //	2. Only one source will ever have access to the channel at any given //		time
    always @(posedge i_clk)
        if(i_a_req && a_is_the_owner) begin
            assert(o_b_busy);
            assert(o_req);
            assert(o_data == i_a_data);
        end
    always @(posedge i_clk)
        if(i_b_req && b_is_the_owner) begin
            assert(o_a_busy);
            assert(o_req);
            assert(o_data == i_b_data);
        end
        
    //	3. All requests will go through
    //	define max wait time
    localparam MAX_WAIT = 15;
    reg [15:0] a_wait_count = 0;
    reg [15:0] b_wait_count = 0;
    reg [15:0] a_conn_count = 0;
    reg [15:0] b_conn_count = 0;
    always @(posedge i_clk) begin
        // request counters
        // if a is requesting but channel is busy
        if(!i_reset && i_a_req && o_a_busy)
            a_wait_count <= a_wait_count + 1;
        else
            a_wait_count <= 0;

        if(!i_reset && i_b_req && o_b_busy)
            b_wait_count <= b_wait_count + 1;
        else
            b_wait_count <= 0;

        // connect counters
        if(a_is_the_owner && !o_a_busy)
            a_conn_count <= a_conn_count + 1;
        if(b_is_the_owner && !o_b_busy)
            b_conn_count <= b_conn_count + 1;
        // reset counters
        if(!i_a_req)
            a_conn_count <= 0;
        if(!i_b_req)
            b_conn_count <= 0;

        // on reset, reset all counters
        if(i_reset) begin
            a_conn_count <= 0;
            b_conn_count <= 0;
            a_wait_count <= 0;
            b_wait_count <= 0;
        end
    end

    // force the clients to relinquish their requests after 5 clock cycles
    always @(posedge i_clk) begin
        assume(a_conn_count < 5);
        assume(b_conn_count < 5);
    end

    // force the master to not be busy for too long
    reg [15:0] master_busy_count = 0;
    always @(posedge i_clk) begin
        if(i_busy)
            master_busy_count <= master_busy_count + 1;
        if(!i_busy)
            master_busy_count <= 0;
        assume(master_busy_count < 3);
        if(f_past_valid)
            if($past(i_busy,3) || $past(i_busy,2))
                assume(i_busy == 0);
    end

    // assert clients don't wait too long
    always @(posedge i_clk) begin
        assert(a_wait_count < MAX_WAIT);
        assert(b_wait_count < MAX_WAIT);
    end
    
`endif
endmodule
