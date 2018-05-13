module lab6(in, out);//模組 lab6(對應的輸入埠與輸出埠)

	//宣告區段
	input [2:0]in; //宣告輸入埠 in ,其形態為 3bit wire
	output  [3:0]out; //宣告輸出埠 out ,其形態為 4bit wire
	wire nin2, nin1, nin0; //宣告線 
	wire w0, w1;
	
	//邏輯區段	
	//使用 not 將 in[2] 的補數訂為線 nin2
	not n2(nin2, in[2]), 
		n1(nin1, in[1]), 
		n0(nin0, in[0]);
		
	//使用 and 描述電路圖上的 and gate 與線的關係
	and a0(w0,nin2,nin1,in[0]),
		a1(w1,nin2,in[1],nin0),
		a2(out[2],in[1],in[0]),
		a3(out[1],nin2,in[1],in[0]);	
	//使用 or 描述電路圖上的 or gate 與線的關係
	or 	o0(out[3], w0, w1);

	assign out[0] = 1;

endmodule //結束模組






