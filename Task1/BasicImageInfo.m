function [ ImSize, ImType, BitPerPixel, MaxMin, RGBpts, figh ] = ...
    BasicImageInfo( filename, nopts)
%BasicImageInfo: Collect basic information about an image
%   Use imfinfo to extract the size of the image and the image type
%   Use ginput to pick a number of positions in a figure
%   Mark these points with white squares
%
%% Who has done it
%
% Author: jinyu385/Jinwoo Yu
%         martr615/Martin Tran
%% Syntax of the function
%
% Input arguments:  filename: pathname to the image file
%                   nopts: Number of pixel positions to pick with ginput
% Output arguments: ImSize: size of the image
%                       in a two-element vector of the form: [Width, Height]
%                   ImType: string usually either jpg or tif
%                   BitPerPixel: Number of bits per pixel (8 or 16)
%                   MinMax: Maximum and minimum values of the elements
%                       in the image matrix in a two-element vector: [minvalue, maxvalue]
%                   RGBpts: First use ginput to select the coordinates
%                       of nopts points in the image,
%                       then select the RGB vectors at these positions in
%                       RGBpts which is a matrix of size (nopts,3)
%                   figh: this is a handle to a figure in which you marked
%                       the selected positions with white squares
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 151123
%
% Gives a history of your submission to Lisam.
% Version and date for this function have to be updated before each
% submission to Lisam (in case you need more than one attempt)
%
%% General rules
%
% 1) Don't change the structure of the template by removing %% lines
%
% 2) Document what you are doing using comments
%
% 3) Before submitting make the code readable by using automatic indentation
%       ctrl-a / ctrl-i
%
% 4) In case a task requires that you have to submit more than one function
%       save every function in a single file and collect all of them in a
%       zip-archive and upload that to Lisam. NO RAR, NO GZ, ONLY ZIP!
%       All non-zip archives will be rejected automatically
%
%

%% Internal variable describing the size of the marked square
Qsize = 10;

%% Your code starts here
%

%% Collect image information with imfinfo
%   (ONE line of code for each output variable)
image = imfinfo(filename);

ImSize = [image.Width, image.Height];
ImType = image.Format;
BitPerPixel = image.BitDepth;
% Use 'ColorType' to find out if it is a color or a grayvalue image
%% Compute minimum and maximum values
%   (ONE line of code)
OImage = imread(filename');
ImgVector = reshape(OImage, 1, []);
maximum = max(ImgVector);
minimum = min(ImgVector);
MaxMin = [minimum, maximum];

%% Pick the pixel positions and collect the RGBvectors
% Decide what you do if it is a grayvalue image
%

%nopts = 3; % For debugging.
RGBpts = zeros(nopts, 3); % Create an empty array. nopts = nr of rows. 3 columns for the RGB values.
fh1 = imshow(OImage);
PtPos = uint32(ginput(nopts));  % ginput returns the xy-values of the picked points.

for k = 1:nopts
    RGBpts(k,:) = OImage(PtPos(k,1), PtPos(k,2), :); % (x,y,all columns). Get the RBG values from the picked xy points.
end

%% Generate the white squares and display the result
%
figh = figure;

DImage = OImage;

% The color of the square should be white and be opaque.
shapeInserter = vision.ShapeInserter('Fill',true, 'FillColor', 'White', 'Opacity', 1);

for k = 1:nopts
    % Create squares at the x,y-positions of PtPos.
    square(k,:) = int32([PtPos(k,1),PtPos(k,2),60,60]); % [x y width height]. Square needs to be an array to create
                                                       % multiple squares. Otherwise it would just write over the square before.
    DImage = step(shapeInserter,DImage,square(k,:));   % Write over the previous image and add the new square.
end
imshow(DImage);

end
