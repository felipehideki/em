function [ordem,maxcriterio,J1,J2,J3,combinacoes]= semana4_SelecaoVetorial(metodo,criterio,classes,n)
% Seleciona caracteristicas baseando-se nas Matrizes de Espalhamento (selecao
% vetorial)
% INPUT:
%   - classes = celula {1 x numero de classes}
%   - classes{c}= matriz L x N (caracteristicas x padroes) para a classe c
%   - metodo='forward','exaustivo' ou 'floating'
%   - criterio= 'J1','J2','J3' (de acordo com Theodoridis)
%   - n = numero de caracteristicas para selecionar
% OUTPUT:
%  - maxcriterio=valor do criterio para a selecao
%  - ordem = ordem das caracteristicas de acordo com o criterio escolhido
%  - J1, J2, J3=criterios de selecao de caracteristicas baseados nas matrizes
%    de espalhamento. Sao vetores correspondentes a combinacoes de n 
%    caracteristicas
%  - combinacoes = diferentes combinacoes de caracteristicas que
%    correspondem aos criterios J1, J2 e J3

%% AGC (atualizado semestre 2/2020)

    %% TESTE DOS INPUTS:
    L=size(classes{1},1);
    C=length(classes);
    for i=2:1:C;
        if size(classes{i},1)~=L
            error('Todas classes devem ter o mesmo numero de caracteristicas');
        end
    end
    if round(n)~=n
        error('n deve ser inteiro e positivo');
    else
        if n==1
            error('Use uma selecao escalar para n =1');
        elseif n<0
            error('n deve ser inteiro e positivo');
        elseif n>=L
            error('n deve ser menor que o numero de caracteristicas');
        end
    end
   

    
    
    switch metodo
        case 'exaustivo'
            [ordem,maxcriterio,J1,J2,J3,combinacoes]= exaustsel(classes,n,criterio);

        case 'forward'
             [ordem,maxcriterio,J1,J2,J3,combinacoes]= forwardsel(classes,n,criterio);

        case 'floating'
             [ordem,maxcriterio,J1,J2,J3,combinacoes]=floatingsel(classes,n,criterio);
    end
end

