libname folder1 '/folders/myfolders/BA-case-study';

/* Data import */
PROC IMPORT DATAFILE= "/folders/myfolders/BA-case-study/credit_card_data" OUT= folder1.CC_details
     DBMS=xls REPLACE;
     GETNAMES=Yes;
     datarow=2;
     sheet=CC_details;
run;

/* we will look for the outliers in the data set, it is important to 
find out outliers and cap or remove them as per the requirement, as their 
presence might affect our factor analysis and segmentation process */

ods html file = '/folders/myfolders/BA-case-study/data_summary.xls';
proc means data=folder1.cc_details mean std p95 n nmiss max min;
run;
ods html close;


data cc_details;
 set folder1.cc_details;
 outlier_95th = "N";
if BALANCE > 5911.51 or 
PURCHASES > 3999.92 or 
Average_purchases > 228.5714286 or
ONEOFF_PURCHASES > 2675 or
INSTALLMENTS_PURCHASES > 1753.08 or
CASH_ADVANCE > 4653.69 or
Average_cash_advance > 926.7585355 or
CASH_ADVANCE_FREQUENCY > 0.583333 or
CASH_ADVANCE_TRX > 15 or
PURCHASES_TRX > 57 or
CREDIT_LIMIT > 12000 or
Ratio_balance_to_limit > 0.9668636 or
PAYMENTS > 6083.43 or
MINIMUM_PAYMENTS > 2767.05 or
payment_by_min > 21.4431139 then outlier_95th = "Y"; 
run;


proc sort data=cc_details;
by outlier_95th;
run; 

proc freq data = CC_details;
tables outlier;
run;

/* since the outliers are approx. 14%, so we will not remove them but will cap them to the upper limit */

data cc_details;
 set cc_details;
if BALANCE > 5911.51 then BALANCE = 5911.51;
if PURCHASES > 3999.92 then PURCHASES = 3999.92;
if Average_purchases > 228.5714286 then Average_purchases = 228.5714286 ;
if ONEOFF_PURCHASES > 2675 then ONEOFF_PURCHASES = 2675;
if INSTALLMENTS_PURCHASES > 1753.08 then INSTALLMENTS_PURCHASES = 1753.08;
if CASH_ADVANCE > 4653.69 then CASH_ADVANCE = 4653.69;
if Average_cash_advance > 926.7585355 then Average_cash_advance = 926.7585355;
if CASH_ADVANCE_FREQUENCY > 0.583333 then CASH_ADVANCE_FREQUENCY = 0.583333;
if CASH_ADVANCE_TRX > 15 then CASH_ADVANCE_TRX = 15;
if PURCHASES_TRX > 57 then PURCHASES_TRX = 57;
if CREDIT_LIMIT > 12000 then CREDIT_LIMIT = 12000;
if Ratio_balance_to_limit > 0.9668636 then Ratio_balance_to_limit = 0.9668636;
if PAYMENTS > 6083.43 then PAYMENTS = 6083.43;
if MINIMUM_PAYMENTS > 2767.05 then MINIMUM_PAYMENTS = 2767.05;
if payment_by_min > 21.4431139 then payment_by_min = 21.4431139;
run;


/* missing values removal*/

proc means data=cc_details nmiss;
run;

data cc_details;
set cc_details ;
if CREDIT_LIMIT = .  then delete ;
if Ratio_balance_to_limit = .  then delete ;
if MINIMUM_PAYMENTS = .  then delete ;
if payment_by_min = .  then delete ;
run;


/* Applying PCA method to get the number of factors */


PROC FACTOR DATA = CC_details
METHOD = PRINCIPAL SCREE MINEIGEN=0 NFACTOR = 6
ROTATE = VARIMAX REORDER OUT= Factor;
var BALANCE 
BALANCE_FREQUENCY 
PURCHASES 
Average_purchases 
ONEOFF_PURCHASES 
INSTALLMENTS_PURCHASES 
CASH_ADVANCE 
Average_cash_advance 
PURCHASES_FREQUENCY 
ONEOFF_PURCHASES_FREQUENCY 
PURCHASES_INSTALLMENTS_FREQUENCY 
CASH_ADVANCE_FREQUENCY 
CASH_ADVANCE_TRX 
PURCHASES_TRX 
CREDIT_LIMIT 
Ratio_balance_to_limit 
PAYMENTS 
MINIMUM_PAYMENTS 
payment_by_min 
PRC_FULL_PAYMENT 
TENURE;
run;

/*  we have chosen a few variables using factor analysis so as to reduce multi-collinearity
 */

data CC_details;
set CC_details;
z_INSTALLMENTS_PURCHASES = INSTALLMENTS_PURCHASES;
z_PURCHASES_TRX = PURCHASES_TRX;
z_Average_purchases = Average_purchases;
z_ONEOFF_PURCHASES_FREQUENCY = ONEOFF_PURCHASES_FREQUENCY;
z_PURCHASES = PURCHASES;
z_CASH_ADVANCE =CASH_ADVANCE;
z_Average_cash_advance=Average_cash_advance;
z_Ratio_balance_to_limit=Ratio_balance_to_limit;
z_PRC_FULL_PAYMENT=PRC_FULL_PAYMENT;
z_CASH_ADVANCE_FREQUENCY=CASH_ADVANCE_FREQUENCY;
z_MINIMUM_PAYMENTS = MINIMUM_PAYMENTS;
run;


