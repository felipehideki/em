function [w,erro] = LS(xClasse1,xClasse2,alpha)

%   FUNÇÃO:
%           [w] = LS(xClasse1,xClasse2,alpha)
%
%   Essa função implementa o algoritmo para o critério Least Squares (LS).
%
%   INPUT:
%           xClasse1: matriz de dados da classe1, características x padrões
%           xClasse2: matriz de dados da classe2, características x padrões
%           alpha: parâmetro de aprendizagem do classificador
%   OUTPUT:
%           w: vetor de peso resultante do critério Least Squares (LS)

    tic;
    nx = size(xClasse1,1); % número de características de x
    classes = [-ones(nx,1); ones(nx,1)];
    y = [xClasse1;xClasse2];
    y = [y,ones(size(y,1),1)]; % vetor com L+1 dimensões
    
    % Vetor de pesos pelo critério LS (w = X'X\X'Y)
    w = inv((y'*y)+alpha*ones(size(y,2)))*(y'*classes);
   
    % Encontrando erros
    indice1 = find(classes<0); % índices dos elementos da 1ªmetade (classe-1)
    pk = y*w;
    pk(indice1) = -pk(indice1);
    indicesYe = find(pk<0);
    erro = numel(indicesYe)/size(y,1);
    
    % Plot
    switch size(y,2)
        case 3 % L+1=3 (L = 2 dimensões)
            c1 = plot(xClasse1(:,1),xClasse1(:,2),'.b'); 
            hold on; 
            c2 = plot(xClasse2(:,1),xClasse2(:,2),'.r');
            hold on;
%             dominio = linspace(min(y(:,1)), max(y(:,1)));
            dominio = get(gca,'Xlim');
            imagem = -(w(3)+w(1)*dominio)/w(2); % reta w1x+w2y+w3=0
            ls = plot(dominio,imagem,'-black');
            title({['\alpha = ', num2str(alpha,'%.2f')];['erro = ', num2str(erro)]});
            legend([c1,c2,ls], {'classe 1','classe 2','LS'});
        case 4 % L+1=4 (L = 3 dimensões)
            c1 = plot3(xClasse1(:,1),xClasse1(:,2),xClasse1(:,3),'.b'); 
            hold on; 
            c2 = plot3(xClasse2(:,1),xClasse2(:,2),xClasse2(:,3),'.r');
            hold on;
            [x y] = meshgrid(min(y(:,1)):max(y(:,1)),min(y(:,2)):max(y(:,2)));
            z = -((w(1)*x)+(w(2)*y)+w(4))/w(3); % plano w1x+w2y+w3z+w4=0
            ls = surf(x,y,z,ones(size(x)));
            ls.EdgeColor = 'none';
            title({['\alpha = ', num2str(alpha,'%.2f')];['erro = ', num2str(erro)]});
            legend([c1,c2,ls], {'classe 1','classe 2','LS'});
    end
    toc;
end
