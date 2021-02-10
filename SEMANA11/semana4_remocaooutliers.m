function [outliers,indexes]=semana4_remocaooutliers(x,p,g)
% Remove outliers de um conjunto de valores utilizando como limiar um numero
% p de desvios padroes em relacao a mediana.

%INPUT:
% x = vetor com dados
% p = numero de desvios padroes em relacao a mediana acima do qual as
%    amostras sao consideradas outliers (padrao = 3)
% g = plotar (1) ou nao plotar (0).

if nargin<3
    g=1;
end
if nargin<2
    p=3;
end

sup=find(x>(median(x)+ p*std(x)));
inf=find(x<(median(x)- p*std(x)));
indexes=union(sup,inf);
outliers=x(indexes);
if g
    figure('Name','Deteccao de Outliers','Color','w');
    plot(1:length(x),x,'*');
    hold on
    plot(indexes,outliers,'or');
    xa=line([1 length(x)],[median(x), median(x)]);
    set(xa,'Color','k')
    xa=line([1 length(x)],[median(x)+ p*std(x), median(x)+ p*std(x)]);
    set(xa,'Color','k','LineStyle','--')
    xa=line([1 length(x)],[median(x)- p*std(x), median(x)- p*std(x)]);
    set(xa,'Color','k','LineStyle','--')
    title(['Deteccao de Outliers:  (mediana \pm ',num2str(p),'*std)'])
    xlabel('Amostras')
    xlim([1 numel(x)])
end
