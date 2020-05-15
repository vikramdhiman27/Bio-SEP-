%% Proposed Protocols 
% Proposed Protocols Code to show Dead Nodes
clear all
clc
close all
global gh
gh = 1; 

%% ========== Assume Parameters  ==============

% Value of x and y ( in Meters)

xm = input('Enter the x Values (prefer 100)');
ym = input('Enter the y Values (prefer 100)');

% find out Sink out Coordinates. 

sink.x = input('Enter the x Coordinate Sink(prefer 50)');   %.5 * xValue ; 
                                   % centre of x  ( Also vary this Value)
sink.y = input('Enter the y Coordinate Sink (prefer 50)'); %yValue * .75 + yValue
                                    % centre of y  ( Also vary this Value)

% Energy Model ( Values Assumed in Joules)

Eo = input('Enter the Energy value between 0.5 to 1 : ') ;   

% Number of Nodes Assumed

n = input('Enter the Total number of Node to Deploy (prefer 100)'); %100;

% How much rounds you require

rmax = input('Enter the max round to Calculate Dead Node');

% parameters Assumed to create Clusture Head from Node

load parameters_P

%%===================================================================

%% LOGIC IMPLIMENTATION 

% Show all 4 Mode in Normal Mode
for i=1:1:n
    S1(i).xd=rand(1,1)*xm;
    S2(i).xd=S1(i).xd;
    S3(i).xd=S1(i).xd;
    S4(i).xd=S3(i).xd;
    XR4(i)=S4(i).xd;
    XR3(i)=S3(i).xd;
    XR2(i)=S2(i).xd;
    XR1(i)=S1(i).xd;
    S1(i).yd=rand(1,1)*ym;
    S2(i).yd=S1(i).yd;
    S3(i).yd=S1(i).yd;
    S4(i).yd=S3(i).yd;
    YR4(i)=S4(i).yd;
    S4(i).G=0;
    YR3(i)=S3(i).yd;
    S3(i).G=0;
    YR2(i)=S2(i).yd;
    YR1(i)=S1(i).yd;
    S1(i).G=0;
    S2(i).G=0;
    S1(i).E=Eo*(1+rand*1);
    S2(i).E=S1(i).E;
    S3(i).E=S1(i).E;
    S4(i).E=S3(i).E;
    E3(i)= S3(i).E;
    E4(i)= S4(i).E;
    Et=Et+E3(i);

    %initially there are no cluster heads only nodes
    S1(i).type='N';
    S2(i).type='N';
    S3(i).type='N';
    S4(i).type='N';
end

%% 1 & 2 parametr Calculation
S1(n+1).xd=sink.x;
S1(n+1).yd=sink.y;
S2(n+1).xd=sink.x;
S2(n+1).yd=sink.y;

%% Call BFO 
save qqww
BG
load qqww

% if(gh==2)
%% call 1st logic
allive1=n;     % copy Value
 
load variable_P1

STATISTICS1 = logic_1(rmax,n,p,S1,flag_first_dead1,...
    flag_teenth_dead1,flag_all_dead1,...
    packets_TO_BS1,ETX,EDA,ERX,...
    Emp,Efs,do,allive1,...
    packets_TO_CH1)

%% Call 2 logic
allive2=n;

load variable_P2

STATISTICS2 = logic_2(rmax,n,p,S2,flag_first_dead2,...
    flag_teenth_dead2,flag_all_dead2,...
    packets_TO_BS2,ETX,EDA,ERX,...
    Emp,Efs,do,allive2,...
    packets_TO_CH2)

%% 3 & 4 parametr Calculation
d1=0.765*xm/2;
K=sqrt(0.5*n*do/pi)*xm/d1^2;
d2=xm/sqrt(2*pi*K);
Er=4000*(2*n*ETX+n*EDA+K*Emp*d1^4+n*Efs*d2^2);
S3(n+1).xd=sink.x;
S3(n+1).yd=sink.y;
S4(n+1).xd=sink.x;
S4(n+1).yd=sink.y;

%% Call 3rd Logic
allive3=n;

load variable_P3

STATISTICS3 = logic_3(rmax,n,p,P,S3,flag_first_dead3,...
    flag_teenth_dead3,flag_all_dead3,...
    packets_TO_BS3,ETX,EDA,ERX,...
    Emp,Efs,do,allive3,packets_TO_CH3,Et,E3)

%% Call 4th Logic
allive4=n;

load variable_P4
STATISTICS4 = logic_4(rmax,n,p,P,S4,flag_first_dead4,...
    flag_teenth_dead4,flag_all_dead4,...
    packets_TO_BS4,ETX,EDA,ERX,...
    Emp,Efs,do,allive4,...
    packets_TO_CH4,Et,E4)

%%  PLOT COMMANDS
 
r=0:5000;


% figure(25), plot(r,STATISTICS4.DEAD4,'m','linewidth',2)
% xlabel('TIME');
% ylabel('NUMBER OF DEAD NODES');
% title('\bf BFO');
figure(6)
plot(r,STATISTICS1.DEAD1,'g',50:5050,STATISTICS3.DEAD3,'k',r,STATISTICS4.DEAD4,'m',310:5310,STATISTICS2.DEAD2,'r','linewidth',2);
legend('Leach-BFO','BIHP','SEP with BFO','E-SEP with BFO');
xlabel('Number of Rounds ->');
ylabel('NUMBER OF DEAD NODES');
title('\bf Leach-BFO v/s BIHP v/s SEP with BFO v/s E-SEP with BFO');

%% =-----------  Alive Nodes -----

new1  =  STATISTICS1.DEAD1' ; 
new11 = 100 - new1 ; 
new111 = new11';

new2  =  STATISTICS2.DEAD2' ; 
new22 = 100 - new2 ; 
new222 = new22';

new3  =  STATISTICS3.DEAD3' ; 
new33 = 100 - new3 ; 
new333 = new33';

new4  =  STATISTICS4.DEAD4' ; 
new44 = 100 - new4 ; 
new444 = new44';
%%
figure(7)
plot(r,new111,'g',50:5050,new333,'k',r,new444,'m',310:5310,new222,'r','linewidth',2);
legend('Leach-BFO','BIHP','SEP with BFO','E-SEP with BFO');
xlabel('Number of Rounds ->');
ylabel('NUMBER OF ALIVE NODES');
title('\bf Leach-BFO v/s BIHP v/s SEP with BFO v/s E-SEP with BFO');

% end