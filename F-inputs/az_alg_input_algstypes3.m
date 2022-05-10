% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [nameFolder] = az_alg_input_algstypes3()
    global Fs Algorithms
    
    %% Параметры алгоритмов
    nameFolder = 'algstypes3';
    wlevels=5;                  % Количество уровней декомпозиции
    Fbr = 0.2;
    nbin = round(Fs/(Fbr*4));   % кол-во отсчетов в pi/4 периода дыхания
    advParam = [0, 2, 1e5];
    Algorithms={
        'FFT',      'TFD',     'Cov',     'Var',    'SsFT',     'WT-coif4',     'WT-old-coif4',     'WT-thr1-coif4',    'WT-thr2-coif4',    'HHT',      'HHT-old',      'HHT-thr1',     'HHT-thr2',     'STFT',     'pyulear-1ord'  ;...
        'FFT',      'TFD',     'Cov',     'Var',    'SsFT',     'WT',           'WTold',            'WTthr',            'WTthr2',           'HHT',      'HHTold',       'HHTthr',       'HHTthr2',     'STFT',     'Paramet'       ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,          1,          0,        1,        0,          1,              1,                  1,                  1,                  1,          1,              1,              1,              0,          1               ;...
        [],         [],         [],       [],       [],         'coif4',        'coif4',            'coif4',            'coif4',            [],         [],             [],             [],             [],         'pyulear'       ;...
        [],         [],         [],       [],       [],         wlevels,        wlevels,            wlevels,            wlevels,            [],         [],             [],             [],             [],         []              ;...
        [],         [nbin],     [],       [],       [],         [],             advParam,           advParam,           advParam,           advParam,   advParam,       advParam,       advParam,       [],         {1, 'twosided'}
        };
end
