% �����ҵ����Ӿ����index
function res_index = rbmf(A,k)
% A=[1,2,3,3,2,1;1,1,1,3,4,5;1,2,3,3,2,1;1,1,1,3,4,5;]
% k=2; % ���ռ�ά��
n_iter=100; % ����������
i=0;
[U,S,V] = svds(A,k);
[L,U_lu,p] = lu(V,'vector');

% ��¼�Ӿ���� det ֵ���۲��Ƿ����
det_vals = [];
det_vals_inv = [];
while(i<n_iter)
    B = V(p,:)*inv(V(p(1:k),:));
    det_vals_inv = [det_vals_inv abs(det(inv(V(p(1:k),:))))];
    det_vals = [det_vals,abs(det(V(p(1:k),:)))];
    maxval = max(max(abs(B([k+1:end],:))));
    if(maxval>1)
        [i_row,i_col]=find(abs(B)==maxval);
        tmp = p(i_row);
        p(i_row)=p(i_col);
        p(i_col)=tmp;
        i = i+1;
    else
        break;
    end
end
% plot(det_vals)
% figure;
% plot(det_vals_inv)
res_index = p(1:k);