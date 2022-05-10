clear all;
close all;

% A = 'D:\DP\Ispitaniya';                         %название директории с файлами
A = uigetdir(path, 'Folder Ispitanya');
B = dir(A);                                     %все файлы и папки из этой директории     

for i=3:length(B)
    FolList(i-2,1)=cellstr(B(i).name); 
    nexDir(i-2,1)=strcat(A,'\', FolList(i-2));      %названи€ папок по датам nexDir
end
clear i A B;
                                                                     
for i=1:length(nexDir)                          %переменна€ дл€ поиска data в директори€х
    nexDir(i,1)=strcat(cell(nexDir(i)),'\**\*.data'); 
end

for q=1:length(nexDir)                          %цикл перебора папок
    
    Data=dir(string(nexDir(q,1)));             %запись файлов из суб директиорий
    fields = fieldnames(Data);                 %пол€ полученной структуры
 

        for i=3:length(fields)                  %оставл€ем только поле с названием и путем
            Data = rmfield(Data,fields(i));
        end
        Data(1).Opisanie=[];
    clear fields i; 



writetable(struct2table(Data), string(strcat('Data',FolList(q),'.xlsx'))); %—оздание xlsx файлов

% xlswrite(string(strcat('Data',FolList(q),'.xlsx')),struct2table(Data));

end

clear a b i c;

return;
% 
% 
% 
% 
% files = setfield(files,exposition,value);%присваивание значений полю
%     
% files=rmfield(files,'name');
% 
% for i=1:length(cell(files.name))
%     if ~endsWith(string(files(i).name),'Im.txt')
%         clear files(i).name
%     end
%     
%     
% end
% 
% 
% FolList=dir(string(nexDir(1)));
% 
% for i=3:length(FolList)
%     fold(i-2,1)=cellstr(FolList(i).name);
%     
%         if ~endsWith(string(fold(i-2,1)),'Im.txt')
%             nexDir3(i-2,1)=strcat(nexDir(1),'\',fold(i-2));
%         elseif ~endsWith(string(fold(i-2,1)),'Re.txt')
%             nexDir3(i-2,1)=strcat(nexDir(1),'\',fold(i-2));
%         end
%         
%         
% end
% clear fold i A B FolList fold;
% 
% endsWith
% strncmp
% 
% B1=dir(string(nexDir(2)));
% 
% for i=3:length(B1)
%     di(i-2,1)=cellstr(B(i).name);
%     nexDir(i-2,1)=strcat(A,'\',di(i-2));     
% end
% 
% deblank
% strcat
% 
% C=struct2dataset(B);
% 
% C=struct2cell(B);
% C=struct2table(B);
% 
% B1= [string(B(1).name), string(B(2).name), string(B(3).name)];
% 
% flds = fieldnames(B);
% fld1=cell2sym(flds(1));
% 
% for i=1:len(B.fld1);
% 
% flds = fieldnames(B);
% 
% flds=[flds(3),flds(4),flds(5),flds(6)];
% fldsrem = {flds(3),flds(4),flds(5),flds(6)};
% B = rmfield(B,fldsrem);
% 
% B.name
% B(1).name
% B(1)
% 
% s.a = 1; % структура с пол€ми a
% s.b = {'A','B','C'}; %b
% s = struct(field1,value1,...,fieldN,valueN);
% 
% sum( lower(str1) ~= lower(str2) )
% sum( str1 == str2 )
% numel(str1) - sum( str1 ~= str2 )
% 
% strfind
% B = sort(A,dim)
% tf = strcmpi(s1,s2)
% strncmp	—равнить n символов строк
% findstr	Ќайти заданную строку в составе другой строки
% strjust	¬ыравн€ть массив символов
% strmatch	Ќайти все совпадени€