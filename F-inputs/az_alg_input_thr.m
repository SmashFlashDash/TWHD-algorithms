% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_thr(AutoSaveFolder)
    global Fs fRes Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_wavelets(coif4)hht(thr)', AutoSaveFolder);
    fRes=400;                           % Частотное разрешение для алгоритмов с декомпозицией (Если [] то в соответвии с FFT)
    wlevels=5;                          % Количество уровней декомпозиции
    DifPamts = [0, 0.1/0.1, 0];         %  [F/dt] - Гц/с     дипс по амп, дисп по част., макс знач мгн частоты,      взять оринетриоочную F/Fs измнение за dt    0.01 это сколько за dt
    Algorithms={
        'WT-coif4',     'WTthr-coif4-01','WTthr-coif4-0.05','WTold-coif4',     'HHT',          'HHTthr',           'HHTold',                ;...
        'WT',           'WTthr',        'WTthr',            'WTOld',           'HHT',          'HHTthr',           'HHTold',                ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,              1,                  1,                 1,              1,                  1,                      ;...
        'coif4',        'coif4',        'coif4',            'coif4',           [],             [],                 [],                     ;...
        wlevels,        wlevels,        wlevels,            wlevels,           [],             [],                 [],                     ;...
        [],             DifPamts,       DifPamts,           DifPamts,          [],             DifPamts,           DifPamts,
        };
        % db'30', db'8' , sym'12' sym>9 дольше вычисляются
    % types 'HHT', 'WT', 'FFT','TFD', 'Var', 'TFDsum', 'HHTold', 'WTOld', 'HTVar',  'HHTthr', 'STFT', 'SsFT', 'STFTrdg','SsFTrdg',   'WssT','WssTrdg', 'Cov',  'WTthr', 'VMD','EEMD',  'Paramet'    
end