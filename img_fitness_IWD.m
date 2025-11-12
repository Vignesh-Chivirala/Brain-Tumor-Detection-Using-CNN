function [fitness best_particle]=img_fitness_tlbo(r,kWithout_skull,k)

% Calculate the ecludian distance between the pixel and selected probable solution cluster center.
min_temp=9999999;
for t=1:size(r,1)
rr=r(t,:);
    for j=1:k

        y=rr(1,j); 
        for m=1:size(kWithout_skull,2)
            x=double(kWithout_skull(1,m));
            d=dist(y,x);  % Inbuilt function of eculidian function
            store_distance(m,j)=d;
        end
    end
    
    temp = min(store_distance');
    
    tempp=sum(temp);
    
    if tempp<min_temp 
        min_temp=tempp;  % find minimum distance cluster center from the pixel, in probable solution.
        min_particle=t;  % best particle position inn the matrix.
        
    end
end
        
%difference

store_distance=[];
%knew_Without_skull=Without_skull;
count=1;

rr=[];
rr=sort(r(min_particle,:));   % find best particle in the probable solution matrix. 
best_particle = min_particle;
%--------This work for the student phase
if min_particle==1
fitness = [1;2];
else
    fitness = [2;1];
end

end

