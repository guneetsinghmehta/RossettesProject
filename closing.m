function [imout]=closing(image,mask,num_ops)
    % morphological image processing operation - closing
    %input - image- image to be closed
    % mask - mask used for closing
    % num_ops- number of time dilation is done before the same number of
    % erosion operation is done. default value of number is 1
    if(nargin==2),num_ops=1;end
    imout=image;
    for i=1:num_ops
        imout=dilation(imout,mask);
    end
       
    for i=1:num_ops
        imout=erosion(imout,mask);
    end
end