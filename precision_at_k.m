% rank_list ��һ�������б�Ԫ��Ϊ 0, 1 ��ʾ��������
function p = precision_at_k(rank_list,k)
    p = sum(rank_list(1:k))/k;
end