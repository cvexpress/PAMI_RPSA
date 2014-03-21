clc ;
clear all;
close all;
addpath(genpath(pwd));
warning off;
%% set env.

%% proprecess data
threhold=0.95;
train=importdata('p1_data_train.mat');
test=importdata('p1_data_test.mat');
train=(train.X)';
test=(test.X)';
X=[train;test];
X=double(X)/255.0;
[COEFF,SCORE,latent] = princomp(zscore(X));
c=cumsum(latent);
c=c/sum(latent);
[inx]=find(c>threhold);
i=min(inx);
S=double(SCORE(:,1:i));
save p1.mat S;
train=importdata('p2_data_train.mat');
test=importdata('p2_data_test.mat');
train=(train.X)';
test=(test.X)';
X=[train;test];
X=double(X)/255.0;
[COEFF,SCORE,latent] = princomp(zscore(X));
c=cumsum(latent);
c=c/sum(latent);
[inx]=find(c>threhold);
i=min(inx);
S=double(SCORE(:,1:i));
save p2.mat S;

%% load data
trainingLabel =importdata([dataPath 'trainingLabel.mat']);
testLabel = importdata([dataPath 'testLabel.mat']);
numTrain=length(trainingLabel);
X=importdata([dataPath 'p1.mat']);
Y=importdata([dataPath 'p2.mat']);
trainingX=double(X(1:numTrain,:));
trainingY=double(Y(1:numTrain,:));
testX=double(X(numTrain+1:end,:));
testY=double(Y(numTrain+1:end,:));
%% prepare data for MvDA
Label=trainingLabel';
[X_multiview,Label_multiview]=prepareMvDA(trainingX',trainingY',Label)
W_lda = MvDA(X_multiview,Label_multiview);
Wx=W_lda{1}';
Wy=W_lda{2}';
%% classify test sample according to KNN
for dimension=1:5:100
testX_projection=Wx(1:dimension,:)*testX';
testY_projection=Wy(1:dimension,:)*testY';  
k_neigbor=1;
Accuracy(dimension)=retrieval_kNN(testX_projection,testLabel, testY_projection,testLabel,k_neigbor);
Accuracy1(dimension)=retrieval_kNN(testY_projection,testLabel, testX_projection,testLabel,k_neigbor);
end
figure;
plot(Accuracy);
figure;
plot(Accuracy1);
  
     
      
     
    




