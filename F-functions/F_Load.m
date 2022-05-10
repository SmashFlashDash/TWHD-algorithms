function [DSpecM,DataAllLine,DataAll,Data] = F_Load(DataAllLine,DataAll,nK,nF)
                Samp = nF;                         %Количество отсчетов в кадре ==nF
                Path=[cd '\' 'Ispitaniya'];
                Folder=char(DataAll(DataAllLine,1));
                File=char(DataAll(DataAllLine,2));
                Input = fread (fopen([Path '\' Folder '\' File], 'r'), 'int32', 'b')';
                fclose all;
                Data = complex(Input(1:2:end), Input(2:2:end));
                Data = reshape(Data, Samp, []).';
                clear Input Folder File filename pathname Path Samp;       
        DSpecM=zeros(nK,nF);         %Развертка дальности реальный сигнал             
        for i=1:nK                          
            DSpecM(i,:)=fft(Data(i,:));      %Переход к развертке по дальности
        end
end
