function [RP,DD] = RPplot_FAN(P,m,t,T,index)

%  Recurrence plot (RP) with Fixed amount of nearest neighbours (FAN)

%  Input:   P: time series;
%           m: the embedding dimension
%           t: the delay time
%           T: the fixed amount of nearest neighbours (FAN)
%           index: the value 0 or 1 (0 for Euclidean distance,1 for maximum distance)
% Output: 
%           RP:  Recurrence plot Matrix
%           DD:  Distance Matrix          

%  referrence: 
%  G Ouyang, X Li, C Dang, DA Richards, Using recurrence plot for determinism analysis of EEG recordings in genetic absence epilepsy rats, 
%  Clinical Neurophysiology 119 (8), 1747-1755
%
%  G Ouyang, X Zhu, Z Ju, H Liu, Dynamical Characteristics of Surface EMG Signals of Hand Grasps via Recurrence Plot,
%  IEEE Journal of Biomedical and Health Informatics,  18 (1), 257 - 265

%%  If you need these codes that implement critical functions with (fast) C code, please visit my website:
%%  http://www.escience.cn/people/gxouyang/Tools.html

%  revise time: May 5 2014, Ouyang,Gaoxiang
%  Email: ouyang@bnu.edu.cn
%  
%  Example:
% P = randn(1,100);
% [RP,DD] = RPplot_FAN(P,3,1,10,0);
% subplot(121);imagesc(RP)
% P = sin(0.1:0.1:10);
% [RP,DD] = RPplot_FAN(P,3,1,10,0);
% subplot(122);imagesc(RP)

% ==============================================
N=length(P);

X=zeros(N-(m-1)*t,m);
for k=1:(N-(m-1)*t)
    PP=[];
    for i=1:m
        PP=[PP P(1,k-t+i*t)];
    end
    X(k,:)=PP;
end
N1=length(X);


RP=zeros(N1,N1);
DD=zeros(N1,N1);

if index == 0;
    for k1=1:N1 
       for k2=k1+1:N1
           DD(k1,k2) = sum( (X(k1,:) - X(k2,:)).^2 );
       end
     end
    DD=DD+DD';
end

if index == 1
    for k1=1:N1       
        for k2=k1+1:N1
            DD(k1,k2) = max(abs(X(k1,:)-X(k2,:)));
        end
    end
    DD=DD+DD';
end

DD1 = DD + 2*max(max(DD))*eye(N1);
RP=zeros(N1,N1)+eye(N1);

for k=1:N1
    [Y I]=sort(DD1(:,k));
    RP(I(1:T),k)=RP(I(1:T),k)+1;
end

    
    

