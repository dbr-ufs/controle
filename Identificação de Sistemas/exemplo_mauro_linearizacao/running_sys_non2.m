% Script para execucao do modelo proposto pelo aluno Mauro
% Copyright (c) 2004 por Eduardo Mendes. Todos os direitos reservados.

clear;clc;close all;

dt=0.01;

tff=input('Tempo final de simulacao [20] : ');

if isempty(tff)
    tff=20;
end;

y0=input('Condicoes inicias [0 0] : ');

if isempty(y0)
    y0=[0 0];
end;

Umax=input('Valor do Degrau [1] : ');

if isempty(Umax)
    Umax=1;
end;

t=(0:dt:tff)';

u=ones(size(t));  % Entrada degrau unitario

[ans,y]=ode45(@sys_non2,t,y0,[],0,Umax,0);

figure(1);plot(t,y);title(sprintf('Sistema Nao-Linear com entrada x(t)=%gu(t)',Umax));
xlabel('Tempo');ylabel('Estados');legend('Saida','Derivada');grid;

yss=y(end,:);  % Estado Estacionario

% Nova simulacao - t=0 (para facilitar)

Ku=input('Degrau no ponto de operacao [0.05] : ');

if isempty(Ku)
    Ku=0.05;
end;

t0=input('Inicio do degrau [5] : ');

if isempty(t0)
    t0=5;
end;

if t0>tff
    t0=tff/2;
end;

% Linearizacao

f=sym('f');
X1=sym('X1');
X2=sym('X2');
U=sym('U');

f=[X2;(-3*X1-X1*X2+5*U*U)];

A=jacobian(f,[X1 X2]);
B=jacobian(f,'U');

% Pontos Fixos

x2=0;
x1=subs(solve(subs(f(2),'X2',x2),'X1'),'U',Umax);

% Sistema Linear

a=subs(subs(subs(A,'X1',x1),'X2',x2),'U',Umax);
b=subs(subs(subs(B,'X1',x1),'X2',x2),'U',Umax);
c=[1 0];
d=0;

sys=ss(a,b,c,d);

% Simulacao do sistema linear

for j=1:length(Ku)
    
    [ans,y1]=ode45(@sys_non2,t,yss,[],Umax,Umax+Ku(j),t0);
    
    figure(2*j);plot(t,y1);
    title(sprintf('Sistema Nao-Linear com degrau no ponto de operacao de %g',Ku(j)));
    xlabel('Tempo');ylabel('Estados');
    legend('Saida','Derivada');grid;
    
    i=find(t>=t0);
    
    u=zeros(size(t));
    
    u(i)=Ku(j)*ones(size(i));
    
    yl=lsim(sys,u,t);
    
    figure(2*j+1);plot(t,y1(:,1),t,yl+yss(1));
    title(sprintf('Comparacao Nonlinear e Linearizado com degrau no ponto de operacao de %g',Ku(j)));
    xlabel('Tempo');ylabel('Saida');grid;
    
end;


