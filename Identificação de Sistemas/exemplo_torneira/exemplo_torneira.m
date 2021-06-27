% Torneira Elétrica

clear;clc;close all;

disp('Exemplo da Torneira - Sistema 1 ordem - Secao 3.2.1');

load degrau_torneira

figure(1);plot(t,u,t,y);title('Click nas regiões para determinar o começo do degrau e o estado permanante');

[taux,ans]=ginput(2);

% Valores máximos e mínimos

i=find(t<taux(1));
umax=mean(u(i));
ymin=mean(y(i));


i=find(t>taux(2));
ymax=mean(y(i));
umin=mean(u(i));

% Ajeitando a escala

i=find(t>=taux(1));

t1=t(i);
u1=u(i);
y1=y(i);

figure(2);plot(t1,u1,t1,y1);title('Origem no começo do degrau negativo');

% Ganhos

A=-(umax-umin)

K=(ymax-ymin)/A


% Normalizando as curvas

t2=t1-t1(1);

u2=u1/umin;
y2=(y1-ymin)/(ymax-ymin);

figure(3);plot(t2,u2,t2,y2);title('Curvas Nomalizadas - Estime o atraso com o mouse');

[theta,ans]=ginput(1);

theta

% Encontrando o valor da contante de tempo

i=find(y2>=(1-exp(-1)));

tau=t2(i(1))-theta

H=tf(K,[tau 1],'OutputDelay', theta)

% Validação

uu=A*ones(size(t2));

yy=lsim(H,uu,t2);

figure(4);plot(t2,y1,t2,yy+ymin);title('Comparação Dados reais e Modelo');









