% % SEMANA 08

%% 1) CRITÉRIO LEAST SQUARES (LS)

% [w] = LS(xClasse1,xClasse2,alpha);


%% 2) ANÁLISE DISCRIMINANTE DE FISHER (FDA)

% [Y] = FDA(xClasse1,xClasse2,L);


%% 3) TESTANDO LS E FDA

load('semana5_dadossimulados2.mat');

% a) LS
LS(dados(:,1:200)',dados(:,201:400)',1);

% ///////// Implementado na função LS()
% c1 = plot3(xClasse1(:,1),xClasse1(:,2),xClasse1(:,3),'.b'); hold on; 
% c2 = plot3(xClasse2(:,1),xClasse2(:,2),xClasse2(:,3),'.r'); hold on;
% [x y] = meshgrid(min(y(:,1)):max(y(:,1)),min(y(:,2)):max(y(:,2)));
% z = -((w(1)*x)+(w(2)*y)+w(4))/w(3); % plano w1x+w2y+w3z+w4=0
% ls = surf(x,y,z,ones(size(x)));
% ls.EdgeColor = 'none';
% title(['\alpha = ', num2str(alpha,'%.2f')]);
% legend([c1,c2,ls], {'classe 1','classe 2','LS'});

% b) FDA

% Conjunto de dados (1) da semana 5
load('semana5_dadossimulados1.mat');

% PCA (1 DIMENSÃO)
[~, ~, matrizmN, ~] = KL(dados,1);
subplot(2,1,1);
plot(matrizmN(1:200),'.','markersize',10); 
hold on;
plot(matrizmN(201:400),'.','markersize',10);
title('PCA');

% FDA (1 DIMENSÃO)
classe{1} = dados(:,1:200);
classe{2} = dados(:,201:400);
Y = FDA(classe);
subplot(2,1,2);
plot(Y(1:200),'.','markersize',10); 
hold on;
plot(Y(201:400),'.','markersize',10);
title('FDA');

% Conjunto de dados (2) da semana 5
load('semana5_dadossimulados2.mat');

% PCA (1 DIMENSÃO)
[~, ~, matrizmN, ~] = KL(dados,1);
subplot(2,1,1);
plot(matrizmN(1:200),'.','markersize',10); 
hold on;
plot(matrizmN(201:400),'.','markersize',10);
title('PCA');

% FDA (1 DIMENSÃO)
classe{1} = dados(:,1:200);
classe{2} = dados(:,201:400);
Y = FDA(classe);
subplot(2,1,2);
plot(Y(1:200),'.','markersize',10); 
hold on;
plot(Y(201:400),'.','markersize',10);
title('FDA');


%% 4) TESTANDO FDA

load('semana8_exercicio4.mat');

% classe1
plot3(dados(1,1:100),dados(2,1:100),dados(3,1:100),'.','markersize',10); hold on;
% classe2
plot3(dados(1,101:800),dados(2,101:800),dados(3,101:800),'.','markersize',10);hold on;
% classe3
plot3(dados(1,801:900),dados(2,801:900),dados(3,801:900),'.','markersize',10);


% FDA PARA 2 CLASSES
classe{1} = dados(:,1:100);
classe{2} = dados(:,101:900);
Y = FDA(classe);
plot(Y(1:100),'.','markersize',10); 
hold on;
plot(Y(101:900),'.','markersize',10);


% FDA PARA 3 CLASSES
classe{1} = dados(:,1:100);
classe{2} = dados(:,101:800);
classe{3} = dados(:,801:900);
Y = FDA(classe);
plot(Y(1:100,1),Y(1:100,2),'.','markersize',10); 
hold on;
plot(Y(101:800,1),Y(101:800,2),'.','markersize',10);
hold on;
plot(Y(801:900,1),Y(801:900,2),'.','markersize',10);
