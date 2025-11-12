function brain_tumor()

%------------------------------------
                ss=180;
 %brain2               BRAIN-TUMOUR3
lider= imresize(imread('brain2.jpg'),[ss ss]);
figure(2);
imshow(lider);
title('Input MRI Image');
gray_img=rgb2gray(lider);
%----------------------------------------------------------------

%----------------------------------------------------------------
for i=2:size(lider,1)-1
    for j=2:size(lider,2)-1
        %for k=1:size(lider,3)
        
            x(1,1)=gray_img(i,j);
            wij = rand(1,8);
            x(1,2)=wij(1,1)*gray_img(i+1,j);
            x(1,3)=wij(1,2)*gray_img(i,j+1);
            x(1,4)=wij(1,3)*gray_img(i+1,j+1);
            x(1,5)=wij(1,4)*gray_img(i-1,j+1);
            
            x(1,6)=wij(1,5)*gray_img(i-1,j);
            x(1,7)=wij(1,6)*gray_img(i+1,j-1);
            x(1,8)=wij(1,7)*gray_img(i,j-1);
            x(1,9)=wij(1,8)*gray_img(i-1,j-1);
            
            y=mean(x);
            
            gray_img(i,j)=y;
    end
end

% skull removal
figure(3);
imshow(gray_img);
title('Image After De-noising');


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
Without_skull=gray_img;
count=1;
for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            Without_skull(i,j)=0;
        else
            kWithout_skull(1,count)=gray_img(i,j);
            count=count+1;
        end
        
    end
end
figure(9);
imshow(Without_skull);

%-----------------Segmentation K-Means Extraction--------------------
% [idx,ctrs] = kmeans(double(kWithout_skull),2,...
%                     'Distance','city',...
%                     'Replicates',5,...
%                     'Options',opts);


[IDX,C] = kmeans(double(kWithout_skull),3);
knew_Without_skull=Without_skull;
count=1;
for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            knew_Without_skull(i,j)=0;
        else
            knew_Without_skull(i,j)=IDX(count,1)*70;
            count=count+1;
        end
        
    end
end
figure(10);
imshow(knew_Without_skull);

som_Without_skull=Without_skull;
count=1;
ccount=1;
for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            som_Without_skull(1,ccount)=0;
        else
            som_Without_skull(1,ccount)=IDX(count,1)*70;
           count=count+1;
        end
         ccount=ccount+1;
    end
end
% figure(10);
% imshow(knew_Without_skull);

%--------------Extract Features--------------------------
y=[];
[I_gray_o,cH2,cV2,cD2] = dwt2(knew_Without_skull,'db1');
%x = simplecluster_dataset
net = selforgmap([5 1]);
net = train(net,double(som_Without_skull));

y = net(double(som_Without_skull));
classes = vec2ind(y);
classes

knew_Without_skull=Without_skull;
count=1;
for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            knew_Without_skull(i,j)=0;
            
        else
            knew_Without_skull(i,j)=classes(1,count)*50;
            
        end
        count=count+1;
    end
end
figure(11);
imshow(knew_Without_skull);



% nett = train(net,b);
% %d = [9,9];
% f = net(d);
% 
% 
% temp=max(max(gray_img(1:8,1:8)));
% 
% 
% 
% k=graythresh(gray_img);
% 
% location=0;
% find=0;
% for i=1:size(gray_img,1)
%     
%     x=gray_img(120,i);
%     
%     if x>temp
%        
%         find=1;
%     end
%     if find == 1 && x<=temp
%        
%         location=i;
%         break;
%         
%     end
%     
% end
% 
%     for j=2:size(lider,2)-1
%         %for k=1:size(lider,3)
%         
%             x=gray_img(i,j);
%             if x>=k
%                 
%             else
%                 temp_gray_img(i,j)=x;
%                 
%             end
% 
%     end
% 
% figure(4);
% imshow(gray_img);
% title('Image After skull Removal');
% 
% se = strel('square',8);
% %se = strel('line',11,90);
% bw2 = imdilate(gray_img,se);
% figure(5);
% imshow(gray_img);
% title('Image After skull Removal');
% 
% ultimateErosion = bwulterode(bw2);
% 
% 
% figure(6);
% imshow(gray_img);
% title('Image After skull Removal');
% 
% 
% 


end

