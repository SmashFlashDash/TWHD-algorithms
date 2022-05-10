% Графика Обнаружителей
function F_GraphicDetectors(signal, signal_unf, alg_type, spect, detected_Spect, threshold, spectf, iModel, nModels, iSNR, nSNRa, SNR, SNRkoef, SingalM, Noise)
global AxTFrames AxDistance Prog_mode TypeRadar x y xd yd


% Сигнал на воход алгоритмов
if isempty(findobj('type', 'figure', 'name', 'input Signal'))
    F_reset_ax_figs();
    if strcmp(Prog_mode,'model') % модели
        Titl={'Моделированный Сигнал дыхания + шум';...
            ['Model=' num2str(iModel) '/'  num2str(nModels) ', ' 'Realisation=' num2str(iSNR) '/'  num2str(nSNRa) ', ' 'SNR=' num2str(SNR)];...
            'Сигнал дыхания'};
    elseif strcmp(Prog_mode,'real') % реальные сигналы
        Titl={'Сигнал дальности';...
            ['Тип радара=' num2str(TypeRadar) ', ' 'Файл=' num2str(iModel) '/'  num2str(nModels) ', ' 'Дальность=' num2str(iSNR) '-',...
            num2str(AxDistance(iSNR)) '[м]']};
    end
    figure('Name', sprintf('input Signal'), 'Position',[x y xd yd],'Units','pixels');
    if strcmp(Prog_mode,'model') % модели
        subplot(211)
        plot(AxTFrames,SignalM*SNRkoef,AxTFrames,Noise); grid on;
        title(Titl);
        xlabel('Сек');
        legend('Signal','Noise')
        subplot(212)
        plot(AxTFrames,Signal,AxTFrames,SignalF); grid on;
        title('Signal');
        xlabel('Сек');
        legend('Noised','Filtered Signal');
    elseif strcmp(Prog_mode,'real') % реальные сигналы
        plot(AxTFrames, signal, AxTFrames, signal_unf); grid on;
        title(Titl);
        xlabel('Сек');
        legend('Noised','Filtered Signal');
    end
    F_change_ax_figs(5);
end


% Алгоритмы
figure('Name', sprintf('algorithm %s ', alg_type),'Position', [x y xd yd], 'Units', 'pixels');
if any(strcmp(alg_type,{'Cov', 'TFD','Var','HTVar'}))
    stem(spect);  % ЧПК кадры
    hold on
    ax_xl = xlim;
    plot([ax_xl(1) ax_xl(2)], [threshold, threshold], 'r-');   % Пороговый уровень
    Indx = logical(detected_Spect);
    plot(detected_Spect(Indx),'g*');    % Превышение порогового уровня
    hold off
    title('');
    legend('value','threshold', 'detections');
elseif any(strcmp(alg_type,{'FFT' 'WTold' 'HHTold' 'STFT' 'SsFT' 'WssT' 'Paramet'}))
%     CalcVal=CalcVal_G{Pos};
%     Threshold=Threshold_G{Pos};
%     IdxThresh=find(CalcVal(:,1)>Threshold);

    plot(spectf, spect)
    hold on
    plot(spectf, threshold, 'r-'); grid on;   % Пороговый уровень и спектр
    Indx = logical(detected_Spect);
    plot(spectf(Indx), detected_Spect(Indx), 'g*');   % Превышение порогового уровня
    hold off
    title(alg_type); 
    legend('spectrum','threshold', 'detections');
    ylabel(''); xlabel('Гц');
    xlim([-inf +inf]), ylim([0 inf])
elseif any(strcmp(alg_type,{'STFTrdg' 'SsFTrdg' 'WssTrdg'}))
    plot(spectf, spect)
    hold on
    plot(spectf, threshold, 'r-'); grid on;   % Пороговый уровень и спектр
    Indx = logical(detected_Spect);
    plot(spectf(Indx), detected_Spect(Indx), 'g*');   % Превышение порогового уровня
    hold off
    title(alg_type); 
    legend('spectrum','threshold', 'detections');
    ylabel(''); xlabel('Гц');
    xlim([-inf +inf]), ylim([0 inf])
elseif any(strcmp(alg_type,{'HHT' 'WT' 'HHTthr' 'HHTthr2' 'WTthr' 'WTthr2' 'HHTst'  'HHTexp' 'VMD'}))
    stem(spectf(spect(:,3)), spect(:,1))
    hold on
    plot(spectf, threshold, 'r-'); grid on;   % Пороговый уровень и спектр
    Indx = logical(detected_Spect);
    stem(spectf(Indx), detected_Spect(Indx), 'g*');   % Превышение порогового уровня
    hold off
    title(alg_type); 
    legend('spectrum','threshold', 'detections');
    ylabel(''); xlabel('Гц');
    xlim([-inf +inf]), ylim([0 inf])
end
F_change_ax_figs(5);

end