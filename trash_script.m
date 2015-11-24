
savePath=fullfile(pathname,[filename(1:end-5) 'mean.tif']);
imwrite(uint8(255*temp),savePath);