% % SEMANA 03

function [media,variancia,mobilidade,complex_estatistica,freq_central,largura_banda,...
    freq_margem,assimetria,curtose,entropia,inclinacao,crista,reducao] = PRINCIPAIS_CARACTERISTICAS(SINAL,FREQ_AMOSTRAGEM)
  
    qtd_trechos = size(SINAL,1);
    tamanho_sinal = size(SINAL,2);
    fshift = (-tamanho_sinal/2:tamanho_sinal/2-1)*(FREQ_AMOSTRAGEM/tamanho_sinal);

    media = zeros(qtd_trechos,1);
    variancia = zeros(qtd_trechos,1);
    mobilidade = zeros(qtd_trechos,1);
    complex_estatistica = zeros(qtd_trechos,1);
    freq_central = zeros(qtd_trechos,1);
    largura_banda = zeros(qtd_trechos,1);
    freq_margem = zeros(qtd_trechos,1);
    assimetria = zeros(qtd_trechos,1);
    curtose = zeros(qtd_trechos,1);
    entropia = zeros(qtd_trechos,1);
%     achatamento = zeros(qtd_trechos,1);
    inclinacao = zeros(qtd_trechos,1);
    crista = zeros(qtd_trechos,1);
    reducao = zeros(qtd_trechos,1);

    for (trecho=1:qtd_trechos)
        %%  MÉDIA
        media(trecho) = mean(SINAL(trecho,:));

        %%  VARIÂNCIA
        variancia(trecho) = var(SINAL(trecho,:));

        %%  MOBILIDADE ESTATÍSTICA
        media_dif1 = 0;
        var_dif1 = 0;
        for i=1:tamanho_sinal-1
          dif1(trecho,i) = SINAL(trecho,i+1)-SINAL(trecho,i);
          media_dif1 = media_dif1 + dif1(trecho,i)/(tamanho_sinal-1);
          var_dif1 = var_dif1 + ((dif1(trecho,i)-media_dif1)^2)/(tamanho_sinal-2);
        end
        mobilidade(trecho) = var_dif1/variancia(trecho);

        %%  COMPLEXIDADE ESTATÍSTICA
        media_dif2 = 0;
        var_dif2 = 0;
        for i=1:tamanho_sinal-2
          dif2 = (SINAL(trecho,i+2)-SINAL(trecho,i+1))-(SINAL(trecho,i+1)-SINAL(trecho,i));
          media_dif2 = media_dif2 + dif2/(tamanho_sinal-2);
          var_dif2 = var_dif2 + ((dif2-media_dif2)^2)/(tamanho_sinal-3);
        end
        complex_estatistica(trecho) = sqrt((var_dif2/var_dif1)-(var_dif1/variancia(trecho)));

        sigfft_shifted = fftshift(fft(SINAL(trecho,:)));
        potencia(trecho,:) = (abs(sigfft_shifted).^2)/tamanho_sinal;
        soma_pot = sum(potencia(trecho,1:floor(1+tamanho_sinal/2)));
        %     plot(fshift,potencia);
        %     xlim([0 FREQ_AMOSTRAGEM/2]);
        ILB_prov = 0;
        fw = 0;
        denominador = 0;
        uf = -mean(fshift(1:floor(tamanho_sinal/2)));
        us = mean(potencia(trecho,1:floor(tamanho_sinal/2)));
        %     delta1 = 0;delta2 = 0;teta1 = 0;teta2 = 0;alfa = 0;beta = 0;gama = 0;
        for i=1:floor(tamanho_sinal/2)
            %% FREQUÊNCIA CENTRAL
            freq_central(trecho) = freq_central(trecho) + (fshift(i)*(-1)*potencia(trecho,i)/soma_pot);  %fshift*(-1) pois comeÃ§a da parte negativa do deslocamento
            
            %%	LARGURA DE BANDA
            ILB_prov = ILB_prov + (((fshift(i)*(-1))-freq_central(trecho))^2)*potencia(trecho,i);  %fshift*(-1) pois comeÃ§a da parte negativa do deslocamento

            %% FREQUÊNCIA DE MARGEM
            if fw<0.9
                fw = fw + potencia(trecho,floor(tamanho_sinal/2)+1-i)/soma_pot;
                freq_margem(trecho) = fshift(floor(tamanho_sinal/2)+1-i)*(-1);
            end
            
        %       %%  POTÊNCIA ESPECTRAL NORMALIZADA EM BANDAS  
        %       %  d1(0.5~2.5Hz), d2(2.5~4 Hz), t1(4~6Hz), t2(6~8Hz), a(8~12Hz), b(12~20 Hz) e g(20~45Hz)
        %       if ((fshift(i)*(-1))>20 && (fshift(i)*(-1))<45)
        %         gama = gama + potencia(trecho,i);
        %       end
        %       if ((fshift(i)*(-1))>12 && (fshift(i)*(-1))<20)
        %         beta = beta + potencia(trecho,i);
        %       end
        %       if ((fshift(i)*(-1))>8 && (fshift(i)*(-1))<12)
        %         alfa = alfa + potencia(trecho,i);
        %       end
        %       if ((fshift(i)*(-1))>6 && (fshift(i)*(-1))<8)
        %         teta2 = teta2 + potencia(trecho,i);
        %       end
        %       if ((fshift(i)*(-1))>4 && (fshift(i)*(-1))<6)
        %         teta1 = teta1 + potencia(trecho,i);
        %       end
        %       if ((fshift(i)*(-1))>2.5 && (fshift(i)*(-1))<4)
        %         delta2 = delta2 + potencia(trecho,i);
        %       end
        %       if ((fshift(i)*(-1))>0.5 && (fshift(i)*(-1))<2.5)
        %         delta1 = delta1 + potencia(trecho,i);
        %       end
        
            %%  ASSIMETRIA (SKEWNESS)
            assimetria(trecho) = assimetria(trecho) + (((fshift(i)*(-1))-freq_central(trecho))^3)*potencia(trecho,i);

            %%  CURTOSE
            curtose(trecho) = curtose(trecho) + (((fshift(i)*(-1))-freq_central(trecho))^4)*potencia(trecho,i);

            %%  ENTROPIA
            entropia(trecho) = entropia(trecho) - (potencia(trecho,i)*log(potencia(trecho,i)));
        
