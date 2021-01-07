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
    end
    L = numel(u);
    px = 0;
    aux = 0;
    i = 1;
    while i <= L
        if ~aux
            if size(u{i})~=size(sigma{i})
                error('Dimensão de médias diferente de dimensão das matrizes de covariância!');
            end
            pxw(i) = (1/sqrt(((2*pi)^L)*det(sigma{i})))*exp(-0.5*(x-u{i})'*inv(sigma{i})*(x-u{i}));
            px = px + pxw(i)*prior(i); % Marginalização P(x) = sum_classe(P(x|classe)P(classe))
            if i==L
                aux = 1;
                i = 1;
            else
                i = i+1;
            end
        else
            probabilidades(i) = pxw(i)*prior(i)/px;
            i = i+1;
        end
    end   
    classificacao = find(probabilidades==max(probabilidades));
end
