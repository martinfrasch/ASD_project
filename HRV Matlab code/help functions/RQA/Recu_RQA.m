function [RR,DET,ENTR,L] = Recu_RQA(RP,I)

% Recurrence quantification analysis of recurrence plots
% RP:  the Recurrence Plot
% I:   the indication marks (I=0 RP is the symmetry matrix
%                            I=1 RP is the asymmetry matrix)  

% RR:   Recurrence rate RR, The percentage of recurrence points in an RP
%       Corresponds to the correlation sum;
% DET:  Determinism DET, The percentage of recurrence points which form
%       diagonal lines
% ENTR: Entropy ENTR, The Shannon entropy of the probability distribution of the diagonal
%       line lengths p(l)
% L:    Averaged diagonal line length L, The average length of the diagonal lines

%%  If you need these codes that implement critical functions with (fast) C code, please visit my website:
%%  http://www.escience.cn/people/gxouyang/Tools.html

%  revise time: May 5 2014, Ouyang,Gaoxiang
%  Email: ouyang@bnu.edu.cn

Lmin=2;

if nargin < 2
    I=0;
end

N1=size(RP,1);

Yout=zeros(1,N1);

for k=2:N1
    On=1;
    while On<=N1+1-k
        if RP(On,k+On-1)==1
            A=1;off=0;
            while off==0 && On~=N1+1-k
                if RP(On+1,k+On)==1
                    A=A+1;On=On+1;
                else
                    off=1;
                end
            end
            Yout(A)=Yout(A)+1;
        end 
        On=On+1;
    end
end
if I==0
    S=2*Yout;
end       

if I==1
    RP=RP';
    for k=2:N1
        On=1;
        while On<=N1+1-k
            if RP(On,k+On-1)==1
                A=1;off=0;
                while off==0 && On~=N1+1-k
                    if RP(On+1,k+On)==1
                        A=A+1;On=On+1;
                    else
                        off=1;
                    end
                end
                Yout(A)=Yout(A)+1;
            end 
            On=On+1;
        end
    end
    S=Yout;
end

%% calculate the recurrence rate (RR)
SR=0;
for i=1:N1
    SR=SR+i*S(i);
end
RR=SR/(N1*(N1-1));

%% calculate the determinism (%DET)
if SR==0
    DET=0;
else
    DET=(SR-sum(S(1:Lmin-1)))/SR;
end

%% calculate the ENTR = entropy (ENTR)
pp=S/sum(S);
entropy=0;
F=find(S(Lmin:end));
l=length(F);
if l==0
    ENTR=0;
else
    F=F+Lmin-1;
    ENTR=-sum(pp(F).*log(pp(F)));
end

%% calculate Averaged diagonal line length (L)
L=(SR-sum([1:Lmin-1].*S(1:Lmin-1)))/sum(S(Lmin:end));

