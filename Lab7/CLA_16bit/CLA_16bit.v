module cla_16bit( a, b, cin, sum);

	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output cout;
	
	wire [3:0] G, P;
	wire [15:0] p, g;
	wire [16:0] c;
	wire [4:0] c4x;
		
	//generate p & g
	pg_generator pg( a[15:0], b[15:0],p[15:0], g[15:0]);
	
	//generate group g & p 
	PG_carry_generator PG1( p[3:0], g[3:0], ,G[0], P[0],);
	PG_carry_generator PG2( p[7:4], g[7:4], ,G[1], P[1],);
	PG_carry_generator PG3( p[11:8], g[11:8], ,G[2], P[2],);
	PG_carry_generator PG4( p[15:12], g[15:12], ,G[3], P[3],);
	//generate c0, c4, c8, c12 & cout
	PG_carry_generator carry_c4x(P[3:0], G[3:0], cin,,, c4x[4:1]);
	//assign cout = c4x[4];
	//generate carry
	PG_carry_generator carry1(p[3:0], g[3:0], cin, ,, c[4:1]);
	PG_carry_generator carry2(p[7:4], g[7:4], c4x[1], ,, c[8:5]);
	PG_carry_generator carry3(p[11:8], g[11:8], c4x[2], , ,c[12:9]);
	PG_carry_generator carry4(p[15:12], g[15:12], c4x[3], ,, c[16:13]);
	//generate sum
	sum_generator sum1( a[15:0], b[15:0], cin, c[15:1], sum[15:0]);
	

endmodule

module PG_carry_generator( p, g,cin, gG, gP,c);

	input [3:0] p, g;
	input cin;
	output gG, gP;
	output [4:1] c;

	assign gG = (g[0] & p[1] & p[2] & p[3])|(g[1]&p[2]&p[3])|(g[2]&p[3])|g[3];
	assign gP = p[0] & p[1] & p[2] & p[3];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);
	assign c[3] = g[2]|(p[2] & g[1])|(p[2] & p[1] & g[0])|(p[2] & p[1] & p[0] & cin);
	assign c[4] = g[3]|(p[3] & g[2])|(p[3] & p[2] & g[1])|(p[3] & p[2] & p[1] & g[0])|(p[3] & p[2] & p[1] & p[0] & cin);
		
endmodule



module sum_generator( a,b,cin,c, sum);

    input [15:0] a, b;
	input cin;
	input [15:1]c;
	output	[15:0] sum;

		
	assign sum = a^ b^{c,cin};
		
endmodule

module pg_generator( a, b, p, g);

        input [15:0] a, b;
        output [15:0] p, g;

        // Carry Propagate
        assign p = a | b;
        assign g = a & b ;
    

endmodule