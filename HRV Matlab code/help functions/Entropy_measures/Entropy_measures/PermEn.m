function [PermEn] = PermEn(series,L)
%{
Function which computes the Permutation Entropy (PermEn) of a time series. 
The alogorithm presented by Bandt and Pompe at "Permutation entropy: a
natural complexity measure for time series" has been followed.
(DOI: http://dx.doi.org/10.1103/PhysRevLett.88.174102).

INPUT:
        series: the time series.
        L: the embedding dimension. 

OUTPUT:
        PermEn: the PermEn value. 

PROJECT: Research Master in signal theory and bioengineering - University of Valladolid

DATE: 15/10/2014

VERSION: 1º

AUTHOR: Jesús Monge Álvarez
%}
%% Checking the ipunt parameters:
control = ~isempty(series);
assert(control,'The user must introduce a time series (first inpunt).');
control = ~isempty(L);
assert(control,'The user must introduce a embbeding dimension (second inpunt).');

%% Processing:
N = length(series);
% First, we compose the patterns of length 'L':
X = series(1:N);
for j = 1:L-1
   X = [X 
       series(j+1:N) zeros(1,j)];
end
% We eliminate the last 'L-1' columns of 'X' since they are not real patterns:
X = X(:,1:N-L+1); % 'X' is a matrix of size Lx(N-L+1) whose columns are the patterns

% Second, we get the permutation vectors:
shift = 0:(L-1); % The original shift vector of length 'L'
perm = NaN((N-L+1),L); % This matrix will include the permutation vectors of each pattern
aux = NaN(1,L); % Auxiliar variable
% This loop goes over the columns of matrix 'X':
for j = 1:(N-L+1)
    Y = X(:,j).';
    % We order the pattern upstream:
    Z = sort(Y);
    % This loop goes over the 'Z' vector:
    for i = 1:L
        if (i==1) % Thi first element cannot be repeated
            aux(i) = shift(find(Y==Z(i),1));
        else
            % If two numbers are repeated consecutively:
            if (Z(i) == Z(i-1))
                aux(i) = aux(i-1) + 1;
            else
                % If the are not repetead:
                aux(i) = shift(find(Y==Z(i),1));
            end
        end
    end
    % We save the permutation vector of the current pattern:
    perm (j,:) = aux;
    % Cleaning the auxiliary variable each iteration: 
    aux = NaN(1,L);
end

% Third, we compute the relative frequency of each permutation vector:
num = zeros(1,N-L+1); % This variable will contain the repetition of each permutation vector
% This loop goes over 'perm':
for j = 1:(N-L+1)
    % If it is NaN, the permutation vector has already been computed:
    if (isnan(perm(j,:)))
         continue;
    else
        % The permutation vector has not been computed. It appears at least one time:
        num(j) = num(j) + 1;
        % This loop goes over the rest of permutation vector to see if they
        % are equal to the current permutation vector:
        for i = j+1:(N-L+1)
            if (isnan(perm(i,:)))
            elseif (isequal(perm(j,:),perm(i,:)))
                num(j) = num(j) + 1; % The counter is incremented one unit
                perm(i,:)= NaN(1,L); % The permutation vector is replace by NaN values
            end
        end
     end
end

% Finally, we get the probability of each permutation vector:
num = num / (N-L+1);
% We get those ones which are different form zero:
num_dist = num(find(num ~= 0));
% We compute the Shannon entropy of the permutation vectors:
PermEn = (-1) * (num_dist * (log(num_dist)'));

end % End of the 'PermEn.m' function
