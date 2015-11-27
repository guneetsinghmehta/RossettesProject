function[maskResult]=classifierVoting(numSlices,z,h,areaMin,areaMax,distribution,threshold,base,step)
%    Inputs
%    1 numSlices - number of slices to be analyzed
%    2 z - stack containing all slices and the last slice being mean. Total numSLices+1 slices
%      h - histogram 
%    3 Areamin- minimum pixel area
%    4 Areamax- max pixel area
%      threshold - pixels>threshold- lie in Rossette
%      base= base vlaue in distribution
%      step = step size in distribution
%   Output- mask - conatining regions with rossette

%initialisation
    [s1,s2,s3]=size(z);mask=zeros(s1,s2);mask_temp=zeros(s1,s2);
    %gives a distribution with total sum=1;
    if(size(distribution)~=numSlices),distribution=getDistribution(base,step,numSlices);end
    
    for k = 1:numSlices
       % Histogram equalisation
            z1 = histeq(z(:,:,k),h)*255;
       % convolving with a gaussian filter
            z5 = conv2(z1,fspecial('gaussian',[20,20],1),'same');
       % detection MSER in each slice
            regions = detectMSERFeatures(uint8(z5),'RegionAreaRange',[areaMin,areaMax]);%to be generalized

       for i=1:regions.Count  %Number of rosettes
        a = regions.PixelList(i,1); [r c] = size(a);
            for j=1:r
                v=a(j,1);
                u=a(j,2);
                mask_temp(u,v)=1;
            end
       end
       mask=mask+distribution(k)*mask_temp;
    end
    maskResult=mask>threshold;
    figure;
    subplot(221);imagesc(mask);colorbar;colormap gray;
    subplot(222);imagesc(maskResult);colorbar;colormap gray;
    subplot(223);imagesc(z(:,:,numSlices+1));colormap gray;
    subplot(224);imagesc(maskResult.*z(:,:,numSlices+1));colormap gray;
end