clc;clear;close all;
load('./data/freq_matrix')
[row_count,col_count] = size(freq_matrix);

pivots =[];
for i=1:row_count
    row = freq_matrix(i,:);
    non_zero_row = row(find(row~=0));
    pivot = quantile(non_zero_row,0.8);
    pivots = [pivots pivot];
    freq_matrix(i,find(row<pivot))=0; % 将小于分位点观看频次的作为坏的推荐，全部置为零
    freq_matrix(i,find(row>=pivot))=1; % 将大于分位点观看频次的作为好的推荐，全部置为1
end
plot(pivots)