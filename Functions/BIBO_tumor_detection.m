function [r best_particle]=BIBO_tumor_detection(kWithout_skull)
img=kWithout_skull;
kk = 4;%Number of cluster center

num_of_particle =5;%num_of_particle: number of probable solution
pop_size = num_of_particle;
iter = 2;%input('Enter Number of Iteration');
chgg=1;
% generate probable solutions and store all solution in r matrix
r = unique(randi([30,230],[num_of_particle,kk]),'rows');


  %----------------------------BIBO----------------------------------------
  
  % The immigration rate ? k and the emigration rates ? k are calculated with the following equations, respectively,
%[best_solution fitness_value]=tlbo_fitness_teacher(num1,r);
[fitness_value final_clust_center best_particle]=img_fitness_BIBO(r,img,kk);
%[best_solution Ii fitness_value]=fitness_function_BIBO_logistic(popullation,tree_matrix,user);
   [C k]=sort(fitness_value);
   
h=pop_size;

for i=1:h
    [C I]=intersect(k,i);
   lemda(i,1) = (1-(I/h)); 
    mui(i,1)= I/h;
end

% calculate mutation rate
i_dash = ceil(h/2);
counters=0;
for i=1:h
    if i<=i_dash
   counters=counters+1;
   v(1,counters) = (factorial(h) / (factorial(h+1-i)*factorial(i-1)));
    else
        
       v(1,i) = v(1,counters);
       counters=counters-1;
    end
    
    
end
% calculate probablity for each island
for i=1:h
    
    P(1,i) = v(1,i)/sum(v);
    
end

P_max = (max(P));

for i=1:h
    
    M_r(1,i) = (1-P(1,i))/P_max;
    
end
% apply migration, here use the imigration and emigraton values.

for i=1:iter
   
    for j=1:h
    
        threshlod = rand();
        if threshlod<lemda(i,1)
       
            for k=1:h
       
                
       
                threshlod = rand();
        
                if threshlod<mui(i,1)
       
                % migration of population from jth island to kth island
                chgg=1;
                for chg = 1:chgg   %Snew = Sold + (Sbest-Tf*Sold)
     
                    r_pos = randi(size(r,2),1,1);
     
    
                    new_element = r(j,r_pos);
    
    
                    old_element = r(k,r_pos);
    
                    r(k,r_pos) = new_element;
    
                end
     
                
                end
            end
       
       
        end
    end
        
   %mutaion of eleemnts
   k=h;
  for j=1:h
    
        threshlod = rand();
        if threshlod<M_r(1,i)
    
            
            r1_pos = randi(size(r,2),1,1);
     
    
            new_element = r(j,r1_pos);
    
            
            
            r2_pos = randi(size(r,2),1,1);
            
            old_element = r(k,r2_pos);
    
            r(j,r1_pos)= old_element;
            r(j,r2_pos)= new_element;
        end
  end
end

[fitness_value final_clust_center best_particle]=img_fitness_BIBO(r,img,kk);
%[final_clust_center best_particle]=img_fitness_IWD(r,img,k);

end

