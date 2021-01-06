function [distanciaEuclidiana, distanciaMahalanobis, classificacaoEuclidiana, classificacaoMahalanobis] = CMAHALANOBIS(u,sigma,prior,x)
    % INPUTS:
    %           u = cell array 1 x M de médias L x 1
    %           sigma = matriz de covariância L x L
    %           prior = vetor de priors L x 1
    %           x = vetor de características/padrões L x 1
    % OUTPUTS:
    %           distanciaEuclidiana (entre x e médias)
    %           distanciaMahalanobis (entre x e médias)
    %           classificacaoEuclidiana
    %           classificacaoMahalanobis
    L = numel(u);
    for i=1:L
        if size(u{i})~=size(sigma)
            error('Dimensão de médias diferente de dimensão da matriz de covariância!');
        else
%             probabilidades(i) = prior(i)*(1/sqrt(((2*pi)^L)*det(sigma)))*exp(-0.5*(x-u{i})'*inv(sigma)*(x-u{i}));
            distanciaEuclidiana(i) = pdist([x';u{i}']);
            distanciaMahalanobis(i) = pdist([x';u{i}'],'mahalanobis',sigma);
        end
    end
    classificacaoEuclidiana = find(distanciaEuclidiana==min(distanciaEuclidiana));
    classificacaoMahalanobis = find(distanciaMahalanobis==min(distanciaMahalanobis));
end
