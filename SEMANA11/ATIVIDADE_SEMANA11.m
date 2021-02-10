% % SEMANA 11
%   CLASSIFICAÇÃO COMPLETA


%% 1) TREINANDO CLASSIFICADOR

load('Semana11_1.mat');

% % NORMALIZAÇÃO

for i=1:size(Padroes,2) 
    padroes_norm(:,i) = semana4_normalizacao(Padroes(:,i));
end

j = 0;
k = 0;
for i=1:size(Classes,1)
    if Classes(i)
        j = j+1;
        xClasse1(j,:) = padroes_norm(i,:);
    else
        k = k+1;
        xClasse2(k,:) = padroes_norm(i,:);
    end
end

% % TESTE ESTATÍSTICO

[h,p,irrelevantes,normais] = semana4_testeestatistico(xClasse1',xClasse2');

% Selecionando somente caracteristicas relevantes para distinção das classes
relevantes = zeros(size(Padroes,1),size(Padroes,2)-numel(irrelevantes));
j = 1;
k = 0;
for i=1:size(padroes_norm,2) 
    if i~=irrelevantes(1,j)
        k = k+1;
        relevantes(:,k) = padroes_norm(:,i);
    else
        j = j+1;
    end
end

relevantes_c1 = zeros(size(xClasse1,1),size(Padroes,2)-numel(irrelevantes));
relevantes_c2 = zeros(size(xClasse2,1),size(Padroes,2)-numel(irrelevantes));
j = 0;
k = 0;
for i=1:size(Classes,1)
    if Classes(i)
        j = j+1;
        relevantes_c1(j,:) = relevantes(i,:);
    else
        k = k+1;
        relevantes_c2(k,:) = relevantes(i,:);
    end
end

% % Encontrando maior AUC e FDR para seleção escalar
for caracteristica=1:size(relevantes,2)
    media_classe1(caracteristica) = mean(relevantes_c1(:,caracteristica));
    var_classe1(caracteristica) = var(relevantes_c1(:,caracteristica));
    media_classe2(caracteristica) = mean(relevantes_c2(:,caracteristica));
    var_classe2(caracteristica) = var(relevantes_c2(:,caracteristica));
    FDR(caracteristica) = ((media_classe1(caracteristica)-media_classe2(caracteristica))^2)/(var_classe1(caracteristica)+var_classe2(caracteristica));
    
    vcarac = [relevantes_c1(:,caracteristica);relevantes_c2(:,caracteristica)];
    y = (1:(numel(relevantes_c1(:,caracteristica))+numel(relevantes_c2(:,caracteristica))))'>numel(relevantes_c1(:,caracteristica)); % classe1 = 0, classe2 = 1
    reg_log = glmfit(vcarac,y,'binomial');   % regressão logística
    p = glmval(reg_log,vcarac,'logit');      % p

    [Xmed,Ymed,~,AUC(caracteristica)] = perfcurve(y,p,'true');

%     figure(caracteristica);
%     plot(0:1,0:1,'black');
%     hold on;
%     plot(Xmed,Ymed);
%     xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
%     title(['AUC = ', num2str(AUC(caracteristica),'%.3f')]);
end
maxAUC = find(AUC==max(AUC));
maxFDR = find(FDR==max(FDR));


sqa1AUC = relevantes(:,maxAUC).^2;
sqa1FDR = relevantes(:,maxFDR).^2;
sumsqa1AUC = sum(sqa1AUC);
sumsqa1FDR = sum(sqa1FDR);
for i=1:size(relevantes,2)
    if i~=maxAUC
        multAUC(:,i) = relevantes(:,maxAUC).*relevantes(:,i);
        summultAUC = sum(multAUC(:,i));
        sqajAUC(:,i) = relevantes(:,i).^2;
        sumsqajAUC = sum(sqajAUC(:,i));
        sqrtsumsqajAUC = sqrt(sumsqa1AUC*sumsqajAUC);
    	indicecAUC = summultAUC/sqrtsumsqajAUC;
        mkAUC08(i) = AUC(i) - 0.8*abs(indicecAUC);
        mkAUC05(i) = AUC(i) - 0.5*abs(indicecAUC);
    end
    if i~=maxFDR
        multFDR(:,i) = relevantes(:,maxFDR).*relevantes(:,i);
        summultFDR = sum(multFDR(:,i));
        sqajFDR(:,i) = relevantes(:,i).^2;
        sumsqajFDR = sum(sqajFDR(:,i));
        sqrtsumsqajFDR = sqrt(sumsqa1FDR*sumsqajFDR);
    	indicecFDR = summultFDR/sqrtsumsqajFDR;
        mkFDR08(i) = FDR(i) - 0.8*abs(indicecFDR);
        mkFDR05(i) = FDR(i) - 0.5*abs(indicecFDR);
    end
end
maxmkAUC05 = find(mkAUC05==max(mkAUC05));
maxmkAUC08 = find(mkAUC08==max(mkAUC08));
maxmkFDR05 = find(mkFDR05==max(mkFDR05));
maxmkFDR08 = find(mkFDR08==max(mkFDR08));

% plot(relevantes(Classes>0,maxAUC),relevantes(Classes>0,maxmkAUC05),'.','markersize',15);
% hold on;
% plot(relevantes(Classes<1,maxAUC),relevantes(Classes<1,maxmkAUC05),'+','markersize',15);
% close all;
% plot(relevantes(Classes>0,maxFDR),relevantes(Classes>0,maxmkFDR05),'.','markersize',15);
% hold on;
% plot(relevantes(Classes<1,maxFDR),relevantes(Classes<1,maxmkFDR05),'+','markersize',15);

