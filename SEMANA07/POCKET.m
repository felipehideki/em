function [w,iteracoes] = POCKET(xClasse1,xClasse2,max_iteracoes,rho)

%   INPUT:
%           mClasse1: matriz de dados da classe1, características x padrões
%           mClasse2: matriz de dados da classe2, características x padrões
%           max_iteracoes: número máximo de iterações
%           p: parâmetro de aprendizagem do classificador
%   OUTPUT:
%           w: vetor de pesos
%           iteracoes: número de iterações realizadas para convergência
    
    nx = size(xClasse1,1); % Número de características de X
    indice1 = 1:nx;
    indice2 = (nx+1):(2*nx);
    classes = [-ones(nx,1); ones(nx,1)];
    
    y = [xClasse1;xClasse2];
    y = [y, ones(size(y,1),1)]; % L+1 dimensões
    N = size(y,1); % Número de características de y (2 x nx)
    
    w0 = randn(size(y,2),1); % vetor de pesos inicial w0, randomizado
    wp = w0; % guardando w0 no pocket (wp)
    indicesYe = 1;
    i = 0;
    
    while(~isempty(indicesYe))
        pk = y*w0;
        % Para este algoritmo, define-se que
        % se p com índice k no máximo N/2 ("primeira metade"):
        %   é positivo: está classificado corretamente
        %   é negativo: está classificado incorretamente
        % se p com índice k mínimo (N/2)+1 e no máximo N ("segunda metade"):
        %   é positivo: está classificado incorretamente
        %   é negativo: está classificado corretamente
        % ou vice-versa, invertendo as duas metades só resulta numa
        % classificação invertida (classe1->classe2, classe2->classe1)
        
        % então, para facilitar a busca das classificações incorretas,
        % basta inverter o sinal de pk para uma das metades. Ou seja, 
        % selecionar todos os pk incorretos será selecionar todos os pk de 
        % mesmo sinal para ambas as metades.
        pk(indice2) = -pk(indice2); % invertendo sinal da segunda metade
        % agora basta buscar os pk negativos, que serão todos INCORRETOS,
        % independente da metade.
        indicesYe = find(pk<0);
        
        wi = w0 + rho*sum(y(indicesYe),1);
        
        pk = y*wi;
        indicesYe = find(pk<0);
        Jwi = -sum(y(indicesYe),1)
    end
    
    
end
