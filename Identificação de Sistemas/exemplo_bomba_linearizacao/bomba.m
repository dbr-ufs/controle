function dhdt = bomba(t,h,SP1,SP2)
% Simulação da planta de bombeamento modelada na secao 1.4
% Copyright (c) 2004 por Eduardo Mendes. Todos os direitos reservados.


dhdt=zeros(size(h));

% Parâmetros

% Area do tanque
A=2.5;

% entrada u em mA

u=external_bomba(t,SP1,SP2);

% h eh o nivel

dhdt = 5.6e-4*sqrt(3554.9+682.8*u-1000*h(1)-10300)/A - ...
       (3.06e-5+1.25e-5*sqrt(1000*h(1)))*sqrt(1000*h(1))/A - ...
        5.6e-4*sqrt(3554.9+682.8*15.61-10300)/A; % Off-set


