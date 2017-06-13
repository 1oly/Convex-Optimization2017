rn = load('micgeom.mat');
CSM = load('CSM_TE.mat');

Ns = 50;

% Region of interest
x = [-0.6 0];           % x grid 
y = [-0.3 0.3];         % y grid

% Beamformer grid
rx = linspace(x(1),x(2),Ns);
ry = linspace(y(1),y(2),Ns);
[X,Y] = meshgrid(rx,ry);

z0 = 0.68;
df = 47;
id = 81;
f = id*df;
phi = 40;

[b,gj] = beamformer(Ns,X,Y,z0,f,rn.micgeom,CSM.CSM(:,:,id));
figure(1)
imagesc(abs(CSM.CSM(:,:,id)))
figure(2)
imagesc(x,y,real(b))
shading interp
colorbar()