% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_meyr(AutoSaveFolder)
    global Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(meyr)', AutoSaveFolder);
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-dmey',  ;...
        'WT',       ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,          ;...
        'dmey',     ;...
        wlevels,    ;...
        [],                
        };
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)

end
