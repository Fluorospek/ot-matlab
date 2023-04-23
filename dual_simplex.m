clc
clear
A=[-1 -1 1 0 0; -1 1 0 1 0; -2 -1 0 0 1];
b=[-2; -10; -6];
C=[-2 -1 0 0 0 0];
A=[A b];
BV=[3 4 5];
ZjCj=C(BV)*A-C;
S=[A;ZjCj];
Var={'x1','x2','s1','s2','s3','Sol'};
array2table(S,'VariableNames',Var)
RUN=true;
while RUN
    sol=A(:,end);
    if any(sol<0)
        [leaving_var,pvt_row]=min(sol);
        ZRow=A(pvt_row,1:end-1);
        ZC=ZjCj(1:end-1);
        for i=1:size(A,2)-1
            if ZRow(i)<0
                ratio(i)=abs(ZC(i)/ZRow(i));
            else
                ratio(i)=inf;
            end
        end
        [enter_var,pvt_col]=min(ratio);
        BV(pvt_row)=pvt_col;
        pvt_key=A(pvt_row, pvt_col);
        A(pvt_row,:)=A (pvt_row,:)./pvt_key; 
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A (i, pvt_col).*A(pvt_row,:);
            end
        end
        zjcj=C(BV)*A-C;
        next_table=[A; zjcj];
        array2table(next_table,'VariableNames',Var)
    else
        RUN=false;
        fprintf('The final optimal value is % f \n',zjcj(end));
    end
end