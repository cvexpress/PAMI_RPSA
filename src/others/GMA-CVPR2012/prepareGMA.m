function [dataCell]=prepareGMA(X,Y,Label)
%each row of X is an observation
dataCell=cell(2,1);


dataCell{1}.data=X;
dataCell{2}.data=Y;
dataCell{1}.label=Label;
dataCell{2}.label=Label;
end