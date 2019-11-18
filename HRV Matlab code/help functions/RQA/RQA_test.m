
%%  If you need these codes that implement critical functions with (fast) C code, please visit my website:
%%  http://www.escience.cn/people/gxouyang/Tools.html

%  revise time: May 5 2014, Ouyang,Gaoxiang
%  Email: ouyang@bnu.edu.cn


I = 1;  % RP is the asymmetry matrix

P = rand(1,200);
[RP,DD] = RPplot_FAN(P,3,1,10,0);
subplot(121);imagesc(RP)
[RR1,DET1,ENTR1,L1] = Recu_RQA(RP,I)
P = sin(0.1:0.1:20);
[RP,DD] = RPplot_FAN(P,3,1,10,0);
subplot(122);imagesc(RP)
[RR2,DET2,ENTR2,L2] = Recu_RQA(RP,I)


figure(2)
I = 0;  % RP is the symmetry matrix

P = rand(1,200);
[RP,DD] = RPplot(P,3,1,.5,0);
subplot(121);imagesc(RP)
[RR1,DET1,ENTR1,L1] = Recu_RQA(RP,I)
P = sin(0.1:0.1:20);
[RP,DD] = RPplot(P,3,1,.5,0);
subplot(122);imagesc(RP)
[RR2,DET2,ENTR2,L2] = Recu_RQA(RP,I)
