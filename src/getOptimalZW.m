function [Z,W]=getOptimalZW(Co,Cr,u)
%% This methods return the optimal Z and W
% * Co is pair-wise term
% * Ar is 3 D matrix each slice of which is a constraint
% * u is a vector each element of which is the weight for its corresponding constraints;
sz=size(Cr);
C=-Co;
for i=1:length(u)
      C=C+Cr(:,:,i)*u(i);
end
[Z,W]=eigenDecomposeSymmetricMatrix(-C);  
W=-W;
end