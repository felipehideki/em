function [outliers,indexes]=semana4_remocaooutliers2(x,p,g)
% Remove outliers de um conjunto de valores utilizando como limiar um fator
% p do intervalo entre os quartiles da distribuiçao de pontos

%INPUT:
% x = vetor com dados
% p =  (padrao = 2)
% g = plotar (1) ou nao plotar (0).

if nargin<3
    g=1;
end
if nargin<2
    p=2;
end

[ss,ssx]=sort(x);
qt1=ss(round(numel(x)/4));%quartil inferior
qt2=ss(end-round(numel(x)/4)+1); %quartil superior
iqr=qt2-qt1;%intervalo entre quartiles
indexes=ssx(union(find(ss<qt1-p*iqr)',find(ss>qt2+p*iqr)'));
outliers=x(indexes);
if g
    figure('Name','Deteccao de Outliers','Color','w');
    plot(1:length(x),x,'*');
    hold on
    plot(indexes,outliers,'or');
    xa=line([1 length(x)],[median(x), median(x)]);
    set(xa,'Color','k')
    xa=line([1 length(x)],[qt1-p*iqr, qt1-p*iqr]);
    set(xa,'Color','k','LineStyle','--')
    xa=line([1 length(x)],[qt2+p*iqr, qt2+p*iqr]);
    set(xa,'Color','k','LineStyle','--')
    title(['Deteccao de Outliers por intervalo entre quartiles (acima de ',num2str(p),' vezes)'])
    xlabel('Amostras')
    xlim([1 numel(x)])
end
