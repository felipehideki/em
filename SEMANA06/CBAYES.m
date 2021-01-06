function [probabilidades, classificacao] = CBAYES(u,sigma,prior,x)
    % INPUTS:
    %           u = cell array 1 x M de médias L x 1
    %           sigma = cell array 1 x M de matrizes de covariância L x L
    %           prior = vetor de priors L x 1
    %           x = vetor de características/padrões L x 1
    % OUTPUTS:
    %           probabilidades(i) = probabilidade P(wi|x)
    %           classificacao = classe com maior P(w|x)
    if size(u)~=size(sigma)
        error('Quantidade de médias diferente da quantidade de matrizes de covariância!');
    else
        L = numel(u);
    end
    for i=1:L
        if size(u{i})~=size(sigma{i})
            error('Dimensão de médias diferente de dimensão das matrizes de covariância!');
        else
            probabilidades(i) = prior(i)*(1/sqrt(((2*pi)^L)*det(sigma{i})))*exp(-0.5*(x-u{i})'*inv(sigma{i})*(x-u{i}));
        end
    end
    classificacao = find(probabilidades==max(probabilidades));
end
