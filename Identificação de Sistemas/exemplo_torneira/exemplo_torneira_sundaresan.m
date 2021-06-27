% Torneira - Método de Sundaresan

load degrau_torneira

figure(1);plot(t,u,t,y);title('Dados Originais - Click no inicio do degrau e no comeco do estado estacionario');

[a,b]=ginput(2);

% Trazendo os valores para o início do Degrau

i=find(t>=a(1));
t1=t(i)-t(i(1));
y1=y(i);
u1=u(i);
figure(2);plot(t1,u1,t1,y1);title('Origem no inicio do degrau');

% Achando os valores máximos e mínimos

i=find(t<a(1));
ymin=mean(y(i));
umax=mean(u(i));
i=find(t>=a(2));
ymax=mean(y(i));
umin=mean(u(i));

A=-umax+umin;  % valor de degrau aplicado à planta

K=(ymax-ymin)/A;  % Ganho em regime permanente

%  Trazendo a sáida para a forma do Método

y2=(y1-ymin)/(ymax-ymin);

figure(3);plot(t1,y2);

% Método

%m1=t1(end)-trapz(t1,y2)

m1=trapz(t1,(1-y2));

yy=smooth(t1,y2,0.1,'rloess');
yy1=diff(yy)/(t1(2)-t1(1));
yy1=[yy1; yy1(end)];
yy2=diff(yy1)/(t1(2)-t1(1));
yy=[yy yy1 [yy2; yy2(end)]];

figure(4);plot(t1,y2,t1,yy(:,1));title('Original e suavizado');

figure(5);plot(t1,yy(:,2:3));grid;title('Primeira e Segunda Derivadas - Click no maximo');

[ti,Mi]=ginput(1)

j=find(t1>=ti);

yti=y2(j(1));

y_reta=Mi*t1+(yti-Mi*ti);

figure(6);plot(t1,y2,t1,y_reta);axis([0 t1(end) 0 1]);

j=find(y_reta>=1);

tm=t1(j(1))

lambda=(tm-m1)*Mi

% Abaco

eta1 = [0.01:0.01:0.99];
lambda1 = (log(eta1)./(eta1-1)).*exp(-(log(eta1)./(eta1-1)));

figure(7); plot(lambda1, eta1,lambda,0,'o'); grid on; xlabel('\lambda'); ylabel('\eta');
title('Repare o valor de lambda na abscissa - Posicionar a vertical neste ponto');

[ans,eta]=ginput(1);

eta

%  Valores da constantes de tempo e atraso

tau1=(eta^(eta/(1-eta)))/Mi
tau2=(eta^(1/(1-eta)))/Mi
td=m1-tau1-tau2

H1=tf(K,conv([tau1 1],[tau2 1]),'OutputDelay', td)

% Validação

yv=lsim(H1,A*ones(size(t1,1),1),t1);

figure(8);plot(t1,y1,t1,yv+ymin);title('Validação');










