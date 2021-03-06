clc;clear;close all;
k = 50;% 隐空间维度
K = 50;% precision@K 的 K
colon = char(58);

%% 读取数据
fileID = fopen('./ml-1m/ratings.dat','r');
formatspec = '%d::%d::%d::%d';
sizeA=[4,Inf];
[A,count] = fscanf(fileID, formatspec,sizeA);
data = A';
max_val = max(data);
n_samples = size(data,1);
n_user = max_val(1); % 用户数目
n_movie = max_val(2);% 电影数目
rating_matrix = zeros(n_user,n_movie);

% 填入评分矩阵
for i=1:n_samples
    rating_matrix(data(i,1),data(i,2))=data(i,3);
end

rating_matrix_T = rating_matrix';% 代表性用户看一下
%% 划分训练数据和测试数据
identity_user = eye(n_user);
s = RandStream('mt19937ar','Seed',0); % 设置seed,每次生成的打乱矩阵不变
perm_user = identity_user(randperm(s,n_user),:);
rating_matrix = perm_user*rating_matrix;

n_train = floor(0.8*n_user);
train_matrix = rating_matrix(1:n_train,:);
test_matrix = rating_matrix(n_train+1:end,:);


%% 计算代表性列

% 利用 rbmf 选择
sub_matrix_index = rbmf(train_matrix,k); %计算出代表性列index
C = train_matrix(:,sub_matrix_index);

% 利用 random 选择
rand('seed',1)
sub_matrix_index_random = ceil(rand(1,k)*n_movie);
C_random = train_matrix(:,sub_matrix_index_random);

%% 计算 loading 矩阵，最小二乘法
% 计算 Loading 矩阵,最小二乘法
lambda = 0.01;
identity_matrix = eye(k);
loading_matrix = inv(C'*C+identity_matrix*lambda)*C'*train_matrix;
loading_matrix_random = inv(C_random'*C_random+identity_matrix*lambda)*C_random'*train_matrix;
%% 对测试数据进行预测
prediction = test_matrix(:,sub_matrix_index)*loading_matrix;
prediction_random = test_matrix(:,sub_matrix_index_random)*loading_matrix_random;

% 把预测后小于0的地方置为0
prediction(find(prediction<0))=0;
prediction_random(find(prediction_random<0))=0;
%% 评估模型
% 评估覆盖率和多样性
% 覆盖率
cov = coverage(rating_matrix,sub_matrix_index,2);
cov_random = coverage(rating_matrix,sub_matrix_index_random,2);

diver = diversity(rating_matrix,sub_matrix_index,2);
diver_random = diversity(rating_matrix,sub_matrix_index_random,2);

% 评估预测情况
% precision_at_10
% precision_at_10
n_test = size(test_matrix,1);
rank_list = (test_matrix>=4);
precision_at_ks = [];
for i = 1:n_test
    [sortes_row,index] = sort(prediction(i,:),'descend');
    precision = average_precision(rank_list(i,index),K);
    if(precision>1)
        disp('error')
    end
    precision_at_ks = [precision_at_ks precision];
end
disp('rbmf precision')
sum(precision_at_ks)/n_test

precision_at_ks_random = [];
for i = 1:n_test
    [sortes_row,index] = sort(prediction_random(i,:),'descend');
    precision = average_precision(rank_list(i,index),K);
    precision_at_ks_random = [precision_at_ks_random precision];
end
disp('random precision')
sum(precision_at_ks_random)/n_test

% plot(precision_at_ks,'r');
% hold on;
% plot(precision_at_ks_random,'b');

test_valid_count = sum(test_matrix,2)';
% 
% mae = sum(sum(abs(test_matrix-prediction)))/(size(test_matrix,1)*size(test_matrix,1));
% mae_random = sum(sum(abs(test_matrix-prediction_random)))/(size(test_matrix,1)*size(test_matrix,1));