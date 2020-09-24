function T = icp_single_axis(fixed,moving)
XY0 = fixed.Location(:,1:2);
XY1 = moving.Location(:,1:2);

deltaT = 0;
% KD = KDTreeSearcher(XY0,'BucketSize',10); %point matching

n = length(XY0);
n1 = length(XY1);

XY1_Transformed = XY1;
match_iterations = 5;
for k=1:match_iterations

[match,~] = knnsearch(XY0,XY1_Transformed); % Meio lixo ?
% [match] = mycorrespondence(XY0,XY1_Transformed);

% Point Correspondence
p0_idx = match;
p1_idx = true(1, n1);

weights = ones(1,length(match));

% P0_corr = XY0(p1_idx,:);
% P1_corr = XY1_Transformed(match,:);

P0_corr = XY0(p0_idx,:);
P1_corr = XY1_Transformed(p1_idx,:);

% MANUAL_XY = XY0 + [0 0.4];

[Ty] = my_scanmatch(P0_corr,P1_corr,weights,1);

XY1_Transformed = XY1_Transformed + [0 Ty];
deltaT = deltaT + Ty;
% hold off
% plotcloud(XY0)
% hold on
% plotcloud(XY1_Transformed)
end

T = deltaT;




end

function match = mycorrespondence(fixed,moving)
n = length(fixed);
match = zeros(n,1);
for i=1:n
   % Shoot line
   x0 = fixed(i,1);
   y0 = fixed(i,2);
   
   x1 = x0;
   y1 = 10000;
   dmin = 50;
   index = 0;
   for j=1:length(moving)
       xp = moving(j,1);
       yp = moving(j,2);
       
       d = abs((y1-y0)*xp - (x1-x0)*yp + x1*y0 - y1*x0)/sqrt( (y1-y0)^2 + (x1-x0)^2);
       if (d < dmin)
          dmin = d;
          index = j;
       end
       
   end
   
   match(i) = index;
   
   
   
   % Compute closest point from moving to line
   
   %Compose match vector
    
end



end




%entra com as duas nuvem de pontos
function [Ty] = my_scanmatch(P0,P1,weights_,n_it)
% weights = weights_ ./ sum(weights_);
N = length(P0);
P0_ = P0;
P1_ = P1;
Ty = 0;
%% Gauss Newton MT BOM!!!
%r(x) = R*Pi + T - Pi

for k=1:n_it
    
    r = [];
    jac = [];
    %     r = zeros(2*N,1);
    % jac = zeros(2*N,3);
    for i=1:N
        r = [r;P0(i,2) + Ty - P1(i,2)]; % Ty
        jac = [jac;1];
    end
    Ty = Ty -inv(jac'*jac)*jac'*r;
    
end
r'*r;
Ty = -Ty;

end