/* Standardization of variables */

proc standard data = CC_details out=CC_details mean=0 std=1;
var z_INSTALLMENTS_PURCHASES 
z_PURCHASES_TRX 
z_ONEOFF_PURCHASES_FREQUENCY 
z_PURCHASES 
z_CASH_ADVANCE 
z_Average_cash_advance 
z_Ratio_balance_to_limit 
z_PRC_FULL_PAYMENT 
z_CASH_ADVANCE_FREQUENCY
z_MINIMUM_PAYMENTS
z_Average_purchases;
run;

/* now we will do the segmentation using the variables we have chosen through factor analysis, we 
have also standardized these variables */

/* Clustering based on standardized variables */

proc fastclus data=CC_details out=clusters cluster=cluster3 maxclusters=3 maxiter=100;
var
z_INSTALLMENTS_PURCHASES 
z_PURCHASES_TRX 
z_ONEOFF_PURCHASES_FREQUENCY 
z_PURCHASES 
z_CASH_ADVANCE 
z_Average_cash_advance 
z_Ratio_balance_to_limit 
z_PRC_FULL_PAYMENT 
z_CASH_ADVANCE_FREQUENCY
z_MINIMUM_PAYMENTS
z_Average_purchases;
run;


proc fastclus data=clusters out=clusters cluster=cluster4 maxclusters=4 maxiter=100;
var
z_INSTALLMENTS_PURCHASES 
z_PURCHASES_TRX 
z_ONEOFF_PURCHASES_FREQUENCY 
z_PURCHASES 
z_CASH_ADVANCE 
z_Average_cash_advance 
z_Ratio_balance_to_limit 
z_PRC_FULL_PAYMENT 
z_CASH_ADVANCE_FREQUENCY
z_MINIMUM_PAYMENTS
z_Average_purchases;
run;


proc fastclus data=clusters out=clusters cluster=cluster5 maxclusters=5 maxiter=100;
var
z_INSTALLMENTS_PURCHASES 
z_PURCHASES_TRX 
z_ONEOFF_PURCHASES_FREQUENCY 
z_PURCHASES 
z_CASH_ADVANCE 
z_Average_cash_advance 
z_Ratio_balance_to_limit 
z_PRC_FULL_PAYMENT 
z_CASH_ADVANCE_FREQUENCY
z_MINIMUM_PAYMENTS
z_Average_purchases;
run;


proc fastclus data=clusters out=clusters cluster=cluster6 maxclusters=6 maxiter=100;
var
z_INSTALLMENTS_PURCHASES 
z_PURCHASES_TRX 
z_ONEOFF_PURCHASES_FREQUENCY 
z_PURCHASES 
z_CASH_ADVANCE 
z_Average_cash_advance 
z_Ratio_balance_to_limit 
z_PRC_FULL_PAYMENT 
z_CASH_ADVANCE_FREQUENCY
z_MINIMUM_PAYMENTS
z_Average_purchases;
run;


/* Creating profile sheet */

ods html file = '/folders/myfolders/BA-case-study/profiling.xls';

proc tabulate data=clusters;
var
BALANCE
BALANCE_FREQUENCY
PURCHASES
Average_purchases
ONEOFF_PURCHASES
INSTALLMENTS_PURCHASES
CASH_ADVANCE
Average_cash_advance
PURCHASES_FREQUENCY
ONEOFF_PURCHASES_FREQUENCY
PURCHASES_INSTALLMENTS_FREQUENCY
CASH_ADVANCE_FREQUENCY
CASH_ADVANCE_TRX
PURCHASES_TRX
CREDIT_LIMIT
Ratio_balance_to_limit
PAYMENTS
MINIMUM_PAYMENTS
payment_by_min
PRC_FULL_PAYMENT
TENURE
;
class  cluster3 cluster4 cluster5 cluster6 ;
table
(BALANCE
BALANCE_FREQUENCY
PURCHASES
Average_purchases
ONEOFF_PURCHASES
INSTALLMENTS_PURCHASES
CASH_ADVANCE
Average_cash_advance
PURCHASES_FREQUENCY
ONEOFF_PURCHASES_FREQUENCY
PURCHASES_INSTALLMENTS_FREQUENCY
CASH_ADVANCE_FREQUENCY
CASH_ADVANCE_TRX
PURCHASES_TRX
CREDIT_LIMIT
Ratio_balance_to_limit
PAYMENTS
MINIMUM_PAYMENTS
payment_by_min
PRC_FULL_PAYMENT
TENURE
)* mean N , all  cluster3 cluster4 cluster5 cluster6 ;
run;

ods html close;