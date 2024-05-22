***********************************************************;
*** Code for paper "Anxiety and Depression of cancer	***;
***	patients/ survivors during the COVID-19 pandemic" 	***;
*** Daniela Doege, 2024									***;
***********************************************************;

*******************************************************;
*** Preparation 									***;
*******************************************************;

*** Link dataset ***;
libname crokus '\\ad\fs\C071-Daten\CroKuS Daten\SAS-Daten\Auswertedatensatz';
%let crokus = crokus_daten_2023_08_31;

*** Show variables ***;
proc contents data=crokus.&crokus varnum out=variables; run;

*** Set formats ***;

proc format;

value yn
0 = "no (0)"
1 = "yes (1)"
2 = "unsure (2)";

value survivor
1 = "Survivors"
0 = "Patients";

value age
low-49 = "49 years and less"
50-59 = "50-59 years"
60-69 = "60-69 years"
70-79 = "70-79 years"
80-86 = "80-86 years";

value agestand
18-29 = "18-29 Jahre"
30-39 = "30-39 Jahre"
40-44 = "40-44 Jahre"
45-49 = "45-49 Jahre"
50-54 = "50-54 Jahre"
55-59 = "55-59 Jahre"
60-64 = "60-64 Jahre"
65-69 = "65-69 Jahre"
70-74 = "70-74 Jahre"
75-79 = "75-79 Jahre"
80-86 = "80-86 Jahre";

value sex
1 = "Female (1)"
2 = "Male (2)";

value ausschluss
1 = "1) Zweitdiagnose lt. Register bzw. in-situ Zweitkrebs, den die Person auch benennt (Ausschluss)"
2 = "2) Selbstangabe Zweitdiagnose ist dem Register nicht bekannt (Ausschluss)"
3 = "3) Selbstangabe Zweitdiagnose widerspricht Registereintrag (Ausschluss)"
4 = "4) Registerangabe insgesamt vor 2015 oder nicht valide (Ausschluss)"
5 = "5) Keine Zustimmung zum Registerabgleich und kein plausibler Krebs oder kein Diagnosejahr (Ausschluss)"
6 = "6) Keine Zweitdiagnose lt. Register UND Selbstauskunft (Einschluss)"
7 = "7) Zweitdiagnose lt. Register nach Teilnahme oder vor 2015 (Einschluss)"
8 = "8) Zweitdiagnose lt. Register Hautkrebs (Einschluss)"
9 = "9) Zweitdiagnose lt. Register, aber selbe Krebsart (Einschluss)"
10 = "10) In-situ Zweitkrebs lt. Register, den die Person nicht nennt (Einschluss)"
11 = "11) Selbstangabe Zweitdiagnose vor 2015 (Einschluss)"
12 = "12) Selbstangabe Zweitdiagnose Hautkrebs (Einschluss)"
13 = "13) Selbstangabe Zweitdiagnose scheint nur Metastase zu sein (Einschluss)"
14 = "14) Kein Registerabgleich, aber Selbstauskunft plausibel (Einschluss)";

value uicc
1 = "I"
2 = "II"
3 = "III"
4 = "IV"
5 = "n.a. (lymphoma)"
0, 9 = "unknown";

value plannedd
1 = "geplant"
0 = "nicht geplant";

value chg_new
1 = "geändert"
0 = "nicht geändert";

value diag_year
2015, 2016 = "2015/2016"
2017 = "2017"
2018 = "2018"
2019 = "2019"
2020, 2021 = "2020";

value therapy
.B = "ended before pandemic"
.O = "open end";

value bmi
low-<18.5 = "underweight"
18.5-<25 = "normal weight"
25-<30 = "pre-obesity"
30-high = "obesity"; 

value bmix
low-<18.5 = "underweight"
18.5-<30 = "normal weight or pre-obesity"
30-high = "obesity"; 

value marstat
1 = "single (1)"
2 = "married (2)"
3 = "divorced (3)"
4 = "widowed (4)";

value marstatd
. = "k.A."
1 = "Alleinstehend"
2 = "Verheiratet"
3 = "Geschieden"
4 = "Verwitwet";

value domestic
1,2 = "living with spouse or partner (1, 2)"
3 = "having a partner but living alone (3)"
4 = "no partner, living alone (4)"
5 = "living with others (5)"
6 = "senior or nursing home (6)"
7 = "other (7)";

value domesticx
1,2,3 = "living with or having partner"
4 = "no partner, living alone"
5,6,7 = "living with others or in senior home";

value educat
.,6 = "no information"
1,5 = "9 years or less"
2 = "10-11 years"
3,4 = "12-13 years";

value work_cat
1 = "Full-time"
2 = "Part-time or Minijob"
3 = "Other or unknown";

value work_catx
1 = "Full-time"
2 = "Part-time or Minijob"
3 = "Not employed or voluntary work";

value jobstat
1 = "Employed"
2 = "Freelancer"
3 = "Civil servant"
4 = "Retired"
5,6 = "Unemployed"
7,8 = "Other/ Don't want to answer"
9 = "Multiple jobs";

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

value metastasis
0 = "no (0)"
1 = "lymph nodes (1)"
2 = "other organs (2)"
3 = "suspicion (3)"
4 = "unknown (4)";

value recurrence
0 = "no (0)"
1 = "yes (1)"
2 = "suspicion (2)"
3 = "unknown (3)";

value phase
1 = "Diagnosis (1)"
2 = "Primary treatment (2)"
3 = "Remission (3)"
4 = "Follow-up (4)"
5 = "Recurrence (5)"
6 = "Palliative care (6)"
7 = "Unknown (7)"
9 = "Multiple (9)";

value burdend
1 = "Gar nicht (1)"
2 = "(2)"
3 = "(3)"
4 = "Sehr (4)";

value treatment
1 = "Hospital - inpatient care (1)"
2 = "Hospital - outpatient care (2)"
3 = "Oncologist (3)"
4 = "Other specialist (4)"
5 = "At home (5)"
6 = "not applicable (6)"
9 = "multiple (9)";

value txchange
0 = "no"
1 = "yes"
2 = "unsure";

value planned
-1 = "not planned due to Corona (-1)"
 0 = "not planned (0)"
 1 = "planned (1)";

value change
-1 = "changed before (-1)"
 1 = "as planned (1)"
 2 = "changed (2)"
 3 = "changed but not due to Corona (3)";

value changea
1 = "postponed (1)"
2 = "cancelled (2)"
3 = "changed (3)"
5 = "changed in several ways (5)";

value changeb
1 = "postponed (1)"
2 = "cancelled (2)"
3 = "changed to telephone/video (3)"
4 = "changed in another way (4)"
5 = "changed in several ways (5)";

value changec
1 = "postponed (1)"
2 = "cancelled (2)"
3 = "reduced (3)"
4 = "changed to telephone/video (4)"
5 = "changed in several ways (5)";

value postpone
1 = "up to 4 weeks (1)"
2 = "more than 4 weeks (2)"
3 = "indefinite time (3)";

value frequency
1 = "once (1)"
2 = "several times (2)";

value reduction
1 = "up to 1h per week (1)"
2 = "1-5h per week (2)"
3 = "5-10h per week (3)"
4 = "more than 10h per week (4)";

value decision
0 = "no information (0)"
1 = "me (1)"
2 = "physicians (2)"
3 = "both (3)";

value reason
1 = "Infection risk (1)"
2 = "Lack of capacities (2)"
3 = "Other reasons (3)";

value total
. = "no information given"
9 = "no change indicated (9)"
0 = "not planned (0)"
1 = "planned and no change due to pandemic (1)"
2 = "not planned or cancelled due to pandemic (2)"
3 = "postponed due to pandemic (3)"
4 = "used telemedicine (4)"
5 = "other change or several changes (5)";

value totalyn
2, 3, 4, 5 = "any change indicated"
0, 1, 9, . = "not planned or no change indicated";

