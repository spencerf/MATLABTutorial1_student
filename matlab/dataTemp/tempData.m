% Data Importing and Plotting
close all; clc; clear all;

%Import data from web
api = 'http://climatedataapi.worldbank.org/climateweb/rest/v1/';
url = [api 'country/cru/tas/year/USA'];
S = webread(url);
years = [S.year];
temps = [S.data];
temps = 9/5 * temps + 32; %Convert to Fahrenheit
yearstoplot = datetime(years,1,1); %Convert years to 'datetime'

%Plot data 
figure(1)
plot(yearstoplot, temps,'ok');
title('USA Average Temperature 1901-2012')
xlabel('Year')
ylabel('Temperature (^{\circ}F)')
xmin = yearstoplot(1);
xmax = yearstoplot(end);
xlim([xmin xmax])

%% Split data into training set and test set
yearfortraintest=1990;

indices_train=years<=yearfortraintest;
years_train = years(indices_train);
temps_train = temps(indices_train);
yearstoplot_train=yearstoplot(indices_train);

indices_test=years>yearfortraintest;
years_test = years(indices_test);
temps_test = temps(indices_test);
yearstoplot_test=yearstoplot(indices_test);

%% Fit polynomials
%Fit 1-degree polynomial
[p1_all,~,mu1_all] = polyfit(years_train,temps_train,1);
p1temps_train = polyval(p1_all,years_train,[],mu1_all); %evaluate polynomial
hold on; xlim([yearstoplot_train(1) yearstoplot_train(end)]);
f1 = plot(yearstoplot_train, p1temps_train,'r'); 
xlim([yearstoplot_train(1) yearstoplot_train(end)]);
R_squared_train1=1-sum((p1temps_train-temps_train).^2)/...
    (((length(temps_train)-1) * var(temps_train)))
norm2_train1=norm(p1temps_train-temps_train,2)

%Fit 2-degree polynomial
[p2_all,~,mu2_all] = polyfit(years_train,temps_train,2);
p2temps_train = polyval(p2_all,years_train,[],mu2_all);
f2=plot(yearstoplot_train, p2temps_train,'b');
R_squared_train2=1-sum((p2temps_train-temps_train).^2)/(((length(temps_train)-1) * var(temps_train)))
norm2_train2=norm(p2temps_train-temps_train,2)

%Fit 3-degree polynomial
[p3_all,~,mu3_all] = polyfit(years_train,temps_train,3);
p3temps_train = polyval(p3_all,years_train,[],mu3_all);
f3=plot(yearstoplot_train, p3temps_train,'m');
R_squared_train3=1-sum((p3temps_train-temps_train).^2)/(((length(temps_train)-1) * var(temps_train)))
norm2_train3=norm(p3temps_train-temps_train,2)

legend([f1,f2, f3],'1st-Degree','2nd-Degree','3rd-Degree','Location','NorthWest')

%% Test Predictions
%test 1-degree polynomial
p1temps_test = polyval(p1_all,years_test,[],mu1_all); %evaluate polynomial
hold on; xlim([yearstoplot(1) yearstoplot(end)]);
f1 = plot(yearstoplot_test, p1temps_test,'r-*');
norm2_test1=norm(p1temps_test-temps_test,2)

%test 2-degree polynomial
p2temps_test = polyval(p2_all,years_test,[],mu2_all);
hold on
f2=plot(yearstoplot_test, p2temps_test,'b-*');
norm2_test2=norm(p2temps_test-temps_test,2)

%test 3-degree polynomial
p3temps_test = polyval(p3_all,years_test,[],mu3_all);
hold on
f3=plot(yearstoplot_test, p3temps_test,'m-*');
norm2_test3=norm(p3temps_test-temps_test,2)

legend([f1,f2, f3],'1st-Degree','2nd-Degree','3rd-Degree','Location','NorthWest')

