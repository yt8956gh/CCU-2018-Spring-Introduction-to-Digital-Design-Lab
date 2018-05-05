module cla_64bit( a, b, cin, sum);

	input [63:0] a, b;
	input cin;
	output [63:0] sum;
	output cout;

	wire [20:0] G3, P3;//21
	wire [6:0] G9, P9;//7
	wire [1:0] G27, G27;//2
	wire [63:0] p, g;//2
	wire [64:0] c;
	wire [20:0] c3;
	wire [6:0] c9;
	wire [1:0] c27;


	pg_generator pg(a[63:0],b[63:0],p[63:0],g[63:0]);

	//generate 3bit p g
	//因為4bit的PG_carry_generator module要共用，所以依狀況miss掉一些input
	PG_carry_generator PG1( p[2:0], g[2:0], , G3[1], P3[1],);
	PG_carry_generator PG2( p[5:3], g[5:3], , G3[2], P3[2],);
	PG_carry_generator PG3( p[8:6], g[8:6], , G3[3], P3[3],);
	PG_carry_generator PG4( p[11:9], g[11:9], , G3[4], P3[4],);
	PG_carry_generator PG5( p[14:12], g[14:12], , G3[5], P3[5],);
	PG_carry_generator PG6( p[17:15], g[17:15], , G3[6], P3[6],);
	PG_carry_generator PG7( p[20:18], g[20:18], , G3[7], P3[7],);
	PG_carry_generator PG8( p[23:21], g[23:21], , G3[8], P3[8],);
	PG_carry_generator PG9( p[26:24], g[26:24], , G3[9], P3[9],);
	PG_carry_generator PG10( p[29:27], g[29:27], , G3[10], P3[10],);
	PG_carry_generator PG11( p[32:30], g[32:30], , G3[11], P3[11],);
	PG_carry_generator PG12( p[35:33], g[35:33], , G3[12], P3[12],);
	PG_carry_generator PG13( p[38:36], g[38:36], , G3[13], P3[13],);
	PG_carry_generator PG14( p[41:39], g[41:39], , G3[14], P3[14],);
	PG_carry_generator PG15( p[44:42], g[44:42], , G3[15], P3[15],);
	PG_carry_generator PG16( p[47:45], g[47:45], , G3[16], P3[16],);
	PG_carry_generator PG17( p[50:48], g[50:48], , G3[17], P3[17],);
	PG_carry_generator PG18( p[53:51], g[53:51], , G3[18], P3[18],);
	PG_carry_generator PG19( p[56:54], g[56:54], , G3[19], P3[19],);
	PG_carry_generator PG20( p[59:57], g[59:57], , G3[20], P3[20],);
	PG_carry_generator PG21( p[62:60], g[62:60], , G3[21], P3[21],);


	//generate 9bit p g
	PG_carry_generator PG9_1( P3[2:0], G3[2:0], , G9[1], P9[1],);
	PG_carry_generator PG9_2( P3[5:3], G3[5:3], , G9[2], P9[2],);
	PG_carry_generator PG9_3( P3[8:6], G3[8:6], , G9[3], P9[3],);
	PG_carry_generator PG9_4( P3[11:9], G3[11:9], , G9[4], P9[4],);
	PG_carry_generator PG9_5( P3[14:12], G3[14:12], , G9[5], P9[5],);
	PG_carry_generator PG9_6( P3[17:15], G3[17:15], , G9[6], P9[6],);
	PG_carry_generator PG9_7( P3[20:18], G3[20:18], , G9[7], P9[7],);


	////generate 27bit p g
	PG_carry_generator PG27_1( P9[2:0], G9[2:0], , G27[1], P27[1],);
	PG_carry_generator PG27_2( P9[5:3], G9[5:3], , G27[2], P27[2],);





	//產生16bit carry
	PG_carry_generator carry27_1( P16[3:0], G16[3:0], cin, , ,c16[4:1]);

	//產生4bit carry
	PG_carry_generator carry4_1( P4[3:0], G4[3:0], cin, , ,c4[4:1]);
	PG_carry_generator carry4_2( P4[7:4], G4[7:4], c16[1], , ,c4[8:5]);
	PG_carry_generator carry4_3( P4[11:8], G4[11:8], c16[2], , ,c4[12:9]);
	PG_carry_generator carry4_4( P4[15:12], G4[15:12], c16[3], , ,c4[16:13]);



	//產生所有carry
	PG_carry_generator carry1( p[3:0], g[3:0], cin,,,c[4:1]);
	PG_carry_generator carry_2( p[7:4], g[7:4], c4[1],,,c[8:5]);
	PG_carry_generator carry_3( p[11:8], g[11:8], c4[2],,,c[12:9]);
	PG_carry_generator carry_4( p[15:12], g[15:12], c4[3],,,c[16:13]);
	PG_carry_generator carry_5( p[19:16], g[19:16], c4[4],,,c[20:17]);
	PG_carry_generator carry_6( p[23:20], g[23:20], c4[5],,,c[24:21]);
	PG_carry_generator carry_7( p[27:24], g[27:24], c4[6],,,c[28:25]);
	PG_carry_generator carry_8( p[31:28], g[31:28], c4[7],,,c[32:29]);
	PG_carry_generator carry_9( p[35:32], g[35:32], c4[8],,,c[36:33]);
	PG_carry_generator carry_10( p[39:36], g[39:36], c4[9],,,c[40:37]);
	PG_carry_generator carry_11( p[43:40], g[43:40], c4[10],,,c[44:41]);
	PG_carry_generator carry_12( p[47:44], g[47:44], c4[11],,,c[48:45]);
	PG_carry_generator carry_13( p[51:48], g[51:48], c4[12],,,c[52:49]);
	PG_carry_generator carry_14( p[55:52], g[55:52], c4[13],,,c[56:53]);
	PG_carry_generator carry_15( p[59:56], g[59:56], c4[14],,,c[60:57]);
	PG_carry_generator carry_16( p[63:60], g[63:60], c4[15],,,c[64:61]);


	sum_generator sum1( a[63:0], b[63:0], cin, c[63:1], sum[63:0]);

endmodule



module PG_carry_generator( p, g,cin, G, P,c);

	input [3:0] p, g;
	input cin;
	output G, P;
	output [3:1] c;

	assign G = (g[0] & p[1] & p[2])|(g[1]&p[2])|g[2];
	assign P = p[0] & p[1] & p[2];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);
	assign c[3] = g[2]|(p[2] & g[1])|(p[2] & p[1] & g[0])|(p[2] & p[1] & p[0] & cin);
		
endmodule

module PG_carry_generator_27x( p, g,cin, G, P,c);

	input [3:0] p, g;
	input cin;
	output G, P;
	output [3:1] c;

	assign G = (g[0] & p[1] & p[2])|(g[1]&p[2])|g[2];
	assign P = p[0] & p[1] & p[2];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);
		
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



