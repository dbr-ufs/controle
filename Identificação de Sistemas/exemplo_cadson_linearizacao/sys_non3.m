function dxdt = sys_non3(t,x,SP1,SP2,t0)
% Simulação do modelo proposto pelo aluno Cadson em Abril 2005
% Copyright (c) 2004 por Eduardo Mendes. Todos os direitos reservados.


dxdt=zeros(size(x));

% entrada u

q=external_input(t,SP1,SP2,t0);

% Parametros

A=1;
k=3;

% Equacoes de Estado

dxdt(1)=q/A-k*abs(sqrt(x(1)))/A; % Garantir um numero real - O matlab retorna complexo

