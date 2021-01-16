% % SEMANA 07

%% 1) PERCEPTRON

% [wp,i] = POCKET(xClasse1,xClasse2,max_iteracoes,rho);


%% 2) TESTANDO O PERCEPTRON

load('semana7.mat');

% Classe1 x Classe2a, rho = 0.05
POCKET(Classe1',Classe2a',10000,0.05);
figure;
% Classe1 x Classe2a, rho = 0.01
POCKET(Classe1',Classe2a',10000,0.01);
figure;

% Classe1 x Classe2b, rho = 0.05
POCKET(Classe1',Classe2b',10000,0.05);
figure;
% Classe1 x Classe2b, rho = 0.01
POCKET(Classe1',Classe2b',10000,0.01);
figure;

% Classe1 x Classe2c, rho = 0.05
POCKET(Classe1',Classe2c',10000,0.05);
figure;
% Classe1 x Classe2c, rho = 0.01
POCKET(Classe1',Classe2c',10000,0.01);
figure;

% Classe1 x Classe2d, rho = 0.05
POCKET(Classe1',Classe2d',10000,0.05);
figure;
% Classe1 x Classe2d, rho = 0.01
POCKET(Classe1',Classe2d',10000,0.01);
