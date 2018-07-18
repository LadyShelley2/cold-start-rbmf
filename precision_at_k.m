% rank_list 是一个排序列表，元素为 0, 1 表示正负样本
function p = precision_at_k(rank_list,k)
    p = sum(rank_list(1:k))/k;
end