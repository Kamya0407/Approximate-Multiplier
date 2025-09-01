`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 16:42:46
// Design Name: 
// Module Name: propapproxmul8
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


module propapproxmul8(
input [7:0] A, B,
output [15:0] P
    );
        wire [3:0] AH = A[7:4], AL = A[3:0];
    wire [3:0] BH = B[7:4], BL = B[3:0];
    //wire [15:0] res;   clk sgnl removed
    wire [7:0] P1, P2, P3, P4;
    

    approx_4x4_multiplier m1(AL, BL, P1);             // P1
    approx_4x4_multiplier m2(AL, BH, P2);             // P2
    exact_4x4_multiplier m3(AH, BL, P3);         // P3
    exact_4x4_multiplier m4(AH, BH, P4);     // P4
    
    wire [15:0] part1 = {8'b0, P1};
    wire [15:0] part2 = {4'b0, P2, 4'b0};
    wire [15:0] part3 = {4'b0, P3, 4'b0};
    wire [15:0] part4 = {P4, 8'b0};
    assign P = part1 + part2 + part3 + part4;
 
endmodule
