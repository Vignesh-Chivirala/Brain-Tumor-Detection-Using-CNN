function I_new = max_pooling(input_feature,k,s,p)

% Accepts a volume of size 
% W1×H1×D1W1×H1×D1
% Requires four hyperparameters: 
% Number of filters K
%their spatial extent F
%the stride S,
%the amount of zero padding PP.
% Produces a volume of size 
% W2×H2×D2W2×H2×D2
% where: 
% W2=(W1?F+2P)/S+1
% W2=(W1?F+2P)/S+1
% H2=(H1?F+2P)/S+1
% H2=(H1?F+2P)/S+1 (i.e. width and height are computed equally by symmetry)
% D2=k

W= size(input_feature,1);

W2 = (W-k+2*p)/s+1;

H= size(input_feature,1);

H2 = (H-k+2*p)/s+1;
I=input_feature;
counter=1;
count=1;
for j=1:s:size(I,1)-(k-1)
    count=1;
    for i=1:s:size(I,1)-(k-1)
        
        x = I(i:i+(k-1),j:j+(k-1));
        
        y = max(max(x));
        I_new(counter,count)=sum(sum(y));
        
       % y=I(i:i+2,j:j+2);
        count=count+1;
    end
    counter=counter+1;
end

end

