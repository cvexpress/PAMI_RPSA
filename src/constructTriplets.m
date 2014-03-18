function [X,Ax,Ay,triplets,type]=constructTriplets(Xn,Yn,XLabels,YLabels,num_pairs)
%% This method constructs triplets to train model (two modality case)
% * Xn is data for modality X, each row of which is an oberservation
% * Yn is data for modality Y, each row of which is an oberservation
% * XLabels is the label vector for modality X 
% * YLabels is the label vector for modality Y
% * num_pair is the number of pairs for each type of triplet.
% * X outputs the augmented data
% * Ax is the augment projection matrix for modality X
% * Ay is the augment projection matrix for modality Y
% * triplets is the triplets constructed
% * type indicates the type of triplets



[m,num]=size(Xn);
[n,num]=size(Yn);
Ax=[eye(m);zeros(n,m)];
Ay=[zeros(m,n);eye(n)];
triplets=zeros(sum(num_pairs*num),3);
type=zeros(size(triplets,1),1);
base=0;
for i=1:4
    if num_pairs(i)>0
     switch (i)
         case 1
             % d(x_i,y_k)-d(x_i,x_j)>=0
             % i,j,k   i from x and j k from y;
             for iter=1:num
             tmp=zhkuang_findOtherViewComparison(iter,Xn,Yn,XLabels,YLabels, i,num_pairs(i));
             triplets(base+(1:num_pairs(i)),:)=[iter*ones(num_pairs(i),1),iter*ones(num_pairs(i),1)+num,num+tmp];
             type(base+(1:num_pairs(i)),:)=1;
             base=base+num_pairs(i);
             end
         case 2
             % not check
             for iter=1:num
             tmp=zhkuang_findOneViewComparison(iter, Xn,XLabels, num_pairs(i));
             triplets(base+(1:num_pairs(i)),:)=[iter*ones(num_pairs(i),1),tmp];
             type(base+(1:num_pairs(i)),:)=2;
             base=base+num_pairs(i);
             end
         case 3
             % not check
             for iter=1:num
             tmp=zhkuang_findOneViewComparison((iter), Yn,YLabels, num_pairs(i));
             triplets(base+(1:num_pairs(i)),:)=num+[(iter)*ones(num_pairs(i),1),tmp];
             type(base+(1:num_pairs(i)),:)=3;
             base=base+num_pairs(i);
             end
             
         case 4
             % i j k, i from y, j k from x;
             for iter=1:num
             tmp=zhkuang_findOtherViewComparison((iter), Xn,Yn,XLabels, YLabels, i,num_pairs(i));
             triplets(base+(1:num_pairs(i)),:)=[num+(iter)*ones(num_pairs(i),1),(iter)*ones(num_pairs(i),1),tmp];
             type(base+(1:num_pairs(i)),:)=4;
             base=base+num_pairs(i);
             end   
     end
  end
       
end
Xn=(Ax*Xn);
Yn=(Ay*Yn);
X=[Xn,Yn];

end

function comparisonIndex=zhkuang_findOneViewComparison(index,data,Labels,num_pairs)
      myLabel=Labels(index);
      base=data(:,index);
      sameLabelIndex=find((Labels==myLabel));
      sameLabelIndex=setdiff(sameLabelIndex,index);
      Y=data(:,sameLabelIndex);
      [~, comparisonIndex1]=pdist2(Y',base', 'euclidean','Smallest',num_pairs);
      
      differentLabelIndex=find(Labels~=myLabel);
      Y=data(:,differentLabelIndex);
      [~, comparisonIndex2]=pdist2(Y',base', 'euclidean','Smallest',num_pairs);
      
      comparisonIndex(:,1)=sameLabelIndex(comparisonIndex1);
      comparisonIndex(:,2)=differentLabelIndex(comparisonIndex2);
      
end
function comparisonIndex=zhkuang_findOtherViewComparison(index,Xn,Yn,XLabels, YLabels,type,num_pairs)
if type==1
   %finding amongst Yn
   base=Yn(:,index);
   I=find(YLabels~=XLabels(index));
   Y=Yn(:,I);
   [~, comparisonIndex]=pdist2(Y',base', 'euclidean','Smallest',num_pairs);
   comparisonIndex=I(comparisonIndex);
elseif type==4
   %finding amongst Xn
   base=Xn(:,index);
   I=find(XLabels~=XLabels(index));
   X=Xn(:,I);
   [~, comparisonIndex]=pdist2(X',base', 'euclidean','Smallest',num_pairs);
   comparisonIndex=I(comparisonIndex);
end

end
  