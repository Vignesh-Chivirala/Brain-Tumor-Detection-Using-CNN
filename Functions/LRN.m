function input_img=LRN(input_img)

for i=1:size(input_img,1)
    for j=1:size(input_img,2)
        
   
        if input_img(i,j)<0.0001
            
            input_img(i,j)= 0.75;
            
        end
    end
end

end

