function w = dwt_cassi(recons_cube)

wname = 'sym8';
% sx = size(recons_cube);
sx = size(zeros(480,640,8));

for i = 1:8
    [wa(:,:,i),wh(:,:,i),wv(:,:,i),wd(:,:,i)] = dwt2(recons_cube(:,:,i),wname, 'mode', 'per');
end
w1 = [wa, wh; wv, wd];
% figure;imagesc(w1(:,:,1))


for i = 1:8
    [waa(:,:,i),whh(:,:,i),wvv(:,:,i),wdd(:,:,i)] = dwt2(wa(:,:,i),wname, 'mode', 'per');
end
w2 = [waa, whh; wvv, wdd];
% figure;imagesc(w2(:,:,1))


for i = 1:8
    [waaa(:,:,i),whhh(:,:,i),wvvv(:,:,i),wddd(:,:,i)] = dwt2(waa(:,:,i),wname, 'mode', 'per');
end
w3 = [waaa, whhh; wvvv, wddd];
% figure;imagesc(w3(:,:,1))

ww = [w3, whh; wvv, wdd];
w = [ww, wh; wv, wd];
% figure;imagesc(w(:,:,1))
