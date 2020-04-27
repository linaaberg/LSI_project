%--------------- FILE: roll_algorithm.m ----------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that calculates the contrast in an image using
% a specific kernel size. Theory and steps collected from
% article: W.J Tom, et al: 
% 'Efficient Processing of Laser Speckle Contrast Images'
%   INPUT:
%   speckle_image - image captured with laser
%   calibration_image - image captured without laser
%   w - kernel size
%   OUTPUT:
%   K - contrast image
%   I - mean intensity image
% Output used in run_speckle.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K, I] = roll_algorithm(speckle_image, calibration_image, w)
%Calibration step
IM = speckle_image - calibration_image;
IM = double(IM);
%Variables
st = size(IM);
n = st(2);
m =st(1);
SumMa = zeros(m-w+1,n);
SqSumMa = zeros(m-w+1,n);

%Step 1
SumAc = IM(1,:);
SqSumAc = SumAc.*SumAc;
for i = 2:w 
    SumAc = SumAc+IM(i,:);
    SqSumAc = SqSumAc+(IM(i,:).*IM(i,:));
end

%Step 2
SumMa(1,1:n) = SumAc;
SqSumMa(1,1:n) = SqSumAc;
for i = w+1:m
    SumAc = SumAc-IM(i-w,1:n)+IM(i,1:n);
    SqSumAc = SqSumAc-(IM(i-w,1:n).*IM(i-w,1:n))+(IM(i,1:n).*IM(i,1:n));
    SumMa(i-w+1,1:n) = SumAc;
    SqSumMa(i-w+1,1:n) = SqSumAc;
end

%Step 3
SumAc = SumMa(:,1);
SqSumAc = SqSumMa(:,1);
for j = 2:w
    SumAc = SumAc+SumMa(:,j);
    SqSumAc = SqSumAc+SqSumMa(:,j);
end

%Step 4
for j = w+1:n
    B = SumAc;
    SqB = SqSumAc;
    SumAc = SumAc-SumMa(:,j-w)+SumMa(:,j);
    SqSumAc = SqSumAc-SqSumMa(:,j-w)+SqSumMa(:,j);
    SumMa(:,j-w) = B;
    SqSumMa(:,j-w) = SqB;
end
SumMa(:,n-w+1) = SumAc;
SqSumMa(:,n-w+1) = SqSumAc;

%Step 5
K = zeros(m-w+1,n-w);
for i = 1:m-w+1
    for j = 1:n-w+1
        K(i,j) = sqrt(((w^2*SqSumMa(i,j))-(SumMa(i,j)^2))/(w^2*(w^2-1)))/(SumMa(i,j)/w^2);
    end
end
I = SumMa./w^2;
I = I(:,1:n-w);  

end


