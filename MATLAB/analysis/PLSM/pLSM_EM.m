function [Pz_d, Pts_zd, Pwtr_z] = pLSM_EM(counts, nMotifs, Tz)

	% Pw_z = #words x #topics_from_pLSA 
	% Pd_z = #documents x #topics_from_pLSA
	% Pz = 
	% X = #words x #documents
	% Tz = Max duration of topic (roughly corresponds to length of motif)
	% Nz = #topics (from pLSA)

	if nargin<4
	   Par.maxit  = 400;
	   Par.Leps   = 1; 
	end;   

	Nw  = size(counts,1); % # of words
	Ta = size(counts,2); % # of time steps
	D = size(counts,3); % # of documents

	% initialize Pz, Pd_z,Pw_z
	[Pz_d, Pts_zd, Pwtr_z] = pLSM_init(Nw,Ta,Tz,D,nMotifs);

	% allocate memory for the posterior
	Pzts_wtad = zeros(Nw,Ta,D,nMotifs,Ta-Tz+1); 

	Li    = [];
	maxit = Par.maxit;

	% EM algorithm
	for it = 1:maxit   
	   fprintf('Iteration %d \n',it);
	   
	   % E-step
	   Pzts_wtad = E_Step(Pz_d, Pts_zd, Pwtr_z);

	   % M-step
	   [Pz_d, Pts_zd, Pwtr_z] = M_Step(Pzts_wtad, counts);


	end
end


function [Pz_d, Pts_zd, Pwtr_z] = pLSM_init(Nw,Ta,Tz,D,nMotifs)
	Pz_d = rand(D,nMotifs);
	Pts_zd = rand(nMotifs,D,Ta - Tz + 1);
	Pwtr_z = rand(nMotifs,Nw,Tz);

	Pz_d = Pz_d ./ sum(Pz_d,2);

	for z = 1:nMotifs
		for d = 1:D
			Pts_zd(z,d,:) = Pts_zd(z,d,:) ./ sum(Pts_zd(z,d,:));
		end
	end

	for z = 1: nMotifs
		toNormalize = Pwtr_z(z,:,:);
		Pwtr_z(z,:,:) = Pwtr_z(z,:,:) ./ sum(toNormalize(:));
	end

end

function Pzts_wtad = E_Step(Pz_d, Pts_zd, Pwtr_z)
	Nz = size(Pz_d,2);
	Nw = size(Pwtr_z,2);
	Tz = size(Pwtr_z,3);
	D = size(Pz_d,1);
	Ts = size(Pts_zd,3);

	% get numerator of probability
	Pzts_wtad = zeros(Nw,Ts + Tz - 1, D, Nz, Ts);
	for z = 1 : Nz
		for ts = 1 : Ts
			A = zeros(Nw,Tz,D);
			for d = 1 : D
				A(:,:,d) = Pz_d(d,z) * Pts_zd(z,d,ts) * Pwtr_z(z,:,:);
			end
			Pzts_wtad(:,ts : ts + Tz - 1,:,z,ts) = A;
		end
	end

	% normalize by z, ts
	for w = 1 : Nw
		for ta = 1 : Ts + Tz - 1
			for d = 1 : D
				toNormalize = Pzts_wtad(w,ta,d,:,:);
				normSum = sum(toNormalize(:));
				if normSum == 0
					Pzts_wtad(w,ta,d,:,:) = 1 / (Nz * Ts) * ones(Nz,Ts);
				else
					Pzts_wtad(w,ta,d,:,:) = Pzts_wtad(w,ta,d,:,:) ./ sum(toNormalize(:));
				end
			end
		end
	end	
end
	
function [Pz_d, Pts_zd, Pwtr_z] = M_Step(Pzts_wtad, counts)

	Nw = size(Pzts_wtad, 1); %
	Tz = size(Pzts_wtad,2) - size(Pzts_wtad,5) + 1;
	D = size(Pzts_wtad,3);
	Ts = size(Pzts_wtad, 5); %
	Nz = size(Pzts_wtad, 4);

	Pz_d = zeros(D,Nz);
	Pts_zd = zeros(Nz,D,Ts);


	for ts = 1:Ts
		for tr = 1:Tz
			for w = 1:Nw
				countBlock = repmat(squeeze(counts(w, ts + tr - 1, :))', Nz, 1);
				otherThing = squeeze(Pzts_wtad(w, ts + tr - 1, :, :, ts));
				
				Pts_zd(:,:,ts) = Pts_zd(:,:,ts) + countBlock .* otherThing;
			end
		end

		Pz_d = Pz_d + Pts_zd(:,:,ts)';
	end

	% Normalize Pz_d
	Pz_d = Pz_d ./ sum(Pz_d,2);

	% Normalize Pts_zd
	for z = 1:Nz
		for d = 1:D
			Pts_zd(z,d,:) = Pts_zd(z,d,:) / sum(Pts_zd(z,d,:));
		end
	end

	Pwtr_z = zeros(Nz, Nw, Tz);
	for z = 1:Nz
		for d = 1:D
			for ts = 1:Ts
				A = counts(:, ts:(ts+Tz-1), d) .* Pzts_wtad(:, ts:(ts+Tz-1), d, z, ts);
				A = reshape(A,1,Nw,Tz);
				Pwtr_z(z, :, :) = Pwtr_z(z, :, :) + A;
			end
		end
	end

	% Normalize Pwtr_z
	for z = 1: Nz
		toNormalize = Pwtr_z(z,:,:);
		Pwtr_z(z,:,:) = Pwtr_z(z,:,:) ./ sum(toNormalize(:));
	end

end


