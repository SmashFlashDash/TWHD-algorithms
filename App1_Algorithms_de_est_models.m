clearvars;
global nK nModels nAlgorithmsAll nSNRa SNRarray Algorithms_v AlgorithmsIndx Al_fl_name ConstantPart Noiseamp graphs typeAlarmCalculation
close all;
% При моделировании шума для выбора уровня тревог не измерять энергию и не нормировать шум
% При моделировании сигнал+шум вычисляется энергия сигнала и шума
% Вычисляется коэф на которы надо домножить сигнал чтобы изменить snr
% Реализация с разными snr прогоняется по алгоритмам
% Подсчет характеристики ложной трвеоги и вывод в комнадное окно
% Подсчет храрактеристики обнаружения и вывод на график
    
    % надо ли у модели вычитать средее
    % сделать модели всех вейвлетов
    % выбрать лучшие вейвлеты
    % промоделировать лучшие партию вейвлетов на разных TypeRdar Tmodel SingalModel
    % промоделировать лучшие вейвлеты на разных TypeRdar Tmodel SingalModel 
    % промоделировать лучшие вейвлеты на WTold
    % првоерить что названия графиков праивльно печатаются алгоритмы
    % добавить вычет среднего из модели сигнала потому что шум без среднего
    % в figs сделать чтбы сбрасывлась y ось
    % F_GraphicsRLImage при graphs=2 отредактировать
    % F_GraphicDetectors при graphs=2 отредактировать
% Отредактить алгоритмы var wt-fft-cfar wt hht fft stft pmusic
    % Оцнка обнаружения алгоритмом, при вычесленном уровне обнаружния 
    % Прогнать при фиксированном SNR с+ш, ш, получится вероятность ПО, вероятность ЛТ
    % Вычислсить примерную ээфективность алгоритма
    % Прогнать при изменении SNR с+ш, ш, получится вероятность ПО, вероятность ЛТ
% Оценка схожести сигнала и модели оставить обнаруженный сигнал из смоделированного
% скорелировать с моделью
    % Другой скрипт для фиксированной прогонки

    % Промоделировать все параметрик алгоритмы
    % промоделировать wt и hht с разными исключениями diff imf
    % или заменить diff imf на var fimf
    % добавить eemd и vmd
    % сделать прогу в которой детектированный сигнал выделяется, и
    % сравнивается с полезной моделью коэффициентом корреляции

    % переделать гармонич модель на выше среднего значение
    

% Составить App_Input для каждого вида вейвлетов и прогнать

% Ссоставить модель как радиолокационную картину с фикс частотой изменение SNR
% Ссоставить модель как радиолокационную картину с фикс SNR изменение частотой

% обьединить моды если средня часстота отличается менее 0,5

% сделать алгоритм кореляции предыдущей дальности со след дальностью

% сделать чтобы autosave определялся в az_algotiyhms_type
% потом дописывались значения из az_input

%% Входные данные
Prog_mode='model';                  % ['model'-модели 'real'-реальные сигналы] не менять
Al_fl_name = '';
graphs_noise_model = 1;             % 0 - скрыть 1 - показать графики реализаций моделей шума
graphs_noise_detections = 1;        % 0 - скрыть 1 - показать графики вычисленных пороговых уровней
graphs_every_model = 0;             % 0 - скрыть 1 - показать моделей сигнал+шум
AutoSaveFolder = sprintf('\\Autosave_Models');
describe = 'Модель';




% az_alg_input_thr();    % параметры алгоритмов
% az_alg_input_experiments();
% az_alg_input_parametric()
% az_alg_input_parametric_2()
% subFolder1 = az_alg_input_algstypes();    % параметры алгоритмов
% subFolder1 = az_alg_input_algstypes2();    % параметры алгоритмов
subFolder1 = az_alg_input_algstypes3();    % параметры алгоритмов
subFolder2 = az_input(Prog_mode);    % остальные параметры
graphs = 0;
typeAlarmCalculation = 2;
%% Массивы и обьекты для вычислений
AutoSaveFolder = F_variables(Prog_mode, AutoSaveFolder);
F_reset_ax_figs()
%% Вычислиить или загрузить проговые уровни алгоритмов
get_Alarm_Levels(typeAlarmCalculation, 0, graphs_noise_model, graphs_noise_detections);
F_reset_ax_figs()
pause(2);
% F_saveallfigs(AutoSaveFolder);
% close all

