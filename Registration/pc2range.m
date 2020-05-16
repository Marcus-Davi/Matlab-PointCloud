function [r,angle] = pc2range(P)
n = length(P);

increment = 0.0061359;
amin = -2.3561945;
amax = 2.0923498;
angle = amin:increment:amax;
r = zeros(n,1);
for i=1:n
    r(i) = norm(P(:,i));
end

end