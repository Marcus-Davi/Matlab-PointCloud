function tf_endpoint = transform_endpoints(s,pose)
x = pose(1);
y = pose(2);
theta = pose(3);
R = [cos(theta) -sin(theta);sin(theta) cos(theta)];

tf_endpoint = R*s' + [x;y];
end