 function idwtima = idwt2_3level_yu(ima)

LoD = [  -0.00338242,  -0.00054213,   0.03169509,   0.00760749,  -0.14329424,  -0.06127336,   0.48135965,   0.77718575,   0.36444189,  -0.05194584,  -0.02721903,   0.04913718,   0.00380875,  -0.01495226,  -0.00030292,   0.00188995 ];
HiD = [  -0.00188995,  -0.00030292,   0.01495226,   0.00380875,  -0.04913718,  -0.02721903,   0.05194584,   0.36444189,  -0.77718575,   0.48135965,   0.06127336,  -0.14329424,  -0.00760749,   0.03169509,   0.00054213,  -0.00338242 ];
LoR = [   0.00188995,  -0.00030292,  -0.01495226,   0.00380875,   0.04913718,  -0.02721903,  -0.05194584,   0.36444189,   0.77718575,   0.48135965,  -0.06127336,  -0.14329424,   0.00760749,   0.03169509,  -0.00054213,  -0.00338242 ];
HiR = [  -0.00338242,   0.00054213,   0.03169509,  -0.00760749,  -0.14329424,   0.06127336,   0.48135965,  -0.77718575,   0.36444189,   0.05194584,  -0.02721903,  -0.04913718,   0.00380875,   0.01495226,  -0.00030292,  -0.00188995 ];

% ima = imread('msDataSet.tif');

% level 1

newimax = zeros(size(ima));
offset = size(ima, 2)/8;
rangeLimit = size(ima, 2);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)/4
        for j = 1:size(ima, 2)/4
            iterB = mod(j, 2);
            for m = -4:3
                if (floor(j/2) -2*m< rangeLimit && floor(j/2) -2*m >0 && floor(j/2) + offset - 2*m < rangeLimit && floor(j/2) + offset - 2*m> 0)
                    newimax(i,j,k) = newimax(i,j,k) + LoR(m*2 + 8 +1 +iterB) * ima(i, floor(j/2) -2*m, k);
                    newimax(i,j,k) = newimax(i,j,k) + HiR(m*2 + 8 +1 +iterB) * ima(i, floor(j/2) + offset - 2*m, k);
                end
            end
        end
    end    
end
% figure;imagesc(newimax(:,:,1))


newimay = zeros(size(ima));
offset = size(ima, 1)/8;
rangeLimit = size(ima, 1);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)/4
        for j = 1:size(ima, 2)/4
            iterB = mod(j, 2);
            for m = -4:3
%                 i  = i -1;
                if (floor(i/2) - m< rangeLimit && floor(i/2) - m >0 && floor(i/2) + offset - m < rangeLimit && floor(i/2) + offset - m > 0)
                    newimay(i,j,k) = newimay(i,j,k) + LoR(m*2 + 8 +1 +iterB) * newimax(floor(i/2) - m , j, k);
                    newimay(i,j,k) = newimay(i,j,k) + HiR(m*2 + 8 +1 +iterB) * newimax(floor(i/2) + offset - m , j, k);
                end
            end
        end
    end    
end
% figure;imagesc(newimay(:,:,1))


% level 2
newima = ima;
newima(1:size(ima,1)/4,1:size(ima,2)/4,:) = newimay(1:size(ima,1)/4,1:size(ima,2)/4,:);
newimax = zeros(size(ima));
offset = size(ima, 2)/4;
rangeLimit = size(ima, 2);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)/2
        for j = 1:size(ima, 2)/2
            iterB = mod(j, 2);
            for m = -4:3
                if (floor(j/2) -2*m< rangeLimit && floor(j/2) -2*m >0 && floor(j/2) + offset - 2*m < rangeLimit && floor(j/2) + offset - 2*m> 0)
                    newimax(i,j,k) = newimax(i,j,k) + LoR(m*2 + 8 +1 +iterB) * newima(i, floor(j/2) -2*m, k);
                    newimax(i,j,k) = newimax(i,j,k) + HiR(m*2 + 8 +1 +iterB) * newima(i, floor(j/2) + offset - 2*m, k);
                end
            end
        end
    end    
end
% figure;imagesc(newimax(:,:,1))


newimay = zeros(size(ima));
offset = size(ima, 1)/4;
rangeLimit = size(ima, 1);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)/2
        for j = 1:size(ima, 2)/2
            iterB = mod(j, 2);
            for m = -4:3
%                 i  = i -1;
                if (floor(i/2) - m< rangeLimit && floor(i/2) - m >0 && floor(i/2) + offset - m < rangeLimit && floor(i/2) + offset - m > 0)
                    newimay(i,j,k) = newimay(i,j,k) + LoR(m*2 + 8 +1 +iterB) * newimax(floor(i/2) - m , j, k);
                    newimay(i,j,k) = newimay(i,j,k) + HiR(m*2 + 8 +1 +iterB) * newimax(floor(i/2) + offset - m , j, k);
                end
            end
        end
    end    
end
% figure;imagesc(newimay(:,:,1))


% level 3
newima = ima;
newima(1:size(ima,1)/2,1:size(ima,2)/2,:) = newimay(1:size(ima,1)/2,1:size(ima,2)/2,:);
newimax = zeros(size(ima));
offset = size(ima, 2)/2;
rangeLimit = size(ima, 2);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)
        for j = 1:size(ima, 2)
            iterB = mod(j, 2);
            for m = -4:3
                if (floor(j/2) -2*m< rangeLimit && floor(j/2) -2*m >0 && floor(j/2) + offset - 2*m < rangeLimit && floor(j/2) + offset - 2*m> 0)
                    newimax(i,j,k) = newimax(i,j,k) + LoR(m*2 + 8 +1 +iterB) * newima(i, floor(j/2) -2*m, k);
                    newimax(i,j,k) = newimax(i,j,k) + HiR(m*2 + 8 +1 +iterB) * newima(i, floor(j/2) + offset - 2*m, k);
                end
            end
        end
    end    
end
% figure;imagesc(newimax(:,:,1))


newimay = zeros(size(ima));
offset = size(ima, 1)/2;
rangeLimit = size(ima, 1);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)
        for j = 1:size(ima, 2)
            iterB = mod(j, 2);
            for m = -4:3
%                 i  = i -1;
                if (floor(i/2) - m< rangeLimit && floor(i/2) - m >0 && floor(i/2) + offset - m < rangeLimit && floor(i/2) + offset - m > 0)
                    newimay(i,j,k) = newimay(i,j,k) + LoR(m*2 + 8 +1 +iterB) * newimax(floor(i/2) - m , j, k);
                    newimay(i,j,k) = newimay(i,j,k) + HiR(m*2 + 8 +1 +iterB) * newimax(floor(i/2) + offset - m , j, k);
                end
            end
        end
    end    
end
 figure;imagesc(newimay(:,:,1))

idwtima = newimay;

