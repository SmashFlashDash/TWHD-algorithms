% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_sym(AutoSaveFolder)
    global fRes Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(sym)', AutoSaveFolder);
    fRes=400;                           % Частотное разрешение для алгоритмов с декомпозицией (Если [] то в соответвии с FFT)
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-sym2',    'WT-sym3',  'WT-sym4',    'WT-sym5',  'WT-sym6',  'WT-sym7',   'WT-sym8',     'WT-sym9',      'WT-sym10',         'WT-sym12',     'WT-sym14',     'WT-sym16',;...     'WT-sym18',   'WT-sym20',  ;...
        'WT',         'WT',       'WT',         'WT',       'WT',       'WT',        'WT',          'WT',           'WT',               'WT',           'WT',           'WT',      ;...     'WT',         'WT',        ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,            1,          1,             1,          1,          1,          1,             1,              1,                  1,              1,              1,         ;...     1,            1,           ;...
        'sym2',       'sym3',     'sym4',       'sym5',     'sym6',     'sym7',      'sym8',        'sym9',         'sym10',            'sym12',       'sym14',         'sym16',   ;...     'sym18',      'sym20',     ;...
        wlevels,      wlevels,    wlevels,      wlevels,    wlevels,    wlevels,     wlevels,       wlevels,        wlevels,            wlevels,        wlevels,        wlevels,   ;...     wlevels,      wlevels,     ;...
        [],           [],         [],           [],         [],         [],          [],            [],             [],                 [],             [],             [],        ;...     [],           [],                                
        };
    % sym25 - sym 45 долго считают
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)

end