value totalx
. = "no information given"
0 = "(0) not planned"
1 = "(1) planned and no change due to pandemic"
2 = "(2) cancelled due to pandemic"
3 = "(3) postponed due to pandemic"
4 = "(4) used telemedicine"
5 = "(5) other change or several changes";

value totalxyn
0 = "not planned"
1 = "planned and not changed"
2, 3, 4, 5 = "planned and changed";

value tmtchange
0 = "0) No treatment"
1 = "1) Treatment without change"
2 = "2) Treatment was changed";

value worry
1 = "Applies exactly (1)"
2 = "More likely to apply (2)"
3 = "Partly (3)"
4 = "Rather not applicable (4)"
5 = "Does not apply at all (5)";

value healthstat
1 = "currently much better than before (1)"
2 = "currently slightly better than before (2)"
3 = "about the same as before (3)"
4 = "currently slightly worse than before (4)";

value isolation
0 = "No, as usual (0)"
1 = "Yes, limited (1)";

value isoburden
.A = "not restricted"
1, 2 = "very much or quite a bit"
3, 4, 5 = "unsure or not";

value lessact
1, 2 = "less active"
., 3, 4, 5, 6 = "equally or more active";

value resources
0 = "no"
1 = "yes";

value income3cat
1,2 = "up to 2000 €"
3,4 = "2001-4000 €"
5,6 = "more than 4000 €";

value incomecat
0 = "low"
1,2 = "average to high";

value incomecatx
0 = "low"
1 = "average"
2 = "high";

value covid
0 = "no (0)"
1 = "yes, currently (1)"
2 = "yes, previously (2)"
3 = "not sure (3)";

value covidx
0,1,3 = "no infection or not sure"
2 = "previous COVID infection";

value covsympcurr
1 = "symptoms (1)"
2 = "no symptoms (2)";

value covsympprev
1 = "symptoms but better now (1)"
2 = "still symptoms (2)"
3 = "no symptoms (3)";

value covidoth
1 = "yes, family (1)"
2 = "yes, friends (2)"
3 = "yes, others (3)"
4 = "no/ unknown (4)"
5 = "yes, several persons (5)";

value qx_self
0 = "No"
1 = "Yes"
2 = "With help of partner";

run;


*** Set English labels ***;

