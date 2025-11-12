function [Precision Recall FMeasure accuracy TL NL] = test_results(I1)
        ss=size(I1,2);
 %brain2               BRAIN-TUMOUR3
 [FileName,PathName] = uigetfile('*.jpg','Select Ground truth of MRI Image');

I2= imresize(imread(FileName),[size(I1,1) size(I1,2)]);
figure(2);
imshow(I2);
title('Ground truth');

level = graythresh(I2);

I2 = im2bw((I2),level);

level = graythresh(I1);

I1 = im2bw((I1),level);



actual_tumor =0;
actual_non_tumor =0;
system_tumor =0;
system_non_tumor =0;
TP=0;
FP=0;
TN=0;
FN=0;
for i=1:size(I1,1)-2
    for j=1:size(I1,2)-2

        x=I1(i,j)
        y=I2(i,j)
        if I1(i,j)==0 && I2(i+2,j+2)==0
            TP=TP+1;
        elseif I1(i,j)==0 && I2(i+2,j+2)==1
            TN=TN+1;
         elseif I1(i,j)==1 && I2(i+2,j+2)==0
            
        FN=FN+1;
        elseif I1(i,j)==1 && I2(i+2,j+2)==1
                FP=FP+1; 
                
        end
        
        if I1(i,j)==0
            system_tumor=system_tumor+1;
        else
            system_non_tumor=system_non_tumor+1;
        end
        
        
        if I2(i,j)==0
            actual_tumor=actual_tumor+1;
        else
            actual_non_tumor=actual_non_tumor+1;
        end
        
    end
end


disp('Tumor Detection Accuracy');
accuracy=((TP+TN)/(TP+TN+FP+FN))*100%size(temp_vectortest,1)



disp('Precision');

Precision=TP/(TP+FP)


disp('Recall');

Recall=TP/(TP+FN)

disp('F-Measure');

FMeasure=2*Precision*Recall/(Precision+Recall)
disp('Positive Likelihood');
TL = TP/(TP+TN)
disp('Negative Likelihood');
NL = TN/(TN+FP)
end

