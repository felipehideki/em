% % TRABALHO FINAL DE ENGENHARIA MÉDICA 2S/2020
% % GRUPO 1

% % CLASSIFICAÇÃO DE INDIVÍDUOS SAUDÁVEIS/DOENTES DE UM BANCO DE DADOS DE
% % AUSCULTAÇÕES PULMONARES

% % ---------------------------------------------------------------------
% % SCRIPT PARA CLASSIFICAÇÃO
% %     Utiliza os dados contidos no arquivo "DADOS_GRUPO1.mat".
% % ---------------------------------------------------------------------
% % Observação: Os dados originais foram coletados do repositório
% % <https://www.kaggle.com/vbookshelf/respiratory-sound-database>.
% % Porém, por conta do grande volume de dados e o excessivo tempo de
% % processamento para extração das características espectrais, optou-se
% % por enviar os dados já processados para economia de recursos. 
% % Entretanto, se necessário, os dados originais podem ser processados 
% % pelo algorimo presente no arquivo "EXTRACAODADOS_GRUPO1.m".

clear all;
close all;
load('DADOS_GRUPO1.mat');
rng('default');

% % ---------------------------------------------------------------------
% %  CLASSIFICAÇÃO AGRUPAMENTO A: "SAUDÁVEIS x TODOS OS OUTROS"

classes = numeracao;
classes(classes~=1) = 2;
xClasse{1} = dados(classes==1,:);
xClasse{2} = dados(classes==2,:);

% % PERCEPTRON POCKET PARA VERIFICAR SEPARABILIDADE LINEAR
% [~,~,erroPocketAteste] = POCKET(xClasse{1},xClasse{2},10000,0.1);
% 0.05 de erro, mas >95% dos dados são de uma única classe...
% De qualquer modo, não é separável linearmente, o algoritmo não converge.

% % REMOÇÃO DE OUTLIERS
outliers = [];
for j=1:size(xClasse,2)
    for i=1:size(dados,2)
        [~,indexes{i,j}] = semana4_remocaooutliers(xClasse{j}(:,i),3,0);
        outliers = [outliers;indexes{i,j}];
    end
end
outliers = unique(outliers);
classes(outliers) = [];
dadosA = dados;
dadosA(outliers,:) = [];
crackle_wheeze(outliers,:) = []; % Para caso seja utilizado posteriormente
xClasse{1} = dadosA(classes==1,:);
xClasse{2} = dadosA(classes==2,:);
clear i indexes outliers

