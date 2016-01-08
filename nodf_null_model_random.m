input_matrix; % W input matrix
rows=size(W,1); % number of rows
columns=size(W,2); % number of columns
nodf_whole_matrix=zeros(1000,1); % number of replicates

t=1;
while t <= 1000 % number of replicates

	%==================%
	%--- NULL MODEL ---%
	%==================%
	
	input_matrix; % W input matrix
	t
	number_ones=nnz(W);
	B=zeros(rows,columns);
	count_ones=0;
	while count_ones < number_ones
	  x=unidrnd(rows);
	  y=unidrnd(columns);
	  while B(x,y)==1
	    x=unidrnd(rows);
	    y=unidrnd(columns);
	  end
	  B(x,y)=1;
	  count_ones=count_ones+1;
	end

	sum_cols=sum(B,1); % row vector
	sum_rows=sum(B,2); % col vector
	if (all(sum_cols)==1 && all(sum_rows)==1) % if the matrix size is preserved

		%=============
		%--- NODF ---%
		%=============

		W=B;

		%%% nestedness columns
		G=zeros((columns*(columns-1))/2,3); % number of different pairs of columns
		x=0;
		for i=1: columns
		  for j=i+1: columns
		    suma=0;
		    for k=1: rows
		      suma=suma+(W(k,i)*W(k,j));
		    end
		    p=nnz(W(:,i)); % number of ones in the i column
		    q=nnz(W(:,j)); % number of ones in the j column
		    if p > q
		      min_column=q;
		      x=x+1;
		      G(x,1)=i;
		      G(x,2)=j;
		      G(x,3)=suma/min_column;
		    elseif p < q
		      min_column=p;
		      x=x+1;
		      G(x,1)=i;
		      G(x,2)=j;
		      G(x,3)=suma/min_column;
		    else  
		      x=x+1;
		      G(x,1)=i;
		      G(x,2)=j;
		      G(x,3)=0;
		    end
		  end
		end
		G;
		col_vector=sum(G,1); % sum of the elements of each column (size= 1 X 3)
		result_cols=col_vector(1,3)/x;
		suma_nodf_cols=col_vector(1,3);

		%% nestedness rows
		G=zeros((rows*(rows-1))/2,3); % number of different pairs of rows
		x=0;
		for i=1: rows
		  for j=i+1: rows
		    suma=0;
		    for k=1: columns
		      suma=suma+(W(i,k)*W(j,k));
		    end
		    p=nnz(W(i,:)); % number of ones in the i row
		    q=nnz(W(j,:)); % number of ones in the j row
		    if p > q
		      min_row=q;
		      x=x+1;
		      G(x,1)=i;
		      G(x,2)=j;
		      G(x,3)=suma/min_row;
		    elseif p < q
		      min_row=p;
		      x=x+1;
		      G(x,1)=i;
		      G(x,2)=j;
		      G(x,3)=suma/min_row;
		    else
		    x=x+1;
		    G(x,1)=i;
		    G(x,2)=j;
		    G(x,3)=0;
		    end
		  end
		end
		G;
		row_vector=sum(G,1); % sum of the elements of each column (size= 1 X 3)
		result_rows=row_vector(1,3)/x;
		suma_nodf_rows=row_vector(1,3);
		nodf_whole_matrix(t,1)=(suma_nodf_cols+suma_nodf_rows)/(((columns*(columns-1))/2)+((rows*(rows-1))/2));
	
	t=t+1;
	end
end
dlmwrite('result_random.txt', nodf_whole_matrix, ' ');
