clc;clear;close all;
k=10;
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

% precision_at_10


mae = sum(sum(abs(test_matrix-prediction)))/(size(test_matrix,1)*size(test_matrix,1));
mae_random = sum(sum(abs(test_matrix-prediction_random)))/(size(test_matrix,1)*size(test_matrix,1));