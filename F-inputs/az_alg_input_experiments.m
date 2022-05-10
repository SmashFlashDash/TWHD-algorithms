% В функции задаются входные данные для моделирования или обработки
% записанных сигналов
% Входные данные
function [AutoSaveFolder] = az_alg_input_experiments(AutoSaveFolder)
    global Algorithms
    
    %% Параметры алгоритмов
    AutoSaveFolder = sprintf('%s_experiments', AutoSaveFolder);
    Algorithms={
        'pmusic',       'peig',         'rootmusic',    'pburg',        'pcov',         'pyulear',     'pentropy',      'kurtogram',    'pkurtosis',  'pwelch',     'envspectrum', 'xspectrogram', 'wvd',        'xwvd',        'cpsd',         'mscohere',     ;...
        'Experiment',   'Experiment',   'Experiment',   'Experiment',   'Experiment',   'Experiment',  'Experiment',    'Experiment',   'Experiment', 'Experiment', 'Experiment',  'Experiment',   'Experiment', 'Experiment',  'Experiment',   'Paramet',      ;...    % [1-исп 0-неисп] Выбор алгоритмов
        1,              1,              1,              1,              1,              1,              1,              1,              1,            1,            1,              1,              1,           1,             1,              1,              ;...
        'pmusic',        'peig',        'rootmusic',   'pburg',         'pcov',         'pyulear',     'pentropy',      'kurtogram',    'pkurtosis',  'pwelch',     'envspectrum','xspectrogram',   'wvd',       'xwvd',        'cpsd',         'mscohere',     ;...
        [],             [],             [],             [],             [],             [],             [],             [],             [],           [],           [],             [],             [],          [],            [],             [],             ;...
        {4, 'whole'},   {4, 'whole'},   {4, 'whole'},   {4,'twosided'}, {4,'twosided'}, {4,'twosided'}, {},             {},             {},           {},           {},             {},             {},          {},            {},             {},          
   
        };

end