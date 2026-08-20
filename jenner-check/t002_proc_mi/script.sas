*******************************************************;
*** Adapted from "SAS-Code depression anxiety clean 2024-08-15.sas"    ***;
*** Source: the "PROC MI" multiple-imputation step (lines ~965-981).   ***;
*** Original imputes crokus (from the DKFZ network share) - this      ***;
*** bundle substitutes a small inline mock cohort, sized down (n=3    ***;
*** instead of 25) but with the exact VAR list, round/minimum/maximum ***;
*** vectors and minmaxiter option copied verbatim from the source.    ***;
*******************************************************;

data crokus;
input agesurvey sex educat marstat domestic
      jobstat_2020 jobstat work_cat how_many_home income self_covid
      tumor diag_year uicc_cat cancer_phase att_end att_feel att_bur
      burden_2020 burden_curr
      iso01rel iso02sh iso03phys iso04care iso05pub
      iso01rel_2020 iso02sh_2020 iso03phys_2020 iso04care_2020 iso05pub_2020
      HADS_A HADS_D weight height;
datalines;
32 1 3 2 2 2 6 1 5 1 3 1 2015 1 2 0 0 2 9 7 0 1 1 0 0 1 1 1 0 0 10 3 51 188
30 2 3 3 7 1 6 2 5 1 3 1 2019 3 6 1 0 1 1 4 1 0 0 0 1 1 1 1 0 1 11 6 125 174
27 1 5 2 2 4 4 2 5 2 2 1 2016 1 3 1 1 1 4 10 1 0 1 1 1 0 1 0 0 1 18 13 154 191
64 1 2 4 1 7 1 1 2 6 1 4 2019 1 4 1 1 3 9 1 0 1 1 0 1 1 0 1 0 1 16 5 104 153
56 1 2 3 7 2 5 3 1 5 2 4 2015 1 3 1 0 1 4 10 0 0 1 0 0 0 1 0 1 1 6 17 136 165
57 2 3 4 5 4 1 1 2 1 2 1 2019 2 5 0 0 1 1 4 0 0 1 0 0 1 1 0 0 1 7 15 143 192
42 1 1 4 3 4 4 2 1 6 0 1 2018 3 1 0 0 2 9 8 0 1 0 1 1 0 0 1 0 0 20 17 147 141
29 1 2 4 4 4 2 2 1 2 3 1 2018 3 4 1 1 4 3 4 1 0 0 0 1 0 0 1 0 0 16 2 148 163
;
run;

*** Multiple Imputation, adapted from source (nimpute reduced 25 -> 3 for a fast bundle run) ***;
%let nimpute = 3;

PROC MI data = crokus seed = 111 out = crokus_MI nimpute = &nimpute NOPRINT
round   =  1 1 1 1 1 	1 1 1 1 1 1		1    1 1 1 1 1 1	 1  1	1 1 1 1 1 1 1 1 1 1 	 1  1	  1	  1
minimum = 18 1 1 1 1 	1 1 1 1 1 0		1 2015 1 1 0 0 1	 1  1	0 0 0 0 0 0 0 0 0 0		 0  0	 40	140
maximum = 86 2 5 4 7 	7 7 3 5 6 3		5 2020 4 6 1 1 4	10 10	1 1 1 1 1 1 1 1 1 1		21 21	160	210
minmaxiter = 1000;
VAR agesurvey sex educat marstat domestic
	jobstat_2020 jobstat work_cat how_many_home income self_covid
	tumor diag_year uicc_cat cancer_phase att_end att_feel att_bur
	burden_2020 burden_curr
	iso01rel iso02sh iso03phys iso04care iso05pub
	iso01rel_2020 iso02sh_2020 iso03phys_2020 iso04care_2020 iso05pub_2020
	HADS_A HADS_D weight height;
run;

title "Multiple-imputation output (row count and imputation index)";
proc freq data=crokus_MI;
tables _Imputation_;
run;

title "Imputed HADS_A / HADS_D summary by imputation";
proc means data=crokus_MI n mean min max;
class _Imputation_;
var HADS_A HADS_D;
run;

title;
