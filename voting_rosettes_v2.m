% adding path to ctFIRE
addpath('C:\Users\S.S. Mehta\Desktop\Github_UWLOCI\curvelets\ctFIRE');
clc;close all;clear all;
[filename,pathname,filterindex]=uigetfile({'*.png';'*.tiff';'*.jpg';'*.jpeg'},'Select image');
filename2=fullfile(pathname,filename);
numSlices=getSliceNumber(filename2);
display(numSlices);


% filling z ,x and other non critical data
    for k = 1:numSlices
       %temp = double(imread(['C:\Users\Sanika\Desktop\Rosette Images\Two Rosette\Two Rosettes 40X-1024pix-Z-stack(1.75um step) #1_z00' num2str(k) '_c002.png']));
        filename2=fullfile(pathname,filename);
        filename2=filename2(1:end-10);
      filename2=[filename2 num2str(k) '_c002.png'];
       temp=double(imread(filename2));
       temp = medfilt2(temp,[3,3]);
       minOld=min(temp(:));
       temp = temp-min(temp(:));
       z(:,:,k) = temp/(max(temp(:))-minOld);% should be max-previous min -- error . resolve after 24th Nov meeting
    end
    % z has the normalized image
    x = sum(z,3);
    x = x/max(x(:));
    % compressing the stack to one image and normalizing it

    temp = mean(z,3);
    temp = temp/max(temp(:));
    h = hist(temp(:)/max(temp(:)),50);
    z(:,:,numSlices+1) = temp;
    [r c]=size(z);

mask=zeros(r);mask_temp=zeros(r);
%classifier 1 - voting
areaMin=7000;areaMax=1e5;distribution=0;threshold=0.6;
base=0.4;step=0.1;
mask=classifierVoting(numSlices,z,h,areaMin,areaMax,distribution,threshold,base,step);

mask_backup=mask;
%New image before voting procedure with all detcted regions
im_new=temp;%temp stores the mean value of pixels along all the stacks

%converting mask to binary values for processing
closing_mask(1:7,1:7)=logical(1);
mask=closing(mask,closing_mask,6);
figure;imagesc(mask);hold on;

%plotting the boundaries and saving images- starts
B=bwboundaries(mask);
for k2 = 1:length(B)
     boundary = B{k2};
     plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2);%boundary need not be dilated now because we are using plot function now
end
%saving the mean image and the mask . image as a uint8 and mask as a
%logical image
savePath=fullfile(pathname,[filename(1:end-5) 'mean.tif']);
imwrite(uint8(255*temp),savePath);

savePath=fullfile(pathname,[filename(1:end-5) 'mask.tif']);
imwrite(mask,savePath);

savePath=fullfile(pathname,[filename(1:end-5) 'filtered_image.tif']);
filtered_image=double(mask).*temp;
imwrite(filtered_image,savePath);
%plotting the boundaries and saving images- ends
%ctFIRE;

%sending mask and boundary to a function for classifying rossettes with
%fibres sticking out of it
fibrous_rossette_present=FibrousRosetteCheck(mask,filename);