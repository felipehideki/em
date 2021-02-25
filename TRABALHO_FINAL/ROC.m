function [auc] = ROC(dados,classes,plt)

%   FUNÇÃO:
%           [auc] = ROC(dados,classes)
%
%   A função implementa o algoritmo para calcular a área abaixo da curva
%   de Característica de Operação do Receptor (AUC-ROC).
% 
%   INPUT:
%           dados: vetor coluna com dados.
%           classes: vetor coluna de informações das classes (0 ou 1).
%           plt: plota a curva ROC.
% 
%   OUTPUT:
%           auc: área abaixo da curva ROC.

patterns = [dados classes];
patterns = sortrows(patterns,-1);
classes = patterns(:,2);
p = cumsum(classes==1);
tp = p/sum(classes==1);
n = cumsum(classes==0);
fp = n/sum(classes==0);

n = length(tp);
Y = (tp(2:n)+tp(1:n-1))/2;
X = fp(2:n)-fp(1:n-1);
auc = sum(Y.*X);

if nargin<3
    plt = 0;
end
if (plt==1)
    plot(fp,tp,'k','LineWidth',2);grid on;
    hold on;plot(tp,tp,'-.k','LineWidth',2);
    xlabel('\alpha','FontSize',16);ylabel('1-\beta','FontSize',16);
    s = num2str(auc); s=strcat('AUC= ',s);
    title(['ROC, ' s],'FontSize',14);hold off;
end