%let labels =
b_year = "Year of birth"
sex = "Sex"
height = "Size"
weight = "Weight"
marstat = "Marriage status"
numchil = "number of children"
domestic = "Living situation"
domestic_othr = "Living situation other (text)"
how_many_home = "Number of persons in household"
kids_home = "Number of kids in household  < 15 years"
educat = "Highest school-leaving qualification"
tumor = "Cancer type"
bc_year = "Breast cancer / year of initial diagnosis"
cc_year = "Colorectal cancer  / year of initial diagnosis"
lc_year = "Lung cancer  / year of initial diagnosis"
pc_year = "Prostate cancer  / year of initial diagnosis"
lol_year = "leucemia or lymphoma  / year of initial diagnosis"
oc_year = "Other cancer  / year of initial diagnosis"
octxt = "What type of other cancer"
metas = "metastasis"
recur = "recurrence"
recur_m = "last recurrence date month"
recur_y = "last recurrence date year"
cancer_phase = "Cancer phase"
att_end = "Cancer treatment ended?"
att_feel = "Still feeling as a cancer patient?"
att_bur = "Cancer burden"
tmt_2020 = "Treatment / Followup, time range ( March -June 2020 )"
tmt_curr = "Current Treatment / Followup"
tmt_phys = "Type of specialist"
tmt_care = "Type of care"
self_covid = "Own Corona infection"
self_covid_curr = "Symptoms current infection"
self_covid_prev = "Symptoms previous infection"
covid_oth = "Corona infection of others"
tx_change = "Treatment changes due to pandemic"
op = "Operation planned during pandemic "
op_m = "Operation: planned month"
op_y = "Operation: planned year"
op_ok = "Operation as planned"
op_change = "Operation: Type of change"
op_pp = "Operation: Postponed for how long?"
op_oth = "Operation: Other change"
op_inf = "Operation reason for change: own infection"
op_risk = "Operation reason for change: risk of infection"
op_cap = "Operation reason for change: shortage of capacities"
op_health = "Operation reason for change: poor health status"
op_urg = "Operation reason for change: not urgent"
op_other = "Operation reason for change: other"
op_othertxt = "Operation reason for change: other (text)"
op_unk = "Operation reason for change: unknown"
op_dec = "Operation change: Decision-maker"
op_app = "Operation change: appropriate"
op_imp = "Operation change: impaired treatment success"
op_distxt = "Operation change: disadvantages (text)"
op_dis = "Operation change: disadvantages"
op_bur = "Operation change: burden"
drug = "Drug therapy planned during pandemic "
drug_m = "Drug therapy: planned start month"
drug_y = "Drug therapy: planned start year"
drug_ok = "Drug therapy as planned"
drug_change = "Drug therapy: Type of change"
drug_pp = "Drug therapy: Postponed for how long?"
drug_oth = "Drug therapy: Other change"
drug_inf = "Drug therapy reason for change: own infection"
drug_risk = "Drug therapy reason for change: risk of infection"
drug_cap = "Drug therapy reason for change: shortage of capacities"
drug_health = "Drug therapy reason for change: poor health status"
drug_urg = "Drug therapy reason for change: not urgent"
drug_other = "Drug therapy reason for change: other"
drug_othertxt = "Drug therapy reason for change: other (text)"
drug_unk = "Drug therapy reason for change: unknown"
drug_dec = "Drug therapy change: Decision-maker"
drug_app = "Drug therapy change: appropriate"
drug_imp = "Drug therapy change: impaired treatment success"
drug_distxt = "Drug therapy change: disadvantages (text)"
drug_dis = "Drug therapy change: disadvantages"
drug_bur = "Drug therapy change: burden"
radia = "Radiotherapy planned during pandemic "
radia_m = "Radiotherapy: planned start month"
radia_y = "Radiotherapy: planned start year"
radia_ok = "Radiotherapy as planned"
radia_change = "Radiotherapy: Type of change"
radia_pp = "Radiotherapy: Postponed for how long?"
radia_oth = "Radiotherapy: Other change"
radia_inf = "Radiotherapy reason for change: own infection"
radia_risk = "Radiotherapy reason for change: risk of infection"
radia_cap = "Radiotherapy reason for change: shortage of capacities"
radia_health = "Radiotherapy reason for change: poor health status"
radia_urg = "Radiotherapy reason for change: not urgent"
radia_other = "Radiotherapy reason for change: other"
radia_othertxt = "Radiotherapy reason for change: other (text)"
radia_unk = "Radiotherapy reason for change: unknown"
radia_dec = "Radiotherapy change: Decision-maker"
radia_app = "Radiotherapy change: appropriate"
radia_imp = "Radiotherapy change: impaired treatment success"
radia_distxt = "Radiotherapy change: disadvantages (text)"
radia_dis = "Radiotherapy change: disadvantages"
radia_bur = "Radiotherapy change: burden"
fu = "Follow-up planned during pandemic "
fu_m = "Follow-up: planned start month"
fu_y = "Follow-up: planned start year"
fu_ok = "Follow-up as planned"
fu_change = "Follow-up: Type of change"
fu_pp = "Follow-up: Postponed for how long?"
fu_video = "Follow-up: Change to telephone/video"
fu_oth = "Follow-up: Other change"
fu_inf = "Follow-up reason for change: own infection"
fu_risk = "Follow-up reason for change: risk of infection"
fu_cap = "Follow-up reason for change: shortage of capacities"
fu_health = "Follow-up reason for change: poor health status"
fu_urg = "Follow-up reason for change: not urgent"
fu_other = "Follow-up reason for change: other"
fu_othertxt = "Follow-up reason for change: other (text)"
fu_unk = "Follow-up reason for change: unknown"
fu_dec = "Follow-up change: Decision-maker"
fu_app = "Follow-up change: appropriate"
fu_imp = "Follow-up change: impaired treatment success"
fu_distxt = "Follow-up change: disadvantages (text)"
fu_dis = "Follow-up change: disadvantages"
fu_bur = "Follow-up change: burden"
reha = "Rehabilitation planned during pandemic "
reha_m = "Rehabilitation: planned start month"
reha_y = "Rehabilitation: planned start year"
reha_ok = "Rehabilitation as planned"
reha_change = "Rehabilitation: Type of change"
reha_pp = "Rehabilitation: Postponed for how long?"
reha_oth = "Rehabilitation: Other change"
reha_inf = "Rehabilitation reason for change: own infection"
reha_risk = "Rehabilitation reason for change: risk of infection"
reha_cap = "Rehabilitation reason for change: shortage of capacities"
reha_health = "Rehabilitation reason for change: poor health status"
reha_urg = "Rehabilitation reason for change: not urgent"
reha_other = "Rehabilitation reason for change: other"
reha_othertxt = "Rehabilitation reason for change: other (text)"
reha_unk = "Rehabilitation reason for change: unknown"
reha_dec = "Rehabilitation change: Decision-maker"
reha_app = "Rehabilitation change: appropriate"
reha_imp = "Rehabilitation change: impaired treatment success"
reha_distxt = "Rehabilitation change: disadvantages (text)"
reha_dis = "Rehabilitation change: disadvantages"
reha_bur = "Rehabilitation change: burden"
psy = "Psychooncological care planned during pandemic "
psy_m = "Psychooncological care: planned start month"
psy_y = "Psychooncological care: planned start year"
psy_ok = "Psychooncological care as planned"
psy_change = "Psychooncological care: Type of change"
psy_pp = "Psychooncological care: Postponed for how long?"
psy_video = "Psychooncological care: Changed to telephone/video"
psy_inf = "Psychooncological care reason for change: own infection"
psy_risk = "Psychooncological care reason for change: risk of infection"
psy_cap = "Psychooncological care reason for change: shortage of capacities"
psy_health = "Psychooncological care reason for change: poor health status"
psy_urg = "Psychooncological care reason for change: not urgent"
psy_other = "Psychooncological care reason for change: other"
psy_othertxt = "Psychooncological care reason for change: other (text)"
psy_unk = "Psychooncological care reason for change: unknown"
psy_dec = "Psychooncological care change: Decision-maker"
psy_app = "Psychooncological care change: appropriate"
psy_imp = "Psychooncological care change: impaired treatment success"
psy_distxt = "Psychooncological care change: disadvantages (text)"
psy_dis = "Psychooncological care change: disadvantages"
psy_bur = "Psychooncological care change: burden"
nurs = "Nursing care planned during pandemic "
nurs_m = "Nursing care: planned start month"
nurs_y = "Nursing care: planned start year"
nurs_ok = "Nursing care as planned"
nurs_change = "Nursing care: Type of change"
nurs_pp = "Nursing care: Postponed for how long?"
nurs_red = "Nursing care: Reduction of hours"
nurs_video = "Nursing care: Changed to telephone/video"
nurs_inf = "Nursing care reason for change: own infection"
nurs_risk = "Nursing care reason for change: risk of infection"
nurs_cap = "Nursing care reason for change: shortage of capacities"
nurs_health = "Nursing care reason for change: poor health status"
nurs_urg = "Nursing care reason for change: not urgent"
nurs_other = "Nursing care reason for change: other"
nurs_othertxt = "Nursing care reason for change: other (text)"
nurs_unk = "Nursing care reason for change: unknown"
nurs_dec = "Nursing care change: Decision-maker"
nurs_app = "Nursing care change: appropriate"
nurs_imp = "Nursing care change: impaired treatment success"
nurs_distxt = "Nursing care change: disadvantages (text)"
nurs_dis = "Nursing care change: disadvantages"
nurs_bur = "Nursing care change: burden"
fur_chg = "Further changes in oncological care"
fur_chgtxt = "Further changes in oncological care (text)"
burden_2020 = "Burden of changes 2020"
burden_2020na = "Burden of changes 2020 not attributable"
burden_curr = "Burden of changes current"
supp = "Seeked other support?"
supp_phys = "Other support: Treating physician"
supp_psy = "Other support: Psychooncologist"
supp_phys2 = "Other support: Other physician"
supp_ins = "Other support: Insurance"
supp_couns = "Other support: Counseling"
supp_info = "Other support: Information"
supp_other = "Other support: Other"
supp_othertxt = "Other support: Other (text)"
sf01gh = "SF12: 1. General health perception"
sf02act = "SF12: 2. Limitations in moderate activity"
sf03stairs = "SF12: 3. Limitations in climbing stairs"
sf04lessph = "SF12: 4. Accomplished less due to physical health"
sf05limph = "SF12: 5. Limitation in work due to physical health"
sf06lessep = "SF12: 6. Accomplished less due to emotional problems"
sf07limep = "SF12: 7. Limitation in work due to emotional problems"
sf08pain = "SF12: 8. Body pain"
sf09calm = "SF12: 9. Calm and peaceful"
sf10ener = "SF12: 10. Lot of energy"
sf11down = "SF12: 11. Downhearted and blue"
sf12soc = "SF12: 12. Problems interfered with social activities"
c01korp = "C30: 1. Do you have trouble doing strenuous activities?"
c02spaz = "C30: 2. Do you have trouble taking a long walk?"
c03haus = "C30: 3. Do you have trouble taking a short walk outside of the house?"
c04bett = "C30: 4. Do you need to stay in bed or a chair during the day?"
c05hilf = "C30: 5. Do you need help with eating, dressing, washing yourself, or using the toilet?"
c06warb = "C30: 6. Were you limited in doing either your work or other daily activities?"
c07karb = "C30: 7. Were you limited in pursuing your hobbies or other leisure time activities?"
c08atmg = "C30: 8. Were you short of breath?"
c09schmz = "C30: 9. Have you had pain?"
c10ruhe = "C30: 10. Do you need to rest?"
c11schlf = "C30: 11. Have you had trouble sleeping?"
c12schw = "C30: 12. Have you felt weak?"
c13appt = "C30: 13. Have you lacked appetite?"
c14uebel = "C30: 14. Have you felt nauseated?"
c15erbr = "C30: 15. Have you vomited?"
c16verst = "C30: 16. Have you been constipated?"
c17durch = "C30: 17. Have you had diarrhea?"
c18muede = "C30: 18. Were you tired?"
c19leben = "C30: 19. Did pain interfere with your daily activities?"
c20konz = "C30: 20. Have you had difficulty in concentrating on things like reading a newspaper or watching television?"
c21spann = "C30: 21. Did you feel tense?"
c22sorg = "C30: 22. Did you worry?"
c23reiz = "C30: 23. Did you feel irritable?"
c24nied = "C30: 24. Did you feel depressed?"
c25erinn = "C30: 25. Have you had difficulty remembering things?"
c26famil = "C30: 26. Has your physical condition or medical treatment interfered with your family life?"
c27aktiv = "C30: 27. Has your physical condition or medical treatment interfered with your social activities?"
c28finan = "C30: 28. Has your physical condition or medical treatment caused you financial difficulties?"
c29zust = "C30: 29. How would you rate your overall health during the past week?"
c30qual = "C30: 30. How would you rate your overall quality of life during the past week?"
c01korp_2020 = "C30: 1. Do you have trouble doing strenuous activities? (2020)"
c02spaz_2020 = "C30: 2. Do you have trouble taking a long walk? (2020)"
c03haus_2020 = "C30: 3. Do you have trouble taking a short walk outside of the house? (2020)"
c04bett_2020 = "C30: 4. Do you need to stay in bed or a chair during the day? (2020)"
c05hilf_2020 = "C30: 5. Do you need help with eating, dressing, washing yourself, or using the toilet? (2020)"
c06warb_2020 = "C30: 6. Were you limited in doing either your work or other daily activities? (2020)"
c07karb_2020 = "C30: 7. Were you limited in pursuing your hobbies or other leisure time activities? (2020)"
c08atmg_2020 = "C30: 8. Were you short of breath? (2020)"
c09schmz_2020 = "C30: 9. Have you had pain? (2020)"
c10ruhe_2020 = "C30: 10. Do you need to rest? (2020)"
c11schlf_2020 = "C30: 11. Have you had trouble sleeping? (2020)"
c12schw_2020 = "C30: 12. Have you felt weak? (2020)"
c13appt_2020 = "C30: 13. Have you lacked appetite? (2020)"
c14uebel_2020 = "C30: 14. Have you felt nauseated? (2020)"
c15erbr_2020 = "C30: 15. Have you vomited? (2020)"
c16verst_2020 = "C30: 16. Have you been constipated? (2020)"
c17durch_2020 = "C30: 17. Have you had diarrhea? (2020)"
c18muede_2020 = "C30: 18. Were you tired? (2020)"
c19leben_2020 = "C30: 19. Did pain interfere with your daily activities? (2020)"
c20konz_2020 = "C30: 20. Have you had difficulty in concentrating on things like reading a newspaper or watching television? (2020)"
c21spann_2020 = "C30: 21. Did you feel tense? (2020)"
c22sorg_2020 = "C30: 22. Did you worry? (2020)"
c23reiz_2020 = "C30: 23. Did you feel irritable? (2020)"
c24nied_2020 = "C30: 24. Did you feel depressed? (2020)"
c25erinn_2020 = "C30: 25. Have you had difficulty remembering things? (2020)"
c26famil_2020 = "C30: 26. Has your physical condition or medical treatment interfered with your family life? (2020)"
c27aktiv_2020 = "C30: 27. Has your physical condition or medical treatment interfered with your social activities? (2020)"
c28finan_2020 = "C30: 28. Has your physical condition or medical treatment caused you financial difficulties? (2020)"
c29zust_2020 = "C30: 29. How would you rate your overall health during the past week? (2020)"
c30qual_2020 = "C30: 30. How would you rate your overall quality of life during the past week? (2020)"
hads01tens = "HADS: 1. I feel tense or 'wound up'"
hads02enj = "HADS: 2. I still enjoy the things I used to enjoy"
hads03fear = "HADS: 3. I get a sort of frightened feeling as if something awful is about to happen"
hads04fun = "HADS: 4. I can laugh and see the funny side of things"
hads05worry = "HADS: 5. Worrying thoughts go through my mind"
hads06happy = "HADS: 6. I feel cheerful"
hads07relax = "HADS: 7. I can sit at ease and feel relaxed"
hads08slow = "HADS: 8. I feel as if I am slowed down"
hads09nerv = "HADS: 9. I get a sort of frightened feeling like 'butterflies' in the stomach"
hads10seed = "HADS: 10. I have lost interest in my appearance"
hads11rest = "HADS: 11. I feel restless as I have to be on the move"
hads12fut = "HADS: 12. I look forward with enjoyment to things"
hads13panic = "HADS: 13. I get sudden feelings of panic"
hads14media = "HADS: 14. I can enjoy a good book or radio or TV program"
phq01health = "PHQ: 1. Worries about health"
phq02look = "PHQ: 2. Worries about weight or look"
phq03sex = "PHQ: 3. Little or no sexual desire"
phq04prtn = "PHQ: 4. Difficulties with partner"
phq05care = "PHQ: 5. Stress of care taking"
phq06work = "PHQ: 6. Stress at work or at school"
phq07fin = "PHQ: 7. Financial problems or worries"
phq08prob = "PHQ: 8. Having no one to turn to with problems"
phq09bad = "PHQ: 9. Something bad that happened recently"
phq10trauma = "PHQ: 10. Thinking/dreaming about sth terrible that happened"
healthstat = "Health status compared to before pandemic"
worr01work = "Worries about work and financial consequences"
worr02fin = "Worries about financial surplus loads due to cancer"
worr03long = "Worries about long-term financial consequences"
worr04inf = "Worries to be affected by COVID-19"
worr05others = "Worries that loved ones could be affected by COVID-19"
worr06care = "Worries about consequences for medical care"
iso01rel = "Restricted contact to relatives currently: y/n"
iso01relb = "Restricted contact to relatives currently: burden"
iso02sh = "Restricted contact to self-help currently: y/n"
iso02shb = "Restricted contact to self-help currently: burden"
iso03phys = "Restricted contact to physicians currently: y/n"
iso03physb = "Restricted contact to physicians currently: burden"
iso04care = "Restricted contact to carers currently: y/n"
iso04careb = "Restricted contact to carers currently: burden"
iso05pub = "Restricted contact in public currently: y/n"
iso05pubb = "Restricted contact in public currently: burden"
iso01rel_2020 = "Restricted contact to relatives 2020: y/n"
iso01relb_2020 = "Restricted contact to relatives 2020: burden"
iso02sh_2020 = "Restricted contact to self-help 2020: y/n"
iso02shb_2020 = "Restricted contact to self-help 2020: burden"
iso03phys_2020 = "Restricted contact to physicians 2020: y/n"
iso03physb_2020 = "Restricted contact to physicians 2020: burden"
iso04care_2020 = "Restricted contact to carers 2020: y/n"
iso04careb_2020 = "Restricted contact to carers 2020: burden"
iso05pub_2020 = "Restricted contact in public 2020: y/n"
iso05pubb_2020 = "Restricted contact in public 2020: burden"
act01work = "Changed activity at work"
act02house = "Changed activity in household"
act03free = "Changed activity in free time"
act04sport = "Changed sportive activity"
act05move = "Changed activity to move"
act06sit = "Changed sedentary activity"
res01help = "Resources: Professional help"
res02fam = "Resources: Social support"
res03cont = "Resources: Social contact via media"
res04nat = "Resources: Nature/gardening"
res05pet = "Resources: Pet"
res06rel = "Resources: Religion/Spirituality"
res07opt = "Resources: Optimism"
res08spor = "Resources: Sports, Relaxation, Meditation"
res09media = "Resources: Movies, series, books, music"
res10oth = "Resources: Other y/n"
res10othtxt = "Resources: Other (text)"
res_na = "Resources: not applicable"
res_no = "Resources: no answer"
jobstat_2020 = "Working status (2020)"
jobstat = "Working status (currently)"
jobstat_txt = "Working status text"
work_full_2020 = "Work: Full time (2020)"
work_part_2020 = "Work: Part time (2020)"
work_midi_2020 = "Work: Midijob (2020)"
work_mini_2020 = "Work: Minijob (2020)"
work_vol_2020 = "Work: Volunteer (2020)"
work_na_2020 = "Work: not applicable (2020)"
work_no_2020 = "Work: no answer (2020)"
work_full = "Work: Full time (currently)"
work_part = "Work: Part time (currently)"
work_midi = "Work: Midijob (currently)"
work_mini = "Work: Minijob (currently)"
work_vol = "Work: Volunteer (currently)"
work_na = "Work: not applicable (currently)"
work_no = "Work: no answer (currently)"
unabl_wk = "Unable to work"
unabl_wk_days = "Unable to work last 4 weeks number of days"
unabl_wk_days2020 = "Unable to work 2020 number of days"
work_chg = "Changes in work due to pandemic"
work_chg_less = "Work change: less work"
work_chg_less_feel = "Work change: less work feeling"
work_chg_more = "Work change: more work"
work_chg_more_feel = "Work change: more work feeling"
work_chg_new = "Work change: new work"
work_chg_new_feel = "Work change: new work feeling"
work_chg_home = "Work change: home office"
work_chg_home_feel = "Work change: home office feeling"
work_chg_kids = "Work change: more child care"
work_chg_kids_feel = "Work change: more child care feeling"
work_chg_loss = "Work change: loss of work place"
work_chg_loss_feel = "Work change: loss of work place feeling"
fin_loss_cor_yn = "Income loss due to pandemic (own)"
fin_loss_cor_cost = "Income loss due to pandemic (own, amount)"
fin_loss_corhh_yn = "Income loss due to pandemic (household)"
fin_loss_corhh_cost = "Income loss due to pandemic (household, amount)"
addcost = "Additional health cost due to pandemic"
addcost_care = "Co-payments for outpatient or inpatient services"
addcost_tx = "Private medical treatment"
addcost_lab = "Laboratory diagnostics / apparatus-based examinations"
addcost_drive = "Travel expenses"
addcost_home = "Home helper"
addcost_drug = "Treatments and medication that are not reimbursed by insurance"
addcost_nurs = "Nursing staff"
addcost_mask = "Purchase of masks, disinfectants, etc."
addcost_oth = "Other cost"
addcost_othtxt = "Other (text)"
addcost_eur = "Monthly additional health costs due to Corona"
comploss = "Possibility to compensate extra costs y/n"
comploss_shrt = "Short-time work"
comploss_aid = "Interim aids"
comploss_save = "Savings"
comploss_cred = "Credit"
comploss_ins = "Mortgage of life/ retirement insurance"
comploss_prop = "Sale/ mortgage of property"
comploss_fam = "Support by family/ friends"
comploss_oth = "Other form of compensation"
comploss_othtxt = "Other (text)"
save_na = "Saving: Does not apply (I don't have to save)"
save_med = "Saving: for medical treatments / additional services"
save_drug = "Saving: By not taking medication that I have to pay for"
save_act = "Saving: In my leisure time (e.g. going to the cinema, eating / going out, traveling, sports)"
save_cos = "Saving: at hairdressers, care products, cosmetics"
save_food = "Saving: in my diet / food"
save_cloth = "Saving: When buying clothing"
save_lux = "Saving: With luxury goods (tobacco, alcohol ...)"
save_equ = "Saving: With equipment for household and living"
save_move = "Saving: By moving to a cheaper house / apartment"
save_bills = "Saving: By paying bills later"
save_oth = "Saving: Other"
save_othtxt = "Saving: Other (text)"
save_no = "Saving: I don't want to make any statements about this"
fin_change = "Financial situation of the household changed since the beginning of the pandemic"
job_risk_own = "My own job or my professional existence is at risk"
job_risk_partn = "The job or the professional existence of my partner is at risk"
finstat = "How well does the household make ends meet financially?"
income = "Total household net income"
ins_stat = "Insurance: statutory"
ins_pri = "Insurance: private"
ins_supp = "Insurance: private supplementary insurance"
ins_allow = "Insurance: allowance"
ins_self = "Insurance: self-payer"
ins_co = "Insurance: Co-insured free of charge"
ins_soc = "Insurance: Social Welfare Office"
ins_none = "Insurance: not insured"
ins_no = "Insurance: no information"
dated = "Completion date day"
datem = "Completion date month"
datey = "Completion date year"
qx_self = "Filled in questionnaire by oneself"
info = "Given comment/ open answer yes/no"
doku = "Additional notes";


