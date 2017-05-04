% This demo shows the reconstruction of a 3D datacube by solving a LASSO
% problem in DWT/DCT domain 

% close all
% clear


% read the ideal 3D datacube
f = imread('msDataSet.tif');
mask = double(imread('CASSIMask.bmp'));
[m n] = size(f);

scrsz = get(0,'ScreenSize');
figure(1)
set(1,'Position',[10 scrsz(4)*0.05 scrsz(3)/4 0.85*scrsz(4)])
subplot(4,1,1)
imagesc(f(:,:,1))
axis off
axis equal
title('Ideal datacube','FontName','Times','FontSize',11)


% from the ideal 3D datacube f to monochrome image y 
y = inverse_coded_aperture(f);

% from the monochrome image y to reconstructed 3D datacube
recons_cube = forward_coded_aperture(y);
% figure;imagesc(f(:,:,1) - recons_cube(:,:,1)); 
% maxerror = max(max(abs(f(:,:,1) - recons_cube(:,:,1))))
% sumerror = sum(sum((f(:,:,1) - recons_cube(:,:,1)).^2))


% show the reconstructed datacube error for debug
% y_compared = inverse_coded_aperture(recons_cube);
% figure;imagesc(y - y_compared); max(max(abs(y - y_compared)))

% for debug 
% afterDWT = dwt_cassi(f);
% afterDCT = dct(afterDWT,[],3);
for i = 1:8
    for j = 1:8
        if (i == 1)
            coeff(i,j) = sqrt(1/8)*cos((i-1)*pi* (2*(j-1)+1)/16 ) ;
        else 
            coeff(i,j) = sqrt(2/8)*cos((i-1)*pi* (2*(j-1)+1)/16 ) ;
        end
    end    
end

% end debug


figure(1)
subplot(4,1,2)
imagesc(y)
axis off
axis equal
title('Reconstructed datacube from monochrome image','FontName','Times','FontSize',11)



% inverse coded aperture function handle
inverse_coded_aperture_handle = @(x) inverse_coded_aperture(x);
% forward coded aperture function handle
forward_coded_aperture_handle = @(x) forward_coded_aperture(x);

% 3 level dwt transformation in spatial domain  
dwt_cassi_handle = @(x) dwt_cassi(x);
% 3 level inverse dwt transformation in spatial domain  
idwt_cassi_handle = @(x) idwt_cassi(x);

% dct transformation in wavelength domain  
dct_cassi_handle = @(x) dct(x,[],3);
% inverse dct transformation in wavelength domain  
idct_cassi_handle = @(x) idct(x,[],3);

% define the function handles for GPSR_BB
W = @(x) idwt_cassi_handle(idct_cassi_handle(x));
WT = @(x) dct_cassi_handle(dwt_cassi_handle(x));



% finally define the function handles that compute 
% AT forward transformation  y -(coded aperture)-datacube -(dwt,dct)--coefficient 
% A inverse transformation  coefficient -(idct, idwt)-datacube -(inverse coded aperture)--y 
A = @(x) inverse_coded_aperture_handle(idwt_cassi_handle(idct_cassi_handle(x)));
AT = @(x) dct_cassi_handle((dwt_cassi_handle(forward_coded_aperture_handle(x))));

% for debug from y -datacube- x -datacube- y
 reconst_monochrome = A(AT(y));
 figure;imagesc(reconst_monochrome)
 
 test = (WT(f));
 test = W(WT(f));
 figure;imagesc(test(:,:,1))
 figure;imagesc(test(:,:,1)-f(:,:,1))
 

% grouth truth and initialization for GPSR_BB
grtruth = dct_cassi_handle((dwt_cassi_handle(f))); 
Initialization = AT(y);

figure(1)
subplot(4,1,3)
imagesc(Initialization(:,:,1))
axis off
axis equal
title('Initialization','FontName','Times','FontSize',11)



% regularization parameter
tau = 0.35;
% set tolA
% tolA =0.5;
tolA = 1.e-2;


