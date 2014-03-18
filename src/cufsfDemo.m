clc ;
clear all;
close all;
addpath(genpath(pwd));
warning off;
%% read training dataset
dataPath='.\data\CUFSF\';
pathdir='.\result\';
trinum=120;
trainingLabel =importdata([dataPath 'trainingLabel.mat']);
testLabel = importdata([dataPath 'testLabel.mat']);
numTrain=length(trainingLabel);

X=importdata([dataPath 'p1.mat']);
Y=importdata([dataPath 'p2.mat']);

trainingX=double(X(1:numTrain,:));
trainingY=double(Y(1:numTrain,:));

testX=double(X(numTrain+1:end,:));
testY=double(Y(numTrain+1:end,:));


%% train the model
[X,Ax,Ay,triplet,type]=constructTriplets(trainingX',trainingY',trainingLabel,trainingLabel,[trinum 0 0 trinum]);
num=min(1000000,size(triplet,1));
triplet=triplet(1:num,:);
type=type(1:num,:);
coeff=0.1;
config.method='SDP'; % cuttingPlane/SDP 
config.param.gamma=size(triplet,1)*coeff;
ratio=size(trainingX,2)/size(trainingY,2);
config.param.weight=[1,1,ratio^2,ratio^2];
config.numOuterIter=50;
config.numInnerIter=1;
config.numQPIter=5;
config.optimized=1; % 0;
config.verbose=2; % 0-silence, 1 time record, 2 debug,3 statistic
config.prefix=[config.method,'1_',num2str(num),'_',num2str(config.param.gamma/size(triplet,1))];
weight=generateWeight(type,config.param.weight);
[Wx,Wy]=RPSA(X,Ax,Ay,triplet,weight,config);
      % classify test sample according to KNN
for dimension=1:100
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
  
     
      
     
    




