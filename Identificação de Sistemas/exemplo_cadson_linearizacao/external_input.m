function u = external_input(t,SP1,SP2,t0)
% function u = external_input(t,SP1,SP2,t0) returns the value of a
%   step input starting at t0
%

if length(t0) == 1
    if (t<=t0)
        u=SP1;
    else
        u=SP2;
    end;
else
    if (t<=t0(1))
        u=SP1;
    elseif ((t>t0(1)) & (t<=t0(2)))
        u=SP2;
    else
        u=SP1;
    end;
end;

