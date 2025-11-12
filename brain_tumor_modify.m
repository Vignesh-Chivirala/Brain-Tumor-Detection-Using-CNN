function [Precision Recall FMeasure accuracy total_time denoise_img without_skull_img segment_img TL NL] =brain_tumor_modify(FileName)

%------------------------------------
                ss=180;
 %brain2               BRAIN-TUMOUR3
 %[FileName,PathName] = uigetfile('*.jpg','Select the MRI Image');

lider= imresize(imread(FileName),[ss ss]);
figure(2);
imshow(lider);
title('Input MRI Image');
gray_img=rgb2gray(lider);
gray_img_old=gray_img;
st_time=tic;
%----------------------------------------------------------------

%----------------------------------------------------------------
 img = im2single(gray_img);

% Add  noise
  % img = imnoise(img, 'salt & pepper');  imshow(img);
filtered = wiener2(img,[3 3]);
 %hmedianfilt = vision.MedianFilter([2 2]);
 %filtered = step(hmedianfilt, img);
 pause(2);
 imshow(filtered); 
title('Image After De-noising');
denoise_img=filtered;
 gray_img=filtered;

level = graythresh(gray_img);

BW = im2bw(gray_img,level);
 figure;
 imshow(BW);
se = strel('square',20);
%se = strel('line',11,90);
bw2 = imdilate(BW,se);
figure(5);
imshow(BW);
 location=0;
find=0;
%for i=1:size(gray_img,1)
count=0;
for k=(ss/2):(ss/2)+10  
    for i=1:size(gray_img,1)
    
     
    x=BW(k,i);
    
    if x~=0
       
        find=1;
    end
    if find == 1 && x==0
       
        location=i;
        count=count+1;
    end
    if count>=3
       break; 
    end
    end
     if count>=3
         
         break;
     else
         count=0;
     end
end
% ultimateErosion = bwulterode(gray_img);
% figure(6);
% imshow(ultimateErosion);
NBW=BW;

for i=1:size(BW,1)
    for j=1:size(BW,2)-3

        x=BW(i,j);
        
        if x==1
            count=1;
            find=1;
            while find==1 && j>3
           NBW(i,j)=0;
           j=j+1;
           x=BW(i,j);
       
           if x==1
               find=1;
           elseif BW(i,j+1)==0 %&& BW(i,j+2)==0 %&& BW(i,j+3)==0 
               find=0;
           end
           
            end
        
        break;
        
        end
        
    end
end
figure(7);
imshow(NBW);


for i=1:size(NBW,1)
    for j=size(NBW,2):-1:5

        x=BW(i,j);
        
        if x==1
            count=1;
            find=1;
            while find==1 && j>3
           NBW(i,j)=0;
           j=j-1;
           x=BW(i,j);
       
           if x==1
               find=1;
           elseif BW(i,j-1)==0 %&& BW(i,j-2)==0 %&& BW(i,j-3)==0 
               find=0;
           end
           
               
          
            
            end
        
        break;
        
        end
        
    end
end
figure(8);
imshow(NBW);
Without_skull=gray_img_old;
count=1;
for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            Without_skull(i,j)=0;
        else
            kWithout_skull(1,count)=gray_img_old(i,j);
            count=count+1;
        end
        
    end
end
figure(9);
imshow(Without_skull);
% figure(10);
% imshow(kWithout_skull);

%-----------------Segmentation K-Means Extraction--------------------
% [idx,ctrs] = kmeans(double(kWithout_skull),2,...
%                     'Distance','city',...
%                     'Replicates',5,...
%                     'Options',opts);


% appling fire fly

%-----------------Explanation---------------------
%IWD_tumor_detection(kWithout_skull);
[r best_particle]=IWD_tumor_detection(kWithout_skull);
rr=sort(r(best_particle,:));
% k = 4;%Number of cluster center
% 
% num_of_particle =15;%num_of_particle: number of probable solution
% iter = 5;%input('Enter Number of Iteration');
% 
% % generate probable solutions and store all solution in r matrix
% r = unique(randi([30,230],[num_of_particle,k]),'rows');
% 
% % in this loop number of time a pixel appreared in the image is calculated. 
% for i=0:255
%     count=0;
%     for j=1:size(kWithout_skull,2)
%         
%         if i==kWithout_skull(1,j)
%             
%             count=count+1;
%         end
%         
%     end
%     final_count(i+1,1)=count;
% end
% 
% final_count
% % calculate the intensity
% % in this loop internsity of the fire fly is calculated. Here each pixel
% % value range from 0-255 is representing a fire fly.
% 
% lemda=-1;
% count =1;
% for i=1:size(final_count,1)
% 
%       temp =rand();
%         I(1,count) = final_count(i,1)*exp((-lemda)*temp);
%         count = count +1;
%      
% end
% t=1;
% tx=1;
% 
% % Calculate the ecludian distance between the pixel and selected probable solution cluster center.
% min_temp=9999999;
% for t=1:num_of_particle
% rr=r(t,:);
%     for j=1:k
% 
%         y=rr(1,j); 
%         for m=1:size(kWithout_skull,2)
%             x=double(kWithout_skull(1,m));
%             d=dist(y,x);  % Inbuilt function of eculidian function
%             store_distance(m,j)=d;
%         end
%     end
%     
%     temp = min(store_distance');
%     
%     tempp=sum(temp);
%     
%     if tempp<min_temp 
%         min_temp=tempp;  % find minimum distance cluster center from the pixel, in probable solution.
%         min_particle=t;  % best particle position inn the matrix.
%         
%     end
% end
%         
% %difference
% 
% store_distance=[];
% knew_Without_skull=Without_skull;
% count=1;
% 
% rr=[];
% rr=sort(r(min_particle,:));   % find best particle in the probable solution matrix. 
tumor=zeros(size(BW,1),size(BW,2));

for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            knew_Without_skull(i,j)=0;
            
        else
            y=double(Without_skull(i,j));
        for m=1:size(rr,2)
            xx=rr(1,m);%
            d=dist(y,xx);
            store_distance(1,m)=d;
        end
        [C I]=min(store_distance);
            knew_Without_skull(i,j)=I*60;
            if I==4
               tumor(i,j)=255; 
            end
        end
        count=count+1;
    end
end
total_time=toc(st_time);
figure(21);

imshow(knew_Without_skull);
title('Clustered Image');
figure;
imshow(uint8(knew_Without_skull));
title('Clustered Image');
without_skull_img=knew_Without_skull;
% figure(22);
% 
% imshow(uint8(tumor));
% title('Segmented Image');

se = strel('square',2);
 I_openedmax = imdilate(tumor,se);
figure(23);

imshow(uint8(tumor));
title('Segmented Image');
segment_img=tumor;
% results   
disp('Total execution Time in seconds');


total_time
[Precision Recall FMeasure accuracy TL NL] =test_result(tumor);
end

