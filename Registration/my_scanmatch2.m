%entra com as duas nuvem de pontos
function [R_f,T_f] = my_scanmatch2(source,target,target2,weights_,n_it)
% weights = weights_ ./ sum(weights_);

N = length(source);
P0_ = source;
P1_ = target;
P2_ = target2;
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
        
        %point to point
        %     r = [r;(R*P0_(:,i)+ T - P1_(:,i))]; %esta função deve ser alterada pra levar em conta a indexação
        %
        %point to line
        
          err_ = point2point(R*P0_(:,i)+ T,P1_(:,i))
        err = -point2line(R*P0_(:,i)+ T, P1_(:,i), P2_(:,i))
          
            r = [r;err]; %esta função deve ser alterada pra levar em conta a indexação
 
        
        jac = [jac ;(Jf(P0_(:,i),P1_(:,i),x))];

    end
    increment = -inv(jac'*jac)*jac'*r;
    x = x + increment(:,1);
    
end

R_f = [cos(x(3)) sin(x(3));-sin(x(3)) cos(x(3))]';
T_f = [x(1);x(2)];


end

function d = point2point(pt0,pt1)
d = pt0 - pt1;

end

function d = point2line(pt, l0,l1)
p0 = [pt(1) pt(2) 0]';
p1 = [l0(1) l0(2) 0]';
p2 = [l1(1) l1(2) 0]';


line_pt = p1;
line_dir = p2-p1;

d = (line_pt - p0) - dot(dot(line_pt-p0,line_dir)*line_dir,line_dir);
d2 = norm(cross(line_dir,line_pt-p0))^2/ norm(line_dir)^2;

d = d(1:2);





% versor



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
