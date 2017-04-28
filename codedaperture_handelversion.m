close all
clear
clc

f = imread('msDataSet.tif');
mask = double(imread('CASSIMask.bmp'));
[m n] = size(f);

%%cassiInverseCodedAperture
% for i = 1:8
%     skewed_cube(:,:,i) = circshift(mask .* f(:,:,i),[0 i-1]);
% end
% y = sum(skewed_cube, 3);

y = inverse_coded_aperture(f);

%%cassiForwardCodedAperture
% for i = 1:8
%     recons_cube(:,:,i) = circshift(circshift(mask ,[0 i-1]).* y, [0 -(i-1)]);
% end
recons_cube = forward_coded_aperture(y);

%%reconstructed data cube error 
% imagesc(recons_cube(:,:,1)-f(:,:,1).* mask);
% 
% %%dwt 

inverse_coded_aperture_handle = @(x) inverse_coded_aperture(x);

forward_coded_aperture_handle = @(x) forward_coded_aperture(x);


dwt_cassi_handle = @(x) dwt_cassi(x);
idwt_cassi_handle = @(x) idwt_cassi(x);


dct_cassi_handle = @(x) dct(x,[],3);
idct_cassi_handle = @(x) idct(x,[],3);

W = @(x) idwt_cassi_handle(idct_cassi_handle(x));
WT = @(x) dct_cassi_handle(dwt_cassi_handle(x));



%Finally define the function handles that compute 
% AT forward transformation  y -(coded aperture)-datacube -(dwt,dct)--coefficient 
% A inverse transformation  coefficient -(idct, idwt)-datacube -(inverse coded aperture)--y 
A = @(x) inverse_coded_aperture_handle(idwt_cassi_handle(idct_cassi_handle(x)));
AT = @(x) dct_cassi_handle((dwt_cassi_handle(forward_coded_aperture_handle(x))));


grtruth = dct_cassi_handle((dwt_cassi_handle(f))); 
Initialization = AT(y);


% regularization parameter
tau = 1.35;

% set tolA
tolA = 1.e-2;

% Now, run the GPSR functions, until they reach the same value 
[theta,theta_debias,obj_QP_BB_mono,times_QP_BB_mono,debias_start,mses_QP_BB_mono]= ...
	GPSR_BB(y,A,tau,...
	'AT', AT,...
	'Debias',0,...
	'Initialization', AT(y),...
    'True_x',WT(f),...
	'Monotone',1,...
	'StopCriterion',1,...
	'ToleranceA',tolA);

