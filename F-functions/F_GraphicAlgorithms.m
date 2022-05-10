% Графика Обнаружителей
function F_GraphicAlgorithms(Signal,SignalF,CalcVal_G,ind_G,Threshold_G,iModel,nModels,iSNR,nSNRa,SNR,SignalM,Noise)
global f1 f2 AxTFrames AxDistance Algorithms_name Algorithms_v Prog_mode Fs
if strcmp(Prog_mode,'model')    % модели
    Titl={'Моделированный Сигнал дыхания + шум';...
         ['Model=' num2str(iModel) '/'  num2str(nModels) ', ' 'Realisation=' num2str(iSNR) '/'  num2str(nSNRa) ', ' 'SNR=' num2str(SNR)];...
          'Сигнал дыхания'};
elseif strcmp(Prog_mode,'real')  % реальные сигналы
    Titl={'Сигнал дальности';...
         ['Тип радара=' num2str(iModel) ', ' 'Файл=' num2str(nModels) '/'  num2str(iSNR) ', ' 'Дальность=' num2str(nSNRa) ' ',...
         num2str(AxDistance(nSNRa)) '[м]']};
end
Fmax=Fs/2;  % Максимальный отсчет спектра


%% Обнаружитель ЧПК
if strcmp(Alg_name,'TFD')

elseif any(strcmp(Alg_name,'Var'))

%% Обнаружитель по FFT спектру   
elseif any(strcmp(Alg_name,{'FFT' 'WTOld'}))
    
    
%% Обнаружитель по дискретным отчетам частоты декомпозиций       
elseif any(strcmp(Alg_name,{'HHT' 'WT' 'HHTst' 'HHTold' 'HHTexp'}))
    
end








% Входной сигнал
subplot(711);
    if Prog_mode==0 % модели
        plot(AxTFrames,SignalM*SNR,AxTFrames,Noise); grid on;
        title(Titl);
        xlabel('Сек');
        legend('Signal','Noise')
    elseif Prog_mode==1 % реальные сигналы
        plot(AxTFrames,Signal,AxTFrames,SignalF); grid on;
        title(Titl);
        xlabel('Сек');
        legend('Noised','Filtered Signal');
    end
    
% TFD
subplot(712)
    Pos=strcmp(Algorithms_name,'TFD');
    if Algorithms_v(1,Pos)==1
    CalcVal=CalcVal_G{Pos};
    Threshold=Threshold_G{Pos}.*ones(length(CalcVal),1);
    IdxThresh=find(CalcVal(:,1)>Threshold);
        stem(CalcVal);  % ЧПК кадры
        hold on
        plot(Threshold,'r-');   % Пороговый уровень
        plot(Threshold(IdxThresh),'g*');    % Превышение порогового уровня
        hold off
        title('TFD Algorithm'); xlabel('Кадры');
    else
    end
% FFT
subplot(713);
    Pos=strcmp(Algorithms_name,'FFT');
    if Algorithms_v(1,Pos)==1
    CalcVal=CalcVal_G{Pos};
    Threshold=Threshold_G{Pos};
    IdxThresh=find(CalcVal(:,1)>Threshold);
            plot(f2,CalcVal(:,1),f1,Threshold,'r-'); grid on;   % Пороговый уровень и спектр
            hold on
            plot(f2(IdxThresh),Threshold(IdxThresh),'g*');   % Превышение порогового уровня
            hold off
            title('FastForuierTransform'); xlabel('Гц');
            legend('AmpSpectrum','Threshold');
            xlim([-inf Fmax]), ylim([0 inf])
    else
    end
% WDold
subplot(714);
    Pos=strcmp(Algorithms_name,'WTOld');
    if Algorithms_v(1,Pos)==1
    CalcVal=CalcVal_G{Pos};
    Threshold=Threshold_G{Pos};
    IdxThresh=find(CalcVal(:,1)>Threshold);
            plot(f2,CalcVal(:,1),f1,Threshold,'r-'); grid on;   % Пороговый уровень и спектр
            hold on
            plot(f2(IdxThresh),Threshold(IdxThresh),'g*');   % Превышение порогового уровня
            hold off
            title('WaveletDecompostionOld'); xlabel('Гц');
            legend('AmpSpectrum','Threshold');
            xlim([-inf Fmax]), ylim([0 inf])
    else
    end
% WD
subplot(715);
    Pos=strcmp(Algorithms_name,'WT');
    if Algorithms_v(1,Pos)==1
        ind=ind_G{Pos};
    CalcVal=[NaN(numel(f1),1),f1];                 % Формирование сетки частот и амплитуд
    CalcVal(ind,1)=CalcVal_G{Pos}(:,2);
    Threshold=Threshold_G{Pos};
    IdxThresh=find(CalcVal(:,1)>Threshold);
            stem(f1,CalcVal(:,1)); grid on;     % Спектр
            hold on
            plot(f1,Threshold,'r-');            % Пороговый уровнь
            plot(f2(IdxThresh),Threshold(IdxThresh),'g*');   % Превышение порогового уровня
            hold off
            title('Wavelet Decomposition Hilbert Transform Algorithm'); xlabel('Гц');
            xlim([-inf Fmax]), ylim([0 inf])
    else
    end
% HHT
subplot(716)
    Pos=strcmp(Algorithms_name,'HHT');
    if Algorithms_v(1,Pos)==1
        ind=ind_G{Pos};
    CalcVal=[NaN(numel(f1),1),f1];                 % Формирование сетки частот и амплитуд
    CalcVal(ind,1)=CalcVal_G{Pos}(:,2);
    Threshold=Threshold_G{Pos};
    IdxThresh=find(CalcVal(:,1)>Threshold);
            stem(f1,CalcVal(:,1)); grid on;     % Спектр
            hold on
            plot(f1,Threshold,'r-');            % Пороговый уровнь
            plot(f2(IdxThresh),Threshold(IdxThresh),'g*');   % Превышение порогового уровня 
            hold off
            title('Hilbet-Huang Transform Algorithm'); xlabel('Гц');
            xlim([-inf Fmax]), ylim([0 inf])
    else
    end    
% HHTold
subplot(717);
    Pos=strcmp(Algorithms_name,'HHTold');
    if Algorithms_v(1,Pos)==1
        ind=ind_G{Pos};
    CalcVal=[NaN(numel(f1),1),f1];                 % Формирование сетки частот и амплитуд
    CalcVal(ind,1)=CalcVal_G{Pos};
    Threshold=Threshold_G{Pos};
    IdxThresh=find(CalcVal(:,1)>Threshold);
            stem(f1,CalcVal(:,1)); grid on;     % Спектр
            hold on
            plot(f1,Threshold,'r-');            % Пороговый уровнь
            plot(f2(IdxThresh),Threshold(IdxThresh),'g*');   % Превышение порогового уровня 
            hold off
            title('Hilbet-Huang Transform Old'); xlabel('Гц');
            xlim([-inf Fmax]), ylim([0 inf])
    else
    end
% subplot(817);
% subplot(818);


end