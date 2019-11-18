function [SE,unique] = ShannonEn(series,L,num_int)
%{
Function which computes the Shannon Entropy (SE) of a time series of length
'N' using an embedding dimension 'L' and 'Num_int' uniform intervals of
quantification. The algoritm presented by Porta et al. at "Measuring 
regularity by means of a corrected conditional entropy in sympathetic 
outflow" (PMID: 9485587) has been followed.

INPUT:
        series: the time series.
        L: the embedding dimension.
        num_int: the number of uniform intervals used in the quantification
        of the series.

OUTPUT:
        SE: the SE value.
        unique: the number of patterns which have appeared only once. This
        output is only useful for computing other more complex entropy
        measures such as Conditional Entorpy or Corrected Conditional
        Entorpy. If you do not want to use it, put '~' in the call of the
        function.

PROJECT: Research Master in signal theory and bioengineering - University of Valladolid

DATE: 15/10/2014

VERSION: 1�

AUTHOR: Jes�s Monge �lvarez
%}
%% Checking the ipunt parameters:
control = ~isempty(series);
assert(control,'The user must introduce a time series (first inpunt).');
control = ~isempty(L);
assert(control,'The user must introduce an embbeding dimension (second inpunt).');
control = ~isempty(num_int);
assert(control,'The user must introduce a number of intervals (third inpunt).');

%% Processing:
% Normalization of the input time series:
series = (series-mean(series))/std(series);

% We the values of the parameters required for the quantification:
epsilon = (max(series)-min(series))/num_int;
partition = min(series):epsilon:max(series);
codebook = -1:num_int;
% Uniform quantification of the time series:
[~,quants] = quantiz(series, partition, codebook);
% The minimum value of the signal quantified assert passes -1 to 0:
quants(logical(quants == -1)) = 0;

% We compose the patterns of length 'L':
N = length(quants); X = quants(1:N);
for j = 1:L-1
   X=[X 
       quants(j+1:N) zeros(1,j)];
end
% We eliminate the last 'L-1' columns of 'X' since they are not real patterns:
X = X(:,1:N-L+1);

% We get the number of repetitions of each pattern:
num = ones(1,N-L+1); % This vector will contain the repetition of each pattern
% This loop goes over the columns of 'X':
for j = 1:(N-L+1)
    for i = j+1:(N-L+1)
        tmp = ~isnan(X(:,j));
        if (tmp(1)) && (isequal(X(:,j),X(:,i)))
            num(j) = num(j) + 1; % The counter is incremented one unit
            X(:,i) = NaN(L,1); % The pattern is replace by NaN values
        end
        % Reset of the auxiliar variable each iteration:
        tmp = NaN;
    end
end

% We get those patterns which are not NaN:
aux = ~isnan(X(1,:));
% Now, we can compute the number of different patterns:
new_num = num(logical(aux));

% We get the number of patterns which have appeared only once:
unique = sum(new_num == 1);

% We compute the probability of each pattern:
p_i = new_num/(N-L+1);

% Finally, the Shannon Entropy is computed as:
SE = (-1) * ((p_i)*(log(p_i)).');

end % End of the 'ShannonEn.m' function