*******************************************************;
*** Adjustments of dataset, Multiple Imputation		***;
*******************************************************;

*** Preparation of dataset ***;
data crokus;
set crokus.&crokus;
label &labels;

*Exclusion of secondary cancer and invalid diagnoses;
if ausschluss <6 then delete;

*Combine variables on working time;
if work_full then work_cat = 1; *Vollzeit;
if work_full ne 1 and (work_part or work_midi or work_mini) then work_cat = 2; *Teilzeit;
if sum (work_full, work_part, work_midi, work_mini)<1 and (work_vol or work_na) then work_cat = 3; *Ehrenamt oder nicht arbeitend;
if sum (work_full, work_part, work_midi, work_mini, work_vol, work_na) < 1 then work_cat = .; *keine Antwort = Missing;
if work_full_2020 then work_cat_2020 = 1; *Vollzeit;
if work_full_2020 ne 1 and (work_part_2020 or work_midi_2020 or work_mini_2020) then work_cat_2020 = 2; *Teilzeit;
if sum (work_full_2020, work_part_2020, work_midi_2020, work_mini_2020)<1 and (work_vol_2020 or work_na_2020) then work_cat_2020 = 3; *Ehrenamt oder nicht arbeitend;
if sum (work_full_2020, work_part_2020, work_midi_2020, work_mini_2020, work_vol_2020, work_na_2020) < 1 then work_cat_2020 = .; *keine Antwort = Missing;
format work_cat work_cat_2020 work_catx.;

