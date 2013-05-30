% inputs: databaseDirectory -- the pathname to the database 
% outputs: extracts the sift features 

% example usage -- text_hist('D:\CS595WP\WordsPicturesProject\Project\');

function [tag_hist] = tag_rank_test(databaseDirectory)


% -------------------------------------------------------------------------
% - GET ALL THE TESTING IMAGES' TAGS AND CREATE A LEXICON AND WORD VECTORS
% -------------------------------------------------------------------------

% declare the spanish stopwords
stopwords = {'tags' 'de' 'un' 'una' 'unas' 'unos' 'uno' 'sobre' 'todo' 'tras' 'otro' 'alguno' 'alguna' 'algunos' 'algunas' 'ser' 'es' 'soy' 'eres' 'somos' 'sois' 'estoy' 'esta' 'estamos' 'estais' 'estan' 'como' 'en' 'para' 'atras' 'porque' 'estado' 'estaba' 'ante' 'antes' 'siendo' 'ambos' 'pero' 'por' 'poder' 'puede' 'puedo' 'podemos' 'podeis' 'pueden' 'fui' 'fue' 'fuimos' 'fueron'  'hacer' 'hago' 'hace' 'hacemos' 'haceis' 'hacen' 'cada' 'fin' 'incluso' 'primero' 'desde' 'conseguir' 'consigo' 'consigue'  'consigues' 'conseguimos' 'consiguen' 'ir' 'voy' 'va' 'vamos' 'vais' 'van' 'vaya' 'gueno' 'ha' 'tener' 'tengo' 'tiene'  'tenemos' 'teneis' 'tienen' 'el' 'la' 'lo' 'las' 'los' 'su' 'aqui' 'mio' 'tuyo' 'ellos' 'ellas' 'nos' 'nosotros' 'vosotros'  'vosotras' 'si' 'dentro' 'solo' 'solamente' 'saber' 'sabes' 'sabe' 'sabemos' 'sabeis' 'saben' 'ultimo' 'largo' 'bastante' 'haces' 'muchos' 'aquellos' 'aquellas' 'sus' 'entonces' 'tiempo' 'verdad' 'verdadero' 'verdadera' 'cierto' 'ciertos' 'cierta' 'ciertas' 'intentar' 'intento' 'intenta' 'intentas' 'intentamos' 'intentais' 'intentan' 'dos' 'bajo' 'arriba' 'encima' 'usar' 'uso' 'usas' 'usa' 'usamos' 'usais' 'usan' 'emplear' 'empleo' 'empleas' 'emplean' 'ampleamos' 'empleais' 'valor' 'muy' 'era' 'eras' 'eramos' 'eran' 'modo' 'bien' 'cual' 'cuando' 'donde' 'mientras' 'quien' 'con' 'entre' 'sin' 'trabajo' 'trabajar' 'trabajas' 'trabaja' 'trabajamos' 'trabajais' 'trabajan' 'podria' 'podrias' 'podriamos' 'podrian' 'podriais' 'yo' 'aquel' '04' '10' '2' '2007' '6' 'a' 'y'};

imgs = [databaseDirectory, 'Img_Spanish\*.jpg'];
images = dir(imgs);

% all_tags is a collection of all the tags of all the test images
all_tags = [];
% all_uniq_tags represents all the uniqe tags in all the test images
all_uniq_tags = [];

% for all the images in the testing set
tags = []; %create an empty tag matrix. We would be storing tags here
im = [];
img_names = {};
for i = 1:length(images)
    img_path = [databaseDirectory, 'Img_Spanish\', images(i).name]
    img_names{i} = img_path;
    %store images
    im{i} = imread(img_path);
    
    im{i} = im2double(im{i});
    if(size(im{i},3) == 3)
       im{i} = rgb2gray(im{i});
    end
    im{i} = imresize(im{i}, [50 50]);
    % get the information related to the image using imfinfo
    
    img_info = imfinfo(img_path);
    
    % line 3 of Comment field stores the tags associated with the image
    line = img_info.Comment{10};
    
    tags_current = []; %tags_current stores the set of tags for current image
    count = 1; %count of number of tags stored.
    while ~isempty(line)
        [t,line] = strtok(line);
        t = lower(strip_punctuation(t));
        present = 0;
        
        % check for the stop words
        for j=1:length(stopwords)
            if(strcmpi(t,stopwords{j}))
                present = 1;
                break;
            end
        end
        
        %if(present == 0)
        %    all_tags{end+1} = t;
        %end
        if(present == 0)
            tags_current{count} = t;
            count = count + 1;
        end
        
    end
    for k = count:100  %fill rest of tags as empty ('') to maintain uniform #cols
        tags_current{k} = '';
    end
    %tags_current{:}
    tags = [tags;tags_current];
    
end


%Now that we have the tags matrix. We can compute rank of each tag per
%image
%img1 = im{1};
%img2= im{2};

sigma = 11;

tag_rank = rand(length(images),100);
tag_rank = tag_rank .*0;

%Xi is the set of images containing the tag ti
%s(ti,x) = p(x/ti) = 1/|Xi| Sum(K_sigma(x-xk))

%for i = 1:length(images)
    count_tags = 0;
    
    i = 172;
    for j = 1:100
        %ITERATION=j
        mcnt = 1; %match count
        if(strcmp(tags(i,j),''))
            %BREAKINGOFF = 1
            break;
        else %find rank for this tag
            
            t = tags(i,j); %storing tag in t
            t = char(t);
            sum1 = 0; 
            count = 0;
            for k = 1:length(images) %finding other images containing t
                if ((k ~= i)) 
                    for l = 1:100
                        if (strcmp(tags(k,l),''))
                            break;
                        else
                            str = tags(k,l);
                            str = char(str);
                            %if (~isempty(findstr(lower(str),lower(t)))) %found a matching tag in image k
                            if (strcmp(lower(str),lower(t)))
                                match1 = lower(str);
                                match2 = lower(t);
                                %sum = sum + exp(-((sum(sum(im{i} - im{k})))/(sigma*sigma)));
                                %im{i}-im{k}
                                ssd = sum(sum((im{i} - im{k}).^2));
                                im_index(mcnt) = k;
                                ssd_tj(mcnt) = ssd;
                                mcnt = mcnt + 1;
                                exppp = exp(-(ssd/(sigma*sigma)));
                                sum1 = sum1 + exp(-(ssd/(sigma*sigma)));
                                count = count + 1; %increase image match count
                                break; %added one image to sum;move to the next one
                            end
                        end
                    end
                end
                
            end
            %counting #tags for this image. The tag graph will have that
            %#nodes.
            count_tags = count_tags + 1; %# tags for this image
            if (count == 0)
                rank_tag = 0;
            else
                rank_tag = sum1/count;
            end
            %tag_rank(i,j) = rank_tag;
            %RANDOM WALK BASED REFINEMENT
            if (mcnt > 20)
                sizeNN = 20;
            else
                sizeNN = mcnt;
            end
            [Y,I] = sort(ssd_tj);
            sizeT(j) = sizeNN;
            %Fine N nearest neighbors for the image.
            for g = 1:sizeNN
                Tao(j,g) = im_index(I(g));
            end
        end
        
        
        %ITERATION_END = 0
    end
        %BROKEOFF=0
    %for every pair of tags compute edge weight
        sum_exmplr = 0;
        for ti = 1:count_tags
            for tj = 1:count_tags
                sum_e = 0;
                for im_ti = 1:sizeT(ti)
                    for im_tj = 1:sizeT(tj)
                        ssdij = sum(sum((im{Tao(ti,im_ti)} - im{Tao(tj,im_tj)}).^2));
                        sum_e = sum_e + ssdij/(sigma*sigma);
                    end
                end
                exmplr(ti,tj) = exp(-(sum_e/(sizeT(ti)*sizeT(tj))));
                sum_exmplr = sum_exmplr + exmplr(ti,tj);
            end
        end
        %compute probability of transition from ti to tj
        for ti = 1:count_tags
            for tj = 1:count_tags
                pr(ti,tj) = exmplr(ti,tj)/sum_exmplr;
                
            end
            rankt(1,ti) = 0;
        end
        itrk = 10; %setting the number of iterations.
        %reranking tags based on edge weights.
        for ti = 1:count_tags
            for itr = 2:itrk
                sum_rank=0;
                for ct = 1:count_tags
                    sum_rank = sum_rank + rankt(itr-1,ct)*pr(ti,ct); 
                end
                rankt(itr,ti) = 0.6 * sum_rank + 0.4 * (1-rank_tag);
            end
            tag_rank(i,ti) = rankt(itr-1,ti);
        end
%end





%save all_tags;
save tags1 tags 
save img_names1 img_names 
tag_hist = tag_rank;








