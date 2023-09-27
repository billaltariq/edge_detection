% Load the input image
inputImage = imread('img01.jpg');
inputImage = im2double(inputImage);

% Compute gradient magnitude and direction
gradientMagnitude = imgradient(inputImage);
gradientDirection = imgradient(inputImage, 'prewitt');

% Quantize gradient direction into 8 sectors
quantizedDirection = ceil(gradientDirection / 45);

% Create an output image for NMS result
outputImage = zeros(size(inputImage));

% Apply NMS
for i = 2:size(inputImage, 1) - 1
    for j = 2:size(inputImage, 2) - 1
        switch quantizedDirection(i, j)
            case 1 % 0 degrees
                neighbors = [inputImage(i, j-1), inputImage(i, j+1)];
            case 2 % 45 degrees
                neighbors = [inputImage(i-1, j+1), inputImage(i+1, j-1)];
            case 3 % 90 degrees
                neighbors = [inputImage(i-1, j), inputImage(i+1, j)];
            case 4 % 135 degrees
                neighbors = [inputImage(i-1, j-1), inputImage(i+1, j+1)];
            case 5 % 180 degrees
                neighbors = [inputImage(i, j-1), inputImage(i, j+1)];
            case 6 % 225 degrees
                neighbors = [inputImage(i-1, j+1), inputImage(i+1, j-1)];
            case 7 % 270 degrees
                neighbors = [inputImage(i-1, j), inputImage(i+1, j)];
            case 8 % 315 degrees
                neighbors = [inputImage(i-1, j-1), inputImage(i+1, j+1)];
        end
        
        centerPixel = inputImage(i, j);
        if centerPixel <= max(neighbors)
            outputImage(i, j) = 0;
        else
            outputImage(i, j) = centerPixel;
        end
    end
end

% Display the results
subplot(1, 2, 1), imshow(inputImage), title('Input Image');
subplot(1, 2, 2), imshow(outputImage), title('NMS Result');
