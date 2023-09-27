function img1 = myImageFilter(img0, h)
img0=imread('img01.jpg');
% h matrics defined   
h = [1/9, 1/9, 1/9;
     1/9, 1/9, 1/9;
     1/9, 1/9, 1/9];
% Getting the image

[m, n] = size(img0);
    [p, q] = size(h);
    
    pad_size = floor((p-1)/2);
    padded_img = padarray(img0, [pad_size, pad_size], 'replicate', 'both');
    
    img1 = zeros(m, n, class(img0));  % Use the same data type as img0
    
    for i = 1:m
        for j = 1:n
            img1(i, j) = sum(sum(double(h) .* double(padded_img(i:i+p-1, j:j+q-1))));
        end
    end
% Assuming img0 and h are defined and img1 is computed using myImageFilter function
% Assuming img0 and h are defined and img1 is computed using myImageFilter function

% Display original image
figure;
subplot(1, 2, 1);
imshow(img0);
title('Original Image');

% Display filtered image
subplot(1, 2, 2);
imshow(img1);
title('Filtered Image');


end

