function [b,gj] = beamformer(Ns,X,Y,z0,f,rn,CSM)

% Number of microphones in array
M = size(rn,1); 

% Constants
c = 343;               % Speed of sound
omega = 2*pi*f;

r0 = sqrt(X.^2 + Y.^2 + z0^2);

% Allocate memory
rmn = zeros(Ns,Ns,M);
gj = zeros(Ns,Ns,M);
b = zeros(Ns,Ns);

for n = 1:M
    rmn(:,:,n) = sqrt((X-rn(n,1)).^2+(Y-rn(n,2)).^2 + z0^2);
    gj(:,:,n) = (rmn(:,:,n)./r0).*exp(1j*omega.*rmn(:,:,n)./c);
end

CSM(logical(eye(size(CSM)))) = 0;  % Diagonal removal

% DELAY AND SUM BEAMFORMER OUTPUT
for ii = 1:length(X)
    for jj = 1:length(Y)
        e = squeeze(gj(ii,jj,:));
        b(ii,jj) = dot(e,CSM*e)/(M^2-M);
    end
end
end