% Now, run the GPSR functions, until they reach the StopCriterion 1 based on the relative
% variation of the objective function, namely (abs(f-prev_f)/(prev_f)> tolA).
[theta1,theta_debias,obj_QP_BB_mono,times_QP_BB_mono,debias_start,mses_QP_BB_mono]= ...
	GPSR_BB(y,A,tau,...
	'AT', AT,...
	'Debias',0,...
	'Initialization', AT(y),...
    'True_x',WT(f),...
	'Monotone',1,...
	'StopCriterion',1,...
	'ToleranceA',tolA);

% % notmono version 
% [theta2,theta_debias,obj_QP_BB_notmono,times_QP_BB_notmono,debias_s,mses_QP_BB_notmono]= ...
% 	GPSR_BB(y,A,tau,...
% 	'AT', AT,...
% 	'Debias',0,...
% 	'Initialization', AT(y),...
%     'True_x',WT(f),...
% 	'Monotone',0,...
% 	'StopCriterion',1,...
% 	'ToleranceA',tolA);


% Now, run the GPSR functions, until they reach the StopCriterion 4 until objective 
% function reached target value obj_value.
% obj_value = ;
% [theta,theta_debias,obj_QP_BB_mono,times_QP_BB_mono,debias_start,mses_QP_BB_mono]= ...
% 	GPSR_BB(y,A,tau,...
% 	'AT', AT,...
% 	'Debias',0,...
% 	'Initialization', AT(y),...
%     'True_x',WT(f),...
% 	'Monotone',1,...
% 	'StopCriterion',1,...
% 	'ToleranceA',obj_value);


% ================= Plotting results ==========
figure(1)
subplot(4,1,4)
result = W(theta1);
imagesc(result(:,:,1))
axis off
axis equal
title('Final datacube','FontName','Times','FontSize',11)
  

figure(2)
scrsz = get(0,'ScreenSize');
lft = 0.55*scrsz(3)-10;
btm = 0.525*scrsz(4);
wdt = 0.45*scrsz(3);
hgt = 0.375*scrsz(4);

set(2,'Position',[lft btm wdt hgt])
plot(obj_QP_BB_mono,'b','LineWidth',1.8);
hold on
% plot(obj_QP_BB_notmono,'r--','LineWidth',1.8);
hold off
leg = legend('GPSR-BB monotone','GPSR-BB non-monotone','GPSR-Basic')
v = axis;
if debias_start ~= 0
   line([debias_start,debias_start],[v(3),v(4)],'LineStyle',':')
   text(debias_start+0.01*(v(2)-v(1)),...
   v(3)+0.8*(v(4)-v(3)),'Debiasing')
end
ylabel('Objective function','FontName','Times','FontSize',16)
xlabel('Iterations','FontName','Times','FontSize',16)

set(leg,'FontName','Times')
set(leg,'FontSize',16)
set(gca,'FontName','Times')
set(gca,'FontSize',16)



figure(3)

scrsz = get(0,'ScreenSize');
lft = 0.55*scrsz(3)-10;
btm = 0.045*scrsz(4);
wdt = 0.45*scrsz(3);
hgt = 0.375*scrsz(4);

set(3,'Position',[lft btm wdt hgt])
plot(times_QP_BB_mono,mses_QP_BB_mono,'b','LineWidth',1.8);
hold on
% plot(times_QP_BB_notmono,mses_QP_BB_notmono,'r--','LineWidth',1.8);
hold off
leg = legend('GPSR-BB monotone','GPSR-BB non-monotone','GPSR-Basic')
v = axis;
if debias_start ~= 0
   line([debias_start,debias_start],[v(3),v(4)],'LineStyle',':')
   text(debias_start+0.01*(v(2)-v(1)),...
   v(3)+0.8*(v(4)-v(3)),'Debiasing')
end
ylabel('Deconvolution MSE','FontName','Times','FontSize',16)
xlabel('CPU time (seconds)','FontName','Times','FontSize',16)

set(leg,'FontName','Times')
set(leg,'FontSize',16)
set(gca,'FontName','Times')
set(gca,'FontSize',16)
    

figure(4)
imagesc([f(:,:,1) result(:,:,1)])


