// Change in the land ownership across caste lines in rural India over a decade(2006-2014/15)//
// Data sources - RURAL ECONOMIC AND DEMOGRAPHIC SURVEY(REDS) 2006 & SOCIO-ECONOMIC PROFILES OF RURAL HOUSEHOLDS IN INDIA(SEPRI 1 & 2)//
// Survey was carried out in 13 Indian states.//

//Author: PARIJAT MAITRA //



* USING SEPRI 1 DATA

use "E:\Data\SEPRI\Sepri1\HH\SECTION01.dta", clear

* Household id can be broken up into the following individual components:
*(moving from right to left)
* Last 4 digits - household listing no. or id(unique for each hh)
* Next 3 digits - village code.
* Next 3 digits - district code.
* First 1 or 2 digits - state code.
* So depending on the state code - for example the state code for the state of Haryana is 7 while that for Jharkhand is 13,
* Therefore, unique household id(var q1_1 in the SEPRI data) is either an 11 or a 12 digit number.


* Browsing through the data, I could see that there are multiple data entry errors in var q1_1.
* So, I chose to recreate the household ids from scratch.

tostring state, ge(stateid)

* For the district code, we need to generate a three digit string(with leading zeroes if original district id is a 1 or a 2 digit no.)

gen str3  distid =  string( district , "%03.0f")
order distid, a( district)

* Similarly for the village code, we need to generate a three digit string.

gen str3  villid =  string( village , "%03.0f")
order villid, a( village)

* The household id is not separately provided. So we need to extract it from var q1_1.

gen hhid = mod( q1_1, 10000)
order hhid, a( q1_1)

* For the household id, we need to generate a four digit string(with possibly leading zeroes)

gen str4  hh =  string( hhid , "%04.0f")
order hh, a( q1_1)

gen id = stateid+ distid+ villid+ hh
order id, a( hh)
gen double id2 = real( id)
order id2, a(id)

* Variable id2 is the new household ID - it takes care of any data entry errors in the state, district or village part of the id.
* However,since we are obtaining the household id from the error riden var q1_1, there can be possible errors in that part of the id.
* We'll deal with this part soon. ** Check LINES 181 & 327**

assert q1_1 == id2

* Contradictions in the assertion confirm the presence of data entry errors in the state, district or village part of the id.

drop q1_1
ren id2 q1_1
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

* Variable q1_2 is the corresponding household ID in the REDS 2006 data.
* Ideally q1_2 should be an 11 or a 12 digit no.
* However, in certain cases the length of q1_2<11 & they only correspond to the state, district, village or a mixture of the three ids.
* Since in those cases we don't have the hh id(from 2006) we won't be able to match these households & we need to drop them.

tostring q1_2 , ge(hhidReds2006) format(%20.0f)

* We generate a string version of q1_2 & find its length.

gen len = length( hhidReds2006)
order len, a (hhidReds2006)

* We extract the hh id(2006) only in case q1_2 is an 11 or a 12 digit no.

gen hhidReds = mod(q1_2, 10000) if len == 11| len ==12
order hhidReds, a( len)

* Generating the four digit unique hh id(2006)

gen str4  hhReds =  string( hhidReds , "%04.0f")
order hhReds, a (hhidReds)

gen id2006 = stateid+ distid+ villid+ hhReds if hhReds != "."
order id2006, a( q1_2)
gen double idReds = real( id2006)
order idReds, a( id2006)

assert q1_2 == idReds

* Contradictions in the assertion confirm the presence of data entry errors.

drop q1_2
ren idReds q1_2
label var q1_2 "Unique hh ID, REDS 2006"

duplicates list q1_1
*No duplicates.

duplicates list q1_2
* There are duplicates - primarily of two types.
* Type 1 : Data entry errors in the hh id(2006) - we're going to drop them.
* Type 2 : There are multiple households in the 2014/15 listing which are linked to a single household in 2006.
* These are cases where the ownership has changed from father(in 2006) to sons (in 2014/15) , with the property being divided among/between them.
* These cases can be furher subdivided into two types:
* Type A - where the names(strings) match.
* Type B - where there are mismatches in the 2006 household heads' name, primarily extra/missing blanks, missing/extra characters etc.

* We will deal with this matching issue later. ** Refer to LINE 464 **

save "E:\Data\SEPRI\Sepri_network\sep1hh1.dta", replace

* Using the SEPRI 2 data.

use "E:\Data\SEPRI\Sepri2\HH\SECTION01.dta", clear

