% Exemplo da Resposta Complementar - Torneira Elétrica

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

figure(3);plot(t2,u2,t2,y2);title('Curvas Normalizadas - Estime \theta (atraso)');

[theta,ans]=ginput(1);

y2s=smooth(t2,y2);

figure(4);plot(t2,u2,t2,y2s);title('Curvas Normalizadas (suave)');

y2aux=1-y2./(u2);

yy=log(y2aux);

for i=1:length(yy)
	if ~isreal(yy(i))
		break;
	end;
end;

figure(5);plot(t2,yy,[t2(i) t2(i)],[min(yy) max(yy)],'r-');title('Escolha a região para o cálculo da assíntota');

[taux,yaux]=ginput(2);

a=(yaux(2)-yaux(1))/(taux(2)-taux(1));

b=yaux(1)-a*taux(1);

tau_1=-1/a;

hold on;plot(t2,a*t2+b,'b-'); hold off;text(taux(2),yaux(1),sprintf('%s=%g','\tau_1',tau_1));


yyy=log(exp(b)*exp(-t2/tau_1)-y2aux);

for i=1:length(yyy)
	if ~isreal(yyy(i))
		break;
	end;
end;

figure(6);plot(t2,yyy,[t2(i) t2(i)],[min(yyy) max(yyy)],'r-');title('Escolha a região para o cálculo da assíntota');

[taux,yaux]=ginput(2);

a=(yaux(2)-yaux(1))/(taux(2)-taux(1));

b=yaux(1)-a*taux(1);

tau_2=-1/a;

hold on;plot(t2,a*t2+b,'b-'); hold off;text(taux(2),yaux(1),sprintf('%s=%g','\tau_2',tau_2));

% Função de Transferência

H=tf(K,conv([tau_1 1],[tau_2 1]),'OutputDelay', theta)

% Validação

uu=A*ones(size(t2));

yv=lsim(H,uu,t2);

figure(7);plot(t2,y1,t2,yv+ymin);title('Comparação Dados reais e Modelo');
s=sprintf('e^{-%gs}',theta);
text(2*mean(t2)/3,mean(y1),sprintf('H(s)=%g*%s/((%g+1)(%g+1))',K,s,tau_1,tau_2));
