%             %%  ACHATAMENTO (FLATNESS)
%             achatamento(trecho) = achatamento(trecho)*(potencia(trecho,i)^(1/(tamanho_sinal/2)));

            %%  INCLINAÇÃO (SLOPE)
            inclinacao(trecho) = inclinacao(trecho) + ((fshift(i)*(-1))-uf)*(potencia(trecho,i)-us);
            denominador = denominador + ((fshift(i)*(-1))-uf)^2;
        end
%         pot_espect_norm(trecho,1) = delta1/soma_pot;
%         pot_espect_norm(trecho,2) = delta2/soma_pot;
%         pot_espect_norm(trecho,3) = teta1/soma_pot;
%         pot_espect_norm(trecho,4) = teta2/soma_pot;
%         pot_espect_norm(trecho,5) = alfa/soma_pot;
%         pot_espect_norm(trecho,6) = beta/soma_pot;
%         pot_espect_norm(trecho,7) = gama/soma_pot;
        largura_banda(trecho) = sqrt(ILB_prov/soma_pot);
        assimetria(trecho) = assimetria(trecho)/((largura_banda(trecho)^3)*soma_pot);
        curtose(trecho) = curtose(trecho)/((largura_banda(trecho)^4)*soma_pot);
        entropia(trecho) = entropia(trecho)/log(tamanho_sinal/2);
%         achatamento(trecho) = achatamento(trecho)/((1/(tamanho_sinal/2))*soma_pot);
        inclinacao(trecho) = inclinacao(trecho)/denominador;
        
        %%  CRISTA (CREST)
        crista(trecho) = max(potencia(trecho,:))/((1/(tamanho_sinal/2))*soma_pot);
        
        %%  REDUÇÃO (DECREASE)
        denominador = 0;
        for i=floor(tamanho_sinal/2)+2:tamanho_sinal
            reducao(trecho) = reducao(trecho) + (potencia(trecho,i)-potencia(trecho,i-1))/(i-1);
            denominador = denominador + potencia(trecho,i);
        end
        reducao(trecho) = reducao(trecho)/denominador;
    end
end