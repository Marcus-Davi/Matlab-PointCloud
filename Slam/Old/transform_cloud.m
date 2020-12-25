function tf_cloud = transform_cloud(cloud,pose)
x = pose(1);
y = pose(2);
theta = pose(3);
R = [cos(theta) -sin(theta);sin(theta) cos(theta)];

tf_cloud = (R*cloud' + [x;y])';
end