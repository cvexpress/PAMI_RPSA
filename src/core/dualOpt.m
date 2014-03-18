function  [W2]=dualOpt(Xn,Yn,Triplet,c3)
%%MAXIteration=50;

numConstraints=size(Triplet{1},1)+size(Triplet{2},1)+size(Triplet{3},1)+size(Triplet{4},1);
u=0/(numConstraints)*ones(1,numConstraints);
constructAr(Xn,Yn,Triplet,0);
lb=zeros(1,numConstraints);
ub=c3/numConstraints*ones(1,numConstraints);
%options=optimset('GradObj','on','Display','iter','Algorithm','interior-point','Hessian','lbfgs');

global Ahat_minus;

global numCall;
numCall=0;
tic
  u=lbfgsb(u,lb,ub,'computeObjective','computeGradient',...
           [],'genericcallback','maxiter',3,'m',4,'factr',1e-7,...
           'pgtol',1e-5);
a=toc;
fprintf('Finishing training model in %fs \n',a);
W2=-Ahat_minus;
end

