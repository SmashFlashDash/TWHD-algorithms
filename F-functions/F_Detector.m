function [DetectionSign,DetectedSpectrum,Threshold, f] = F_Detector(alg_type, pos_name, spect, f, type_signal)
global Alarms f1 f1_grid_bin f2 leveldef f2_grid_bin nK fwsst f_band
% Входные параметры
if strcmp(type_signal, 'signal+noise')
    threshHHT=Alarms(1, pos_name);       % Постоянное значение обнаружителя
end

if not(isempty(f))
    % соответсиве матриц частот и спектра
    if not(size(f, 1) == 1)
        f = f';
    end
    % Используемые частоты в детекторе
    f_bin = ones(size(f));
    f_bin(:, f < f_band(1, 1) | f > f_band(1, 2)) = NaN;
    % дискретных спектров
    if size(spect, 2) == 10
        ind = spect(:, 3);
        Spectrum = [NaN(size(f)); f];
        Spectrum(1,ind) = spect(:, 1);                   % Присвоение амплитуд на значения частот в сплошнйо спектр
        Spectrum(1,:) = Spectrum(1, :) .* f_bin;           % Значения амплитуд и частот NaN вне полосы f_band
    else
        % сплошной спектр проверка на соостветвие f_bin
        index = find(size(spect) == size(f, 2));
        if index == 1
            spect = spect';
        elseif index == 2
            error('unkonw spectrum');
        end
        Spectrum = spect .* f_bin;     % Значения амплитуд и частот NaN вне полосы f_band
    end
end



%% Обнаружитель Experiment  
if any(strcmp(alg_type,'Paramet'))
    if strcmp(type_signal, 'noise')          % Если вычисляем статистику
        Threshold=[];
        DetectedSpectrum=NaN(1,numel(f));
        DetectionSign(1,1)=max(Spectrum);
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if leveldef==1                     % Постоянный пороговый уровень
            Threshold=f_bin.*threshHHT;   % присвоение значений
            Detector=Spectrum>Threshold;   % Сравнение с пороговой функции
            % Вывод
            DetectionSign=any(Detector);                % Произошло ли обнаружения
            DetectedSpectrum=Spectrum.*Detector;   % Отсчеты спектра превысившие threshold
            DetectedSpectrum(isnan(DetectedSpectrum))=0;    % Если надо NaN в 0 для граифков
        elseif leveldef==2   % Не реализованно % Аддаптивный
        elseif leveldef==3    % Не реализованно % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');    
    end

%% Обнаружитель Experiment  
elseif any(strcmp(alg_type,{'Experiment'}))
%     Spectrum=spect.*f2_grid_bin;     % Значения амплитуд и частот NaN вне полосы f_band
    if strcmp(type_signal, 'noise')          % Если вычисляем статистику
        Threshold=[];
        DetectedSpectrum=NaN(1,numel(f2));
        DetectionSign(1,1)=max(Spectrum);
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if leveldef==1                     % Постоянный пороговый уровень
            Threshold=f2_grid_bin.*threshHHT;   % присвоение значений
            Detector=Spectrum(:,1)>Threshold;   % Сравнение с пороговой функции
            % Вывод
            DetectionSign=any(Detector);                % Произошло ли обнаружения
            DetectedSpectrum=Spectrum(:,1).*Detector;   % Отсчеты спектра превысившие threshold
            DetectedSpectrum(isnan(DetectedSpectrum))=0;    % Если надо NaN в 0 для граифков
        elseif leveldef==2   % Не реализованно % Аддаптивный
        elseif leveldef==3    % Не реализованно % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');    
    end


