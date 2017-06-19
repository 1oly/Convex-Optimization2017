clear all;
close all;
clc;
%%
Ns = 15; % the dimension of the beamformer picture
CSM_example
%%
% http://ask.cvxr.com/t/square-of-frobenius-norm/3765/6
% Michael C. Grant gives; 
Gt = reshape(gj,Ns*Ns,Nm);
G = Gt';
%%
lam = max(eig(P));
cvx_begin %quiet
    %cvx_solver_settings('max_iters',20)
    cvx_precision low
    % ------------ Holtgen ------------------------------------------------
    %variable X(Ns*Ns,Ns*Ns) %hermitian 
    % naive
    %minimize( sum_square_abs(vec(P-G*X*Gt)) ) % should take the Complex aspect into account
    %X == semidefinite(Ns*Ns,Ns*Ns)
    % holtgen eq. 11
    %minimize( sum_square_abs(vec(P-G*X*Gt)) + lam*norm(diag(X),1) ) % should take the Complex aspect into account
    %X == semidefinite(Ns*Ns,Ns*Ns)
    % ------------ Martin -------------------------------------------------
    variable M(Nm,Nm)
    variable D(Ns*Ns,Ns*Ns) diagonal nonnegative
    % Martins 1
    
    % Martins 2
    minimize(sum_square_abs( vec(P - G*(Gt*M*G + D)*Gt))  + lam*trace(real(D+Gt*M*G)) + lam*trace(imag(D+Gt*M*G)))
    M == semidefinite(Nm,Nm)
    
cvx_end
display(cvx_status)
display(cvx_optval)
%%
% if case is Martin's, then: X = Gt*M*G + D
X = real(Gt*M*G + D);
res_img = reshape(diag(X),Ns,Ns);
%%
figure(3)
imagesc(res_img)
colorbar()
%%
figure(4)
imagesc(X)
colorbar()
%%
figure(5)
subplot(1,2,1)
imagesc(x,y,real(b))
colorbar()
title('DAS method')
subplot(1,2,2)
imagesc(res_img)
colorbar()
title('Naive approach')
str_save = sprintf('./../../pictures/ComparImgMartin2Ns%d',Ns)
print(gcf,str_save,'-dpng')