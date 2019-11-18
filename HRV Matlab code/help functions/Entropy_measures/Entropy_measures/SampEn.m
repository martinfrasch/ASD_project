function [SampEn] = SampEn(series,dim,r)
%{
Function which computes the Sample Entropy (SampEn) of a time series. The
alogorithm presented by Richman and Moorman at "Physiological time-series
analysis using approximate entropy and sample entropy" (PMID: 10843903) has
been followed.

INPUT:
        serie: the time series.
        dim: the embedding dimesion employed in the SampEn algorithm.
        r: the tolerance employed in the SampEn algorithm.

OUTPUT:
        SampEn: the SampEn value. 

PROJECT: Research Master in signal theory and bioengineering - University of Valladolid

DATE: 10/10/2014

VERSION: 1º

AUTHOR: Jesús Monge Álvarez
%}

%% Checking the ipunt parameters:
control = ~isempty(series);
assert(control,'The user must introduce a time series (first inpunt).');
control = ~isempty(dim);
assert(control,'The user must introduce a embbeding dimension (second inpunt).');
control = ~isempty(r);
assert(control,'The user must introduce a tolerand: r (third inpunt).');

%% Processing:
% Normalization of the input time series:
series = (series-mean(series))/std(series);
N = length(series);
result = zeros(1,2);
% Value of 'r' in case of not normalized time series:
% r = r*std(series);
    
for j = 1:2
    m = dim+j-1; % 'm' is the embbeding dimension used each iteration
    % Pre-definition of the varialbes for computational efficiency:
    patterns = NaN(m,N-m+1);
    count = NaN(1,N-m);
    
    % First, we compose the patterns
    % The columns of the matrix 'patterns' will be the (N-m+1) patterns of 'm' length:
    if m == 1 % If the embedding dimension is 1, each sample is a pattern
        patterns = series;
    else % Otherwise, we build the patterns of length 'm':
        for i = 1:m
            patterns(i,:) = series(i:N-m+i);
        end
    end
    
    % Second, we compute the number of patterns whose distance is less than the tolerance.
    % This loop goes over the columns of matrix 'patterns':
    for i = 1:N-m
        % We compute the maximum absolut distance between each pattern and the rest:
        if m == 1 
            temp = abs(patterns - repmat(patterns(:,i),1,N-m+1));
        else
            temp = max(abs(patterns - repmat(patterns(:,i),1,N-m+1)));
        end
        % We determine which elements of 'temp' are smaller than the tolerance:
        bool = (temp <= r);
        % We sum the numeber of patters which are similar to the current one:
        count(i) = (sum(bool)-1); % We rest 1 to avoid self-comparison
    end
    
    % Third, we average the number of similar patterns:
    count = count/(N-m-1);
    % Finally, we average the mean of similar patterns:
    result(j) = mean(count);
end

SampEn = log(result(1)/result(2));

end % End of the 'SampEn.m' function
