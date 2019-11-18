function [ApEn] = ApEn(series,dim,r)
%{
Function which computes the Aproxiamte Entropy (ApEn) of a time series. The
alogorithm presented by Pincus et al. at "A regularity statistic for
medical data analysis" (DOI:10.1007/BF01619355) has been followed.

INPUT:
        serie: the time series.
        dim: the embedding dimesion employed in the ApEn algorithm.
        r: the tolerance employed in the ApEn algorithm.

OUTPUT:
        ApEn: the ApEn value. 

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
assert(control,'The user must introduce a tolerand (r) (third inpunt).');

%% Processing:
N = length(series);
result = zeros(1,2);
r = r*std(series);

for j = 1:2
    m = dim+j-1; % 'm' is the embbeding dimension used each iteration
    % Pre-definition of the varialbes for computational efficiency:
    phi = zeros(1,N-m+1);
    patterns = zeros(m,N-m+1);
    
    % First, we compose the patterns
    % The columns of the matrix 'patterns' will be the (N-m+1) patterns of 'm' length:
    if m == 1 % If the embedding dimension is 1, each sample is a pattern:
        patterns = series;
    else % Otherwise, we build the patterns of length 'm':
        for i = 1:m
            patterns(i,:) = series(i:N-m+i);
        end
    end
    
    % Second, we compute the number of patterns whose distance is less than the tolerance.
    % This loop goes over the columns of matrix 'patterns':
    for i = 1:N-m+1
        % 'temp' is an auxiliar matrix whose elements are the maximum 
        % absolut difference between the current pattern and the rest:
        if m == 1 
            temp = abs(patterns - repmat(patterns(:,i),1,N-m+1));
        else
            temp = max(abs(patterns - repmat(patterns(:,i),1,N-m+1)));
        end
        % We determine which elements of 'temp' are smaller than the tolerance:
        bool = any((temp < r),1);
        % We get the relative frequency of the current pattern: 
        phi(i) = sum(bool)/(N-m+1);
    end

    % Finally, we average the natural logarithm of all relative frequencies:
    result(j) = mean(log(phi));
end

ApEn = result(1)-result(2);

end % End of the 'ApEn.m' function
