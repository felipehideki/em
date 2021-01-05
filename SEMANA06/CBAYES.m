function [probabilidades, classificacao] = CBAYES(u,sigma,prior,x)
    if size(u)~=size(sigma)
        error('Quantidade de médias diferente da quantidade de matrizes de covariância!');
    else
        L = numel(u);
    end
    for i=1:L
        probabilidades(i) = prior(i)*(1/sqrt(((2*pi)^L)*det(sigma{i})))*exp(-0.5*(x-u{i})'*inv(sigma{i})*(x-u{i}));
    end
    classificacao = find(probabilidades==max(probabilidades));
end
