*******************************************************;
*** Adapted from "SAS-Code depression anxiety clean 2024-08-15.sas"    ***;
*** Source: PROC FORMAT catalog (work_cat/uicc/ausschluss/etc.) and    ***;
*** the derivation logic from the "data crokus" step (work_cat,        ***;
*** jobstat cleanup, uicc_cat staging, tx_change ".A" logic).          ***;
*** Original reads from libname crokus (DKFZ network share) - this    ***;
*** bundle substitutes a small inline mock cohort with the same       ***;
*** variable names/shapes so the real derivation logic runs.          ***;
*******************************************************;

*** Set formats (subset actually exercised below, verbatim from source) ***;
proc format;

value survivor
1 = "Survivors"
0 = "Patients";

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

run;

*** Mock cohort standing in for crokus.&crokus (same variable names) ***;
data crokus;
input tid work_full work_part work_midi work_mini work_vol work_na
      jobstat uicc $ uicc_3months_1 $ uicc_3months_2 $ tumor
      tx_change op_ok drug_ok radia_ok fu_ok reha_ok psy_ok nurs_ok
      ausschluss survivor;
datalines;
1  1 0 0 0 0 0  1 I   .  .   1  0 1 1 1 1 1 1 1  6 1
2  0 1 0 0 0 0  2 II  .  .   2  0 . . . . . . .  6 0
3  0 0 0 0 1 0  3 X   I  .   3  0 . . . . . . .  6 1
4  0 0 0 0 0 1  8 III .  .   1  1 1 3 1 . . . .  6 0
5  0 0 1 0 0 0  4 IV  .  .   5  0 . . . . . . .  8 1
6  1 0 0 0 0 0  7 0   .  .   2  0 . . . . . . .  6 0
7  0 0 0 0 0 0  5 I   .  .   4  0 . . . . . . .  9 1
8  0 1 0 0 0 0  6 II  .  .   1  0 . . . . . . .  6 0
9  1 0 0 0 0 0  1 III .  .   3  0 . . . . . . .  6 1
10 0 0 0 1 0 0  2 X   II .   2  0 . . . . . . .  6 0
;
run;

*** Derivation logic adapted from the "data crokus" step (lines ~834-961) ***;
data crokus;
set crokus;

*Exclusion of secondary cancer and invalid diagnoses;
if ausschluss <6 then delete;

*Combine variables on working time;
if work_full then work_cat = 1; *Vollzeit;
if work_full ne 1 and (work_part or work_midi or work_mini) then work_cat = 2; *Teilzeit;
if sum (work_full, work_part, work_midi, work_mini)<1 and (work_vol or work_na) then work_cat = 3; *Ehrenamt oder nicht arbeitend;
if sum (work_full, work_part, work_midi, work_mini, work_vol, work_na) < 1 then work_cat = .; *keine Antwort = Missing;
format work_cat work_catx.;

*Summarize information on job and set "don't want to anwer" to missing;
jobstat = round(jobstat, 1);
if jobstat = 8 then jobstat = .;

*Stage: summarize, set unplausible stage to missing and include registry data;
if index(uicc, "I") and find(uicc, "II")<1 and find(uicc, "IV")<1 then uicc_cat = 1;
if index(uicc, "II") and find(uicc, "III")<1 then uicc_cat = 2;
if index(uicc, "III") then uicc_cat = 3;
if index(uicc, "IV") then uicc_cat = 4;
if uicc in ("", "0", "X") then uicc_cat = .; *Missings und unplausible Stadien --> Imputation auf Missing setzen;
if tumor = 5 then uicc_cat = 5; *Lymphom - logische Missings als eigene Kategorie;
label uicc_cat = "Stage (UICC)";
if uicc = "X" then do;
if index(uicc_3months_1, "I") or index(uicc_3months_2, "I") then uicc_cat = 1;
if index(uicc_3months_1, "II") or index(uicc_3months_2, "II") then uicc_cat = 2;
if index(uicc_3months_1, "III") then uicc_cat = 3;
if index(uicc_3months_1, "IV") then uicc_cat = 4;
end;
format uicc_cat uicc.;

*Set changes to .A if no overall change has been indicated (conditional question);
if tx_change = 0
	and op_ok in (., 1, 3) and drug_ok in (., 1, 3) and radia_ok in (., 1, 3) and fu_ok in (., 1, 3)
	and reha_ok in (., 1, 3) and psy_ok in (., 1, 3) and nurs_ok in (., 1, 3)
then do; op_ok = .A; end;

format survivor survivor.;
run;

title "Derived work_cat / uicc_cat / jobstat after mock cohort cleanup";
proc print data=crokus label;
var tid work_cat jobstat uicc uicc_cat survivor;
run;

title "Cross-tab of derived work category by survivor status";
proc freq data=crokus;
tables work_cat*survivor / norow nocol;
run;

title;
