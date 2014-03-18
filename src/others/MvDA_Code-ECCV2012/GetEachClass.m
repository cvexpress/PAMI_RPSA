function [Ans class_num Label_Class] = GetEachClass(X,Label,type)
% type = 'x',为按照类别分组的X
% type = 'm', 返回各类的均值
% type = 'sw'，返回Sw
% type =  'sb',返回sb
% type = 'sw-i'，返回各类w
% type =  'sb-i',返回各类sb
% type = 'num', return the num of each class

X_Class = [];Mean=[];Sw=[];
Label_unique = unique(Label);
class_num = size(Label_unique,2);
dim = size(X,1);
Index = cell(1,class_num);
Label_Class = Label_unique;
%% index cluster by class_label
for i=1:class_num
    label = Label_unique{i};
    idx = strcmp(Label,label);
    Index{i} = find(idx==1);
end

%% type == 'x'
if strcmp(type,'x') == 1
    X_Class = cell(1,class_num);
    for i=1:class_num
        X_Class{i} = X(:,Index{i});
    end
    Ans = X_Class;
end

if strcmp(type, 'm') == 1
    Mean = zeros(dim,class_num);
    for i=1:class_num
        x = X(:,Index{i});
        Mean(:,i) = mean(x,2);
    end
    Ans = Mean;
end

if strcmp(type, 'sw-i')==1
    Sw = cell(1,class_num);
    for i=1:class_num
        x = X(:,Index{i});
        x_mean = mean(x,2);
        y = x - repmat(x_mean,1,size(x,2));
        Sw{i} = y * y';
    end
    Ans = Sw;
end

if strcmp(type, 'num')==1
     Num = zeros(1,class_num);
    for i=1:class_num
        Num(i) = size(Index{i},2);
    end
    Ans = Num;
end