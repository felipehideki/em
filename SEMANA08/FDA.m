function [Y] = FDA(classes)
    
%   FUNÇÃO:
%           [Y] = FDA(classes)
%
%   Essa função implementa o algoritmo para a análise discriminante de Fisher.
%
%   INPUTS:   
%           classes = matriz de células onde classes{i} = características x padrões
%   OUTPUTS:
%           Y = matriz com os dados originais projetados por FDA em dimensão C-1
    
    [Sb,Sw] = SCATTER(classes);
    mat = Sw\Sb;
    [mAutovet,mAutoval] = eig(mat);
    [~,index] = sort(diag(mAutoval),'descend');
    A = mAutovet(:,index)';
    L = size(classes,2);
    allclasses = [];
    for i=1:L
        allclasses = [allclasses classes{i}];
    end
    Y = A(1:L-1,:)*allclasses;
    Y = Y';
end    
