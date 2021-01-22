% % SEMANA 05

%% 1) PCA: TRANSFORMADA DE KARHUNEN-LOÈVE

% [autovalores, matrizLL, matrizmN, erro] = KL(matrizLN,m);


%% 2) TESTANDO PCA a)

% load('semana5_dadossimulados1.mat');
m = [-6 6 6; 6 6 6]';
s = zeros(3,3,2);
s(:,:,1) = [0.3 1 1; 1 9 1; 1 1 9];
s(:,:,2) = s(:,:,1);
[dados, classes] = semana5_gerandodadosgaussianos(m,s,400);

% PCA (2 DIMENSÕES)
[~, ~, matrizmN, erro] = KL(dados,2);
    % RESULTADO: ERRO = 0.1677
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);

% PCA (1 DIMENSÃO)
[~, ~, matrizmN, erro] = KL(dados,1);
    % RESULTADO: ERRO = 0.3562
plot(matrizmN,'.','markersize',20);


%% 2) TESTANDO PCA b)
% load('semana5_dadossimulados2.mat');
m = [-2 6 6; 2 6 6]';
s = zeros(3,3,2);
s(:,:,1) = [0.3 1 1; 1 9 1; 1 1 9];
s(:,:,2) = s(:,:,1);
[dados, classes] = semana5_gerandodadosgaussianos(m,s,400);

% PCA (2 DIMENSÕES)
[~, ~, matrizmN, erro] = KL(dados,2);
    % RESULTADO: ERRO = 0.1663
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);

% PCA (1 DIMENSÃO)
[~, ~, matrizmN, erro] = KL(dados,1);
    % RESULTADO: ERRO = 0.5575
plot(matrizmN,'.','markersize',20);


%% 3) TESTANDO PCA EM DADOS REAIS: POLISSONOGRAFIA SEMANA 3+4

load('Semana3_eeg.mat');
[media,variancia,mobilidade,complex_estatistica,freq_central,largura_banda,freq_margem,pot_espect_norm] = PRINCIPAIS_CARACTERISTICAS(SINAL,100);

estagios_range{1} = find(ESTAGIOS==0); % WAKE
estagios_range{2} = find(ESTAGIOS==1); % NREM1
estagios_range{3} = find(ESTAGIOS==2); % NREM2
estagios_range{4} = find(ESTAGIOS==3); % NREM3
estagios_range{5} = find(ESTAGIOS==4); % NREM4
estagios_range{6} = find(ESTAGIOS==5); % REM

% %  OUTLIERS

% for i=1:6
%     [outliers{1,i},indexes{1,i}] = semana4_remocaooutliers(media(estagios_range{i}));
%     [outliers{2,i},indexes{2,i}] = semana4_remocaooutliers(variancia(estagios_range{i}));
%     [outliers{3,i},indexes{3,i}] = semana4_remocaooutliers(mobilidade(estagios_range{i}));
%     [outliers{4,i},indexes{4,i}] = semana4_remocaooutliers(complex_estatistica(estagios_range{i}));
%     [outliers{5,i},indexes{5,i}] = semana4_remocaooutliers(freq_central(estagios_range{i}));
%     [outliers{6,i},indexes{6,i}] = semana4_remocaooutliers(largura_banda(estagios_range{i}));
%     [outliers{7,i},indexes{7,i}] = semana4_remocaooutliers(freq_margem(estagios_range{i}));
% %     for j=1:7
% %         [outliers{8,i},indexes{8,i}] = semana4_remocaooutliers(pot_espect_norm(estagios_range{i},j));
% %     end
%     close all;
% end

% % NORMALIZAÇÃO

media_nl = semana4_normalizacao(media);
variancia_nl = semana4_normalizacao(variancia);
mobilidade_nl = semana4_normalizacao(mobilidade);
complex_estatistica_nl = semana4_normalizacao(complex_estatistica);
freq_central_nl = semana4_normalizacao(freq_central);
largura_banda_nl = semana4_normalizacao(largura_banda);
freq_margem_nl = semana4_normalizacao(freq_margem);
% delta1 = pot_espect_norm(:,1)';
% delta2 = pot_espect_norm(:,2)';
% teta1 = pot_espect_norm(:,3)';
% teta2 = pot_espect_norm(:,4)';
% alfa = pot_espect_norm(:,5)';
% beta = pot_espect_norm(:,6)';
% gama = pot_espect_norm(:,7)';

norm_vec = [media_nl;variancia_nl;mobilidade_nl;complex_estatistica_nl;freq_central_nl;largura_banda_nl;freq_margem_nl];
    %delta1;delta2;teta1;teta2;alfa;beta;gama];

% DADOS VIGÍLIA
vigilia = norm_vec(:,estagios_range{1});
% DADOS NREM4
NREM4 = norm_vec(:,estagios_range{5});
% DADOS REM
REM = norm_vec(:,estagios_range{6});
% DADOS VIGÍLIA X NREM4
vig_NREM4 = [vigilia NREM4];
% DADOS VIGÍLIA X REM
vig_REM = [vigilia REM];


% % PCA VIGÍLIA X NREM4
    % 1 DIMENSÃO
[~, ~, matrizmN, erro] = KL(vig_NREM4,1);
plot(matrizmN,'.','markersize',20);
    % 2 DIMENSÕES
[~, ~, matrizmN, erro] = KL(vig_NREM4,2);
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);

% % PCA VIGÍLIA X REM
    % 1 DIMENSÃO
[~, ~, matrizmN, erro] = KL(vig_REM,1);
plot(matrizmN,'.','markersize',20);
    % 2 DIMENSÕES
[~, ~, matrizmN, erro] = KL(vig_REM,2);
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);


%% 4) SVD vs. PCA

load('semana5_exercicio4.mat');

% SVD
tic;
[U,S,V] = svd(X);
matcov = (1/100)*S*S';
autovalores = flipud(eig(matcov));
[matrizLL,~] = eig(matcov);
matrizLL = fliplr(matrizLL);
erro_SVD = 0;

for i=1:2
    matrizAuto(i,:) = matrizLL(i,:);
	erro_SVD = erro_SVD + autovalores(i)/sum(autovalores);
end
    matrizmN = matrizAuto*X;
    erro_SVD = 1-erro_SVD;
    
time_SVD = toc;
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);


% PCA
tic;
[~,~, matrizmN, erro_PCA] = KL(X,2);
time_PCA = toc;
figure;
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);
