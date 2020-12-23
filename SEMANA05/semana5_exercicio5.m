clc
clear all

%% Exemplo ICA: AUDIO DEMIXING

%Vamos carregar cinco fontes sonoras distintas:
s1=audioread('semana5_exercicio5_beet.wav',[1 191000]);
s2=audioread('semana5_exercicio5_beet9.wav',[1 191000]);
s3=audioread('semana5_exercicio5_street.wav',[1 191000]);
s4=audioread('semana5_exercicio5_beet92.wav',[1 191000]);
s5=audioread('semana5_exercicio5_mike.wav',[1 191000]);
fontes=[s1,s2,s3 s4 s5]';
clear s1 s2 s3 s4 s5

%Voce pode ouvir essas fontes. Por exemplo, a primeira
%delas (levante o volume!):
sound(fontes(1,:));
%Ou a terceira:
sound(fontes(3,:));

%Agora vamos misturar essas cinco fontes como se elas fossem detectadas por 
% 5 microfones:
rand('seed',0); %para reprodutibilidade
out = ones( 5, 5) + diag(0.5 * rand( 5, 1)); %matriz de mistura
mic=out*fontes; %sons registrados nos microfones

%Este eh o registro de um dos microfones
sound(mic(3,:))

figure('color','w');
for i=1:1:5
subplot(5,3,3*i-2)
plot(fontes(i,:))
set(gca,'YTick',[])
title(['Wav ',num2str(i)])
subplot(5,3,3*i-1)
plot(mic(i,:))
set(gca,'YTick',[])
title(['Mic ',num2str(i)])
end

%Decompondo em componentes independentes com o algoritmo fastICA:
[ica, A, W]=semana5_exercicio5_fastica(mic);
ica=ica/10; %controlar o volume

%Eis as componentes independentes detectadas pelo algoritmo:
for i=1:1:5
    subplot(5,3,3*i)
    plot(ica(i,:))
    set(gca,'YTick',[])
    title(['Componente ',num2str(i)])
end

%E aqui os sons apos ICA:
sound(ica(1,:))
sound(ica(2,:))
sound(ica(3,:))
sound(ica(4,:))
sound(ica(5,:))