* Following the same steps as outlined above.

tostring state, ge(stateid)
gen str3  distid =  string( district , "%03.0f")
order distid, a( district)
gen str3  villid =  string( village , "%03.0f")
order villid, a( village)
gen hhid = mod( q1_1, 10000)
order hhid, a( q1_1)
gen str4  hh =  string( hhid , "%04.0f")
order hh, a( q1_1)
gen id = stateid+ distid+ villid+ hh
order id, a( hh)
gen double id2 = real( id)
order id2, a(id)

assert q1_1 == id2

drop q1_1
ren id2 q1_1
order q1_1, a(hhid)

tostring q1_2 , ge(hhidReds2006) format(%20.0f)
gen len = length( hhidReds2006)
order len, a (hhidReds2006)

gen hhidReds = mod(q1_2, 10000) if len == 11| len ==12
order hhidReds, a( len)
gen str4  hhReds =  string( hhidReds , "%04.0f")
order hhReds, a (hhidReds)

gen id2006 = stateid+ distid+ villid+ hhReds if hhReds != "."
order id2006, a( q1_2)
gen double idReds = real( id2006)
order idReds, a( id2006)

assert q1_2 == idReds

drop q1_2
ren idReds q1_2

label var q1_1 "Unique hh ID"
label var q1_2 "Unique hh ID, REDS 2006"

duplicates list q1_1
duplicates list q1_2

save "E:\Data\SEPRI\Sepri_network\sep2hh1.dta", replace

use "E:\Data\SEPRI\Sepri_network\sep1hh1.dta", replace

append using E:\Data\SEPRI\Sepri_network\sep2hh1.dta

* We have the full SEPRI data now.
* Replacing the missing values in variables related to land ownership to zero.

foreach k of var q1_10 q1_10a q1_10h{
replace `k' = 0 if `k'==.
}
      
* In the next step we'll deal with data entry errors in the hh id part of var q1_1 **Refer to LINE 55**

bys state district village: gen population = _N
bys state district village: gen issue = 1 if hhid>population
drop if issue ==1

* There were cases where the hhid was greater than the population of the village - again, possible data entry errors in the hh id part of q1_1
* These households have now been dropped.

* Total land owned by a household.

gen TotLandHolding = q1_10a+ q1_10h
* Variables q1_10a - irrigated land holdings, q1_10h - dry land holdings.

save "E:\Data\SEPRI\Sepri_network\sepfull.dta"




* The following variables scst & obc are used to specify whether a specific household belongs to the Scheduled Castes/Scheduled Tribes(SC/ST) or the Other Backward Castes(OBC) categories.

gen scst = 0
replace scst = 1 if q1_8 ==1 | q1_8 ==2

gen obc= 0
replace obc = 1 if q1_8 == 3

* Total no.of SCs/STs & OBCs in a village.

bys state district village: egen SCSTtot = total(scst)
bys state district village: egen OBCtot = total(obc)

* SC/ST & OBC proportion of the population in a village.

bys state district village: gen scstfrac = SCSTtot/ population
bys state district village: gen obcfrac = OBCtot/ population

* Whether a specific household owns land.

gen IsLandHolder=0
replace IsLandHolder=1 if TotLandHolding>0

* Land ownership characteristics.(village-wise)

* TotLandHolders - No. of land owners in each village.
* FracLandOwner - Proportion of the village population who owns land.
* SCSTmeanLandHold & OBCmeanLandHold - Mean land holdings(in acres) of SC/ST & OBC households in a village.
* scstLandOwners & obcLandOwners - Total no. of SC/ST & OBC households who own land, village-wise.
* scstLandOwnFrac & obcLandOwnFrac - Proportion of the SC/ST & OBC households who own land, village-wise.

bys state district village: egen TotLandHolders = total( IsLandHolder)
bys state district village: gen FracLandOwner = TotLandHolders/ population
bys state district village scst: egen SCSTmeanLandHold = mean( TotLandHolding)
bys state district village obc: egen OBCmeanLandHold = mean( TotLandHolding)
bys state district village: egen scstLandOwners  = total( scst ==1 & IsLandHolder ==1)
bys state district village: egen obcLandOwners = total( obc ==1 & IsLandHolder ==1)
bys state district village: gen scstLandOwnFrac = scstLandOwners /population
bys state district village: gen obcLandOwnFrac = obcLandOwners /population
gen scstmeanlandhold = SCSTmeanLandHold if scst ==1
gen obcmeanlandhold = OBCmeanLandHold if obc ==1
replace SCSTmeanLandHold = scstmeanlandhold
replace OBCmeanLandHold = obcmeanlandhold
replace SCSTmeanLandHold = 0 if SCSTmeanLandHold ==.
replace OBCmeanLandHold = 0 if OBCmeanLandHold ==.
drop obcmeanlandhold scstmeanlandhold


