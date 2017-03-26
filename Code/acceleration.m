function [ a ] = acceleration( v, Va0, dx, dv, Sd )
global tau taus gamma lagD 

a = (Va0 - v)/tau * (1-H(Va0 - V(dx,Sd,Va0))) ...
  + (V(dx,Sd,Va0) - v)/taus * (H(Va0 - V(dx,Sd,Va0))) ...
  - gamma* dv^2/abs(dx - lagD) * H(-dv)*H(v - V(dx,Sd,Va0));

%% Heavyside functions
function z = H(x)
        if x <= 0;
            z = 0;
        else
            z = 1;
        end
    end

%% Velocity-distance-relation V(x) function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %This function just has to be strictly monotonic increasing    %
    %function. I chose exponential to suggest that people slow down%
    %faster the closer they are to someone else.                   %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function b = V(x,Sd,Va0) 

    
    if  x > Sd
        b = Va0 ;
    else
        C = Va0/(log(Sd + 10));
        b = C*(log(x + 10));
    end
end
end

