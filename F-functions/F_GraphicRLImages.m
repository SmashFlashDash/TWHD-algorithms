% Графика развертки дальности всех алгоритмов
function F_GraphicRLImages(DetectedSpectrum_G, fspects, i_fl, RadarData, idx_sel_Dist, idx_sel_Tsel, SignalFrames, describe, graphs)
global AxDistance AxTFrames nK nF Fs f1 f2 Alarms Algorithms_name Algorithms_v fwsst TypeRadar nFiles  Algorithms x y xd yd
if not(graphs==0)
    return
end
% Заполнить не исключенные дальности
[DetectedSpectrum_G] = Fill_emp_tabs(DetectedSpectrum_G, idx_sel_Dist(1), idx_sel_Dist(2));


F_reset_ax_figs()
space = '   ';
% График Сигнала
titl = 'Необработанные сигналы';
figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
mesh(AxDistance,AxTFrames,abs(SignalFrames),'EdgeColor','none','FaceColor','interp');
view(2);
xlabel('Дальность [м]'); ylabel('Время [с]');
xlim([-inf inf]); ylim([-inf inf]);
title({['Тип радара=' num2str(TypeRadar) '/' '2, Fs=' num2str(Fs)];...
    ['Файл=' num2str(i_fl) '/' num2str(nFiles) ' ' describe];...
    'Необработанные сигналы';...
    ['Период наблюдения=' num2str(AxTFrames(1)) ' : ' num2str(AxTFrames(end)) '[с]'] });
F_change_ax_figs(5)
% График ЧПК
fb = 0.2;
nbin = round(Fs/(fb*4));    % кол-во отсчетов в pi/4 периода дыхания
TFD1 = zeros(nK,nF);
TFD2 = zeros(nK,nF);
TFD3 = zeros(nK,nF);
TFD4 = zeros(nK,nF);
TFD1(1:nK-nbin,:) = abs(SignalFrames(1+nbin:nK,:) - SignalFrames(1:nK-nbin,:));      % комплексный ЧПК амплитудный
TFD2(1:nK-nbin,:) = abs(angle(SignalFrames(1+nbin:nK,:) - SignalFrames(1:nK-nbin,:)));    % комплексный ЧПК фазовый
TFD3(1:nK-nbin,:) = abs(abs(SignalFrames(1+nbin:nK,:)) - abs(SignalFrames(1:nK-nbin,:))); % ЧПК амплитудный
TFD4(1:nK-nbin,:) = abs(angle(SignalFrames(1+nbin:nK,:)) - angle(SignalFrames(1:nK-nbin,:))); % ЧПК фазовый
titl = sprintf('ЧПК порядок %.d', nbin);
figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
subplot(2,2,1);
mesh(AxDistance,AxTFrames,TFD1,'EdgeColor','none','FaceColor','interp');
view(2);
xlabel('Дальность [м]'); ylabel('Время [с]');
xlim([-inf inf]); ylim([-inf inf]);
title({['Тип радара=' num2str(TypeRadar) '/' '2, Fs=' num2str(Fs)];...
    ['Файл=' num2str(i_fl) '/' num2str(nFiles) ' ' describe];...
    'комплексный ЧПК амплитудный';...
    ['Период наблюдения=' num2str(AxTFrames(1)) ' : ' num2str(AxTFrames(end)) '[с]'] });
subplot(2,2,2);
mesh(AxDistance,AxTFrames,TFD2,'EdgeColor','none','FaceColor','interp');
view(2);
xlabel('Дальность [м]'); ylabel('Время [с]');
xlim([-inf inf]); ylim([-inf inf]);
title('комплексный ЧПК фазовый');
subplot(2,2,3);
mesh(AxDistance,AxTFrames,TFD3,'EdgeColor','none','FaceColor','interp');
view(2);
xlabel('Дальность [м]'); ylabel('Время [с]');
xlim([-inf inf]); ylim([-inf inf]);
title('ЧПК амплитудный');
subplot(2,2,4);
mesh(AxDistance,AxTFrames,TFD4,'EdgeColor','none','FaceColor','interp');
view(2);
xlabel('Дальность [м]'); ylabel('Время [с]');
xlim([-inf inf]); ylim([-inf inf]);
title('ЧПК фазовый');
F_change_ax_figs(5)




