function [closestMatches] = hist_sift_train(databaseDirectory)

apple_names = [databaseDirectory, 'Img_English\apple\*.jpg'];
car_names = [databaseDirectory, 'Img_English\car\*.jpg'];
rose_names = [databaseDirectory, 'Img_English\rose\*.jpg'];
tiger_names = [databaseDirectory, 'Img_English\tiger\*.jpg'];

db_apple = dir(apple_names);
db_car = dir(car_names);
db_rose = dir(rose_names);
db_tiger = dir(tiger_names);

apples = {};
cars = {};
roses = {};
tigers = {};

label = {};
count = 1;

for i=1:length(db_apple)
    apples{i} = [databaseDirectory,'Img_English\apple\',db_apple(i).name];
    label{count} = 'apple';
    label_obj(count) = 0;
    count = count + 1;
end

for i=1:length(db_car)
    cars{i} = [databaseDirectory,'Img_English\car\',db_car(i).name];
    label{count} = 'car';
    label_obj(count) = 1;
    count = count + 1;
end

for i=1:length(db_rose)
    roses{i} = [databaseDirectory,'Img_English\rose\',db_rose(i).name];
    label{count} = 'rose';
    label_obj(count) = 2;
    count = count + 1;
end

for i=1:length(db_tiger)
    tigers{i} = [databaseDirectory,'Img_English\tiger\',db_tiger(i).name];
    label{count} = 'tiger';
    label_obj(count) = 3;
    count = count + 1;
end

%transpose the label_obj matrix to finally concat with the feature matrix
label_obj = label_obj';
%choosing the value of kcenters
kcenters=50;
%get sift descriptors
im = [];
descr = {};

obj_all = {};
%concat all data into a single array 
obj_all = {apples{:},cars{:},roses{:},tigers{:}};
%obj_all{236}
%label{236}

for i=1:length(obj_all)
    %im{i} = imread(['C:\Users\biswa\Pictures\dummy\deer\',db_deer(i).name]);
    %obj_all{i}%REMOVE
    im{i} = imread(obj_all{i});
    if(size(im{i},3) == 3)
       im{i} = im2single(rgb2gray(im{i}));
    else
        im{i} = im2single(im{i});
    end
    [f,descr{i}] = vl_sift(im{i});
end

%descr%REMOVE
%length(cat(2, descr{:}))%REMOVE

descrcat = vl_colsubset(cat(2, descr{:}),10000);
descrcat = single(descrcat) ;
%construct the vocab book
vocab = vl_kmeans(descrcat, kcenters);

hist_train = rand(length(obj_all),kcenters);
hist_train = hist_train .*0;

for i = 1:length(obj_all)
    %check to which visual word does its sift features match
    %for each word
    %get a sift descriptor
    min = 1000000;
    index = 0;
    for j = 1:length(descr{i}(1,:))
        for k = 1:kcenters
        %get each ssd for each vocab word
        %descr{i}(:,j)
        %vocab(:,k)
        ssd = sum(sum((double(descr{i}(:,j))-double(vocab(:,k))).^2));
            if (ssd < min)
                   min = ssd;
                index = k;
            end
            %descr{i}(:,j)
        end
        hist_train(i,index)=hist_train(i,index)+1;
    end
end

closestMatches = cat(2,hist_train,label_obj);