function dydt = eleactuator(t,y,SP1,SP2,t0)
% Simulation of a Electrostatic Actuator
% Copyright (c) 2005 by Eduardo Mendes.

dydt=zeros(size(y));

% Parameters

R=0.001;   % Resistor
epsilon=1; % Permittivity
A=100.0;   % Area
m=1.0;   % Mass
k=1;	% Spring Constant
b=0.5;  % Damping Constant
g0=1; % Initial gap
gmin=0.01; % Minimum gap

% Input

Vin=external_input(t,SP1,SP2,t0); % Vin=0.01;  % Input

% States

dydt(1) = (1/R)*(Vin-(y(1)*y(2))/(epsilon*A));
dydt(2) = y(3);
dydt(3) = -(1/m)*((y(1)*y(1))/(2*epsilon*A)+k*(y(2)-g0)+b*y(3));

