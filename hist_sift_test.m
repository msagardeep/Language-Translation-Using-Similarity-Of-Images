function [closestMatches] = hist_sift_test(databaseDirectory)

test_image_names = [databaseDirectory, 'Img_Spanish\*.jpg'];
db_test_images = dir(test_image_names);

test_images = {};
for i=1:length(db_test_images)
    test_images{i} = [databaseDirectory, 'Img_Spanish\',db_test_images(i).name];
end

%choosing the value of kcenters
kcenters=500;
%get sift descriptors
im = [];
descr = {};

for i=1:length(test_images)
    im{i} = imread(test_images{i});
    if(size(im{i},3) == 3)
        im{i} = im2single(rgb2gray(im{i}));
    else
        im{i} = im2single(im{i});
    end
    [f,descr{i}] = vl_sift(im{i});
end

descrcat = vl_colsubset(cat(2, descr{:}),10000);
descrcat = single(descrcat) ;
%construct the vocab book
vocab = vl_kmeans(descrcat, kcenters);

hist_test = rand(length(test_images),kcenters);
hist_test = hist_test .*0;

for i = 1:length(test_images)
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
        hist_test(i,index)=hist_test(i,index)+1;
    end
end

closestMatches = hist_test;