function [medias, matriz_covariancia] = MAXLIKE(dados)
    L = size(dados,1);
    for i=1:L
        medias(i,1) = sum(dados(i,:))/length(dados);
    end
        matriz_covariancia = cov(dados');
end
