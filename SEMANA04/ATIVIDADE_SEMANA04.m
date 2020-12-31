% % SEMANA 04

%% 1) REMOÇÃO DE OUTLIERS

load('Semana4_exercicio1.mat');
[outliers,indexes] = semana4_remocaooutliers(sinal);
% [outliers,indexes] = semana4_remocaooutliers2(sinal);


%% 2) NORMALIZAÇÃO

load('Semana4_exercicio2.mat');
figure(1);
plot(med,ske,'.','markersize',25);

med_norm_linear = [med(:,1);med(:,2)];
med_norm_linear = semana4_normalizacao(med_norm_linear);
med_norm_linear = [med_norm_linear(1:5) med_norm_linear(6:10)];
ske_norm_linear = [ske(:,1);ske(:,2)];
ske_norm_linear = semana4_normalizacao(ske_norm_linear);
ske_norm_linear = [ske_norm_linear(1:5) ske_norm_linear(6:10)];
figure(2);
plot(med_norm_linear,ske_norm_linear,'.','markersize',25);


%% 3) TESTES ESTATÍSTICOS

load('Semana4_exercicio2.mat');
classe1 = [med(:,1)';ske(:,1)'];
classe2 = [med(:,2)';ske(:,2)'];
semana4_testeestatistico(classe1,classe2);


%% 4) CARACTERÍSTICA DE OPERAÇÃO DO RECEPTOR (ROC)

load('Semana4_exercicio2.mat');

% ROC em med
vmed = [med(:,1);med(:,2)];
vmed = sort(vmed);
for i=1:10
    FALSO(i) = 0;
    VERDADEIRO(i) = 0;
end
for i=numel(vmed):-1:1 % verificando da direita para esquerda
    achado = find(med==vmed(i));
    if achado<=5 % achado<=5 é a segunda classe (coluna) de med
        FALSO(11-i) = 1;
    else
        VERDADEIRO(11-i) = 1;
    end
    FP(11-i) = sum(FALSO)/5;
    VP(11-i) = sum(VERDADEIRO)/5;
end
AUCmed = trapz(FP,VP);
figure(1);
plot(0:1,0:1,'black');
hold on;
plot(FP,VP);
xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
title(['AUC = ', num2str(AUCmed,'%.3f')]);


% ROC em ske
vske = [ske(:,1);ske(:,2)];
vske = sort(vske);
for i=1:10
    FALSO(i) = 0;
    VERDADEIRO(i) = 0;
end
for i=numel(vske):-1:1  % verificando da direita para a esquerda
    achado = find(ske==vske(i));
    if (achado<=5)  % achado<=5 é a primeira classe (coluna) de ske
        FALSO(11-i) = 1;
    else
        VERDADEIRO(11-i) = 1;
    end
    FP(11-i) = sum(FALSO)/5;
    VP(11-i) = sum(VERDADEIRO)/5;
end
AUCske = trapz(FP,VP);
figure(2);
plot(0:1,0:1,'black');
hold on;
plot(FP,VP);
xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
title(['AUC = ', num2str(AUCske,'%.3f')]);


% % CALCULANDO ROC POR REGRESSÃO LOGÍSTICA

% vmed = [med(:,1);med(:,2)];         % vetor de dados característica med
% vske = [ske(:,1);ske(:,2)];         % vetor de dados característica ske
% y = (1:10)'>5;                      % classe1 = 0, classe2 = 1
% reg_logmed = glmfit(vmed,y,'binomial');   % regressão logística para med
% reg_logske = glmfit(vske,y,'binomial');   % regressão logística para ske
% pmed = glmval(reg_logmed,vmed,'logit');      % p para classificação med
% pske = glmval(reg_logske,vske,'logit');      % p para classificação ske
% 
% [Xmed,Ymed,~,AUCmed] = perfcurve(y,pmed,'true');
% [Xske,Yske,~,AUCske] = perfcurve(y,pske,'true');
% 
% figure(1);
% plot(0:1,0:1,'black');
% hold on;
% plot(Xmed,Ymed);
% xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
% title(['AUC = ', num2str(AUCmed,'%.3f')]);
% 
% figure(2);
% plot(0:1,0:1,'black');
% hold on;
% plot(Xske,Yske);
% xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
% title(['AUC = ', num2str(AUCske,'%.3f')]);


%% 5) PRÉ-PROCESSAMENTO, TESTE ESTATÍSTICO E ROC

