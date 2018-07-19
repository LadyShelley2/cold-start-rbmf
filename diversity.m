function div = diversity(data,index)
% 多样性计算的可能有问题，重新改下代码
% 选择列
    threshold = 0.1;%少于10%
    n_index = size(index,1);
    sub_data = data(:,index);
    acc = sum(sub_data>0,2);
    div = sum((acc/n_index)<threshold)/size(data,1);
end