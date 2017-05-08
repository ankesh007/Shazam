function [MusicFileDatabase,Filename] = make_database(DirectoryName)

%DirectoryName2=cellstr(DirectoryName);

Filenames=getMp3List(DirectoryName);
char(Filenames)
MusicFileDatabase=[];
Filename=[];
%Filenames
[r,c]=size(Filenames);
%Filenames(1,1:c)

for i = 1:1:r
    [table,hashtable] = song_to_table(strcat(DirectoryName,'/',cellstr(Filenames(i,1:c))));
    MusicFileDatabase=[[hashtable];MusicFileDatabase];
    Filename = [cellstr(Filenames(i,1:c));Filename]
    %MusicFileDatabase=[song_to_table(Filenames(i,1:c)) MusicFileDatabase]

end

end

