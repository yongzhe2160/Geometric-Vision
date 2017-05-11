%% main function of exercise 2
function ex2
clear;

% initializing the matrix
p=ones(3,4,4);
x=ones(3,4,4);
T=zeros(3,3,4);

% transfer the images into the computer
img1=imread('1.jpg');
img2=imread('2.jpg');
img3=imread('3.jpg');

% plot the images on the screen
subplot(2,1,1),imshow(img1);
subplot(2,1,2),imshow(img2);

% get four corresponding image points by hand between the first two image
for j=1:4
    for i=1:2
        p(1:2,j,i)=(ginput(1))';
    end
end

% Point conditioning
for i=1:2
    T(:,:,i)=getT(p(:,:,i));
    for j=1:4
        x(:,j,i)=T(:,:,i)*p(:,j,i);
    end
end

% get design matrix
A12=getA(x(:,:,1),x(:,:,2));

% solve linear homogeneous equation system with SVD
[u d v]=svd(A12);

% reshape solution for conditioned coordinates:
H12=reshape(v(:,9),3,3)';

% reverse conditioning
H12=inv(T(:,:,2))*H12*T(:,:,1);

% Euclidean normalized
H12=H12/H12(3,3);

% combine the first two images
img12=geokor(H12, img1, img2);

% plot the combined image and the 3rd one
subplot(2,1,1), imshow(img12);
subplot(2,1,2), imshow(img3);

% redo the procedure above to combine img12 and the img3 
for j=1:4
    for i=3:4
        p(1:2,j,i)=(ginput(1))';
    end
end

for i=3:4
    T(:,:,i)=getT(p(:,:,i));
    for j=1:4
        x(:,j,i)=T(:,:,i)*p(:,j,i);
    end
end

A32=getA(x(:,:,4),x(:,:,3));
[u d v]=svd(A32);
H32=reshape(v(:,9),3,3)';
H32=inv(T(:,:,3))*H32*T(:,:,4);
H32=H32/H32(3,3);

img123=geokor(H32, img3, img12);

% show the final result
figure,imshow(img123);

%% Get conditioning matrix of a given set of points
function T = getT(p)
tx=mean(p(1,:));
ty=mean(p(2,:));
sx=mean(abs(p(1,:)-tx));
sy=mean(abs(p(2,:)-ty));
T=[1/sx    0    -tx/sx;
    0     1/sy  -ty/sy;
    0      0      1   ];

%% Generate design matrix A
function A=getA(p1,p2)
B=zeros(2,9,4);
for j=1:4
    B(:,:,j)=[-p2(3,j)*(p1(:,j))'  zeros(1,3)           p2(1,j)*(p1(:,j))'
               zeros(1,3)          -p2(3,j)*(p1(:,j))'  p2(2,j)*(p1(:,j))'];
end
A=[B(:,:,1);
   B(:,:,2);
   B(:,:,3);
   B(:,:,4);
   zeros(1,9)];

