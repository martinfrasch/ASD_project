function [CCE_min] = CorrecCondEn(series,Lmax,num_int)
%{
Function which computes the Corrected Conditional Entropy (CCE) of a time 
series of length 'N' using an embedding dimension 'L' and 'Num_int' uniform
intervals of quantification. The algoritm presented by Porta et al. at 
"Measuring regularity by means of a corrected conditional entropy in 
sympathetic outflow" (PMID: 9485587) has been followed. 

INPUT:
        series: the time series.
        Lmax: the maximum embedding dimension employed.
        num_int: the number of uniform intervals used in the quantification
        of the series.

OUTPUT:
        CCE_min: the CCE value. The best estimation of the CCE is the
        minimum value of all the CCE that have been computed.

PROJECT: Research Master in signal theory and bioengineering - University of Valladolid

DATE: 15/10/2014

VERSION: 1º

AUTHOR: Jesús Monge Álvarez
%}
%% Checking the ipunt parameters:
control = ~isempty(series);
assert(control,'The user must introduce a time series (first inpunt).');
control = ~isempty(Lmax);
assert(control,'The user must introduce an embbeding dimension (second inpunt).');
control = ~isempty(num_int);
assert(control,'The user must introduce a number of intervals (third inpunt).');

%% Processing:
N = length(series);
% We will use this for the correction term: (L=1)
[E_est_1,~] = ShannonEn(series,1,num_int);

%Incialización de la primera posición del vector que almacena la CCE a un
%número elevado para evitar que se salga del bucle en L=2 (primera
%iteración):
% CCE is a vector that will contian the several CCE values computed:
CCE = NaN(1,Lmax); CCE(1) = 100;
CE = NaN(1,Lmax);
uniques = NaN(1,Lmax);
correc_term = NaN(1,Lmax);
for L = 2:1:Lmax
    % First, we compute the CE for the current embedding dimension: ('L')
    [CE(L),uniques(L)] = CondEn(series,L,num_int);
    
    % Second, we compute the percentage of patterns which are not repeated:
    perc_L = uniques(L)/(N-L+1);
    correc_term(L) = perc_L*E_est_1;
    
    % Third, the CCE is the CE plus the correction term:
    CCE(L) = CE(L) + correc_term(L);
end

% Finally, the best estimation of the CCE is the minimum value of all the 
% CCE that have been computed:
CCE_min = min(CCE);

end % End of the 'CorrecCondEn.m' function
