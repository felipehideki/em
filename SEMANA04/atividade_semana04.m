% % SEMANA 04

%% 1) REMOÇÃO DE OUTLIERS

load('Semana4_exercicio1.mat');
semana4_remocaooutliers(sinal);
semana4_remocaooutliers2(sinal);


%% 2) NORMALIZAÇÃO

load('Semana4_exercicio2.mat');
figure 1;
plot(med,ske,'.','markersize',25);

med_norm_linear = [med(:,1);med(:,2)];
med_norm_linear = semana4_normalizacao(med_norm_linear);
med_norm_linear = [med_norm_linear(1:5) med_norm_linear(6:10)];
ske_norm_linear = [ske(:,1);ske(:,2)];
ske_norm_linear = semana4_normalizacao(ske_norm_linear);
ske_norm_linear = [ske_norm_linear(1:5) ske_norm_linear(6:10)];
figure 2;
plot(med_norm_linear,ske_norm_linear,'.','markersize',25);


%% 3) TESTES ESTATÍSTICOS

load('Semana4_exercicio2.mat');
classe1 = [med(:,1)';ske(:,1)'];
classe2 = [med(:,2)';ske(:,2)'];
semana4_testeestatistico(classe1,classe2);


%% 4) CARACTERÍSTICA DE OPERAÇÃO DO RECEPTOR (ROC)

load('Semana4_exercicio2.mat');
vmed = [med(:,1);med(:,2)];         % vetor de dados característica med
vske = [ske(:,1);ske(:,2)];         % vetor de dados característica ske
y = (1:10)'>5;                      % classe1 = 0, classe2 = 1
reg_logmed = glmfit(vmed,y,'binomial');   % regressão logística para med
reg_logske = glmfit(vske,y,'binomial');   % regressão logística para ske
pmed = glmval(reg_logmed,vmed,'logit');      % p para classificação med
pske = glmval(reg_logske,vske,'logit');      % p para classificação ske

[Xmed,Ymed,~,AUCmed] = perfcurve(y,pmed,'true');
[Xske,Yske,~,AUCske] = perfcurve(y,pske,'true');

figure(1);
plot(0:1,0:1,'black');
hold on;
plot(Xmed,Ymed);
xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
title(['AUC = ', num2str(AUCmed,'%.3f')]);

figure(2);
plot(0:1,0:1,'black');
hold on;
plot(Xske,Yske);
xlabel('%FP(\alpha)'); ylabel('%VP(1-\beta)');
title(['AUC = ', num2str(AUCske,'%.3f')]);


