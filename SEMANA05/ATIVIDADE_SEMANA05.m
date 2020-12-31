% % SEMANA 05

%% 1) PCA: TRANSFORMADA DE KARHUNEN-LOÈVE

% [autovalores, matrizLL, matrizmN, erro] = KARLOEVE(matrizLN,m);


%% 2) TESTANDO PCA a)

% load('semana5_dadossimulados1.mat');
m = [-6 6 6; 6 6 6]';
s = zeros(3,3,2);
s(:,:,1) = [0.3 1 1; 1 9 1; 1 1 9];
s(:,:,2) = s(:,:,1);
[dados, classes] = semana5_gerandodadosgaussianos(m,s,400);

% PCA (2 DIMENSÕES)
[~, ~, matrizmN, erro] = KARLOEVE(dados,2);
    % RESULTADO: ERRO = 0.1677
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);

% PCA (1 DIMENSÃO)
[~, ~, matrizmN, erro] = KARLOEVE(dados,1);
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
[~, ~, matrizmN, erro] = KARLOEVE(dados,2);
    % RESULTADO: ERRO = 0.1663
plot(matrizmN(1,:),matrizmN(2,:),'.','markersize',20);

% PCA (1 DIMENSÃO)
[~, ~, matrizmN, erro] = KARLOEVE(dados,1);
    % RESULTADO: ERRO = 0.5575
plot(matrizmN,'.','markersize',20);
