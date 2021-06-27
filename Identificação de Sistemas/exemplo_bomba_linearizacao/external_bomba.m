function u = external_bomba(t,SP1,SP2)
% function u = external_bomba(t,SP1,SP2) retorna o valor de entrada
%   baseado no valor de t.
%
% obs.: Esta funcao e um workaround para o problema de entrada
%   externas para o ode.

% SP1=16.34;
% SP2=17.05;

if (t<=200)
    u=SP1;
else
    u=SP2;
end;

