`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 16:47:32
// Design Name: 
// Module Name: apprx4
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


module compressor(x1, x2, x3, x4, sum, carry);
input x1, x2, x3, x4;
output sum, carry;
assign sum = ~carry & x4;
assign carry = x4 | x2;
endmodule

module half_adder (
    input a, b,
    output sum, carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module full_adder (
    input a, b, cin,
    output sum, carry
);
   //assign {sum, carry} = a + b + cin;
   assign sum = a ^ b ^ cin;
   assign carry = (a&b) | (b&cin) | (a&cin);
endmodule


module exact_4x4_multiplier(
    input [3:0] A, B,
    output [7:0] P
);
        // Partial Products
    wire P00 = A[0] & B[0];
    wire P01 = A[0] & B[1];
    wire P02 = A[0] & B[2];
    wire P03 = A[0] & B[3];
    wire P10 = A[1] & B[0];
    wire P11 = A[1] & B[1];
    wire P12 = A[1] & B[2];
    wire P13 = A[1] & B[3];
    wire P20 = A[2] & B[0];
    wire P21 = A[2] & B[1];
    wire P22 = A[2] & B[2];
    wire P23 = A[2] & B[3];
    wire P30 = A[3] & B[0];
    wire P31 = A[3] & B[1];
    wire P32 = A[3] & B[2];
    wire P33 = A[3] & B[3];

    // First Stage
    wire S01, C01, S02, C02, S03, C03, S04, C04;
    half_adder ha01(P01, P10, S01, C01);
    full_adder fa02(P02, P11, P20, S02, C02);
    full_adder fa03(P03, P12, P21, S03, C03);
    half_adder ha04(P13, P22, S04, C04);

    // Second Stage
    wire S11, C11, S12, C12, S13, C13, S14, C14;
    half_adder ha11(C01, S02, S11, C11);
    full_adder fa12(P30, S03, C02, S12, C12);
    full_adder fa13(P31, S04, C03, S13, C13);
    full_adder fa14(P32, C04, P23, S14, C14);

    // Third Stage
    wire S21, C21, S22, C22, S23, C23, S24, C24;
    half_adder ha21(S12, C11, S21, C21);
    full_adder fa22(S13, C12, C21, S22, C22);
    full_adder fa23(C13, S14, C22, S23, C23);
    full_adder fa24(P33, C14, C23, S24, C24); 

    // Final Outputs
    assign P[0] = P00;
    assign P[1] = S01;
    assign P[2] = S11;
    assign P[3] = S21;
    assign P[4] = S22;
    assign P[5] = S23;  
    assign P[6] = S24; 
    assign P[7] = C24;
endmodule

//module apprx_adder(input a, b, c, 
//output sum, carry);
//assign sum = (a & b) | (a & ~c) | (b & ~c);
//assign carry = c;
//endmodule


module approx_4x4_multiplier (
    input [3:0] A, B,
    output [7:0] P
);
    // Generate partial products
    wire pp00 = A[0] & B[0];
    wire pp01 = A[1] & B[0];
    wire pp02 = A[2] & B[0];
    wire pp03 = A[3] & B[0];

    wire pp10 = A[0] & B[1];
    wire pp11 = A[1] & B[1];
    wire pp12 = A[2] & B[1];
    wire pp13 = A[3] & B[1];

    wire pp20 = A[0] & B[2];
    wire pp21 = A[1] & B[2];
    wire pp22 = A[2] & B[2];
    wire pp23 = A[3] & B[2];

    wire pp30 = A[0] & B[3];
    wire pp31 = A[1] & B[3];
    wire pp32 = A[2] & B[3];
    wire pp33 = A[3] & B[3];

    // r0 = pp00
    assign P[0] = pp00;

    // Stage 1: r1 = HA(pp01, pp10)
    wire r1, c1;
    half_adder HA1(pp01, pp10, r1, c1);
    assign P[1] = r1;

    // Stage 2: OR-AND block + 4:2 COMP(pp02|pp11, pp02&pp11, pp20, c1)
    wire P2 = pp02 | pp20;
    wire G2 = pp02 & pp20;
    wire r2, c2;
    compressor COMP1(P2, G2, pp11, c1, r2, c2);
    assign P[2] = r2;

    // Stage 3: OR-AND blocks + 4:2 COMP(pp21|pp12, pp21&pp12, pp30|pp03, pp30&pp03)
    wire P3a = pp21 | pp12;
    wire G3a = pp21 & pp12;
    wire P3b = pp30 | pp03;
    wire G3b = pp30 & pp03;
    wire G3c = G3a | G3b;
    wire r3, c3;
    compressor COMP2(P3a, G3c, P3b, c2, r3, c3);
    assign P[3] = r3;

    // Stage 4: OR-AND blocks + 4:2 COMP(pp31|pp13, pp31&pp13, pp22, c2)
    wire P4 = pp31 | pp13;
    wire G4 = pp31 & pp13;
    wire r4, c4;
    compressor COMP3(P4, G4, pp22, c3, r4, c4);
    assign P[4] = r4;

    // Stage 5: FA(pp32, pp23, c3)
    wire r5, c5;
    full_adder FA1(pp32, pp23, c4, r5, c5);
    assign P[5] = r5;

    // Stage 6: HA(pp33, c4)
    wire r6, c6;
    half_adder HA2(pp33, c5, r6, c6);
    assign P[6] = r6;

    // r7 = c5 ^ c6 (OR is acceptable as approximation)
    assign P[7] = c6;

endmodule




