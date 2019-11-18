function [CE,unique] = CondEn(series,L,num_int)
%{
Function which computes the Conditional Entropy (CE) of a time series of 
length 'N' using an embedding dimension 'L' and 'Num_int' uniform intervals
of quantification. The algoritm presented by Porta et al. at "Measuring 
regularity by means of a corrected conditional entropy in sympathetic 
outflow" (PMID: 9485587) has been followed. 

INPUT:
        series: the time series.
        L: the embedding dimension.
        num_int: the number of uniform intervals used in the quantification
        of the series.

OUTPUT:
        CE: the CE value.
        unique: the number of patterns which have appeared only once. This
        output is only useful for computing other more complex entropy
        measures such as Corrected Conditional Entorpy. If you do not want 
        to use it, put '~' in the call of the function.

PROJECT: Research Master in signal theory and bioengineering - University of Valladolid

DATE: 15/10/2014

VERSION: 1º

AUTHOR: Jesús Monge Álvarez
%}
%% Checking the ipunt parameters:
control = ~isempty(series);
assert(control,'The user must introduce a time series (first inpunt).');
control = ~isempty(L);
assert(control,'The user must introduce an embbeding dimension (second inpunt).');
control = ~isempty(num_int);
assert(control,'The user must introduce a number of intervals (third inpunt).');

%% Processing:
% First, we call the Shannon Entropy function:
% 'L' as embedding dimension:
[SE,unique] = ShannonEn(series,L,num_int);
% 'L-1' as embedding dimension:
[SE_1,~] = ShannonEn(series,(L-1),num_int);
% The Conditional Entropy is defined as a differential entropy:
CE = SE - SE_1;

end % End of the 'CondEn.m' function

