function CImage = WhitePoint(OImage,type)
%WhitePoint Type conversion and white point correction
%   Convert OImage to an image with specified white point
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
% Input arguments:  OImage original image of type uint8, uint16 or double
%                   type: character variable describing type of CImage,
%                       values are 'b' (uint8), 's' (uint16), 'd' (double) 
% Output arguments: CImage color corrected image
%
%   The MINIMUM solution must be able to handle an uint16 OImage and an uint8 CImage 
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 151124
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
OImage = imread(OImage);

%% The default output type is uint8 
% More information about handling of function arguments, string
% manipulation and basic data types can be found in WhitePoint.pdf
%

if (nargin < 2) % Nargin is a built in function,counts the nr of input arguments.
    otype = 'b'; % b = uint8, s = uint16, d = double
else
    if strcmp(type,'b') % strcmp = returns true if the strings are identical.
        otype = 'b';
    else
        otype = 'd';
    end
end;

% The type of the output image is either uint8 (type 'b') or double (type 'd') 
    
%% Find out the type of the input image
% You can assume that it is either uint8 or double
%
    if isa(OImage,'uint8') % isa(obj,ClassName) returns true if obj is an instance of the class specified by ClassName,
        InputImage = im2double(OImage); % convert to double
    else
        InputImage = OImage; % else fortsätter vara en double.
    end

%% Display the input image and pick the white point

fh = figure;
imshow(OImage); % display the input image 

whitept = uint8(ginput(1)); % select the point that should be white

rgbvec = zeros(1,3);
rgbvec(1,:) = OImage(whitept(1,1), whitept(1,2), :);
rgbvec = squeeze(rgbvec); % This is the RGB vector at the point you selected

%% Generate the result image CImage
switch otype
    case 'b' % uint8
        CImage = OImage; % Eller  = InputImage ???? Blir samma nedan?
        rgbvec = uint8(rgbvec);
    case 'd' % double
        CImage = InputImage; % eller "im2double(OImage);" för typ samma sak? 
        rgbvec = im2double(rgbvec);
    otherwise 
%         if you do the extended version add your code here
end

%% Scaling of CImage such that the pixel at whitept is
% (maxpix,maxpix,maxpix)
% where maxpix is the maximum value in a channel which depends on the 
% type of the resulting CImage (see otype)
rValue = double(rgbvec(1,1));
gValue = double(rgbvec(1,2));
bValue = double(rgbvec(1,3));

% Normalize.
rScale = double(rValue/255);
gScale = double(gValue/255);
bScale = double(bValue/255);

% Also truncate pixel values greater than maxpix to maxpix.
% Here you need several lines of code where rgbvec defines the scaling
% after the scaling you have to truncate the pixel values
% Finally you have to convert the result to the datatype given by otype
 
redChannel = double(CImage(:,:,1));
greenChannel = double(CImage(:,:,2));
blueChannel = double(CImage(:,:,3));

% Truncate
redChannel(redChannel > rValue) = rValue;
greenChannel(greenChannel > gValue) = gValue;
blueChannel(blueChannel > bValue) = bValue;

% Scale the previous white values to real white value of 255.
redChannel = redChannel./rScale;
greenChannel = greenChannel./gScale;
blueChannel = blueChannel./bScale;

% Write over the old RGB channels with the new ones. 
CImage(:,:,1) = redChannel;
CImage(:,:,2) = greenChannel;
CImage(:,:,3) = blueChannel;

% Show image.
figure
imshow(CImage)

%% Cleaning
%close(fh)


end
