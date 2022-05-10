% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_fk(AutoSaveFolder)
    global Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(fk)', AutoSaveFolder);
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-fk4',       'WT-fk6',   'WT-fk8',   'WT-fk14',  'WT-fk18',  'WT-fk22',  ;...
        'WT',           'WT',       'WT',       'WT',       'WT',       'WT',       ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,          1,          1,          1,          1,          ;...
        'fk4',          'fk6',      'fk8',      'fk14',     'fk18',     'fk22',     ;...
         wlevels,       wlevels,    wlevels,    wlevels,    wlevels,    wlevels,    ;...
        [],             [],         [],         [],         [],         [],                
        };
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)

end
