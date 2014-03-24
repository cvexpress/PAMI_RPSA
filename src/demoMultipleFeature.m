clc ;
clear all;
close all;
addpath(genpath(pwd));
 warning off;
%% read training dataset
path='..\..\data\mfeat\';
pathdir='..\..\result\';
dataset='multifea';
featureset={'Fou','Fac','Kar','Pix','Zer','Mor'};
for i=1
    for j=1
feature1name='Kar';%featureset{i};
feature2name='Pix';%featureset{j};
feature1=importdata([path 'mfeat-',feature1name]);
feature2=importdata([path 'mfeat-',feature2name]);
dimension1=size(feature1,2);
dimension2=size(feature2,2);

[feature1,mu_X,sigma_X] = zscore(feature1);
[feature2,mu_Y,sigma_Y] = zscore(feature2);

Label=1:10;
Label=repmat(Label,200,1);
Labels=reshape(Label,2000,1);
trainingIndexFull=importdata([path 'trainingIndex.mat']);
trinum=20;
Accuracy=[];
for round=1:10
      fprintf('round=%d \n',round);
      trainingIndex=trainingIndexFull(:,round);
      testIndex=setdiff([1:2000], trainingIndex);
      trainingX=feature1(trainingIndex,:);
      trainingY=feature2(trainingIndex,:);
      trainingLabel=Labels(trainingIndex);
      testX=feature1(testIndex,:);
      testY=feature2(testIndex,:);
      testLabel=Labels(testIndex);
      [X,Ax,Ay,triplet,type]=constructTriplets(trainingX',trainingY',trainingLabel,trainingLabel,[trinum 2*trinum 2*trinum trinum]);
      N=size(triplet,1);
      coeff=1;
      % train model 
     config.method='SDP'; % cuttingPlane/SDP 
     config.param.gamma=size(triplet,1)*coeff; % This is set based on cuttingplane
     config.param.gamma3=size(triplet,1)*coeff*0;  % the weight for pair-wise constraints;
     ratio=size(trainingX,2)/size(trainingY,2);
     config.resultPath=pathdir;
     config.param.weight=[1,1,1,1];
     config.numOuterIter=100;
     config.numInnerIter=1;
     config.numQPIter=2;
     config.optimized=1; % 0;
     config.verbose=2; % 0-silence, 1 time record, 2 debug,3 statistic
     config.prefix=[dataset config.method,'3_',num2str(trinum),'_',num2str(config.param.gamma/size(triplet,1))];
     weight=generateWeight(type,config.param.weight,triplet,X);
     [Wx,Wy]=RPSA(X,Ax,Ay,triplet,weight,config);
     
      for dimension=1:min(dimension1,dimension2)
      trainingX_projection=Wx(1:dimension,:)*trainingX';
      trainingY_projection=Wy(1:dimension,:)*trainingY';
      testX_projection=Wx(1:dimension,:)*testX';
      testY_projection=Wy(1:dimension,:)*testY'; 
      k_neigbor=1;
      Accuracy(dimension,round)=retrieval_kNN(trainingX_projection+trainingY_projection, trainingLabel, testX_projection+testY_projection,testLabel,k_neigbor);
      % fprintf('The accuracy for %s with %d-NN is %f\n',algorithm, k,Accuracy);
      end
end
save([pathdir, dataset,'_',feature1name,'_',feature2name,'_', config.method,'.mat'],'Accuracy');
  
    end
end


