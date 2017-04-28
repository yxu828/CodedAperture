close all
clear
clc

f = imread('msDataSet.tif');
mask = double(imread('CASSIMask.bmp'));
[m n] = size(f);

%%cassiInverseCodedAperture
for i = 1:8
    skewed_cube(:,:,i) = circshift(mask .* f(:,:,i),[0 i-1]);
end
y = sum(skewed_cube, 3);


%%cassiForwardCodedAperture
for i = 1:8
    recons_cube(:,:,i) = circshift(circshift(mask ,[0 i-1]).* y, [0 -(i-1)]);
end

%%reconstructed data cube error 
% imagesc(recons_cube(:,:,1)-f(:,:,1).* mask);

% recons_cube = imresize(recons_cube, [256, 256]);
%%dwt 
recons_cube = f;
sx = size(recons_cube);
wname = 'sym8';
% wname = 'sym4';
% wname = 'db2';
for i = 1:8
    [wa(:,:,i),wh(:,:,i),wv(:,:,i),wd(:,:,i)] = dwt2(recons_cube(:,:,i),wname, 'mode', 'per');
end
w1 = [wa, wh; wv, wd];
figure;imagesc(w1(:,:,1))


for i = 1:8
    [waa(:,:,i),whh(:,:,i),wvv(:,:,i),wdd(:,:,i)] = dwt2(wa(:,:,i),wname, 'mode', 'per');
end
w2 = [waa, whh; wvv, wdd];
figure;imagesc(w2(:,:,1))


for i = 1:8
    [waaa(:,:,i),whhh(:,:,i),wvvv(:,:,i),wddd(:,:,i)] = dwt2(waa(:,:,i),wname, 'mode', 'per');
end
w3 = [waaa, whhh; wvvv, wddd];
figure;imagesc(w3(:,:,1))

ww = [w3, whh; wvv, wdd];
w = [ww, wh; wv, wd];
figure;imagesc(w(:,:,1))


%%dct
x = dct(w,[], 3);
figure;imagesc(x(:,:,1))


%%idct
x_idct =  idct(x,[], 3);
figure;imagesc(x_idct(:,:,1))


%%idwt
% x_idwt =  idwt2(wa, wh, wv, wd, wname, sx);
% figure;imagesc(x_idwt(:,:,3))

for i = 1:8
    x_idwt_1iter(:,:,i) =  idwt2(x_idct(1:size(x_idct,1)/8, 1:size(x_idct,2)/8, i), x_idct(1:size(x_idct,1)/8, size(x_idct,2)/8+1:size(x_idct,2)/4, i), x_idct(size(x_idct,1)/8+1:size(x_idct,1)/4, 1:size(x_idct,2)/8, i ), x_idct(size(x_idct,1)/8+1:size(x_idct,1)/4, size(x_idct,2)/8+1:size(x_idct,2)/4, i), wname, [sx(1)/4, sx(2)/4]);
%     figure;imagesc(x_idwt_1iter(:,:,i))
end


for i = 1:8
    x_idwt_2iter(:,:,i)  =  idwt2(x_idwt_1iter(:,:,i), x_idct(1:size(x_idct,1)/4, size(x_idct,2)/4+1:size(x_idct,2)/2, i), x_idct(size(x_idct,1)/4+1:size(x_idct,1)/2, 1:size(x_idct,2)/4, i ), x_idct(size(x_idct,1)/4+1:size(x_idct,1)/2, size(x_idct,2)/4+1:size(x_idct,2)/2), wname, [sx(1)/2, sx(2)/2]);
%     figure;imagesc(x_idwt_2iter(:,:,i))
end


for i = 1:8
    x_idwt_3iter(:,:,i) =  idwt2(x_idwt_2iter(:,:,i), x_idct(1:size(x_idct,1)/2, size(x_idct,2)/2+1:size(x_idct,2), i), x_idct(size(x_idct,1)/2+1:size(x_idct,1), 1:size(x_idct,2)/2, i ), x_idct(size(x_idct,1)/2+1:size(x_idct,1), size(x_idct,2)/2+1:size(x_idct,2)), wname, [sx(1), sx(2)]);
    figure;imagesc(x_idwt_3iter(:,:,i))
end