* We need to create a panel structure to compare these characteristics across time(2006 - 2014/15)

gen time = 2

collapse time obcLandOwnFrac scstLandOwnFrac OBCmeanLandHold SCSTmeanLandHold FracLandOwner obcfrac scstfrac, by( state stateid district distid village villid)
drop state district village
ren distid districtid
ren villid villageid

gen int state = real( stateid)

gen int district = real( districtid)

gen int village = real( villageid)

drop stateid districtid villageid

order state, first

order district, a( state)

sort state district village

* We now have the village-level characteristics for the SEPRI(2014-15) survey.

save "E:\Data\SEPRI\Sepri_network\seprivill.dta"

* Please note that since we're currently dealing with village level characteristics the potential matching issue(s) 
* mentioned in lines 105-113 shouldn't matter for the time being. 
* They shall be dealt with when we're dealing with the household-level portion of the comparison(s).

* Using REDS 2006 data.

use "E:\Data\REDS\Listing_2006\listing2006.dta", clear

* In the REDS data, the ids are fragmented into hh, village, district & state components. 
* We need to create an 11 or a 12 digit id to match with the SEPRI records.


gen id = stateid+ districtid+ villageid

*var q3 is the hhid - depending on the listing no. it ranges from a one digit to a three digit no. 
*We would like to generate a four digit string var for each hh(containing leading zeroes in case q3 is a 1, 2 or 3 digit no.)

gen str4  q3_1 =  string( q3 , "%04.0f")

gen id2= id + q3_1
gen double q1_2 = real( id2)
order q1_2, a( stateid)

* var q1_2  - REDS 2006 listing in the required format.

tab state

* REDS covers four additional states. We need to drop them.

drop if state =="PUNJAB" | state == "HIMACHAL PRADESH"| state == "KARNATAKA" | state == "KERALA"

foreach k of var q68 q72{
replace `k' = 0 if `k'==.
}

* Following the same steps as the SEPRI data, we generate the land ownership characteristics.

gen TotLandHolding = q68 + q72

save "E:\Data\SEPRI\Sepri_network\redsfinal.dta"

gen scst = 0
replace scst = 1 if q11==1 | q11 ==2
gen obc= 0
replace obc = 1 if q11 == 3
by state districtid villageid: egen population = max(q3)

* q3 is the household ID

bys state district village: gen issue = 1 if q3> population
tab issue, mi

* No. of cases where issue = 1 is zero - So, possibly no data entry errors. **Refer to LINE 55**

bys state district village: egen SCSTtot = total(scst)
bys state district village: egen OBCtot = total(obc)
bys state district village: gen scstfrac = SCSTtot/ population
bys state district village: gen obcfrac = OBCtot/ population
gen IsLandHolder=0
replace IsLandHolder=1 if TotLandHolding>0
bys state district village: egen TotLandHolders = total( IsLandHolder)
bys state district village: gen FracLandOwner = TotLandHolders/ population
bys state district village scst: egen SCSTmeanLandHold = mean( TotLandHolding)
bys state district village obc: egen OBCmeanLandHold = mean( TotLandHolding )
bys state district village: egen scstLandOwners  = total( scst ==1 & IsLandHolder ==1)
bys state district village: egen obcLandOwners = total( obc ==1 & IsLandHolder ==1)

bys state district village: gen scstLandOwnFrac = scstLandOwners /population
bys state district village: gen obcLandOwnFrac = obcLandOwners /population
gen scstmeanlandhold = SCSTmeanLandHold if scst ==1
gen obcmeanlandhold = OBCmeanLandHold if obc ==1
replace SCSTmeanLandHold = scstmeanlandhold
replace OBCmeanLandHold = obcmeanlandhold
replace SCSTmeanLandHold = 0 if SCSTmeanLandHold ==.
replace OBCmeanLandHold = 0 if OBCmeanLandHold ==.

gen time = 1

collapse scstfrac obcfrac FracLandOwner SCSTmeanLandHold OBCmeanLandHold scstLandOwnFrac obcLandOwnFrac time, by( state stateid district districtid village villageid)


