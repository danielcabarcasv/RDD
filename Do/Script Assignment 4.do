
clear all 
cap log close
set more off 
cd "/Users/danielcabarcas/Documents/GitHub/RDD/Do"
log using "RDD", replace

use "/Users/danielcabarcas/Documents/GitHub/RDD/Data/hansen_dwi.dta", clear

*3
gen D=0
replace D=1 if bac1>=0.08
label var D "DUI threshold"
label var white "White"
label var male "Male"
label var aged "Age"
label var acc "Accident"
label var bac1 "BAC"

*5
cd "/Users/danielcabarcas/Documents/GitHub/RDD/Tables"
preserve
drop if bac1>=0.15

reg male D
outreg2 using covariate_balance.doc, replace ctitle("Male") label
reg white D
outreg2 using covariate_balance.doc, append ctitle("White") label
reg aged D
outreg2 using covariate_balance.doc, append ctitle("Age") label
reg acc D
outreg2 using covariate_balance.doc, append ctitle("Accident") label

restore

*6
cd "/Users/danielcabarcas/Documents/GitHub/RDD/Figures"
//Accident
cmogram acc bac1, cut(0.08) scatter line(0.08) qfitci title("Accident Quadratic")
graph export cmogram_acc_qfit.png, as(png) replace
cmogram acc bac1, cut(0.08) scatter line(0.08) lfit title("Accident Linear")
graph export cmogram_acc_lfit.png, as(png) replace

//Male
cmogram male bac1, cut(0.08) scatter line(0.08) qfitci title("Male Quadratic")
graph export cmogram_male_qfit.png, as(png) replace
cmogram male bac1, cut(0.08) scatter line(0.08) lfit title("Male Linear")
graph export cmogram_male_lfit.png, as(png) replace

//Age
cmogram aged bac1, cut(0.08) scatter line(0.08) qfitci title("Age Quadratic")
graph export cmogram_age_qfit.png, as(png) replace
cmogram aged bac1, cut(0.08) scatter line(0.08) lfit title("Age Linear")
graph export cmogram_age_lfit.png, as(png) replace

//White
cmogram white bac1, cut(0.08) scatter line(0.08) qfitci title("White Quadratic")
graph export cmogram_white_qfit.png, as(png) replace
cmogram white bac1, cut(0.08) scatter line(0.08) lfit title("White Linear")
graph export cmogram_white_lfit.png, as(png) replace

*7
cd "/Users/danielcabarcas/Documents/GitHub/RDD/Tables"
gen bac1D = bac1*D
gen bac12 = bac1^2
gen bac12D  = bac12*D

//bandwidth 1
reg recidivism D bac1 male white aged acc if bac1>.03 & bac1<.13
outreg2 using rdestimates.doc, replace ctitle("Linear BAC") label
reg recidivism D bac1 bac1D male white aged acc if bac1>.03 & bac1<.13
outreg2 using rdestimates.doc, append ctitle("BAC*DUI") label
reg recidivism D bac1 bac12D male white aged acc if bac1>.03 & bac1<.13
outreg2 using rdestimates.doc, append ctitle("BAC*DUI2") label

//bandwidth 2
reg recidivism D bac1 male white aged acc if bac1>.055 & bac1<.105
outreg2 using rdestimates2.doc, replace ctitle("Linear BAC") label
reg recidivism D bac1 bac1D male white aged acc if bac1>.055 & bac1<.105
outreg2 using rdestimates2.doc, append ctitle("BAC*DUI") label
reg recidivism D bac1 bac12D male white aged acc if bac1>.055 & bac1<.105
outreg2 using rdestimates2.doc, append ctitle("BAC*DUI2") label
*8
cd "/Users/danielcabarcas/Documents/GitHub/RDD/Figures"
cmogram recidivism bac1 if bac1<0.15, cut(0.08) scatter line(0.08) qfitci title("BAC and Recidivism (Quadratic Fit)")
graph export cmogram_bac1recidivism_qfit.png, as(png) replace
cmogram recidivism bac1 if bac1<0.15, cut(0.08) scatter line(0.08) lfit title("BAC and Recidivism (Linear Fit)")
graph export cmogram_bac1recidivism_lfit.png, as(png) replace

log close


