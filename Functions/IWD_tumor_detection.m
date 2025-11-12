function [r best_particle]=IWD_tumor_detection(kWithout_skull)
img=kWithout_skull;
k = 4;%Number of cluster center

num_of_particle =5;%num_of_particle: number of probable solution
iter = 2;%input('Enter Number of Iteration');
chgg=1;
% generate probable solutions and store all solution in r matrix
r = unique(randi([30,230],[num_of_particle,k]),'rows');

%Initialize the static parameters. The graph (V, E) of the problem is given to the algorithm. 
%The value of the total-best solution TTBest is Initially assigned to the worst value
pixel_type=[0:255];%unique(unique(kWithout_skull));
nodes = 256;%size(pixel_type,2); %Total numer of images
soil = zeros(nodes,nodes);

as = 1; 
bs = .01;
cs = 1;


av = 1; 
bv = .01;
cv = 1;

roh_nls = 0.9;
roh_ngs=0.8;

%Initialize the dynamic parameters. Every IWD has a visited node list Vc (IWD), which is initially empty:
Vc = zeros(nodes);

velocity = zeros(nodes,nodes);

%-----------------Estimate SOIL Value----------------------
for i=1:nodes
    xx=pixel_type(1,i);
    for j=i+1:nodes
        yy=pixel_type(1,j);
        d = dist(xx,yy);
        soil(i,j)=(d^2)^0.5;
    end
end
counter=0;
while counter < iter%for j=1:size(r,1)%(1,:)
 
    
hud = 0.5;
abslong =0.2;
for i=1:size(r,1)
    for ii=1:size(r,2)
        rt = r(i,ii);
   % x_txt = txt{rt,:};

    m_soil = min(soil(rt,:));
    for j=1:nodes
        
        if m_soil>0
           
            g_soil = soil(rt,j);
        else
            g_soil = soil(rt,j)-m_soil;
            
        end
        
        f_soil(1,j) = 1/(abslong+g_soil);
        
        
    end
    for j=1:nodes
        
    
        roh_ij(rt,j)= f_soil(1,j)/sum(f_soil);
        
        velocity(rt,j)=velocity(rt,j)+av/(bv+cv*soil(rt,j)^2);
        
        timee = hud/velocity(rt,j);
        del_soil(rt,j) = av/(bs+cs*timee^2);
        
        soil(rt,j)=(1-roh_nls)*soil(rt,j)-roh_nls*del_soil(rt,j);
    end
    end
end
[final_clust_center best_particle]=img_fitness_IWD(r,img,k);

[Cc valle] = max(final_clust_center);


 for m=1:size(r,1)
     
     for chg = 1:chgg   %Snew = Sold + (Sbest-Tf*Sold)
     r_pos = randi(k,1,1);
     
    new_element = r(best_particle,r_pos);
    
    
    
    
    soil(m,new_element)=(1-roh_ngs)*soil(m,new_element)-roh_ngs*(1/(Cc-1))*soil(new_element,m);
    r(m,r_pos) = new_element;
     end
 end
 
    %for m=1:size(r,1)
 %fitness=text_fitness_cosinetlbo(r,document_vector,k);

%[C best_particle] = min(fitness);
%best_particle = r(I,:);

counter = counter +1;

end
[final_clust_center best_particle]=img_fitness_IWD(r,img,k);

end

