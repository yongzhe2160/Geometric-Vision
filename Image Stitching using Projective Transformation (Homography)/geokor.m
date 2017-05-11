function i=geokor(H,f,g)
[h1 w1 d1]=size(f);
[h2 w2 d2]=size(g);

f=double(f);
g=double(g);

cp=norm2(H*[1 1 w1 w1;1 h1 1 h1;1 1 1 1]);
Xpr=min([cp(1,:) 0]):max([cp(1,:) w2]);
Ypr=min([cp(2,:) 0]):max([cp(2,:) h2]);
[Xp, Yp]=ndgrid(Xpr,Ypr);
[wp hp]=size(Xp);

X=norm2(H\[Xp(:) Yp(:) ones(wp*hp,1)]');

clear i;
xI=reshape(X(1,:),wp,hp)';
yI=reshape(X(2,:),wp,hp)';
i(:,:,1)=interp2(f(:,:,1),xI,yI,'bilinear');
i(:,:,2)=interp2(f(:,:,2),xI,yI,'bilinear');
i(:,:,3)=interp2(f(:,:,3),xI,yI,'bilinear');

off=-round([min([cp(1,:) 0]) min([cp(2,:) 0])]);
Index=find(g(:,:,1)+g(:,:,2)+g(:,:,3)>9);
for k=1:3
    iPart=i(1+off(2):h2+off(2),1+off(1):w2+off(1),k);
    fChannel=g(:,:,k);
    iPart(Index)=fChannel(Index);
    i(1+off(2):h2+off(2),1+off(1):w2+off(1),k)=iPart;
end
i2=find(~finite(i));
i(i2)=0;
i=uint8(i);

function n=norm2(x)
for i=1:3
    n(i,:)=x(i,:)./x(3,:);
end
