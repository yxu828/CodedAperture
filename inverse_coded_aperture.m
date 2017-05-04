function   y = inverse_coded_aperture(f)

mask = double(imread('CASSIMask.bmp'));

for i = 1:8
    skewed_cube(:,:,i) = circshift(mask .* f(:,:,i),[0 -(i-1)]);
end
y = sum(skewed_cube, 3);