function [closestMatches] = get_cg(databaseDirectory)

%root = ['C:\Users\biswa\Pictures\wp_proj\'];
%deer_names = [root, 'deer\00001\*.jpg'];
%db_deer = dir(deer_names);
%get sift descriptors
%im = [];
%descr = {};

no_of_objects = 3;

%get a vector representation for each image
%trying with 
%1. sift features
%2. hsv features
%3. ... features

%hist_sift returns a word vector for each image along with the
%label vector concatenated with it. 

%sift_hist = hist_sift_test(databaseDirectory);
sift_hist = hist_hsv_train(databaseDirectory);

%save hist2
%load hist2

%Divide the image set into two parts 
%1 Training 
%2 Testing
%Take 70% of each image category as training
%and 30% of each image category as testing.
%say x is the total number of images we have
rows = size(sift_hist,1); %gives the number of rows
cols = size(sift_hist,2) - 1; %#columns 
rows = rows/no_of_objects; %total number images for each obj 
c_train_size = uint32((70*rows)/100);
c_test_size = rows - c_train_size;
trainmatrix_size = (c_train_size*no_of_objects);
c_training = rand((c_train_size*no_of_objects),cols);
c_training = c_training .*0;

testmatrix_size = (c_test_size*no_of_objects);
c_testing = rand((c_test_size*no_of_objects),cols);
c_testing = c_testing .*0;

size(c_testing,1);
size(c_training,1);

%have matrices for storing labels as well
inx=1;
for i = 0:(no_of_objects-1)
    start = (i * rows) + 1;
    for j = start:(c_train_size+start-1)
        for k = 1:cols
            c_training(inx,k) = sift_hist(j,k);
        end
        %store label
        if (sift_hist(j,cols+1) == 0)
            label_cat_0(inx) = 1;
            label_cat_1(inx) = -1;
            label_cat_2(inx) = -1;
            label_cat_3(inx) = -1;            
        elseif (sift_hist(j,cols+1) == 1)
            label_cat_0(inx) = -1;
            label_cat_1(inx) = 1;
            label_cat_2(inx) = -1;
            label_cat_3(inx) = -1;            
        elseif (sift_hist(j,cols+1) == 2)
            label_cat_0(inx) = -1;
            label_cat_1(inx) = -1;
            label_cat_2(inx) = 1;
            label_cat_3(inx) = -1;            
        elseif (sift_hist(j,cols+1) == 3)
            label_cat_0(inx) = -1;
            label_cat_1(inx) = -1;
            label_cat_2(inx) = -1;
            label_cat_3(inx) = 1;            
        end
        inx = inx + 1;
    end
end

label_cat_0 = label_cat_0';
label_cat_1 = label_cat_1';
label_cat_2 = label_cat_2';
label_cat_3 = label_cat_3';
%size(c_training,1) 
%label_cat_0

model_cat_0 = svmtrain(label_cat_0,c_training,'-c 800 -g 0.01 -b 1'); %93.33
model_cat_1 = svmtrain(label_cat_1,c_training,'-c 900 -g 0.05 -b 1');
model_cat_2 = svmtrain(label_cat_2,c_training,'-c 700 -g 0.01 -b 1');
model_cat_3 = svmtrain(label_cat_3,c_training,'-c 700 -g 0.01 -b 1');

%temporary testing set
inx=1;
for i = 0:(no_of_objects-1)
    start = (i * rows) + c_train_size + 1;
    for j = start:(c_test_size+start-1)
        for k = 1:cols
            c_testing(inx,k) = sift_hist(j,k);         
        end
        %store label
        if (sift_hist(j,cols+1) == 0)
            testlabel_cat_0(inx) = 1;
            testlabel_cat_1(inx) = -1;
            testlabel_cat_2(inx) = -1;
            testlabel_cat_3(inx) = -1;
        elseif (sift_hist(j,cols+1) == 1)
            testlabel_cat_0(inx) = -1;
            testlabel_cat_1(inx) = 1;
            testlabel_cat_2(inx) = -1;
            testlabel_cat_3(inx) = -1;
        elseif (sift_hist(j,cols+1) == 2)
            testlabel_cat_0(inx) = -1;
            testlabel_cat_1(inx) = -1;
            testlabel_cat_2(inx) = 1;
            testlabel_cat_3(inx) = -1;
        elseif (sift_hist(j,cols+1) == 3)
            testlabel_cat_0(inx) = -1;
            testlabel_cat_1(inx) = -1;
            testlabel_cat_2(inx) = -1;
            testlabel_cat_3(inx) = 1;
        end
        inx = inx + 1;
    end
end
testlabel_cat_0 = testlabel_cat_0';
testlabel_cat_1 = testlabel_cat_1';
testlabel_cat_2 = testlabel_cat_2';
testlabel_cat_3 = testlabel_cat_3';

[predicted_label_0, accuracy, prob_estimates_0] = svmpredict(testlabel_cat_0, c_testing, model_cat_0,'-b 1');
[predicted_label_1, accuracy, prob_estimates_1] = svmpredict(testlabel_cat_1, c_testing, model_cat_1,'-b 1');
[predicted_label_2, accuracy, prob_estimates_2] = svmpredict(testlabel_cat_2, c_testing, model_cat_2,'-b 1');
[predicted_label_2, accuracy, prob_estimates_3] = svmpredict(testlabel_cat_3, c_testing, model_cat_3,'-b 1');

closestMatches = prob_estimates_2;
