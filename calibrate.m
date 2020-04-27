%------------------ FILE: calibrate.m ------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that takes a calibration picture with the camera 
% using specified properties without laser and saves it on 
% the computer. (specific location!)
%   INPUT:
%   expotime - exposure time
% Output used in run_speckle.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calibrate(expotime)
% Prepare camera
clear vid
clear src
% Specify filename and location of saved file
filename = 'cal_image';
destination = 'C:\Users\LSI\Documents\MATLAB\';

% Specify camera settings
vid = videoinput('pointgrey', 1, 'F7_Mono8_2080x1080_Mode8');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;       % set number of images to 1
src.Shutter = expotime;         % set exposuretime to input value

% Take a picture and save it
start(vid);
str1 = sprintf('%s%s.mat',destination, filename);
wo_laser = getdata(vid);
save(str1, 'wo_laser');

end
