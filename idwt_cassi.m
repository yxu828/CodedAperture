function x_idwt_3iter = idwt_cassi(x_idct)

wname = 'sym8';
sx = size(zeros(480,640,8));

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
%     figure;imagesc(x_idwt_3iter(:,:,i))
end
