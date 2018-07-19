function ap = average_precision(rank_list, n)
    acc = 0;
    for i=1:n
        acc = acc + rank_list(i)*precision_at_k(rank_list,i);
    end
    if(sum(rank_list(1:n))==0)
        ap = 0;
        return 
    end
    ap = acc / sum(rank_list(1:n));
end