%% Начало моделирования с+ш
ModelVars=NaN(1,8);                 % Массив параметров моделирования полезного сигнала
DSpecMBank=NaN(nK,nModels);         % Массив с моделями сигналов
Detections=NaN(nAlgorithmsAll,1);   % Массив обнаружений
DetectionsSignSignalNoise=NaN(nAlgorithmsAll,nModels,nSNRa);
DetectionsSignNoise=NaN(nAlgorithmsAll,nModels,nSNRa);
% DetectionsSignNoise=NaN(nAlgorithmsAll,nModels);
Esignal = NaN(nModels,nSNRa);
TypeSignal='signal+noise';   % Параметр для F_Detector чтобы определить что поступил сигнал+шум
%% Цикл моделирования сигнала
for iModel=1:nModels
    [DSpecMBank, Signal, Noise, Es_prev, Enoise, SNR_prev] = F_modelling(DSpecMBank, iModel);
    Signal_loop = Signal;
    %% Цикл изменения SNR и использование алгоритмов
    tic;
    for iSNR=1:nSNRa
        % Изменить энергию сигнала чтобы привести к SNRi
        SNRi = SNRarray(iSNR);
        koef = SNRi/SNR_prev;
        Signal_loop = Signal.*sqrt(koef);
        Esignal = sum(abs(Signal_loop).^2);
        SNR = Esignal/Enoise;
        % Зашумлени
        Signal_noised = Signal_loop + Noise + ConstantPart;
        % Вывод отношения c/ш нескольких моделей и Вывод соответсвия SNR
        graphics_iModel(Signal_loop, Noise, Signal_noised, iSNR, koef, SNR, SNRi, iModel, graphs_every_model);
        % Алгоритмы сигнал+шум
        [Detections,~] = F_Algorithms(Signal_noised, graphs, TypeSignal, iModel,nModels,iSNR,nSNRa,SNR,koef,Signal_loop,Noise);
        DetectionsSignSignalNoise(:,iModel,iSNR)=Detections(1,:);   % Запись решений алгоритмов в массивы
         % Алгоритмы шум
        Noise_iter = Noiseamp .* randn(size(Signal_noised));
        [Detections_Noise,~] = F_Algorithms(Noise_iter, 0, TypeSignal, [],[],[],[],[],[],[],[]);
        DetectionsSignNoise(:,iModel,iSNR)=Detections_Noise(1,:);   % Запись решений алгоритмов в массивы
    end
    toc;
    fprintf('Algorithms processed Model %d/%d\n',iModel, nModels);
end
pause(2);
% F_saveallfigs(AutoSaveFolder);
% close all


%% Оценка вероятности правильного обнаружения и ложной тревоги
Prob_Detection = zeros(sum(Algorithms_v),nSNRa);
Prob_FalseAlarm = zeros(sum(Algorithms_v),1);
% for inA=1:length(AlgorithmsIndx)
%     Prob_Detection(inA,:) = sum(DetectionsSignSignalNoise(inA,:,:))./nModels;
%     Prob_FalseAlarm(inA,:) = sum(sum(DetectionsSignNoise(inA,:,:)))./(nModels*nSNRa);
% end
iter = 0;
for inA=AlgorithmsIndx
    iter = iter+1;
    Prob_Detection(iter,:) = sum(DetectionsSignSignalNoise(inA,:,:))./nModels;
    Prob_FalseAlarm(iter,:) = sum(sum(DetectionsSignNoise(inA,:,:)))./(nModels*nSNRa);
end


