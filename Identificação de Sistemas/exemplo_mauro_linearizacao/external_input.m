function u = external_input(t,SP1,SP2,t0)
% function u = external_bomba(t,SP1,SP2,t0) retorna o valor de entrada
%   baseado no valor de t.
%

if (t<=t0)
    u=SP1;
else
    u=SP2;
end;

