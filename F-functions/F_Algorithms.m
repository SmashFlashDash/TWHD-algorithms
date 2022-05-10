% Алгоритмы обработки исследуемые
function [Detections,Detected_Spect, spectf] = F_Algorithms(inp_signal, graphs, type_signal, iModel, nModels, iSNR,nSNRa,SNR,SNRkoef,SingalM,Noise)
global Algorithms_v Algorithms_name Algorithms_type Algorithms_all_type Algorithms_name_filt nAlgorithmsAll Algorithms
global lpFilt FilterSign Prog_mode


%% Амп Фаз спектры
signal = abs(inp_signal);            % амплитудный спектр
signal_y = angle(inp_signal);        % фазовый спектр
% Минус среднее
signal = signal - mean(signal);          % Минус постоянная составляющая
signal_y = signal_y - mean(signal_y);        % фазовый спектр


%% Фильтрация
if strcmp(FilterSign, 'on')
    signal_unf = signal;
    signal = filtfilt(lpFilt, signal);   % Степень фильтра ограничивает кол-во входных отсчетов%% Детренд
elseif strcmp(FilterSign, 'off')
    signal_unf = signal;
else
    error('Incorrect FilterSign Input value');
end


%% Цикл сигнала по алгоритмам
Detections=NaN(1,nAlgorithmsAll);           % Сигнал детектирования
spect = cell(nAlgorithmsAll,1);             % Массив спектров алгоритмов
spectf = cell(nAlgorithmsAll,1);
Detected_Spect = cell(nAlgorithmsAll,1);    % Массив спектров после обнаружителя
Threshold = cell(nAlgorithmsAll,1);         % Массив пороговых уровней
ind = cell(nAlgorithmsAll,1);
for i=1:size(Algorithms_v, 2)
    pos_name = find(strcmp(Algorithms_name, Algorithms{1,i}));
    if Algorithms_v(i)==1
        alg_name = Algorithms{1,i};
        alg_type = Algorithms{2,i};
        alg_use = Algorithms{3,i};
        wname = Algorithms{4,i};
        wlev = Algorithms{5,i};
        diff_params = Algorithms{6,i};
%         fprintf('%s\n', alg_name);
    else
        Detections(1,pos_name)=NaN;
        Detected_Spect{pos_name}=NaN;
        continue
    end
    

   % Paramet
    if alg_use==1 && strcmp(alg_type, 'Paramet') 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_Paramet(signal, signal_y, diff_params, graphs, wname,wlev);
    % ЧПК
    elseif alg_use==1 && any(strcmp(alg_type, {'TFD', 'Var', 'HTVar', 'Cov'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_1d(signal, signal_y, diff_params, alg_type);
    % FFT
    elseif alg_use==1 && any(strcmp(alg_type, {'FFT', 'HTFFT'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_FFT(signal, alg_type);
    % STFT
    elseif alg_use==1 && any(strcmp(alg_type, {'STFT', 'STFTrdg'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_STFFT(signal, alg_type);
    % SsFT
    elseif alg_use==1 && any(strcmp(alg_type, {'SsFT', 'SsFTrdg'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_SsFT(signal, alg_type);
    % WssT
    elseif alg_use==1 && any(strcmp(alg_type, {'WssT', 'WssTrdg'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_WssT(signal, alg_type);
    % WT
    elseif alg_use==1 && any(strcmp(alg_type,{'WT', 'WTold', 'WTthr', 'WTthr2'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_WT(signal, alg_type, wname, wlev, diff_params);    % graphs nSNRa nModels только для графика
    % HHT
    elseif alg_use==1 && any(strcmp(alg_type,{'HHT', 'HHTold', 'HHTthr', 'HHTthr2'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_HHT(signal, alg_type, diff_params);   % graphs только для графика
    
        
        % Не сделанные алгоритмы
    % Experiment', 'VMD', 'EEMD'
    elseif alg_use==1 && any(strcmp(alg_type, {'Experiment'})) 
        [spect{pos_name}, spectf{pos_name}] = F_Alg_Experiment(signal, signal_y, alg_type, diff_params, wname, wlev, graphs);
    %HHTperiodic
    elseif alg_use==1 && strcmp(alg_type,'HHTst') 
        error('In production, Turn off "HHTst" algorithm')
    %HHTexperemental
    elseif alg_use==1 && strcmp(alg_type,'HHTexp') 
        error('In production, Turn off "HHTexp" algorithm')
    else
        error('Wrong alg_type')
    end

    % Детектор
    [Detections(1,pos_name), Detected_Spect{pos_name}, Threshold{pos_name}, spectf{pos_name}] = F_Detector(alg_type, pos_name, spect{pos_name}, spectf{pos_name}, type_signal);



    %% Пауза для графиков
    if graphs==0
    elseif graphs==1
        F_GraphicAlgorithms(signal,signal_unf,CalcVal_G,ind_G,Threshold_G,iModel,nModels,iSNR,nSNRa,SNR,SignalM,Noise)
        error('No realisation of graphs=1 value');
    elseif graphs==2
        if strcmp(Prog_mode, 'real')
            F_GraphicDetectors(signal, signal_unf, alg_type, spect{pos_name}, Detected_Spect{pos_name}, Threshold{pos_name}, spectf{pos_name}, iModel, nModels, iSNR, 0, 0, 0, 0, 0);
        elseif strcmp(Prog_mode, 'model')
            F_GraphicDetectors(signal, signal_unf, alg_type, spect{pos_name}, Detected_Spect{pos_name}, Threshold{pos_name}, spectf{pos_name}, iModel, nModels, iSNR, nSNRa, SNR, SNRkoef, SingalM, Noise);
        end
    end
end

% Сохранить графики
if graphs==0
elseif graphs==1
elseif graphs==2
    % обнаружители сохранять в папку Detector
    AutoSaveFolder = [pwd '\Detector\'];
    if exist(AutoSaveFolder, 'dir')
        rmdir(AutoSaveFolder, 's')
    end
    mkdir(AutoSaveFolder, 's')
    F_reset_ax_figs();
    F_saveallfigs(AutoSaveFolder);
%     pause();
    close all;
end
end

