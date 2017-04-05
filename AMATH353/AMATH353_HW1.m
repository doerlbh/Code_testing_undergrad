%% HW1 for AMATH353
% @Author: Baihan Lin
% @Date: Apr 2017

clear all; close all; clc;

%% Different ways of visualizing a function of two variables
% Consider the function u(x,t) = exp(-(x-t)^2) + exp(-(x+t)^2)

%% Plot at discrete time shots
% Visualize the function at different time-shots as just a function of x

% Discretize the 'space' variable
x = linspace(-4,4,201);

% Choose time shots
time = [0,1,2];

% Loop over the number of time shots and create a figure for the
% corresponding value of time
figure(1)
for j = 1:length(time)
    u = exp(-(x-time(j)).^2) + exp(-(x+time(j)).^2);
    subplot(3,1,j)
    plot(x,u,'k-','LineWidth',1.5)
    hold all
    plot([x(1),x(end)],[0,0],'k--')
    plot([0,0],[-.1,1.1],'k--')
    title(sprintf('t = %d',time(j)))
    ylim([-.1,2.1])
    axis on
end


%% Slice Plot
% Plots of u at different time shots stacked next to each other
% Discretize both space and time 
x = linspace(-4,4,201);
t = linspace(0,2,11);

% Create a grid, and define the z component as the function u
[X,T] = meshgrid(x,t);
Z = exp(-(X-T).^2) + exp(-(X+T).^2);

figure(2)
clf
waterfall(X,T,Z)
colormap default
xlabel('x','FontSize',15)
ylabel('t','FontSize',15)


%% Surface Plot
% Create a 3D figure with x as x-axis, t as y-axis and u as z-axis.

% Discretize both space and time 
x = linspace(-4,4,201);
t = linspace(0,2,101);

% Create a grid, and define the z component as the function u
[X,T] = meshgrid(x,t);
Z = exp(-(X-T).^2) + exp(-(X+T).^2);

figure(3)
clf
surf(X,T,Z)
colormap default
xlabel('x','FontSize',15)
ylabel('t','FontSize',15)


%% Density Plot or xt-plane plots
% Discretize both space and time 
x = linspace(-4,4,201);
t = linspace(0,2,101);

% Create a grid, and define the z component as the function u
[X,T] = meshgrid(x,t);
Z = exp(-(X-T).^2) + exp(-(X+T).^2);

figure(4)
clf
pcolor(X,T,Z)
colormap default
xlabel('x','FontSize',15)
ylabel('t','FontSize',15)


% %% Animation
% % Plot the function at each time-step in consecutive frames to create a
% % movie showing how the function evolves in time
% 
% % Discretize both space and time 
% x = linspace(-4,4,201);
% t = linspace(0,2,101);
% 
% % Create a grid, and define the z component as the function u
% [X,T] = meshgrid(x,t);
% Z = exp(-(X-T).^2);
% 
% figure(5)
% M = moviein(length(t));
% for j = 1:length(t)
%     plot(x,Z(j,:))
%     M(:,j) = getframe;
% end
% movie(M)