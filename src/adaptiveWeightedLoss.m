function l=adaptiveWeightedLoss(Delta_ik,Delta_ij,W)

if issparse(Delta_ik)
    l=weightedLossSparse(Delta_ik,Delta_ij,W);
else
    l=weightedLoss(Delta_ik,Delta_ij,W);
end


end