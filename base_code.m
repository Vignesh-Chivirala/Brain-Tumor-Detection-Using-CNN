function  [Precision Recall FMeasure accuracy denoise_img without_skull_img]=base_code(FileName)
[FileName,PathName] = uigetfile('*.jpg','Select the MRI Image');
img_ = double(imread(FileName));
figure(1);
imshow(uint8(img_));
img_
%--------RGB 2 grayimage-------------------------

for i=1:size(img_,1)
    
    for j=1:size(img_,2)
        
           gray(i,j) = img_(i,j,1)*(0.3) +img_(i,j,2)*(29/50) +img_(i,j,3)*(0.11); 
           
    end
end
img_org = rgb2gray(img_);
% figure(2);
% imshow(uint8(img_org));


prob_density = pdf('normal',img_org,0,1);

b=0.4;

for i=1:size(img_org,1)
    for j=1:size(img_org,2)
       % for k=1:size(img_org,3)

            r_open(i,j) = prob_density(i,j)-prob_density(i,j)*b;
            
            r_close(i,j) = prob_density(i,j)*b-prob_density(i,j);
            
    end
end

%--------Find noise in the image-------------------------
T=0.5;
for i=1:size(img_org,1)
    for j=1:size(img_org,2)
       % for k=1:size(img_org,3)

           if r_open(i,j) >= T   % salt part of image
               
               S(i,j)=1;%-prob_density(i,j,k)*b;
           elseif r_close(i,j) >= T  % pepper part of image
               
               S(i,j)=-1;
               
           else                            % nonoise in image
               S(i,j)=0;
           end
           
       % end
    end
end



%---------------Median filter--------------------------

ca = image_block(gray);


filter_matrix = zeros(3,3);

filter_matrix(2,2) = max(max(gray));

caa = reshape(gray, 1, size(gray,1)*size(gray,2));

caa = unique(caa);

[C I]=sort(caa,'descend');

filter_matrix(1,2) = C(1,2);
filter_matrix(2,1) = C(1,2);
filter_matrix(2,3) = C(1,2);
filter_matrix(3,2) = C(1,2);



filter_matrix(1,1) = C(1,size(C,2));
filter_matrix(1,3) =C(1,size(C,2));
filter_matrix(3,1) = C(1,size(C,2));
filter_matrix(3,3) = C(1,size(C,2));


for i=1:size(ca,1)-1
    for j=1:size(ca,2)-1
        
        x = ca{i,j};
        
        if S(i,j)~=0
            
             y = x*filter_matrix;
             
             neighbour = zeros(1,5);
             
             
             neighbour(1,1)=y(1,2);% = C(1,2);

             neighbour(1,2)=y(2,1);%
             
             neighbour(1,3)=y(2,2);%
             
             neighbour(1,4)=y(2,3);%
             
             neighbour(1,5)=y(3,2);%
             

             [C I]=sort(neighbour,'descend');
             
             y(1,2)=C(1,3);
             y(2,1)=C(1,3);
             y(2,3)=C(1,3);
             y(3,2)=C(1,3);
             
              neighbour = zeros(1,5);
             
             
             neighbour(1,1)=y(1,1);% = C(1,2);

             neighbour(1,2)=y(1,3);%
             
             neighbour(1,3)=y(2,2);%
             
             neighbour(1,4)=y(3,1);%
             
             neighbour(1,5)=y(3,3);%
             
             [C I]=sort(neighbour,'descend');
             
             y(1,1)=C(1,3);
             y(1,3)=C(1,3);
             y(3,1)=C(1,3);
             y(3,3)=C(1,3);
        
        ca{i,j}=y;
             
        end
        
    end
end

%----------combine image-------------------------


embed_image = [];

watermark_ca_t = [];

for i = 1:size(ca,1)-1
    
   embed_image = [];
   
   count = 1;
    
    for j = 1:size(ca,2)-1
        
        t = ca{i,j};
        
        embed_image = horzcat(embed_image,t);
        
        count = count +1;
    

    end
        
        watermark_ca_t = vertcat(watermark_ca_t,embed_image);
        
        
        
    
    
end

figure(3);


imshow(uint8(watermark_ca_t));

denoise_img = watermark_ca_t;
%-------------------Skull Removal-------------------------------
ss=180;

watermark_ca_t= uint8(imresize(watermark_ca_t,[ss ss]));

gray_img=watermark_ca_t;
level = graythresh(watermark_ca_t)+0.08;

BW = im2bw((watermark_ca_t),level);
 figure(4);
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

se = strel('disk',2);
%se = strel('line',11,90);
bw2 = imdilate(NBW,se);
figure(8);
imshow(bw2);

se = strel('disk',5);
%se = strel('line',11,90);
% bw2 = imdilate(bw2,se);
% figure(9);
% imshow(bw2);
without_skull_img=bw2;
[Precision Recall FMeasure accuracy] = test_results(double(bw2));
end