%% Очистить или создать dir
% сделать основную папку Autosave_Models_algtypes\\под папки
isDirMaked = false;
FolderBase = AutoSaveFolder(1:end-1);
for i = 1 : 10
    AutoSaveFolder = [FolderBase ' ' subFolder1 '\' subFolder2 '_' num2str(i) '\'];
    if not(exist([AutoSaveFolder], 'dir'))
        isDirMaked = true;
        mkdir(AutoSaveFolder)
        break
    end
end
if not(isDirMaked)
    AutoSaveFolder = [FolderBase subFolder1 '\' subFolder2 '_temp' '\'];
    try
        rmdir(AutoSaveFolder, 's');
    catch
    end
    mkdir(AutoSaveFolder);
end


%% Отображение в командной строке
print_text(Prob_FalseAlarm, AutoSaveFolder)
%% Графика вероятностей обнаружений алгоритмов
graphics_detections(Prob_Detection, Prob_FalseAlarm)
graphics_models(DSpecMBank, 20)
F_saveallfigs(AutoSaveFolder);
pause();
close all;











%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Функции
% Расчет уровня тревог
function get_Alarm_Levels(typeAlarmCalculation, graphs, graphs_noise_model, graphs_noise_detections)  
    global Al_fl_name NFest Noiseamp nK Tmodel nAlgorithmsAll nFalseAlarms AlgorithmsIndx Fest
    global Alarms
    file_name=Al_fl_name;
    if logical(exist(file_name, 'file'))
        % Уровень тревог из файла
        Alarms=load(file_name);
        Alarms=Alarms.Alarms;
    else
        % Уровень тревог вычисление
        LevelsArray=NaN(nAlgorithmsAll,NFest);      % Массив амплитуд шума
        TypeSignal='noise';
        fprintf('Modeling noises to fix alarm thresholding')
        % Моделирование шума
        for iNFest=1:NFest
            Noise = Noiseamp .* randn(nK,1);        
            % Графика
            graphics_noise(3, Noise, iNFest, NFest*2, graphs_noise_model)   % Графика
            [LevelsArray(:,iNFest),~]=F_Algorithms(Noise,graphs,TypeSignal,[],[],[],[],[],[],[],[]);
            % Отображение в командной строке
            Enoise = sum(abs(Noise).^2);
            fprintf('Enoise %.3f\t',Enoise)
            fprintf('Noise Model %d/%d\n', iNFest, NFest);
        end
        % Расчет пороговых уровней алгоритмов
        Alarms = NaN(1, nAlgorithmsAll);    % Выбор порогового уровня
        plots = cell(1, nAlgorithmsAll);     % Графики
        for i=AlgorithmsIndx
            [Alarms(:,i), plots{:,i}] = calculateAlarmLevel(LevelsArray(i,:), Fest, NFest*Fest, typeAlarmCalculation);     
        end
        % Графики
        graphics_noise_detectors(plots, Alarms, LevelsArray, graphs_noise_detections)
    end
end

function [alarmLevel, plots] = calculateAlarmLevel(data, Fest, nFalseAlarms, typeAlarmCalculation)
    eps = 0;
    ins = 0;
    dataSorted = sort(data, 2, 'descend');  % Сортировка
    nbins = numel(data);
    data = data(:);
    
    switch (typeAlarmCalculation)
        case 1
            % вариант кол-во отсчетов от максимума
            alarmLevel = (dataSorted(:, nFalseAlarms))';      % Выбор порогового уровня
            x = false;
            y = false;
            bincenters = false;
            bincounts  = false;
        case 2
            % через аппроксимацию
            [hvals, binedges] = histcounts(dataSorted, nbins, 'Normalization', 'probability');
            bincenters = binedges(1 : end-1) + diff(binedges) / 2;
%             binwidth = binedges(2)-binedges(1); % Finds the width of each bin
%             p = polyfit(bincenters,hvals,20);
%             x = bincenters;
%             y = polyval(p, x);
            y = hvals;
            % Расчет уровня тревоги, накполение eps до Fest
            while(eps < Fest)
                eps = eps + y(end-ins);
                ins = ins + 1;
            end
            alarmLevel = bincenters(end - ins + 1);
            bincounts = hvals;
            x = false;
        case 3
            % через pdf
            isZeroInData = any(data < 0);
            if isZeroInData
                minim = abs(min(data));
                data = minim + data;
            end
            [hvals, binedges] = histcounts(dataSorted, nbins, 'Normalization', 'probability');
            bincenters = binedges(1 : end-1) + diff(binedges) / 2;
            binwidth = binedges(2)-binedges(1); % Finds the width of each bin
            pd = fitdist(data, "Gamma");
            q = icdf(pd,[0.01 0.99]); % three-sigma range for normal distribution
            x = linspace(q(1), q(2), nbins);
            dist = pdf(pd,x);
            y = 1/sum(dist) .* dist;
%             y = max(hvals) .* (dist ./ max(dist));
%             y = nbins * binwidth * pdf(pd,x) / nbins;
            if isZeroInData
                bincenters = bincenters - min(data);
            end
            % Расчет уровня тревоги, накполение eps до Fest
            while(eps < Fest)
                eps = eps + y(end-ins);
                ins = ins + 1;
            end
            alarmLevel = bincenters(end - ins + 1);
            bincounts = hvals;
            x = bincenters;
    end
    fprintf("Сумма: %.3f - %.3f\n", sum(y), sum(hvals))
    % Вывод
    plots = {{dataSorted}, {bincenters, bincounts}, {x, y}};
end


% Вывод инофрмации
function print_text(Prob_FalseAlarm, AutoSaveFolder)  
    global Al_fl_name Alarms Fs Fest NFest nModels nSNRa Tmodel Noiseamp Algorithms_name Algorithms_name_filt TypeRadar idx_sel_Tsel AxTFrames_base AlgorithmsIndx
    if logical(exist(Al_fl_name, 'file'))
        type_thr = sprintf('Prob_FA est_real from file');
    else
        type_thr = sprintf('Prob_FA est_real');
    end
    % Присвоим значения другим алгоритмам
    for i=AlgorithmsIndx
    end
    % Уровни обнаружения вывод
    cellls_table = NaN(10, length(Alarms));
    cellls_table(1,:) = Alarms;
    cellls_table(2,1) = Fs;
    cellls_table(3,1) = TypeRadar;
    cellls_table(4,1) = Tmodel;
    cellls_table(5,1) = Noiseamp;
    cellls_table(6,1) = Fest;
    cellls_table(7,1) = NFest;
    cellls_table(8,~(isnan(Alarms))) = Prob_FalseAlarm;
    cellls_table(9,1) = nModels*nSNRa;
    cellls_table(10,:) = NaN;
    Aldisp = array2table(cellls_table,...
        'VariableNames',Algorithms_name,...
        'RowName',{'Alg_th_value', 'Fs', 'Type_radar', 'T_model', 'Noise_amp','Prob_FA est', ...
                    'Prob_FA n_models', type_thr,  'Prob_FA n_models_real', 'line'});
    % Вывод значений в консоль
    disp(Aldisp);
    % Запись файла уровни обнаружений
    filename = sprintf('%s\\!_thrs_alarms_n%d_fest%.3f_t%.3f.mat', AutoSaveFolder, NFest, Fest, Tmodel);
    save(filename, 'Alarms')
    filename = sprintf('%s\\!_info.mat',AutoSaveFolder);
    save(filename, 'Aldisp')
end


% Графика моделей шума
function graphics_noise(num, Noise, iNFest, NFest, graphs_noise_model)
    global AxTFrames x y xd yd
    if iNFest <= num
        if graphs_noise_model == 1
            titl = sprintf('Noise realisation for thresholding Model %d of %d',iNFest, NFest);
            figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
            plot(AxTFrames, Noise);
            title(titl); legend('Noise'); xlabel('sec'); ylabel('amp');
        end
    end
end


% Графика обнаружений шума
function graphics_noise_detectors(plots, Alarms, LevelsArray, graphs_noise_detections)
    global AlgorithmsIndx Algorithms_name NFest x y xd yd
    if graphs_noise_detections == 1
        space = '   ';
        for i = AlgorithmsIndx
            dataSorted = plots{i}{1}{1};
            bincenters = plots{i}{2}{1};
            bincounts = plots{i}{2}{2};
            bincentersPDF = plots{i}{3}{1};
            bincountsPDF = plots{i}{3}{2};
            if islogical(bincenters) && islogical(bincentersPDF) % По соритровке
                % Гарфик отсортированный
                titl = sprintf('%s%sNoise Detections Sorted', Algorithms_name{i}, space);
                figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
                ax = newplot();
                stem(ax, dataSorted);
                set(ax, 'NextPlot', 'add');
                ax_xl = xlim;
                plot([ax_xl(1) ax_xl(2)],[Alarms(:,i), Alarms(:,i)], 'r--')
                F_change_ax_figs(5)
            elseif islogical(bincenters)==false && islogical(bincentersPDF) % По гистограмме
                % График обнаружения
                titl = sprintf('%s%sThreshold est', Algorithms_name{i}, space);
                figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
                ax = newplot();
                bar(ax, bincenters, bincounts, 1);
%                 xlim([0,1]);
                set(ax, 'NextPlot', 'add');
                ax_yl = ylim;
                plot([Alarms(:,i), Alarms(:,i)],[ax_yl(1) ax_yl(2)], 'r--')
                % Гарфик отсортированный
%                 titl = sprintf('%s%sNoise Detections Sorted', Algorithms_name{i}, space);
%                 figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
%                 ax = newplot();
%                 stem(ax, dataSorted);
%                 set(ax, 'NextPlot', 'add');
%                 ax_xl = xlim;
%                 plot([ax_xl(1) ax_xl(2)],[Alarms(:,i), Alarms(:,i)], 'r--')
                % сменить гарфики
                F_change_ax_figs(5)
            elseif islogical(bincenters)==false && islogical(bincentersPDF)==false % По плотности вероятности
                % График обнаружения
                titl = sprintf('%s%sThreshold est', Algorithms_name{i}, space);
                figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
                ax = newplot();
                stem(ax, bincenters, bincounts);
                set(ax, 'NextPlot', 'add');
                ax_yl = ylim;
                plot(ax, [Alarms(:,i), Alarms(:,i)],[ax_yl(1) ax_yl(2)], 'r--', 'LineWidth', 2);
                plot(ax, bincentersPDF, bincountsPDF, 'r-', 'LineWidth', 2);
                % Гарфик отсортированный
%                 titl = sprintf('%s%sNoise Detections Sorted', Algorithms_name{i}, space);
%                 figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
%                 ax = newplot();
%                 stem(ax, dataSorted);
%                 set(ax, 'NextPlot', 'add');
%                 ax_xl = xlim;
%                 plot([ax_xl(1) ax_xl(2)],[Alarms(:,i), Alarms(:,i)], 'r--');
                % сменить гарфики
                F_change_ax_figs(5)
            else
                error('');
            end
            F_reset_ax_figs()
        end
    end
end


% Графика первых nmods моделeй
function graphics_iModel(Signal, Noise, Signal_noised, iSNR, koef, SNR, SNRi, iModel, graphs_every_model)
    global AxTFrames nSNRa x y xd yd
    % Для децебелов
%     SNR_prev_db = (10*log10(SNR_prev));
%     koef_db = (10*log10(SNRarray(iSNR))) - SNR_prev_db;
%     SNR_db = koef_db + (10*log10(SNR_prev_db));
    logstr = {'False', 'True'};
    % Вывод соответсвия SNR на все модели
    if graphs_every_model == 1
        res = round(SNR,3) == round(SNRi,3);
        fprintf('%s, SNR == SNRi %.3f==%.3f\n', logstr{res+1}, SNRi, SNR);
    end
    % Вывод соответсвия SNR на 3 модели и графики
    if (iSNR==floor(nSNRa/nSNRa) || iSNR==floor(nSNRa/2) || iSNR==floor(nSNRa/1)) && iModel<=3
        res = round(SNR,3) == round(SNRi,3);
        fprintf('%s, SNR == SNRi %.3f==%.3f\n', logstr{res+1}, SNRi, SNR);
        titl = sprintf('z_Model=%d_SNR=%f', iModel, SNR);
        titl2 = sprintf('Model=%d, SNR=%f', iModel, SNR);
        figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
        plot(AxTFrames,Signal,AxTFrames,Noise,AxTFrames,Signal_noised);
        legend ('Signal', 'Noise','kSNR*Signal+Noise'); xlabel('Samples'),ylabel('Amp')
        title(titl2);
        F_change_ax_figs(3)
        if iSNR==floor(nSNRa/1) && iModel==3
            pause(2);
        end
    elseif(iModel==4)
        F_reset_ax_figs()
    end
    
end


% Графика характеристик обнаружений алгоритмов
function graphics_detections(Prob_Detection, Prob_FalseAlarm)  
    global SNRarray f_band nModels Tmodel Fest NFest Algorithms_name_filt AlgorithmsIndx FilterSign ModelType
    % Графики характеристик обнаружения
    titl = sprintf('zProbability Detection, nModels=%d, Fest=%f', NFest, Fest);
    figure('Name',titl,'NumberTitle','off','Position',[0 0 900 1080],'Units','pixels');
    % SNRarrayDb=mag2db(SNRarray);    % Перевод в децебеллы
    for inA=1:length(AlgorithmsIndx)
        plot(10*log10(SNRarray), Prob_Detection(inA,:,:));
%         semilogx(SNRarray,Prob_Detection(inA,:,:));
%         plot(SNRarray,Prob_Detection(inA,:,:));
        hold on;
    end
    hold off;
    grid on;
    title({['Вероятность обнаружения алгоритмов']; ...
        ['lppre_Filter = ', FilterSign, ', Detector Band = ', num2str(f_band(1)), '-', num2str(f_band(2)) ' [Hz],' ];...
        ['Pfa=',num2str(Fest),', ModelType = ',ModelType,', nModels = ',num2str(nModels), ', Tmodel = ',num2str(Tmodel),' [s]']})
    xlabel('SNR pow'), ylabel('PFd')
    xlim([-inf inf]), ylim([0 1])
    % Названия алгоритмов и вероятность FA
    alg_names_FA = cell(1, length(AlgorithmsIndx));
    for i=1:length(AlgorithmsIndx)
        text = sprintf('%s | FA=%.3f', Algorithms_name_filt{i}, Prob_FalseAlarm(i));
        alg_names_FA{i} = text;

    end
    legend(alg_names_FA)
end

% Графика моделей
function graphics_models(DSpecMBank, n)  
    global AxTFrames NFest
    titl = sprintf('zModel iterations, nModels=%d', NFest);
    figure('Name',titl,'NumberTitle','off','Position',[1080 400 400 400],'Units','pixels');
    plot(AxTFrames,DSpecMBank(:,1:n));
    title('Реализации модели дыхания');
end
