clc;clear;close all;
load('./data/freq_matrix')
[row_count,col_count] = size(freq_matrix);

pivots =[];
for i=1:row_count
    row = freq_matrix(i,:);
    non_zero_row = row(find(row~=0));
    pivot = quantile(non_zero_row,0.8);
    pivots = [pivots pivot];
    freq_matrix(i,find(row<pivot))=0; % ��С�ڷ�λ��ۿ�Ƶ�ε���Ϊ�����Ƽ���ȫ����Ϊ��
    freq_matrix(i,find(row>=pivot))=1; % �����ڷ�λ��ۿ�Ƶ�ε���Ϊ�õ��Ƽ���ȫ����Ϊ1
end
plot(pivots)