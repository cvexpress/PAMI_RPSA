function w=generateWeight(type,weight)
n=length(type);
w=zeros(n,1);
for i=1:4
w(type==i)=weight(i);
end
end