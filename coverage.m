% dim=1 ��ʾ����
% dim=2 ��ʾ����
function cov = coverage(data,index,dim)
% �ĳ�ֱ�Ӱ��У����¼�����
    [n_row,n_col]=size(data);
    if(dim==1)
        cov = sum(sum(data(index,:))>0)/n_col;
    else
        cov = sum(sum(data(:,index),2)>0)/n_row;
    end
end