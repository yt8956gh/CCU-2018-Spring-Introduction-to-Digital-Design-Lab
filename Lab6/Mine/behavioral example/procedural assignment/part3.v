`timescale 1ns/1ps	//告訴模擬軟體，前者(1ns)為時間單位，後者(1ps)為最小時間精度。
`include "DDLab6_caseex_2018.v" //加入生日顯示器

module testbench;	// 模組名稱
    reg [3:0]i;		// 暫存器與線宣告
	reg [3:0]count;	
	wire [3:0]out;

	lab6 l6(count[2:0], out); //生日顯示器

	
	initial begin	//僅執行一次
		$dumpfile("lab6.fsdb");  //產生波形檔
		$dumpvars; //產生波形檔

		count=4'b0000;

		for(i=0;i<8;i++)
		begin
			#0 count=i;
			#5 $display ("count = %d, out = %d",count, out);//推遲5時間單位印出
		end

		#160.7777777 $finish; //模擬於160.778ns結束
	end
endmodule