% g = 2 - X2 + (4*X1)^4
% g = 2 - rv2 + (4*rp1)^4
% Xi ~ N(0,1) for i=1,2
for i=1:length(Tinput)
 Toutput(i).out = 2 - Tinput(i).Xrv2 + (4*(Tinput(i).Xrv1))^4; 
end

% Tinput(i).parameterA