% Формирование массивов, сеток частот, фильтров и cfar
function [AutoSaveFolder]=F_variables(Prog_mode, AutoSaveFolder)
    global FilterSign Fcut Forder f_band fRes CFAR TypeRadar
    global nF FrameT df Fs lpFilt cfarWin f1 f2 f1_grid_bin f2_grid_bin
    global nK
    global AxTSamp dr AxDistance  AxTFrames AxFreqs Algorithms_v nAlgorithms nAlgorithmsAll AlgorithmsIndx...
    Algorithms_all_type Algorithms_name AxTFrames_base nK_base Tmodel idx_sel_Dist idx_sel_Tsel Algorithms_name_filt
    global Algorithms_type
    
    
    % Автосохранение файлов
    AutoSaveFolder = [pwd AutoSaveFolder];
    % Параметры
    [nK, nF, FrameT, df, Fs] = F_Radar(TypeRadar);
    res = Arguments(Prog_mode);
    if strcmp(Prog_mode, 'model')
        [AxTSamp, dr, AxDistance, AxTFrames, AxFreqs, Algorithms_v, nAlgorithms, nAlgorithmsAll, AlgorithmsIndx, Algorithms_type, Algorithms_name,...
            nK, nK_base, Tmodel, AxTFrames_base, idx_sel_Tsel] = res{1,1:end};
    elseif strcmp(Prog_mode, 'real')
        [AxTSamp, dr, AxDistance, AxTFrames, AxFreqs, Algorithms_v, nAlgorithms, nAlgorithmsAll, AlgorithmsIndx, Algorithms_type, Algorithms_name,...
            nK, nK_base, AxTFrames_base, idx_sel_Dist, idx_sel_Tsel] = res{1,1:end};
        if TypeRadar > 2
            error("Err::: For real signals TypeRadar = %d, but cant be > 2", TypeRadar);
        end
    end
    Algorithms_name_filt = {Algorithms_name{(logical(Algorithms_v))}};
    Algorithms_all_type = unique(Algorithms_name);
    lpFilt = ProduceFilter(FilterSign, Fcut, Forder, Fs);
    [cfarWin, f1, f2, f1_grid_bin, f2_grid_bin] = Objects(f_band, fRes, CFAR, nK, Fs);
end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Функции
function [nK, nF, FrameT, df, Fs] = F_Radar(TypeRadar)
    if TypeRadar==1
        % Данные Радара 1
        nK=256;
        nF=376;
        FrameT = 0.2;   % Период кадра
        df=4e6;         % шаг изменения частоты
        Fs=1/FrameT;    % Частота следования кадров
    elseif TypeRadar==2
        % Данные Радара 2
        nK=450;
        nF=350;
        FrameT = 0.1;   % Период кадра
        df=4e6;         % шаг изменения частоты
        Fs=1/FrameT;    % Частота следования кадров
    elseif TypeRadar==3
        % Данные Радара 3 моделирования больше частота дискретизации
        nK=450;
        nF=350;
        FrameT = 0.05;   % Период кадра
        df=4e6;         % шаг изменения частоты
        Fs=1/FrameT;    % Частота следования кадров
    else
        error('TypeRadar');
    end
end

% Второстепенные аргументы
function res = Arguments(Prog_mode)
    global Fs remove_dist select_time Algorithms FrameT nF df nK
    
    AxTSamp=linspace(0,FrameT,nF);              % Отсчеты временни сигнала
    dr   = 3.0e8/(2*nF*df);                     % разрешающая способность по дальности
    AxDistance=0:dr:dr*(nF-1);                  % Сетка дальности
    AxTFrames=linspace(0,FrameT*(nK-1),nK);     % Отсчетов времени по кадрам
    if strcmp(Prog_mode, 'model')
        if length(select_time)>2
            select_time = [select_time(1), select_time(2)];
        end
        Tmodel = select_time(2) - select_time(1);
        [nK_base, nK, AxTFrames_base, AxTFrames, idx_sel_Tsel] = AxTFrames_TimeWind(AxTFrames, select_time, nK);
    elseif strcmp(Prog_mode, 'real')
        [nK_base, nK, AxTFrames_base, AxTFrames, idx_sel_Tsel] = AxTFrames_TimeWind(AxTFrames, select_time, nK);
        [idx_sel_Dist] = AxDistance_DstWind(AxDistance, remove_dist);
    end
    AxFreqs=(-nK/2:nK/2-1)/nK*Fs;
    Algorithms_v=[Algorithms{3,:}];
    nAlgorithms=sum(Algorithms_v);        % Кол-во используемых алгоритмов
    nAlgorithmsAll=length(Algorithms_v);  % Общее кол-во алгоритмов
    AlgorithmsIndx=find(Algorithms_v);
    Algorithms_name=Algorithms(1,:);
    Algorithms_type=Algorithms(2,:);
    % Вывод
    if strcmp(Prog_mode, 'model')
        res = {AxTSamp, dr, AxDistance, AxTFrames, AxFreqs, Algorithms_v, nAlgorithms, nAlgorithmsAll, AlgorithmsIndx, Algorithms_type, Algorithms_name,...
            nK, nK_base, Tmodel, AxTFrames_base, idx_sel_Tsel};
    elseif strcmp(Prog_mode, 'real')
        res = {AxTSamp, dr, AxDistance, AxTFrames, AxFreqs, Algorithms_v, nAlgorithms, nAlgorithmsAll, AlgorithmsIndx, Algorithms_type, Algorithms_name,...
            nK, nK_base, AxTFrames_base, idx_sel_Dist, idx_sel_Tsel};
    end
