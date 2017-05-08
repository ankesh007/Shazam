function [Table,HashTable] = song_to_table(filename)

filename=char(filename);

format long g;
[y,fs]=mp3read(filename);
y=mean(y,2);
z=mean(y);
y=y-z;

NewFrequency=8000;
TimeStamps=0.032;
PEAKS_PER_SECOND=30;

y=resample(y,NewFrequency,fs);

window=(2*TimeStamps*NewFrequency);
overlap=(TimeStamps*NewFrequency);
nfft=window; %assumed

[S,F,T] = spectrogram(y,window,overlap,nfft,NewFrequency);

%spectrogram(y,512,256,512,NewFrequency,'yaxis');

CS=circshift(S,[0,-1]);
P=((S-CS)>0);
CS=circshift(S,[0,1]);
P=P&((S-CS)>0);
CS=circshift(S,[1,0]);
P=P&((S-CS)>0);
CS=circshift(S,[-1,0]);
P=P&((S-CS)>0);
[r,c] =size(P);

S=abs(S);
Q=P.*S;


Q=sort(Q,1);
R=Q(r-PEAKS_PER_SECOND,1:c);
R=repmat(R,r,1);
P30=(S-R>=0)&P;
%imagesc((1:c)+0.5,(1:r)+0.5,P30);
%colormap(1-gray);
size (P30)
delt=2;
delf=2;
temp=int32((r*c)/10);
temp2=0;
Table = zeros(temp,4);
ZERO=zeros(r,c);
index=0;
%disp(r);
%disp(c);
%r=100;
%c=100;
for i = 1:delf:r
   for j = 1:delt:c
       for k = i:1:min([i+delf r])
           for l=j:1:min([j+delt c])
               for row1=k+1:1:min([i+delf r])
                   for col1=l+1:1:min([j+delt c])
                     if (P30(k,l)==1 && P30(row1,col1)==1)
                         index=index+1;
                         %Table(index)=[F(k) F(row1) T(l) T(col1)]; 
                         Table(index,1)=F(k);
                         Table(index,2)=F(row1);
                         Table(index,3)=T(l);
                         
                         Table(index,4)=T(col1)-T(l);
                         
                         ZERO(k,l)=ZERO(k,l)+1;
                         ZERO(row1,col1)=ZERO(row1,col1)+1;
                        
                     end
                     
                   end
               end
           end
       end
   end
end

max(ZERO);
max(max(ZERO));

%HashTableSize=(2^18);

function hashvalue = MyHash(f1,f2,t21)
hashvalue=t21*(2^16) + f1*(2^8) + f2;
end

% Hashtable in Matlab

HashTable= java.util.Hashtable;

for j = index-1:(-1):1
hashval=MyHash(int32(Table(j,1)/15.625),int32(Table(j,2)/15.625),int32(Table(j,4)/TimeStamps));
hashval=num2str(hashval);
HashTable.put(hashval,[Table(j,3);HashTable.get(hashval)]);
%size(HashTable.get(hashval))
%Performing Chaning in case of Collision
end
end


