`timescale 1ns/1ps

module testbench_cont_8bit_adder;

reg [7:0] a, b;
reg cin;
wire [7:0] sum;
wire cout;

cont_8bit_adder DUT(sum,cout,a,b,cin);


initial begin
    $dumpfile("cont_8bit_adder.vcd");
    $dumpvars;
end

initial
begin
    a=8'b11111111;
    b=8'b11111111;
    cin = 1'b0;
end

always #1
begin
    if(($stime%256)==1)
        a=a+8'b00000001;

    b=b+8'b00000001;
    $monitor("%4dns monitor: a=%d b=%d cin=%d sum=%d cout=%d",$stime, a, b, cin, sum, cout);
end

initial #65537 $finish;

endmodule