end

% Переформатирование осей для первоначальнйо выборки
function [nK_base, nK, AxTFrames_base, AxTFrames, idx_sel_Tsel] = AxTFrames_TimeWind(AxTFrames, select_time, nK)
    nK_base = nK;
    AxTFrames_base = AxTFrames;
    indx = (AxTFrames_base > select_time(1)) & (AxTFrames_base < select_time(2));
    in_Tsel_min = find(indx==1,1);
    in_Tsel_max = find(indx==1,1,'last');
    AxTFrames = AxTFrames_base(in_Tsel_min : in_Tsel_max);  % Выборка времени наблюдения
    nK = length(AxTFrames);
    idx_sel_Tsel = [in_Tsel_min, in_Tsel_max];    % Индексы просматриваеммого периода времени
end

function [idx_sel_Dist] = AxDistance_DstWind(AxDistance, remove_dist)
    indx = (AxDistance > remove_dist(1)) & (AxDistance < remove_dist(2));
    in_dst_min = find(indx==1,1);
    in_dst_max = find(indx==1,1,'last');
    % Выборка дальностей
    idx_sel_Dist = [in_dst_min, in_dst_max];    % Индексы просматриваеммых дальностей
end

% Предварительный лоу пасс
function lpFilt = ProduceFilter(FilterSign, Fcut, Forder, Fs)
if strcmp(FilterSign, 'on')
    lpFilt = designfilt('lowpassfir', ...   % Response type
        'FilterOrder',Forder, ...               % Filter order
        'CutoffFrequency',Fcut, ...         % Frequency constraints
        'DesignMethod','window', ...        % Design method
        'SampleRate',Fs);                   % Sample rate
elseif strcmp(FilterSign, 'off')
    lpFilt = [];
else
    error('Incorrect FilterSign Input value');
end
end

% Создание фильтров, пороговых уровней
function [cfarWin, f1, f2, f1_grid_bin, f2_grid_bin] = Objects(f_band, fRes, CFAR, nK, Fs)
% Создание CFAR
refLength=CFAR(1,1);
guardLength=CFAR(1,2);
cfarWin=ones((refLength+guardLength)*2+1,1);
cfarWin(refLength+1:refLength+1+2*guardLength)=0;
cfarWin=cfarWin/sum(cfarWin);
% Сетка частот FFT
f2 = Fs*(0:(nK/2))/nK;      % Сетка значений частот
f2_grid_bin=ones(1,numel(f2))';
f2_grid_bin(f2<f_band(1,1) | f2>f_band(1,2))=NaN;   % Сетка частот по которым работает обнаружитель
% Разрешение алгоритмов с декомпозицией
FRange = [0;Fs/2];
if isempty(fRes)
    FResol = (FRange(2)-FRange(1))/(numel(f2)-1);   % Для разрешения в соответсвии FFT
else
    FResol = (FRange(2)-FRange(1))/fRes;  % Для заданного разрешения
end
% Сетка частот алгоритмов с декомпозицией
f1 = (FRange(1):FResol:FRange(2))';             % Сетка значений частот
f1_grid_bin=ones(1,numel(f1));
f1_grid_bin(f1<f_band(1,1) | f1>f_band(1,2))=NaN;  % Сетка частот по которым работает обнаружитель
end