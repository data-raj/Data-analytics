libname folder1 "/folders/myfolders/BA-case-study/mycs2";

/* Data import */
PROC IMPORT DATAFILE= "/folders/myfolders/BA-case-study/mycs2/Linear_Regression_Case" OUT= folder1.CC_spends
     DBMS=xlsx REPLACE;
     GETNAMES=Yes;
     datarow=2;
     sheet=customer_dbase;
run;


data CC_spends;
 set folder1.cc_spends;
 total_spent = cardspent + card2spent;
 total_items = carditems + card2items;
run; 


proc means data=CC_spends N Nmiss max min P95 mean std mode;
run;

proc corr data = CC_spends ;
var 
age
ed
employ
income
lninc
inccat
debtinc
lncreddebt
lnothdebt
default
carditems
cardspent
lnlongmon
lnlongten
ln
cars 
longmon 
longten
tollfree
wiremon 
lnwiremon	
total_spent;
run;



proc univariate data = CC_spends;
var total_spent;
class region;
histogram total_spent;
run;


proc univariate data = CC_spends;
var total_spent;
class townsize;
histogram total_spent;
run;

proc univariate data = CC_spends;
var total_spent;
class gender;
histogram total_spent;
run;

proc univariate data = CC_spends;
var total_spent;
class ed;
histogram total_spent;
run;

proc univariate data=CC_spends;
var total_spent;
class multiline;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class pager;
histogram total_spent;
run;

proc univariate data=CC_spends;
var total_spent;
class callid;
histogram total_spent;
run;

proc univariate data=CC_spends;
var total_spent;
class callwait;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class forward;
histogram total_spent;
run;

proc univariate data=CC_spends;
var total_spent;
class confer;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class ownpda;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class response_01;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class response_02;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class commutecat;
histogram total_spent;
run;


proc univariate data=CC_spends;
var total_spent;
class polview;
histogram total_spent;
run;

data CC_spends;
 set CC_spends;
 outlier = "N";
if ed > 24.3862484 or 
employ > 38.8031861 or 
income > 220.8921336 or 
lninc > 5.9411251 or 
inccat > 6.0559818 or 
debtinc > 29.1535099 or 
lncreddebt > 3.6887217 or 
lnothdebt >4.0826499 or 
cardspent > 1072.637725 or 
card2spent > 599.7544224 or 
lnlongmon > 4.6143129 or 
lnlongten > 10.5592231 or 
lntollmon > 4.4572056 or 
lntollten > 10.2509039 or 
lnequipmon > 4.4503917 or 
lnequipten > 10.3449969 or 
lncardmon > 4.60431 or 
lncardten > 9.9424578 or 
lnwiremon > 4.7753058 then outlier = 'Y';
run;

proc sort data=CC_spends;
by outlier;
run;

proc freq data=cc_spends;
tables outlier;
run;

data CC_spends;
 set CC_spends;
if ed > 24.3862484 then ed = 24.3862484;
if employ > 38.8031861 then employ = 38.8031861;
if income > 220.8921336 then  income = 220.8921336;
if lninc > 5.9411251 then lninc = 5.9411251;
if inccat > 6.0559818 then inccat = 6.0559818;
if debtinc > 29.1535099 then debtinc = 29.1535099;
if lncreddebt > 3.6887217 then lncreddebt = 3.6887217 ;
if lnothdebt >4.0826499 then lnothdebt = 4.0826499;
if cardspent > 1072.637725 then  cardspent = 1072.637725;
if card2spent > 599.7544224 then card2spent = 599.7544224;
/*if lnlongmon > 4.6143129 then lnlongmon = 4.6143129;
if lnlongten > 10.5592231 then lnlongten = 10.5592231;
if lntollmon > 4.4572056 then lntollmon = 4.4572056;
if lntollten > 10.2509039 then lntollten = 10.2509039;
if lnequipmon > 4.4503917 then lnequipmon = 4.4503917;
if lnequipten > 10.3449969 then lnequipten = 10.3449969;
if lncardmon > 4.60431 then lncardmon = 4.60431;
if lncardten > 9.9424578 then lncardten = 9.9424578 ;
if lnwiremon > 4.7753058 then lnwiremon = 4.7753058; */
if total_spent > 1764.63 then total_spent = 1764.63 ;
run;


data CC_spends;
  set CC_spends;
if townsize = . then townsize = 1;
if lncreddebt = . then lncreddebt = -0.1304535;
if lnothdebt = . then lnothdebt = 0.6969153; 
if longten = . then longten = 708.8717531 ;
run;
 
