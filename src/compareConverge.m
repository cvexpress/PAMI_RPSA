recordCuttingPlane=importdata('cuttingPlane2_1000000_100recordCuttingPlane.mat');

figure;
plot(recordCuttingPlane(:,1),log(recordCuttingPlane(:,2)),'r-*');

recordSDP=importdata('SDP3_1000000_100recordSDP.mat');

hold on;
plot(recordSDP(:,1),log(recordSDP(:,2)));