%Simulation of an Electrostatic Actuator

clc;close all;clear;

dt=0.01;

oldOpts=odeset;

newOpts=odeset(oldOpts,'InitialStep',dt,'MaxStep',dt);

% External values

tff=input('Final time [50] => ');

if isempty(tff)
	tff=50;
end;

tspan=[0 tff];

y0=input('Initial Condition (3 values) => ');

if isempty(y0)
	y0=[0 0 0]';
end;

Vin=input('Input (Step function) [0.01] : ');

if isempty(Vin)
    Vin=0.01;
end;

t=(0:dt:tff)';

[ans,y]=ode45(@eleactuator,t,y0,newOpts,0,Vin,0);

figure(1);plot(t,y);title(sprintf('Nonlinear system driven by the input x(t)=%gu(t)',Vin));
xlabel('Time');ylabel('States');grid;

yss=y(end,:);  % Steady State

% New simulation - t=0 just to make things easier

Ku=input('Step input over the operating point [-0.001 0.01] : ');

if isempty(Ku)
    Ku=[-0.001 0.01];
end;

t0=input('Start time of the input (step)  [5] : ');

if isempty(t0)
    t0=5;
end;

if t0>tff
    t0=tff/2;
end;

% Linearization

% Parameters

R=0.001;   % Resistor
epsilon=1; % Permittivity
A=100.0;   % Area
m=1.0;   % Mass
k=1;	% Spring Constant
b=0.5;  % Damping Constant
g0=1; % Initial gap
gmin=0.01; % Minimum gap

% States

f=sym('f');
X1=sym('X1');
X2=sym('X2');
X3=sym('X3');
V=sym('V');

f=[(1/R)*(V-(X1*X2)/(epsilon*A));X3;-(1/m)*((X1*X1)/(2*epsilon*A)+k*(X2-g0)+b*X3)];

A=jacobian(f,[X1 X2 X3]);
B=jacobian(f,[V]);


% Fixed Point

x3=0;
aux=subs(solve(f(1),'X1'),'V',Vin);
aux=subs(subs(f(3),'X1',aux),'X3',x3);
x2=solve(aux,'X2');

disp(' ');
disp('Check whether the fixed points for X2 are complex or not');

eval(x2)

disp('I am assuming that they are not and therefore taking the absolute value of them.');

x2=abs(eval(x2));

x1=zeros(3,1);

for i=1:3
    x1(i)=eval(solve(subs(subs(f(1),'X2',x2(i)),'V',Vin),'X1'));
end;

% Linear System - I am choosing the first fixed point

a=subs(subs(subs(subs(A,'X1',x1(1)),'X2',x2(1)),'X3',x3),'V',Vin);
b=subs(subs(subs(subs(B,'X1',x1(1)),'X2',x2(1)),'X3',x3),'V',Vin);
c=eye(3);
d=0;

sys=ss(a,b,c,d);

% Simulation of the linearized system

for j=1:length(Ku)
    
    [ans,y1]=ode45(@eleactuator,t,yss,newOpts,Vin,Vin+Ku(j),t0);
    
    i=find(t>=t0);
    
    u=zeros(size(t));
    
    u(i)=Ku(j)*ones(size(i));
    
    yl=lsim(sys,u,t);
    
    figure(1+j);
    subplot(3,1,1);
    plot(t,y1(:,1),t,yl(:,1)+yss(1));
    title(sprintf('Nonlinear versus Linear - operating point - a step of  %g was applied',Ku(j)));
    xlabel('Time');ylabel('Output');grid;legend('Nonlinear','Linear');
    subplot(3,1,2);
    plot(t,y1(:,2),t,yl(:,2)+yss(2));
    xlabel('Time');ylabel('Output');grid;legend('Nonlinear','Linear');
    subplot(3,1,3);
    plot(t,y1(:,3),t,yl(:,3)+yss(3));
    xlabel('Time');ylabel('Output');grid;legend('Nonlinear','Linear');
    
end;

disp(' ');
disp('We can clearly see that the linearization only works for small');
disp('values of perturbations around the operating point');
