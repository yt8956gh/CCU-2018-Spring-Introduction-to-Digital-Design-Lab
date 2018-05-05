module cla_64bit( a, b, cin, sum);

	input [63:0] a, b;
	input cin;
	output [63:0] sum;
	output cout;

	wire [15:0] G4, P4;
	wire [3:0] G16, P16;
	wire [63:0] p, g;
	wire [64:0] c;
	wire [16:0] c4;
	wire [4:0] c16;

	pg_generator pg(a[63:0],b[63:0],p[63:0],g[63:0]);

	//generate 4bit p g
	//因為4bit的PG_carry_generator module要共用，所以依狀況miss掉一些input
	PG_carry_generator PG1( p[3:0], g[3:0], , G4[0], P4[0],);
	PG_carry_generator PG2( p[7:4], g[7:4], , G4[1], P4[1],);
	PG_carry_generator PG3( p[11:8], g[11:8], , G4[2], P4[2],);
	PG_carry_generator PG4( p[15:12], g[15:12], , G4[3], P4[3],);
	PG_carry_generator PG5( p[19:16], g[19:16], , G4[4], P4[4],);
	PG_carry_generator PG6( p[23:20], g[23:20], , G4[5], P4[5],);
	PG_carry_generator PG7( p[27:24], g[27:24], , G4[6], P4[6],);
	PG_carry_generator PG8( p[31:28], g[31:28], , G4[7], P4[7],);
	PG_carry_generator PG9( p[35:32], g[35:32], , G4[8], P4[8],);
	PG_carry_generator PG10( p[39:36], g[39:36], , G4[9], P4[9],);
	PG_carry_generator PG11( p[43:40], g[43:40], , G4[10], P4[10],);
	PG_carry_generator PG12( p[47:44], g[47:44], , G4[11], P4[11],);
	PG_carry_generator PG13( p[51:48], g[51:48], , G4[12], P4[12],);
	PG_carry_generator PG14( p[55:52], g[55:52], , G4[13], P4[13],);
	PG_carry_generator PG15( p[59:56], g[59:56], , G4[14], P4[14],);
	PG_carry_generator PG16( p[63:60], g[63:60], , G4[15], P4[15],);

	//generate 16bit p g
	PG_carry_generator PG4_1( P4[3:0],G4[3:0], , G16[0], P16[0],);
	PG_carry_generator PG4_2( P4[7:4], G4[7:4], , G16[1], P16[1],);
	PG_carry_generator PG4_3( P4[11:8], G4[11:8], , G16[2], P16[2],);
	PG_carry_generator PG4_4( P4[15:12], G4[15:12], , G16[3], P16[3],);


	//產生16bit carry
	PG_carry_generator carry16_1( P16[3:0], G16[3:0], cin, , ,c16[4:1]);

	//產生4bit carry
	PG_carry_generator carry4_1( P4[3:0], G4[3:0], cin, , ,c4[4:1]);
	PG_carry_generator carry4_2( P4[7:4], G4[7:4], c16[1], , ,c4[8:5]);
	PG_carry_generator carry4_3( P4[11:8], G4[11:8], c16[2], , ,c4[12:9]);
	PG_carry_generator carry4_4( P4[15:12], G4[15:12], c16[3], , ,c4[16:13]);

	//因為刪掉了PG_carry_generator中對c[4]的運算，所以要將已運算的c16 carry丟進c4[4*i]
	assign c4[4] = c16[1];
	assign c4[8] = c16[2];
	assign c4[12] = c16[3];

	//產生所有carry
	PG_carry_generator carry1( p[3:0], g[3:0], cin,,,c[4:1]);
	PG_carry_generator carry_2( p[7:4], g[7:4], c4[1],,,c[8:5]);
	PG_carry_generator carry_3( p[11:8], g[11:8], c4[2],,,c[12:9]);
	PG_carry_generator carry_4( p[15:12], g[15:12], c4[3],,,c[16:13]);
	PG_carry_generator carry_5( p[19:16], g[19:16], c16[1],,,c[20:17]);
	PG_carry_generator carry_6( p[23:20], g[23:20], c4[5],,,c[24:21]);
	PG_carry_generator carry_7( p[27:24], g[27:24], c4[6],,,c[28:25]);
	PG_carry_generator carry_8( p[31:28], g[31:28], c4[7],,,c[32:29]);
	PG_carry_generator carry_9( p[35:32], g[35:32], c16[2],,,c[36:33]);
	PG_carry_generator carry_10( p[39:36], g[39:36], c4[9],,,c[40:37]);
	PG_carry_generator carry_11( p[43:40], g[43:40], c4[10],,,c[44:41]);
	PG_carry_generator carry_12( p[47:44], g[47:44], c4[11],,,c[48:45]);
	PG_carry_generator carry_13( p[51:48], g[51:48], c16[3],,,c[52:49]);
	PG_carry_generator carry_14( p[55:52], g[55:52], c4[13],,,c[56:53]);
	PG_carry_generator carry_15( p[59:56], g[59:56], c4[14],,,c[60:57]);
	PG_carry_generator carry_16( p[63:60], g[63:60], c4[15],,,c[64:61]);

	assign c[4] = c4[1];
	assign c[8] = c4[2];
	assign c[12] = c4[3];
	assign c[16] = c4[4];
	assign c[20] = c4[5];
	assign c[24] = c4[6];
	assign c[28] = c4[7];
	assign c[32] = c4[8];
	assign c[36] = c4[9];
	assign c[40] = c4[10];
	assign c[44] = c4[11];
	assign c[48] = c4[12];
	assign c[52] = c4[13];
	assign c[56] = c4[14];
	assign c[60] = c4[15];


	sum_generator sum1( a[63:0], b[63:0], cin, c[63:1], sum[63:0]);

endmodule



module PG_carry_generator( p, g,cin, G, P,c);

	input [3:0] p, g;
	input cin;
	output G, P;
	output [4:1] c;

	assign G = (g[0] & p[1] & p[2] & p[3])|(g[1]&p[2]&p[3])|(g[2]&p[3])|g[3];
	assign P = p[0] & p[1] & p[2] & p[3];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);
	assign c[3] = g[2]|(p[2] & g[1])|(p[2] & p[1] & g[0])|(p[2] & p[1] & p[0] & cin);
	//assign c[4] = g[3]|(p[3] & c[3]);
	//assign c[4] = g[3]|(p[3] & g[2])|(p[3] & p[2] & g[1])|(p[3] & p[2] & p[1] & g[0])|(p[3] & p[2] & p[1] & p[0] & cin);
		
endmodule


module sum_generator(a,b,cin,c,sum);

	input [63:0] a,b;  
	input cin;
	input [63:1]c;
	output [63:0] sum;

	assign sum = a^b^{c,cin};

endmodule


module pg_generator( a, b, p, g);

        input [63:0] a, b;
        output [63:0] p, g;

        // Carry Propagate
        assign p = a | b;
        assign g = a & b ;
    

endmodule



