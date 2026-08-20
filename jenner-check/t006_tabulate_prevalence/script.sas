*******************************************************;
*** Adapted from "SAS-Code depression anxiety clean 2024-08-15.sas"    ***;
*** Source: the prevalence summary block (lines ~1319-1333) — two      ***;
*** PROC TABULATE reports over a pct/freq dataset built from ODS       ***;
*** OneWayFreqs/CrossTabFreqs output, matching the shape %crude        ***;
*** produces upstream in the source. Titles copied verbatim.           ***;
*******************************************************;

data pct;
input Variable $ Event Percent;
datalines;
HADS_A_cutoff 1 24.5
HADS_A_cutoff11 1 12.1
HADS_D_cutoff 1 18.7
HADS_D_cutoff11 1 9.4
;
run;

data freq;
input Variable $ Skala treatment2 ColPercent;
datalines;
HADS_A_cutoff 1 0 20.0
HADS_A_cutoff 1 1 25.0
HADS_A_cutoff 1 2 30.0
HADS_D_cutoff 1 0 15.0
HADS_D_cutoff 1 1 18.0
HADS_D_cutoff 1 2 22.0
;
run;

title "Prevalence Anxiety/ Depression in overall group";
proc tabulate data=pct;
class variable/ order=data;
var Percent;
table mean="Overall Prevalence", Variable=""*Percent="";
where Event = 1;
run;

title "Prevalence Anxiety/ Depression in subgroups";
proc tabulate data=freq;
class variable treatment2/ order=data;
var ColPercent;
table treatment2="", Variable=""*mean=""*ColPercent="";
where Skala = 1;
run;

title;
