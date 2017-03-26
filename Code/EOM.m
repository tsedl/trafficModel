%% Equations Of Motion Function
function accel = EOM(t,z,dx,Va0,Sd,dv)   
%Constants 
global tau taus gamma lagD TEST
%% accel diffeq calc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           z_1 = x                                                        %
%           z_2 = x^dot                                                    %
%           z^dot_1 = x^dot = v                                            %
%           z^dot_2 = x^doubleDot = dv                                     %
%           accel = [z^dot_1; z^dot_2];                                    %
% Note x = z(1) is not used in ode solver. System equations of motion are  % 
% defined as follows:                                                      % 
%           dx/dx = v                                                      %
%           d^2x/dt^2 = (Va0-v)/tau(1-H(Va0-V(dx))) ...                    % 
%                       + (V(dx)-v)/taus(H(Va0-V(dx))  ...                 %
%                       - gamma*dv^2/(dx-l_d)(H(dv)H(v-V(dx))              % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = z(2);

accel = [v; ...
        (Va0 - v)/tau * (1-H(Va0 - V(dx))) ...
      + (V(dx) - v)/taus *(H(Va0 - V(dx))) ...
      - gamma*dv^2/abs(dx - lagD) * H(-dv) * H(v - V(dx))];
  TEST = [accel(2) dx dv v ((Va0 - v)/tau * (1-H(Va0 - V(dx)))) ((V(dx) - v)/taus *(H(Va0 - V(dx)))) (gamma*dv^2/(dx - lagD) * H(-dv) * H(v - V(dx)))];
%% V(dx) functions
    function b = V(x) 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %This function just has to be strictly monotonic increasing    %
        %function. I chose exponential to suggest that people slow down%
        %faster the closer they are to someone else.                   %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  x > Sd
            b = Va0 ;
        else
%              C = Va0/(exp(Sd+0.1) - exp(0.1));
%              b = C*(exp(x+0.1) - exp(0.1));
            
            
%             C = Va0/(exp(Sd) - 1);
%             b = C*(exp(x) - 1);
             
             C = Va0/(log(Sd + 10));
             b = C*(log(x + 10));
%              C = Va0/Sd;
%              b = C*x;
        end
    end
%% Heavyside function

    function z = H(x)
        if x <= 0;
            z = 0;
        else
            z = 1;
        end
    end
end