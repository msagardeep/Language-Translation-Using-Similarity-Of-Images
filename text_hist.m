% inputs: databaseDirectory -- the pathname to the database 
% outputs: extracts the sift features 

% example usage -- text_hist('D:\CS595WP\WordsPicturesProject\Project\');

function [] = text_hist(databaseDirectory)


% -------------------------------------------------------------------------
% - GET ALL THE TESTING IMAGES' TAGS AND CREATE A LEXICON AND WORD VECTORS
% -------------------------------------------------------------------------

% declare the spanish stopwords
stopwords = {'tags' 'de' 'un' 'una' 'unas' 'unos' 'uno' 'sobre' 'todo' 'tras' 'otro' 'alguno' 'alguna' 'algunos' 'algunas' 'ser' 'es' 'soy' 'eres' 'somos' 'sois' 'estoy' 'esta' 'estamos' 'estais' 'estan' 'como' 'en' 'para' 'atras' 'porque' 'estado' 'estaba' 'ante' 'antes' 'siendo' 'ambos' 'pero' 'por' 'poder' 'puede' 'puedo' 'podemos' 'podeis' 'pueden' 'fui' 'fue' 'fuimos' 'fueron'  'hacer' 'hago' 'hace' 'hacemos' 'haceis' 'hacen' 'cada' 'fin' 'incluso' 'primero' 'desde' 'conseguir' 'consigo' 'consigue'  'consigues' 'conseguimos' 'consiguen' 'ir' 'voy' 'va' 'vamos' 'vais' 'van' 'vaya' 'gueno' 'ha' 'tener' 'tengo' 'tiene'  'tenemos' 'teneis' 'tienen' 'el' 'la' 'lo' 'las' 'los' 'su' 'aqui' 'mio' 'tuyo' 'ellos' 'ellas' 'nos' 'nosotros' 'vosotros'  'vosotras' 'zoo' 'si' 'dentro' 'solo' 'solamente' 'saber' 'sabes' 'sabe' 'sabemos' 'sabeis' 'saben' 'ultimo' 'largo' 'bastante' 'haces' 'muchos' 'aquellos' 'aquellas' 'sus' 'entonces' 'tiempo' 'verdad' 'verdadero' 'verdadera' 'cierto' 'ciertos' 'cierta' 'ciertas' 'intentar' 'intento' 'intenta' 'intentas' 'intentamos' 'intentais' 'intentan' 'dos' 'bajo' 'arriba' 'encima' 'usar' 'uso' 'usas' 'usa' 'usamos' 'usais' 'usan' 'emplear' 'empleo' 'empleas' 'emplean' 'ampleamos' 'empleais' 'valor' 'muy' 'era' 'eras' 'eramos' 'eran' 'modo' 'bien' 'cual' 'cuando' 'donde' 'mientras' 'quien' 'con' 'entre' 'sin' 'trabajo' 'trabajar' 'trabajas' 'trabaja' 'trabajamos' 'trabajais' 'trabajan' 'podria' 'podrias' 'podriamos' 'podrian' 'podriais' 'yo' 'aquel' '04' '10' '2' '2007' '6' 'a' 'y' 's'};

load result_cat_0;
load result_cat_1;
load result_cat_2;
load result_cat_3;

% for all the images in the testing set
for l = 1:4
    if(l == 1)
        images = result_cat_0;
    elseif (l == 2)
        images = result_cat_1;
    elseif (l == 3)
        images = result_cat_2;
    else
        images = result_cat_3;
    end

    % all_tags is a collection of all the tags of all the test images
    all_tags = [];
    % all_uniq_tags represents all the unique tags in all the test images
    all_uniq_tags = [];
    
    for i = 1:length(images)
        % get the information related to the image using imfinfo
        img_path = [databaseDirectory, 'Img_Spanish\', images{i}];
        img_info = imfinfo(img_path);
    
        % line 10 of Comment field stores the tags associated with the image
        line = img_info.Comment{10};
    
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
        
            if(present == 0)
                all_tags{end+1} = t;
            end
        end
    end

    % get all the unique tags in the images
    all_uniq_tags = unique(all_tags);

    % for each unique tag, compute the number of times it has been encountered
    all_tags_t = all_tags';
    count_tags = strcmpi(all_tags_t(:,ones(1,length(all_uniq_tags))),all_uniq_tags(ones(length(all_tags_t),1),:));
    count_tags = sum(count_tags,1);

    % pick all tags with count > 3 and create the lexicon
    lexicon = [];
    lex_count = 1;
    for i = 1:length(all_uniq_tags)
        if(count_tags(i)>3)
            lexicon{lex_count} = all_uniq_tags{i};
            lex_count = lex_count + 1;
        end
    end
  
    %lexicon
    % create the word vectors
    word_vector = rand(length(images),length(lexicon));
    word_vector = word_vector .* 0;
    for i = 1:length(images)
        img_path = [databaseDirectory, 'Img_Spanish\', images{i}];
        img_info = imfinfo(img_path);
        line = img_info.Comment{3};
        %copy = rand(1,length(lexicon));
        %copy = copy .* 0;
        while ~isempty(line)
            [t,line] = strtok(line);
            t = strip_punctuation(t);
            for j = 1:length(lexicon)
                if ( strcmpi(t,lexicon{j}) )
                %if (strcmpi(t,lexicon{j}))
                    %if(copy(1,j) == 0)
                        word_vector(i,j) = word_vector(i,j) + 1;
                    %    copy(1,j) = 1;
                    %end 
                end
            end
        end
    end
    
    % determine the translated word
    word_vector = sum(word_vector,1);
    %word_vector
    [Y,I] = sort(word_vector,'descend');
    %Y
    %I
    lexicon(I(1))
    %lexicon(I(2))
    %lexicon(I(3))
    %lexicon(I(4))
    %end
end;

