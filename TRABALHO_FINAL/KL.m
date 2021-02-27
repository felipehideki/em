function [autovalores, matrizLL, matrizmN, erro] = KL(matrizLN,m)
    % INPUTS:   
    %           matrizLN (caracter�sticas x padr�es)
    %           m (n�mero de autovetores, caracter�sticas a selecionar)
    
    % OUTPUTS:
    %           autovalores
    %           matrizLL (autovetores correspondentes aos autovalores)
    %           matrizmN (proje��o no novo espa�o com 'm' caracter�sticas)
    %           erro (erro quadr�tico m�dio em percentual da vari�ncia)

    %% MATRIZ DE COVARI�NCIA
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