function main_script_MvDA

%% generate random data in 3 views
Mu = [1 2; 1 5; 1 10]'; Sigma = ones(2,2);
num_view = 3;
X_multiview = cell(1,num_view);
Label_multiview = cell(1,num_view);

% each view has 100 instances,5 each class,
num_sample_per_view = 100;
Label = repmat({'1','2','3','4','5'},1,20);
for i=1:num_view
    X = mvnrnd(Mu(:,i),Sigma,num_sample_per_view);
    X_multiview{i} = X';
    Label_multiview{i} = Label;
end



%% MvDA

W_lda = MvDA(X_multiview,Label_multiview);
w1= W_lda{1};   % projection of view 1
w2 = W_lda{2};   % projection of view 2
w3 = W_lda{3};   % projection of view 3