function filename = searchDatabase(Clip)

load ('MusicDataBase.mat','DataBase','FileDataBase');

function hashvalue = MyHash(f1,f2,t21)
hashvalue=t21*(2^16) + f1*(2^8) + f2;
end

%[DataBase,FileDataBase]=make_database('MusicFiles');

%size(DataBase)
%FileDataBase

[Table,HashTable]=song_to_table(Clip);

[r,c]=size(Table);

[NumSongs,c]=size(DataBase);
CounterValues=zeros(NumSongs);

for i=1:1:NumSongs
    i
    TimeDifference=[];
    for j=1:1:r
        hashval=MyHash(int32(Table(j,1)/15.625),int32(Table(j,2)/15.625),int32(Table(j,4)/(0.032)));
        hashval=num2str(hashval);
        
        temp1=DataBase(i);
        TimeStamps=temp1.get(hashval);
        [sizeTimeStamps,c]=size(TimeStamps);
        
        for k =1:1:sizeTimeStamps
            TimeDifference=[(Table(j,3)-TimeStamps(k));TimeDifference];
        end
        
    end
    val=mode(TimeDifference);
    [sizeTimeDifference,c]=size(TimeDifference);
    counter=0;
    for j=1:1:sizeTimeDifference
        if (TimeDifference(j)==val)
            counter=counter+1;
        end
    end
    CounterValues(i)=counter;
end

maxx=0;

for i=1:1:NumSongs
    if (CounterValues(i)>maxx)
        maxx=CounterValues(i);
        filename=FileDataBase(i);
    end
end



end