function Ahat=constructPairTerm(Delta_ij,weight)
%% This method constructs the pair term matrix
% * Each column of Delta_ij is $x_i-x_j$;
% * weight is a vector each element of which is the weight of one constraint.
N=length(weight);
D=size(Delta_ij,1);
Co=zeros(D,D);
% U=sparse(N,N);
% U(1:N+1:end)=u';
%Ahat=Delta_ik*U*Delta_ik'-Delta_ij*U*Delta_ij';
  rootW=(sqrt(weight));
  tmp=bsxfun(@times,Delta_ij,rootW);
  Ahat=tmp*tmp'; 
% for i=1:N
%    Ahat=Ahat+(u(i)*Delta_ik(:,i)*Delta_ik(:,i)'-Delta_ij(:,i)*Delta_ij(:,i)');
% end
end

