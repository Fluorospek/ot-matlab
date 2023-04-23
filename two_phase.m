%2-phase 3rd question
clc;
clear all;
c = [ 0 0 0 0 -1 0]
A = [ 1 1 1 0 0; 1 3 0 1 0; 1 -1 0 0 1]
b = [2;3;1]
A = [ A b]
bv = [3 4 5]
zjcj = c(bv)*A - c
simplex_table = [A; zjcj]
array2table(simplex_table , 'VariableNames', {'x1','x2','s1','s2','R1','sol'})
RUN = true
while RUN
    zc = zjcj(1:end-1);
    if any(zc<0)
        fprintf('sol is not optimal \n')
        [enter_val pvt_col] = min(zc);
        if all(A(:,pvt_col)<=0)
            fprintf('lpp is unbounded \n')
            RUN = false;
        else
            sol = A(:,end);
            col = A(:,pvt_col);
            for i = 1: size(A,1)
                if col(i) >0
                    ratio(i) = sol(i)/col(i);
                else
                    ratio(i) = inf;
                end
            end
            [leaving_value  pvt_row] = min(ratio);
         pvt_key = A( pvt_row, pvt_col);
         bv(pvt_row) = pvt_col;
         A(pvt_row, :)= A(pvt_row, :)/pvt_key;
         % row operations
         for i = 1:size(A,1)
             if i ~= pvt_row
                 A(i,:) = A(i,:)-A(i,pvt_col)*A(pvt_row,:);
             end
         end
         zjcj = c(bv)*A - c;
         new_table = [A; zjcj];
         array2table(new_table, 'Variablenames', {'x1','x2','s1','s2','R1','sol'})
        end 
    else
        RUN = false;
        fprintf('the optimal sol is %f \n',-zjcj(end))
    end
end
if A(end,5)>0 && zjcj(end) ~= 0
    fprintf('infeasible solution \n')
    return;
else
c = [ 3 2 0 0 0]
b = A(:,6)
A = A(:,1:4)
A = [ A b]
zjcj = c(bv)*A - c
simplex_table = [A; zjcj]
array2table(simplex_table , 'VariableNames', {'x1','x2','s1','s2','sol'})
RUN = true;
while RUN
    zc = zjcj(1:end-1);
    if any(zc<0)
        fprintf('sol is not optimal \n')
        [enter_val pvt_col] = min(zc);
        if all(A(:,pvt_col)<=0)
            RUN = false;
            fprintf('lpp is unbounded \n')
        else
            sol = A(:,end);
            col = A(:,pvt_col);
            for i = 1: size(A,1)
                if col(i) >0
                    ratio(i) = sol(i)/col(i);
                else
                    ratio(i) = inf;
                end
            end
            [leaving_value, pvt_row] = min(ratio);
            pvt_key = A(pvt_row, pvt_col);
         bv(pvt_row) = pvt_col;
         A(pvt_row, :)= A(pvt_row, :)/pvt_key;
         % row operations
         for i = 1:size(A,1)
             if i ~= pvt_row
                 A(i,:) = A(i,:)-A(i,pvt_col)*A(pvt_row,:);
             end
         end
         zjcj = c(bv)*A - c;
         new_table = [A; zjcj];
         array2table(new_table, 'Variablenames', {'x1','x2','s1','s2','sol'})
        end
         
    else
        RUN = false;
        fprintf('the optimal sol is %f \n',zjcj(end))
end
end
end