% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_bior(AutoSaveFolder)
    global Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(bior)', AutoSaveFolder);
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-bior 1.1', 'WT-bior 1.3',    'WT-bior 1.5',     'WT-bior 2.2',     'WT-bior 2.4',   'WT-bior 2.6',  'WT-bior 2.8',  'WT-bior 3.1',  'WT-bior 3.3',  'WT-bior 3.5',  'WT-bior 3.7',  'WT-bior 3.9',  'WT-bior 4.4',  'WT-bior 5.5',  'WT-bior 6.8',  ;...
        'WT',           'WT',           'WT',               'WT',               'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           'WT',           ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,              1,                  1,                  1,              1,              1,              1,              1,              1,              1,              1,              1,              1,              1,              ;...
        'bior 1.1',     'bior 1.3',     'bior 1.5',         'bior 2.2',         'bior 2.4',     'bior 2.6',     'bior 2.8',     'bior 3.1',     'bior 3.3',     'bior 3.5',     'bior 3.7',     'bior 3.9',     'bior 4.4',     'bior 5.5',     'bior 6.8',     ;...
         wlevels,       wlevels,        wlevels,            wlevels,            wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        wlevels,        ;...
        [],             [],             [],                 [],                 [],             [],             [],             [],             [],             [],             [],             [],             [],             [],             [],             
        };
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)
end
