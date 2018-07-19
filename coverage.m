% dim=1 表示按行
% dim=2 表示按列
function cov = coverage(data,index,dim)
% 改成直接按列，重新检查计算
    [n_row,n_col]=size(data);
    if(dim==1)
        cov = sum(sum(data(index,:))>0)/n_col;
    else
        cov = sum(sum(data(:,index),2)>0)/n_row;
    end
end