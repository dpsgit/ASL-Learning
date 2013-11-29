function [] = pLSM_EM(Pw_z, Pd_z, Pz, X, Tz, Nz)

% Pw_z = #words x #topics_from_pLSA 
% Pd_z = #documents x #topics_from_pLSA
% Pz = 
% X = #words x #documents
% Tz = Max duration of topic (roughly corresponds to length of motif)
% Nz = #topics (from pLSA)


function [] = E_Step(Pz_d, Pts_z_d, Pw_z, Ptr_w_z)

Pwtadzts = zeros(size(X, 1), ??, )

end
	
function [] = M_Step()

	norm_Corr(P_wz, X);


end

function [normCorr] = norm_Corr(Pw_z, X)
%	normCorr = zeros(size(Pw_z, 2), size(X, 2)); 
	inverter = Pw_z.^(-1*ones(size(Pw_z)));
	normFactor = X'*(inverter.*Pw_z);
	normCorr = (normFactor.^(-1)).*(X'*Pw_z); % size = #topics x #documents (both from pLSA)
end