load('Semana3_eeg.mat');
[media,variancia,mobilidade,complex_estatistica,freq_central,largura_banda,freq_margem,pot_espect_norm] = principais_c(SINAL,100);

% ESTÁGIOS DO SINAL
vigilia = find(ESTAGIOS==0);
vigilia = [vigilia(1):vigilia(end)];
estagio1 = find(ESTAGIOS==1);
estagio1 = [estagio1(1):estagio1(end)];
estagio2 = find(ESTAGIOS==2);
estagio2 = [estagio2(1):estagio2(end)];
estagio3 = find(ESTAGIOS==3);
estagio3 = [estagio3(1):estagio3(end)];
estagio4 = find(ESTAGIOS==4);
estagio4 = [estagio4(1):estagio4(end)];
rem = find(ESTAGIOS==5);
rem = [rem(1):rem(end)];

% % a) OUTLIERS
% semana4_remocaooutliers2(media);
% semana4_normalizacao(media);

% d) AUC
indice1 = vigilia;
indice2 = rem;
vcarac = [largura_banda(indice1)';largura_banda(indice2)'];
y = (1:(numel(indice1)+numel(indice2)))'>indice1(end); % classe1 = 0, classe2 = 1
reg_log = glmfit(vcarac,y,'binomial');   % regressão logística
p = glmval(reg_log,vcarac,'logit');      % p

[Xmed,Ymed,~,AUC] = perfcurve(y,p,'true');

figure(1);
plot(0:1,0:1,'black');
hold on;
plot(Xmed,Ymed);
xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
title(['AUC = ', num2str(AUC,'%.3f')]);


%% 6) SELEÇÃO ESCALAR POR AUC E POR CRITÉRIO DE FISHER (FDR)

load('Semana4_exercicio6.mat');

%   NORMALIZAÇÃO
med_norm_linear = [figadoadiposo(:,1);figadocirrotico(:,1)];
med_norm_linear = semana4_normalizacao(med_norm_linear);
std_norm_linear = [figadoadiposo(:,2);figadocirrotico(:,2)];
std_norm_linear = semana4_normalizacao(std_norm_linear);
ske_norm_linear = [figadoadiposo(:,3);figadocirrotico(:,3)];
ske_norm_linear = semana4_normalizacao(ske_norm_linear);
kur_norm_linear = [figadoadiposo(:,4);figadocirrotico(:,4)];
kur_norm_linear = semana4_normalizacao(kur_norm_linear);
norm_vec = [med_norm_linear std_norm_linear ske_norm_linear kur_norm_linear];
classes{1} = norm_vec(1:10,:);
classes{2} = norm_vec(11:20,:);

for caracteristica=1:4
    media_classe1(caracteristica) = mean(classes{1}(:,caracteristica));
    var_classe1(caracteristica) = var(classes{1}(:,caracteristica));
    media_classe2(caracteristica) = mean(classes{2}(:,caracteristica));
    var_classe2(caracteristica) = var(classes{2}(:,caracteristica));
    FDR(caracteristica) = ((media_classe1(caracteristica)-media_classe2(caracteristica))^2)/(var_classe1(caracteristica)+var_classe2(caracteristica));
    % RESULTADO: CARACTERÍSTICA 1 (MÉDIA) POSSUI MAIOR FDR
    
    vcarac = [classes{1}(:,caracteristica);classes{2}(:,caracteristica)];
    y = (1:(numel(classes{1}(:,caracteristica))+numel(classes{2}(:,caracteristica))))'>=numel(classes{1}(:,caracteristica)); % classe1 = 0, classe2 = 1
    reg_log = glmfit(vcarac,y,'binomial');   % regressão logística
    p = glmval(reg_log,vcarac,'logit');      % p

    [Xmed,Ymed,~,AUC(caracteristica)] = perfcurve(y,p,'true');
    % RESULTADO: CARACTERÍSTICA 1 (MÉDIA) POSSUI MAIOR AUC

%     figure(caracteristica);
%     plot(0:1,0:1,'black');
%     hold on;
%     plot(Xmed,Ymed);
%     xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
%     title(['AUC = ', num2str(AUC(caracteristica),'%.3f')]);
end

cara_padrao = [classes{1};classes{2}];