proc means data=CC_spends N Nmiss max min P95 mean std mode;
run; 

/* factor analysis */

proc factor data=CC_spends
mineigen=0 method=principal rotate=varimax reorder scree nfactors=9 ;
var
region	townsize agecat	edcat 
jobcat	empcat	retire internet
lninc inccat debtinc addresscat tenure total_items
creddebt lncreddebt othdebt lnothdebt 
jobsat cardspent total_spent
cartype commute commutecat;
run;

/*
 * agecat
addresscat
empcat
jobsat
lnothdebt
lncreddebt
othdebt
cardspent
inccat
retire
commutecat
edcat
region
jobcat
cartype
 */

data CC_spends;
set CC_spends;
ln_spents = log(total_spent);
if agecat= 2 then dummy_agecat2 = 1; else dummy_agecat2 = 0;
if agecat= 3 then dummy_agecat3 = 1; else dummy_agecat3 = 0;
if agecat= 4 then dummy_agecat4 = 1; else dummy_agecat4 = 0;
if agecat= 5 then dummy_agecat5 = 1; else dummy_agecat5 = 0;


if addresscat= 1 then dummy_addresscat1 = 1; else dummy_addresscat1 = 0;
if addresscat= 2 then dummy_addresscat2 = 1; else dummy_addresscat2 = 0;
if addresscat= 3 then dummy_addresscat3 = 1; else dummy_addresscat3 = 0;
if addresscat= 4 then dummy_addresscat4 = 1; else dummy_addresscat4 = 0;

if empcat= 1 then dummy_empcat1 = 1; else dummy_empcat1 = 0;
if empcat= 2 then dummy_empcat2 = 1; else dummy_empcat2 = 0;
if empcat= 3 then dummy_empcat3 = 1; else dummy_empcat3 = 0;
if empcat= 4 then dummy_empcat4 = 1; else dummy_empcat4 = 0;

if jobsat= 1 then dummy_jobsat1 = 1; else dummy_jobsat1 = 0;
if jobsat= 2 then dummy_jobsat2 = 1; else dummy_jobsat2 = 0;
if jobsat= 3 then dummy_jobsat3 = 1; else dummy_jobsat3 = 0;
if jobsat= 4 then dummy_jobsat4 = 1; else dummy_jobsat4 = 0;

if inccat= 1 then dummy_inccat1 = 1; else dummy_inccat1 = 0;
if inccat= 2 then dummy_inccat2 = 1; else dummy_inccat2 = 0;
if inccat= 3 then dummy_inccat3 = 1; else dummy_inccat3 = 0;
if inccat= 4 then dummy_inccat4 = 1; else dummy_inccat4 = 0;

if commutecat= 1 then dummy_commutecat1 = 1; else dummy_commutecat1 = 0;
if commutecat= 2 then dummy_commutecat2 = 1; else dummy_commutecat2 = 0;
if commutecat= 3 then dummy_commutecat3 = 1; else dummy_commutecat3 = 0;
if commutecat= 4 then dummy_commutecat4 = 1; else dummy_commutecat4 = 0;

if edcat= 1 then dummy_edcat1 = 1; else dummy_edcat1 = 0;
if edcat= 2 then dummy_edcat2 = 1; else dummy_edcat2 = 0;
if edcat= 3 then dummy_edcat3 = 1; else dummy_edcat3 = 0;
if edcat= 4 then dummy_edcat4 = 1; else dummy_edcat4 = 0;

if jobcat= 1 then dummy_jobcat1 = 1; else dummy_jobcat1 = 0;
if jobcat= 2 then dummy_jobcat2 = 1; else dummy_jobcat2 = 0;
if jobcat= 3 then dummy_jobcat3 = 1; else dummy_jobcat3 = 0;
if jobcat= 4 then dummy_jobcat4 = 1; else dummy_jobcat4 = 0;
if jobcat= 5 then dummy_jobcat5 = 1; else dummy_jobcat5 = 0;

if region= 1 then dummy_region1 = 1; else dummy_region1 = 0;
if region= 2 then dummy_region2 = 1; else dummy_region2 = 0;
if region= 3 then dummy_region3 = 1; else dummy_region3 = 0;
if region= 4 then dummy_region4 = 1; else dummy_region4 = 0;

if cartype= 0 then dummy_cartype0 = 1; else dummy_cartype0 = 0;
if cartype= 1 then dummy_cartype1 = 1; else dummy_cartype1 = 0;
run;


