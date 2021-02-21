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
          
    r = [];
    jac = [];
    %     r = zeros(2*N,1);
    % jac = zeros(2*N,3);
    for i=1:N
        %point to line
        
        p_src = P0_(:,i);
        p_tgt = P1_(:,i);
        p_tgt2 = P2_(:,i);
        
        pts = [p_src p_tgt p_tgt2]; %generic

           

        err_ = point2line(x,pts);
%         err_ = point2point(x,pts);
        
        
        
        
%         jac_ = numericalDiff(x,@point2point,pts);
        jac_ = numericalDiff(x,@point2line,pts);
     
        
        r = [r;err_];
        
        jac = [jac ;jac_]; % stack jacobians
        
    end
    increment = -inv(jac'*jac)*jac'*r;
    x = x + increment(:,1);
    
end

R_f = [cos(x(3)) sin(x(3));-sin(x(3)) cos(x(3))]';
T_f = [x(1);x(2)];


end


% Distance / Cost Function 
function d = point2point(x,pts)
pt0 = pts(:,1);
pt1 = pts(:,2);



R = [cos(x(3)) -sin(x(3));sin(x(3)) cos(x(3))];
T = [x(1);x(2)];

vec = R*pt0+T - pt1;
% 
% d = vec;
d = norm(vec);
end


function d = point2line(x,pts)
% p0 = [pt(1) pt(2) 0]';
pt0 =[pts(1,1) pts(2,1)]';
p1 = [pts(1,2) pts(2,2) 0]';
p2 = [pts(1,3) pts(2,3) 0]';

% Compose transforms
R = [cos(x(3)) -sin(x(3));sin(x(3)) cos(x(3))];
T = [x(1);x(2)];

p0_tf = R*pt0+T;
p0_tf(3) = 0;

line_pt = p1;
line_dir = (p2-p1)/norm(p2-p1);
 
% d = (line_pt - p0_tf) - dot(dot(line_pt-p0_tf,line_dir)*line_dir,line_dir); % point to point ??
d = norm(cross(line_dir,line_pt-p0_tf))/ norm(line_dir);

% d = d2(3);
% 
% d = d(1:2);


end


%% Use numerical Jacobian (faster ? more practical ? reliable ? )
function jac = numericalDiff (x, f_handle,f_consts)

y_nom = f_handle(x,f_consts);
n_rows = length(y_nom);
n_cols = length(x);
jac = zeros(n_rows,n_cols);


increment = 1e-4;
for i=1:length(x)
    x_inc = x;
    x_inc(i) = x_inc(i) + increment;
    
    y_inc = f_handle(x_inc,f_consts);
    
    jac(:,i) = (y_inc - y_nom) / increment;
    
end


end


