%% SEMANA 03

function [media,variancia,mobilidade,complex_estatistica,freq_central,largura_banda,freq_margem,pot_espect_norm] = principais_c(SINAL,FREQ_AMOSTRAGEM)
  qtd_trechos = size(SINAL,1);
  tamanho_sinal = size(SINAL,2);
  fshift = (-tamanho_sinal/2:tamanho_sinal/2-1)*(FREQ_AMOSTRAGEM/tamanho_sinal);
    
  for (trecho=1:qtd_trechos)
    %%  MÉDIA
    media(trecho) = mean(SINAL(trecho,:));
    
    %%  VARIÂNCIA
    variancia(trecho) = var(SINAL(trecho,:));
    
    %%  MOBILIDADE ESTATÍSTICA
    media_dif1 = var_dif1 = 0;
    for (i=1:tamanho_sinal-1)
      dif1 = SINAL(trecho,i+1)-SINAL(trecho,i);
      media_dif1 = media_dif1 + dif1/(tamanho_sinal-1);
      var_dif1 = var_dif1 + ((dif1-media_dif1)^2)/(tamanho_sinal-2);
    endfor
    mobilidade(trecho) = var_dif1/variancia(trecho);
      
    %%  COMPLEXIDADE ESTATÍSTICA
    media_dif2 = var_dif2 = 0;
    for (i=1:tamanho_sinal-2)
      dif2 = (SINAL(trecho,i+2)-SINAL(trecho,i+1))-(SINAL(trecho,i+1)-SINAL(trecho,i));
      media_dif2 = media_dif2 + dif2/(tamanho_sinal-2);
      var_dif2 = var_dif2 + ((dif2-media_dif2)^2)/(tamanho_sinal-3);
    endfor
    complex_estatistica(trecho) = sqrt((var_dif2/var_dif1)-(var_dif1/variancia(trecho)));
    
    %%  FREQUÊNCIA CENTRAL
    sigfft_shifted = fftshift(fft(SINAL(trecho,:)));
    potencia(trecho,:) = (abs(sigfft_shifted).^2)/tamanho_sinal;
    soma_pot = sum(potencia(trecho,1:1+tamanho_sinal/2));
    %plot(fshift,potencia);
    %xlim([0 FREQ_AMOSTRAGEM/2]);
    freq_central(trecho) = 0;
    for (i=1:tamanho_sinal/2)
      freq_central(trecho) = freq_central(trecho) + (fshift(i)*(-1)*potencia(trecho,i)/soma_pot);  %fshift*(-1) pois começa da parte negativa do deslocamento
    endfor
    
    %%  LARGURA DE BANDA
    ILB_prov = 0;
    fw = 0;
    delta1 = delta2 = teta1 = teta2 = alfa = beta = gama = 0;
    for (i=1:tamanho_sinal/2)
      ILB_prov = ILB_prov + (((fshift(i)*(-1))-freq_central(trecho))^2)*potencia(trecho,i);  %fshift*(-1) pois começa da parte negativa do deslocamento
      
      %%  FREQUÊNCIA DE MARGEM
      if (fw<0.9)
        fw = fw + potencia(trecho,1501-i)/soma_pot;
        freq_margem(trecho) = fshift(1501-i)*(-1);
      endif
      
      %%  POTÊNCIA ESPECTRAL NORMALIZADA EM BANDAS  
      %  d1(0.5~2.5Hz), d2(2.5~4 Hz), t1(4~6Hz), t2(6~8Hz), a(8~12Hz), b(12~20 Hz) e g(20~45Hz)
      if ((fshift(i)*(-1))>20 && (fshift(i)*(-1))<45)
        gama = gama + potencia(trecho,i);
      endif
      if ((fshift(i)*(-1))>12 && (fshift(i)*(-1))<20)
        beta = beta + potencia(trecho,i);
      endif
      if ((fshift(i)*(-1))>8 && (fshift(i)*(-1))<12)
        alfa = alfa + potencia(trecho,i);
      endif
      if ((fshift(i)*(-1))>6 && (fshift(i)*(-1))<8)
        teta2 = teta2 + potencia(trecho,i);
      endif
      if ((fshift(i)*(-1))>4 && (fshift(i)*(-1))<6)
        teta1 = teta1 + potencia(trecho,i);
      endif
      if ((fshift(i)*(-1))>2.5 && (fshift(i)*(-1))<4)
        delta2 = delta2 + potencia(trecho,i);
      endif
      if ((fshift(i)*(-1))>0.5 && (fshift(i)*(-1))<2.5)
        delta1 = delta1 + potencia(trecho,i);
      endif
    endfor
    largura_banda(trecho) = sqrt(ILB_prov/soma_pot);
    pot_espect_norm(trecho,1) = delta1/soma_pot;
    pot_espect_norm(trecho,2) = delta2/soma_pot;
    pot_espect_norm(trecho,3) = teta1/soma_pot;
    pot_espect_norm(trecho,4) = teta2/soma_pot;
    pot_espect_norm(trecho,5) = alfa/soma_pot;
    pot_espect_norm(trecho,6) = beta/soma_pot;
    pot_espect_norm(trecho,7) = gama/soma_pot;
  end
endfunction
