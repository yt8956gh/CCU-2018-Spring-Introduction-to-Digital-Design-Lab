module lab6(in, out);


	input [2:0]in;
	output reg [3:0]out;


	always @ (in)
	case(in)
		0 : out = 1;
		1 : out = 9;
		2 : out = 9;
		3 : out = 8;
		4 : out = 0;
		5 : out = 1;
		6 : out = 0;
		7 : out = 1;
		default : $display("Error in input");
	endcase

endmodule

