%Gaussian Distributions
clear all; close all; clc;

%% Import Data
load humandata25000.mat

index=data(:,1);    %subject index
height=data(:,2);   %inches 
weight=data(:,3);   %pounds

%% Initial Plots
figure(6)
plot(height,weight,'o'); hold on;
title('Weight vs. Height')
xlabel('Height (in)'); ylabel('Weight (kg)');

%% Random Sampling of Gaussian - Heights
samples=[5,10,100,25000];
xlimits_height=[min(height),max(height)];
figure(1);
randsamples=randi([min(index) max(index)],samples(1),1);
subplot(5,1,1); h25=histogram(height(randsamples),10);
title(sprintf('Histogram %d Samples', samples(1)))
ylabel('Frequency')
xlim(xlimits_height)

randsamples=randi([min(index) max(index)],samples(2),1);
subplot(5,1,2); h250=histogram(height(randsamples),10);
title(sprintf('Histogram %d Samples', samples(2)))
ylabel('Frequency')
xlim(xlimits_height)

randsamples=randi([min(index) max(index)],samples(3),1);
subplot(5,1,3); h2500=histogram(height(randsamples),25);
title(sprintf('Histogram %d Samples', samples(3)))
ylabel('Frequency')
xlim(xlimits_height)

randsamples=randi([min(index) max(index)],samples(4),1);
subplot(5,1,4); h25000=histogram(height(randsamples),50);
title(sprintf('Histogram %d Samples', samples(4)))
ylabel('Frequency')
xlim(xlimits_height)

%% Fit gaussian to data
pd_height = fitdist(height,'Normal');
prob_height=pdf(pd_height,xlimits_height(1):0.1:xlimits_height(2));
subplot(5,1,5); plot(xlimits_height(1):0.1:xlimits_height(2),prob_height)
title('Probability Distribution Function')
ylabel('Probability')
xlabel('Height [in]')
xlim(xlimits_height)

%% Law of large numbers
figure(2);
%calculate the mean of N random samples taken from the pd
N=1:10:10000;
for i = 1:length(N)
    samplemean(i)=mean(random(pd_height,[N(i),1]));
end
semilogx(N,samplemean);
title('Sample Mean vs. Number of Samples')
xlabel('Number of Samples')
ylabel('Mean')
meanline=refline([0 pd_height.mu]);
meanline.LineStyle='--';

%% 3D Histogram
figure(5)
[a,y]=hist3([height,weight],[50,50]);
surf(y{1},y{2},a); shading interp; axis tight
title('3D Histogram')
xlabel('Height (in)'); ylabel('Weight (kg)'); zlabel('frequency')

%% Use height data to predict weight (backslash operator)
figure(6);

%A*x=y or height*x=weight. To solve for x, we invert
A=[height,ones(size(height))]; %N by 2 matrix
y=[weight]; %N by 1 vector
x=A\y; %this is the matrix inversion step. In this case we are calculating the 'pseudo-inverse'.
y_pred=polyval(x,height);
plot(height,y_pred)
legend('data','Linear Fit')