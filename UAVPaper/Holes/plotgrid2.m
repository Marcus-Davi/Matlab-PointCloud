%plota grid

function y = plotgrid2(M)
[rows,cols] = size(M); %line, col
greycolor = [211 211 211]/256;
lw = 0.1;
% plotar ny linhas horizontais
% plotar nx linhas verticais
y = figure;
hold on
xmin = 0.5;
xmax = rows;
ymin = 0.5;
ymax = cols;
for i=1:cols
   plot([xmin xmax],[i-0.5 i-0.5],'color',greycolor,'linewidth',lw) 
end

for i=1:rows
   plot([i-0.5 i-0.5],[ymin ymax],'color',greycolor,'linewidth',lw) 
end



end
