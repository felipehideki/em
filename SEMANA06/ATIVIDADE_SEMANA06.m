% % SEMANA 06

%% 1) CLASSIFICANDO GAUSSIANAS

us = [1;1];             % u saudável
up = [3;3];             % u patológico
sigma = [1 0; 0 1];     % matriz de covariância (igual para as S e P)
x = [1.8;1.8];          % padrão
L = 2;                  % espaço bi-dimensional

% Os padrões observam normalidade, então P(x|wi) pode ser calculado:

% P(x|ws)
p_ws = (1/sqrt(((2*pi)^L)*det(sigma))) * exp(-0.5*(x-us)'*inv(sigma)*(x-us));

% P(x|wp)
p_wp = (1/sqrt(((2*pi)^L)*det(sigma))) * exp(-0.5*(x-up)'*inv(sigma)*(x-up));

% Como o prior P(ws) = P(wp), então: 
% P(ws|x) = P(x|ws)*P(ws)/P(x) = P(x|ws)*C1
% P(wp|x) = P(x|wp)*P(wp)/P(x) = P(x|wp)*C2
% tal que C1 = C2.

% 1 A) razão P(ws|x)/P(wp|x)
ratio_wswp = p_ws/p_wp;

% 1 B) razão P(ws|x)/P(wp|x) para P(ws) = 1/6
ratio_wswp = (1/6)*p_ws/p_wp;


%% 2) CLASSIFICADOR BAYESIANO

% [probabilidades, classificacao] = CBAYES(u,sigma,prior,x);


%% 3) CLASSIFICADOR DE DISTÂNCIA MÍNIMA DE MAHALANOBIS

% [distanciaEuclidiana, distanciaMahalanobis, classificacaoEuclidiana,classificacaoMahalanobis] = CMAHALANOBIS(u,sigma,prior,x);


%% 4) TESTANDO CLASSIFICADORES

sigma{1} = [0.8 0.01 0.01; 0.01 0.2 0.01; 0.01 0.01 0.2];
sigma{2} = sigma{1};
u{1} = [0;0;0];
u{2} = [0.5;0.5;0.5];
x = [0.1;0.5;0.1];
prior = [0.5 0.5];

% a)
medias = [u{1} u{2}];
covariancias = sigma{1};
covariancias(:,:,2) = sigma{1};
[dadossim,classessim] = semana5_gerandodadosgaussianos(medias,covariancias,600,prior,'true');
hold on;
plot3(x(1),x(2),x(3),'*','color','k','markersize',20);

% b)
[~, classificacao] = CBAYES(u,sigma,prior,x);

% c) d)
[~,~, classificacaoEuclidiana,classificacaoMahalanobis] = CMAHALANOBIS(u,sigma{1},prior,x);


%% 5) MAXIMUM LIKELIHOOD PARAMETER ESTIMATION

% a) b)
m = [-2;2];
c = [0.9 0.2;0.2 0.3];
dados = semana5_gerandodadosgaussianos(m,c,50,1,0);
[mediab,covarianciab] = MAXLIKE(dados);

% c)
dados = semana5_gerandodadosgaussianos(m,c,500,1,0);
[mediac,covarianciac] = MAXLIKE(dados);

% d)
dados = semana5_gerandodadosgaussianos(m,c,2000,1,0);
[mediad,covarianciad] = MAXLIKE(dados);


%% 6) REDES BAYESIANAS

PST = 0.4; % P(S=1)
PSF = 0.6; % P(S=0)

PHTST = 0.4; % P(H=1|S=1)
PHTSF = 0.15; % P(H=1|S=0)
PHFST = 0.6; % P(H=0|S=1)    
PHFSF = 0.85; % P(H=0|S=0)

PH1THT = 0.95; % P(H1=1|H=1)
PH1THF = 0.01; % P(H1=1|H=0)
PH1FHT = 0.05; % P(H1=0|H=1)
PH1FHF = 0.99; % P(H1=0|H=0)

PH2THT = 0.98; % P(H2=1|H=1)
PH2THF = 0.05; % P(H2=1|H=0)
PH2FHT = 0.02; % P(H2=0|H=1)
PH2FHF = 0.95; % P(H2=0|H=0)

PCTST = 0.2; % P(C=1|S=1)
PCTSF = 0.11; % P(C=1|S=0)
PCFST = 0.8; % P(C=0|S=1)
PCFSF = 0.89; % P(C=0|S=0)

PC1TCT = 0.99; % P(C1=1|C=1)
PC1TCF = 0.1; % P(C1=1|C=0)
PC1FCT = 0.01; % P(C1=0|C=1)
PC1FCF = 0.9; % P(C1=0|C=0)

PC2TCT = 0.98; % P(C2=1|C=1)
PC2TCF = 0.05; % P(C2=1|C=0)
PC2FCT = 0.02; % P(C2=0|C=1)
PC2FCF = 0.95; % P(C2=0|C=0)
 
% a1) P(C=1) = P(C=1|S=1)P(S=1) + P(C=1|S=0)P(S=0)
PCT = PCTST*PST + PCTSF*PSF;
% a2) P(H=1) = P(H=1|S=1)P(S=1) + P(H=1|S=0)P(S=0)
PHT = PHTST*PST + PHTSF*PSF;

% b)
% P(H=0) = 1-P(H=1)
PHF = 1-PHT; 
% P(H1=1) = P(H1=1|H=1)P(H=1) + P(H1=1|H=0)P(H=0)
PH1T = PH1THT*PHT + PH1THF*PHF; 
% P(H=1|H1=1) = P(H1=1|H=1)P(H=1)/P(H1=1)
PHTH1T = PH1THT*PHT/PH1T;

% c) P(C=1|H1=1) = P(H1=1|C=1)*P(C=1)/P(H1=1)
