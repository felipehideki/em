% % SEMANA 03

function [media,variancia,mobilidade,complex_estatistica,freq_central,largura_banda,freq_margem,pot_espect_norm] = PRINCIPAIS_CARACTERISTICAS(SINAL,FREQ_AMOSTRAGEM)
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
  
  for (trecho=1:qtd_trechos)
    % %  MÉDIA
    media(trecho) = mean(SINAL(trecho,:));
    
    % %  VARIÂNCIA
    variancia(trecho) = var(SINAL(trecho,:));
    
    % %  MOBILIDADE ESTATÍSTICA
    media_dif1 = 0;
    var_dif1 = 0;
    for (i=1:tamanho_sinal-1)
      dif1(trecho,i) = SINAL(trecho,i+1)-SINAL(trecho,i);
      media_dif1 = media_dif1 + dif1(trecho,i)/(tamanho_sinal-1);
      var_dif1 = var_dif1 + ((dif1(trecho,i)-media_dif1)^2)/(tamanho_sinal-2);
    end
    mobilidade(trecho) = var_dif1/variancia(trecho);
      
    % %  COMPLEXIDADE ESTATÍSTICA
    media_dif2 = 0;
    var_dif2 = 0;
    for (i=1:tamanho_sinal-2)
      dif2 = (SINAL(trecho,i+2)-SINAL(trecho,i+1))-(SINAL(trecho,i+1)-SINAL(trecho,i));
      media_dif2 = media_dif2 + dif2/(tamanho_sinal-2);
      var_dif2 = var_dif2 + ((dif2-media_dif2)^2)/(tamanho_sinal-3);
    end
    complex_estatistica(trecho) = sqrt((var_dif2/var_dif1)-(var_dif1/variancia(trecho)));

    % % FREQUÊNCIA CENTRAL
    sigfft_shifted = fftshift(fft(SINAL(trecho,:)));
    potencia(trecho,:) = (abs(sigfft_shifted).^2)/tamanho_sinal;
    soma_pot = sum(potencia(trecho,1:floor(1+tamanho_sinal/2)));
    %plot(fshift,potencia);
    %xlim([0 FREQ_AMOSTRAGEM/2]);
    freq_central(trecho) = 0;
    for (i=1:tamanho_sinal/2)
      freq_central(trecho) = freq_central(trecho) + (fshift(i)*(-1)*potencia(trecho,i)/soma_pot);  %fshift*(-1) pois comeÃ§a da parte negativa do deslocamento
    end
    
    % %  LARGURA DE BANDA
    ILB_prov = 0;
    fw = 0;
    for (i=1:tamanho_sinal/2)
      ILB_prov = ILB_prov + (((fshift(i)*(-1))-freq_central(trecho))^2)*potencia(trecho,i);  %fshift*(-1) pois comeÃ§a da parte negativa do deslocamento
      % % FREQUÊNCIA DE MARGEM
      if (fw<0.9)
        fw = fw + potencia(trecho,floor(tamanho_sinal/2)+1-i)/soma_pot;
        freq_margem(trecho) = fshift(floor(tamanho_sinal/2)+1-i)*(-1);
      end
    end
    largura_banda(trecho) = sqrt(ILB_prov/soma_pot);
  end
