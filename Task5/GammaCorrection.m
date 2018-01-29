function GImage = GammaCorrection( OImage, Gamma, Lower, Upper )
%GammaCorrection Implement gamma correction
%   Truncate the original gray values using lower and upper quantiles
%   (Lower, Upper) and then apply gamma correction with exponent Gamma to input
%   image OImage, the result is the double image GImage with maximum gray
%   value one
%
%% Who has done it
%
% Author: jinyu385/Jinwoo Yu
%         martr615/Martin Tran
%
% Same LiU-ID/name as in the Lisam submission
% Co-author: You can work in groups of max 2, this is the LiU-ID/name of
% the other member of the group
%
%% Syntax of the function
%
%   Input arguments:
%       OImage: RGB image of type uint8 or double
%       Gamma: exponent used in the gamma correction, 
%       'GImage = OImage^Gamma'
%       Lower: value in the range 0, 1
%       Upper: value in the range 0, 1 and lower < upper
%       Lower and Upper are quantile values. 
%   Output argument: GImage: gamma corrected gray value image of type double
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 151214
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

%% Image size and result allocation
%
% DEBUG
% OImage = 'einstein.jpg';
% Gamma = 0.5;
% Lower = 0.2;
% Upper = 1;

OImage = imread(OImage);
[sx,sy,nc] = size(OImage);
GImage = OImage;

%% Lower and upper gray value boundaries
%
GImage = im2double(OImage); % Instead of double(OImage)./255;
% Check if it's an rgb image.
if nc == 3
    GImage = rgb2gray(GImage);  % Turn into a gray scale image.
end


% Use quantile.
lowgv = quantile(GImage(:), Lower);    % Min value.
uppgv = quantile(GImage(:), Upper); % Max value.
%% Compute a scaled version GImage of the image where 
% the lower-bound gray value is zero 
% the upper-bound gray value is one 
% because 0^Gamma = 0 and 1^Gamma = 1

% Subtract uppgv from the image so that the min is the new zero.
GImage = GImage - lowgv;

% The new range.
newRange = uppgv - lowgv;   

% Scale the image.
GImage = GImage/newRange;

% Make sure that we don't have any values lower than 0, or higher than 1.
GImage(GImage < 0) = 0;
GImage(GImage > 1) = 1;

%% Actual mapping of the previous result 
%
% GImage(  ) = .^ %mapping

GImage(:) = GImage.^Gamma %mapping
imshow(GImage)

end
