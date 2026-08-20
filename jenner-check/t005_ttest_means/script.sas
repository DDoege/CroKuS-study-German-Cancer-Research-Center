*******************************************************;
*** Adapted from "SAS-Code depression anxiety clean 2024-08-15.sas"    ***;
*** Source: the sample-description block (lines ~1066-1079) — PROC     ***;
*** MEANS on agesurvey, then PROC TTEST of agesurvey by survivor,      ***;
*** both restricted to the first imputation (there was no imputation   ***;
*** of age, so it's identical across imputations, per the source       ***;
*** comment). Titles copied verbatim. Mock cohort stands in for        ***;
*** crokus_MI.                                                        ***;
*******************************************************;

proc format;
value survivor
1 = "Survivors"
0 = "Patients";
run;

data crokus_MI;
input _Imputation_ agesurvey survivor;
format survivor survivor.;
datalines;
1 55 1
1 62 0
1 71 1
1 48 0
1 59 1
1 44 0
1 67 1
1 53 0
1 61 1
1 49 0
2 55 1
2 62 0
;
run;

title "Sample description (Table 1/2) after MI";

title2 "Mean age, SD and sample size, overall group";
proc means data=crokus_MI;
var agesurvey;
where _Imputation_ = 1; *there was no imputation of age, thus same for all imputations;
run;

title2 "Mean age, SD and sample size, patients vs. survivors";
proc ttest data=crokus_MI;
class survivor;
var agesurvey;
where _Imputation_ = 1; *there was no imputation of age, thus same for all imputations;
run;

title;
