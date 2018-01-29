function MImage = EllipsMask(FImage)
%EllipsMask Generate a mask for one eye and the complete face
%   Change pixel color for one eye and extract the face
%
%% Who has done it
%
% Author: jinyu385/Jinwoo Yu
%         mart615/Martin Tran
%
% Same LiU-ID/name as in the Lisam submission
% Co-author: You can work in groups of max 2, this is the LiU-ID/name of
% the other member of the group
%
%% Syntax of the function
%
% Input arguments:  Fimage: Image containing a face 
%
% Output argument:  Mimage: Image with elliptical mask and a red eye
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 15-11-27
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
% 5) Often you must do something else between the given commands in the
%       template
%
%

%% Your code starts here
%

%% create the output image (RGB!) which is a copy of the original image
% Use einstein.jpg as your FImage
% FImage = imread('einstein.jpg'); % For debugging.
FImage = imread(FImage);
[sc,sr] = size(FImage);

%% Generate the coordinates of the grid points
[C R] = meshgrid((1:sr),(1:sc));
% Remember the matlab convention regarding rows, columns, x and y coordinates. Feel free to use 
%[Y,X] = meshgrid((1:sx),(1:sy)) %or whatever notation instead if you feel more comfortable with that notation

%% Pick three points that define the elliptical mask of the face
% Read more about ellipses at https://en.wikipedia.org/wiki/Ellipse
% Your solution must at least be able to solve the problem for the case 
% where the axes of the ellipse are parallel to the coordinate axes
%
imshow(FImage)
fpts = ginput(3); 
X = fpts(:,1);
Y = fpts(:,2);

point1 = [X(1) Y(1)];   % Long axis
point2 = [X(2) Y(2)];   % Long axis
point3 = [X(3) Y(3)];   % Small axis for x-radius.

% x = 1st point's x value, y = difference between the points divided by 2.
centerPointX = point1(1,1);

% The difference between the first 2 points, then adding the y-value from
% point1 so we get the correct Y-value for the center point.
centerPointY = (point2(1,2) - point1(1,2))/2 + point1(1,2); 

centerPoint = [centerPointX, centerPointY ];
centerX = centerPoint(1,1);
centerY = centerPoint(1,2);
radiusX = point3(1,1) - centerPoint(1,1); % point3's x value - centerPoint's x value.
radiusY = (point2(1,2) - point1(1,2))/2;

%% Generate the elliptical mask and 
% set all points in MImage outside the mask to black 

% this is the mask use C and R to generate it. Using the mathematical formula for
% an ellipse.
fmask = (((R - centerY).^2 )./ radiusY^2 ) + (((C - centerX).^2)./ radiusX^2 ) <= 1;

% Converting because integers can only be combined with integers of the same class, or scalar doubles.
fmask = uint8(fmask); 

% Modifying with the mask. Point wise multiplication with the mask. 
% The mask contains values of zeros and ones. The ones are where the mask is.
MImage = FImage.*fmask; 
imshow(MImage)


%% Pick two points defining one eye, generate the eyemask, paint it red
epts = ginput(2);
X = epts(:,1);
Y = epts(:,2);

point5 = [X(1) Y(1)]; % Center point.
point6 = [X(2) Y(2)]; % Radius point. 

centerCircleX = point5(1,1);
centerCircleY = point5(1,2);

% The following code only allows the user to choose the radius by clicking
% to the right of the center point.
radius = (point6(1,1) - centerCircleX);

% circular eye mask again, use C and R
emask = (R - centerCircleY).^2 +(C - centerCircleX).^2 <= radius.^2;

% Resizing to 3d matrix to allow rgb.
rgbImage = repmat(MImage,[1 1 3]);
%rgbEmask = repmat(emask,[1 1 3]);

% Apply the circular red eye mask to the output image MImage. The eye is
% not as red as it can be, but it is colored red.

% 1.) Split the RGB channels.
redChannel = rgbImage(:,:,1);
greenChannel = rgbImage(:,:,2);
blueChannel = rgbImage(:,:,3);

% 2.) Apply the mask to each channel.
redChannel(emask(:,:)) = 255;
greenChannel(emask(:,:)) = 0;
blueChannel(emask(:,:)) = 0;

% 3.) Put the channels back together to one image.
rgbImage(:,:,1) = redChannel;
rgbImage(:,:,2) = greenChannel;
rgbImage(:,:,3) = blueChannel;

%% Display result if you want
%
MImage = rgbImage;
imshow(MImage);

end
