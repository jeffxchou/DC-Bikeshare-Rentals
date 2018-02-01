libname project "C:\Users\Jeffrey\Documents\School\Fall 2016\STAT 4210 Applied Regression\Final Project";

*DATA PREPARATION--------------------------------------------------;

*Rename "date" variable in original 'bike' dataset;
data project.bike2;
set project.bike;
	rename dteday=Date;
run;

*Merge 'bike2' and 'dca1112' datasets;
data project.dcbike;
	merge project.bike2 project.dca1112;
	by Date;
run;

*Print list of variables in 'dcbike' by "position" in dataset;
proc contents data=project.dcbike position;
run;

*Make subset of 'dcbike' with selected variables;
data project.dcbike2 (keep=Date season workingday weathersit cnt 
							Min_TemperatureF Max_TemperatureF Mean_Humidity 
							Mean_Sea_Level_PressureIn Mean_VisibilityMiles
							Mean_Wind_SpeedMPH PrecipitationIn CloudCover Events);
set project.dcbike;
run;

*rename variables;
data project.dcbike3;
set project.dcbike2 (rename=(cnt=rentals
							workingday=workday
							weathersit=weathercat
							Max_TemperatureF=tempmax
							Min_TemperatureF=tempmin
	 						Mean_Humidity=humidity
							Mean_Sea_Level_PressureIn=pressure 
							Mean_VisibilityMiles=visibility
							Mean_Wind_SpeedMPH=wind 
							PrecipitationIn=precipitation));
run;

*Dummy variable coding for 'season', where base=winter;
data project.dcbike4;
set project.dcbike3;
	if season=2 then ds_spring=1;
	else ds_spring=0;
	if season=3 then ds_summer=1;
	else ds_summer=0;
	if season=4 then ds_fall=1;
	else ds_fall=0;
run;

*Dummy variable coding for 'weathercat', where base=3;
data project.dcbike5;
set project.dcbike4;
	if weathercat=1 then dwc_1=1;
	else dwc_1=0;
	if weathercat=2 then dwc_2=1;
	else dwc_2=0;
run;

*Print list of variables in 'dcbike' by "position" in dataset;
proc contents data=project.dcbike5 position;
run;

*Drop 'season' and 'events';
data project.dcbike6 (drop = season events);
set project.dcbike5;
run;

*Recode 'T' (trace) precipitation to 0.00 inches;
data project.dcbike7;
set project.dcbike6;
	if precipitation='T' then precipitation=0;
run;

*Print list of variables in 'dcbike' by "position" in dataset
!For some odd reason, precipitation is a character variable and should be changed to numerical;
proc contents data=project.dcbike7 position;
run;

*Change 'precipitation' from categorical to numerical variable.
!Modified variable is now called 'precip;
data project.dcbike8;
set project.dcbike7;
      precip=input(precipitation,best32.);
run;

*Check to make sure that 'precip' is a numerical variable;
proc contents data=project.dcbike8 position;
run;

*DATA OVERVIEW-----------------------------------;

*Frequency tables for all categorical variables;
ods rtf;
proc freq data=project.bike2;
    table season;
	table workday;
	table weather;
run; 
ods rtf close;

*Create histogram/boxplot/PPlot to visualize distributions of each quantitative variable;
proc univariate data=project.dcbike8 plots;
var tempmax;
run;

proc univariate data=project.dcbike8 plots;
var tempmin;
run;

proc univariate data=project.dcbike8 plots;
var humidity;
run;

proc univariate data=project.dcbike8 plots;
var pressure;
run;

proc univariate data=project.dcbike8 plots;
var visibility;
run;

proc univariate data=project.dcbike8 plots;
var wind;
run;

proc univariate data=project.dcbike8 plots;
var precip;
run;

*Summary statistics for all quantitative variables;
ods rtf;
proc means data=project.dcbike8 nmiss min q1 median mean q3 max stddev maxdec=3;
	var tempmax;
	var tempmin;
	var humidity;
	var pressure;
	var visibility;
	var wind;
	var precip;
	var cloudcover;
run;
quit;
ods rtf close;

*Correlation matrix of all quantitative variables;
ods rtf;
proc corr data=project.dcbike8 plots(maxpoints=none)=matrix(nvar=9);
	var rentals tempmax tempmin humidity pressure precip 
					visibility wind CloudCover;
run;
quit;
ods rtf close;

*MODEL 1--------------------------------------------------;

*Stepwise regression, first-order model;
ods rtf;
proc reg data=project.dcbike8;
	model rentals = tempmax tempmin humidity pressure precip
					visibility wind CloudCover / vif;
run;
	model rentals = tempmax tempmin pressure precip
					visibility wind CloudCover / vif influence;
run;
quit;
ods rtf close;

*MODEL 2--------------------------------------------------;

*Stepwise regression with categorical variables;
ods rtf;
proc reg data=project.dcbike8;
	model rentals = workday tempmax tempmin humidity pressure precip
					visibility wind CloudCover ds_spring ds_summer
					ds_fall dwc_1 dwc_2 / selection=stepwise sle=0.15 sls=0.10 partial vif;
run;
quit;
ods rtf close;

*MODEL 3--------------------------------------------------;

*All-possible model selection;
ods rtf;
proc reg data=project.dcbike8;
	model rentals = workday tempmax tempmin humidity pressure precip
					visibility wind CloudCover ds_spring ds_summer
					ds_fall dwc_1 dwc_2 / selection=rsquare adjrsq cp best=3 vif;
run;
quit;
ods rtf close;

*Best model from all-possible-regression procedure;
ods rtf;
proc reg data=project.dcbike8;
	model rentals = workday tempmax tempmin humidity pressure precip wind 
					ds_spring ds_summer ds_fall dwc_1 dwc_2/ vif;
run;
quit;
ods rtf close;




