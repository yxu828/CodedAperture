function newima = dwt2_yu(ima)

LoD = [  -0.00338242,  -0.00054213,   0.03169509,   0.00760749,  -0.14329424,  -0.06127336,   0.48135965,   0.77718575,   0.36444189,  -0.05194584,  -0.02721903,   0.04913718,   0.00380875,  -0.01495226,  -0.00030292,   0.00188995 ];
HiD = [  -0.00188995,  -0.00030292,   0.01495226,   0.00380875,  -0.04913718,  -0.02721903,   0.05194584,   0.36444189,  -0.77718575,   0.48135965,   0.06127336,  -0.14329424,  -0.00760749,   0.03169509,   0.00054213,  -0.00338242 ];
LoR = [   0.00188995,  -0.00030292,  -0.01495226,   0.00380875,   0.04913718,  -0.02721903,  -0.05194584,   0.36444189,   0.77718575,   0.48135965,  -0.06127336,  -0.14329424,   0.00760749,   0.03169509,  -0.00054213,  -0.00338242 ];
HiR = [  -0.00338242,   0.00054213,   0.03169509,  -0.00760749,  -0.14329424,   0.06127336,   0.48135965,  -0.77718575,   0.36444189,   0.05194584,  -0.02721903,  -0.04913718,   0.00380875,   0.01495226,  -0.00030292,  -0.00188995 ];

ima = imread('msDataSet.tif');
% newima = ima;
newimax = zeros(size(ima));
offset = 0;
rangeLimit = size(ima, 2);
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)
        for j = 1:size(ima, 2)
            indx = 2 * (j - offset);
            for m = -7:8
                if (indx - m < rangeLimit && indx - m >0 )
                    newimax(i,j,k) = newimax(i,j,k) + LoD(m + 8) * ima(i, indx - m, k);
                end
            end
        end
    end    
end
imagesc(newimax(:,:,1))


offset = size(ima, 2)/2; 
for k = 1: size(ima, 3)
    for i = 1:size(ima, 1)
        for j = 1:size(ima, 2)
            indx = 2 * (j - offset);
            for m = -7:8
                if  (indx - m < rangeLimit && indx - m >0 )
                    newimax(i,j,k) = newimax(i,j,k)+ HiD(m + 8) * ima(i, indx - m, k);
                end
            end
        end
    end    
end
imagesc(newimax(:,:,1))


offset = 0; 
newimay = zeros(size(ima));
rangeLimit = size(ima, 1);
for k = 1: size(ima, 3)
    for j = 1:size(ima, 2) 
        for i = 1:size(ima, 1)
            indy = 2 * (i - offset);
            for m = -7:8
                if  (indy - m < rangeLimit && indy - m >0 )
                    newimay(i,j,k) = newimay(i,j,k) + LoD(m + 8) * newimax(indy - m, j, k);
                end
            end
        end
    end    
end
figure;imagesc(newimay(:,:,1))

offset = size(ima, 1)/2;  
for k = 1: size(ima, 3)
    for j = 1:size(ima, 2)
        for i = 1:size(ima, 1)
            indy = 2 * (i - offset);
            for m = -7:8
                if  (indy - m < rangeLimit && indy - m >0 )
                    newimay(i,j,k) = newimay(i,j,k) + HiD(m + 8) * newimax(indy - m, j, k);
                end
            end
        end
    end    
end
figure;imagesc(newimay(:,:,1))






