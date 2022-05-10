% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_wavelets(AutoSaveFolder)
    global fRes Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets', AutoSaveFolder);
    fRes=400;                           % Частотное разрешение для алгоритмов с декомпозицией (Если [] то в соответвии с FFT)
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-bior 6.8',  'WT-coif3', 'WT-coif4',     'WT-db8',  'WT-fk4',   'WT-dmey', 'WT-rbio 6.8',   'WT-sym7'   ;...
        'WT',           'WT',       'WT',           'WT',       'WT',       'WT',      'WT',            'WT'        ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,          1,              1,          1,          1,          1,              1,          ;...
        'bior 6.8',    'coif3',     'coif4',        'db8',    'fk4',       'dmey',     'rbio 6.8',     'sym7'          ;...
         wlevels,       wlevels,    wlevels,        wlevels,    wlevels,    wlevels,    wlevels,        wlevels     ;...
        [],             [],         [],             [],         [],         [],         [],             []      
        };
    % db'30', db'8' , sym'12' sym>9 дольше вычисляются

end
