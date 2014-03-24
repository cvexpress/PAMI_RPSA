function w=generateWeight(type,weight,triplet,X)
%%This method generates the weights for each penality term.
% type is a vector, each element of which corresponds to a triplet
% weight is a matrix, weight(i,1) corresponds to the weight of the ith type
% triplet penality; weight(i,2) corresponds to the weight of the ith type
% pair penality
% X is the data matrx, each column of which is an instance;

%Delta_ik=X(:,triplet(:,1))-X(:,triplet(:,3));
Delta_ij=X(:,triplet(:,1))-X(:,triplet(:,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=length(type);
w=zeros(n,1);
for i=1:4
w(type==i)=weight(i);
end
w=[w,ones(n,1)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%for pair term

distance=Delta_ij.*Delta_ij;
distance=sqrt(sum(distance));
distance=distance';
maxv=max(distance)/0.01;
ratio=exp(-distance/maxv);

% w(:,2)=w(:,2).*(ratio);
% w(:,1)=w(:,2);

end