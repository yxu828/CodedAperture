
function  recons_cube = forward_coded_aperture(y)



mask = double(imread('CASSIMask.bmp'));

for i = 1:8

    recons_cube(:,:,i) = circshift(circshift(mask ,[0 i-1]).* y, [0 -(i-1)]);

end