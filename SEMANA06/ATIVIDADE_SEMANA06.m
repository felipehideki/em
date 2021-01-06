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
