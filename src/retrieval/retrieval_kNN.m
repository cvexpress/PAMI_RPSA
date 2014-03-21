function [Accuracy]=retrieval_kNN(trainedView1, trainedView1Lable, testView2,testView2Label,k)
[r,c]=size(trainedView1);
[r, c1]=size(testView2);
limit=max(trainedView1Lable);
num=0;
for iter=1:c1
%   distance=zeros(c,1);
  distance=pdist2(trainedView1',testView2(:,iter)');  
%   for innerIter=1:c
%     distance(1,innerIter)=norm(testView2(:,iter)-trainedView1(:,innerIter),2);
%   end
  %% sort distance
  [B,INX]=sort(distance);
  INX=trainedView1Lable(INX);
  if testView2Label(iter)==voting(INX(1:k),limit)
      num=num+1;
  end
  
end
Accuracy=num/c1;
end