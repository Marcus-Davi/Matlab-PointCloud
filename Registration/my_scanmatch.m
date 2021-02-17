%entra com as duas nuvem de pontos
function [R_f,T_f] = my_scanmatch(source,target,weights_,n_it)
% weights = weights_ ./ sum(weights_);

N = length(source);
P0_ = source; 
P1_ = target;
x = zeros(3,1); % tx ty theta
%% Gauss Newton MT BOM!!!
%r(x) = R*Pi + T - Pi 

for k=1:n_it

    R = [cos(x(3)) -sin(x(3));sin(x(3)) cos(x(3))];
    T = [x(1);x(2)];
    r = [];
    jac = [];
%     r = zeros(2*N,1);
% jac = zeros(2*N,3);
for i=1:N
%     r(2*i-1:2*i) = [(R*P0_(:,i)+ T - P1_(:,i))]; %esta função deve ser alterada pra levar em conta a indexação
    r = [r;(R*P0_(:,i)+ T - P1_(:,i))]; %esta função deve ser alterada pra levar em conta a indexação
    jac = [jac ;(Jf(P0_(:,i),P1_(:,i),x))];
%     r = [r;weights(i)* (R*P0_(:,i)+ T - P1_(:,i))]; %esta função deve ser alterada pra levar em conta a indexação
%     jac = [jac ;weights(i)*(Jf(P0_(:,i),P1_(:,i),x))];
end
     increment = -inv(jac'*jac)*jac'*r;
         x = x + increment(:,1);
                
end

    R_f = [cos(x(3)) sin(x(3));-sin(x(3)) cos(x(3))]';
    T_f = [x(1);x(2)];


end


%% Functions
function y = Jf(p0,p1,x)
tx = x(1);
ty = x(2);
theta = x(3);
x0 = p0(1);y0=p0(2);
x1 = p1(1);y1=p1(2);

y = [1 0 -sin(theta)*x0-cos(theta)*y0;0 1 cos(theta)*x0-sin(theta)*y0];
end
