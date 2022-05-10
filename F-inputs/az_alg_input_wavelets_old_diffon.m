% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_wavelets_old_diffon(AutoSaveFolder)
    global fRes Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_waveletsold_diff', AutoSaveFolder);
    fRes=400;                           % Частотное разрешение для алгоритмов с декомпозицией (Если [] то в соответвии с FFT)
    wlevels=5;                          % Количество уровней декомпозиции
    DifPamts=[0,2,1e-8];                % 1,2 - дисперсия частоты мин и макс, 3 - дисперсия энергии
    DifPamts_off=[0,1e2,0];                % максималные условия которые не исключают моды
    Algorithms={
        'WT-coif4_Don', 'WT-db8_Don','WT-coif3_Don','WTold-coif4','WTold-db8',    'WTold-coif3',  ;...
        'WTOld',        'WTOld',    'WTOld',        'WTOld',      'WTOld',        'WTOld',    ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,          1,              1,            1,              1,          ;...
        'coif4',        'db8',     'coif3',        'coif4',       'db8',          'coif3',     ;...
         wlevels,       wlevels,    wlevels,        wlevels,       wlevels,       wlevels,    ;...
        DifPamts,       DifPamts,   DifPamts,       DifPamts_off,  DifPamts_off,  DifPamts_off,         
        };
    % db'30', db'8' , sym'12' sym>9 дольше вычисляются
    % types 'HHT', 'WT', 'FFT','TFD', 'Var', 'TFDsum', 'HHTold', 'WTOld', 'HTVar',  'HHTthr', 'STFT', 'SsFT', 'STFTrdg','SsFTrdg',   'WssT','WssTrdg', 'Cov',  'WTthr', 'VMD','EEMD',  'Paramet'    

end
