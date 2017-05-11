
close;
clear;

% initializing the matrix
p=ones(3,8,2);
l=ones(3,8,2);
x=ones(3,8,2);
T=zeros(3,3,2);

% transfer the images into the computer
img1=imread('1.jpg');
img2=imread('2.jpg');

% plot the images on the screen
subplot(1,2,1),imshow(img1);
subplot(1,2,2),imshow(img2);

% get 8 corresponding image point pairs by hand between the two images
for j=1:8
    for i=1:2
        p(1:2,j,i)=(ginput(1))';
        subplot(1,2,i),hold on; plot(p(1,j,i),p(2,j,i),'ko','MarkerFaceColor','r');hold off;
    end
end

% Point conditioning
for i=1:2
    T(:,:,i)=getT(p(:,:,i));
    x(:,:,i)=T(:,:,i)*p(:,:,i);
end

% get design matrix
A=getA(x(:,:,1),x(:,:,2));

% solve linear homogeneous equation system with SVD
[u d v]=svd(A);

% reshape solution for conditioned coordinates:
F=reshape(v(:,9),3,3)';

% reverse conditioning
F=T(:,:,2)'*force_rank2(F)*T(:,:,1);

% Draw the epipolar lines
l(:,:,2)=F*p(:,:,1);
l(:,:,1)=F'*p(:,:,2);

for i=1:2
    subplot(1,2,i),
    hold on;
    for j=1:8
        hline(l(:,j,i));
    end
    hold off;
end


% Calculate the Symmetric epipolar distance
err=0;
for i=1:8
    A=F*x(:,i,1);
    A=A/A(3);
    B=F'*x(:,i,2);
    B=B/B(3);
    err=err+(x(:,i,2)'*F*x(:,i,1))^2*(1/((A(1))^2+(A(2))^2) + 1/((B(1))^2+(B(2))^2));
end
err

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
A=[];
for j=1:8
    A=[A;
       p1(:,j)'*p2(1,j) p1(:,j)'*p2(2,j) p1(:,j)'];
end
A=[A; zeros(1,9)];

%% Force singularity constraint det(F)=0
function F=force_rank2(F)
[U, D, V]=svd(F);
D(3,3)=0;
F=U*D*V';
