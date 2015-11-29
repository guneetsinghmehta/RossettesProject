
%savePath=fullfile(pathname,[filename(1:end-5) 'mean.tif']);
%imwrite(uint8(255*temp),savePath);
s1=1024;s2=1024;
image=zeros(s1,s2);
blank=image;
xc=512;yc=512;r=100;
for i=1:s1
    for j=1:s2
        if((i-xc)^2+(j-yc)^2<=r*r)
           image(i,j)=1; 
        end
    end
end
B=bwboundaries(image);
B1=B{1};
figure;imagesc(image);colormap gray;hold on;
color1=[1,1,0];
plot(B1(:,1),B1(:,2),'LineStyle','-','color',color1,'linewidth',0.005);

x1=512;y1=512;x2=712;y2=512;
plot(v1,v2,'LineStyle','-','color',color1,'linewidth',0.005);

for i=2:size(B1,1)-1
   x0=B1(i,1);
   y0=B1(i,2);
   dist=distanceFromLine(x1,x2,y1,y2,x0,y0);
   
   pause(0.01);
   dist=distanceFromLine(x1,x2,y1,y2,B1(i-1,1),B1(i-1,2))*distanceFromLine(x1,x2,y1,y2,B1(i+1,1),B1(i+1,2));
   fprintf('x=%f y=%f and dist=%f\n',x0,y0,dist);
   if(dist<0)
        text(x0,y0,'a','color',[1,0,0]);
   end
end


