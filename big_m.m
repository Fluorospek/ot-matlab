%BIG_M
clc
clear all
a = [4 2;1 5;6 1];
b = [4;8;3];
M=1000;
c=[3 -4 0 -M 0 0];
I=[1 0 0];
Id=eye(size(a,1));
n1=find(I==1);
Id(n1,n1)=-Id(n1,n1);
A=[a Id b];
n=2;
m=size(A,2);
run=1;
bv=n+1:m-1;
while run==1
    basic_cost=c(bv);
    zj=basic_cost*A;
    zjcj=zj-c;
    zc=zjcj(1:end-1);
    [mz,ec]=min(zc);
    pc=A(:,ec);
    b=A(:,end);
    ratio=b./pc;
    for i=1:size(A,1)
        if ratio(i)<0
            ratio(i)=inf;
        end
    end
    [leave,lindex]=min(ratio);
    bv(lindex)=ec;
    pivot_row=lindex;
    pivot_column=ec;
    pv=A(pivot_row,pivot_column);
    pivot_row=A(pivot_row,:)/pv;
    for i=1:size(A,1)
        if i~=lindex
            A(i,:)=A(i,:)-(pivot_row)*A(i,ec);
        else
            A(i,:)=pivot_row;
        end
    end
    basic_cost=c(bv);
    zj=basic_cost*A;
    zjcj=zj-c;
    zc=zjcj(1:end-1);
    if(zc>=0)
        run=0;
    else
        run=1;
    end
    
end
A
zjcj(end)