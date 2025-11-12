function [Lower_cap upper_cap inner_boundary outer_boundary]=final_center(final_ceters)
final_ceters = ceil(final_ceters);


X=[];
Ind_common=[];
chk_index=[];
count=1;
counter=0;
for i=1:size(final_ceters,1)
    
        
        if final_ceters(i,3)==1
     
            X(count,1)= i;
            count=count+1;
            
        end
     [C Ia1 Ib]=intersect(i,chk_index);   
   if size(Ia1,2)==0  
       chk_index=[chk_index,i];
       counter=counter+1;
        %here we find common element group
        rcount=1;
        Ind_common(counter,rcount)=i;
    for j=i+1:size(final_ceters,1)
             [C Ia Ib]=intersect(j,chk_index);   
   
             if size(Ia,2)==0 
        
                 xx = sort(final_ceters(i,1:2));
                 yy= sort(final_ceters(j,1:2));
                 if xx(1,1)==yy(1,1) && xx(1,2)==yy(1,2)
            
                     rcount=rcount+1;
                     Ind_common(counter,rcount)=j;
                     chk_index=[chk_index,j];
                 end
             end
    end
   end
end

%find lower_cap value sets in our case 1 means tumor and 0 means non tumor

Lower_cap=[];
    for i=204:size(Ind_common,1)
        Y=Ind_common(i,:);
        t=1;
        for j=1:size(Y,2)
           if Y(1,j)>0
            Yt(1,t)=Y(1,j);
            t=t+1;
           else 
               break;
           end
        end
        [C Ia Ib]=intersect(X',Yt);   
        
        if size(Ia,2)==size(Yt,2)
        Lower_cap=[Lower_cap,Yt];
        end
    end

    %find upper_cap value sets in our case 1 means tumor and 0 means non tumor

upper_cap=[];
    for i=1:size(Ind_common,1)
        Y=Ind_common(i,:);
        t=1;
        for j=1:size(Y,2)
           if Y(1,j)>0
            Yt(1,t)=Y(1,j);
            t=t+1;
           end
        end
        [C Ia Ib]=intersect(X',Yt);   
        
        if size(Ia,2)>=1
        upper_cap=[upper_cap,Yt];
        end
    end
upper_cap=unique(upper_cap);
inner_boundary = setdiff(upper_cap,Lower_cap);
outer_boundary = setdiff([1:size(final_ceters,1)],upper_cap);
end

