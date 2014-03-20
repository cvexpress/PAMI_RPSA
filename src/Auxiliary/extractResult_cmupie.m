%%This script is to extract the result of RPSA (SDP, or cuttingPlane)

camera={'c02' 'c05' 'c07' 'c09' 'c11' 'c14' 'c22' 'c25' 'c27' 'c29' 'c31' 'c34' 'c37'};
   
Result=zeros(13,13,6);
dataset='cmupie';
pathdir='..\..\..\result\';
config.method='GMLDA'; %SDP or cuttingPlane
index=   [12     9      8     6     4      3     13   11    7      5     2     1    10];       

for i=1:13
    for j=1:13
        if(i~=j)
        path=[pathdir, dataset,camera{i},'_',camera{j},'_', config.method,'.mat'];
        acc=importdata(path);
        Result(index(i),index(j),:)=acc;
        end
    end
end
finalR=max(Result,[],3);
 path=[pathdir, dataset,'finalResult', config.method,'.mat'];
 save(path,'finalR');