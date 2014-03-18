function [Ahat_plus,Ahat_minus]=eigenDecomposeSymmetricMatrix(Ahat)
Ahat=(Ahat+Ahat')/2;
[v d]=eig(Ahat);
Ahat_plus=v*max(d,0)*v';
Ahat_minus=v*min(d,0)*v';
end