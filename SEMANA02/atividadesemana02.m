%% SEMANA 02
clear all;
close all;

%% ATIVIDADE 1 a) MÉDIAS E VARIÂNCIAS
load('semana2_prob1.mat');
medialinha1 = mean(dados(1,:));
medialinha2 = mean(dados(2,:));
medialinha3 = mean(dados(3,:));
medialinha4 = mean(dados(4,:));

varlinha1 = var(dados(1,:));
varlinha2 = var(dados(2,:));
varlinha3 = var(dados(3,:));
varlinha4 = var(dados(4,:));


%% ATIVIDADE 1 b) HISTOGRAMAS E TESTE DE NORMALIDADE
figure 1;
hist(dados(1,:));
figure 2;
hist(dados(2,:));
figure 3;
hist(dados(3,:));
figure 4;
hist(dados(4,:));

varall = [varlinha1 varlinha2 varlinha3 varlinha4];

pkg load statistics; % Carrega pacote de estatística para Octave
H1 = semana2_swtest(dados(1,:));
H2 = semana2_swtest(dados(2,:));
H3 = semana2_swtest(dados(3,:));
H4 = semana2_swtest(dados(4,:));


%% ATIVIDADE 1 c) PLOT DOS DADOS DO PACIENTE COM O CONTROLE
mCMAP = 56;
mSNAP = 52;
uCMAP = 54;
uSNAP = 61;

figure 1;
hold on;
plot([mCMAP,mCMAP],[0,max(hist(dados(1,:)))], "linewidth",3,'r');
figure 2;
hold on;
plot([mSNAP,mSNAP],[0,max(hist(dados(2,:)))], "linewidth",3,'r');
figure 3;
hold on;
plot([uCMAP,uCMAP],[0,max(hist(dados(3,:)))], "linewidth",3,'r');
figure 4;
hold on;
plot([uSNAP,uSNAP],[0,max(hist(dados(4,:)))], "linewidth",3,'r');


%% ATIVIDADE 1 d) DISTRUBUIÇÃO NORMAL CUMULADA
dnc_mCMAP = normcdf(mCMAP,medialinha1,std(dados(1,:)));
dnc_mSNAP = normcdf(mSNAP,medialinha2,std(dados(2,:)));
dnc_uCMAP = normcdf(uCMAP,medialinha3,std(dados(3,:)));
dnc_uSNAP = normcdf(uSNAP,medialinha4,std(dados(4,:)));


%% ATIVIDADE 1 e) MATRIZ DE COVARIÂNCIA E PROBABILIDADE MULTIVARIADA CUMULADA
matcov = cov(dados');
pmc = mvncdf([mCMAP mSNAP uCMAP uSNAP],[medialinha1 medialinha2 medialinha3 medialinha4],matcov);
% -------------- CORRIGIR ----------------


%% ATIVIDADE 2 a)b) SENSIBILIDADE E ESPECIFICIDADE
load('/home/ikedihbuntu/Downloads/EngenhariaMedica/semana02/semana2_prob2.mat');

totalPacientes = size(dados,1);
totalDoentes = sum(dados(:,3));
totalSaudaveis = totalPacientes-totalDoentes;
doentesPSA = doentesDRE = 0;
saudaveisPSA = saudaveisDRE = 0;
for (i=1:totalPacientes)
  %%  DOENTES DETECTADOS PELO PSA CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if (dados(i,1)==1 && dados(i,3)==1)
    doentesPSA++;
  end
  %%  DOENTES DETECTADOS PELO DRE CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if (dados(i,2)==1 && dados(i,3)==1)
    doentesDRE++;
  end
  %%  SAUDÁVEIS NÃO-DETECTADOS PELO PSA CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if (dados(i,1)==0 && dados(i,3)==0)
    saudaveisPSA++;
  end
  %%  SAUDÁVEIS NÃO-DETECTADOS PELO DRE CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if (dados(i,2)==0 && dados(i,3)==0)
    saudaveisDRE++;
  end
end

%% P(T=1|D=1)
sensPSA = doentesPSA/totalDoentes;
sensDRE = doentesDRE/totalDoentes;

%% P(T=0|D=0)
espePSA = saudaveisPSA/totalSaudaveis;
espeDRE = saudaveisDRE/totalSaudaveis;


%% ATIVIDADE 2 c) TEOREMA DE BAYES

