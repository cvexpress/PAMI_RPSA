function [f]=computeObjective(u,auxData)
%% This method return the objective value of the dual problem of SDP.
% * u is the current value of variable;
% * auxData is the auxiliary data;
% * f is the objective value;
global recordSDP;

N=length(u);
[Delta_ik,Delta_ij,Delta_ik_s,Delta_ij_s,weight,config]=deal(auxData{:}); 

% Construct Ahat
if config.verbose==3
   tAhat=tic;
end
Ahat=constructAhat(Delta_ik,Delta_ij,u);
if config.verbose==3
   a=toc(tAhat);
end

if config.verbose==3
   tEig=tic;
end
[~,Ahat_minus]=eigenDecomposeSymmetricMatrix(full(Ahat));
if config.verbose==3
   
   b=toc(tEig);
 
end
f=double(0.5*(sum(sum(Ahat_minus.*Ahat_minus)))-sum(u));
% Compute gradient
global gradient;
if config.verbose==3
   tgrad=tic;
end
gradient=-1-adaptiveWeightedLoss(Delta_ik,Delta_ij,Ahat_minus);
if config.verbose==3
   
   c=toc(tgrad);
   d=toc(config.tSDP);
   recordSDP=[recordSDP;a,b,c,d];
end
global finalW;
finalW=-Ahat_minus;
end
