function [net_ff_IWD filter_IWD]=cnn_tumor_IWD_train()%kWithout_skull,rr)

%=================================BIBO============================

   ss=180;
 [FileName,PathName] = uigetfile('*.jpg','Select the MRI Image');

lider= imresize(imread(FileName),[ss ss]);
figure(1);
imshow(lider);
lider
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
%IWD_tumor_detection(kWithout_skull);
%[r best_particle]=BIBO_tumor_detection(kWithout_skull)
[r best_particle]=IWD_tumor_detection(kWithout_skull);
rr=sort(r(best_particle,:));

%=================================BIBO End=======================

[FileName,PathName] = uigetfile('*.jpg','Select Ground truth of MRI Image');
I2= rgb2gray(imresize(imread(FileName),[size(Without_skull,1) size(Without_skull,2)]));

level = graythresh(I2);

I2 = double(im2bw((I2),level));

ss=3;

st_time = tic;
P=[];
T=[];
class=1;
%-------------Convolutional Neural Network-------------------
k=2;
s=1;
p=0;
for m=1:k
    for n=1:k
        x = randi([3],1,1)
        if x==1

            filter(m,n) = 0;
        elseif x==2
            
            filter(m,n) = 1;
        else
            filter(m,n) = 1;
        end
    end
end
filter1=filter;

k=2;
s=1;
p=0;
for m=1:k
    for n=1:k
        x = randi([3],1,1)
        if x==1

            filter(m,n) = 0;
        elseif x==2
            
            filter(m,n) = 1;
        else
            filter(m,n) = 1;
        end
    end
end

filter2=filter;

k=2;
s=1;
p=0;
for m=1:k
    for n=1:k
        x = randi([3],1,1)
        if x==1

            filter(m,n) = 0;
        elseif x==2
            
            filter(m,n) = 1;
        else
            filter(m,n) = 1;
        end
    end
end
%L4_b = convolutional(I_new,k,s,p,filter);
filter3=filter;


k=1;
s=1;
p=0;
for m=1:k
    for n=1:k
        x = randi([3],1,1)
        if x==1

            filter(m,n) = 0;
        elseif x==2
            
            filter(m,n) = 1;
        else
            filter(m,n) = 1;
        end
    end
end
%L7 = convolutional(L6,k,s,p,filter);
filter4=filter;
kWithout_skull=Without_skull;
input_pixel=[];
output_pixel=[];
ca = image_block(kWithout_skull,ss);
ca_I2 = image_block(I2,ss);
for i=1:size(ca,1)-1
    for j=1:size(ca,2)-1
        temp =ca{i,j};
        temp=reshape(temp,1,ss*ss);
        chk_cls=0;
        for m=1:size(temp,1)
            y=temp(1,m);
        for m=1:size(rr,2)
            xx=rr(1,m);%
            d=dist(y,xx);
            store_distance(1,m)=d;
        end
        [C I]=min(store_distance);
            knew_Without_skull(i,j)=I*60;
            if I==4
               chk_cls=chk_cls+1;
            end
        end
        
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
        temp_ca=ca_I2{i,j};
        if sum(sum(temp_ca))>=2%size(temp,1)
            output_pixel = [output_pixel;1];
        else
            output_pixel = [output_pixel;0];
        end
    end
end
P=input_pixel;
T=output_pixel;
net = newff(P',T',[4 3]);
net.trainParam.epochs = 100;
net.trainParam.goal = 0.01;
net.trainParam.show = 1;
net.trainParam.mc = 0.9;
net.trainParam.max_fail = 10000;
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.1;
net.divideParam.testRatio = 0.1;
net_ff_IWD = train(net,P',T');
save net_ff_IWD.mat net_ff_IWD;
filter_IWD = filter1;
save filter1.mat filter_IWD;

TP=0;
for i=1:size(P,1)
   feature_vect_temp_1=P(i,:);
    Y = round(sim(net_ff_IWD,feature_vect_temp_1'));
   if Y==T(i,1)
     TP=TP+1;  
   end
end
TP
i
end