%% P(D=1)
prior = 0.042; 

%% P(T=1) = P(T=1|D=0)*P(D=0) + P(T=1|D=1)*P(D=1)
p_PSApos = ((1-espePSA)*(1-prior)) + (sensPSA*prior);
p_DREpos = ((1-espeDRE)*(1-prior)) + (sensDRE*prior);

%% P(D=1|T=1) = P(T=1|D=1)*P(D=1) / P(T=1)
p_doente_casoPSApos = sensPSA*prior/p_PSApos;
p_doente_casoDREpos = sensDRE*prior/p_DREpos;


%% ATIVIDADE 2 d) TESTES MÚLTIPLOS

saudaveisPSAeDRE = saudaveisPSAouDRE = doentesPSAeDRE = doentesPSAouDRE = 0;
for (i=1:totalPacientes)
  %%  DOENTES DETECTADOS PELO PSA E DRE CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if (dados(i,1)+dados(i,2)+dados(i,3)==3)
    doentesPSAeDRE++;
  end
  %%  DOENTES DETECTADOS PELO PSA OU DRE CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if ((dados(i,1)+dados(i,2))~=0 && dados(i,3)==1)
    doentesPSAouDRE++;
  end
  %%  SAUDÁVEIS NÃO-DETECTADOS PELO PSA E DRE CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if (dados(i,1)==0 && dados(i,2)==0 && dados(i,3)==0)
    saudaveisPSAeDRE++;
  end
  %%  SAUDÁVEIS NÃO-DETECTADOS PELO PSA OU DRE CORRETAMENTE (COMPARANDO COM BIÓPSIA)
  if ((dados(i,1)+dados(i,2))==1 && dados(i,3)==0)
    saudaveisPSAouDRE++;
  end
end

%% P(T1eT2=1|D=1)
sensPSAeDRE = doentesPSAeDRE/totalDoentes;
%% P(T1ouT2=1|D=1)
sensPSAouDRE = doentesPSAouDRE/totalDoentes;
%% P(T=0|D=0)
espePSAeDRE = saudaveisPSAeDRE/totalSaudaveis;
%% P(T1ouT2=0|D=0)
espePSAouDRE = (saudaveisPSAeDRE+saudaveisPSAouDRE)/totalSaudaveis;

%% P(T1ouT2=1) = P(T=1|D=0)*P(D=0) + P(T1ouT2=1|D=1)*P(D=1)
p_PSAouDREpos = ((1-espePSAeDRE)*(1-prior)) + (sensPSAouDRE*prior);
%% P(D=1|T1ouT2=1) = P(T1ouT2=1|D=1)*P(D=1) / P(T1ouT2=1)
p_doente_casoPSAouDREpos = sensPSAouDRE*prior/p_PSAouDREpos;

%% P(T1eT2=1) = P(T1eT2=1|D=0)*P(D=0) + P(T1eT2=1|D=1)*P(D=1)
p_PSAeDREpos = ((1-espePSAouDRE)*(1-prior)) + (sensPSAeDRE*prior);
%% P(D=1|T1eT2=1) = P(T1eT2=1|D=1)*P(D=1) / P(T1eT2=1)
p_doente_casoPSAeDREpos = sensPSAeDRE*prior/p_PSAeDREpos;


%% ATIVIDADE 2 e) ANÁLISE PARA TESTES NEGATIVOS

%% P(T=0) = P(T=0|D=0)*P(D=0) + P(T=0|D=1)*P(D=1)
p_PSAneg = (espePSA*(1-prior)) + ((1-sensPSA)*prior);
p_DREneg = (espeDRE*(1-prior)) + ((1-sensDRE)*prior);

%% P(D=1|T=0) = P(T=0|D=1)*P(D=1) / P(T=0)
p_doente_casoPSAneg = (1-sensPSA)*prior/p_PSAneg;
p_doente_casoDREneg = (1-sensDRE)*prior/p_DREneg;

%% P(T=0) = P(T=0|D=0)*P(D=0) + P(T=0|D=1)*P(D=1)
p_PSAeDREneg = (espePSAeDRE*(1-prior)) + ((1-sensPSAouDRE)*prior);
%% P(D=1|T=0) = P(T=0|D=1)*P(D=1) / P(T=0)
p_doente_casoPSAeDREneg = (1-sensPSAouDRE)*prior/p_PSAeDREneg;