drop village district state

gen int state = real( stateid)
gen int district = real( districtid)
gen int village = real( villageid)
drop stateid districtid villageid
order state, first
order district, a( state)
order village, a( district)

sort state district village

save "E:\Data\SEPRI\Sepri_network\redsvill.dta"

use "E:\Data\SEPRI\Sepri_network\seprivill.dta", clear

append using E:\Data\SEPRI\Sepri_network\redsvill.dta

sort state district village time

* We now have the data in panel format - REDS2006 time 1, SEPRI time 2.

* Variable village has gaps(discontinuous)so we'll use a continuous var villid in its place.

egen villid = group(village)
xtset villid time
save "E:\Data\SEPRI\Sepri_network\villagefinal.dta"

* Generating variables that capture the village-wise changes in the land ownership characteristics.

gen scstfrac_change = scstfrac - l1.scstfrac
gen obcfrac_change = obcfrac - l1.obcfrac
gen fraclandowner_change = FracLandOwner - l1.FracLandOwner
gen scstmeanlandhold_change = SCSTmeanLandHold - l1.SCSTmeanLandHold
gen obcmeanlandhold_change = OBCmeanLandHold - l1.OBCmeanLandHold
gen scstlandownfrac_change = scstLandOwnFrac - l1.scstLandOwnFrac
gen obclandownfrac_change  = obcLandOwnFrac - l1.obcLandOwnFrac

save "E:\Data\SEPRI\Sepri_network\villgraph.dta"

drop if time ==1

* Generating the plots of scstfrac_change, obcfrac_change, fraclandowner_change, scstmeanlandhold_change, obcmeanlandhold_change, scstlandownfrac_change & obclandownfrac_change, village - wise.

separate fraclandowner_change , by( fraclandowner_change >=0)
gen zero = 0
graph twoway rarea fraclandowner_change1 zero villid , color(blue*0.8) cmissing(no) || rarea fraclandowner_change0 zero villid , color(red*0.8) cmissing(no)
graph export "E:\Data\SEPRI\Composition\Graph1.png", as(png) replace

separate scstfrac_change , by( scstfrac_change >=0)
graph twoway rarea scstfrac_change1 zero villid , color(blue*0.8) cmissing(no) || rarea scstfrac_change0 zero villid , color(red*0.8) cmissing(no) nodraw
graph save Graph f:\2.gph

separate obcfrac_change , by( obcfrac_change >=0)
graph twoway rarea obcfrac_change1 zero villid , color(blue*0.8) cmissing(no) || rarea obcfrac_change0 zero villid , color(red*0.8) cmissing(no) nodraw
graph save Graph f:\3.gph

cd f:\
graph combine 2.gph 3.gph
graph export "E:\Data\SEPRI\Composition\Graph2.png", as(png) replace

separate scstmeanlandhold_change , by( scstmeanlandhold_change >=0)
graph twoway rarea scstmeanlandhold_change1 zero villid , color(blue*0.8) cmissing(no) || rarea scstmeanlandhold_change0 zero villid , color(red*0.8) cmissing(no) nodraw
graph save Graph f:\4.gph

separate obcmeanlandhold_change , by( obcmeanlandhold_change >=0)
graph twoway rarea obcmeanlandhold_change1 zero villid , color(blue*0.8) cmissing(no) || rarea obcmeanlandhold_change0 zero villid , color(red*0.8) cmissing(no) nodraw
graph save Graph f:\5.gph
graph combine 4.gph 5.gph
graph export "E:\Data\SEPRI\Composition\Graph3.png", as(png) replace

separate scstlandownfrac_change , by( scstlandownfrac_change >=0)
graph twoway rarea scstlandownfrac_change1 zero villid , color(blue*0.8) cmissing(no) || rarea scstlandownfrac_change0 zero villid , color(red*0.8) cmissing(no) nodraw
graph save Graph f:\6.gph

separate obclandownfrac_change , by( obclandownfrac_change >=0)
graph twoway rarea obclandownfrac_change1 zero villid , color(blue*0.8) cmissing(no) || rarea obclandownfrac_change0 zero villid , color(red*0.8) cmissing(no) nodraw
graph save Graph f:\7.gph
graph combine 6.gph 7.gph
graph export "E:\Data\SEPRI\Composition\Graph4.png", as(png) replace

clear

use "E:\Data\SEPRI\Sepri_network\villagefinal.dta", clear

