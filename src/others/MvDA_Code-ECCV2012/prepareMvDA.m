function [X_multiview,Label_multiview]=prepareMvDA(X,Y,Label)
%each column of X is an observation
X_multiview=cell(1,2);
Label_multiview=cell(1,2);
X_multiview{1}=X;
X_multiview{2}=Y;
for i=1:length(Label)
Label_multiview{1}{i}=int2str(Label(i));
Label_multiview{2}{i}=int2str(Label(i));
end



end