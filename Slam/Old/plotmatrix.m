function plotmatrix(A)
% axis ij -> aqui inverte a mostra
  [r,c] = find(A>0); %A > 0
  scatter(r,c,'filled','red')
  hold on
  [r,c] = find(A<0); %A > 0
  scatter(r,c,'filled','green')
  
  grid on
  
end