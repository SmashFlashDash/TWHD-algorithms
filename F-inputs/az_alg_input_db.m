% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_db(AutoSaveFolder)
    global Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(db)', AutoSaveFolder);
    wlevels=5;                          % Количество уровней декомпозиции
    Algorithms={
        'WT-db1-haar', 'WT-db2',    'WT-db3', 'WT-db4',     'WT-db5',   'WT-db6',   'WT-db7',   'WT-db8',   'WT-db9',   'WT-db10',      'WT-db12',      'WT-db14',      'WT-db16',   'WT-db18',   'WT-db20',   'WT-db25',   'WT-db30',   'WT-db35',   'WT-db40',   'WT-db45'     ;...
        'WT',           'WT',       'WT',       'WT',       'WT',       'WT',       'WT',       'WT',       'WT',       'WT',           'WT',           'WT',           'WT',        'WT',        'WT',        'WT',        'WT',        'WT',        'WT',        'WT'        ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,          1,          1,          1,          1,          1,          1,          1,          1,              1,              1,              1,           1,           1,           1,           1,           1,           1,           1,          ;...
        'db1',          'db2',      'db3',      'db4',     'db5',       'db6',      'db7',      'db8',      'db9',      'db10',         'db12',         'db14',         'db16',      'db18',      'db20',      'db25',      'db30',      'db35',     'db40',       'db45'        ;...
         wlevels,       wlevels,    wlevels,    wlevels,    wlevels,    wlevels,    wlevels,    wlevels,    wlevels,    wlevels,        wlevels,        wlevels,        wlevels,     wlevels,     wlevels,     wlevels,     wlevels,     wlevels,     wlevels,     wlevels     ;...
        [],             [],         [],         [],         [],         [],         [],         [],         [],         [],             [],             [],             [],          [],          [],          [],          [],          [],          [],          []         
        };
    % waveinfo('coif')   fk4 rbio2.2 meyr(without FWT) dmey       (no DWT) gaus mexh morl cgau shan fbsp cmor (no DWT)
    
    
    
end
