% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [nameFolder] = az_input(Prog_mode)
    global FilterSign Forder Fcut TypeRadar leveldef f_band CFAR Al_fl_name
    global graphs
    global nModels nSNRa fRes SNRarray Noiseamp ConstantPart Fest nFalseAlarms NFest  ModelType Mode3_file Mode3_st Type_br_mod Model_singl Model_diap
    global noises remove_dist select_time select_file Alarms 
    

    %% LP Фильтр
    FilterSign='on';                    % ['on'-yes | 'off'-no] Использутся ли LP фильтиер
    Forder = 10;
    Fcut = 1;                             % Частота среза LP [Гц]
    %% Тип радара
    TypeRadar=2;                        % Характеристики радара [1 | 2], параметры можно посмотреть в фунции F_Radar в конце файла
    %% Обнаружитель
    leveldef=1;                         % Обнаружитель 1-Постоянный ____нереализовано____2-CFAR 3-Аддапитивный(вычисляет шум)
    % f_band=[0.1,2];                     %[f_l,f_h] Полоса пропускания для постоянного порогового уровня [Гц]
    f_band=[0.01,120];                       %[f_l,f_h] Полоса пропускания для постоянного порогового уровня [Гц]
    CFAR=[4,2,0.3];                     % Параметры для CFAR обнаружителя [gueard,def,thresh]
    %% Файл с расчитанными уровнями тревог (если нет происходит расчет)
    % Al_fl_name='Autosave_alarms_n80000_fest0.010000_t5.000000.mat';               % Имя файла с пороговыми урвонями
    %% Выборка времени
    select_time = 2:8:80;               % разбить файл на диапазоны по 5 секунд от 2 до 80
%     select_time = [20,24];            % с 20 по 24 секунды
%     select_time = [20,40];
    % Частотное разрешение Многомерных алгоритмов
    fRes = 400;                   % Частотное разрешение для алгоритмов с декомпозицией (Если [] то в соответвии с FFT)
    %% Графики
    graphs=3;                           % Выбор графиков 2-Детекторы 1-Алгоритмы 0-Изображение или характеристики обнаруж.
    


    %% Параметры Модели
    if  strcmp(Prog_mode,'model')
        %% Получаемые графики
        graphs=2;                           % Выбор отображаемых грфиков 0-Вероятности обнруж 2-Обнаружители 1-Алгоритмы
        %% Параметры моделирования
        nModels=2000;                         % Количество моделей
        nSNRa=20;                           % Значений сигнала в одной модели
        %% Параметры модели сигнала
        SNRarray=logspace(-2, 1, nSNRa);      % Диапазон отношений SNR в порядках -1.0 до 1.0
        SNRarray=logspace(-1, 1, nSNRa);      % Диапазон отношений SNR в порядках -1.0 до 1.0
%         SNRarray=linspace(1e-3, 4, nSNRa);      % Диапазон отношений SNR линейный
        % a = 0.1;                        % мин значение amp сигнала
        % da = 0.4;                       % шаг изменения amp сигнала
        % SNRarray = a:da:a+da*(nSNRa-1); % массив значений amp сигнала
        %% Параметры модели сигнала
        Noiseamp=1;                         % Амплитуда шума
        ConstantPart=0;                   % Постоянная составляющая
        %% Параметры расчета статистики для вычисления пороговых уровней
        Fest=0.01;                          % Вероятность ложной тревоги
        NFest = 1000*10;
%         nFalseAlarms=10;                    % Кол-во тревог по которым считается порогвый уровень
%         NFest=round(nFalseAlarms/Fest);     % Расчет необходимого количества моделирований
        %% Параметры модели дыхания
        ModelType = 'CycleStationarity';        % 'CycleStationarity'-циклостационарность, 'Garmonic'-псвгармоническая, 'Signal Experement'-реальный сигнал
        Mode3_file = load([pwd '\Model_file_164_dist_45.mat']);  % загрузка mat-file
        Mode3_st = 80;      % 1 - номер отсчета, 'rand' Время начала выборки модели 3
        Type_br_mod = 'singl';      % Тип модели сигнала 'diap'-диапазон 'singl'-заданная
        Model_singl=[0.2,      1,  0.1,  0.1,   0.1,   0.1,   0.1,   1];
        % СрЧД, СрАмпД,УрНЧш,   ДизЧД, ЧизЧД,   ДизАД, ДизЧД,   ПНег
        Model_diap=[ 0.1,   0.8   1,   0.04,  0.04   0.04   0.04  2;...
            0.4,    1,    1,   0.04,  0.04,  0.04,  0.04, 3];
        % СрЧД,СрАмпД, УрНЧш,ДизЧД, ЧизЧД, ДизАД, ДизЧД,ПНег

%         nModels=100;                         % Количество моделей
%         NFest = 200;
%         Fest=0.1;                          % Вероятность ложной тревоги

        nameFolder = sprintf('models%d noises%d peroid%.1f radar%d F%s %s', nModels, NFest, select_time(2) - select_time(1), TypeRadar, FilterSign, ModelType);

    %% Параметры Сигналы
    elseif strcmp(Prog_mode, 'real')
        
        %% Шум добавляемый ко всем кадрам
        Noiseamp = 0;
        %% [м] Диапазон дальностей
        % remove_dist=[4.7,4.8];
        remove_dist=[1.2,30];
        %% Файлы с сигналами
        select_file=167:168;                % Только заданная выборк файлов
        % select_file=164:180;                % Только заданная выборк файлов
        %% Уровни тревог если нет файла
        % Alarms=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];         % Уровни обнаружителей
        nameFolder = sprintf('peroid%.1f radar%d F%s', select_time(2) - select_time(1), TypeRadar, FilterSign);
    end

    
end
