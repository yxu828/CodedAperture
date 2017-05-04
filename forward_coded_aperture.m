function  recons_cube = forward_coded_aperture(monochrome)

mask = double(imread('CASSIMask.bmp'));

% build 3D mask cube
for i = 1:8
    maskdatacube(:,:,i) = mask;
end
%figure;imagesc(maskdatacube(:,:,1))

for i = 1:8
    skewed_maskcube(:,:,i) = circshift( maskdatacube(:,:,i),[0 -(i-1)]);
end
y = sum(skewed_maskcube, 3);
% figure;imagesc(y)

% build weighting matrix
weig = y;
for i = 1:size(y,1)
    for j = 1:size(y,2) 
        if (y(i,j) ~=0 )
            weig(i,j )= 1/y(i,j);
        end
    end
end
% figure;imagesc(weig)

for i = 1:8
    recons_cube(:,:,i) = circshift(monochrome .* weig .* skewed_maskcube(:,:,i), [0 (i-1)]); 
end
% figure;imagesc(recons_cube(:,:,1))

