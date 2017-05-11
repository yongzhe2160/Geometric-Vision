
%define parameters
N=9;
offset=floor(N/2);
searcharea=1/4;

%read the image and convert to double
left=double(imread('left.jpg'));
right=double(imread('right.jpg'));

%initialize matrices and arrays
SizeImg=size(left);
disparity=zeros(SizeImg);

[row col]=find(left);

%for vert=(1+offset):(SizeImg(1)-offset)
%    for hori=(1+offset):(SizeImg(2)-offset)
for index=1:length(row)
        vert=row(index);
        hori=col(index);
        ref=define_sub_window(left,vert, hori, offset);
        mean_ref=mean2(ref);
        c=zeros(1,SizeImg(2));
        for hori2=hori:(min(SizeImg(2)-offset,floor(hori+searcharea*SizeImg(2)-offset)))
            search=define_sub_window(right, vert, hori2, offset);
            mean_search=mean2(search);
            if (mean_search~=0)
                c(hori2)=calc_NCC(ref,mean_ref, search,mean_search, N);
            end
        end
        [maxc, i]=max(c(:));
        if (maxc~=0)
            disparity(vert,hori)=i-hori;
        end
%    end    
end

figure, imshow(disparity,[]);
disparity=medfilt2(disparity,[10,10]);
figure, imshow(disparity,[]);


figure; surfl(1:256, 1:256, disparity);axis square; view(67, 50);
shading interp;colormap(pink);

function subwindow=define_sub_window(Img, vert, hori, offset)
subwindow=Img((vert-offset):(vert+offset),(hori-offset):(hori+offset));

function c=calc_NCC(ref,mean_ref, search,mean_search, N)
tmp=1/(N*N);
sd1=sqrt(tmp*(sum(sum(ref.*ref)))-mean_ref^2);
sd2=sqrt(tmp*(sum(sum(search.*search)))-mean_search^2);
if (sd1==0 || sd2==0)
    c=0;
else 
    c=(tmp*(sum(sum(ref.*search)))-mean_ref*mean_search)/(sd1*sd2);
end


