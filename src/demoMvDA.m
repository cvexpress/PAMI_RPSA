clc ;
clear all;
close all;
addpath(genpath(pwd));
warning off;
%% read training dataset
dataPath='.\data\CUFSF\';
pathdir='.\result\';

num_view = 2;
X_multiview = cell(1,num_view);
Label_multiview = cell(1,num_view);

trainingLabel =importdata([dataPath 'trainingLabel.mat']);
testLabel = importdata([dataPath 'testLabel.mat']);
numTrain=length(trainingLabel);

X=importdata([dataPath 'p1.mat']);
Y=importdata([dataPath 'p2.mat']);
trainingX=double(X(1:numTrain,:));
trainingY=double(Y(1:numTrain,:));

testX=double(X(numTrain+1:end,:));
testY=double(Y(numTrain+1:end,:));

X_multiview{1}=trainingX';
X_multiview{2}=trainingY';
for i=1:length(trainingLabel)
Label_multiview{1}{i}=int2str(trainingLabel(i));
Label_multiview{2}{i}=int2str(trainingLabel(i));
end


W_lda = MvDA(X_multiview,Label_multiview);
Wx=W_lda{1};
Wy=W_lda{2};
for dimension=1:size(Wx,2)
testX_projection=Wx(:,1:dimension)'*testX';
testY_projection=Wy(:,1:dimension)'*testY';  
Accuracy(dimension)=retrieval_kNN(testX_projection,testLabel, testY_projection,testLabel,1);
end