% clc ;
% clear all;
% close all;
addpath(genpath(pwd));
warning off;
%% read training dataset
dataPath='..\..\data\wikipedia_info\';
pathdir='..\..\result\';
trinum=120;
[~, ~, trainingLabel] = textread([dataPath 'trainset_txt_img_cat.list'], '%s %s %d');
[~, ~, testLabel] = textread([dataPath 'testset_txt_img_cat.list'],'%s %s %d');
% countTrain = hist(trainCat)';
% countTest = hist(testCat)';
database=importdata([dataPath,'raw_features.mat']);
trainingX=database.I_tr;
trainingY=database.T_tr;
testX=database.I_te;
testY=database.T_te;
%% train the model
[X,Ax,Ay,triplet,type]=constructTriplets(trainingX',trainingY',trainingLabel,trainingLabel,[trinum trinum trinum trinum]);
num=1000000;
num=min(num,size(triplet,1));
coeff=1;
triplet=triplet(1:num,:);
type=type(1:num,:);

config.method='SDP'; % cuttingPlane/SDP 
config.param.gamma=size(triplet,1)*coeff; % This is set based on cuttingplane
config.param.gamma3=size(triplet,1)*coeff*0.01;  % the weight for pair-wise constraints;
ratio=size(trainingX,2)/size(trainingY,2);
config.resultPath=pathdir;
config.param.weight=[1,1,1,1];
config.numOuterIter=50;
config.numInnerIter=1;
config.numQPIter=2;
config.optimized=1; % 0;
config.verbose=2; % 0-silence, 1 time record, 2 debug,3 statistic
config.prefix=[config.method,'3_',num2str(num),'_',num2str(config.param.gamma/size(triplet,1))];
weight=generateWeight(type,config.param.weight);
[Wx,Wy]=RPSA(X,Ax,Ay,triplet,weight,config);
% classify test sample according to KNN
dimension=10;
testX_projection=Wx(1:dimension,:)*testX';
testY_projection=Wy(1:dimension,:)*testY';  
[map,map1]=computeMAP(testX_projection',testY_projection',testLabel,testLabel);
fprintf('The map is %f, %f.\n',map,map1);

[map,map1]=computeMAP(testY_projection',testX_projection',testLabel,testLabel);
fprintf('The map is %f, %f.\n',map,map1);

  
     
      
     
    