*Summarize information on job and set "don't want to anwer" to missing;
jobstat = round(jobstat, 1); jobstat_2020 = round(jobstat_2020, 1);
if jobstat = 8 then jobstat = .; if jobstat_2020 = 8 then jobstat_2020 = .;

*Set "don't want to anwer" of incometo missing;
if income = 7 then income = .;

*Education: set "don't want to anwer" to missing;
if educat = 6 then educat = .;

*Cancer phase: set "don't want to anwer" to missing;
if cancer_phase = 7 then cancer_phase = .;

*Stage: summarize, set unplausible stage to missing and include registry data;
if index(uicc, "I") and find(uicc, "II")<1 and find(uicc, "IV")<1 then uicc_cat = 1;
if index(uicc, "II") and find(uicc, "III")<1 then uicc_cat = 2;
if index(uicc, "III") then uicc_cat = 3;
if index(uicc, "IV") then uicc_cat = 4;
if uicc in ("", "0", "X") then uicc_cat = .; *Missings und unplausible Stadien --> für Imputation auf Missing setzen;
if tumor = 5 then uicc_cat = 5; *Lymphom - logische Missings als eigene Kategorie;
label uicc_cat = "Stage (UICC)";
if uicc = "X" then do;
if index(uicc_3months_1, "I") or index(uicc_3months_2, "I") then uicc_cat = 1;
if index(uicc_3months_1, "II") or index(uicc_3months_2, "II") then uicc_cat = 2;
if index(uicc_3months_1, "III") then uicc_cat = 3;
if index(uicc_3months_1, "IV") then uicc_cat = 4;
end;

*Unplausible Jahre 2021 auf 2020 setzen (Lt. Register alle 2020 - hatten 2021 Rezidiv o.ä.);
if diag_year = 2021 then diag_year = 2020;

*Set changes to .A if no overall change has been indicated (conditional question);
if tx_change = 0
	and op_ok in (., 1, 3) and drug_ok in (., 1, 3) and radia_ok in (., 1, 3) and fu_ok in (., 1, 3) 
	and reha_ok in (., 1, 3) and psy_ok in (., 1, 3) and nurs_ok in (., 1, 3)