function [J1,J2,J3,combinacoes]= aula18_Scatter(classes,n)
%Calcula os criterios de selecao das matrizes de espalhamento para
%combinacoes de n caracteristicas
%INPUTS:
%  - classes= celula{1 x Numero de classes}, onde 
%    classes{c}=matriz L x N (caracteristicas x padroes) para a classe c.
%  - n = numero de caracteristicas para selecionar
%OUTPUTS:
%  - J1, J2, J3=criterios de selecao de caracteristicas baseados nas matrizes
%    de espalhamento. Sao vetores correspondentes a combinacoes de n 
%    caracteristicas
%  - combinacoes = diferentes combinacoes de caracteristicas que
%    correspondem aos criterios J1, J2 e J3

    if nargin==1 %nao especificou n, faz com todas as caracteristicas
        n=size(classes{1},1); %numero de caracteristicas para considerar
    end

    N=0;
    Probs=zeros(1,length(classes)); %probabilidades de cada classe
    for i=1:1:length(classes)
        if i>1
            if ~isequal(size(classes{i},1),size(classes{i-1},1))
                error('Classes devem ter o mesmo numero de caracteristicas!')
            end
        end
        N=N+size(classes{i},2);
        Probs(1,i)=size(classes{i},2);
    end
    Probs=Probs./N;


    combinacoes=nchoosek(1:1:size(classes{1},1),n); %combinacoes de caracteristicas
    J1=zeros(1,size(combinacoes,1));
    J2=zeros(1,size(combinacoes,1));
    J3=zeros(1,size(combinacoes,1));
    for j=1:1:size(combinacoes,1)  
        caracts=combinacoes(j,:);
        Sw=zeros(n,n); %scatter matrice within classes
        allclasses=[];
        for i=1:1:length(classes)
            varwithin=cov(classes{i}(caracts,:)',1);    
            allclasses=[allclasses;classes{i}(caracts,:)'];
            Sw=Sw+Probs(i).*varwithin;   
        end
        Sm=cov(allclasses,1); %scatter matrice mixed

        J1(j)=trace(Sm)/trace(Sw);
        if cond(Sw)<1000000 %matriz singular
            J2(j)=det(Sm)/det(Sw);
            J3(j)=trace(inv(Sw)*(Sm))/size(Sw,1);
        else
            combinacoes(j,:)
            J2(j)=NaN;
            J3(j)=NaN;
            disp('Atençao: Sw perto de ser singular');
        end
    end
end   










function classes_sub=construirclasses(classes,caracteristicas)
         classes_sub=cell(1,length(classes));
         for c=1:1:length(classes)
             classes_sub{c}=classes{c}(caracteristicas,:);
         end
            
end

        
function [caractsel,valor,J1,J2,J3,combinacoes]=exaustsel(classes,n,criterio)
    [J1,J2,J3,combinacoes]= aula18_Scatter(classes,n);
     eval(['caractsel=combinacoes(find(',criterio,'==max(',criterio,')),:);']);
     eval(['valor=max(',criterio,');']);
end

        

function [caractsel,custo,J1,J2,J3,combinacoes]=forwardsel(classes,n,criterio)    
     caractsel=[];
     remaining=1:1:size(classes{1},1);    
     [J1,J2,J3,combinacoes]= aula18_Scatter(classes,1);
     eval(['caractsel=combinacoes(find(',criterio,'==max(',criterio,')),:);']);
     eval(['custo=max(',criterio,');'])
     remaining(caractsel)=[];
     for j=2:n
         valor=-Inf;
         escolhida=0;
         for k=1:1:length(remaining)
             testaressas=[caractsel,remaining(k)];
             [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,testaressas),numel(testaressas));
             eval(['teste=',criterio,';'])
             if teste>valor
                 eval(['valor=',criterio,';']);
                 escolhida=k;
             end
         end
         caractsel(end+1)=remaining(escolhida);
         remaining(escolhida)=[];
         custo=valor;
     end

end




function [caractsel,valor,J1,J2,J3,combinacoes]=floatingsel(classes,n,criterio)    
     
    %INICIALIZACAO
    k=2;
    m=size(classes{1},1);
    [X{2},C{2}]=forwardsel(classes,2,criterio);
    
    while k<=n
        %STEP 1:        
        custo=[];
        Y{m-k}=setdiff(1:m,X{k});
        for i=1:length(Y{m-k})
            testaressas=[X{k} Y{m-k}(i)];
            [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,testaressas),numel(testaressas));
            eval(['custo=[custo ',criterio,'];']);
        end
        [maxcusto,ind]=max(custo);
        X{k+1}=[X{k} Y{m-k}(ind)]; %adiciona a caracteristica que maximiza o custo      
        
        %STEP 2:
        custo=[];
        for i=1:length(X{k+1})
            testaressas=setdiff(X{k+1}, X{k+1}(i));
            [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,testaressas),numel(testaressas));
            eval(['custo=[custo ',criterio,'];']);
        end
        [maxcusto,r]=max(custo);
        xr=X{k+1}(r); %caracteristica menos relevante     
        if r==k+1 %eh a caracteristica que foi adicionada: continua sem remove-la
            [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,X{k+1}),numel(X{k+1}));
             eval(['C{k+1}=',criterio,';']);
            k=k+1;
            continue;
        end
        if r~=k+1 &  maxcusto< C{k} %eh uma caracteristica anterior mas a remocao dela nao aumenta o custo
            continue;
        end
        if k==2 %nesse caso, r=1 ou 2 e maxcusto>C{k}: troca X{k} pelo par melhor e comeca de novo (se esta aqui pq no algoritmo de Theodoridis a inicializacao com forward nao eh otimizada como a minha, no meu caso isso nunca acontece)
            X{k}=setdiff(X{k+1},xr);
            C{k}=maxcusto;
            continue;
        end
        
         
        %STEP 3: so vem nesse passo se r~=k+1 e maxcusto>=C{k}: vale a pena
        %remover
        go=1;
        while go
            Xlinha{k}=setdiff(X{k+1},xr); %remove xr, Xlinha eh o novo conjunto
            custo=[];
            for i=1:length(Xlinha{k})
                 testaressas=setdiff(Xlinha{k}, Xlinha{k}(i));
                 [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,testaressas),numel(testaressas));
                  eval(['custo=[custo ',criterio,'];']);
            end
            [maxcusto,s]=max(custo);
            xs=Xlinha{k}(s); %caracteristica menos relevante no novo conjunto
            if maxcusto<C{k-1} %remocao de xs baixa o custo, entao fica com o Xlinha 
                X{k}=Xlinha{k};
                [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,X{k}),numel(X{k}));
                eval(['C{k}=',criterio,';']); 
                go=0;
                break;
            end
            %se esta aqui a remocao de xs aumenta o custo
            Xlinha{k-1}=setdiff(Xlinha{k},xs); %remove xs e da um passo para tras
            k=k-1;
            if k==2
                X{k}=Xlinha{k};
                [J1,J2,J3,combinacoes]= aula18_Scatter(construirclasses(classes,X{k}),numel(X{k}));
                eval(['C{k}=',criterio,';']);                 
                go=0;
            end
        end
        if go==0
            continue;
        end
    end
    if k>n
        caractsel=X{k-1};
        valor=C{k-1};
    else
        caractsel=X{k-1};
        valor=C{k-1};
    end


end





