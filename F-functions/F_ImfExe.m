function [CalcVal,imf] = F_ImfExe(CalcVal, DiffParamets, imf, imfinsfHHT, imfinseHHT, type)
    global f1 Fs
    
    switch type
            % обьединить часоты которых пересекаются
        case 1
            % Исключение мод скорость изменения мгновенной частоты которых не соответсвует
            index = (CalcVal(:, 10) < DiffParamets(1, 1)) | (CalcVal(:, 10) > DiffParamets(1, 2));
            CalcVal(index,:) = 0;           % Обнулить моды
            CalcVal = CalcVal(~index,:);    % Исключить моды
            imf = imf(:,~index);            % Исключить моды
        case 2
            % Исключение мод
            % обьединение мод энергия которых превышает значение
            index = CalcVal(:, 1) > DiffParamets(3);    % Индексы с энерги больше 500
            if sum(index) > 1
                maxIndx = CalcVal(:, 1) == max(CalcVal(index, 1));       % из них индекс с максимальной энергией
                imf(:, maxIndx) = sum(imf(:, index),2);
                index(maxIndx) = 0;
                imf = imf(:,~index);
            end
            % обьеденить imf и CalcVal в этот индекс, пересчитать моды
            [imfinseHHT, imfinsfHHT] = F_HHT(imf, Fs);
            [CalcVal, ~, ~] = F_inmods_vals(imfinseHHT, imfinsfHHT);
        otherwise
            error('wrong type decomposition algorithm');
    end
