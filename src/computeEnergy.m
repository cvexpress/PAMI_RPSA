function obj=computeEnergy(W,Delta_ik,Delta_ij,weight,sigmma)
%% This function returns the energy.
% * W is the parameter we learn;
% * Each column of Delta_ik is $x_i-x_k$; 
% * Each column of Delta_ij is $x_i-x_j$;
% * sigmma is the tradeoff in the energy function.
obj=0;
obj=obj+0.5*sum(sum(W.*W));
N=size(Delta_ik,2);
loss=zeros(N,1);
% tic
% l=weightedLoss(Delta_ik,Delta_ij,W);
% sum(l)
% toc
l=adaptiveWeightedLoss(Delta_ik,Delta_ij,W);

% tic
% l=weightedLossSparse(Delta_ik_s,Delta_ij_s,W);
% sum(l)
% toc

loss=max(1-l,0).*weight;
loss=sigmma/N*sum(loss);
fprintf('reg=%f,loss=%f\n',obj,loss);
obj=obj+loss;

end