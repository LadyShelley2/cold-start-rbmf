function div = diversity(data,index)
% �����Լ���Ŀ��������⣬���¸��´���
% ѡ����
    threshold = 0.1;%����10%
    n_index = size(index,1);
    sub_data = data(:,index);
    acc = sum(sub_data>0,2);
    div = sum((acc/n_index)<threshold)/size(data,1);
end