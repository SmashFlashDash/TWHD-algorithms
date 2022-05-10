clearvars
clear global
clc
close all
global nAlgorithmsAll AxDistance Noiseamp select_file select_time graphs Prog_mode nFiles Alarms Al_fl_name AxTFrames Fs

addpath('F-algorithms\', 'F-functions\', 'F-inputs\')


% Добавить предварительный алгоритм по корреляции фазового и амплитудного спектра развертки по дальности
% Добавить предварительный variance алгоритм для исключения малоподвижных дальностей
% Добавить алгоритм z-score выборку по ЧПК для исключения моментов присутсвия в дальности перемещения человека
% В z-score алгоритме можно использовать phase спектра от развертки по дальности строка 98
% HHT иногда сигнал разбивается в две моды, и результирующий сигнал их сложение

% Проверить работу алгоритмов на малых периодах времени и на длинных
% Добавить fft+bp_filt, stft, var, ssfft, wvd
% Детектирование CFAR по РЛ картине (2d CFAR)
% Детектирование во временно-частотной области
% Не правильный расчет сигналшум при изменении амплитуды шума

% Сделать движение по данным окна алгоритмов

% Доабвить график рл по wsst fsst, посмотреть с tfridge
% нужен алгоритм с лучшим обнаружением сигнала
% нужен алгоритм с лучшим частотным разрешением для записи сигнала
% обнаружение подвижного, исключение дальностей за ним

% обьеденить функцию по выборке дальностей
% обьеденить функциб по выборке времени
% Добавить такую же функцию для моделей
% сделать локатор с максимальнйо дискритизацией по вермени, сравнить алгоритмы



%  в wt thr сделать сложение мод при превышении порога обнаружителя
% в wt thr складывать моды если их энергия превышает значение энергии
% рассчитываемое от количества отсчетов
%% Входные данные
AutoSaveFolder = '\Autosave_real';
delete([AutoSaveFolder '*'])
Prog_mode='real';                   % ['model'-модели 'real'-реальные сигналы] не менять
graphs_noise_model = 0;             % 0 - скрыть 1 - показать графики реализаций моделей шума
graphs_noise_detections = 0;        % 0 - скрыть 1 - показать графики вычисленных пороговых уровней
graphs_every_model = 0;             % 0 - скрыть 1 - показать моделей сигнал+шум


% az_alg_input_thr();    % параметры алгоритмов
% az_alg_input_experiments();
% az_alg_input_parametric()
% az_alg_input_parametric_2()
% subFolder1 = az_alg_input_algstypes2();    % параметры алгоритмов
subFolder1 = az_alg_input_algstypes3();    % параметры алгоритмов
subFolder2 = az_input(Prog_mode);    % остальные параметры
%% Массивы и обьекты для вычислений
Noiseamp = 1.8e3;                                           % Добавить шум к сигналу
graphs = 0;                                           
AutoSaveFolderMain = F_variables(Prog_mode, AutoSaveFolder);
Alarms = zeros(1,nAlgorithmsAll);         % Уровни обнаружителей
get_Alarm_Levels();
F_reset_ax_figs()



%% Цикл по параметрам радара
TypeSignal = 'signal+noise';   % параметр реальные сигналы
% for TypeRadar=1:2
[Data_select, Data_All, nFiles] = LoadReal();      % Таблица с путями к файлам
%% Цикл файлов
DetectionsMain = zeros(size(Data_select, 1), nAlgorithmsAll); % Массив обнаружений в эксперименте
[n_fl, ~] = size(Data_select);                      % Кол-во файлов текущего типа радара
for i_fl=1 : n_fl
    [signals_loaded, describe] = LoadSignal(i_fl, Data_select);     % Получение развертки по дальности
    % Добавление шума к сигналу
    signals_loaded = signals_loaded + Noiseamp*complex(rand(size(signals_loaded)), rand(size(signals_loaded)));
    %% Цикл выборки по времени
    for i = 1 : length(select_time)-1
        signals_framed = signals_loaded;
        [signals_framed, idx_sel_Tsel] = Remv_TimeWind(signals_framed, i);      % Выборка времени
        % возврат если отсчетов меньше чем в заданном периоде
        if length(signals_framed(:,1)) < (select_time(2) - select_time(1)) * Fs
            break;
        end
        [signals_framed, idx_sel_Dist] = Remv_DstTime(signals_framed);          % Выборка дальностей и времени сигналов
        %% Цикл по дальностям
        Detections = zeros(nAlgorithmsAll, size(signals_framed, 2));            % Массив обнаружений по каждой дальности
        DetectedSpectrumDif = cell(numel(AxDistance), nAlgorithmsAll);          % Массив сбора результатов обработки по дальностям
        DetectedSpectrumDif(:,:) = {NaN};
        for i_dist = idx_sel_Dist(1) : idx_sel_Dist(2)
            Signal = signals_framed(:, i_dist);     % Сигнал от одной дальности
            [Detections, DetectedSpectrum, fspects] = F_Algorithms(Signal, graphs, TypeSignal, i_fl, n_fl, i_dist, [],[],[],[]);  % TypeRadar-тек.тип i_dist-тек. дальнось i-тек. номер файла
            DetectedSpectrumDif(i_dist,:) = DetectedSpectrum;    % Накопление результотов обработки дальностей
            %% Отображение в командной строке
            fprintf('Обработано: Дальность=%d/%d\n', i_dist, numel(AxDistance));
        end
        
        

        %% Очистить или создать dir
        isDirMaked = false;
        num_file = num2str(select_file(i_fl));
        AutoSaveFolder = AutoSaveFolderMain;
        if i==1
            isDirMainMaked = false;
            for is=1:10
                    AutoSaveFolderBase = char(sprintf("%s %s\\f%s %s_%d", AutoSaveFolder, subFolder1, num_file, subFolder2, is));
                    if not(exist(AutoSaveFolderBase, 'dir'))
                        isDirMainMaked = true;
                        break;
                    end
            end
            if not(isDirMainMaked)
                AutoSaveFolderBase = char(sprintf("%s %s_temp", AutoSaveFolder, subFolder1));
                try
                    rmdir(AutoSaveFolderBase, 's');
                catch
                end
            end
        end
        for is = 1 : 10
            AutoSaveFolderSub2 = char(sprintf("\\Time-%.2f-%.2f %s _%d", AxTFrames(1), AxTFrames(end), describe, is));
            if not(exist([AutoSaveFolderBase AutoSaveFolderSub2], 'dir'))
                isDirMaked = true;
                AutoSaveFolder = [AutoSaveFolderBase AutoSaveFolderSub2];
                mkdir(AutoSaveFolder)
                break
            end
        end
        if not(isDirMaked)
            AutoSaveFolder = [AutoSaveFolderBase AutoSaveFolderSub(1:end-1) '_temp' ];
            try
                rmdir(AutoSaveFolder, 's')
            catch
            end   
            mkdir(AutoSaveFolder)
        end
        %% Отображение в командной строке
        print_text(AutoSaveFolder, num_file, describe)
        %% Графика
        F_GraphicRLImages(DetectedSpectrumDif, fspects, i_fl, Data_select, idx_sel_Dist, idx_sel_Tsel, signals_framed, describe, graphs);
        F_saveallfigs(AutoSaveFolder);
        pause;
        close all;
    end
end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Функции
% Загрузка уровней тревог
function get_Alarm_Levels()
    global Al_fl_name Alarms
    file_name=Al_fl_name;
    if logical(exist(file_name, 'file'))
        % Уровень тревог из файла
        Alarms=load(file_name);
        Alarms=Alarms.Alarms;
    else
        % Заданные из условия если файла нет
        % Alarms;
    end
end

% Загрузка сигналов радара
function [Data_sel_radartype, Data_All, nFiles] = LoadReal()
    global select_file TypeRadar
    Data_All = load([pwd '\DataAllString.mat']);  % загрузка mat-file
    Data_All = Data_All.DataAll;
    Data_select = Data_All(select_file,:);    % выборка файлов из таблицы
    Data = str2double(Data_select);          % конвертация в double
    Data_sel_radartype = Data_select(Data(:,6)==TypeRadar,:); % Исключение путей к файлам с другим типом радара
    nFiles = size(Data_sel_radartype,1);
end

% Загрузка сигналов радара
function [DSpecM, describe] = LoadSignal(i_fl, Data_select)
    global nK_base  nF
    Samp = nF;                         %Количество отсчетов в кадре ==nF
    Path = [cd '\' 'Ispitaniya'];
    Folder = char(Data_select(i_fl, 1));
    File = char(Data_select(i_fl, 2));
    Input = fread(fopen([Path '\' Folder '\' File], 'r'), 'int32', 'b')';
    fclose all;
    Data = complex(Input(1:2:end), Input(2:2:end));
    Data = reshape(Data, Samp, []).';
    DSpecM = zeros(nK_base, nF);         %Развертка дальности реальный сигнал
    for in = 1:nK_base
        DSpecM(in,:) = fft(Data(in,:));      %Переход к развертке по дальности
    end
    describe = char(Data_select(i_fl, 3));
end

% Выборка времени сигнала радара
function [signals_framed, idx_sel_Tsel] = Remv_TimeWind(signals_framed, i)
    global AxTFrames AxTFrames_base select_time
    sel_time = [select_time(i), select_time(i+1)];
    % Индексы времени
    indx = (AxTFrames_base > sel_time(1)) & (AxTFrames_base < sel_time(2));
    in_Tsel_min = find(indx==1,1);
    in_Tsel_max = find(indx==1,1,'last');
    AxTFrames = AxTFrames_base(in_Tsel_min : in_Tsel_max);  % Выборка времени наблюдения
    % Выборка времени
    signals_framed = signals_framed(in_Tsel_min:in_Tsel_max, :);   % Выборка времени наблюдения
    idx_sel_Tsel = [in_Tsel_min, in_Tsel_max];    % Индексы просматриваеммого периода времени
end

% Выборка дальностей
function [signals_framed, idx_sel_Dist] = Remv_DstTime(signals_framed)
    global AxDistance remove_dist
    indx = (AxDistance > remove_dist(1)) & (AxDistance < remove_dist(2));
    in_dst_min = find(indx==1,1);
    in_dst_max = find(indx==1,1,'last');
    % Выборка дальностей
    signals_framed(:,~indx) = 0;    % Исключение заданных помеховых дальностей
    idx_sel_Dist = [in_dst_min, in_dst_max];    % Индексы просматриваеммых дальностей
end

% Вывод информации
function print_text(AutoSaveFolder, numfile, describe)
    global Al_fl_name Alarms Algorithms_name TypeRadar Tmodel Fs Noiseamp AxTFrames
    if logical(exist(Al_fl_name, 'file'))
        type_thr = sprintf('threshold from file');
    else
        type_thr = sprintf('threshold from input');
    end
    % Уровни обнаружения вывод
    cellls_table = NaN(10, length(Alarms));
    cellls_table(1,:) = Alarms;
    cellls_table(2,1) = Fs;
    cellls_table(3,1) = TypeRadar;
    cellls_table(4,1:2) = [AxTFrames(1), AxTFrames(end)];
    cellls_table(5,1) = Noiseamp;
    cellls_table(6,1) = str2double(numfile);
    cellls_table(7,1) = NaN;
    cellls_table(8,:) = NaN;
    cellls_table(9,1) = NaN;
    cellls_table(10,:) = NaN;
    Aldisp = array2table(cellls_table,...
        'VariableNames',Algorithms_name,...
        'RowName',{'Alg_th_value', 'Fs', 'Type_radar', 'Period sec', 'Noise_amp','File_num', ...
                    describe, type_thr,  's', 'line'});
    % Вывод значений в консоль
    disp(Aldisp);
    % Запись файл
    filename = sprintf('%s\\!_thrs_alarms_t%.3f.mat', AutoSaveFolder,Tmodel);
    save(filename, 'Alarms')
    filename = sprintf('%s\\!_info.mat',AutoSaveFolder);
    save(filename, 'Aldisp')
    fileID = fopen(sprintf('%s\\%s.txt',AutoSaveFolder, describe),'w','n','UTF-8');
    fwrite(fileID, describe);
    fclose(fileID);
end





