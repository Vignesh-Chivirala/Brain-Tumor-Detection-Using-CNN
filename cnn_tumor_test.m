function cnn_tumor_test(net_ff,filter1)

%=================================BIBO============================

   ss=180;
 [FileName,PathName] = uigetfile('*.jpg','Select the MRI Image');

lider= imresize(imread(FileName),[ss ss]);
figure(1);
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
 figure(2);
 imshow(filtered); 
title('Image After De-noising');
denoise_img=filtered;
 gray_img=filtered;

level = graythresh(gray_img);

BW = im2bw(gray_img,level);
 
se = strel('square',20);
%se = strel('line',11,90);
bw2 = imdilate(BW,se);
figure(3);
 imshow(bw2);
 title('Image After Dialation');
 location=0;
find=0;
%for i=1:size(gray_img,1)
count=0;
% for k=(ss/2):(ss/2)+10  
%     for i=1:size(gray_img,1)
%     
%      
%     x=BW(k,i);
%     
%     if x~=0
%        
%         find=1;
%     end
%     if find == 1 && x==0
%        
%         l   ocation=i;
%         count=count+1;
%     end
%     if count>=3
%        break; 
%     end
%     end
%      if count>=3
%          
%          break;
%      else
%          count=0;
%      end
% end
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
figure(4);
imshow(NBW);
title('Remove Image Left Skull');

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
figure(5);
imshow(NBW);
title('Remove Image Right Skull');
Without_skull=gray_img_old;
count=1;
for i=1:size(BW,1)
    for j=1:size(BW,2)

        x=NBW(i,j);
        
        if x==0
        
            Without_skull(i,j)=0;
        else
            kWithout_skull(1,count)=gray_img_old(i,j);
            Without_skull(i,j)=gray_img_old(i,j);
            count=count+1;
        end
        
    end
end

%-----------------Explanation---------------------
%--------------------------------------------------------
ss=3;
kWithout_skull=Without_skull;
%load net_ff;
%load filter1;
input_pixel=[];
output_pixel=[];
ca = image_block(kWithout_skull,ss);
for i=1:size(ca,1)-1
    for j=1:size(ca,2)-1
        temp =ca{i,j};
        temp=reshape(temp,1,ss*ss);
        
%=============================================

input_feature = double(reshape(temp,ss,ss));

k=2;
s=1;
p=0;
outpu_img = convolutional(input_feature,k,s,p,filter1);


k=2;
s=1;
p=0;

I_new = max_pooling(outpu_img,k,s,p);

I_new = LRN(I_new);



%=============================================
        input_pixel = [input_pixel;reshape(I_new,1,size(I_new,1)*size(I_new,2))];
        
    end
end
P=input_pixel;
tumor_final_img=[];
for i=1:size(P,1)
   feature_vect_temp_1=P(i,:);
    Y = round(sim(net_ff,feature_vect_temp_1'));
    if Y==0
       tumor_final_img{i,1}=zeros(ss,ss);
    else
        tumor_final_img{i,1}=ones(ss,ss)*255;
    end
end
count=1;
water_image=[];
for i=1:size(ca,1)-1%size(cac,2)
    hori=[];
    for j=1:size(ca,2)-1%size(cac,1)
        xt=tumor_final_img{count,1};
       % xt=idct2(xt);
        hori=horzcat(hori,xt);
        count=count+1;
    end
    water_image=vertcat(water_image,hori);
end
figure(6);
imshow(uint8(water_image));
disp('Extract tumor region');
[Precision Recall FMeasure accuracy TL NL] =test_result(water_image);
end

