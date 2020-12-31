%   SEMANA 05
%   TRANSFORMADA DE KARHUNEN-LOÈVE

function [autovalores, matrizLL, matrizmN, erro] = KARLOEVE(matrizLN,m)
    % INPUTS:   
    %           matrizLN (características x padrões)
    %           m (número de autovetores, características a selecionar)
    
    % OUTPUTS:
    %           autovalores
    %           matrizLL (autovetores correspondentes aos autovetores)
    %           matrizmN (projeção no novo espaço com 'm' características)
    %           erro (erro quadrático médio em percentual da variância)

    %% MATRIZ DE COVARIÂNCIA
    matcov = cov(matrizLN');
    
    %%  AUTOVALORES
    autovalores = flipud(eig(matcov));
    
    %%  AUTOVETORES
    [matrizLL,~] = eig(matcov);
    matrizLL = fliplr(matrizLL);
    erro = 0;
    matrizMax = matrizLL*matrizLN;
    
    if nargin>1
        for i=1:m
            matrizAuto(i,:) = matrizLL(i,:);
            erro = erro + autovalores(i)/sum(autovalores);
        end
        matrizmN = matrizAuto*matrizLN;
        erro = 1-erro;
    else
        matrizmN = matrizMax;
    end
end
