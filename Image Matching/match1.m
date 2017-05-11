function ex6
left=double(imread('left.jpg'));
right=double(imread('right.jpg'));

N=4;    %window size N*N
N_square=N*N;
ImgSize=size(left);
c=zeros(1,ImgSize(2));
dmap=zeros(ImgSize);
floor_N_half=floor((N-1)/2);
for i=ceil(N/2):(ImgSize(1)-floor_N_half)
    for j=ceil(N/2):(ImgSize(2)-floor_N_half)
        sub_left = left(i-floor_N_half:i+floor_N_half, j-floor_N_half:j+floor_N_half);
        mean_sub_left=mean2(sub_left);
                            
        if (mean_sub_left~=0)
            sd1=sqrt(1/N_square*(sum(sum(sub_left.*sub_left)))-(mean_sub_left)^2);
            if (sd1~=0)
                for k=ceil(N/2):(ImgSize(2)-floor_N_half)
                    sub_right= right(i-floor_N_half:i+floor_N_half, k-floor_N_half:k+floor_N_half);
                    mean_sub_right=mean2(sub_right);
                    if (mean_sub_right~=0)

                        sd2=sqrt(1/N_square*(sum(sum(sub_right.*sub_right)))-(mean_sub_right)^2);
                        if (sd2~=0)
                            c(k)=(1/N_square*(sum(sum(sub_left.*sub_right)))-mean_sub_left*mean_sub_right)/(sd1*sd2);
                        end
                    end
                end
                [max_c, imax] = max(c(:));
                dmap(i,j)=imax-j;
            end
        end
    end
    i
end
figure,imshow(dmap,[]);

dmap=medfilt2(dmap,[5,5]);
figure, imshow(dmap,[]);


figure; surfl(1:256, 1:256, dmap);axis square; view(67, 50);
shading interp;colormap(pink);