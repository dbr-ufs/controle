% Exemplo Método da integrais - Torneira Elétrica

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

figure(3);plot(t2,u2,t2,y2);title('Curvas Nomalizadas');

% Métodps das integrais
%
% \tau + \theta = \int_{0}^{\infty} u(t) dt - \int_{0}^{\infty} y(t) dt
%
% \tau = \exp{1} \int_{0}^{theta+tau} y(t) dt
%
% Ou 
%
% \tau + \theta = \sum){k=0}^{T_{o}} [u(k)-y(k)]\Delta t
%
% \tau = exp(1) \sum){k=0}^{\tau + \theta} y(k) \Delta t
%
% T_{o} - [u(k)-y(k)] <= 0.01

tau_theta=trapz(t2,u2-y2);

i=find(t2<=tau_theta);

tau=exp(1)*trapz(t2(i),y2(i))

theta=tau_theta-tau;

H=tf(K,[tau 1],'OutputDelay', theta)

% Validação

uu=A*ones(size(t2));

yy=lsim(H,uu,t2);

figure(4);plot(t2,y1,t2,yy+ymin);title('Comparação Dados reais e Modelo');









