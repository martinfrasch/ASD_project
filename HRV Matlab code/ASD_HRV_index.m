%% read data

[~, sheet_name] = xlsfinfo('SBS IBI - Baseline 10 Epochs - 3-19-2018.xlsx');
for k = 1:numel(sheet_name)
    data{k, 1} = sheet_name{k};
    data{k, 2} = xlsread('SBS IBI - Baseline 10 Epochs - 3-19-2018.xlsx', sheet_name{k});
end

%split each subject into 10 epoches
for i = 1:36
    a = [NaN; data{i, 2}; NaN];
    startpt = find(isnan(a)) + 2;
    startpt = startpt(1:end-1);
    endpt = find(isnan(a)) - 1;
    endpt = endpt(2:end);
    
    data{i,3} = cell(10,1);
    for j = 1:10
        data{i,3}{j,1} = a(startpt(j):endpt(j)) / 1000;  %convert to sec 
    end   
end

%read label and sort by label
label = xlsread('SBS groupings - 3-26-2018.xlsx');
for i = 1:36
    data{i, 2} = label(i, 2);
end
[~, ind] = sort(label(:,2));
data = data(ind, :);

%%  RRI adjust

for i = 1:36
    rri = [];
    ADDED = [];
    REMOVED = [];
    for j = 1:10
        a = data{i,3}{j};
        [aa, added, removed] = RRI_adjust_v2(a', 0.4, 2);
        data{i,4}{j, 1} = aa';
        rri = [rri; aa'];
        ADDED = [ADDED added];
        REMOVED = [REMOVED removed];
    end
    data{i,5} = rri;
    data{i,6} = ADDED;
    data{i,7} = REMOVED;
end

ADDED = [];
for i = 1:36
    ADDED(i,:) = data{i,6};
end   

REMOVED = [];
for i = 1:36
    REMOVED(i,:) = data{i,7};
end 
%% observe before adjust vs after adjust
for i = 1:36
    figure; hold on
    a = [];
    aa = [];
    for j = 1:10
        a = [a; data{i,3}{j}];
        aa = [aa; data{i,4}{j}];
    end   
    plot(cumsum(a), a); plot(cumsum(aa),aa)
end


%% IBI data and CD and depr data
listing = dir('/Users/chaos/Dropbox/ASD project/IBI files - combined groups/data');
%listing = dir('/Users/chaos/Dropbox/ASD project/CD and depr groups together/data');
name = cell(0,0);
for i = 4:39 %4:33
    name{i-3, 1} = listing(i).name;
end

data = cell(0,0);   %5 cols: ID; original sig; orig sig epochs; adjusted sig epochs; concatenate all epochs 
for i = 1:36  %1:30
    data{i,1} = name{i,1};
    sig = importdata(name{i,1});
    sig = sig(:,1);
    data{i,2} = sig/1000;
    ind = find(sig < 120);
    ind = [ind; length(sig)];
    startpt = ind(1:end-1);
    endpt = ind(2:end);
    rri = [];
    ADDED = [];
    REMOVED = [];
    for j = 1:10  %only need first 5 min i.e. 10 epochs %1:length(startpt)
        a = sig(startpt(j)+1:endpt(j)-1) / 1000; %convert to sec
        data{i,3}{j,1} = a;
        [aa, added, removed] = RRI_adjust_v2(a', 0.4, 2);  %adjust RRI
        data{i,4}{j, 1} = aa';
        rri = [rri; aa'];
        ADDED = [ADDED added];
        REMOVED = [REMOVED removed];  
    end        
    data{i,5} = rri;
    data{i,6} = ADDED;
    data{i,7} = REMOVED;
end   

ADDED = []; %number of beats added
for i = 1:36
    ADDED(i,:) = data{i,6};
end   

REMOVED = []; %number of beats removed
for i = 1:36
    REMOVED(i,:) = data{i,7};
end 

%% corrected CD and depr data
%listing = dir('/Users/chaos/Dropbox/ASD project/corrected files/Corrected files for BASELINE ONLY_April 17/CD');
listing = dir('/Users/chaos/Dropbox/ASD project/corrected files/Corrected files for BASELINE ONLY_April 17/Depression');

name = cell(0,0);
for i = 3:17
    name{i-2, 1} = listing(i).name;
end

data = cell(0,0);   %5 cols: ID; original sig; orig sig epochs; adjusted sig epochs; concatenate all epochs 
for i = 1:15 
    data{i,1} = name{i,1};
    sig = importdata(name{i,1});
    sig = sig(:,1);
    data{i,2} = sig/1000;
    ind = find(sig < 120);
    ind = [ind; length(sig)];
    startpt = ind(1:end-1);
    endpt = ind(2:end);
    rri = [];
    ADDED = [];
    REMOVED = [];
    for j = 1:10  %only need first 5 min i.e. 10 epochs %1:length(startpt)
        a = sig(startpt(j)+1:endpt(j)-1) / 1000; %convert to sec
        data{i,3}{j,1} = a;
        [aa, added, removed] = RRI_adjust_v2(a', 0.4, 2);  %adjust RRI
        data{i,4}{j, 1} = aa';
        rri = [rri; aa'];
        ADDED = [ADDED added];
        REMOVED = [REMOVED removed];  
    end        
    data{i,5} = rri;
    data{i,6} = ADDED;
    data{i,7} = REMOVED;
end   

ADDED = [];
for i = 1:15
    ADDED(i,:) = data{i,6};
end   

REMOVED = [];
for i = 1:15
    REMOVED(i,:) = data{i,7};
end 

%% observe before adjust vs after adjust
for i = 1:10
    figure; hold on
    a = data{i,2};
    aa = data{i,5};
    plot(cumsum(a), a); plot(cumsum(aa),aa)
    xlabel('time sec', 'fontsize', 15); ylabel('RRI in sec', 'fontsize', 15);
    legend({'original', 'adjusted'}, 'fontsize', 20)
end

%% 3 new data
listing = dir('/Users/chaos/Dropbox/ASD project/three more subjects');
name = cell(0,0);
for i = 4:6
    name{i-3, 1} = listing(i).name;
end

data = cell(0,0);   %5 cols: ID; original sig; orig sig epochs; adjusted sig epochs; concatenate all epochs 
for i = 1:3
    data{i,1} = name{i,1};
    sig = importdata(name{i,1});
    sig = sig(:,1);
    data{i,2} = sig/1000;
    ind = find(sig < 120);
    ind = [ind; length(sig)];
    startpt = ind(1:end-1);
    endpt = ind(2:end);
    rri = [];
    ADDED = [];
    REMOVED = [];
    for j = 1:10  %only need first 5 min i.e. 10 epochs %1:length(startpt)
        a = sig(startpt(j)+1:endpt(j)-1) / 1000; %convert to sec
        data{i,3}{j,1} = a;
        [aa, added, removed] = RRI_adjust_v2(a', 0.4, 2);  %adjust RRI
        data{i,4}{j, 1} = aa';
        rri = [rri; aa'];
        ADDED = [ADDED added];
        REMOVED = [REMOVED removed]; 
    end        
    data{i,5} = rri;
    data{i,6} = ADDED;
    data{i,7} = REMOVED;
end   

ADDED = [];
for i = 1:18
    ADDED(i,:) = data{i,6};
end   

REMOVED = [];
for i = 1:18
    REMOVED(i,:) = data{i,7};
end 


%% observe before adjust vs after adjust
for i = 1:36
    figure; hold on
    a = data{i,2};
    aa = data{i,5};
    plot(cumsum(a), a); plot(cumsum(aa),aa)
    xlabel('time sec', 'fontsize', 15); ylabel('RRI in sec', 'fontsize', 15);
    legend({'original', 'adjusted'}, 'fontsize', 20)
end


%% SDNN, RMSSD

indices = [];
for i = 1:15
    ind = [];
    for j = 1:size(data{i, 4})
        RRI = data{i, 4}{j, 1};
        dRRI = RRI(2:end)-RRI(1:end-1);
        SDNN = std(RRI) ;
        RMSSD = sqrt( sum(dRRI.^2) ./ length(dRRI) );
        ind(j,1) = SDNN;
        ind(j,2) = RMSSD;
    end    
    indices(i,:) = mean(ind);
end   


%% SD1, SD2
indices = [];
for i = 1:15
    ind = [];
    for j = 1:size(data{i, 4})
        RRI = data{i, 4}{j, 1};
        dRRI = RRI(2:end)-RRI(1:end-1);
        SDNN = std(RRI) ;
        SDSD = std(dRRI);
        SD1 = SDSD ./ sqrt(2);
        SD2 = sqrt( 2*SDNN.^2 - SDSD.^2 ./ 2 );
        ind(j,1) = SD1;
        ind(j,2) = SD2;
    end   
    indices(i,:) = mean(ind);
end  


%% sample entropy, fuzzy entropy
indices = [];
for i = 1:15
    RRI = data{i, 5};
    SE = SampEn(RRI', 5, 0.2);
    FE = FuzzyEn(RRI', 5, 2, 2);
    indices(i, 1) = SE;
    indices(i, 2) = FE; 
end   

%% skewness
indices = [];
for i = 1:15
    RRI = data{i, 5};
    moment_sk = skewness(RRI, 0);
    mode_sk = (mean(RRI) - mode(RRI)) ./ std(RRI);
    med_sk = 3 * (mean(RRI) - median(RRI)) ./ std(RRI);
    indices(i, 1) = moment_sk;
    indices(i, 2) = mode_sk;
    indices(i, 3) = med_sk;
end  

%% LF power, HF power
indices = [];
for i = 1:15
    RRI = data{i, 5};
    %interpolate to 4Hz
    time = cumsum(RRI);
    time = [0; time(1:end-1)];
    time_resample = ceil(time(1)):.25:floor(time(end));
    RRI_resample = spline(time,RRI,time_resample);
    if mod(length(RRI_resample),2)
        RRI_resample = RRI_resample(1:end-1);
    end
    %FFT
    Fs = 4;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = length(RRI_resample);             % Length of signal
    t = (0:L-1)*T;        % Time vector
    Y = fft(RRI_resample);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    %plot(f, P1)         %fourier transform
    
    %LF power, 0.04 to 0.15 Hz
    ind = f >= .04 & f <= .15;
    LF = trapz(f(ind), P1(ind)); 
    %HF power, 0.15 to 0.50 Hz
    ind = f >= .15 & f <= .5;
    HF = trapz(f(ind), P1(ind));
    
    indices(i, 1) = LF;
    indices(i, 2) = HF;
end   


%% RQA: RR, DET, ENTR, L
indices = [];
for i = 1:15
    RRI = data{i, 5};
    [RP, ~] = RPplot(RRI', 3, 1, 0.5, 1) ;
    [RR, DET, ENTR, L] = Recu_RQA(RP, 0);
    indices(i, 1) = RR;
    indices(i, 2) = DET;
    indices(i, 3) = ENTR;
    indices(i, 4) = L;
end