% % SELEÇÃO VETORIAL

%   ORGANIZANDO VETORES PARA INPUT NA FUNÇÃO DE SELEÇÃO VETORIAL
classes{1} = relevantes_c1';
classes{2} = relevantes_c2';

%   SELEÇÃO VETORIAL
[ordem,maxcriterio,J1,J2,J3,combinacoes]= semana4_SelecaoVetorial('exaustivo','J3',classes,2);

% plot(relevantes(Classes>0,ordem(1)),relevantes(Classes>0,ordem(2)),'.','markersize',15);
% hold on;
% plot(relevantes(Classes<1,ordem(1)),relevantes(Classes<1,ordem(2)),'+','markersize',15);


% % PERCEPTRON
classeA = [relevantes(Classes>0,ordem(1)) relevantes(Classes>0,ordem(2))];
classeB = [relevantes(Classes<1,ordem(1)) relevantes(Classes<1,ordem(2))];
wp = POCKET(classeA,classeB,10000,0.05);


% % SUPPORT VECTOR MACHINES
C = 1;
tol = 0.001;
iteracoes = 10^5;
eps = 10^-10;
class = [-ones(size(classeA,1),1);ones(size(classeB,1),1)];
dados = [classeA;classeB];

[alpha, w0, w, evals, stp, glob] = semana9_SVM(dados,class,'linear',0,0,C,tol,iteracoes,eps);


% % c) quantidade de support vectors
nsv = numel(find(alpha>0)); % número de multiplicadores de Lagrange positivos

% % d) padrões classificados incorretamente
clear y;
y = [dados, ones(size(dados,1),1)];
pk = y*[w w0]';
pk(1:size(classeA,1)) = -pk(1:size(classeA,1)); % invertendo sinal da primeira metade (classe 1)
% agora basta buscar os pk negativos, que serão todos INCORRETOS,
% independente da metade.
incorretos = numel(find(pk<0));
erro = incorretos/size(dados,1);

% % e) plot
% c1 = plot(classeA(:,1),classeA(:,2),'.b'); 
% hold on; 
% c2 = plot(classeB(:,1),classeB(:,2),'.r');
% % dominio = linspace(min(dados(:,1)),max(dados(:,1)));
% dominio = get(gca,'Xlim');
% imagem = -(w0+w(1)*dominio)/w(2); % reta w0x+w1y+w2=0
% svm = plot(dominio,imagem,'-black');
% margem_pos = plot(dominio,-(w0+1+w(1)*dominio)/w(2),'--k');
% margem_neg = plot(dominio,-(w0-1+w(1)*dominio)/w(2),'--k');
% title({['SVM linear, ','C = ',num2str(C,'%.2f')];['Support vectors: ', num2str(nsv)];['erro de treinamento = ',num2str(erro)]});
% legend([c1,c2,svm,margem_pos], {'classe 1','classe 2','decisão','margem'});

indices_svms = find(alpha>0); % índices dos multiplicadores de Lagrange > 0
svms = dados(indices_svms,:); % vetores de suporte
coefs = alpha(indices_svms).*class(indices_svms); % coeficientes correspondentes aos vetores de suporte
[classificacao,erro] = semana9_SVMclass(coefs,svms','linear',0,0,w0,dados',class');


%% 2) CLASSIFICANDO SEGUNDO CONJUNTO DE DADOS

clearvars -except w w0 wp classeA classeB ordem alpha irrelevantes svms
load('Semana11_2.mat');

% % NORMALIZAÇÃO
Padroes = Padroes';
Classes = Classes';

for i=1:size(Padroes,2)
    padroes_norm(:,i) = semana4_normalizacao(Padroes(:,i));
end

% Selecionando somente caracteristicas relevantes para distinção das classes
relevantes = zeros(size(Padroes,1),size(Padroes,2)-numel(irrelevantes));
j = 1;
k = 0;
for i=1:size(padroes_norm,2) 
    if i~=irrelevantes(1,j)
        k = k+1;
        relevantes(:,k) = padroes_norm(:,i);
    else
        j = j+1;
    end
end

j = 0;
k = 0;
for i=1:size(Classes,1)
    if Classes(i)
        j = j+1;
        relevantes_c1(j,:) = relevantes(i,:);
    else
        k = k+1;
        relevantes_c2(k,:) = relevantes(i,:);
        Classes(i) = -1;
    end
end

xClasse1 = relevantes_c1(:,ordem);
xClasse2 = relevantes_c2(:,ordem);

dados = [xClasse1;xClasse2];
class = [-ones(size(classeA,1),1);ones(size(classeB,1),1)];

indices_svms = find(alpha>0); % índices dos multiplicadores de Lagrange > 0
coefs = alpha(indices_svms).*class(indices_svms); % coeficientes correspondentes aos vetores de suporte
[classificacao,erro] = semana9_SVMclass(coefs,svms','linear',0,0,w0,dados',class');

% % % d) padrões classificados incorretamente
% y = [dados, ones(size(dados,1),1)];
% pk = y*[w w0]';
% pk(1:size(relevantes_c1,1)) = -pk(1:size(relevantes_c1,1)); % invertendo sinal da primeira metade (classe 1)
% % agora basta buscar os pk negativos, que serão todos INCORRETOS,
% % independente da metade.
% incorretos = numel(find(pk<0));
% erro = incorretos/size(dados,1);
