% Моделирование сигнала радара
% 3 типа моделей 1-циклостационарность, 2-псвгармонгич, 3-реальный сигнал
function [DSpecMBank, SignalM, Noise, Esignal, Enoise, SNRnow] = F_modelling(DSpecMBank, iModel)
    global Type_br_mod Model_singl Model_diap ModelType AxTFrames Noiseamp
    % Вычисление параметров модели дыхания для циклостационарности
    if strcmp(Type_br_mod, 'diap')
        ModelVars(1,1:8)=RandomModelParametrs(Model_diap(1,1:8),Model_diap(2,1:8));   % Задавать как интервал, или как диапазон от введенных значений
    elseif strcmp(Type_br_mod, 'singl')
        ModelVars(1,1:8)=Model_singl(1,1:8);    % Модель с заданными значениями
    else
        error('Incorrect value of Model signal type')
    end
    ModelParametrs(ModelVars);      % Обьявление параметров модели
    %% Моделирование сигнала дыхания
    Fase = ((-1) + (1 + 1) * rand(1)) * 1 * pi;
    if strcmp(ModelType, 'CycleStationarity')
        [SignalM]=ModelLoadSignals(Fase);  % циклостационарность
    elseif strcmp(ModelType, 'Garmonic')
        [SignalM]=ModelLoadSignals2(Fase); % псвгармоническая
    elseif strcmp(ModelType, 'Signal Experement')
        [SignalM]=ModelLoadSignals3(); % псвгармоническая
    end
    % Выборка времени
    [SignalM, ~] = Remv_TimeWind(SignalM);  
    % Нормирование
    SignalM = SignalM./max(SignalM); % Нормирование смоделированного сигнала
%     SignalM = SignalM - mean(SignalM);
    %% Моделирование шума
    Noise = Noiseamp .* randn(size(SignalM));
    % Нормирование
%     Noise = Noise./max(Noise); % Нормирование смоделированного сигнала
%     Noise = Noise - mean(Noise);
    %% Вычисление энергий и SNR
    Esignal = sum(abs(SignalM).^2);
    Enoise = sum(abs(Noise).^2);
    SNRnow = Esignal/Enoise;
    % Графика
%     plot(AxTFrames, SignalM, AxTFrames, Noise)
%     xlabel('Time [s]')
%     ylabel('Amp')
%     legend('Breathe model', 'Noise model')
%     title(sprintf('Model, SNR: %f', SNRnow));
    % Привести к SNR=1
%     koef = 1/SNRnow;
%     SignalM = SignalM.*sqrt(koef);
%     Esignal = sum(abs(SignalM).^2);
%     SNRnow = Esignal/Enoise;
    % В db
%     SNRnow2_db = snr(SignalM,Noise);
%     SNRnow2 = db2pow(SNRnow2_db);
    % Запись сигнала в банк моделей
    DSpecMBank(:,iModel)=SignalM;    % Запись модели в банк
end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Функции
function [signals_framed, idx_sel_Tsel] = Remv_TimeWind(signals_framed)
global AxTFrames AxTFrames_base select_time
% Индексы времени
indx = (AxTFrames_base > select_time(1)) & (AxTFrames_base < select_time(2));
in_Tsel_min = find(indx==1,1);
in_Tsel_max = find(indx==1,1,'last');
AxTFrames = AxTFrames_base(in_Tsel_min : in_Tsel_max);  % Выборка времени наблюдения
% Выборка времени
signals_framed = signals_framed(in_Tsel_min:in_Tsel_max, :);   % Выборка времени наблюдения
idx_sel_Tsel = [in_Tsel_min, in_Tsel_max];    % Индексы просматриваеммого периода времени
end

% Моделирование сигнала радара
function [x]=RandomModelParametrs(Min,Max)
% Случайные параметры
x=zeros(1,8);
[x(1,1)]=randinterval(Min(1,1),Max(1,1));       % средняя частота дыхания
[x(1,2)]=randinterval(Min(1,2),Max(1,2));     % средняя амплитуда дыхани
[x(1,3)]=randinterval(Min(1,3),Max(1,3));         % уровень низкочатотного шума
[x(1,4)]=randinterval(Min(1,4),Max(1,4));     % диапазон изменения частоты дыхания
[x(1,5)]=randinterval(Min(1,5),Max(1,5));    % частота изменения частоты дыхания
[x(1,6)]=randinterval(Min(1,6),Max(1,6));     % диапазон изменения амплитуды дыхания
[x(1,7)]=randinterval(Min(1,7),Max(1,7));     % частота изменения частоты дыхания
[x(1,8)]=randinterval(Min(1,8),Max(1,8));         % параметр негармоничности
end

