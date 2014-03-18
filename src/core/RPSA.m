function [Wx,Wy]=RPSA(X,Ax,Ay,triplet,weight,config)
%% This function implements relatively-paired  space analysis. 
% * Column of X is an augmented instance, which may come from any modality;
% * Ax and Ay are projection matrix so that Wx=W*Ax and Wy=W*Ay;
% * Each row of triplet is of the structure (i,j,k), which means  distance $(X_i,X_k)$>= distance $(X_i,X_j)$;
% * Each element of weight is the coefficient of its corresponding triplet;
% * The config contains the parameters and options;
% * Wx is the projection mapping for modality x while Wy for modality y;

%% The enery function minimized
% 
% 
% $$min \frac{1}{2}||{\rm A}||_{\rm F}^2+\frac{\gamma_2}{N} \sum \xi _(i,j,k)$$
%
% 
% $$\;\; s.t. {\rm Tr}({\bf AC}_{i,j,k}) \ge 1 - \xi _{i,j,k},\;\;{\bf A}\succeq 0\;\;  {\rm and} \;\; \xi _{i,j,k} \ge 0, \;\forall (i,j,k) \in S$$
if strcmp(config.method,'SDP')
% This option is for the problem with small training triplets
fun=@SDPMetricLearning;
elseif strcmp(config.method,'cuttingPlane')
% This option is for the problem with large scale training triplets
fun=@cuttingPlaneMetricLearning;

end
% Optimize the enery function;
[A] = feval(fun, X,triplet,weight,config);
W=getProjection(A); % very important bug;
% Recover the projection mapping for modality x and modality y; 
Wx=W*Ax;
Wy=W*Ay;
end