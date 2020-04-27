%------------------- FILE: capture.m -------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes a picture with the camera using 
% specified properties with laser and saves it on the 
% computer. (specific location!)
%   INPUT:
%   filename - chosen filename for the saved file
%   expotime - exposure time
% Output used in run_speckle.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function capture(filename,expotime)
% Prepare camera
clear vid
clear src
% Specify location of saved file
destination = 'C:\Users\LSI\Documents\MATLAB\';

% Specify camera settings
vid = videoinput('pointgrey', 1, 'F7_Mono8_2080x1080_Mode8');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;   % set number of images to 1
src.Shutter = expotime;     % set exposuretime to input value

% Take a picture and save it
start(vid);
str1 = sprintf('%s%s.mat',destination, filename);
w_laser = getdata(vid);
save(str1, 'w_laser');

end
