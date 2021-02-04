% % SEMANA 10
%   AVALIAÇÃO DE CLASSIFICADORES


%% 1) AVALIANDO PERCEPTRON X LS

load('semana10.mat');

indices1 = find(classes==1);
indices2 = find(classes==2);
xClasse1 = dados(:,indices1);
xClasse2 = dados(:,indices2);

max_iteracoes = 1000;
rho = 0.1;
alfa = 0;

% POCKET(xClasse1',xClasse2',max_iteracoes,rho);
% LS(xClasse1',xClasse2',alfa);

% rng('default');
for i=1:10
    part{i} = cvpartition(400,'KFold',2);
    fold{i} = dados.*repmat(training(part{i},1),1,size(dados,1))'; % dados de treino
    xTraining1 = fold{i}(:,indices1);
    xTraining2 = fold{i}(:,indices2);
    wPocket{i} = POCKET(xTraining1',xTraining2',max_iteracoes,rho);
    wLS{i} = LS(xTraining1',xTraining2',alfa);
    close all;
    y = (dados-fold{i})'; % dados de teste (dados originais - dados de treino)
    y = [y,ones(size(y,1),1)]; % vetor com L+1 dimensões
    y(find(y(:,1)==0&y(:,2)==0&y(:,3)==0),4) = 0; % incluindo zeros na última coluna para os padrões "nulos"
    % Erro Pocket
    pk = y*wPocket{i};
    FP_pocket(i) = numel(find(pk(indices1)>0))/numel(indices1);
    FN_pocket(i) = numel(find(pk(indices2)<0))/numel(indices2);
    % Erro LS
    pk = y*wLS{i};
    FP_LS(i) = numel(find(pk(indices1)>0))/numel(indices1);
    FN_LS(i) = numel(find(pk(indices1)<0))/numel(indices2);
end


%% 2) AVALIANDO SVM

load('semana10.mat');

indices1 = find(classes==1);
indices2 = find(classes==2);
classes(indices1) = -1;
classes(indices2) = 1;

% treinando classificador
C = 0.1;
tol = 0.001;
iteracoes = 10^5;
eps = 10^-10;

% rng('default');
for i=1:10
    part{i} = cvpartition(400,'KFold',2);
    fold{i} = dados.*repmat(training(part{i},1),1,size(dados,1))'; % dados de treino
    [~,w0,w,~,~,~] = semana9_SVM(fold{i}',classes','linear',0,0,C,tol,iteracoes,eps);
    % padrões classificados incorretamente
    Y = (dados-fold{i})'; % dados de teste (dados originais - dados de treino)
    Y = [Y,ones(size(Y,1),1)]; % vetor com L+1 dimensões
    Y(find(Y(:,1)==0&Y(:,2)==0&Y(:,3)==0),4) = 0; % incluindo zeros na última coluna para os padrões "nulos"
    pk = Y*[w w0]';
    FP_SVM(i) = numel(find(pk(indices1)>0))/numel(indices1);
    FN_SVM(i) = numel(find(pk(indices2)<0))/numel(indices2);
end

% nsv = numel(find(alpha>0)); % número de multiplicadores de Lagrange positivos (quantidade de support vectors)
% % plot
% c1 = plot3(dados(1,indices1),dados(2,indices1),dados(3,indices1),'.b'); 
% hold on; 
% c2 = plot3(dados(1,indices2),dados(2,indices2),dados(3,indices2),'.r'); 
% [x y] = meshgrid(min(Y(:,1)):max(Y(:,1)),min(Y(:,2)):max(Y(:,2)));
% z = -(w0+(w(1)*x)+(w(2)*y))/w(3); % plano w1x+w2y+w3z+w4=0
% svm = surf(x,y,z,ones(size(x)));
% svm.EdgeColor = 'none';
% z_pos = -(w0+1+(w(1)*x)+(w(2)*y))/w(3);
% margem_pos = surf(x,y,z_pos,ones(size(x)));
% z_neg = -(w0-1+(w(1)*x)+(w(2)*y))/w(3);
% margem_neg = surf(x,y,z_neg,ones(size(x)));
% title({['SVM linear, ','C = ',num2str(C,'%.2f')];['Support vectors: ', num2str(nsv)]});
% legend([c1,c2,svm,margem_pos],{'classe 1','classe 2','decisão','margem'});
