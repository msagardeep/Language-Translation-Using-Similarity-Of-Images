function [closestMatches] = hist_hsv_test(databaseDirectory)

test_obj_names = [databaseDirectory, 'Img_Spanish\*.jpg'];

db_test_objs = dir(test_obj_names);
test_objs = {};
for i=1:length(db_test_objs)
    test_objs{i} = [databaseDirectory,'Img_Spanish\',db_test_objs(i).name];    
end

%choosing the value of bins
bins=1000;

hsv_hist_test = rand(length(test_objs),bins);
hsv_hist_test = hsv_hist_test .*0;
% computing hue-saturation-value color histogram for the training set
for k = 1:length(test_objs)
    I = imread(test_objs{k});
    I = imresize(I, [32 32]);
    if(size(I,3)==3)
        I = rgb2hsv(im2double(I));
        H = I(:,:,1);
        S = I(:,:,2);
        V = I(:,:,3);

        maxH = max(H(:));
        maxS = max(S(:));
        maxV = max(V(:));

        intvH = maxH/10;
        intvS = maxS/10;
        intvV = maxV/10;

        for i=1:32
            for j=1:32
                I(i,j,1);
                I(i,j,2);
                I(i,j,3);
                h_bin = uint32(I(i,j,1) / intvH) + 1;
                s_bin = uint32(I(i,j,2) / intvS) + 1;
                v_bin = uint32(I(i,j,3) / intvV) + 1;
                if(h_bin > 10)
                    h_bin = 10;
                end
                if(s_bin > 10)
                    s_bin = 10;
                end
                if(v_bin > 10)
                    v_bin = 10;
                end
                hsv_hist_test(k,(((h_bin-1)*100) + ((s_bin-1)*10) + v_bin)) = hsv_hist_test(k,(((h_bin-1)*100) + ((s_bin-1)*10) + v_bin)) + 1;
            end
        end
    end
end
%normalize the training histogram
for k = 1:length(test_objs)
    for j = 1:1000
       hsv_hist_test(k,j) = hsv_hist_test(k,j)/1024;
    end
end

save hsv2;

closestMatches = hsv_hist_test;