function [closestMatches] = language_translate_sift(databaseDirectory)

sift_hist = hist_sift_train(databaseDirectory);

rows = size(sift_hist,1);  % # rows
cols = size(sift_hist,2) - 1; % #columns 
inx=1;
for i = 1:rows
        if (sift_hist(i,cols+1) == 0)
            label_cat_0(inx) = 1;
            label_cat_1(inx) = -1;
            label_cat_2(inx) = -1;
            label_cat_3(inx) = -1;
        elseif (sift_hist(i,cols+1) == 1)
            label_cat_0(inx) = -1;
            label_cat_1(inx) = 1;
            label_cat_2(inx) = -1;
            label_cat_3(inx) = -1;
        elseif (sift_hist(i,cols+1) == 2)
            label_cat_0(inx) = -1;
            label_cat_1(inx) = -1;
            label_cat_2(inx) = 1;
            label_cat_3(inx) = -1;
        elseif (sift_hist(i,cols+1) == 3)  
            label_cat_0(inx) = -1;
            label_cat_1(inx) = -1;
            label_cat_2(inx) = -1;
            label_cat_3(inx) = 1;
        end
        inx = inx + 1;
end

label_cat_0 = label_cat_0';
label_cat_1 = label_cat_1';
label_cat_2 = label_cat_2';
label_cat_3 = label_cat_3';

svm_train_vector = rand(rows,cols);
svm_train_vector = svm_train_vector .* 0;

%remove loop
for i=1:rows
    for j=1:cols
        svm_train_vector(i,j) = sift_hist(i,j);
    end
end

model_cat_0 = svmtrain(label_cat_0,svm_train_vector,'-c 700 -g 0.01 -b 1');
model_cat_1 = svmtrain(label_cat_1,svm_train_vector,'-c 700 -g 0.01 -b 1');
model_cat_2 = svmtrain(label_cat_2,svm_train_vector,'-c 700 -g 0.01 -b 1');
model_cat_3 = svmtrain(label_cat_3,svm_train_vector,'-c 700 -g 0.01 -b 1');

%test_sift_hist = test_hist_sift('C:\Users\biswa\Pictures\wp_proj\');
test_sift_hist = hist_sift_test(databaseDirectory);

test_rows = size(test_sift_hist,1);
%test_cols = size(test_sift_hist,2);

for i = 1:test_rows
    test_label_vector(i) = 0.01;
end

test_label_vector = test_label_vector';

[predicted_label_0, accuracy, prob_estimates_0] = svmpredict(test_label_vector, test_sift_hist, model_cat_0,'-b 1');
[predicted_label_1, accuracy, prob_estimates_1] = svmpredict(test_label_vector, test_sift_hist, model_cat_1,'-b 1');
[predicted_label_2, accuracy, prob_estimates_2] = svmpredict(test_label_vector, test_sift_hist, model_cat_2,'-b 1');
[predicted_label_3, accuracy, prob_estimates_3] = svmpredict(test_label_vector, test_sift_hist, model_cat_3,'-b 1');

test_obj_names = [databaseDirectory, '\Img_Spanish\*.jpg'];
db_test_objs = dir(test_obj_names);
test_objs = {};
for i=1:length(db_test_objs)
    test_objs{i} = [db_test_objs(i).name];    
end

temp0 = prob_estimates_0(:,1);
[Y,I] = sort(temp0,'descend');
result_sift_cat0 = {};
for k=1:100
    result_sift_cat0{k} = test_objs{I(k)};
end
% create a webpage showing the results
fid = fopen('apples_sift.html','w');
fprintf(fid,'<html><body>\n');
for i=1:length(result_sift_cat0)
	picname = result_sift_cat0{i};
	fprintf(fid,['<img src="Img_Spanish/', picname,  '">\n']);
	if mod(i,3)==0  
		fprintf(fid,'<br>');
	end
end
fprintf(fid,'</html>');
fclose(fid);

save result_cat_sift0;

tempbl = prob_estimates_1(:,2);
[Y,I] = sort(tempbl,'descend');
result_sift_cat1 = {};
for k=1:100
    result_sift_cat1{k} = test_objs{I(k)};
end
% create a webpage showing the results
fid = fopen('cars_sift.html','w');
fprintf(fid,'<html><body>\n');
for i=1:length(result_sift_cat1)
	picname = result_sift_cat1{i};
	fprintf(fid,['<img src="Img_Spanish/', picname,  '">\n']);
	if mod(i,3)==0  
		fprintf(fid,'<br>');
	end
end
fprintf(fid,'</html>');
fclose(fid);

save result_cat_sift1;

tempbl = prob_estimates_2(:,2);
[Y,I] = sort(tempbl,'descend');
result_sift_cat2 = {};
for k=1:100
    result_sift_cat2{k} = test_objs{I(k)};
end
% create a webpage showing the results
fid = fopen('roses_sift.html','w');
fprintf(fid,'<html><body>\n');
for i=1:length(result_sift_cat2)
	picname = result_sift_cat2{i};
	fprintf(fid,['<img src="Img_Spanish/', picname,  '">\n']);
	if mod(i,3)==0  
		fprintf(fid,'<br>');
	end
end
fprintf(fid,'</html>');
fclose(fid);

save result_cat_sift2;

tempbl = prob_estimates_3(:,2);
[Y,I] = sort(tempbl,'descend');
result_sift_cat3 = {};
for k=1:100
    result_sift_cat3{k} = test_objs{I(k)};
end
% create a webpage showing the results
fid = fopen('tigers_sift.html','w');
fprintf(fid,'<html><body>\n');
for i=1:length(result_sift_cat3)
	picname = result_sift_cat3{i};
	fprintf(fid,['<img src="Img_Spanish/', picname,  '">\n']);
	if mod(i,3)==0  
		fprintf(fid,'<br>');
	end
end
fprintf(fid,'</html>');
fclose(fid);

save result_cat_sift3;

closestMatches = prob_estimates_2;
