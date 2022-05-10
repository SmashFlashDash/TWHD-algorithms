% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [nameFolder] = az_alg_input_algstypes2()
    global Fs Algorithms
    
    %% Параметры алгоритмов
    nameFolder = 'algstypes2';
    wlevels=5;                  % Количество уровней декомпозиции
    Fbr = 0.2;
    nbin = round(Fs/(Fbr*4));   % кол-во отсчетов в pi/4 периода дыхания
    advParam = [0, 2, 1e5];
    Algorithms={
        'FFT',      'TFD',     'Cov',     'Var',    'SsFT',     'WT-coif4',    'HHT',       'WTOld-coif4',  'HHTold',   'STFT',     'pyulear-1ord'  ;...
        'FFT',      'TFD',     'Cov',     'Var',    'SsFT',     'WTthr',       'HHTthr',    'WTOld',        'HHTold',   'STFT',     'Paramet'       ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,          1,          1,        1,        1,          1,             1,           1,              1,          1,          1               ;...
        [],         [],         [],       [],       [],         'coif4',       [],          'coif4',        [],         [],         'pyulear'       ;...
        [],         [],         [],       [],       [],         wlevels,       [],          wlevels,        [],         [],         []              ;...
        [],         [nbin],     [],       [],       [],         [0, 1],        [0, 1],      [0, 2],         [0, 2],     [],         {1, 'twosided'}
        };
end
