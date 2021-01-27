% % SEMANA 08
%   SUPPORT VECTOR MACHINES

%% 1) SVM LINEAR

% % a) gerando dados
sigma{1} = [0.2 0;0 0.2];
sigma{2} = sigma{1};
u{1} = [0;0];
u{2} = [1.3;1.2];
prior = [0.5 0.5];

medias = [u{1} u{2}];
covariancias = sigma{1};
covariancias(:,:,2) = sigma{1};
dados = semana5_gerandodadosgaussianos(medias,covariancias,500,prior,0,0)';
classes = [-ones(250,1);ones(250,1)];

% % b) treinando classificador
C = 0.1;
tol = 0.001;
iteracoes = 10^5;
eps = 10^-10;

[alpha, w0, w, evals, stp, glob] = semana9_SVM(dados,classes,'linear',0,0,C,tol,iteracoes,eps);

% % c) quantidade de support vectors
nsv = numel(find(alpha>0)); % número de multiplicadores de Lagrange positivos

% % d) padrões classificados incorretamente
y = [dados, ones(size(dados,1),1)];
pk = y*[w w0]';
pk(1:250) = -pk(1:250); % invertendo sinal da primeira metade (classe 1)
% agora basta buscar os pk negativos, que serão todos INCORRETOS,
% independente da metade.
incorretos = numel(find(pk<0));
erro = incorretos/size(dados,1);

% % e) plot
c1 = plot(dados(1:250,1),dados(1:250,2),'.b'); 
hold on; 
c2 = plot(dados(251:500,1),dados(251:500,2),'.r');
% dominio = linspace(min(dados(:,1)),max(dados(:,1)));
dominio = get(gca,'Xlim');
imagem = -(w0+w(1)*dominio)/w(2); % reta w0x+w1y+w2=0
svm = plot(dominio,imagem,'-black');
margem_pos = plot(dominio,-(w0+1+w(1)*dominio)/w(2),'--k');
margem_neg = plot(dominio,-(w0-1+w(1)*dominio)/w(2),'--k');
title({['SVM linear, ','C = ',num2str(C,'%.2f')];['Support vectors: ', num2str(nsv)];['erro de treinamento = ',num2str(erro)]});
legend([c1,c2,svm,margem_pos], {'classe 1','classe 2','decisão','margem'});

% % f) C = 1
C = 1;
[alpha, w0, w, evals, stp, glob] = semana9_SVM(dados,classes,'linear',0,0,C,tol,iteracoes,eps);

% fa) quantidade de support vectors
nsv = numel(find(alpha>0)); % número de multiplicadores de Lagrange positivos

% fb) padrões classificados incorretamente
y = [dados, ones(size(dados,1),1)];
pk = y*[w w0]';
pk(1:250) = -pk(1:250); % invertendo sinal da primeira metade (classe 1)
% agora basta buscar os pk negativos, que serão todos INCORRETOS,
% independente da metade.
incorretos = numel(find(pk<0));
erro = incorretos/size(dados,1);

% fc) plot
c1 = plot(dados(1:250,1),dados(1:250,2),'.b'); 
hold on; 
c2 = plot(dados(251:500,1),dados(251:500,2),'.r');
% dominio = linspace(min(dados(:,1)),max(dados(:,1)));
dominio = get(gca,'Xlim');
imagem = -(w0+w(1)*dominio)/w(2); % reta w0x+w1y+w2=0
svm = plot(dominio,imagem,'-black');
margem_pos = plot(dominio,-(w0+1+w(1)*dominio)/w(2),'--k');
margem_neg = plot(dominio,-(w0-1+w(1)*dominio)/w(2),'--k');
title({['SVM linear, ','C = ',num2str(C,'%.2f')];['Support vectors: ', num2str(nsv)];['erro de treinamento = ',num2str(erro)]});
legend([c1,c2,svm,margem_pos], {'classe 1','classe 2','decisão','margem'});


%% 2) SVM NÃO-LINEAR

% % a) visualizando dados
load('semana9_exemplo2.mat');
classe1 = find(classesX<0);
classe2 = find(classesX>0);
c1 = plot(X(1,classe1),X(2,classe1),'ob'); 
hold on; 
c2 = plot(X(1,classe2),X(2,classe2),'+r');

% % b) SVM LINEAR C = 2
C = 2;
tol = 0.001;
iteracoes = 10^5;
eps = 10^-10;

[alpha, w0, w, evals, stp, glob] = semana9_SVM(X',classesX','linear',0,0,C,tol,iteracoes,eps);

% ba) quantidade de support vectors
nsv = numel(find(alpha>0)); % número de multiplicadores de Lagrange > 0

% bb) padrões classificados incorretamente
y = [X', ones(size(X',1),1)];
pk = y*[w w0]';
pk(classe1) = -pk(classe1); % invertendo sinal da primeira metade (classe 1)
% agora basta buscar os pk negativos, que serão todos INCORRETOS,
% independente da metade.
incorretos = numel(find(pk<0));
erro = incorretos/size(X',1);

% bc) plot
% dominio = linspace(min(dados(:,1)),max(dados(:,1)));
dominio = get(gca,'Xlim');
imagem = -(w0+w(1)*dominio)/w(2); % reta w0x+w1y+w2=0
svm = plot(dominio,imagem,'-black');
margem_pos = plot(dominio,-(w0+1+w(1)*dominio)/w(2),'--k');
margem_neg = plot(dominio,-(w0-1+w(1)*dominio)/w(2),'--k');
title({['SVM linear, ','C = ',num2str(C,'%.2f')];['Support vectors: ', num2str(nsv)];['erro de treinamento = ',num2str(erro)]});
legend([c1,c2,svm,margem_pos], {'classe 1','classe 2','decisão','margem'});

% % c) KERNEL RADIAL C = 2, delta = 2
[alpha, w0, w, evals, stp, glob] = semana9_SVM(X',classesX','rbf',2,0,C,tol,iteracoes,eps);
indices_svms = find(alpha>0); % índices dos multiplicadores de Lagrange > 0
svms = X(:,indices_svms); % vetores de suporte
coefs = alpha(indices_svms).*classesX(indices_svms)'; % coeficientes correspondentes aos vetores de suporte
[classificacao,erro] = semana9_SVMclass(coefs,svms,'rbf',2,0,w0,X,classesX);


%% 3) SVM NÃO-LINEAR

% % a) visualizando dados
load('semana9_exemplo3.mat');
classe1 = find(classesX<0);
classe2 = find(classesX>0);
% c1 = plot(X(1,classe1),X(2,classe1),'ob'); 
% hold on; 
% c2 = plot(X(1,classe2),X(2,classe2),'+r');

% aa) SVM NÃO-LINEAR C = 2000, delta = 0.5
C = 2000;
tol = 0.001;
iteracoes = 10^5;
eps = 10^-10;

[alpha, w0, w, evals, stp, glob] = semana9_SVM(X',classesX','rbf',0.5,0,C,tol,iteracoes,eps);
indices_svms = find(alpha>0); % índices dos multiplicadores de Lagrange > 0
svms = X(:,indices_svms); % vetores de suporte
coefs = alpha(indices_svms).*classesX(indices_svms)'; % coeficientes correspondentes aos vetores de suporte
[classificacao,erro] = semana9_SVMclass(coefs,svms,'rbf',0.5,0,w0,X,classesX);

% b) Classificando X2
[classificacao,erro] = semana9_SVMclass(coefs,svms,'rbf',0.5,0,w0,X2,classesX2);

