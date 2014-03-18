function  [map,map1]=computeMAP(X,Y,XLabel,YLabel)
%% This method compute the MAP of the queries
% * X is the query set, each row of which is an oberservation
% * Y is the gallery set, each row of which is an oberservation
% * XLabel is the label vector of X
% * YLabel is the label vector of Y; Its value must be from 1 up to k
% * map is the MAP of the query set
N=size(X,1);
numGallery=size(Y,1);
account=hist(YLabel);
AP= zeros(N,1);
AP1=zeros(N,1);
for i=1:N
   label=XLabel(i);
   [~,sortIndex]=pdist2(Y,X(i,:), 'euclidean','smallest',numGallery);
   flag=(YLabel(sortIndex)==label);
   prec= cumsum(flag)./[1:numGallery]';
   recall= cumsum(flag)/account(label);
   AP(i)= diff([0;recall]')*prec;
   AP1(i)=apInterp([0;recall],[1;prec]);
end
map=mean(AP);
map1=mean(AP1);

end


function ap=apInterp(recall,prec)
[recall,index]=unique(recall);
prec=prec(index);
ap=mean(interp1(recall,prec,[0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]));
end