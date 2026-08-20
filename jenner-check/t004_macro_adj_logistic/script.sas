*******************************************************;
*** Adapted from "SAS-Code depression anxiety clean 2024-08-15.sas"    ***;
*** Source: the %adj macro (lines ~1354-1391) - PROC LOGISTIC with a   ***;
*** CLASS statement carrying per-level ref= for eight predictors, the  ***;
*** MODEL with the treatment2/adjust set, and LSMEANS with diff/cl/    ***;
*** adjust=bon/ilink, run BY _imputation_ - copied verbatim. The       ***;
*** "Further adjusted" %let adjust list from the source comment is     ***;
*** used here (agesurvey tumorsex uicc_cat survivor cancer_phase       ***;
*** self_covid bmi educat domestic work_cat income_cat iso01rel        ***;
*** through iso05pub) since it is the richest of the three options     ***;
*** the source offers behind commented-out %let lines.                 ***;
*** Original runs against crokus_MI (post multiple-imputation) - this  ***;
*** bundle supplies a small mock already-imputed cohort directly.      ***;
*** The two CONTRAST statements and their ods output contrasttest=     ***;
*** capture are omitted here - not a script change, but a workaround   ***;
*** for a currently-known Jenner limitation on that ODS table (filed   ***;
*** upstream separately). Everything else in the macro is unchanged.   ***;
*******************************************************;

proc format;
value age
low-49 = "49 years and less"
50-59 = "50-59 years"
60-69 = "60-69 years"
70-79 = "70-79 years"
80-86 = "80-86 years";

value bmi
low-<18.5 = "underweight"
18.5-<25 = "normal weight"
25-<30 = "pre-obesity"
30-high = "obesity";

value uicc
1 = "I"
2 = "II"
3 = "III"
4 = "IV"
5 = "n.a. (lymphoma)"
0, 9 = "unknown";

value work_catx
1 = "Full-time"
2 = "Part-time or Minijob"
3 = "Not employed or voluntary work";

value domesticx
1,2,3 = "living with or having partner"
4 = "no partner, living alone"
5,6,7 = "living with others or in senior home";

value covidx
0,1,3 = "no infection or not sure"
2 = "previous COVID infection";

value incomecat
0 = "low"
1,2 = "average to high";

*** Formats applied permanently earlier in the source's pipeline (data crokus step,   ***;
*** lines ~956-957 and ~1014) - reproduced here so crokus_MI carries the same         ***;
*** formatted values the PROC LOGISTIC CLASS ref= list expects.                       ***;
value sex
1 = "Female (1)"
2 = "Male (2)";

value tumor
1 = "Breast cancer (1)"
2 = "Colorectal cancer (2)"
3 = "Lung cancer (3)"
4 = "Prostate cancer (4)"
5 = "Leukemia or lymphoma (5)"
6 = "Other cancer (6)"
7 = "Type of cancer unknown (7)"
9 = "Multiple cancers (9)";

value tumorsex
1 = "Breast cancer"
2 = "Colorectal cancer (f)"
3 = "Colorectal cancer (m)"
4 = "Lung cancer (f)"
5 = "Lung cancer (m)"
6 = "Prostate cancer"
7 = "Leukemia or lymphoma (f)"
8 = "Leukemia or lymphoma (m)";

value survivor
1 = "Survivors"
0 = "Patients";

value educat
.,6 = "no information"
1,5 = "9 years or less"
2 = "10-11 years"
3,4 = "12-13 years";

value isolation
0 = "No, as usual (0)"
1 = "Yes, limited (1)";

run;

data crokus_MI;
input _imputation_ HADS_A_cutoff treatment2 agesurvey sex tumor tumorsex
      uicc_cat survivor cancer_phase self_covid bmi educat domestic
      work_cat income_cat iso01rel iso02sh iso03phys iso04care iso05pub wmi;
format sex sex. tumor tumor. tumorsex tumorsex. survivor survivor. educat educat.
       iso01rel iso02sh iso03phys iso04care iso05pub isolation.;
datalines;
1 0 1 55 1 1 1 1 1 2 0 22.5 3 2 1 0 1 0 0 0 1 1
1 1 2 62 2 2 3 2 0 3 2 27.1 4 1 2 1 1 1 1 0 1 1
1 0 0 71 1 3 4 3 1 4 0 19.8 2 4 3 2 1 0 1 0 1 1
1 1 1 48 2 4 6 1 0 1 1 31.4 1 1 3 1 1 0 1 0 0 1
1 0 2 59 1 5 7 5 1 2 3 24.0 3 3 2 1 0 0 0 0 1 1
1 1 0 44 2 1 1 1 0 1 0 20.6 2 1 1 1 1 1 0 1 1 1
2 0 1 55 1 1 1 1 1 2 0 22.5 3 2 1 0 1 0 0 0 1 1
2 1 2 62 2 2 3 2 0 3 2 27.1 4 1 2 1 1 1 1 0 1 1
2 0 0 71 1 3 4 3 1 4 0 19.8 2 4 3 2 1 0 1 0 1 1
2 1 1 48 2 4 6 1 0 1 1 31.4 1 1 3 1 1 0 1 0 0 1
2 0 2 59 1 5 7 5 1 2 3 24.0 3 3 2 1 0 0 0 0 1 1
2 1 0 44 2 1 1 1 0 1 0 20.6 2 1 1 1 1 1 0 1 1 1
;
run;

%let adjust = agesurvey tumorsex uicc_cat survivor cancer_phase self_covid bmi
	educat domestic work_cat income_cat iso01rel iso02sh iso03phys iso04care iso05pub;

ods select none;

%macro adj(scale);
proc logistic data = crokus_MI;
	format agesurvey age. bmi bmi. uicc_cat uicc. work_cat work_catx. domestic domesticx. self_covid covidx.
		income_cat incomecat.;
	class &scale
		treatment2 (order = internal ref = first)
		agesurvey (ref = "60-69 years")
		sex (ref = "Male (2)")
		tumor (ref = "Colorectal cancer (2)")
		tumorsex (ref = "Colorectal cancer (m)")
		uicc_cat (ref = "I")
		survivor (ref = "Survivors")
		cancer_phase (order = internal ref = first)
		self_covid (ref = "no infection or not sure")
		bmi (order = internal ref = 'normal weight')
		educat (ref = "10-11 years")
		domestic (ref= "living with or having partner")
		work_cat (ref= "Full-time")
		income_cat (ref = "average to high")
		iso01rel (ref = "No, as usual (0)")
		iso02sh (ref = "No, as usual (0)")
		iso03phys (ref = "No, as usual (0)")
		iso04care (ref = "No, as usual (0)")
		iso05pub (ref = "No, as usual (0)")
		/ param=glm;
	model &scale (event = "1") = treatment2 &adjust;
	ods output	lsmeans = pct_&scale
				oddsratios = or_&scale;
	lsmeans treatment2 /diff cl adjust=bon ilink;
	by _imputation_;
run;
data pct_&scale; length Skala $50; set pct_&scale; Skala = "&scale"; run;
data or_&scale; length Skala $50; set or_&scale; Skala = "&scale"; run;
%mend;

%adj(HADS_A_cutoff);

ods select all;

title "Odds ratios (HADS_A_cutoff)";
proc print data=or_HADS_A_cutoff label;
var Skala Effect OddsRatioEst LowerCL UpperCL;
run;

title "LS-means (HADS_A_cutoff)";
proc print data=pct_HADS_A_cutoff label;
var Skala Effect Level Mean StdErr;
run;

title;
