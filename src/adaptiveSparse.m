function [X1,Y1]=adaptiveSparse(X,Y)
sz=size(X);  
ratio=sum(sum(X==0))/(sz(1)*sz(2));
if ratio>0.1
   
    X1=sparse(X);
    Y1=sparse(Y);
    fprintf('****using sparse matrix****\n');
else
    X1=X;
    Y1=Y;
end

end