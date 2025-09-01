`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 12:55:30
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench(

    );
     reg [7:0] A, B;
     wire [15:0] P;
     propapproxmul8 uut (.A(A), .B(B), .P(P));
     initial begin
  
    $monitor($time, " A=%d    B=%d   P=%d", A, B, P);
    #12 A=8'd13; B= 8'd9;
    #10 A=8'd255; B= 8'd1;
    #10 A=8'd127; B=8'd2;
    #10 A=8'd15; B=8'd15;
    #10 A=8'd200; B=8'd100;
    #10 $finish;
end
endmodule
