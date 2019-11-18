function [RRI_output, added, removed] = RRI_adjust_v2(RRI, low, high)

%RRI: RR interval (in sec) directly from R peaks
%low: low cut off thresold 
%high: high cut off thresold

%output: adjusted RRI; number of beats added/removed

%% first remove R peaks with RRI <= low

num0 = length(RRI);
if sum(RRI(1:end-1) <= low)     
    Rbeats = cumsum(RRI);
    %figure; hold on;
    %plot(Rbeats, RRI);
    Rbeats(RRI(1:end-1) <= low) = [];
    RRI = Rbeats - [0 Rbeats(1:end-1)];
    %Rbeats = cumsum(RRI);
    %plot(Rbeats, RRI);
end

num1 = length(RRI);
minus1 = num1-num0;

%% next adjust RRI >= high
a = sum(RRI >= high);

while a    
    %Rbeats = cumsum(RRI);
    %figure; hold on;
    %plot(Rbeats, RRI);
    ind = find(RRI >= high, 1);
    bad_pt = RRI(ind);
    startpt = max(1, ind-15);
    endpt = min(length(RRI), ind+15);
    temp = median([RRI(startpt:ind-1) RRI(ind+1:endpt)]);
    n = round(bad_pt/temp);
    if n == 1
        n = 2;
    end   
    RRI = [RRI(1:ind-1) (bad_pt/n)*ones(1,n) RRI(ind+1:end)];
    %Rbeats = cumsum(RRI);
    %plot(Rbeats, RRI);
    a = sum(RRI >= high);
end   

num2 = length(RRI);
plus1 = num2 - num1;
%% remove small spikes from below

L = length(RRI);
Rbeats = cumsum(RRI);
bad_ind = [];
for k = 1:L-1
    startpt = max(1, k-15);
    endpt = min(L, k+15);
    iqr = quantile([RRI(startpt:k-1) RRI(k+1:endpt)], .75) - quantile([RRI(startpt:k-1) RRI(k+1:endpt)], .25);
    low1 = quantile([RRI(startpt:k-1) RRI(k+1:endpt)], .25) - 1.5*iqr;
    if RRI(k) <= low1
        bad_ind = [bad_ind k];
    end
end
Rbeats(bad_ind) = [];    
RRI = Rbeats - [0 Rbeats(1:end-1)]; 

num3 = length(RRI);
minus2 = num3 - num2;
%% remove spikes from above

L = length(RRI);
bad_ind = [];

for k = 1:L
    startpt = max(1, k-15);
    endpt = min(L, k+15);
    iqr = quantile([RRI(startpt:k-1) RRI(k+1:endpt)], .75) - quantile([RRI(startpt:k-1) RRI(k+1:endpt)], .25);
    high1 = quantile([RRI(startpt:k-1) RRI(k+1:endpt)], .75) + 1.5*iqr;
    if RRI(k) >= high1
        bad_ind = [bad_ind k];
    end
end    

if ~isempty(bad_ind)  
    bad_ind = sort(bad_ind,'descend');
    for kk = bad_ind
        bad_pt = RRI(kk);
        startpt = max(1, kk-10);
        endpt = min(length(RRI), kk+10);
        temp = median([RRI(startpt:kk-1) RRI(kk+1:endpt)]);
        n = round(bad_pt/temp);
        RRI = [RRI(1:kk-1) (bad_pt/n)*ones(1,n) RRI(kk+1:end)];              
    end
    Rbeats = cumsum(RRI);  
    RRI = Rbeats - [0 Rbeats(1:end-1)];
end

num4 = length(RRI);
plus2 = num4 - num3;

added = plus1 + plus2;
removed = minus1 + minus2;
RRI_output = RRI;
end