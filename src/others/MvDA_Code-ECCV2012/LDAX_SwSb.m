function   W_lda = LDAX_SwSb(Sw,Sb)
[h A H]= svd(Sw);
for i=1:size(A,2)
    A(i,i) = 1.0/sqrt(A(i,i));
end
M1 = H * A;
M4 = M1' * Sb * M1;
[u EV U] = svd(M4);

EE = M1 * U;

eig_val_unsort = diag(EV);
V = EE;

[eigen_value,index] = sort(eig_val_unsort, 'descend');

dim = size(Sw,1);
lda_dim = size(Sb,1);
W_lda = zeros(dim,lda_dim);
for i = 1: lda_dim
    v =  V(: , index(i));
    v = v / norm(v);
    W_lda(:, i ) =v;
end
fprintf('Trainset LDA Model Finished\n');