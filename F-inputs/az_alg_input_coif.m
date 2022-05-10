% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_coif(AutoSaveFolder)
    global Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(coif)', AutoSaveFolder);
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-coif1', 'WT-coif2',  'WT-coif3', 'WT-coif4', 'WT-coif5', ;...
        'WT',       'WT',         'WT',       'WT',       'WT',   ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,          1,            1,          1,          1,      ;...
        'coif1',    'coif2',    'coif3',    'coif4',     'coif5', ;...
         wlevels,   wlevels,    wlevels,    wlevels,    wlevels,  ;...
        [],         [],         [],         [],         [],       
        };
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)

end