/* Creating training and validation set */

data dev val;
set CC_spends;
if ranuni(5000) <0.7 then output dev;
else output val;
run;


proc transreg data= CC_spends;
model boxcox(total_spent) = identity(income othdebt creddebt tenure ed total_items cardspent);
run;


/* Running the linear regression */

proc reg data=dev;
model ln_spents = 
income lnothdebt lncreddebt retire cardspent
employ tenure ed 
total_items 
dummy_agecat2 dummy_agecat3 dummy_agecat4 dummy_agecat5
dummy_addresscat1 dummy_addresscat2 dummy_addresscat3 dummy_addresscat4
dummy_empcat1 dummy_empcat2 dummy_empcat3 dummy_empcat4
dummy_jobsat1 dummy_jobsat2 dummy_jobsat3 dummy_jobsat4
dummy_jobcat1 dummy_jobcat2 dummy_jobcat3 dummy_jobcat4 dummy_jobcat5
dummy_inccat1 dummy_inccat2  dummy_inccat3 dummy_inccat4 
dummy_commutecat1 dummy_commutecat2 dummy_commutecat3 dummy_commutecat4
dummy_edcat1 dummy_edcat2 dummy_edcat3 dummy_edcat4 
dummy_region1 dummy_region2 dummy_region3 dummy_region4 
dummy_cartype0 dummy_cartype1
/selection = stepwise slentry= 0.05 slstay=0.1 vif stb;
output out = tmp cookd=cd;
run;

data tmp1;
set tmp;
if cd<4/3500;
run;


proc reg data=tmp1;
model ln_spents = 
income lnothdebt lncreddebt retire cardspent
employ tenure ed 
total_items 
dummy_agecat2 dummy_agecat3 dummy_agecat4 dummy_agecat5
dummy_addresscat1 dummy_addresscat2 dummy_addresscat3 dummy_addresscat4
dummy_empcat1 dummy_empcat2 dummy_empcat3 dummy_empcat4
dummy_jobsat1 dummy_jobsat2 dummy_jobsat3 dummy_jobsat4
dummy_jobcat1 dummy_jobcat2 dummy_jobcat3 dummy_jobcat4 dummy_jobcat5
dummy_inccat1 dummy_inccat2  dummy_inccat3 dummy_inccat4 
dummy_commutecat1 dummy_commutecat2 dummy_commutecat3 dummy_commutecat4
dummy_edcat1 dummy_edcat2 dummy_edcat3 dummy_edcat4 
dummy_region1 dummy_region2 dummy_region3 dummy_region4 
dummy_cartype0 dummy_cartype1
/selection = stepwise slentry= 0.05 slstay=0.1 vif stb;
output out = tmp cookd=cd2;
run;


/* prediction for training and validation data sets */


data dev;
set dev;
y = 4.6945 + 0.00093185 * income + lncreddebt*0.00785 +  -0.02992 * retire 
+ cardspent*0.00209 + 0.04082 * total_items 
+ dummy_addresscat1*0.03078 - dummy_inccat1*0.06856 + dummy_commutecat2*0.3907 + dummy_edcat4*-0.01984;
prediction = exp(y);
run;


data val;
set val;
y = 4.6945 + 0.00093185 * income + lncreddebt*0.00785 +  -0.02992 * retire 
+ cardspent*0.00209 + 0.04082 * total_items 
+ dummy_addresscat1*0.03078 - dummy_inccat1*0.06856 + dummy_commutecat2*0.3907 + dummy_edcat4*-0.01984;
prediction = exp(y);
run;

/* Deciling datasets based on prediction */

proc rank data= dev out=dev descending groups=10;
var prediction;
ranks decile;
run;


proc rank data=val out=val descending groups=10;
var prediction;
ranks decile;
run;


/* decile analysis to assess rank oders for development and validation sets*/

ods html file = '/folders/myfolders/BA-case-study/mycs2/linear_validation.xls';

proc sql;
select decile, count(prediction)as observations, avg(prediction) as avg_predicted_spend,
avg(total_spent) as avg_actual_spend, sum(prediction) as total_predicted_spend,
sum(total_spent) as total_actual_spend 
from dev
group by decile
order by decile ;
quit;

proc sql;
select decile, count(prediction)as observations, avg(prediction) as avg_predicted_spend,
avg(total_spent) as avg_actual_spend, sum(prediction) as total_predicted_spend,
sum(total_spent) as total_actual_spend
from val
group by decile
order by decile ;

quit;

ods html close ;