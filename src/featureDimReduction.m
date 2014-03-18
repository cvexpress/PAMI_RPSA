function [result, projection]=featureDimReduction(X,flag)
%% This methods reduces the dimensionality of features
% * Each row of X correpsond to an observation
% * flag indicates whether the dimension is reduced using PCA
% * result is the reduced features
% * projection is the projection matrix obtained

if nargin==1
   flag=1;
end
if flag==1
%[tmp,projection.mu,projection.sigma]=zscore(X);
tmp=X;
%if size(X,1)<size(X,2)
    % [COEFF,SCORE,latent] = princomp(tmp,'econ');
%else
     [COEFF,SCORE,latent] = princomp(tmp);
%end
    e=cumsum(latent)./sum(latent);
    [inx]=find(e>=1);
    result=SCORE(:,1:inx(1));
    %result=zscore(result);
    projection.coeff=COEFF(:,1:inx(1));
else
    result=X;
    projection=[];
end
end
