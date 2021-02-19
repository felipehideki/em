% % TRABALHO FINAL DE ENGENHARIA MÉDICA 2S/2020
% % GRUPO 1: FELIPE HIDEKI HATANO & PEDRO ROCHA SANTOS

% % CLASSIFICAÇÃO DE INDIVÍDUOS SAUDÁVEIS/DOENTES DE UM BANCO DE DADOS DE
% % AUSCULTAÇÕES TORÁXICAS



% % EXTRAINDO INÍCIO E FINAL DOS CICLOS RESPIRATÓRIOS EM CADA GRAVAÇÃO
pathname = 'C:\Users\$USER$\Desktop\EngenhariaMedica\TRABALHOFINAL\Respiratory_Sound_Database\Respiratory_Sound_Database\audio_and_txt_files';

S = dir(fullfile(pathname,'*.txt'));
outtxt = cell(size(S));
w = waitbar(0,'Importando arquivos .txt');
for k = 1:numel(S)
    waitbar(k/numel(S));
    filename = S(k).name;
    filepath = fullfile(pathname,filename);
    outtxt{k} = load(filepath);
end
delete(w);
clear filename filepath k S w

S = dir(fullfile(pathname,'*.wav'));
ciclos = cell(size(S));
w = waitbar(0,'Importando arquivos .wav');
for k = 1:numel(S)
    waitbar(k/numel(S));
    filename = S(k).name;
    filepath = fullfile(pathname,filename);
    [dados,fs] = audioread(filepath);
    for i = 1:size(outtxt{k},1)
        if round(outtxt{k}(i,1)*fs)
            ciclos{k,i} = dados((floor(outtxt{k}(i,1)*fs)):(ceil(outtxt{k}(i,2)*fs)));
        else %caso o primeiro índice do ciclo seja 0
            ciclos{k,i} = dados(1:(ceil(outtxt{k}(i,2)*fs)));
        end
    end
end
delete(w);
clear dados filename filepath fs i k w outtxt

T = readtable('C:\Users\$USER$\Desktop\EngenhariaMedica\TRABALHOFINAL\Respiratory_Sound_Database\Respiratory_Sound_Database\patient_diagnosis.csv');
w = waitbar(0,'Relacionando classes');
classes = table;
for j = 1:size(S)
    waitbar(j/numel(S));
    id = S(j).name;
    for m = 1:size(T,1)
        if sum(id(1:3)==num2str(T.Var1(m)))==3
            classes.Var1(j,1) = T.Var2(m);
        end
    end
end
delete(w);
clear id j m pathname S T w