then do; op = .A; drug = .A; radia = .A; fu = .A; reha = .A; psy = .A; nurs = .A;
op_m = .; op_y = .; op_ok = .; op_change = .; op_pp = .; op_oth = .; op_inf = .; op_risk = .; op_cap = .; op_health = .; op_urg = .; op_other = .; op_othertxt = ''; op_unk = .; op_dec = .; op_app = .; op_imp = .; op_distxt = ''; op_dis = .; op_bur = .; 
drug_m = .; drug_y = .; drug_ok = .; drug_change = .; drug_pp = .; drug_oth = .; drug_inf = .; drug_risk = .; drug_cap = .; drug_health = .; drug_urg = .; drug_other = .; drug_othertxt = ''; drug_unk = .; drug_dec = .; drug_app = .; drug_imp = .; drug_distxt = ''; drug_dis = .; drug_bur = .;
radia_m = .; radia_y = .; radia_ok = .; radia_change = .; radia_pp = .; radia_oth = .; radia_inf = .; radia_risk = .; radia_cap = .; radia_health = .; radia_urg = .; radia_other = .; radia_othertxt = ''; radia_unk = .; radia_dec = .; radia_app = .; radia_imp = .; radia_distxt = ''; radia_dis = .; radia_bur = .;
fu_m = .; fu_y = .; fu_ok = .; fu_change = .; fu_pp = .; fu_video = .; fu_oth = .; fu_inf = .; fu_risk = .; fu_cap = .; fu_health = .; fu_urg = .; fu_other = .; fu_othertxt = ''; fu_unk = .; fu_dec = .; fu_app = .; fu_imp = .; fu_distxt = ''; fu_dis = .; fu_bur = .; 
reha_m = .; reha_y = .; reha_ok = .; reha_change = .; reha_pp = .; reha_oth = .; reha_inf = .; reha_risk = .; reha_cap = .; reha_health = .; reha_urg = .; reha_other = .; reha_othertxt = ''; reha_unk = .; reha_dec = .; reha_app = .; reha_imp = .; reha_distxt = ''; reha_dis = .; reha_bur = .;
psy_m = .; psy_y = .; psy_ok = .; psy_change = .; psy_pp = .; psy_video = .; psy_inf = .; psy_risk = .; psy_cap = .; psy_health = .; psy_urg = .; psy_other = .; psy_othertxt = ''; psy_unk = .; psy_dec = .; psy_app = .; psy_imp = .; psy_distxt = ''; psy_dis = .; psy_bur = .; 
nurs_m = .; nurs_y = .; nurs_ok = .; nurs_change = .; nurs_pp = .; nurs_red = .; nurs_video = .; nurs_inf = .; nurs_risk = .; nurs_cap = .; nurs_health = .; nurs_urg = .; nurs_other = .; nurs_othertxt = ''; nurs_unk = .; nurs_dec = .; nurs_app = .; nurs_imp = .; nurs_distxt = ''; nurs_dis = .; nurs_bur = .;
end;

*Set burden to .A if no change has been indicated;
if tx_change ne 1 then do; burden_2020 = .A; burden_curr = .A; end;
if burden_2020na = 1 then burden_2020 = .A;

*Combine data on treatment changes to 1 variable per domain;
array care op drug radia fu reha psy nurs;
array change op_ok drug_ok radia_ok fu_ok reha_ok psy_ok nurs_ok;
array howchange op_change drug_change radia_change fu_change reha_change psy_change nurs_change;
array total op_total drug_total radia_total fu_total reha_total psy_total nurs_total;
array chg op_chg drug_chg radia_chg fu_chg reha_chg psy_chg nurs_chg;
do over total;
	if tx_change = 0 and nmiss(op, drug, radia, fu, reha, psy, nurs) = 7 then total = 9; *generell keine Behandlungsänderung angegeben, wir wissen nicht ob was geplant war;
	if care in (0, 3) then total = 0; *Beh. nicht geplant unabhängig von Corona;
	if care = 1 and change in (., 1, 3) then total = 1; *Beh. geplant und nicht wg. Corona geändert;
	if care = 1 and change = 2 and howchange = 2 or care = -1 then total = 2; *Beh. wegen Corona nicht geplant oder abgesagt;
	if care = 1 and change in (-1, 2) and howchange = 1 then total = 3; *Beh. wegen Corona verschoben;
	if care = 1 and change = 2 and howchange in (., 3, 4, 5) then total = 5; *Beh. wegen Corona anderweitig oder mehrfach geändert;
end;
	if fu = 1 and fu_ok = 2 and fu_change = 3 then fu_total = 4;  *Videochat Nachsorge;
	if psy = 1 and psy_ok = 2 and psy_change = 3 then psy_total = 4;  *Videochat Psychoonkologie;
	if nurs = 1 and nurs_ok = 2 and nurs_change = 4 then nurs_total = 4;  *Videochat Pflege;
format op_total drug_total radia_total fu_total reha_total psy_total nurs_total total.;

*Calculate number of changes;
do over total; if total in (2, 3, 4, 5) then chg = 1; end; *Änderung dichotom;
chg_nr = sum (op_chg, drug_chg, radia_chg, fu_chg, reha_chg, psy_chg, nurs_chg);
drop op_chg drug_chg radia_chg fu_chg reha_chg psy_chg nurs_chg;

*Changes for those with planned treatment (considering registered treatments);
array selbstang op_total drug_total radia_total;
array totalx op_totalx drug_totalx radia_totalx;
array register op_corona sy_corona st_corona;
do over totalx;
	totalx = selbstang;
	if selbstang in (., 9) then do; *Selbstauskunft fehlt --> Registerangabe zählt;
		if register = 0 then totalx = 0;
		if register = 1 then totalx = 1;
		if register = . then totalx = .; end; *verbleibende fehlende Angaben bei denen die Registerangabe ebenfalls fehlt;
	end;
label 	op_totalx = "OP verschoben unter Einbezug geplanter Behandlungen"
		drug_totalx = "Syst. Th. verschoben unter Einbezug geplanter Behandlungen"
		radia_totalx = "Radiotherapie verschoben unter Einbezug geplanter Behandlungen";
format op_totalx drug_totalx radia_totalx totalx.;

*Any change if surgery, systemic or radiation therapy was planned;
if op_totalx not in (1 2 3 5) and drug_totalx not in (1 2 3 5) and radia_totalx not in (1 2 3 5) and tx_change ne 1 then treatment = 0; *keine Beh gehabt;
if (op_totalx in (1 2 3 5) or drug_totalx in (1 2 3 5) or radia_totalx in (1 2 3 5)) and tx_change = 0 then treatment = 1; *Behandlung gehabt die nicht geändert wurde;
if tx_change = 1 then treatment = 2; *Behandlung geändert;

*Variable for change of surgery, systemic or radiation therapy;
if op_totalx = 0 and drug_totalx = 0 and radia_totalx = 0 then treatment2 = 0; *keine der drei Beh gehabt;
if treatment2 ne 0 and op_totalx in (0 1) and drug_totalx in (0 1) and radia_totalx in (0 1) then treatment2 = 1; *Behandlung gehabt die nicht geändert wurde;
if op_totalx in (2 3 5) or drug_totalx in (2 3 5) or radia_totalx in (2 3 5) then treatment2 = 2; *Behandlung geändert;
format treatment tmtchange. treatment2 tmtchange.;

*Formats and labels;
agesurvey_cat = agesurvey;
label agesurvey_cat = "Age at survey";
format agesurvey agestand. agesurvey_cat age. sex sex. educat educat. marstat marstat. domestic domestic. jobstat jobstat. work_cat work_cat.
tumor tumor_reg tumor. uicc_cat uicc. cancer_phase phase. att_end att_feel yn. self_covid covid. diagdat_reg ddmmyy10. survivor survivor.;

*Dummy weight for MI;
wmi = 1;
run;


*** Multiple Imputation ***;

%let nimpute = 25; *Number of imputations;

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

