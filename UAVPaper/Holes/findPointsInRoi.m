% Select points inside rectangle (efficient) (mais efieicente que do
% matlab)
function xyzf = findPointsInRoi(xyz,roi)
  
  xi = xyz(:,1) > roi(1) & xyz(:,1) < roi(2);
  yi = xyz(:,2) > roi(3) & xyz(:,2) < roi(4);
  zi = xyz(:,3) > roi(5) & xyz(:,3) < roi(6);
  
  allconds = (xi & yi & zi);
  
  xyzf = [xyz(allconds,1) xyz(allconds,2) xyz(allconds,3)];
  
end
