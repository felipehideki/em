% % SEMANA 06

%% 1) CLASSIFICANDO GAUSSIANAS

us = [1;1];             % μ saudável
up = [3;3];             % μ patológico
sigma = [1 0; 0 1];     % matriz de covariância (igual para as S e P)
x = [1.8;1.8];          % padrão
L = 2;                  % espaço bi-dimensional

% Os padrões observam normalidade, então P(x|ωi) pode ser calculado:

% P(x|ωs)
p_ws = (1/sqrt(((2*pi)^L)*det(sigma))) * exp(-0.5*(x-us)'*inv(sigma)*(x-us));

% P(x|ωp)
p_wp = (1/sqrt(((2*pi)^L)*det(sigma))) * exp(-0.5*(x-up)'*inv(sigma)*(x-up));

% Como o prior P(ws) = P(wp), então: 
% P(ws|x) = P(x|ws)*P(ws)/P(x) = P(x|ws)*C1
% P(wp|x) = P(x|wp)*P(wp)/P(x) = P(x|wp)*C2
% tal que C1 = C2.

% 1 A) razão ωs/ωp
ratio_wswp = p_ws/p_wp;

% 1 B) razão ωs/ωp para P(ωs) = 1/6
ratio_wswp = (1/6)*p_ws/p_wp;
