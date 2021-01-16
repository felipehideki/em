function [wp,i] = POCKET(xClasse1,xClasse2,max_iteracoes,rho)
    tic;
%   INPUT:
%           xClasse1: matriz de dados da classe1, características x padrões
%           xClasse2: matriz de dados da classe2, características x padrões
%           max_iteracoes: número máximo de iterações
%           p: parâmetro de aprendizagem do classificador
%   OUTPUT:
%           wp: vetor de pesos pocket
%           i: número de iterações realizadas para convergência

    nx = size(xClasse1,1); % número de características de x
    indice1 = 1:nx; % índices dos elementos da 1ªmetade (classe-1)
    indice2 = (nx+1):(2*nx); % índices dos elementos da 2ªmetade (classe+1)
    classes = [-ones(nx,1); ones(nx,1)];
    
    y = [xClasse1;xClasse2];
    y = [y, ones(size(y,1),1)]; % vetor com L+1 dimensões
    N = size(y,1); % número de características de y (2 x nx)
    L1 = size(y,2); % número de dimensões de y (L+1)
    
    wi = randn(size(y,2),1); % primeiro vetor de pesos (w0), randomizado
    wp = wi; % guardando w0 no pocket (wp)
    indicesYe = 1;
    i = 1;
    
    while(~isempty(indicesYe))
        pk = y*wi;
        % Para este algoritmo, define-se que
        % se p com índice k de 1 até N/2 ("primeira metade"):
        %   é positivo: está classificado incorretamente
        %   é negativo: está classificado corretamente
        % se p com índice k de (N/2)+1 até N ("segunda metade"):
        %   é positivo: está classificado corretamente
        %   é negativo: está classificado incorretamente
        % ou vice-versa, invertendo as duas metades só resulta numa
        % classificação invertida (classe1->classe2, classe2->classe1)
        
        % então, para facilitar a busca das classificações incorretas,
        % basta inverter o sinal de pk para uma das metades. Ou seja, 
        % selecionar todos os pk incorretos será selecionar todos os pk de 
        % mesmo sinal para ambas as metades.
        
        pk(indice1) = -pk(indice1); % invertendo sinal da primeira metade
        % agora basta buscar os pk negativos, que serão todos INCORRETOS,
        % independente da metade.
        indicesYe = find(pk<0);
        % calculando custo J(wi)
        Jwi = -sum(y(indicesYe,:)*wi.*classes(indicesYe));
        
        matrizClasses = repmat(classes(indicesYe),1,L1);
        % criando novo vetor peso wi+1
        wi_new = wi + rho*sum(y(indicesYe,:).*matrizClasses,1)';
        % calculando pk com o novo vetor peso wi+1
        pk = y*wi_new;
        pk(indice1) = -pk(indice1); % invertendo sinal da primeira metade
        indicesYe = find(pk<0);
        % calculando custo J(wi+1)
        Jwi_new = -sum(y(indicesYe,:)*wi_new.*classes(indicesYe));
        % se o custo J(wi+1)<J(wi), guarda wi+1 no pocket
        if Jwi_new<Jwi
            wp = wi_new;
        end
        wi = wi_new;
        i = i+1;
        if i>max_iteracoes | isempty(indicesYe)
            i = i-1;
            c1 = plot( xClasse1(:,1), xClasse1(:,2), '.b' ); hold on; 
            c2 = plot( xClasse2(:,1), xClasse2(:,2), '.r' ); hold on; 
            dominio = linspace(min(y(:,1)), max(y(:,1)));
            imagem = -(wp(3)+wp(1)*dominio)/wp(2);
            perceptron = plot(dominio,imagem,'-black');
            title(['\rho = ', num2str(rho,'%.2f'),', iterações: ', num2str(i)]);
            legend([c1,c2,perceptron], {'classe 1','classe 2','perceptron'});
            toc;
            break
        end
    end
end
