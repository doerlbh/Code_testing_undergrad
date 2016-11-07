%% HW2 for AMATH422
% @Author: Baihan Lin
% @Date: Nov 2016

clear all; close all; clc;

rng(1);

%% I. Dwell time distributions: theory





%% II. Simulating Markov Chains and dwell times

% Markov Matrix
A = [0.98 0.1 0;
    0.02 0.7 0.05;
    0 0.2 0.95 ];

% across the entire time frame
Nstep = 10^7;
S = zeros(1,Nstep);  % states
S(1) = 1; % from C1

% simulation of Markov Chains
for k=1:Nstep-1
    rd=rand ;
    if rd < A(1,S(k))
        S(k+1) = 1;  % S(k+1) = S1 (C1)
    elseif rd < A(1,S(k))+A(2,S(k))
        S(k+1) = 2; % S(k+1) = S2 (C2)
    else
        S(k+1) = 3; % S(k+1) = S3 (O)
    end
end;

% plot the firstatet 1000 steps since 10^7 is too long
fig1 = figure
set(gca,'FontSize',18);
plot(1:1000,S(1:1000),'.','Markersize',20);
xlabel('Nstep','FontSize',16);
ylabel('States','FontSize',16);
title('Simulation of Markov Chain over Nstep = 1000');

% Calculate dominant eigenvector
[V,D] = eig(A);
lamdas = diag(D);
jmax=find(abs(lamdas) == max(abs(lamdas))) ;
dom_eigenvec=V(:,jmax);
rescaled_dom_eigenvec = dom_eigenvec/sum(dom_eigenvec)
% Output of rescaled_dom_eigenvec:
%    0.5000
%    0.1000
%    0.4000

% fraction of time in each state with outputs:
S1 = length(find(S==1))/Nstep  % 0.4999
S2 = length(find(S==2))/Nstep  % 0.1000
S3 = length(find(S==3))/Nstep  % 0.4001

% Here the fractions match with the rescaled dominant eigenvector.

% reduced states
rstate = S;
rstate(find(S == 2)) = 1; % reduction

% Find dwell times in the different reduced states.
dt_closed=[];
dt_open=[];

% Initial Condition
S_0 = rstate(1);
Nstep_0=1;

for k = 2:length(rstate)
    if rstate(k) ~= S_0
        dt = k- Nstep_0 + 1;
        if S_0==1
            dt_closed = [dt_closed dt];
        else
            dt_open = [dt_open dt];
        end
        S_0=rstate(k);
        Nstep_0=k;
    end
end

%plot histograms
fig2 = figure

subplot(211)
[Nc,xc]=hist(dt_closed,200);
bar(xc,Nc)
axis([0 max(xc)/4 -Inf Inf])
xlabel('dt')
ylabel('freq')
title('histogram of dt_ closed')

subplot(212)
bar(xc(1:50),log(Nc(1:50)))
xlabel('log(dt)')
ylabel('freq')
title('histogram of log(dt_ closed)')

fig3 = figure

subplot(211)
[No,xo]=hist(dt_open,500);
bar(xo,No)
axis([0 max(xo)/4 -Inf Inf])
xlabel('dt')
ylabel('freq')
title('histogram of dt_ open')

subplot(212)
bar(xo(1:50),log(No(1:50)))
xlabel('log(dt)')
ylabel('freq')
title('histogram of log(dt_ open)')
%%
% Based on the hypothesis, here we fit it to a single exponential:
fig4 = figure;
plot(1:length(Nc),log(Nc))  %see what we're fitting
title('log(dt closed) fitting to exponential')
para = polyfit(1:50,log(Nc(1:50)),1) % -0.0666    8.7731
E_ajj = exp(para(1)) % 0.9355

% As shown in Fig 4, the single exponential fits dt_closed well.

%% III. Simulating Markov Chains and neural spiking

Trial = 1000;
Nin = 10;
Nout = 5;

Snet = zeros(1, Trial);

% Markov Matrices
Ain = [0.98 0.1 0;
    0.02 0.7 0.05;
    0 0.2 0.95 ];
Aout = [0.9 0.1 0;
    0.1 0.6 0.1;
    0 0.3 0.9 ];

% across the entire time frame
Nstep = 10^7;

parfor t = 1:Trial
    
    Snet = zeros(1,Nstep);
    Sin = zeros(Nin,Nstep);
    Sout = zeros(Nout,Nstep);
    
    Sin(:,1) = 1;
    Sout(:,1) = 1;
    
    % simulation of Markov Chains
    for k=1 : Nstep-1
        % Get states of inward channels
        for n = 1:Nin
            rd=rand;
            if rd < Ain(1,Sin(n,k))
                Sin(n,k+1) = 1; % S(k+1) = S1 (C1)
            elseif rd < Ain(1,Sin(n,k))+Ain(2,Sin(n,k))
                Sin(n,k+1) = 2; % S(k+1) = S2 (C2)
            else
                Sin(n,k+1) = 3; % S(k+1) = S3 (O)
            end
        end
        % Get states of outward channels
        for m = 1:Nout
            rd=rand;
            if rd < Aout(1,Sout(m,k))
                Sout(m,k+1) = 1; % S(k+1) = S1 (C1)
            elseif rd < Aout(1,Sout(m,k))+Aout(2,Sout(m,k))
                Sout(m,k+1) = 2; % S(k+1) = S2 (C2)
            else
                Sout(m,k+1) = 3; % S(k+1) = S3 (O)
            end
        end
    end;
    
    % Calculate dominant eigenvector of Ain
    [Vin,Din] = eig(Ain);
    lamdas_in = diag(Din);
    jmax_in=find(abs(lamdas_in) == max(abs(lamdas_in))) ;
    dom_eigenvec_in=Vin(:,jmax_in);
    rescaled_dom_eigenvec_in = dom_eigenvec_in/sum(dom_eigenvec_in);
    num_of_channels_S_in = Nin*rescaled_dom_eigenvec_in
    % Output of num_of_channels_S_in:
    %    5.0000
    %    1.0000
    %    4.0000
    
    % double check with num of channels in each state with outputs:
    N1in = length(find(Sin==1))/Nstep  % 4.9968
    N2in = length(find(Sin==2))/Nstep  % 1.0014
    N3in = length(find(Sin==3))/Nstep  % 40.017
    
    % Calculate dominant eigenvector of Aout
    [Vout,Dout] = eig(Aout);
    lamdas_out = diag(Dout);
    jmax_out=find(abs(lamdas_out) == max(abs(lamdas_out))) ;
    dom_eigenvec_out=Vout(:,jmax_out);
    rescaled_dom_eigenvec_out = dom_eigenvec_out/sum(dom_eigenvec_out);
    num_of_channels_S_out = Nout*rescaled_dom_eigenvec_out
    % Output of num_of_channels_S_out:
    %    1.0000
    %    1.0000
    %    3.0000
    
    % double check with num of channels in each state with outputs:
    N1out = length(find(Sout==1))/Nstep  % 0.9992
    N2out = length(find(Sout==2))/Nstep  % 0.9989
    N3out = length(find(Sout==3))/Nstep  % 3.0019
    
    % The equilibrium of the net current at t
    Snet(t) = num_of_channels_S_in(3) - num_of_channels_S_out(3);
    % Output of Snet:
    %    1.0000
    
    % Thus, it shows that the equilibrium would have 1 unit flows
    
end

%plot histograms
fig5 = figure

[Nt,xt]=hist(Snet,50);
bar(xt,Nt/Trial)
axis([0 max(xt)/4 -Inf Inf])
xlabel('T')
ylabel('Probability')
title('histogram of probability on T')