%% Обнаружитель один отсчет
elseif any(strcmp(alg_type,{'TFD' 'Cov' 'Var' 'HTVar'}))
    Val = spect(:,1);
    if strcmp(type_signal, 'noise')            % Если вычисляем статистику
        DetectedSpectrum=[];
        Threshold=[];
        DetectionSign(1,1)=Val;   % Запись максимального числа в массив
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if leveldef==1
            Threshold=threshHHT;
            spect(Val<Threshold)=0;   %Сравнение каждого ЧПК с Threshold
            % Вывод
            DetectionSign=any(spect);         % Детектирование
            DetectedSpectrum=spect;  % Спектр превысивший пороговый уровнь
        elseif leveldef==2   % Аддаптивный
        elseif leveldef==3    % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');
    end 

    
%% Обнаружитель сплошной спектр
elseif any(strcmp(alg_type,{'FFT' 'WTold' 'HHTold'}))
    if strcmp(type_signal, 'noise')          % Если вычисляем статистику
        Threshold=[];
        DetectedSpectrum=NaN(1,numel(f));
        DetectionSign(1,1)=max(Spectrum);
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if leveldef==1                     % Постоянный пороговый уровень
            Threshold=f_bin.*threshHHT;   % присвоение значений
            Detector=Spectrum>Threshold;   % Сравнение с пороговой функции
            % Вывод
            DetectionSign=any(Detector);                % Произошло ли обнаружения
            DetectedSpectrum=Spectrum.*Detector;   % Отсчеты спектра превысившие threshold
            DetectedSpectrum(isnan(DetectedSpectrum))=0;    % Если надо NaN в 0 для граифков
        elseif leveldef==2   % Не реализованно % Аддаптивный
        elseif leveldef==3    % Не реализованно % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');    
    end

    
    
%% Обнаружитель спектр двумерный
elseif any(strcmp(alg_type,{'STFT' 'SsFT' 'WssT'}))
    Spectrum(isnan(Spectrum)) = 0;     % Значения амплитуд и частот NaN вне полосы f_band
    if strcmp(type_signal, 'noise')          % Если вычисляем статистику
        Threshold = [];
        DetectedSpectrum = NaN;
        DetectionSign(1,1) = max(max(Spectrum(:,:)));  
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if leveldef == 1                     % Постоянный пороговый уровень
            Threshold = f_bin .* threshHHT .* ones(size(spect));   % присвоение значений
            Detector = Spectrum > Threshold;   % Сравнение с пороговой функции
            % Вывод
            DetectionSign = any(any(Detector));                % Произошло ли обнаружения
            DetectedSpectrum = max(Spectrum.*Detector,[],1);   % Отсчеты спектра превысившие threshold         
%             DetectedSpectrum(isnan(DetectedSpectrum)) = 0;    % Если надо NaN в 0 для граифков
        elseif leveldef==2    % Не реализованно % Аддаптивный
        elseif leveldef==3    % Не реализованно % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');    
    end


