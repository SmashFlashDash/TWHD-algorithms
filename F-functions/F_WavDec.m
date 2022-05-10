%% Выполнение вейвлет декомпозиции
function [DU]=F_WavDec(wlevels,wname,x)
    global nK
    %[x1] =wdencmp ('gbl', x, 'db3', 3, 20, 's', 0); %шумоподавление и компрессия
    [C,L]=wavedec(x,wlevels,wname);               %многоуровневый вейвлет анали
    DU=zeros(nK,wlevels);
    for l=1:wlevels
        DU(:,l)=wrcoef('d',C,L,wname,l);    %Детилизирующий вектор
    end
end


