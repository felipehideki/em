function [Y] = FDA(xClasse1,xClasse2,L)
    
% INPUTS:   
    %           xClasse1 = matriz de características x padrões da classe 1
    %           xClasse2 = matriz de características x padrões da classe 2
    %           L = número de dimensões do novo espaço de características
    
    % OUTPUTS:
    %           Y = matriz com os dados originais projetados por FDA
    
    classe{1} = xClasse1;
    classe{2} = xClasse2;
    [Sb,Sw]=SCATTER(classe,size(classe{1},1));
    mat = Sw\Sb;
    [mAutovet,mAutoval] = eig(mat);
    [~,index] = sort(diag(mAutoval),'descend');
    A = mAutovet(:,index)';
    Y = A(1:L,:)*[classe{1} classe{2}];
    Y = Y';
end    