* I used two-sample t-tests(with unequal variances) to check whether the changes in land ownership characteristics are statistically significant.

ttest scstfrac , by(time) unequal
ttest obcfrac , by(time) unequal
ttest FracLandOwner , by(time) unequal
ttest SCSTmeanLandHold , by(time) unequal
ttest OBCmeanLandHold , by(time) unequal
ttest scstLandOwnFrac , by(time) unequal
ttest obcLandOwnFrac , by(time) unequal

// Household level land-ownership.

use "E:\Data\SEPRI\Sepri_network\sepfull.dta", replace

* Variables q1_1 - hhid in 2014/15, q1_2 - hhid in 2006 (11/12 digit nos.)

drop if q1_2 ==.
sort q1_2

* There are certain households where q1_2 ends with 4 zeroes - possible data entry error - can't be matched with the REDS 06 data.
* Dropping them

drop if hhidReds == 0
* We shall now deal with the matching issue(s) mentioned in LINES 105-113. 
* We first need to find how many copies of each q1_2 exists.

bys state district village q1_2: gen copies  = _N
order copies, a( q1_2)
tab copies, mi

sort copies q1_2

* Variable head2006 - name of the household head in 2006.
* In cases where the ownership has passed from the father(in 2006) to sons(2014/15) with the property being subsequently divided among/between them,
* The variable head2006 should ideally be same for all the households in SEPRI data(var q1_1) linked to a REDS 2006 household(var q1_2) with multiple occurances.
* However there are issues in the names such as missing/ extra blanks, missing/extra characters etc.
* I use the following code which allows me to match some(not all) of these households.

*Removing all spaces in the name of the hh head 2006

gen head06 = subinstr(head2006, " ", "", .)

* For the next step, I use soundex code  - soundex codes consist of a letter followed by three numbers:
* The letter is the first letter of the name and the numbers encode the remaining consonants.
* Similar sounding consonants are encoded by the same number.
* This allows me to match names with missing/extra blanks, missing/wrong/extra characters in the surname, partial surnames etc.
* As long as there are mistakes in the surnames or in case of first names, there are mismatches involving similar sounding consonants etc, we get a match.
* This doesn't work if there are any mistakes in the first letter of the name or mismatches involving consonants that sound different.

gen soundex = soundex( head06)
order soundex, a( head06)
sort copies q1_2

* Variable diff finds whether soundex codes differ for each repeating q1_2(hh id 2006)

bys state district village q1_2: gen diff = 1 if soundex[1] != soundex[_n]
order diff, a(copies)
sort copies q1_2
replace diff = 0 if diff == .
bys state district village q1_2 : egen diffsum = total(diff)
order diffsum, a( diff)
drop if diffsum>0

drop  copies diff diffsum head06 soundex

*Now that the households are matched we will add up the total land holdings of those households which saw a change in ownership status & subsequent division.

bys state district village q1_2 : egen landhold = total(TotLandHolding)
drop  if q1_2 == q1_2[_n+1]

duplicates list q1_2
*No duplicates.


drop hh id q1_1 hhid population TotLandHolding hhidReds head2006 q1_4 state district village

ren landhold landhold2015
ren distid districtid
ren villid villageid

save "E:\Data\SEPRI\Sepri_network\sepindfinal.dta"

use "E:\Data\SEPRI\Sepri_network\redsfinal.dta", clear
keep villageid districtid stateid q1_2 TotLandHolding
ren TotLandHolding landhold2006

merge 1:1 q1_2 using E:\Data\SEPRI\Sepri_network\sepindfinal.dta
drop if _merge ==1 | _merge == 2
drop _merge

duplicates list q1_2 
tab landhold2015
tab landhold2006

* Removing outliers.

winsor2 landhold2006, cuts(1, 99.90)
winsor2 landhold2015, cuts(1, 99.90)
replace landhold2006 = landhold2006_w
replace landhold2015 = landhold2015_w

gen landhold_change = landhold2015 - landhold2006
drop landhold2006_w landhold2015_w
sum landhold_change, detail

*Plotting the change in land holdings for 67,861 matched households.

separate landhold_change , by( landhold_change >=0)
gen zero = 0
graph twoway rarea landhold_change1 zero id , color(blue*0.8) cmissing(no) || rarea landhold_change0 zero id , color(red*0.8) cmissing(no)

graph export "E:\Data\SEPRI\Composition\Graph5.png", as(png) replace

*The End!




















