function [Sb,Sw] = SCATTER(classes)

%   FUNÇÃO:
%           [Sb,Sw] = SCATTER(classes)
%
%   Essa função calcula as matrizes de espalhamento Sb e Sw.
%
%   INPUTS:
%           classes = celula {1 x Numero de classes}, onde classes{c} = matriz L x N (caracteristicas x padroes) para a classe c
%
%   OUTPUTS:
%           Sb = Matriz de espalhamento entre-classes
%           Sw = Matriz de espalhamento intra-classes

    n = size(classes{1},1); %numero de caracteristicas para considerar
    N = 0;
    Probs = zeros(1,length(classes)); %probabilidades de cada classe
    for i=1:1:length(classes)
        if i>1
            if ~isequal(size(classes{i},1),size(classes{i-1},1))
                error('Classes devem ter o mesmo numero de caracteristicas!')
            end
        end
        N = N+size(classes{i},2);
        Probs(1,i) = size(classes{i},2);
    end
    Probs = Probs./N;
    
    combinacoes = nchoosek(1:size(classes{1},1),n); % combinacoes de caracteristicas
    for j=1:size(combinacoes,1)  
        caracts = combinacoes(j,:);
        Sw = zeros(n,n);
        allclasses = [];
        for i=1:length(classes)
            varwithin = cov(classes{i}(caracts,:)',1);    
            allclasses = [allclasses;classes{i}(caracts,:)'];
            Sw = Sw+Probs(i).*varwithin; % Matriz de espalhamento intra-classe
        end
        Sm = cov(allclasses,1); % Matriz de espalhamento mista
        Sb = Sm-Sw;
    end
end  
