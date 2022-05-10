clear all;

addpath('F-algorithms\', 'F-functions\', 'F-inputs\')

autosave = Autosave('sds');
% autosave = autosave.autosave_set_dir('asdas');
autosave.autosave_to_folder("", 1);

fprintf(autosave.MainDir);

