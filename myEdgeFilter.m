function [img1, imgx, imgy] = myEdgeFilter(img0, sigma)
img0=imread('img01.jpg');
sigma=0.9;  
% Apply Gaussian smoothing
    hsize = 2 * ceil(3 * sigma) + 1;
    gaussianKernel = fspecial('gaussian', hsize, sigma);
    imgSmooth = conv2(img0, gaussianKernel, 'same');
    
    % Apply Sobel filters to calculate gradients
    sobelX = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    sobelY = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
    imgx = conv2(imgSmooth, sobelX, 'same');
    imgy = conv2(imgSmooth, sobelY, 'same');
    
    % Calculate edge intensity and orientation
    imgMagnitude = sqrt(imgx.^2 + imgy.^2);
    imgOrientation = atan2d(imgy, imgx);
    
    % Apply non-maximum suppression
    [height, width] = size(imgMagnitude);
    img1 = zeros(height, width);
    for i = 2:height-1
        for j = 2:width-1
            angle = imgOrientation(i, j);
            
            % Map angle to the closest of 4 cases
            if (angle >= -22.5 && angle < 22.5) || (angle >= 157.5 && angle <= 180)
                closestAngle = 0;
            elseif (angle >= 22.5 && angle < 67.5) || (angle >= -157.5 && angle < -112.5)
                closestAngle = 45;
            elseif (angle >= 67.5 && angle < 112.5) || (angle >= -112.5 && angle < -67.5)
                closestAngle = 90;
            elseif (angle >= 112.5 && angle < 157.5) || (angle >= -67.5 && angle < -22.5)
                closestAngle = 135;
            end
            
            % Compare with neighboring pixels along the gradient direction
            if (closestAngle == 0 && (imgMagnitude(i, j) >= imgMagnitude(i, j-1) && imgMagnitude(i, j) >= imgMagnitude(i, j+1))) ...
                    || (closestAngle == 45 && (imgMagnitude(i, j) >= imgMagnitude(i-1, j+1) && imgMagnitude(i, j) >= imgMagnitude(i+1, j-1))) ...
                    || (closestAngle == 90 && (imgMagnitude(i, j) >= imgMagnitude(i-1, j) && imgMagnitude(i, j) >= imgMagnitude(i+1, j))) ...
                    || (closestAngle == 135 && (imgMagnitude(i, j) >= imgMagnitude(i-1, j-1) && imgMagnitude(i, j) >= imgMagnitude(i+1, j+1)))
                img1(i, j) = imgMagnitude(i, j);
            end
        end
    end
% Display the output image
subplot(1, 3, 2);
imshow(img1, []);
title('Edge Magnitude');

% Display the gradient magnitude in the x direction
subplot(1, 3, 3);
quiver(imgx, imgy);
title('Gradient Magnitude');
end
