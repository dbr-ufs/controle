% Arquivo mestre para rodar o exemplo da Bomba

clear;clc;

options = odeset('RelTol',1e-9);
load ens_25.dat  % Da variavel ens_25 vamos tirar os valores iniciais e finais

t=ens_25(:,1);  % Variavel tempo
Y=ens_25(:,2);  % Saida Medida
h0=ens_25(1,2); % Valor inicial nivel

% Entrada

i=find(t<=200);

SP1=16.34;

SP2=17.05+.3;

u=SP2*ones(size(t));

u(i)=SP1*ones(size(i));

% Usando o ode45

[ans,h]=ode45(@bomba,t,h0,options,SP1,SP2);

figure(1);plot(t,Y,t,h);

% Linearizacao

syms f H U;

f1=5.6e-4*sqrt(3554.9+682.8*U-1000*H-10300)/2.5 - (3.06e-5+1.25e-5*sqrt(1000*H))*sqrt(1000*H)/2.5 - 5.6e-4*sqrt(3554.9+682.8*15.61-10300)/2.5;
f = [f1];

A=jacobian(f,[H]);
B=jacobian(f,[U]);

a=subs(subs(A,'H',h(end)),'U',SP2);
b=subs(subs(B,'H',h(end)),'U',SP2);
% a=subs(subs(A,'H',h0),'U',SP1)
% b=subs(subs(B,'H',h0),'U',SP1)
c=1;
d=0;

sys=ss(eval(a),eval(b),c,d);

% Simulacao em torno do ponto de linearizacao

Ku=input('Valor da perturbacao (0.5) => ');

if isempty(Ku)
    Ku=0.5;
end;

[ans,h1]=ode45(@bomba,t,h(end),options,SP2,SP2+Ku);

i=find(t>200);

ul=zeros(size(t));

ul(i)=Ku*ones(size(i));

hl=lsim(sys,ul,t);

figure(2);plot(t,h1,t,hl+h(end));

% Dentro dos dados

a=subs(subs(A,'H',h(1)),'U',SP1);
b=subs(subs(B,'H',h(1)),'U',SP1);
% a=subs(subs(A,'H',h0),'U',SP1)
% b=subs(subs(B,'H',h0),'U',SP1)
c=1;
d=0;

sys=ss(eval(a),eval(b),c,d);

Ku=SP2-SP1;

ul=zeros(size(t));

ul(i)=Ku*ones(size(i));

hl=lsim(sys,ul,t);

figure(3);plot(t,h,t,hl+h(1));