% Графики
for i=1:size(Algorithms_v, 2)
    pos_name = find(strcmp(Algorithms_name, Algorithms{1,i}));
    if Algorithms_v(pos_name)==1
        alg_name = Algorithms{1,pos_name};
        alg_type = Algorithms{2,pos_name};
        alg_use = Algorithms{3,pos_name};
        wname = Algorithms{4,pos_name};
        wlev = Algorithms{5,pos_name};
        diff_params = Algorithms{6,pos_name};
        %         fprintf('%s\n', alg_name);
    else
%         Detections(1,pos_name)=NaN;
%         Detected_Spect{pos_name}=NaN;
        continue
    end
    titl = sprintf('img_%s%s', Algorithms_name{i}, space);
    figure('Name',titl,'NumberTitle','off','Position',[x y xd yd],'Units','pixels');
    f = fspects{pos_name,:};
    if size(f,2)==0
        DetectedSpectrum = NaN(1, size(DetectedSpectrum_G,1));
    else
        DetectedSpectrum = NaN(size(f,2), size(DetectedSpectrum_G,1));
%     DetectedSpectrum = NaN(size(DetectedSpectrum_G,1), size(f,2));
    end
    for iF=1:nF
        DetectedSpectrum(:,iF) = DetectedSpectrum_G{iF,pos_name};    % Получаем массив по всем кадрам и дальностям данного алгоритма
