function [closestMatches] = hist_hsv_train(databaseDirectory)

apple_names = [databaseDirectory, 'Img_English\apple\*.jpg'];
car_names = [databaseDirectory, 'Img_English\car\*.jpg'];
rose_names = [databaseDirectory, 'Img_English\rose\*.jpg'];
tiger_names = [databaseDirectory, 'Img_English\tiger\*.jpg'];

db_apple = dir(apple_names);
db_car = dir(car_names);
db_rose = dir(rose_names);
db_tiger = dir(tiger_names);

apple = {};
car = {};
rose = {};
tiger = {};

label = {};
count = 1;
for i=1:length(db_apple)
    apple{i} = [databaseDirectory,'Img_English\apple\',db_apple(i).name];
    label{count} = 'apple';
    label_obj(count) = 0;
    count = count + 1;
end

for i=1:length(db_car)
    car{i} = [databaseDirectory,'Img_English\car\',db_car(i).name];
    label{count} = 'car';
    label_obj(count) = 1;
    count = count + 1;
end

for i=1:length(db_rose)
    rose{i} = [databaseDirectory,'Img_English\rose\',db_rose(i).name];
    label{count} = 'rose';
    label_obj(count) = 2;
    count = count + 1;
end

for i=1:length(db_tiger)
    tiger{i} = [databaseDirectory,'Img_English\tiger\',db_tiger(i).name];
    label{count} = 'tiger';
    label_obj(count) = 3;
    count = count + 1;
end

%transpose the label_obj matrix to finally concat with the feature matrix
label_obj = label_obj';
%choosing the value of bins
bins=1000;

%concat all data into a single array 
obj_all = {apple{:},car{:},rose{:},tiger{:}};

hsv_hist_train = rand(length(obj_all),bins);
hsv_hist_train = hsv_hist_train .*0;
% computing hue-saturation-value color histogram for the training set
for k = 1:length(obj_all)
%    obj_all{k}
    I = imread(obj_all{k});
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
                hsv_hist_train(k,(((h_bin-1)*100) + ((s_bin-1)*10) + v_bin)) = hsv_hist_train(k,(((h_bin-1)*100) + ((s_bin-1)*10) + v_bin)) + 1;
            end
        end
    end
end
%normalize the training histogram
for k = 1:length(obj_all)
    for j = 1:1000
       hsv_hist_train(k,j) = hsv_hist_train(k,j)/1024;
    end
end

closestMatches = cat(2,hsv_hist_train,label_obj);