%% Обнаружитель спектр двумерный накопление по ridge
elseif any(strcmp(alg_type,{'STFTrdg' 'SsFTrdg' 'WssTrdg'}))
        if strcmp(alg_type,{'WssTrdg'})
            f_wsst_bin = NaN(size(fwsst'));
            f_wsst_bin(~(fwsst<f_band(1,1) | fwsst>f_band(1,2))) = 1;
            Spectrum=spect(:,:).*f_wsst_bin;     % Значения амплитуд и частот NaN вне полосы f_band
            Spectrum(isnan(Spectrum)) = 0;     % Значения амплитуд и частот NaN вне полосы f_band
            freqs = fwsst;
            freqs_bin = f_wsst_bin;
        elseif any(strcmp(alg_type,{'STFTrdg' 'SsFTrdg'}))
            Spectrum = spect(:,:).*f2_grid_bin;     % Значения амплитуд и частот NaN вне полосы f_band
            Spectrum(isnan(Spectrum)) = 0;     % Значения амплитуд и частот NaN вне полосы f_band
            freqs = f2;
            freqs_bin = f2_grid_bin;
        end
    if strcmp(type_signal, 'noise')          % Если вычисляем статистику
        Threshold = [];
        DetectedSpectrum = NaN;
        [~,~,lridge] = tfridge(Spectrum,freqs);
        DetectionSign(1,1) = sum(Spectrum(lridge));
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if all(leveldef == 1)                     % Постоянный пороговый уровень
            Threshold = threshHHT;   % присвоение значений
            % Накопление сигнала
            [~,iridge,lridge] = tfridge(Spectrum,freqs);
            SpectrumStemVal = sum(Spectrum(lridge));
            findx = mode(iridge);
            % Сравнение
            Detector = SpectrumStemVal > Threshold;   % Сравнение с пороговой функции
%             spect = [NaN(numel(f2),1),f2'];                 % Формирование сетки частот и амплитуд
%             spect(findx,1) = SpectrumStemVal;                   % Присвоение значений из разреженного спектра
            % Вывод
            DetectionSign = any(any(Detector));                % Произошло ли обнаружения
            DetectedSpectrum = NaN(numel(freqs),1);                 % Формирование сетки частот и амплитуд
            DetectedSpectrum(findx,1) = SpectrumStemVal;                   % Присвоение значений из разреженного спектра
            DetectedSpectrum(isnan(DetectedSpectrum)) = 0;    % Если надо NaN в 0 для граифков
        elseif leveldef==2   % Не реализованно % Аддаптивный
        elseif leveldef==3    % Не реализованно % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');    
    end
 
    
%% Обнаружитель по частотным отсчетам мод      
elseif any(strcmp(alg_type,{'HHT' 'WT' 'HHTthr' 'HHTthr2' 'WTthr' 'WTthr2' 'HHTst'  'HHTexp' 'VMD'}))
    % Перенос отсчетов спектра на сетку частот
%     Spectrum = [NaN(numel(f1),1),f1];                 % Формирование сетки частот и амплитуд
%     [spect] = removeRepeat(spect,ind);
%     Spectrum(ind,1)=spect(:,1);                   % Присвоение значений из разреженного спектра
%     Spectrum(:,1)=Spectrum(:,1).*f1_grid_bin';      % Значения амплитуд и частот NaN вне полосы f_band
    if strcmp(type_signal, 'noise')                  % Если вычисляем статистику
        Threshold = [];
        DetectedSpectrum = NaN(1,numel(f1));
        DetectionSign(1,1) = max(Spectrum(1,:));
    elseif strcmp(type_signal, 'signal+noise')   % Если принимаем решение по сигналу дальности
        if leveldef==1                     % Постоянный пороговый уровень
            Threshold = f_bin.*threshHHT;  % присвоение значений
            Detector = Spectrum(1,:)>Threshold;   % Сравнение с пороговой функции
            % Вывод
            DetectionSign = any(Detector);                % Произошло ли обнаружения
            DetectedSpectrum = Spectrum(1,:).*Detector;   % Отсчеты спектра превысившие threshold
            DetectedSpectrum(isnan(DetectedSpectrum)) = 0;    % Если надо NaN в 0 для граифков
        elseif leveldef==2   % Не реализованно % Аддаптивный
        elseif leveldef==3    % Не реализованно % CFAR
        else
            error('Incorrect "leveldef"');
        end
    else
        error('Incorrect "type_signal" Input value in F_Detector');
    end


end
end






%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%%
function [spect] = removeRepeat(spect,ind)
duplicates = double.empty;
    for i = 1:numel(ind)
        for i2 = i+1:numel(ind)
            if ind(i)==ind(i2)
                duplicates(end+1) = ind(i);
            end
        end
            
    end
    
if ~isempty(duplicates)
    for i=1:length(duplicates)
        indxd = find(ind==duplicates(i));
        
        % Найти максимальный
        amps = spect(:,1);
        ampsindx = find(amps==max(amps(indxd)));
        diff = ~(indxd==ampsindx);
        spect(indxd(diff),:) = 0;

        
    end
else
end

end
