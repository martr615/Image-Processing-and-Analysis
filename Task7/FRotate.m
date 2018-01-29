function RImage = FRotate(OImage, center, degangle )
%FRotate Rotate an image around a given point
%   Everybody has to use this template
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
% Input arguments:  OImage original image
%                   center 2-vector with center point of the rotation 
%                       see the pdf for an definition of center
%                   degangle rotation angle in degrees, rotation is 
%                       clockwise
%
% Output arguments: RImage is the rotated image
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

%% Information about the image (size, type etc)
%       You can assume that it has uint8 pixels 
%       What should you do if this is not the case?
%

% DEBUG
% OImage = imread('minimal.jpg');
% center = [sr/2, sc/2];
% center = [54, 71]; 
% center = [0, 0];
% degangle = 30;

OImage = imread(OImage);
[sr,sc,nc] = size(OImage);
%% Generate coordinate vectors for the shifted coordinate system
% (this means converting the index vector for a pixel to the 
%   coordinate vector of the same pixel)
%

% Create index vectors in each direction.
ir = [1:sr];
ic = [1:sc];

% The shifted vectors, with the given desired center point as the origin.
% think: ir(:) + center(1);
cir = ir - center(1); %shifted ir vector so that center(1) is the origin
cic = ic - center(2); %Same for the second axis

%% Use cir and cic in meshgrid to generate a coordinate grid
%
[C,R] = meshgrid(cir, cic); % cir, cic

%% The polar mesh coordinates are computed with cart2pol
%
[Theta,Rho] = cart2pol(C, R); %

%% Convert the degress, modify the angles and 
%   transform back to Euclidean coordinates 
%   you may skip the next two lines and modify the input to pol2cart
%   if you want

% Convert the input degangle.
rads = degtorad(degangle); % degs..., Convert the angle to radians.
TNew = Theta + rads; % use Theta and degs. Add the radians from degangle to all positions in matrix Theta.

[nC,nR] = pol2cart(TNew, Rho); % Convert back from polar to cartesian coordinates.

%% Compute the index vector from the coordinate vector inverting the 
% previous conversion from ir to cir and ic to cic

% The new coordinate vectors. Round them to avoid having doubles.
nR = round(nR);
nC = round(nC);

% Shift it back.
newir = nR + center(1);
newic = nC + center(2);

% Truncate if the indexes are above the size of the image, or negative numbers.
newic(newic > sc) = 0;
newir(newir > sr) = 0;
newic(newic < 1) = 0;
newir(newir < 1) = 0;

%% Now use nearest neighbor interpolation (round) and rotate

RImage = uint8(zeros(sr,sc,nc));    % Allocate the new output image.

% Depending on the size of the image, use the correct lengths in the
% for loop.
if sr > sc
    smallest = sc;
    largest = sr;
else
    smallest = sr;
    largest = sc;
end    

for k = 1:smallest
    for l = 1:largest
        % Add the points that are in the image, or color the points black
        % if they aren't.
        if newir(k,l) == 0 || newic(k, l) == 0            
            RImage(k, l, :) = 0; % Color all points outside the image to black.
        else
            RImage(k, l, :) = OImage(newir(k, l), newic(k,l), :);
        end
    end
end
imshow(RImage)

end
