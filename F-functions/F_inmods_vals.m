function [CalcVal,imfinseHHT,imfinsfHHT] = F_inmods_vals(imfinseHHT,imfinsfHHT)
global f1 Fs
[~,b] = size(imfinseHHT);
CalcVal = zeros(b,10);
nKUnS = Fs; % Количество кадров неопределенности 1с=Fs

%% Уменьшение неопределенности на краях
% imfinseHHT = imfinseHHT(nKUnS:end-nKUnS,:);
% imfinsfHHT = imfinsfHHT(nKUnS:end-nKUnS,:);
%% Вычисление характеристик мод
% Определение значений амплитуды и частоты мод
CalcVal(:,1) = mean(imfinseHHT(nKUnS:end-nKUnS,:));       % накопление энергий мод
CalcVal(:,2) = mean(imfinsfHHT(nKUnS:end-nKUnS,:));      % вычисление средней частоты моды

% Определение доп характеристик мод
CalcVal(:,8) = max(abs(imfinsfHHT(nKUnS:end-nKUnS,:))) - min(abs(imfinsfHHT(nKUnS:end-nKUnS,:)));
CalcVal(:,9) = var(imfinsfHHT(nKUnS:end-nKUnS,:));
CalcVal(:,10) = max(abs(diff(imfinsfHHT(nKUnS:end-nKUnS,:))));


%  inda = find(imfinseHHT==max(imfinseHHT));
%  CalcVal(:,1) = imfinseHHT(inda);       % накопление энергий мод
%  CalcVal(:,2) = imfinsfHHT(inda);       % накопление энергий мод

% Замена частот на сетку
A = abs(f1-CalcVal(:,2)');        % Округление значений частоты до ближайшего по сетке частот
[ind,~] = find(A==min(A));        % Определение индексов частот
CalcVal(:,2) = f1(ind);
CalcVal(:,3) = ind;
    
% % Определение кол-ва отсчетов в полосе частот
% Df = max(imfinsfHHT) - min(abs(imfinsfHHT));
% Df(Df<f1(2) - f1(1)) = f1(2) - f1(1);
% CalcVal(:,3) = Df;
% CalcVal(:,4) = round( Df / (f1(2) - f1(1)) );       % накопление энергий мод
% CalcVal(:,5) = CalcVal(:,1)./CalcVal(:,4);       % накопление энергий мод
% 
% % Дисперсия энергии и частот мод
% CalcVal(:,6) = var(imfinseHHT);
% CalcVal(:,7) = var(imfinsfHHT);


end