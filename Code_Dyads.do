// Dyads - Caste to caste networks at the village level, REDS 2006//

// Author - Parijat Maitra

// Version  - 14//

set more off
use main_reds

* To create the network dyads(caste - caste in each village) I needed to reshape the data to create the row castes.
* However, due to the peculiar naming conventions unique to each Indian states, reshaping the data using the caste names proved to be a bit of a challenge.
* So instead of the caste names, I chose to use the unique caste codes.

keep village - villageid district - stateid q3 castecode q152 - q157 q168 - q170
drop if castecode== .

* Dropping duplicate castes - for the row castes we need to have a unique caste in each row.

bys castecode: drop if castecode == castecode[_n+1]

* Reshaping the data.

keep castecode
gen Num = _n
gen num = 1

save temp
reshape wide num, i(Num) j( castecode)
save temp, replace

* Keeping just a single column of data.
* var Num  - unique ID for joining with the master data(column castes)

drop if Num != 1
replace num1001 = .

* Post- reshape, the var names(row castes)are num*castecode
* Since STATA doesn't allow var names to be numeric or begin with a number, I named each caste var as c_castecode

renvars num1001 - num17394, presub(num c_)
save temp, replace

* Using the main REDS data

clear
use main_reds
keep village villageid district - stateid q3 castecode q152 - q157 q168 - q170
gen Num = 1
save dyad

* Joining the reshaped dataset(row castes) with the column castes.

joinby Num using temp
drop Num
save dyad, replace
tostring castecode, ge(caste)

* converting the castecodes to string & renaming them as c_castecode to maintain parity with the row castes.

 replace caste = "c"+"_"+caste
 drop castecode
 order q3, a( villageid)

 save dyad, replace
 
 * creating network characteristics for the caste vars 
 * q152, q153, q154(Hh IDs in order of preference  - borrow money)
 * q155, q156, q157(HH IDS in order of preference - borrow food)
 * q168, q169, q170(HH IDS in order of preference - preferred neighbour)
 
 drop q152 - q170
 drop district - stateid
 save temp, replace
 drop _all
 use temp
 rename q3 q152
 ren caste q152caste
 save tempx, replace
 use dyad
 merge m:1 villageid q152 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q153
 ren caste q153caste
 save tempx, replace
 use dyad
 merge m:1 villageid q153 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q154
 ren caste q154caste
 save tempx, replace
 use dyad
 merge m:1 villageid q154 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q155
 ren caste q155caste
 save tempx, replace
 use dyad
 merge m:1 villageid q155 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q156
 ren caste q156caste
 save tempx, replace
 use dyad
 merge m:1 villageid q156 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q157
 ren caste q157caste
 save tempx, replace
 use dyad
 merge m:1 villageid q157 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q168
 ren caste q168caste
 save tempx, replace
 use dyad
 merge m:1 villageid q168 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q169
 ren caste q169caste
 save tempx, replace
 use dyad
 merge m:1 villageid q169 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 drop _all
 use temp
 ren q3 q170
 ren caste q170caste
 save tempx, replace
 use dyad
 merge m:1 villageid q170 using tempx
 drop if _merge == 2
 drop _merge
 save dyad, replace
 
 * creating caste to caste village level network - when the row castes & column castes are same, it captures the within-caste links.
 
 foreach var1 of varlist q152 - q170{
 foreach var2 of varlist c_1001 - c_17394{
 replace `var2' = 1 if caste != "" & caste == `var1'caste & caste == "`var2'"
 }
 }
save dyad, replace

* generating the village level total within-caste links for each caste.

set maxvar 10000

sort stateid districtid villageid caste
foreach k of varlist c_1001 - c_17394{
bys stateid districtid villageid caste: egen `k'_1 = total(`k')
order `k'_1, b(`k')
drop `k'
}
* Collapsing the hh level data to village + caste level

collapse c_1001_1 - c_17394_1, by( stateid districtid villageid caste)
order stateid districtid, first
renvars c_1001_1 - c_17394_1, postdrop(2)

save dyad, replace

*The End!