function [r]=randinterval(a,b)
% Cлучайные числа в пределах интервала
r = a + (b-a).*rand(1,1);
end

function ModelParametrs(ModelVars)
global Fs nK_base dt tx fr ar snr dfr ffr dar far p0
dt=1/Fs;
tx=nK_base*(dt);
    fr   = ModelVars(1,1);     % средняя частота дыхания
    ar   = ModelVars(1,2);     % средняя амплитуда дыхани
    snr  = ModelVars(1,3);     % уровень низкочатотного шума
dfr  = ModelVars(1,4)*fr;  % диапазон изменения частоты дыхания
ffr  = ModelVars(1,5);    % частота изменения частоты дыхания
dar  = ModelVars(1,6)*ar;  % диапазон изменения амплитуды дыхания
far  = ModelVars(1,7);     % частота изменения частоты дыхания
p0   = ModelVars(1,8);     % параметр негармоничности 
end

% Модель циклостационарность
function [X]=ModelLoadSignals(Fase)
global nK_base tx dt fr ar snr dfr ffr dar far p0
% tx длительность временного интервала (сек)
% dt период дискретизации времени
%% Расчёт дополнительных параметров
T   = 0:dt:tx-dt;       % массив отсчётов времени
nT  = nK_base;
%% Расчёт процесса дыхания
FT = fr*ones(1,nT)+dfr*sin(2*pi*ffr.*T+2*pi*rand(1,1)); % значения частот
% PHT = cumsum(FT)*dt*2*pi;
AT = ar*ones(1,nT)+dar*cos(2*pi*far.*T+2*pi*rand(1,1)); % значения амплитуд
% X  = AT.*sin(2*pi.*FT.*T);           % процесс дыхания без шума
% X  = AT.*sin(PHT);           % процесс дыхания без шума
X  = AT.*sin(2*pi*cumsum(FT)*dt - Fase);           % процесс дыхания без шума
x_max = abs(max(X));
YS   = sinc(-10:0.1:10);
Nois = conv(randn(1,nT),YS,'same');  % низкочастотный шум
Nois = Nois/max(Nois);
X = X + snr*x_max*Nois; % добавление низкочастотного шума
for ix = 1:nT
    X(ix) = X(ix)*(p0^(sign(X(ix))-1));
end
X = abs(min(X)) + X';
% plot(X);
end

% Модель псвгармоническая
function [X]=ModelLoadSignals2(Fase)
global tx dt fr
T   = 0:dt:tx-dt;       % массив отсчётов времени
f0 = fr;
Signal = sin(2 * pi * f0 * T - Fase);
Signal(Signal < 0) = 0;
Signal = smoothdata(Signal .^5, 'gaussian');
% Signal = exp(1i * 2 * pi * f0 .* (T + Fase));
% Signal = complex(real(Signal) .^ 5, imag(Signal) .^ 5);
% plot(T, Signal)
X = abs(real(Signal));
X = X';
end

% Модель реальный сигнал
function [X]=ModelLoadSignals3()
global Fs Mode3_file
Signal = Mode3_file.model.signal;  
Fs_Signal = Mode3_file.model.fs;
% Изменение частоты дескритизации
if Fs==Fs_Signal
    Signal_sam = Signal;
else
    Signal_sam = resample(Signal,Fs,Fs_Signal);
end
% сделать выборку
% L_Signal = length(Signal_sam);
% if strcmp(Model3_st, 'rand')
%     max_st = L_Signal - nK;
%     indx_st = randi([0,max_st]);
% else
%     max_st = 1/Fmax_Signal*1/4;
%     [ind_Phase] = Index_Minimal(max_st,AxTFrames);
%     indx_st = randi([Model3_st,Model3_st+ind_Phase]);
% end
% Signal_cut = Signal_sam(indx_st:indx_st+nK-1,1);
% Фильтрация
% F_cut1 = 0.1;
% F_cut2 = 1;
% lpFilt2 = designfilt('bandpassfir', ...     % Response type
%         'FilterOrder',8, ...               % Filter order
%         'CutoffFrequency1',F_cut1,...          % Frequency constraints
%         'CutoffFrequency2',F_cut2, ...        
%         'DesignMethod','window', ...        % Design method
%         'SampleRate',Fs);                   % Sample rate
% Signal_cut_shift_f = filtfilt(lpFilt2,Signal_cut);   % Степень фильтра ограничивает кол-во входных отсчетов%% Детренд
X = Signal_sam;
% X = X';
end

% function [indx] = Index_Minimal(val,arr)
%     array = abs(arr-val);
%     indx = find(array==min(array));
% end