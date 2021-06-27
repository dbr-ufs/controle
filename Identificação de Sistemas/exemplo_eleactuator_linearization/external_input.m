function u = external_input(t,SP1,SP2,t0)
% function u = external_input(t,SP1,SP2,t0) returns the value of a
%   step input starting at t0
%

if (t<=t0)
    u=SP1;
else
    u=SP2;
end;

