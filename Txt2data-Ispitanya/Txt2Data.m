clear; close all;

Folder='D:\DP\Ispitaniya';                                      %Дирректория с папками испытаний                      
%A = uigetdir(path, 'Folder Ispitanya');

B = dir(Folder);                                                        %Получение структуры папок дирректории
    for i=3:length(B)
        fold(i-2,1)=cellstr(B(i).name);                         %Получение названий папок из структуры
        nexDir(i-2,1)=strcat(Folder,'\',fold(i-2));       %Объединение названий папок и путей к ним
    end
Folder=nexDir;      
clear fold nexDir B i;                                                  %Ненужные переменные

for i=1:length(Folder)                                               %переменная для поиска txt в директориях
    nexDir(i,1)=strcat(cell(Folder(i)),'\**\*.txt'); 
    delete strcat(cell(Folder(i)),'\*.data');                 %Удаление имеющихся data             
end
clear Folder;

for n=1:length(nexDir)
    
    files=dir(string(nexDir(n,1)));                                  %Структура директории
    fields = fieldnames(files);                                         %Названия полей полученной структуры
        for i=3:length(fields)                                            %оставляем только поле 1 и 2
            files = rmfield(files,fields(i));
        end
    clear fields i;

    b=0;
            for i=1:size(files)
                if logical(strfind((files(i).name),'Im.txt'))       %Ищем файлы Im
                    b=b+1;
                    Data(b).name = files(i).name;                   %записываем в структуру
                    Data(b).folder = files(i).folder;
                    Data(b).Opisanie = [];
                elseif  logical(strfind((files(i).name),'Re.txt'))  %Ищем файлы re
                    b=b+1;
                    Data(b).name = files(i).name;                   %записываем в структуру
                    Data(b).folder = files(i).folder;
                    Data(b).Opisanie = [];
                end
            end
    clear files;




                for i=1:2:(size(Data.'))
                FoldLoad=Data(i).folder;                              %Выбор имени файлов
                FileNameRe=strcat(Data(i).name(1:length(Data(i).name)-7),'_Re.txt');
                FileNameIm=strcat(Data(i).name(1:length(Data(i).name)-7),'_Im.txt');

                Re=load(fullfile(FoldLoad,FileNameRe));     %Загрузка файлов txt
                Im=load(fullfile(FoldLoad,FileNameIm));
                Re=(reshape(Re',[],1)).';                                %Преобразуем файлы в одну строку
                Im=(reshape(Im',[],1)).';                              

                N=zeros(1,length(Re)+length(Im));           %Создаем новый файл (Re четный Im нечетный)
                N(1:2:end)=Re(1:1:end);                             
                N(2:2:end)=Im(1:1:end);

                Name=Data(i).name(1:length(Data(i).name)-7);    %Создаем имя где сохраним файл
                Name=strcat( FoldLoad,'\',Name,'.data');     
                f_id=fopen(Name,'w');                                     %Запись файла
                fwrite(f_id,N,'int32','b');
                fclose(f_id);

                Input = fread (fopen([Name], 'r'), 'int32', 'b')';                   
                Conv=isequal(N,Input);                                  % Открытие и проверка правильности записей

                if Conv==0
                            Name
                            return;
                end
               fclose all;
               clear Re Im N Name Input Conv f_id b FileNameRe FileNameIm  FoldLoad;

                end

    %         i=121;                                %проверка
    %         FoldLoad=Data(i).folder;                             
    %         FileNameRe=strcat(Data(i).name(1:length(Data(i).name)-7),'_Re.txt');
    %         FileNameIm=strcat(Data(i).name(1:length(Data(i).name)-7),'_Im.txt');
    %         Re=load(fullfile(FoldLoad,FileNameRe));     
    %         Im=load(fullfile(FoldLoad,FileNameIm));
    %         Re=(reshape(Re',[],1)).';                              
    %         Im=(reshape(Im',[],1)).';      
    %         N=zeros(1,length(Re)+length(Im));           
    %         N(1:2:end)=Re(1:1:end);                             
    %         N(2:2:end)=Im(1:1:end);
    %         Name=Data(i).name(1:length(Data(i).name)-7);
    %         Name=strcat( FoldLoad,'\',Name,'.data');  
    %         Input = fread (fopen([Name], 'r'), 'int32', 'b')';
    %         Conv=isequal(N,Input); 

end
         
return;
