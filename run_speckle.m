%----------------- FILE: run_speckle.m -----------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that processes an image with the LSI-method
% using minimum and maximum contrast as input values.
%   INPUT:
%   w_laser - an image taken with laser (capture.m)
%   wo_laser - an image without laser for calibration
%   w - kernel size (here, maximum 9 pixels)
%   min_contrast - calibration value for minimum contrast
%   max_contrast - calibration value for maximum contrast
%   OUTPUT:
%   IM - processed and downsampled image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IM] = run_speckle(w_laser, wo_laser, w, min_contrast, max_contrast)
%Load necessary images and values
if w > 9
    w = 9;
end
speckle_image = load(w_laser);
back_calibration_image = load(wo_laser);
% Calculate the contrast
[contrast_image, mean_intencity_image] = roll_algorithm(speckle_image.w_laser, back_calibration_image.wo_laser, w);
%Calibrating with mean of homogeneous contrast
calibrated_contrast_image = contrast_image - min_contrast;
calibrated_contrast_image = calibrated_contrast_image./(max_contrast-min_contrast); %add milk calibration
%Removing low intencity/high contrast pixles, areas around the hand
calibrated_contrast_image(calibrated_contrast_image < 0) = 1;
%Calucating the perfusion
IM = 1./calibrated_contrast_image - 1;
IM(mean_intencity_image < 25) = 0; 
IM = imgaussfilt(IM);
% Downsampling the resulting image
IM = downsample(IM, 4);
IM = downsample(IM', 4);
IM = IM';
end

