function lst=getMp3List(dir)
    lst=ls(dir);
    l=size(lst,1);
    counter=1;
    for ii=1:l
        pos=findstr(lst(ii,:),'.mp3');
        if ~isempty(pos)
           lst(counter,:)=lst(ii,:);
           counter=counter+1;
        end
    end
    if counter==1
        disp 'error, no mp3s found'; 
    else
        lst=lst(1:counter-1,:);
    end
end