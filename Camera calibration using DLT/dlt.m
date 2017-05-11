function dlt
clear;

% set X and x respectively by measuring 
X=[28 15 0 1;32 31 0 1;0 22 24 1;0 31 12 1; 25 0 19 1; 13 0 29 1]';
x=[326 198 1; 344 110 1; 98 181 1; 139 108 1; 258 324 1; 164 338 1]';

% Point conditioning
T1=getT(x);
T2=getT(X);
for j=1:6
    x(:,j)=T1*x(:,j);
    X(:,j)=T2*X(:,j);
end

% get design matrix
A=getA(x,X);

% solve linear homogeneous equation system with SVD
[u d v]=svd(A);

% reshape solution for conditioned coordinates:
P1=reshape(v(:,12),4,3)';

% reverse conditioning
P=inv(T1)*P1*T2;

% Euclidean normalized
P=P/P(3,4)

% RQ using QR-Decomposition
M=P(1:3,1:3);
[Q R]=qr(inv(M));
K=inv(R);
K=K/K(3,3)
R=inv(Q)

% Extraction of Projection center
C=[det(P(:,2:4)) -det([P(:,1) P(:,3) P(:,4)]) det([P(:,1) P(:,2) P(:,4)]) -det(P(:,1:3))]';
C=C/C(4)

% Rotation angles(omega, phi, kappa):
omega=atan(-R(3,2)/R(3,3))*180/pi
phi=asin(R(3,1))*180/pi
kappa=atan(-R(2,1)/R(1,1))*180/pi

% Principle distance
AlphaX=K(1,1)

% Skew S 
S=acot(-K(1,2)/AlphaX)*180/pi

% Principle point
X0=K(1,3)
Y0=K(2,3)

% Aspect ratio 
Gamma=K(2,2)/K(1,1)

%% Get conditioning matrix of a given set of points
function T = getT(p)
if size(p,1)==3
    tx=mean(p(1,:));
    ty=mean(p(2,:));
    sx=mean(abs(p(1,:)-tx));
    sy=mean(abs(p(2,:)-ty));
    T=[1/sx    0    -tx/sx;
        0     1/sy  -ty/sy;
        0      0      1   ];
else if size(p,1)==4
        tx=mean(p(1,:));
        ty=mean(p(2,:));
        tz=mean(p(3,:));
        sx=mean(abs(p(1,:)-tx));
        sy=mean(abs(p(2,:)-ty));
        sz=mean(abs(p(3,:)-tz));
        T=[1/sx    0     0      -tx/sx;
            0     1/sy   0      -ty/sy;
            0      0    1/sz    -tz/sz;
            0      0     0         1  ];
    end
end
%% Generate design matrix A
function A=getA(x, X)
A=[];
for j=1:6
    A=[A;   -x(3,j)*(X(:,j))'  zeros(1,4)           x(1,j)*X(:,j)';
               zeros(1,4)    -x(3,j)*(X(:,j))'      x(2,j)*X(:,j)'];
end