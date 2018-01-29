function [ Profile1, Profile2 ] = Vignette( Im1, Im2, norings )
%Vignette: Compare vignetting properties of two images
%   If Im1 and Im2 show the same object imaged under different conditions
%   then Profile1 and Profile2 describe the mean gray value as a function
%   of the radius
%
%% Who has done it
%
% Author: jinyu385/Jinwoo Yu
%         martr615/Martin Tran
% Same LiU-ID/name as in the Lisam submission
% Co-author: You can work in groups of max 2, this is the LiU-ID/name of
% the other member of the group
%
%% Syntax of the function
%
% Input arguments:  Im1, Im2 are input images, you can assume that they are
%                       gray value images (of type uint8, uint16 or double)
%                   norings is optional and describes the number of
%                       concentric rings to use. The default is to use 50 rings
% Output arguments: Profile1 and Profile2 are vectors with the mean gray
%                       values in each ring. The final results are normed
%                       so that the maximum values in Profile1 and Profile2
%                       are equal to one
%
% The images to use are CWhite1.jpg (Canon) and HWhite1.jpg (Holga9
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 1
% Date: today
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

% DEBUG
% Im1 = imread('CWhite1EXPEN.jpg');   % The blue curve.
% Im2 = imread('HWhite1CHEAP.jpg');   % The red curve.
% norings = 50;

%% Input parameters
%
Im1 = imread(Im1);
Im2 = imread(Im2);

if nargin < 3
    norings = 50; % Default value.
end
    
%% Generate two square images cIm1 and cIm2 that have the same size
% Use the center of the images and if at least one of them is an RGB image 
% either convert to gray value or exit with an error message

[sr1, sc1, nc1] = size(Im1);
[sr2, sc2, nc2] = size(Im2);

% Variables to compare the images sizes.
newSr1 = sr1;
newSc1 = sc1;
newSr2 = sr2;
newSc2 = sc2;

% If one of them is an RGB image.
if nc1 == 3
    Im1 = rgb2gray(Im1);
%     imshow(Im1)  
elseif nc2 == 3 
    Im2 = rgb2gray(Im2);
%     imshow(Im2)
end

% Find which row or column that is the smallest for image 1.
if sr1 ~= sc1   % Not a square image.
    if sr1 > sc1
        newSr1 = sc1;
    elseif sr1 < sc1
        newSc1 = sr1;    
    end    
end    

% Find which row or column that is the smallest for image 1.
if sr2 ~= sc2    
    if sr2 > sc2
        newSr2 = sc2;
    elseif sr2 < sc2
        newSc2 = sr2;    
    end    
end   

% Im1 and Im2 are not of the same size, choose the height and width from
% the smaller image.
if sr1 ~= sr2 || sc1 ~= sc2
    if newSr1 < newSr2
        newSr2 = newSr1;
    elseif newSr1 > newSr2
        newSr1 = newSr2;
    end
    
    if newSc1 < newSc2
        newSc2 = newSc1;
    elseif newSc1 > newSc2
        newSc1 = newSc2;
    end
    
end

% Resize the image.
cIm1 = imresize(Im1, [newSr1, newSc1]);
cIm2 = imresize(Im2, [newSr2, newSc2]);

Profile1 = zeros(norings,1);
Profile2 = Profile1;

%% Now you have two gray value images of the size (square) size and you 
%   generate grid with the help of an axis vector ax that defines your
%   rings
%

%ax = ( : )
% or read the documentation of linspace
ax = linspace(-norings, norings, newSr1); % Generate a linearly spaced vector from -50 to 50 with newSr1 nr of values.

[C R] = meshgrid(ax); %Euclidean mesh. Replicates a grid with the size newSr1. Returns the arrays C and R.
[~,Rho] = cart2pol(C, R); %Polar coordinates comment on the ~ used. Turns it into cylindrical coordinates.
                          % Theta is not necessary so therefore the "~" is there.

% %% Do the actual calculations
for ringno = 1:norings
    RMask = ( (ringno-1) <= Rho & Rho < ringno); % Generate a mask describing the ring number ringno.
    nopixels = sum(RMask(:));% Compute the number of pixels in RMask
    pixsum = sum(cIm1(RMask));% Compute the sum over all pixel values in RMask in Im1
    Profile1(ringno) =  pixsum/nopixels; %Mean gray value of pixels i RMask
    pixsum = sum(cIm2(RMask));% Compute the sum over all pixel values in RMask in Im1% ... and now you do it for the second images
    Profile2(ringno) = pixsum/nopixels; %Mean gray value of pixels i RMask
end

%% Finally the normalization to max value one
%
Profile1 = Profile1/(max(Profile1));
Profile2 = Profile2/(max(Profile2));

% Comparing the vignetting properties.
plot(Profile1); 
hold on;
plot(Profile2,'r'); 

%% Extra question: How can you find out if Im1 is better than Im2?

% The closer to one the better the vignetting properties are. 
% The straighter the curve is the image has less vignetting.


end
