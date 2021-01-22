function [w] = LS(xClasse1,xClasse2,alpha)

%   FUNÇÃO:
%           [w] = LS(xClasse1,xClasse2,alpha)
%
%   Essa função implementa o algoritmo para o critério Least Squares (LS).
%
%   INPUT:
%           xClasse1: matriz de dados da classe1, características x padrões
%           xClasse2: matriz de dados da classe2, características x padrões
%           p: parâmetro de aprendizagem do classificador
%   OUTPUT:
%           w: vetor de peso resultante do critério Least Squares (LS)

    tic;
    nx = size(xClasse1,1); % número de características de x
    classes = [-ones(nx,1); ones(nx,1)];
    y = [xClasse1;xClasse2];
    y = [y,ones(size(y,1),1)]; % vetor com L+1 dimensões
    
    % Vetor de pesos pelo critério LS
    w = inv((y'*y)+alpha*ones(size(y,2)))*(y'*classes);
    
    % Plot
    c1 = plot(xClasse1(:,1),xClasse1(:,2),'.b'); 
    hold on; 
    c2 = plot(xClasse2(:,1),xClasse2(:,2),'.r');
    hold on;
    dominio = linspace(min(y(:,1)), max(y(:,1)));
    imagem = -(w(3)+w(1)*dominio)/w(2);
    ls = plot(dominio,imagem,'-black');
    title(['\alpha = ', num2str(alpha,'%.2f')]);
    legend([c1,c2,ls], {'classe 1','classe 2','LS'});
    toc;
end
