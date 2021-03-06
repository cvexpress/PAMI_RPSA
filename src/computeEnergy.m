function obj=computeEnergy(A,Delta_ik,Delta_ij,weight,sigmma,sigmma3,Co)
%% This function returns the energy.
% * A=W'*W is the parameter we learn;
% * Each column of Delta_ik is $x_i-x_k$; 
% * Each column of Delta_ij is $x_i-x_j$;
% * sigmma is the tradeoff in the energy function.
% * sigmma3 is the weight of pairwise term
obj=0;
reg=0.5*sum(sum(A.*A));
N=size(Delta_ik,2);
loss=zeros(N,1);
% tic
% l=weightedLoss(Delta_ik,Delta_ij,W);
% sum(l)
% toc
l=adaptiveWeightedLoss(Delta_ik,Delta_ij,A);

% tic
% l=weightedLossSparse(Delta_ik_s,Delta_ij_s,W);
% sum(l)
% toc

loss=max(1-l,0).*weight(:,1);
loss=sigmma/N*sum(loss);

loss1=sigmma3/N*sum(sum((Co.*A)));
obj=reg+loss+loss1;
fprintf('obj=%f,reg=%f,loss=%f,loss1=%f\n',obj,reg,loss,loss1);
end