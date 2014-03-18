function [Z,W]=getOptimalZW(Cr,u)
%% This methods return the optimal Z and W
% * Ar is 3 D matrix each slice of which is a constraint
% * u is a vector each element of which is the weight for its corresponding constraints;
sz=size(Cr);
C=zeros(sz(1),sz(2));
for i=1:length(u)
      C=C+Cr(:,:,i)*u(i);
end
[Z,W]=eigenDecomposeSymmetricMatrix(-C);  
W=-W;
end