*** Adjustment of imputed dataset ***;
data crokus_MI;
set crokus_MI;
*Calculation of HADS categories;
if HADS_A ne . and HADS_A < 8 then HADS_A_cutoff = 0;
if HADS_A ge 8 then HADS_A_cutoff = 1;
if HADS_D ne . and HADS_D < 8 then HADS_D_cutoff = 0;
if HADS_D ge 8 then HADS_D_cutoff = 1;
if HADS_A ne . and HADS_A < 11 then HADS_A_cutoff11 = 0;
if HADS_A ge 11 then HADS_A_cutoff11 = 1;
if HADS_D ne . and HADS_D < 11 then HADS_D_cutoff11 = 0;
if HADS_D ge 11 then HADS_D_cutoff11 = 1;
*BMI;
if weight and height then bmi = weight/((height/100)*(height/100));
*Income;
if how_many_home = 0 and income = 1 then income_cat = 0; *Singles mit niedrigem Einkommen;
if how_many_home = 0 and income = 2 then income_cat = 1; *Singles mit mittlerem Einkommen;
if how_many_home = 0 and income in (3 4 5 6) then income_cat = 2; *Singles mit höherem Einkommen;
if how_many_home ge 1 and income in (1 2) then income_cat = 0; *Familien mit niedrigem Einkommen;
if how_many_home ge 1 and income in (3 4) then income_cat = 1; *Familien mit mittlerem Einkommen;
if how_many_home ge 1 and income in (5 6) then income_cat = 2; *Familien mit höherem Einkommen;
format income_cat incomecat.;
*Tumor * sex;
if tumor = 1 then tumorsex = 1;
if tumor = 2 and sex = 1 then tumorsex = 2;
if tumor = 2 and sex = 2 then tumorsex = 3;
if tumor = 3 and sex = 1 then tumorsex = 4;
if tumor = 3 and sex = 2 then tumorsex = 5;
if tumor = 4 then tumorsex = 6;
if tumor = 5 and sex = 1 then tumorsex = 7;
if tumor = 5 and sex = 2 then tumorsex = 8;
format tumorsex tumorsex.;
*Weight;
wmi = 1/&nimpute;
*Decision-maker of treatment changes;
if treatment2 ne 2 then dec_change = .A;
if treatment2 = 2 then do; *nur relevant wenn Änderung;
	dec_change = .;
	*Keinerlei Angabe zur Entscheidung;
	if nmiss(op_dec, drug_dec, radia_dec) = 3 then dec_change = 0;
	*Nur ich;
	if dec_change = . and op_dec in (., 1) and drug_dec in (., 1) and radia_dec in (., 1) then dec_change = 1;
	*Nur Ärzte;
	if dec_change = . and op_dec in (., 2) and drug_dec in (., 2) and radia_dec in (., 2) then dec_change = 2;
	*nur beide;
	if dec_change = . and op_dec in (., 3) and drug_dec in (., 3) and radia_dec in (., 3) then dec_change = 3;
	*Arzt und beide --> zu beide;
	if tid in (18 1421 1603 1908 2554) then dec_change = 3;
	end;
format dec_change decision.;
*Reasons for treatment changes;
if op_totalx le 1 then op_reason = .A;
if op_totalx > 1 then do;
if op_risk then op_reason = 1; *eigenes Risiko;
if op_risk = . and op_cap then op_reason = 2; *Kapazitäten;
if op_risk = . and op_cap = . then op_reason = 3; *sonstiges;
end;
if drug_totalx le 1 then drug_reason = .A;
if drug_totalx > 1 then do;
if drug_risk then drug_reason = 1; *eigenes Risiko;
if drug_risk = . and drug_cap then drug_reason = 2; *Kapazitäten;
if drug_risk = . and drug_cap = . then drug_reason = 3; *sonstiges;
end;
if radia_totalx le 1 then radia_reason = .A;
if radia_totalx > 1 then do;
if radia_risk then radia_reason = 1; *eigenes Risiko;
if radia_risk = . and radia_cap then radia_reason = 2; *Kapazitäten;
if radia_risk = . and radia_cap = . then radia_reason = 3; *sonstiges;
end;
format op_reason drug_reason radia_reason reason.;
run;



***********************************************************;
*** Sample description (Table 1/2)						***;
***********************************************************;

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

ods select none;
%macro crude(item);
proc freq data=crokus_MI order=internal;
tables &item &item*survivor/ norow chisq;
weight wmi;
ods output chisq = &item;
ods output crosstabfreqs = freq_&item;
format income_cat incomecatx. sex sex. op_totalx drug_totalx radia_totalx totalxyn.;
run;
data &item; set &item;
rename table = Variable;
run;
data freq_&item; set freq_&item;
rename table = Variable &item =level;
*level = &item;
run;
%mend;

%crude(agesurvey_cat);
%crude(sex);
%crude(marstat);
%crude(domestic);
%crude(educat);
%crude(jobstat);
%crude(jobstat_2020);
%crude(work_cat);
%crude(income_cat);
%crude(self_covid);
%crude(iso01rel);
%crude(iso02sh);
%crude(iso03phys);
%crude(iso04care);
%crude(iso05pub);
%crude(iso01relb);
%crude(iso02shb);
%crude(iso03physb);
%crude(iso04careb);
%crude(iso05pubb);

%crude(tumor);
%crude(uicc_cat);
%crude(cancer_phase);
%crude(att_end);
%crude(att_feel);
%crude(att_bur);
%crude(tx_change);
%crude(op_totalx);
%crude(drug_totalx);
%crude(radia_totalx);
%crude(treatment2);

ods select all;

data frequencies; *Summarize frequencies;
set freq_agesurvey_cat freq_sex freq_educat freq_marstat freq_domestic freq_jobstat freq_jobstat_2020
	freq_work_cat freq_income_cat freq_self_covid 
	freq_iso01rel freq_iso02sh freq_iso03phys freq_iso04care freq_iso05pub 
	freq_iso01relb freq_iso02shb freq_iso03physb freq_iso04careb freq_iso05pubb 
	freq_tumor freq_uicc_cat freq_cancer_phase freq_att_end freq_att_feel freq_att_bur 
	freq_tx_change freq_op_totalx freq_drug_totalx freq_radia_totalx freq_treatment2;
where _Type_ in ("10", "11");
drop _Table_;
format level;
run;

data chiquadrat; *Summarize p values;
set agesurvey_cat sex educat marstat domestic jobstat jobstat_2020
	work_cat income_cat self_covid 
	iso01rel iso02sh iso03phys iso04care iso05pub 
	iso01relb iso02shb iso03physb iso04careb iso05pubb 
	tumor uicc_cat cancer_phase att_end att_feel att_bur 
	tx_change op_totalx drug_totalx radia_totalx treatment2;
run;

title "Frequencies overall group";
proc tabulate data=frequencies;
where survivor = .;
class variable / missing order=data;
class level / missing order=unformatted;
var frequency percent;
table variable=''*level='', mean="Alle"*(F=5.0*frequency="N" F=4.1*percent="%");
run;

title "Frequencies patients vs. survivors";
proc tabulate data=frequencies;
where _Type_ = "11";
class variable survivor/ missing order=data;
class level / missing order=unformatted;
var frequency colpercent;
table variable=''*level='', survivor=""*mean=""*(F=5.0*frequency="N" F=4.1*colpercent="%");
run;

title "Results of Chi-square tests regarding differences between patients and survivors";
proc print data=chiquadrat;
id variable;
var prob;
where Statistic = "Chi-Quadrat";
format prob pvalue.;
run;

title;


***********************************************************;
*** Level-wise comparisons for overall significant diff	***;
***********************************************************;

title "Level-wise comparisons for overall significant differences";

ods select none; 

*Dummy-Variablen;
data crokus_MI2;
set crokus_MI;
mar_single = 0; if marstat = 1 then mar_single = 1;
mar_married = 0; if marstat = 2 then mar_married = 1;
mar_divorced = 0; if marstat = 3 then mar_divorced = 1;
mar_widowed = 0; if marstat = 4 then mar_widowed = 1;
phase_diag = 0; if cancer_phase = 1 then phase_diag = 1;
phase_prim = 0; if cancer_phase = 2 then phase_prim = 1;
phase_rem = 0; if cancer_phase = 3 then phase_rem = 1;
phase_fu = 0; if cancer_phase = 4 then phase_fu = 1;
phase_recur = 0; if cancer_phase = 5 then phase_recur = 1;
phase_pall = 0; if cancer_phase = 6 then phase_pall = 1;
burden1 = 0; if att_bur = 1 then burden1 = 1;
burden2 = 0; if att_bur = 2 then burden2 = 1;
burden3 = 0; if att_bur = 3 then burden3 = 1;
burden4 = 0; if att_bur = 4 then burden4 = 1;
run;

*Anwendung;
%macro crude(item);
proc freq data=crokus_MI2;
tables &item &item*survivor/ norow chisq;
weight wmi;
ods output chisq = &item;
ods output crosstabfreqs = freq_&item;
run;
data &item; set &item;
rename table = Variable;
run;
data freq_&item; set freq_&item;
rename table = Variable &item = level;
run;
%mend;
%crude(mar_single);
%crude(mar_married);
%crude(mar_divorced);
%crude(mar_widowed);
%crude(phase_diag);
%crude(phase_prim);
%crude(phase_rem);
%crude(phase_fu);
%crude(phase_recur);
%crude(phase_pall);
%crude(burden1);
%crude(burden2);
%crude(burden3);
%crude(burden4);