%     subplot(211)
%     hht(imf)    % Спектр Гильберта
%     subplot(223)
%     waterfall(imfinseHHT')
%     subplot(224)
%     waterfall(imfinsfHHT')

%     CalcVal(:,8) = max(abs(imfinsfHHT(Fs:end-Fs,:))) - min(abs(imfinsfHHT(Fs:end-Fs,:)));
%     CalcVal(:,9) = var(imfinsfHHT(Fs:end-Fs,:));
%     CalcVal(:,10) = max(abs(diff(imfinsfHHT(Fs:end-Fs,:))));
%     CalcVal(:,9) = var(abs(diff(imfinsfHHT(Fs:end-Fs,:))));
%     index = (CalcVal(:, 9) > DiffParamets(1, 1)) | (CalcVal(:, 10) > DiffParamets(1, 2));

    % Фильтр по var и diff
%     DiffParamets(1,1) = 0.2;
%     DiffParamets(1,2) = 100;

    
    
   % Обьединить моды если средняя частота менее 0.5
   % Если значение вне условия Мода смещается к частоте с максимальной амплитудой
   % Здесь все моды вне условия складываютс, можно рассмотреть с
   % ограничением
%    [CalcVal, imf] = uniteIMF(CalcVal, imf, 0.2, Fs);


    % Исключение мод скорость изменения мгновенной частоты которых не соответсвует
%     CalcVal(:,10)=max(abs(diff(imfinsfHHT)));
%     index = (CalcVal(:,10)>DiffParamets(1,2)) | (CalcVal(:,10)<DiffParamets(1,1));
%     CalcVal(index,:) = 0;           % Обнулить моды
%     CalcVal = CalcVal(~index,:);    % Исключить моды
%     imf = imf(:,~index);            % Исключить моды

    % Исключение мод дисперсия мгновенных частот которых не соответсвует
%     CalcVal(:,7) = var(imfinsfHHT);
%     index = (CalcVal(:,7) > DiffParamets(1,2)) | (CalcVal(:,7) < DiffParamets(1,1));
%     CalcVal(index,:) = 0;
%     CalcVal = CalcVal(~index,:);


    % сравнить с двумя ближайшими, какое расстояни меньше

    % Отсеивание мод скорость изменения мгновенной частоты которых не соответсвует
%     CalcVal(:,10)=max(abs(diff(imfinsfHHT)));
%     index = (CalcVal(:,10)>DiffParamets(1,2)) | (CalcVal(:,10)<DiffParamets(1,1));
%     CalcVal(index,:) = 0;         % Обнулить моды
%     CalcVal = CalcVal(~index,:);    % Исключить моды

    % Подсчет энергии кол-ва отсчетов в полосе частот
%     Df = max(imfinsfHHT) - min(abs(imfinsfHHT));
%     Df(Df<f1(2) - f1(1)) = f1(2) - f1(1);
%     CalcVal(:,3) = Df;
%     CalcVal(:,4) = round( Df / (f1(2) - f1(1)) );    % подсчет количества отсчетов в полосе df
%     CalcVal(:,5) = CalcVal(:,1)./CalcVal(:,4);       % равномерное распределение энергии по отсчетам

    % Отсеивание мод дисперсия энергии которых не соответсвует
%     CalcVal(:,6) = var(imfinseHHT);
%     index = CalcVal(:,6) < DiffParamets(1,3);
%     CalcVal(index,:) = 0;

    % Отсеивание мод дисперсия частоты которых не соответсвует
%     CalcVal(:,7) = var(imfinsfHHT);
%     index = (CalcVal(:,7) > DiffParamets(1,2)) | (CalcVal(:,7) < DiffParamets(1,1));
%     CalcVal(index,:) = 0;
%     CalcVal = CalcVal(~index,:);    % Исключить моды
    
    % Исключение мод
%     imf(:, index) = [];
%     CalcVal([1,2],:) = 0;
end


%-------------------------------
%-------------------------------
%-------------------------------

% Обьединить моды если средняя частота менее 0.5
% Если значение вне условия Мода смещается к частоте с максимальной амплитудой
% Здесь все моды вне условия складываютс, можно рассмотреть с
% ограничением
function [CalcVal, imf] = uniteIMF(CalcVal, imf, dffff, Fs)
num_imf =  length(CalcVal(:,2));
dff = zeros(3, num_imf-1);
for i=1:num_imf-1
    cash = [CalcVal(i,2), CalcVal(i+1,2)];
    dff(1, i) = cash(1)-cash(2);
    if dff(1, i) <= dffff
        dff(2, i) = 1;
        indx = find(cash==max(cash))+i-1;
        if length(indx)>1
            indx = indx(1);
        end
        dff(3, i) = indx;
    end
end
% Перемещение и замена мод
if any(dff(2,:)==1)
    for i = num_imf-1:-1:1
        if dff(2,i)==1
%             if i==dff(3,i)
%                 imf(:, dff(3,i)) = imf(:,dff(3,i)) + imf(:,dff(3,i)+1);
%                 imf(:, dff(3,i)+1) = [];
%                 CalcVal(dff(3,i), 1) = CalcVal(dff(3,i), 1) + CalcVal(dff(3,i)+1, 1);
%                 CalcVal(dff(3,i)+1, :) = [];    % Исключить моды
%             else
%                 imf(:, dff(3,i)+1) = imf(:,dff(3,i)) + imf(:,dff(3,i)+1);
%                 imf(:, dff(3,i)) = [];
%                 CalcVal(dff(3,i)+1, :) = CalcVal(dff(3,i), 1) + CalcVal(dff(3,i)+1, 1);
%                 CalcVal(dff(3,i), :) = [];    % Исключить моды
%             end
try
                if i==dff(3,i)
                    imf(:, dff(3,i)) = imf(:,dff(3,i)) + imf(:,dff(3,i)+1);
                    imf(:, dff(3,i)+1) = [];
                    CalcVal(dff(3,i), 1) = CalcVal(dff(3,i), 1) + CalcVal(dff(3,i)+1, 1);
                    CalcVal(dff(3,i)+1, :) = [];    % Исключить моды
                else
                    imf(:, dff(3,i)+1) = imf(:,dff(3,i)) + imf(:,dff(3,i)+1);
                    imf(:, dff(3,i)) = [];
                    CalcVal(dff(3,i)+1, :) = CalcVal(dff(3,i), 1) + CalcVal(dff(3,i)+1, 1);
                    CalcVal(dff(3,i), :) = [];    % Исключить моды
                end
            catch
                error('')
            end

        end
    end
    [imfinseHHT,imfinsfHHT] = F_HHT(imf, Fs);
    [CalcVal, imfinseHHT, imfinsfHHT] = F_inmods_vals(imfinseHHT, imfinsfHHT);
end


end