function [p]=getProjection(W2)

% [V,D] = eig(W2);
% [Y,I] = sort(max(diag(D),0),'descend') ;
% V = V(:,I);
% p=V*sqrt(diag(Y));
% p=p';


[U S,V] = svd(W2);
[Y,I] = sort(max(diag(S),0),'descend') ;
U = U(:,I);
p=U*sqrt(diag(Y));
p=p';
end