%         DetectedSpectrum(iF,:) = DetectedSpectrum_G{iF,pos_name};    % Получаем массив по всем кадрам и дальностям данного алгоритма
    end
    

    % По однозначынм спектрам
    if alg_use==1 && any(strcmp(alg_type,{'Cov', 'TFD','Var','HTVar'}))
        stem(AxDistance,DetectedSpectrum);
        xlabel('Дальность [м]')
        ylabel('Amp');
        title(alg_name);
    % По сплошным спектрам
    elseif alg_use==1 && any(strcmp(alg_type,{'FFT' 'WTold' 'HHTold' 'STFT' 'SsFT' 'WssT' 'Paramet'}))
        mesh(AxDistance,f,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         mesh(f,AxDistance,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
        % view(2);
        view(0,0);
        xlabel('Дальность [м]'); ylabel('Частота [Гц]');
        xlim([0 inf]); ylim([0 inf]);
        title(alg_name);
    % По сплошным спектрам и накопленной выборке максимумов
    elseif alg_use==1 && any(strcmp(alg_type,{'STFTrdg' 'SsFTrdg' 'WssTrdg'}))
        stem(AxDistance,DetectedSpectrum);
        xlabel('Дальность [м]')
        ylabel('Amp');
        title(alg_name);
    % По дискретным спектрам
    elseif alg_use==1 && any(strcmp(alg_type,{'HHT' 'WT' 'HHTthr' 'HHTthr2' 'WTthr' 'WTthr2' 'HHTst'  'HHTexp' 'VMD'}))
        mesh(AxDistance,f,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         mesh(f,AxDistance,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
        % view(2);
        view(0,0);
        xlabel('Дальность [м]'); ylabel('Частота [Гц]');
        xlim([0 inf]); ylim([0 inf]);
        title(alg_name);
    
        

    %Experiment
    elseif alg_use==1 && any(strcmp(alg_type,'Experiment'))
        

    % Не сделанные алгоритмы
    %HHTperiodic
    elseif alg_use==1 && any(strcmp(alg_type,'HHTst'))

    %HHTexperemental
    elseif alg_use==1 && any(strcmp(alg_type,'HHTexp'))
    end





%     % ЧПК
%     elseif alg_use==1 && any(strcmp(alg_type,'TFD'))
%         % DetectedSpectrum(DetectedSpectrum>1e5)=1e10;
%         mesh(AxDistance,AxTFrames,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         xlabel('Дальность [м]'); ylabel('Время [с]');
%         xlim([-inf inf]); ylim([-inf inf]);
%         title('ЧПК');
%     % FFT
%     elseif alg_use==1 && any(strcmp(alg_type,'FFT'))
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('FFT');
%     % STFT
%     elseif alg_use==1 && any(strcmp(alg_type,'STFT'))
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('STFTmax');
%     % STFT ridge
%     elseif  alg_use==1 && any(strcmp(alg_type,'STFTrdg')) 
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('STFT ridge');
%     % SsFT
%     elseif alg_use==1 && any(strcmp(alg_type,'SsFT'))
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('SsFTmax');
%      % SsFT ridge
%     elseif alg_use==1 && any(strcmp(alg_type,'SsFTrdg'))
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('STFT ridge');
%     % WssT
%     elseif alg_use==1 && any(strcmp(alg_type,'WssT'))
%         mesh(AxDistance,fwsst,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('WssT');
%     % WssT ridge
%     elseif alg_use==1 && any(strcmp(alg_type,'WssTrdg'))
%         mesh(AxDistance,fwsst,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('WssT ridge');
%      % WT_Old
%     elseif alg_use==1 && any(strcmp(alg_type,'WTOld'))
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('WTOld');
%     % WT
%     elseif alg_use==1 && any(strcmp(alg_type,'WT'))
%         mesh(AxDistance,f1,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('WT');
%     % HHT
%     elseif alg_use==1 && any(strcmp(alg_type,'HHT'))
%         mesh(AxDistance,f1,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('HHT');
%     %HHTold
%     elseif alg_use==1 && any(strcmp(alg_type,'HHTold'))
%         mesh(AxDistance,f2,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('HHT FFT');
%     %HHTthr
%     elseif alg_use==1 && any(strcmp(alg_type,'HHTthr'))
%         mesh(AxDistance,f1,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('HHT vardiff');
%     %WTthr
%     elseif alg_use==1 && any(strcmp(alg_type,'WTthr'))
%         mesh(AxDistance,f1,DetectedSpectrum,'EdgeColor','none','FaceColor','interp');
%         view(2);
%         view(0,0);
%         xlabel('Дальность [м]'); ylabel('Частота [Гц]');
%         xlim([0 inf]); ylim([0 inf]);
%         title('WT vardiff');
%     %VMD
%     elseif alg_use==1 && any(strcmp(alg_type,'VMD'))
% 
%     %EEMD
%     elseif alg_use==1 && any(strcmp(alg_type,'EEMD'))
% 
%     %Experiment
%     elseif alg_use==1 && any(strcmp(alg_type,'Experiment'))
%         
% 
%     % Не сделанные алгоритмы
%     %HHTperiodic
%     elseif alg_use==1 && any(strcmp(alg_type,'HHTst'))
% 
%     %HHTexperemental
%     elseif alg_use==1 && any(strcmp(alg_type,'HHTexp'))
% 
%     end




    F_change_ax_figs(5)
end






end




%% Функции
% Заполнение исключенных дальностей
function [DetectedSpectrum_G] = Fill_emp_tabs(DetectedSpectrum_G, in_dst_min, in_dst_max)
global Algorithms_v AxDistance
% idx_alg = find(Algorithms_v);   % индексы в таблице используемых алгоритмов
% idx_NaN_dist = [1:in_dst_min-1, in_dst_max+1:numel(AxDistance)];    % индексы не вычесленных дальностей
% for i_alg = idx_alg
%     [nF,nF1] = size(DetectedSpectrum_G{in_dst_min,i_alg});   % количестов частот в спектре алгоритма
%     for i_dstd = idx_NaN_dist
%         DetectedSpectrum_G{i_dstd,i_alg} = zeros(nF,nF1);
%     end
% end

idx_alg = find(Algorithms_v);   % индексы в таблице используемых алгоритмов
for i_alg = idx_alg
    for in_dst_min=1:length(DetectedSpectrum_G(:,i_alg))
        DetectedSpectrum_G{in_dst_min, i_alg}(isnan(DetectedSpectrum_G{in_dst_min, i_alg})) = 0;

%         DetectedSpectrum_G{isnan(DetectedSpectrum_G{in_dst_min,i_alg})}(in_dst_min,i_alg) = 0;    % Если надо NaN в 0 для граифков
    end
end

end