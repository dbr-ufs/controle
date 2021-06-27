function dxdt = sys_non2(t,x,SP1,SP2,t0)
% Simulação do modelo proposto pelo aluno Mauro em Abril 2005
% Copyright (c) 2004 por Eduardo Mendes. Todos os direitos reservados.


dxdt=zeros(size(x));

% entrada u

u=external_input(t,SP1,SP2,t0);

% Equacoes de Estado

dxdt(1)=x(2);
dxdt(2)=-3*x(1)-x(2)*x(1)+5*u*u;

