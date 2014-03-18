function [Xtraining,Xtesting]=precoessData(Xtraining,Xtesting)
%% This function normalizes training data and testing data
% * Each row of Xtraining is an observation
% * Each row of Xtesting is an observation

[Xtraining,mu,sigma]=zscore(Xtraining);

Xtesting=bsxfun(@minus,Xtesting,mu);
row=size(Xtesting,1);
Xtesting=Xtesting./(repmat(sigma,row,1)+eps);

end