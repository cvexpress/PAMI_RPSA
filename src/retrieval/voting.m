function [label]=voting(INX,limit)
V=zeros(1,limit);
for i=1:length(INX)
    V(INX(i))=V(INX(i))+1;
end
[C,label]=max(V);
end