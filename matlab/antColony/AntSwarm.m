%% Ant Swarm
% This script runs and Ant Swarm simulation
% Individual Ants are created using antDef, which is a class that defines
% an ant and its characteristics, such as its current location, vision, 
% desire for food, desire for friends (i.e. how badly
% does the ant want to be near other ants). 
clc; clear all; close all;

%% Define Domain and Create Ants
%our Class defines an ant
%our object/instance of the class is the specific ant
% antColony is the array containing all ants
% antColony(i) is a specific ant

%define domain that Ants can exist in
xlim=[-1, 1]; %[m] 
ylim=[-1 ,1]; %[m]

% Create Ant Objects(aka instances) and Initialize Locations
N_ants=40; %define number of ants in colony (i.e. number of objects)

f1=figure(1);
for i=1:N_ants
    antColony(i)=antDef; %Create ant object (N_ants is the number of individual ants, with their own characteristics)
    antColony(i).loc=(rand(1,2)-0.5).*[xlim(2)-xlim(1),ylim(2)-ylim(1)]; %randomize initial location of each ant
    plot(antColony(i).loc(1),antColony(i).loc(2),'.k'); hold on
end

% Specify to ant the boundaries of the domain
[antColony.xlim]=deal(xlim);
[antColony.ylim]=deal(ylim);

%Specify food locations
food_x=[-0.75 0.75 0 0];
food_y=[0 0 0.75 -0.75];
[antColony.foodloc]=deal([food_x(:),food_y(:)]);% the 'deal' command allows you to assign values to multiple objects at one (like dealing cards to multiple players)

%% Run movement simulation
dt=1; %[s]
t_final=100; %[s]
tvec=0:dt:t_final; %[s] vector of discrete times

%Properties

[antColony.speed]=deal(0.1);      %[m/s] max speed an ant can walk (how fast can an ant walk?)
[antColony.vision]=deal(0.2);         %[m] the distance an ant can see (how far away can it recognize other ants?)
[antColony.foodDesire]=deal(0);       %desire for food (how hungry is the ant?);
[antColony.friendDesire]=deal(0.5);     %desire for friends (how much does an ant want to be near other ants?);
[antColony.foundFood]=deal(0);          %initialize foundFood to 0
[antColony.maxAntsEating]=deal(10);          %max number of ants that can eat at a single food source
[antColony.randMovement]=deal(0.1);   %random movements (how wobbly is an ant's trajectory;

for k=1:length(tvec)
    cla% clear axis
    t=tvec(k); %print time
    
    [antColony.foodDesire]=deal([antColony(1).foodDesire]+0.01); %Increase food desire as time increases

    for i=1:N_ants         
        antColony(i).getMove(antColony(i),antColony,dt)
        plot(antColony(i).loc(1),antColony(i).loc(2),'.k','MarkerSize',10); hold on
    end
    
    %plot
    fplot=plot(food_x,food_y,'xr'); %plot food
    axis([xlim ylim])
    
    %make movie
    frame(k)=getframe;
    
end

%Count occurances
tabulate([antColony.foundFood])

%play movie
%movie(frame)
    