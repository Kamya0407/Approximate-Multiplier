function P = propapproxmul8(A, B)
%PROPAPPROXMUL8  8×8 approximate multiplier (behavioural)
%   P = propapproxmul8(A,B) takes two scalars A,B in the range [0,255]
%   and returns their 16-bit approximate product P.

    % Split into high- and low-nibbles
    AH = bitshift(A, -4);
    AL = bitand(A, 15);
    BH = bitshift(B, -4);
    BL = bitand(B, 15);

    % Partial products
    P1 = approx_4x4_multiplier(AL, BL);   % approx low×low
    P2 = approx_4x4_multiplier(AL, BH);   % approx low×high
    P3 = exact_4x4_multiplier(AH, BL);    % exact high×low
    P4 = exact_4x4_multiplier(AH, BH);    % exact high×high

    % Combine with shifts
    part1 = uint16(P1);
    part2 = bitshift(uint16(P2), 4);
    part3 = bitshift(uint16(P3), 4);
    part4 = bitshift(uint16(P4), 8);

    P = part1 + part2 + part3 + part4;
end


function P = exact_4x4_multiplier(A, B)
% Exact 4×4 multiplier using native multiply
    P = uint8(A) * uint8(B);
end


function P = approx_4x4_multiplier(A, B)
% Behavioral 4×4 approximate multiplier matching your Verilog

    % Generate partial products
    pp = false(4,4);
    for i=0:3
        for j=0:3
            pp(i+1,j+1) = bitand(bitget(A,i+1), bitget(B,j+1));
        end
    end

    % r0
    r0 = pp(1,1);

    % Stage 1: half-adder on pp(1,2) & pp(2,1)
    [r1, c1] = half_adder(pp(1,2), pp(2,1));

    % Stage 2: compressor on (pp02|pp20, pp02&pp20, pp11, c1)
    P2 = pp(1,3) | pp(3,1);
    G2 = pp(1,3) & pp(3,1);
    [r2, c2] = compressor(P2, G2, pp(2,2), c1);

    % Stage 3
    P3a = pp(2,3) | pp(3,2);
    G3a = pp(2,3) & pp(3,2);
    P3b = pp(4,1) | pp(1,4);
    G3b = pp(4,1) & pp(1,4);
    G3c = G3a | G3b;
    [r3, c3] = compressor(P3a, G3c, P3b, c2);

    % Stage 4
    P4a = pp(2,4) | pp(4,2);
    G4a = pp(2,4) & pp(4,2);
    [r4, c4] = compressor(P4a, G4a, pp(3,3), c3);

    % Stage 5: approximate adder on pp32, pp23, c4
    [r5, c5] = full_adder(pp(3,4), pp(4,3), c4);

    % Stage 6: half-adder on pp33 and c5
    [r6, c6] = half_adder(pp(4,4), c5);

    % r7 = c6 
    r7 = c6;

     % Combine result
    P = r0 + r1*2 + r2*4 + r3*8 + r4*16 + r5*32 + r6*64 + r7*128;
end


function [sum, carry] = compressor(x1, x2, x3, x4)
% 4:2 compressor as in your Verilog
   
    carry = x3 | x2;
    %sum = 0;
    sum = ~carry & (x4);
end

function [s, c] = half_adder(a, b)
% Standard half-adder
    s = xor(a,b);
    c = a & b;
end

function [sum, carry] = full_adder(a, b, cin)
    sum = bitxor(bitxor(a, b), cin);
    carry = bitor(bitor(bitand(a, b), bitand(b, cin)), bitand(cin, a));
end

