function [wp,i] = POCKET(xClasse1,xClasse2,max_iteracoes,rho)

%   FUN��O:
%           [wp,i] = POCKET(xClasse1,xClasse2,max_iteracoes,rho)
%
%   Essa fun��o implementa o algoritmo para o perceptron pocket.
%
%   INPUT:
%           xClasse1: matriz de dados da classe1, caracter�sticas x padr�es
%           xClasse2: matriz de dados da classe2, caracter�sticas x padr�es
%           max_iteracoes: n�mero m�ximo de itera��es
%           p: par�metro de aprendizagem do classificador
%   OUTPUT:
%           wp: vetor de pesos pocket
%           i: n�mero de itera��es realizadas para converg�ncia

    tic;
    nx = size(xClasse1,1); % n�mero de caracter�sticas de x
    indice1 = 1:nx; % �ndices dos elementos da 1�metade (classe-1)
    indice2 = (nx+1):(2*nx); % �ndices dos elementos da 2�metade (classe+1)
    classes = [-ones(nx,1); ones(nx,1)];
    
    y = [xClasse1;xClasse2];
    y = [y, ones(size(y,1),1)]; % vetor com L+1 dimens�es
    N = size(y,1); % n�mero de caracter�sticas de y (2 x nx)
    L1 = size(y,2); % n�mero de dimens�es de y (L+1)
    
    wi = randn(size(y,2),1); % primeiro vetor de pesos (w0), randomizado
    wp = wi; % guardando w0 no pocket (wp)
    indicesYe = 1;
    i = 1;
    
    while(1)
        pk = y*wi;
        % Para este algoritmo, define-se que
        % se p com �ndice k de 1 at� N/2 ("primeira metade"):
        %   � positivo: est� classificado incorretamente
        %   � negativo: est� classificado corretamente
        % se p com �ndice k de (N/2)+1 at� N ("segunda metade"):
        %   � positivo: est� classificado corretamente
        %   � negativo: est� classificado incorretamente
        % ou vice-versa, invertendo as duas metades s� resulta numa
        % classifica��o invertida (classe1->classe2, classe2->classe1)
        
        % ent�o, para facilitar a busca das classifica��es incorretas,
        % basta inverter o sinal de pk para uma das metades. Ou seja, 
        % selecionar todos os pk incorretos ser� selecionar todos os pk de 
        % mesmo sinal para ambas as metades.
        
        pk(indice1) = -pk(indice1); % invertendo sinal da primeira metade
        % agora basta buscar os pk negativos, que ser�o todos INCORRETOS,
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
        erro = numel(indicesYe)/size(y,1);
        if i>max_iteracoes | isempty(indicesYe)
            i = i-1;
            switch size(y,2)
                case 3 % L+1=3 (L = 2 dimens�es)
                    c1 = plot(xClasse1(:,1),xClasse1(:,2),'.b'); 
                    hold on; 
                    c2 = plot(xClasse2(:,1),xClasse2(:,2),'.r');
                    hold on;
%                     dominio = linspace(min(y(:,1)), max(y(:,1)));
                    dominio = get(gca,'Xlim');
                    imagem = -(wp(3)+wp(1)*dominio)/wp(2); % reta w1x+w2y+w3=0
                    perceptron = plot(dominio,imagem,'-black');
                    title({['\rho = ', num2str(rho,'%.2f'),', itera��es: ', num2str(i)];['erro: ',num2str(erro)]});
                    legend([c1,c2,perceptron], {'classe 1','classe 2','perceptron'});
                case 4 % L+1=4 (L = 3 dimens�es)
                    c1 = plot3(xClasse1(:,1),xClasse1(:,2),xClasse1(:,3),'.b'); 
                    hold on; 
                    c2 = plot3(xClasse2(:,1),xClasse2(:,2),xClasse2(:,3),'.r');
                    hold on;
                    [x y] = meshgrid(min(y(:,1)):max(y(:,1)),min(y(:,2)):max(y(:,2)));
                    z = -((wp(1)*x)+(wp(2)*y)+wp(4))/wp(3); % plano w1x+w2y+w3z+w4=0
                    perceptron = surf(x,y,z,ones(size(x)));
                    perceptron.EdgeColor = 'none';
                    title({['\rho = ', num2str(rho,'%.2f'),', itera��es: ', num2str(i)];['erro: ',num2str(erro)]});
                    legend([c1,c2,perceptron], {'classe 1','classe 2','perceptron'});
            end
            toc;
            break;
        end
    end
end
