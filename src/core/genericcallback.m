function genericcallback (t, f, x,auxData)
global recordSDP;
global finalA;
[Co,Delta_ik,Delta_ij,Delta_ik_s,Delta_ij_s,weight,config]=deal(auxData{:}); 
if config.verbose==2
    obj=computeEnergy(finalA,Delta_ik_s,Delta_ij_s,weight,config.param.gamma,config.param.gamma3,Co);
    t1=toc(config.tSDP);
    recordSDP=[recordSDP;t1,obj];
end
fprintf('iter=%3d  objective function=%0.3g \n', t, -1.0*f);
end