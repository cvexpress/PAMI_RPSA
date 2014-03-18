clc
clear all;
close all;
addpath(genpath(pwd));
dimension=10;
%The proposed method
%wikiDemo
%% Other method
% * CCA
% * PLS
% * BLM

% load data;

dataPath='.\data\wikipedia_info\';
pathdir='.\result\';
[~, ~, trainingLabel] = textread([dataPath 'trainset_txt_img_cat.list'], '%s %s %d');
[~, ~, testLabel] = textread([dataPath 'testset_txt_img_cat.list'],'%s %s %d');
database=importdata([dataPath,'raw_features.mat']);
trainingX=database.I_tr;
trainingY=database.T_tr;
testX=database.I_te;
testY=database.T_te;
[trainingX,testX]=precoessData(trainingX,testX);
[trainingY,testY]=precoessData(trainingY,testY);



% CCA

[Wx, Wy, ~] = cca(trainingX',trainingY');
Wx=real(Wx');
Wy=real(Wy');

testX_projection=Wx(1:dimension,:)*testX';
testY_projection=Wy(1:dimension,:)*testY';  
[map,map1]=computeMAP(testX_projection',testY_projection',testLabel,testLabel);
fprintf('The map of CCA is %f, %f.\n',map,map1);
[map,map1]=computeMAP(testY_projection',testX_projection',testLabel,testLabel);
fprintf('The map of CCA is %f, %f.\n',map,map1);

%PLS
[W,Z] = PLS_basesLatest(trainingX',trainingY',dimension);
testX_projection = (W'*(testX'));
testY_projection = (Z\(testY'));
[map,map1]=computeMAP(testX_projection',testY_projection',testLabel,testLabel);
fprintf('The map of PLS is %f, %f.\n',map,map1);
[map,map1]=computeMAP(testY_projection',testX_projection',testLabel,testLabel);
fprintf('The map of PLS is %f, %f.\n',map,map1);
