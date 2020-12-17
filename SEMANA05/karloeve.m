% TRANSFORMADA DE KARHUNEN-LOÈVE

function [autovalores, matrizLL, matrizmN, erro] = karloeve(matrizLN,m)
    % MATRIZ DE COVARIÂNCIA
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
    else
        matrizmN = matrizMax;
    end
    erro = 1-erro;
end