ods select all;

*Alle Ergebnistabellen zusammenfügen: Häufigkeiten;
data frequencies; 
set freq_mar_single freq_mar_married freq_mar_divorced freq_mar_widowed 
freq_phase_diag freq_phase_prim freq_phase_rem freq_phase_fu freq_phase_recur freq_phase_pall
 freq_burden1 freq_burden2 freq_burden3 freq_burden4;
where _Type_ in ("10", "11");
drop _Table_;
run;

*Alle Ergebnistabellen zusammenfügen: p-Werte;
data chiquadrat; 
set mar_single mar_married mar_divorced mar_widowed 
phase_diag phase_prim phase_rem phase_fu phase_recur phase_pall burden1 burden2 burden3 burden4;
run;

title2 "Frequencies patients vs. survivors";
proc tabulate data=frequencies;
where _Type_ = "11" and level = 1;
class variable level survivor/ missing order=data;
var frequency colpercent;
table variable='', survivor=""*mean=""*(F=5.0*frequency="N" F=4.1*colpercent="%");
run;

title2 "Results of Chi-square tests regarding differences between patients and survivors";
proc print data=chiquadrat;
id variable;
var prob;
where Statistic = "Chi-Quadrat";
format prob pvalue.;
run;
title;



***********************************************************;
*** Differences in HADS (Supp. Tables 2/3, Fig 1/2/3	***;
***********************************************************;

***************************************************************************************;
*** 1) Unadjusted, overall group and subgroups (no, unchanged, changed treatment)	***;
***************************************************************************************;

title "Subgroup sizes";
proc freq data=crokus_MI;
table treatment2;
weight wmi;
run;

title "Differences & Chi-Square-Tests";
ods select none;
%macro crude(scale, var);
proc freq data=crokus_MI;
table &scale; *overall;
table &scale*&var/ nopercent chisq; *stratified by subgroup;
weight wmi;
ods output	
	OneWayFreqs = pct_&scale
	CrossTabFreqs = freq_&scale
	chisq = &scale;
run;
data pct_&scale; set pct_&scale; rename table = Variable &scale = Event; run;
data freq_&scale; set freq_&scale; rename table = Variable &scale = Skala; run;
data &scale; set &scale; rename table = Variable; run;
%mend;

%crude(HADS_A_cutoff, treatment2);
%crude(HADS_A_cutoff11, treatment2);
%crude(HADS_D_cutoff, treatment2);
%crude(HADS_D_cutoff11, treatment2);

data pct; set pct_HADS_A_cutoff pct_HADS_A_cutoff11 pct_HADS_D_cutoff pct_HADS_D_cutoff11; run;
data freq; set freq_HADS_A_cutoff freq_HADS_A_cutoff11 freq_HADS_D_cutoff freq_HADS_D_cutoff11; run;
data sign; set HADS_A_cutoff HADS_A_cutoff11 HADS_D_cutoff HADS_D_cutoff11; run;

ods select all;

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


***************************************************************************************;
*** 2) Adjusted analysis and analysis of predictors for anxiety and depression		***;
***************************************************************************************;

*To select one of the following options:

	*Unadjusted LS-Means;
	*%let adjust = ;

	*Adjusted LS-Means;
	%let adjust = agesurvey sex educat tumor uicc_cat;

	*Further adjusted model / calculate Odds Ratios;
	*%let adjust = agesurvey tumorsex uicc_cat survivor cancer_phase self_covid bmi 
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
				contrasttest = contrast_&scale
				oddsratios = or_&scale;
	contrast "As planned vs. none" 		treatment2  1  0 -1/ estimate=parm;
	contrast "Changed vs. as planned" 	treatment2 -1  1  0/ estimate=parm;
	lsmeans treatment2 /diff cl adjust=bon ilink;
	by _imputation_;
run;
data pct_&scale; length Skala $50; set pct_&scale; Skala = "&scale"; run;
data contrast_&scale; length Skala $50; set contrast_&scale; Skala = "&scale"; run;
data or_&scale; length Skala $50; set or_&scale; Skala = "&scale"; run;
%mend;

%adj(HADS_A_cutoff);
%adj(HADS_A_cutoff11);
%adj(HADS_D_cutoff);
%adj(HADS_D_cutoff11);

ods select all;


data pct; set pct_HADS_A_cutoff pct_HADS_D_cutoff pct_HADS_A_cutoff11 pct_HADS_D_cutoff11; run;
data contrast; set contrast_HADS_A_cutoff contrast_HADS_D_cutoff contrast_HADS_A_cutoff11 contrast_HADS_D_cutoff11; run;
data odds; set or_HADS_A_cutoff or_HADS_D_cutoff /*or_HADS_A_cutoff11 or_HADS_D_cutoff11*/; run;

ods select all;

title "Prevalence";
proc tabulate data=pct;
class Skala treatment2/ order=unformatted;
var mu probz lowermu uppermu;
table treatment2="", Skala=""*mean=""*(mu=""*F=10.3);
run;

title "Confidence intervals";
proc tabulate data=pct;
class Skala treatment2/ order=unformatted;
var mu probz lowermu uppermu;
table treatment2="", Skala=""*mean=""*F=10.3*(lowermu mu uppermu);
run;

title "Contrasts";
proc tabulate data=contrast;
class Skala / order=unformatted;
class Contrast/ order=data;
var ProbChiSq;
table contrast="", Skala=""*mean=""*F=pvalue.*ProbChiSq="";
run;

title "Odds ratios";
proc tabulate data=odds;
class effect Skala /order=data;
var OddsRatioEst LowerCL UpperCL;
table Effect="", skala=""*mean=""*F=10.2*(OddsRatioEst LowerCL UpperCL);
run;
title;


***************************************************************************************;
*** Additional variables (reasons for change & decision-makers)						***;
*** (Supp. Table 3)																	***;
***************************************************************************************;

%macro changes(var);

title "Subgroup sizes";
proc freq data=crokus_MI;
table &var/ missing;
where treatment2 = 2 and &var not in (., .A); *only those with changed treatment;
weight wmi;
run;

ods select none;

title "Differences in Prevalence";
%macro crude(scale);
proc freq data=crokus_MI;
table &scale*&var/ chisq; *stratified by subgroups;
weight wmi;
where treatment2 = 2 and &var not in (., .A);
ods output	
	CrossTabFreqs = freq_&scale
	chisq = chisq_&scale;
run;
data freq_&scale; set freq_&scale; rename table = Variable &scale = Skala; run;
data chisq_&scale; set chisq_&scale; rename table = Variable; run;
%mend;

%crude(HADS_A_cutoff);
%crude(HADS_A_cutoff11);
%crude(HADS_D_cutoff);
%crude(HADS_D_cutoff11);

ods select all;

data freq; set freq_HADS_A_cutoff freq_HADS_A_cutoff11 freq_HADS_D_cutoff freq_HADS_D_cutoff11; run;
title "Prevalence of anxiety/ depression per changed domain";
proc tabulate data=freq;
class variable &var/ order=data missing;
var Percent;
table &var, Variable=""*mean=""*Percent="";
where Skala = 1 and _type_ = "10";
run;

title "Unadjusted differences in anxiety / depression according to subgroups";
proc tabulate data=freq;
class variable &var/ order=data;
var ColPercent;
table &var, Variable=""*mean=""*ColPercent="";
where Skala = 1 and _type_ = "11";
run;

data chisq; set chisq_HADS_A_cutoff chisq_HADS_A_cutoff11 chisq_HADS_D_cutoff chisq_HADS_D_cutoff11; run;
title "Chi square tests";
proc print data=chisq;
id variable;
var prob;
where Statistic = "Chi-Quadrat";
format prob pvalue.;
run;
title;

%mend;

%changes(op_reason);
%changes(drug_reason);
%changes(radia_reason);
%changes(dec_change);
