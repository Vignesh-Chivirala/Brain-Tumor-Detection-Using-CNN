function [Precision Recall FMeasure accuracy img_gray foreend final_filter_image TL NL]=base_fcm_rough_set(FileName)
FileName='1a.jpg';
img_ = imresize(imread(FileName),[16 16]);
figure(1);
imshow(uint8(img_));
img_(:,:,1)
img_(:,:,2)
img_(:,:,3)
img_gray = rgb2gray(img_);
img_gray
level = graythresh(img_gray);
level
BW = im2bw(img_gray,level);
figure(2);
imshow(BW)
BW
ss=4;
for i=1:size(BW,1)
    for j=1:size(BW,2)
        
        if BW(i,j)>0
          foreend(i,j) = img_gray(i,j);
        else
            foreend(i,j) = 0;
        end
    end
end
foreend
figure(3);
imshow(foreend)
I2= (rgb2gray(imread('bt3_set2_ground_truth.jpg')));%,[size(foreend,1),size(foreend,2)]);

ca = image_block(foreend,ss);
ca_train = image_block(I2,ss);
store_center=[];
for i=1:size(ca,1)-1
    for j=1:size(ca,2)-1
        basic_region = ca{i,j};
        basic_region
        basic_region_train = ca_train{i,j};
        basic_region=reshape(basic_region,1,size(basic_region,1)*size(basic_region,1));
        classes =2;
        if sum(sum(basic_region))>0
        [center,U,obj_fcn] = fcm(basic_region',classes);
        act_class=sum(sum(basic_region_train));
        if act_class>20
            act_class=1;
        else
            act_class=0;
        end
        center=[center;act_class];
        store_center=[store_center,center];
        end
        
        
        
    end
end
store_center
final_ceters =[];
count=0;
for i=1:size(store_center,2)
    for j=1:size(store_center,1)
        
        if ~isnan(store_center(j,i))
            if j==1
               count=count+1; 
            end
            final_ceters(j,count)=store_center(j,i);
            
        end
    end
end
%[lower_cap upper_cap inner_boundary outer_boundry]=final_center(final_ceters');
[Lower_cap upper_cap inner_boundary outer_boundary]=final_center(final_ceters');
% count=1;
% for i=1:size(outer_boundary,2)
%    fiter_data(count,:) = final_ceters(1:2,outer_boundary(1,i));
%    count=count+1;
% end
% final_filter_image = [];
% mm=max(max(fiter_data));
% img_gray
% for i=1:size(img_gray,1)
%     for j=1:size(img_gray,2)
%         temp = img_gray(i,j);
%         [C Ia Ib]=intersect(temp,Lower_cap); 
%         
%         if temp>=mm
% 
%             final_filter_image(i,j)=255;
%         else
%              final_filter_image(i,j)=0;
%         end
%     end
% end
% figure(6);
% imshow(uint8(final_filter_image));

fiter_data=[];
count=1;
for i=1:size(Lower_cap,2)
   fiter_data(count,:) = final_ceters(1:2,Lower_cap(1,i));
   count=count+1;
end
final_filter_image = [];
mm=max(max(fiter_data))+15;

for i=1:size(img_gray,1)
    for j=1:size(img_gray,2)
        temp = img_gray(i,j);
        [C Ia Ib]=intersect(temp,Lower_cap); 
        
        if temp>=mm

            final_filter_image(i,j)=255;
        else
             final_filter_image(i,j)=0;
        end
    end
end
figure(7);
imshow(uint8(final_filter_image));

[Precision Recall FMeasure accuracy TL NL] = test_results(double(final_filter_image));
end

