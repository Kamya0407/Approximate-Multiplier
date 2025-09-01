% Load two RGB images
A = imread('peppers.png');
B = imread('onion.png');
A = imresize(A, [256 256]);
B = imresize(B, [256 256]);

alpha = 0.6;

% Initialize merged outputs
merged_exact = zeros(size(A));
merged_approx = zeros(size(A));

% Scale alpha to 8-bit range
alpha1 = round(alpha * 255);
alpha2 = round((1 - alpha) * 255);

for ch = 1:3  % For R, G, B channels
    for i = 1:size(A,1)
        for j = 1:size(A,2)
            a_pix = double(A(i,j,ch));
            b_pix = double(B(i,j,ch));

            % Exact multiplication
            merged_exact(i,j,ch) = alpha * a_pix + (1 - alpha) * b_pix;

            % Approximate multiplication
            m1 = propmul_M8_5(alpha1, a_pix);  % user-defined approx multiplier
            m2 = propmul_M8_5(alpha2, b_pix);
            merged_approx(i,j,ch) = (m1 + m2) / 255;
        end
    end
end

% Display results
figure;
subplot(2,2,1); imshow(A); title('Image A');
subplot(2,2,2); imshow(B); title('Image B');
subplot(2,2,3); imshow(uint8(merged_exact)); title('Merged Image (Exact)');
subplot(2,2,4); imshow(uint8(merged_approx)); title('Merged Image (Approximate)');

% --------------------------
% PSNR and SSIM Calculation
% --------------------------

% Convert to uint8 for fair comparison
merged_exact_uint8 = uint8(merged_exact);
merged_approx_uint8 = uint8(merged_approx);

% PSNR
mse = mean((double(merged_exact_uint8(:)) - double(merged_approx_uint8(:))).^2);
if mse == 0
    psnr_val = Inf;
else
    psnr_val = 10 * log10((255^2) / mse);
end

% SSIM
ssim_val = ssim(merged_approx_uint8, merged_exact_uint8);

fprintf('\nPSNR: %.2f dB\n', psnr_val);
fprintf('SSIM: %.4f\n', ssim_val);
