% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_rbio(AutoSaveFolder)
    global fRes Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(rbio)', AutoSaveFolder);
    fRes=400;                           % Частотное разрешение для алгоритмов с декомпозицией (Если [] то в соответвии с FFT)
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-rbio 1.1', 'WT-rbio 1.3',    'WT-rbio 1.5',     'WT-rbio 2.2',     'WT-rbio 2.4',   'WT-rbio 2.6',  'WT-rbio 2.8',  'WT-rbio 3.1',  'WT-rbio 3.3',  'WT-rbio 3.5',  'WT-rbio 3.7',  'WT-rbio 3.9',  'WT-rbio 4.4',  'WT-rbio 5.5',  'WT-rbio 6.8',  ;...
        'WT',           'WT',           'WT',               'WT',               'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,              1,                  1,                  1,              1,              1,              1,              1,              1,              1,              1,              1,              1,              1,              ;...
        'rbio 1.1',     'rbio 1.3',     'rbio 1.5',         'rbio 2.2',         'rbio 2.4',     'rbio 2.6',     'rbio 2.8',     'rbio 3.1',     'rbio 3.3',     'rbio 3.5',     'rbio 3.7',     'rbio 3.9',     'rbio 4.4',     'rbio 5.5',     'rbio 6.8',     ;...
         wlevels,       wlevels,        wlevels,            wlevels,            wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        ;...
        [],             [],             [],                 [],                 [],             [],             [],             [],             [],             [],             [],             [],             [],             [],             [],             
        };
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)

end
