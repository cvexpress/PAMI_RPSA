%%This file run the proposed method over the CMUPIE dataset.
clc ;
clear all;
close all;
addpath(genpath(pwd));
warning off;
path='.\data\cmupie.mat';
pathdir='.\result\';
trinum=4;
load(path);
Labels=[1:68]';
camera={'c02' 'c05' 'c07' 'c09' 'c11' 'c14' 'c22' 'c25' 'c27' 'c29' 'c31' 'c34' 'c37'};
trainingIndex=[1:34]';
tmp=pose(:,:,1,1);
scale=1;
tmp=imresize(tmp,1/scale);
l=size(tmp,1)*size(tmp,2);
n=34;
PHOTOS=zeros(n,l);
SKETCHS=zeros(n,l);
flag=['_demo_' num2str(trinum)];
for i=1:12 
  for j=i+1:1:13
      fprintf('i=%d  j=%d \n',i,j);
      testIndex=setdiff([1:68], trainingIndex);
      % prepare training and test data for both gallery and probe
      for k=1:size(pose,4)
          tmp=pose(:,:,i,k);
          tmp=imresize(tmp,1/scale);
          PHOTOS(k,:)=tmp(:)';
          tmp=pose(:,:,j,k);
          tmp=imresize(tmp,1/scale);
          SKETCHS(k,:)=tmp(:)';
      end
      [feature1, ~]=featureDimReduction(PHOTOS,1);
      [feature2, ~]=featureDimReduction(SKETCHS,1);
      trainingX=feature1(trainingIndex,:);
      trainingY=feature2(trainingIndex,:);
      trainingLabel=Labels(trainingIndex);
      testX=feature1(testIndex,:);
      testY=feature2(testIndex,:);
      testLabel=Labels(testIndex);
      % construct triplets to train model
      [X,Ax,Ay,triplet,type]=constructTriplets(trainingX',trainingY',trainingLabel,trainingLabel,[trinum 0 0 trinum]);
     num=size(triplet,1);
     config.method='cuttingPlane'; % cuttingPlane/SDP 
     coeff=1;
     config.param.gamma=size(triplet,1)*coeff;
     ratio=size(trainingX,2)/size(trainingY,2);
     config.param.weight=[1,1,ratio^2,ratio^2];
     config.numOuterIter=100;
     config.numInnerIter=2;
     config.numQPIter=50;
     config.optimized=1; % 0;
     config.verbose=2; % 0-silence, 1 time record, 2 debug,3 statistic
     config.prefix=[config.method,'cmupie_',num2str(i),'_', num2str(j),'-',num2str(num),'_',num2str(config.param.gamma/size(triplet,1))];
     weight=generateWeight(type,config.param.weight);
     
     [Wx,Wy]=RPSA(X,Ax,Ay,triplet,weight,config);
      % classify test sample according to KNN
      for dimension=1:size(feature1,2)
      testX_projection=Wx(1:dimension,:)*testX';
      testY_projection=Wy(1:dimension,:)*testY'; 
      k_neigbor=1;
      Accuracy(dimension)=retrieval_kNN(testX_projection,testLabel, testY_projection,testLabel,k_neigbor);
      Accuracy1(dimension)=retrieval_kNN(testY_projection,testLabel, testX_projection,testLabel,k_neigbor);
      % fprintf('The accuracy for %s with %d-NN is %f\n',algorithm, k,Accuracy);
      end
      %save Accuracy;
      save([pathdir, '',camera{i},'_',camera{j},'_', num2str(scale),flag,config.method,'_RPSA_accuracy.mat'],'Accuracy');
      save([pathdir, '',camera{j},'_',camera{i},'_', num2str(scale),flag,config.method,'_RPSA_accuracy.mat'],'Accuracy');
      figure;
      plot(Accuracy);
      axis([1 length(Accuracy) 0 1.2]);
      xlabel('Num. of dimensions of the learned latent space');
      ylabel('Accuracy');
  end
end


  
     
      
     
    




