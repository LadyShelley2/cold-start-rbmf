feature('DefaultCharacterSet', 'UTF8');
fileID = fopen('./data/freq_series.csv','r');
formatspec = '%s %s %f';
data = textscan(fileID,formatspec, 'delimiter', ',');
count = size(data{1},1);
cinema_name = unique(data{1});
movie_name = unique(data{2});
cinema_count = size(cinema_name,1);
movie_count = size(movie_name,1);

freq_matrix  = zeros(cinema_count,movie_count);
for i=1:count
%     data{1}{i}
%     data{2}{i}
%     data{3}[i]

    % 找到影吧的index
    ciname_indexc = strfind(cinema_name, data{1}{i});
    cinema_index = find(not(cellfun('isempty', ciname_indexc)));
    
    % 找到影院的index
    movie_indexc = strfind(movie_name, data{2}{i});
    movie_index = find(not(cellfun('isempty', movie_indexc)));
    
    freq_matrix(cinema_index,movie_index)=data{3}(i);
end
fclose(fileID); 
