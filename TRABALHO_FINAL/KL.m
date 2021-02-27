function [autovalores, matrizLL, matrizmN, erro] = KL(matrizLN,m)

%   FUNÇÃO:
%           [autovalores, matrizLL, matrizmN, erro] = KL(matrizLN,m)
%
%   A função implementa o algoritmo para calcular a Transformada de
%   Karhunen-Loève para um conjunto de dados.
% 
%   INPUTS:   
%           matrizLN = matriz de dados (características x padrões)
%           m = número de autovetores, dimensões a calcular
% 
%   OUTPUTS:
%           autovalores = autovalores resultantes da transformada
%           matrizLL = autovetores correspondentes aos autovalores
%           matrizmN = dados projetados num espaço com 'm' dimensões
%           erro = erro quadrático médio em percentual da variância

    %% MATRIZ DE COVARIÂNCIA
    matcov = cov(matrizLN');
    
    %%  AUTOVETORES E AUTOVALORES
    [mAutovet,mAutoval] = eig(matcov);
    [autovalores,index] = sort(diag(mAutoval),'descend');
    matrizLL = mAutovet(:,index);
    erro = 0;
    matrizMax = matrizLL*matrizLN;
    
    w = waitbar(0,'PCA');
    if nargin>1
        for i=1:m
            waitbar(i/m);
            matrizAuto(i,:) = matrizLL(i,:);
            erro = erro + autovalores(i)/sum(autovalores);
        end
        matrizmN = matrizAuto*matrizLN;
        erro = 1-erro;
    else
        matrizmN = matrizMax;
    end
    delete(w);
end
