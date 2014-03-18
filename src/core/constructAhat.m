function Ahat=constructAhat(Delta_ik,Delta_ij,u)
%% This method constructs the matrix Ahat
% * Each column of Delta_ik is $x_i-x_k$; 
% * Each column of Delta_ij is $x_i-x_j$;
% * u is a vector each element of which is the weight of one constraint.
N=length(u);
D=size(Delta_ik,1);
Ahat=zeros(D,D);
% U=sparse(N,N);
% U(1:N+1:end)=u';
%Ahat=Delta_ik*U*Delta_ik'-Delta_ij*U*Delta_ij';
  rootW=(sqrt(u));
 
  tmp1=bsxfun(@times,Delta_ik,rootW);
 
   tmp2=bsxfun(@times,Delta_ij,rootW);
   Ahat=tmp1*tmp1'-tmp2*tmp2';
   
% for i=1:N
%    Ahat=Ahat+(u(i)*Delta_ik(:,i)*Delta_ik(:,i)'-Delta_ij(:,i)*Delta_ij(:,i)');
% end

Ahat=-Ahat;
end

