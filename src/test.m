%%%%%%%%%%%%%%%test 

X=rand(4000,10);
A=X*X';
tic
v=eig(A);
toc