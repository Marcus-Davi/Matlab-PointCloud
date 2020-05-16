function plotmatrix(A)
% axis ij -> aqui inverte a mostra
  [r,c] = find(A>0); %A > 0
  scatter(r,c,1,'filled','r')
  hold on
  [r,c] = find(A<0); %A > 0
  scatter(r,c,'filled','g')
  
%   grid on
  
end