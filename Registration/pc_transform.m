% Total trasnform
% P = [x x2 ... ; y1 y2 ...]
function P_t = pc_transform(P,Transform)
N = length(P);
Pc = P';
R = [cos(Transform(3)) -sin(Transform(3));sin(Transform(3)) cos(Transform(3))];
T = [Transform(1);Transform(2)];
p = [0 0]';
P_t = (R*(Pc-p) + T + p)';
end  