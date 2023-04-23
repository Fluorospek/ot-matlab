%BIG-M
format short
clc
clear all
M=1000;
var={'x1','x2','s2','s3','A1','A2','sol'};
cost=[-2 -1 0 0 -M -M 0]; %always include sol
A=[3 1 0 0 1 0; 4 3 -1 0 0 1; 1 2 0 1 0 0];
b=[3;6;3];
A=[A b];
art_v=[5,6];
bv=[];  % are those who form identity matrix in order
s=eye(size(A,1)); % no. of Rows in A
for i=1:size(s,2)
    for j=1:size(A,2)
        if s(:,i)==A(:,j)
            bv = [bv j];
        end
    end
end
RUN = true;
while RUN 
    ZjCj = cost(bv)*A-cost;
    ZC = ZjCj(1,1:end-1); %remove sol to find pvt_col
    ST = [A;ZjCj];
    ST = array2table(ST,'VariableNames',var)
    if any(ZC<0)
        [val,pvt_col]=min(ZC);
        if all(A(:,pvt_col)<=0)
            fprintf('Unbounded LPP');
            return;
        end
        sol=A(:,end);
        PC=A(:,pvt_col);
        for i=1:size(A,1)
            if PC(i)>0
                ratio(i)=sol(i)/PC(i);
            else
                ratio(i)=inf;
            end
        end
        [val,pvt_row]=min(ratio);
        PK = A(pvt_row,pvt_col);
        %%% Row Transformation
        A(pvt_row,:)=A(pvt_row,:)/PK; %pvt_row/PK
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col)*A(pvt_row,:);
            end
        end
        bv(pvt_row) = pvt_col;
    else
        RUN=false;
    end
end
if find(art_v) == any(bv)
    fprintf('Infeasible Solution');
end    
fprintf('Optimal Table ->');
ST
fprintf('\nOpt Sol = %f', ZjCj(end));