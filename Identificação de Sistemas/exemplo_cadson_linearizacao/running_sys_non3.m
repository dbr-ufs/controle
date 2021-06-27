% Script para execucao do modelo proposto pelo aluno Cadson
% Copyright (c) 2005 por Eduardo Mendes. Todos os direitos reservados.

clear;clc;close all;

disp('Nas equacoes de estado deste sistema ha uma raiz quadrada.');
disp('Como o matlab retorna valores complexos com a parte imaginaria');
disp('praticamente zero foi introduzida a funcao abs para evitar esse');
disp('inconveniente.');
disp(' ');
disp('Notar tambem que a resposta do sistema para excursoes de degrau');
disp('pequenas apresenta oscilacoes caso nao haja intervencao nos.');
disp('parametros do ode45.');
disp(' ');


dt=0.001;

oldOpts=odeset;

newOpts=odeset(oldOpts,'InitialStep',dt,'MaxStep',dt);

%newOpts=odeset(newOpts,'OutputFcn','odeplot');

tff=input('Tempo final de simulacao [20] : ');

if isempty(tff)
    tff=20;
end;

y0=input('Condicoes iniciais [0] : ');

if isempty(y0)
    y0=[0];
end;

Umax=input('Valor do Degrau [1] : ');

if isempty(Umax)
    Umax=1;
end;

t=(0:dt:tff)';

u=ones(size(t));  % Entrada degrau unitario

[ans,y]=ode45(@sys_non3,t,y0,newOpts,0,Umax,0);

figure(1);plot(t,y);title(sprintf('Sistema Nao-Linear com entrada x(t)=%gu(t)',Umax));
xlabel('Tempo');ylabel('Estado');legend('Saida');grid;

yss=y(end,:);  % Estado Estacionario

% Nova simulacao - t=0 (para facilitar)

disp('Para o exemplo do pulso entre com 0.1 ou 1.0');
Ku=input('Degrau no ponto de operacao [0.01 0.1 1 10] : ');

if isempty(Ku)
    Ku=[0.01 0.1 1 10];
end;

t0=input('Inicio do degrau [3] : ');

if isempty(t0)
    t0=3;
end;

if t0>tff
    t0=tff/2;
end;

% Linearizacao

f=sym('f');
X1=sym('X1');
Q=sym('Q');

f=[Q/1-3*sqrt(X1)/1]; % A=1 e k=3.

A=jacobian(f,[X1]);
B=jacobian(f,[Q]);

% Pontos Fixos
x1=subs(solve(f,'X1'),'Q',Umax);

% Sistema Linear

a=subs(subs(A,'X1',x1),'Q',Umax);
b=subs(subs(B,'X1',x1),'Q',Umax);
c=[1];
d=0;

sys=ss(a,b,c,d);

% Simulacao do sistema linear

error=zeros(size(Ku));

for j=1:length(Ku)
    
    [ans,y1]=ode45(@sys_non3,t,yss,newOpts,Umax,Umax+Ku(j),t0);
    
    figure(2*j);plot(t,y1);
    title(sprintf('Sistema Nao-Linear com degrau no ponto de operacao de %g',Ku(j)));
    xlabel('Tempo');ylabel('Estados');
    legend('Saida');grid;
    
    i=find(t>=t0);
    
    u=zeros(size(t));
    
    u(i)=Ku(j)*ones(size(i));
    
    yl=lsim(sys,u,t);
    
    figure(2*j+1);plot(t,y1(:,1),t,yl+yss(1));
    title(sprintf('Comparacao Nonlinear e Linearizado com degrau no ponto de operacao de %g',Ku(j)));
    xlabel('Tempo');ylabel('Saida');grid;legend('Nonlinear','Linear');
    
    error(j)=y1(end,1)-(yl(end)+yss(1));
end;

j=2*j;

disp(' ');
disp('Repare na mudanca de constante de tempo no sistema naolinear.');
disp('Repare, tambem, que razao entre os erros eh:');
disp(' ');

for jj=2:length(Ku)
    error(jj)/error(jj-1)
end;

% Aplicacao do Pulso

t0=input('Inicio e Final do pulso [3 3.03] : ');

if isempty(t0)
    t0=[3 3.03];
end;

disp('Para o exemplo do pulso - use entrada degrau 0.1 e d=20 ou 1.0 e d=1');
d=input(sprintf('Amplitude do pulso [d*%g] (e.g d=1) : ',Ku(end)));

if isempty(d)
    d=1;
end;

[ans,y2]=ode45(@sys_non3,t,yss,newOpts,Umax,Umax+d*Ku(end),t0);

i=find(t>t0(1));

u=Umax*ones(size(t));

u(i)=(Umax+d*Ku(end))*ones(size(i));

i=find(t>t0(2));

u(i)=Umax*ones(size(i));


figure(j+2);plot(t,y2(:,1),t,u);title('Aplicacao do Pulso');

y3=y2(:,1)-yss(1);
u3=u-Umax;

Y3=fft(y3);
U3=fft(u3);

H=Y3./U3;

freq=1/(dt*length(y3))*(0:length(y3)/2)';

H=H(1:length(freq));  % So metade de H

figure(j+3);
subplot(2,1,1);
semilogx(freq,20*log10(abs(H)));title('Click no ponto onde comeca as irregularidades (0.0088)');
subplot(2,1,2);
semilogx(freq,angle(H)*180/pi);
a=ginput(1);

i=find(freq <= a(1));

freq=freq(i);
H=H(i);

figure(j+4);
subplot(2,1,1);
semilogx(freq,20*log10(abs(H)));
subplot(2,1,2);
semilogx(freq,angle(H)*180/pi);

[a,b]=bode(sys,2*pi*freq);

mag=zeros(size(a,3),1);
pha=mag;

for i=1:size(a,3);
    mag(i)=a(1,1,i);
    pha(i)=b(1,1,i);
end;

figure(j+5);
subplot(2,1,1);
semilogx(freq,20*log10(abs(H)),freq,20*log10(mag));legend('FFT','Bode modelo linear');
ylabel('|H(j\omega)|');
subplot(2,1,2);
semilogx(freq,angle(H)*180/pi,freq,pha);legend('FFT','Bode modelo linear');
ylabel('\angle H(j\omega)');xlabel('freq');
