function sfunction = Sharpness(FStack)
%TNM087Template General Template for TNM087 Lab Tasks
%   Everybody has to use this template
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
% Input arguments: In1, In2 are the input variables defined in the
%   lab-document
% Output arguments: Out1, Out2 output variables defined in the lab-document
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 151230
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

%% Size of images and number of images
%

% DEBUG
%FStack = load('AutoFocus32x32Patches.mat'); % Load FStack. 192 images.
FStack = FStack.winsuint8;

[sx,sy,noimages] = size(FStack);

%% Generate a grid, convert the Euclidean to polar coordinates
%

% Create index vectors in each direction.
ir = [1:sx];
ic = [1:sy];

cx = ir - sx/2; %- 0.5;
cy = ic - sy/2; %- 0.5;

[X, Y] = meshgrid(cx, cy);
[TH,R] = cart2pol(X, Y);    

%% Number of COMPLETE rings in the Fourier domain 
% ignore the points in the corners

norings = 8; %Change this if you want. Number of rings.
radius = sx/2;  % Width/2

% RQ = %this is the quantized version of R where 
% the pixel value is the index of the ring 
% (origin = 0, and the point (0,r(Radie)) has index norings...
RQ = floor((R/radius*norings)+1); % Floor to round down. Plus 1 for preventing zero index.

maxindex = max(RQ(:));
%% Number of grid points in each ring

ptsperring = zeros(norings,1);          % 8x1.
for ringno = 1:norings                  % 1:8.
    Rmask = (RQ == ringno);             % Rmask is true where RQ equals ringno.
    ptsperring(ringno) = sum(Rmask(:)); % Sums the nr of grid points per ring.
end

%% Sum of fft magnitude per image - per ring

absfftsums = zeros(noimages, norings); % (noimages, maxindex) stod det först, men har ändrat. Nu ignorerar kanterna där tex ring 11,10, 9 finns.
padding = 4;
RQ = padarray(RQ, [padding, padding]);    % Pad RQ to allow multiplication with padimage (the padded image) below. 

for imno = 1:noimages
    padimage = padarray(FStack(:,:,imno), [padding, padding]);% Pad the image to allow the use of a larger FFT.
    ftplan = fft2(padimage);    % 2D fft.
    cftplan = fftshift(ftplan); % Move origin to the center.
    cftplan = abs(cftplan);     % Absolute value.
    
    % Normalize.
    cftplan = cftplan./max(cftplan(:));
 
    % Calculate the 8 rings in the 192 pictures.
    for ringno = 1:norings
        % this is a logical array defining the ring.
        Rmask = (RQ == ringno);
        % Average over Fourier magnitude in ring. Mean value by division by
        % the nr of rings at ringno position.
        absfftsums(imno,ringno) = (sum(  (sum(cftplan.*Rmask))) ) / ptsperring(ringno); 
    end
    
    
end
%% Compute weighted average over the ring sums
%
meanfreqcontent = zeros(noimages,1);
w = 1:norings;  % The weight. New code 151230.

for imno = 1:noimages   
    meanfreqcontent(imno) = sum( w.*absfftsums(imno,w) );   % New code 151230.
end
figure
plot(meanfreqcontent)

%% Requested result
% default solution but you can invent something else if you want
sfunction = meanfreqcontent;

end