sqa1 = cara_padrao(:,1).^2;
sum_sqa1 = sum(sqa1);
for j=1:3  %1=STD 2=SKEW 3=KURT
    mult(:,j) = cara_padrao(:,1).*cara_padrao(:,j+1);
    sum_mult(j) = sum(mult(:,j));
    sqaj(:,j) = cara_padrao(:,j+1).^2;
    sum_sqaj(j) = sum(sqaj(:,j));
    sqrt_sum_sqaj(j) = sqrt(sum_sqa1*sum_sqaj(j));
    indice_c(j) = sum_mult(j)/sqrt_sum_sqaj(j);
    % ÍNDICE DE CORRELAÇÃO COM PESO 0.8
    mkFDR08(j) = FDR(j+1) - 0.8*abs(indice_c(j)); % FDR
    mkAUC08(j) = AUC(j+1) - 0.8*abs(indice_c(j)); % AUC
    % ÍNDICE DE CORRELAÇÃO COM PESO 0.5
    mkFDR05(j) = FDR(j+1) - 0.5*abs(indice_c(j)); % FDR
    mkAUC05(j) = AUC(j+1) - 0.5*abs(indice_c(j)); % AUC
end


%% 7) SELEÇÃO VETORIAL

load('Semana4_exercicio6.mat');

%   NORMALIZAÇÃO
med_norm_linear = [figadoadiposo(:,1);figadocirrotico(:,1)];
med_norm_linear = semana4_normalizacao(med_norm_linear);
std_norm_linear = [figadoadiposo(:,2);figadocirrotico(:,2)];
std_norm_linear = semana4_normalizacao(std_norm_linear);
ske_norm_linear = [figadoadiposo(:,3);figadocirrotico(:,3)];
ske_norm_linear = semana4_normalizacao(ske_norm_linear);
kur_norm_linear = [figadoadiposo(:,4);figadocirrotico(:,4)];
kur_norm_linear = semana4_normalizacao(kur_norm_linear);

%   ORGANIZANDO VETORES PARA INPUT NA FUNÇÃO DE SELEÇÃO VETORIAL
norm_vec = [med_norm_linear std_norm_linear ske_norm_linear kur_norm_linear]';
classes{1} = norm_vec(:,1:10);
classes{2} = norm_vec(:,11:20);

%   SELEÇÃO VETORIAL
[ordem,maxcriterio,J1,J2,J3,combinacoes]= semana4_SelecaoVetorial('exaustivo','J3',classes,2);

%   RESULTADO DA SELEÇÃO VETORIAL COM MÉTODO EXAUSTIVO: CARACTERÍSTICAS 1 E 2
media = [norm_vec(1,1:10)' norm_vec(1,11:20)'];
desvio = [norm_vec(2,1:10)' norm_vec(2,11:20)'];
plot(media,desvio,'.','markersize',20);
title(['J1 = ', num2str(J1(1),'%.4f'), '   J2 = ', num2str(J2(1),'%.4f'),'   J3 = ', num2str(J3(1),'%.4f')]);
xlabel('Media');
ylabel('Desvio');


%%  8) DESAFIO

load('Semana4_exercicio8.mat');

%   NORMALIZAÇÃO
for i=1:20
    norm_vec(:,i) = [classe1(:,i);classe2(:,i)];
    norm_vec(:,i) = semana4_normalizacao(norm_vec(:,i));
end

%   ORGANIZANDO VETORES PARA INPUT NA FUNÇÃO DE SELEÇÃO VETORIAL
norm_vec = norm_vec';
classes{1} = norm_vec(:,1:25);
classes{2} = norm_vec(:,26:50);
    
%   SELEÇÃO VETORIAL
[ordem,maxcriterio,J1,J2,J3,combinacoes]= semana4_SelecaoVetorial('floating','J3',classes,3);
    
%   RESULTADO DA SV COM MÉTODO EXAUSTIVO: CARACTERÍSTICAS 1,2,11
f1 = [norm_vec(1,1:25)' norm_vec(1,26:50)'];
f2 = [norm_vec(2,1:25)' norm_vec(2,26:50)'];
f3 = [norm_vec(11,1:25)' norm_vec(11,26:50)'];
plot3(f1,f2,f3,'.','markersize',20);
title(['J1 = ', num2str(J1(1),'%.4f'), '   J2 = ', num2str(J2(1),'%.4f'),'   J3 = ', num2str(J3(1),'%.4f')]);
xlabel('Característica 1');
ylabel('Característica 2');
zlabel('Característica 11');
