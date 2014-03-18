function l=adaptiveWeightedLoss(Delta_ik,Delta_ij,A)

if issparse(Delta_ik)
    l=weightedLossSparse(Delta_ik,Delta_ij,A);
else
    l=weightedLoss(Delta_ik,Delta_ij,A);
end


end