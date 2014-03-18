function  m=vec2SymmetricM(v,d)

ltri=tril(ones(d,d));
m=zeros(d,d);
m(logical(ltri))=v;
m=m+m'-diag(diag(m));


end