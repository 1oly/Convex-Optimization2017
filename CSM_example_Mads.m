rn = load('micgeom.mat'); % positions for the microphones (important when creating our G matrix)
CSM = load('CSM_TE.mat'); % TE= trailing edgematix Olver made from the homepage converted from time domain to frequency domain (in bands of 47 Hz) Top frequency is 47*512=24064 HZ
% This is a DAS script (Delay-And-Sum). It takes P and creates the
% beamformer image of the original sound sources: DAS: P -> X
%Ns = 6; % the dimension of the beamformer picture
% the X we look for is [Ns^2 x Ns^2] in dimension
Nm = size(rn.micgeom,1); % number of microphones

% Region of interest
x = [-0.6 0];           % x grid 
y = [-0.3 0.3];         % y grid

% Beamformer grid
rx = linspace(x(1),x(2),Ns);
ry = linspace(y(1),y(2),Ns);
[X,Y] = meshgrid(rx,ry);

z0 = 0.68; % meaasuring distance. The euclidiean distance in meters between microphones and acoustic sources
df = 47; % change between each frquence. (47Hz between each measure. So a measure is the mean of 47 Hz'ies)
id = 81; % the id for a given frequency (id is to acces the CSM.CSM(:,:,id)
f = id*df; % the corresponding frequency (f is for the beamformer which needs a frequency)
phi = 40; % not used. ONe can define an angle for the beamformer, that the beamformer should use to look along.

P = CSM.CSM(:,:,id); 
[b,gj] = beamformer(Ns,X,Y,z0,f,rn.micgeom,P);
%CSM.CSM(:,:,1) -> 0 HZ
%CSM.CSM(:,:,2) -> [23-71]hz with mean 47 HZ
% these gj's can be reshaped into the alrge G matrix containing our model
% of Green functions
str1 = sprintf('CSM Matrix rank = %d ',rank(CSM.CSM(:,:,id)));
%%
figure('Name',str1)
imagesc(abs(CSM.CSM(:,:,id)))
colorbar()
str2 = sprintf('Beamforming at %d Hz',f);
%%
figure('Name',str2)
imagesc(x,y,real(b))
shading interp
colorbar()
