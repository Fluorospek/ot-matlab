clc
clear
cost=[2 1 0 0 0 0];
A=[1 2 1 0 0; 1 1 0 1 0; 1 -1 0 0 1];
b=[10; 6; 2];
A=[A b];
bv=[3 4 5];
var={'x1','x2','s1','s2','s3','b'};
ZjCj=cost(bv)*A-cost;
simplex_table=[A;ZjCj];
array2table(simplex_table,'VariableNames',var)
RUN=true;
while RUN
    ZC=ZjCj(1:end-1);
    if any(ZC<0)
        fprintf('Solution is not optimal \n');
        [Enter_var,Pivot_col]=min(ZC);
        if all(A(:,Pivot_col)<=0)
            fprintf('LPP is unbounded');
        else
            sol=A(:,end);
            column=A(:,Pivot_col);
            for i=1:size(A,1)
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=inf;
                end
            end
        end
        [Leaving_value Pivot_row]=min(ratio);
        Pivot_key=A(Pivot_row,Pivot_col);
        bv(Pivot_row)=Pivot_col;
        A(Pivot_row,:)=A(Pivot_row,:)/Pivot_key;
        for i=1:size(A,1)
            if i~=Pivot_row
                A(i,:)=A(i,:)-A(i,Pivot_col)*A(Pivot_row,:);
            end
        end
        ZjCj=cost(bv)*A-cost;
        new_table=[A;ZjCj];
        array2table(new_table,'VariableNames',var)
    else
        RUN=false;
    end
end
fprintf('The optimal solution is %f \n',ZjCj(end));