% HISTOGRAMA
figure;
histogram(classes,2);
[n,x] = hist(classes,2);
barstrings = num2str(n');
text(x,n,barstrings,'horizontalalignment','center','verticalalignment','bottom');
title('Distribuição dos padrões (agrupamento A)');
xlabel('classe (1 = Positiva, 2 = Negativa)');
ylabel('padrões');
ax = gca;
ax.XTick = [1 2];
clear n x ax

% % PERCEPTRON POCKET PARA VERIFICAR SEPARABILIDADE LINEAR
% [~,~,erroPocketAteste] = POCKET(xClasse{1},xClasse{2},10000,0.1);
% Não é separável linearmente, o algoritmo não converge.

% % NORMALIZAÇÃO DOS DADOS
todas = [xClasse{1};xClasse{2}];
padroes_norm = zeros(size(todas,1),size(todas,2));
for i=1:size(todas,2)
    padroes_norm(:,i) = semana4_normalizacao(todas(:,i)');
end
clear todas i
saudaveis = padroes_norm(1:size(xClasse{1},1),:);
doentes = padroes_norm(size(xClasse{1},1)+1:end,:);

% % PCA
erroPCA = 0;
i = size(padroes_norm,2);
while erroPCA<=0.05
        i = i-1;
        [~,~,~,erroPCA] = KL(padroes_norm',i);
end
[~,~,matrizPCA] = KL(padroes_norm',i+1);
clear i erroPCA;
matrizPCA = matrizPCA';
% Espaço reduzido para 10 dimensões após PCA

% % CLASSIFICAÇÃO COM PERCEPTRON
saudaveisPCA = matrizPCA(1:size(xClasse{1},1),:);
doentesPCA = matrizPCA(size(xClasse{1},1)+1:end,:);
Y = [ones(size(saudaveisPCA,1),1);-ones(size(doentesPCA,1),1)];
[~,~,erroPocketA,indicesYe] = POCKET(saudaveisPCA,doentesPCA,10000,0.1);

% Histograma do resultado da classificação Perceptron
figure;
classificacaoP = Y';
classificacaoP(indicesYe) = -classificacaoP(indicesYe);
H = [sum(classificacaoP+Y'>0) sum(classificacaoP+Y'==0) sum(classificacaoP+Y'<0)];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title({['Resultado Perceptron (agrupamento A)'];['Acurácia: ', num2str(100*(1-erroPocketA),'%.2f'),'%']});
xlabel('1 = VP, 2 = FN+FP, 3 = VN');
ylabel('padroes');

% Histograma de percentual dos erros Perceptron
figure;
FN_POCKETA = sum(indicesYe<=size(saudaveisPCA,1))/size(saudaveisPCA,1);
FP_POCKETA = sum(indicesYe>size(saudaveisPCA,1))/size(doentesPCA,1);
H = 100*[FN_POCKETA FP_POCKETA];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title('Percentual de erros Perceptron (agrupamento A)');
xlabel('1 = FN, 2 = FP');
ylabel('%');

% % CLASSIFICAÇÃO COM SVM LINEAR
[alpha, w0] = semana9_SVM(matrizPCA,Y,'linear');
indices_svms = find(alpha>0);
svms = matrizPCA(indices_svms,:);
coefs = alpha(indices_svms).*Y(indices_svms);
[classificacao,erroSVMA] = semana9_SVMclass(coefs,svms','linear',0,0,w0,matrizPCA',Y');

% Histograma do resultado da classificação SVM
figure;
H = [sum(classificacao+Y'>0) sum(classificacao+Y'==0) sum(classificacao+Y'<0) ];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title({['Resultado SVM (agrupamento A)'];['Acurácia: ', num2str(100-erroSVMA,'%.2f'),'%']});
xlabel('1 = VP, 2 = FN+FP, 3 = VN');
ylabel('padrões');

% % Histograma de percentual dos erros SVM
figure;
FN_SVMA = (sum(Y'==1)-sum(classificacao+Y'==2))/sum(Y'==1);
FP_SVMA = (sum(Y'==-1)-sum(classificacao+Y'==-2))/sum(Y'==-1);
H = 100*[FN_SVMA FP_SVMA];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title('Percentual de erros SVM (agrupamento A)');
xlabel('1 = FN, 2 = FP');
ylabel('%');

% AUC da característica 1
% aucA1 = ROC(matrizPCA(:,1),Y);

% % AVALIAÇÃO DE POSSÍVEIS SUBAJUSTES E SOBREAJUSTES
part = cvpartition(size(matrizPCA,1),'KFold',10);
Q = [matrizPCA ones(size(matrizPCA,1),1)];

%   PERCEPTRON
erroPtrainingA = zeros(10,1);
erroPtestA = zeros(10,1);
wb = waitbar(0,'Avaliando subajustes/sobreajustes (A)...');
for i=1:10
    waitbar(i/10);
    fold = matrizPCA(training(part,i),:);% dados de treino
    Z = Y(training(part,i));
    xClasse{1} = fold(Z>0,:);
    xClasse{2} = fold(Z<0,:);
    [wp,~,erroPtrainingA(i)] = POCKET(xClasse{1},xClasse{2},10000,0.1);
    pk = Q*wp;
    pk(pk(test(part,i))<0) = 1;
    pk(pk(test(part,i))>0) = -1;
    erroPtestA(i) = 100*(1-sum(pk(test(part,i))+Y(test(part,i))==0)/sum(test(part,i)));
end
erroPtrainingA = 100*erroPtrainingA;
delete(wb); clear wb;

% SVM
erroSVMtrainingA = zeros(10,1);
erroSVMtestA = zeros(10,1);
wb = waitbar(0,'Avaliando subajustes/sobreajustes (A)...');
for i=1:10
    waitbar(i/10);
    fold = matrizPCA(training(part,i),:);% dados de treino
    Z = Y(training(part,i));
    [alpha,w0,w] = semana9_SVM(fold,Z,'linear');
    indices_svms = find(alpha>0);
    svms = fold(indices_svms,:);
    coefs = alpha(indices_svms).*Z(indices_svms);
    [~,erroSVMtrainingA(i)] = semana9_SVMclass(coefs,svms','linear',0,0,w0,fold',Z');
    pk = Q*[w w0]';
    pk(pk(test(part,i))<0) = 1;
    pk(pk(test(part,i))>0) = -1;
    erroSVMtestA(i) = 100*(1-sum(pk(test(part,i))+Y(test(part,i))==0)/sum(test(part,i)));
end
delete(wb);


% % ---------------------------------------------------------------------
% % CLASSIFICAÇÃO AGRUPAMENTO B: "SAUDÁVEIS x TODOS (5% DPOC)"

% % PARTICIONANDO 5% DOS PADRÕES DE DPOC
c = cvpartition(sum(numeracao==3),'KFold',20);
idx = test(c,1);
dpoc = dados(numeracao==3,:);
dpoc = dpoc(idx,:);

clear classes xClasse
xClasse{1} = dados(numeracao==1,:);
xClasse{2} = dados(numeracao~=1 & numeracao~=3,:);
xClasse{2} = [xClasse{2}; dpoc];
classes = [ones(size(xClasse{1},1),1);2*ones(size(xClasse{2},1),1)];

% % PERCEPTRON POCKET PARA VERIFICAR SEPARABILIDADE LINEAR
% [~,~,erroPocketBteste] = POCKET(xClasse{1},xClasse{2},10000,0.1);
% Não é separável linearmente, o algoritmo não converge.

% % REMOÇÃO DE OUTLIERS
outliers = [];
for j=1:size(xClasse,2)
    for i=1:size(dados,2)
        [~,indexes{i,j}] = semana4_remocaooutliers(xClasse{j}(:,i),3,0);
        outliers = [outliers;indexes{i,j}];
    end
end
outliers = unique(outliers);
classes(outliers) = [];
dadosB = dados;
dadosB(outliers,:) = [];
crackle_wheeze(outliers,:) = []; % Para caso seja utilizado posteriormente
xClasse{1} = dadosB(classes==1,:);
xClasse{2} = dadosB(classes==2,:);
clear i indexes outliers

% HISTOGRAMA
figure;
histogram(classes,2);
[n,x] = hist(classes,2);
barstrings = num2str(n');
text(x,n,barstrings,'horizontalalignment','center','verticalalignment','bottom');
title('Distribuição dos padrões (agrupamento B)');
xlabel('classe (1 = Positiva, 2 = Negativa)');
ylabel('padrões');
ax = gca;
ax.XTick = [1 2];
clear n x ax

% % PERCEPTRON POCKET PARA VERIFICAR SEPARABILIDADE LINEAR
% [~,~,erroPocketBteste] = POCKET(xClasse{1},xClasse{2},10000,0.1);
% Não é separável linearmente, o algoritmo não converge.

% % NORMALIZAÇÃO DOS DADOS
todas = [xClasse{1};xClasse{2}];
padroes_norm = zeros(size(todas,1),size(todas,2));
for i=1:size(xClasse{1},2)
    padroes_norm(:,i) = semana4_normalizacao(todas(:,i)');
end
clear todas i
saudaveis = padroes_norm(1:size(xClasse{1},1),:);
doentes = padroes_norm(size(xClasse{1},1)+1:end,:);

% % PERCEPTRON POCKET PARA VERIFICAR SEPARABILIDADE LINEAR
% [~,~,erroPocketB] = POCKET(saudaveis,doentes,10000,0.1);
% 0.05 de erro, mas >95% dos dados são da classe não-saudável...
% Não é separável linearmente, o algoritmo não converge.

% % PCA
erroPCA = 0;
i = size(padroes_norm,2);
while erroPCA<=0.05
        i = i-1;
        [~,~,~,erroPCA] = KL(padroes_norm',i);
end
[~,~,matrizPCA] = KL(padroes_norm',i+1);
clear i erroPCA;
matrizPCA = matrizPCA';
% Espaço reduzido para 9 dimensões após PCA

% % CLASSIFICAÇÃO COM PERCEPTRON
saudaveisPCA = matrizPCA(1:size(xClasse{1},1),:);
doentesPCA = matrizPCA(size(xClasse{1},1)+1:end,:);
Y = [ones(size(saudaveisPCA,1),1);-ones(size(doentesPCA,1),1)];
[~,~,erroPocketB,indicesYe] = POCKET(saudaveisPCA,doentesPCA,10000,0.1);

% Histograma do resultado da classificação Perceptron
figure;
classificacaoP = Y';
classificacaoP(indicesYe) = -classificacaoP(indicesYe);
H = [sum(classificacaoP+Y'>0) sum(classificacaoP+Y'==0) sum(classificacaoP+Y'<0)];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title({['Resultado Perceptron (agrupamento B)'];['Acurácia: ', num2str(100*(1-erroPocketB),'%.2f'),'%']});
xlabel('1 = VP, 2 = FN+FP, 3 = VN');
ylabel('padroes');

% Histograma de percentual dos erros Perceptron
figure;
FN_POCKETB = sum(indicesYe<=size(saudaveisPCA,1))/size(saudaveisPCA,1);
FP_POCKETB = sum(indicesYe>size(saudaveisPCA,1))/size(doentesPCA,1);
H = 100*[FN_POCKETB FP_POCKETB];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title('Percentual de erros Perceptron (agrupamento B)');
xlabel('1 = FN, 2 = FP');
ylabel('%');

% % CLASSIFICAÇÃO COM SVM LINEAR
[alpha, w0] = semana9_SVM(matrizPCA,Y,'linear');
indices_svms = find(alpha>0);
svms = matrizPCA(indices_svms,:);
coefs = alpha(indices_svms).*Y(indices_svms);
[classificacao,erroSVMB] = semana9_SVMclass(coefs,svms','linear',0,0,w0,matrizPCA',Y');

% Histograma do resultado da classificação SVM
figure;
H = [sum(classificacao+Y'>0) sum(classificacao+Y'==0) sum(classificacao+Y'<0) ];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title({['Resultado SVM (agrupamento B)'];['Acurácia: ', num2str(100-erroSVMB,'%.2f'),'%']});
xlabel('1 = VP, 2 = FN+FP, 3 = VN');
ylabel('padrões');

% Histograma de percentual dos erros SVM
figure;
FN_SVMB = (sum(Y'==1)-sum(classificacao+Y'==2))/sum(Y'==1);
FP_SVMB = (sum(Y'==-1)-sum(classificacao+Y'==-2))/sum(Y'==-1);
H = 100*[FN_SVMB FP_SVMB];
bar(H);
text(1:length(H),H,num2str(H'),'vert','bottom','horiz','center'); 
box off
title('Percentual de erros SVM (agrupamento B)');
xlabel('1 = FN, 2 = FP');
ylabel('%');

% AUC da característica 1
% aucB1 = ROC(matrizPCA,Y);


% % AVALIAÇÃO DE POSSÍVEIS SUBAJUSTES E SOBREAJUSTES

part = cvpartition(size(matrizPCA,1),'KFold',10);
Q = [matrizPCA ones(size(matrizPCA,1),1)];

%   PERCEPTRON
erroPtrainingB = zeros(10,1);
erroPtestB = zeros(10,1);
wb = waitbar(0,'Avaliando subajustes/sobreajustes (B)...');
for i=1:10
    waitbar(i/10);
    fold = matrizPCA(training(part,i),:);% dados de treino
    Z = Y(training(part,i));
    xClasse{1} = fold(Z>0,:);
    xClasse{2} = fold(Z<0,:);
    [wp,~,erroPtrainingB(i)] = POCKET(xClasse{1},xClasse{2},10000,0.1);
    pk = Q*wp;
    pk(pk(test(part,i))<0) = 1;
    pk(pk(test(part,i))>0) = -1;
    erroPtestB(i) = 100*(1-sum(pk(test(part,i))+Y(test(part,i))==0)/sum(test(part,i)));
end
erroPtrainingB = 100*erroPtrainingB;
delete(wb); clear wb;

% % SVM
wb = waitbar(0,'Avaliando subajustes/sobreajustes (B)...');
erroSVMtrainingB = zeros(10,1);
erroSVMtestB = zeros(10,1);
for i=1:10
    waitbar(i/10);
    fold = matrizPCA(training(part,i),:);% dados de treino
    Z = Y(training(part,i));
    [alpha,w0,w] = semana9_SVM(fold,Z,'linear');
    indices_svms = find(alpha>0);
    svms = fold(indices_svms,:);
    coefs = alpha(indices_svms).*Z(indices_svms);
    [~,erroSVMtrainingB(i)] = semana9_SVMclass(coefs,svms','linear',0,0,w0,fold',Z');
    pk = Q*[w w0]';
    pk(pk(test(part,i))<0) = 1;
    pk(pk(test(part,i))>0) = -1;
    erroSVMtestB(i) = 100*(1-sum(pk(test(part,i))+Y(test(part,i))==0)/sum(test(part,i)));
end
delete(wb); clear wb;

erroP_training_testA = [erroPtrainingA erroPtestA];
erroP_training_testB = [erroPtrainingB erroPtestB];
erroSVM_training_testA = [erroSVMtrainingA erroSVMtestA];
erroSVM_training_testB = [erroSVMtrainingB erroSVMtestB];

clearvars -except erroP_training_testA erroP_training_testB erroSVM_training_testA erroSVM_training_testB

