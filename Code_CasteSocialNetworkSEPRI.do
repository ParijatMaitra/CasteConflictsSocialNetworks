// Caste & Social Networks //

// Data sources - RURAL ECONOMIC AND DEMOGRAPHIC SURVEY(REDS) 2006 & SOCIO-ECONOMIC PROFILES OF RURAL HOUSEHOLDS IN INDIA(SEPRI 1 & 2)//
// Survey was carried out in 13 Indian states.//


// Author: PARIJAT MAITRA //


* Stage 1  - Cleaning & merging the relevant portions of SEPRI 1 & 2 datasets.

* USING SEPRI 1 DATA

* Household roster.

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
* We'll deal with that issue later. **See line 464**

assert q1_1 == id2

* Contradictions in the assertion confirm the presence of data entry errors in the state, district or village part of the id.

drop q1_1
ren id2 q1_1
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

save "E:\Data\SEPRI\SepriNetwork\hh1.dta"

* Using SEPRI 1 household income details dataset.

use "E:\Data\SEPRI\Sepri1\HH\SECTION04.dta", clear

* Folowing the same procedure as above, I created the household IDs.

* I created the hh IDs for each relevant sections of the datasets instead of merging them first & then creating the IDs because,
* the data-entry errors were different in each sections so using the latter method would possibly lead to matching issues.

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)
save "E:\Data\SEPRI\SepriNetwork\hh4.dta"

* Using SEPRI 1 migration dataset.

use "E:\Data\SEPRI\Sepri1\HH\SECTION14.dta", clear

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

* generating the no. of migrants in each household.
* for each hh, we've the individual IDs of the members who have migrated.

sort q1_1
bys state district village q1_1: gen NoOfMigrants = _N
drop q14_1 q14_2

* we need the no. of migrants per hh, so dropping duplicates.

drop if q1_1 == q1_1[_n+1]
duplicates list q1_1

save "E:\Data\SEPRI\SepriNetwork\hh14.dta"

* Merging the SEPRI 1 household level datasets.

use "E:\Data\SEPRI\SepriNetwork\hh1.dta", clear
duplicates list q1_1

merge 1:1 q1_1 using E:\Data\SEPRI\SepriNetwork\hh4.dta
drop _merge
merge 1:1 q1_1 using E:\Data\SEPRI\SepriNetwork\hh14.dta
drop _merge

save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace

* Using SEPRI 1 individual(member) level data

use "E:\Data\SEPRI\Sepri1\HH\SECTION07.dta", clear
keep state - q7_1 q7_16 q7_24 q7_26 q7_28 q7_31 q7_34 q7_37
save "E:\Data\SEPRI\SepriNetwork\hh7.dta"

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

sort q1_1

* Creating a dummy variable IsWorking, which's 1 for employed members & 0 for the unemployed ones.

gen IsWorking =  1 if q7_24 ==1 | q7_26 ==1 | q7_28 ==1 | q7_31 == 1| q7_34 == 1| q7_37 == 1
replace IsWorking = 0 if IsWorking ==.

* generating the household size(no. of members) of each hh.

bys state district village q1_1: gen hhsize = _N
sort q1_1 q7_1
save "E:\Data\SEPRI\SepriNetwork\hh7.dta", replace

* Merging with the hh level dataset.

merge 1:m q1_1 using E:\Data\SEPRI\SepriNetwork\hh7.dta
order q7_1, a(q1_1)
sort q1_1 q7_1

* var q7_1 - one or two digit member ID. Household Head's ID is always 1.

order NoOfMigrants, a(q7_37)
drop _merge

*Generating the total no. of employed members in the household.

bys state district village q1_1: egen TotEarners = total( IsWorking)
save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace

* generating Unique ID for each individual.
* it's a 13 or 14 digit no.(depending on the HH ID).
* ID = HH ID + member ID.
* Member ID is a one or two digit no.
* Since the member ID comes at the end we need to generate a two digit string for it(with leading zeroes in case it's a single digit ID)

gen str2  IndID =  string( q7_1 , "%02.0f")
order IndID, a( q7_1)
gen uid = id + IndID
order uid, a( IndID)
destring uid, ge(ID)
format ID %14.0f
duplicates list ID
sort ID
drop if ID == ID[_n+1]
duplicates list ID

browse if TotEarners> hhsize

* We have a potential data entry error in the following hh

replace hhsize = 5 if hhid == 377 & villid =="105"
replace TotEarners = 4 if hhid == 377 & villid =="105"

* generating dependency ratio for each household.

gen DependencyRatio = hhsize/ TotEarners
save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace


* Using the network dataset. Only hh members above the age of 18 were interviewed.

use "E:\Data\SEPRI\Sepri1\HH\SECTION10.dta", clear

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)
sort q1_1
save "E:\Data\SEPRI\SepriNetwork\hh10.dta"



* For a given HH ID, var q10_1 is the unique member ID of the respondent who responds to the following question:
* In a time of crisis, choose 4 neighbours(in order of preference) from whom the respondent is likely to borrow money.
* var q10_3, q10_6, q10_9 & q10_12 - IDs of the neighbours from whom the respondent is likely to borrow money.

* For a given HH ID, var q10_14 is the unique member ID of the respondent who responds to the following question:
* In a time of crisis, choose 4 neighbours(in order of preference) from whom the respondent is likely to borrow food.
* var q10_16, q10_19, q10_22 & q10_25 - IDs of the neighbours from whom the respondent is likely to borrow food.

* For a given HH ID, var q10_27 is the unique member ID of the respondent who responds to the following question:
* Choose 4 neighbours(in order of preference) to whom the respondent is likely to ask for advice related to agriculture, financial matters etc.
* var q10_29, q10_32, q10_35 & q10_38  - IDs of the neighbours.

* Since for each household, for a given HH Id(i.e. for a particular row) we've the network data for multiple members.
* For example, the money based question is usually answered by the head of the hh or other male members,
* while the food based question is usually answered by the women of the hh.

* We need to split the data into three parts - for three questions,
* create the network data for each individual members(there are cases where one member responds to all the three questions) for each questions
* with blanks representing non- response & then merge them.

drop q10_2 q10_5 q10_8 q10_11 q10_14 q10_15 q10_16 q10_17 q10_18 q10_19 q10_20 q10_21 q10_22 q10_23 ///
q10_24 q10_25 q10_25 q10_26 q10_27 q10_28 q10_29 q10_30 q10_31 q10_32 q10_33 q10_34 q10_35 q10_36 q10_37 q10_38 q10_39

tab q10_1, mi
drop if q10_1>11
gen str2  IndID =  string( q10_1 , "%02.0f")
order IndID, a( q10_1 )
gen uid = id + IndID
order uid, a( IndID)
destring uid, ge(ID)
format ID %14.0f

* For the network variables(the IDs of the preferred neighbours) we'll follow the same method as before so as to ensure that there are no data-entry errors.

foreach k of var q10_3 q10_6 q10_9 q10_12{
gen hhsocnet`k'  = mod(`k', 10000)
order hhsocnet`k', a(`k')
gen str4 hhscnt`k' = string(hhsocnet`k', "%04.0f")
order hhscnt`k' , a(`k')
}
*The loop creates a 4 digit household ID(With leading zeroes in case the hh id is not a four digit no.) for all the network variables in question 1(Borrow Money).

foreach k of var q10_4 q10_7 q10_10 q10_13{
gen str2 scntID`k' = string(`k', "%02.0f")
order scntID`k', a(`k')
}
* The loop creates a 2 digit member ID( with leading zeroes in case the mem Id is not a two digit no.) for all the network variables in question 1(Borrow Money).

ren scntIDq10_4 scntIDq10_3
ren scntIDq10_7 scntIDq10_6
ren scntIDq10_10 scntIDq10_9
ren scntIDq10_13 scntIDq10_12

drop q10_4 q10_7 q10_7 q10_10 q10_13
drop hhsocnetq10_3 hhsocnetq10_6 hhsocnetq10_9 hhsocnetq10_12

foreach k of var q10_3 q10_6 q10_9 q10_12{
gen id1`k' = hhscnt`k' + scntID`k'
gen l`k' = length(id1`k')
replace id1`k' = "." if l`k'<6
gen id`k' = stateid+ distid+ villid+ id1`k' if id1`k' != "."
order id`k', a(`k')
destring id`k', ge(ID`k')
format ID`k' %14.0f
}

* This loop creates a six digit ID - HH ID + memID at the start.
* if the length of the ID is less than 6 due to missing values in HH ID or mem ID, I set it to missing.
* Then I created a thirteen or a fourteen digit Unique ID using state, district & village IDs.
* The Unique ID was only created for members whose id1`k' was not missing.

drop q10_3 idq10_3 l2 l2 hhscntq10_3 scntIDq10_3 q10_6 q10_6 idq10_6 hhscntq10_6 scntIDq10_6 q10_9 idq10_9 hhscntq10_9 scntIDq10_9 q10_12 ///
idq10_12 hhscntq10_12 scntIDq10_12 id1q10_3 lq10_3 id1q10_6 lq10_6 id1q10_9 lq10_9 id1q10_12 lq10_12 hh id hhid q10_1 IndID uid

duplicates report ID

save "E:\Data\SEPRI\SepriNetwork\hh10mod1.dta"

use "E:\Data\SEPRI\SepriNetwork\hh10.dta", clear

* Repeating the same process for questions 2(Boorow food) & 3 (advice).

drop q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q10_13 ///
q10_27 q10_28 q10_29 q10_30 q10_31 q10_32 q10_33 q10_34 q10_35 q10_36 q10_37 q10_38 q10_39 q10_15 q10_18 q10_21 q10_24

tab q10_14, mi
drop  if q10_14>11
gen str2  IndID =  string( q10_14 , "%02.0f")
order IndID, a( q10_14)
gen uid = id + IndID
order uid, a( IndID)
destring uid, ge(ID)
format ID %14.0f

foreach k of var q10_16 q10_19 q10_22 q10_25{
gen hhsocnet`k'  = mod(`k', 10000)
gen str4 hhscnt`k' = string(hhsocnet`k', "%04.0f")
order hhscnt`k' , a(`k')
}           
* Loop ends here.
foreach k of var q10_17 q10_20 q10_23 q10_26{
gen str2 scntID`k' = string(`k', "%02.0f")
order scntID`k', a(`k')
}
ren scntIDq10_17 scntIDq10_16
ren scntIDq10_20 scntIDq10_19
ren scntIDq10_23 scntIDq10_22
ren scntIDq10_26 scntIDq10_25

drop q10_17 q10_20 q10_23 q10_26
drop hhsocnetq10_16 hhsocnetq10_16 hhsocnetq10_19 hhsocnetq10_22 hhsocnetq10_25

foreach k of var q10_16 q10_19 q10_22 q10_25{
gen id1`k' = hhscnt`k' + scntID`k'
gen l`k' = length(id1`k')
replace id1`k' = "." if l`k'<6
gen id`k' = stateid+ distid+ villid+ id1`k' if id1`k' != "."
order id`k', a(`k')
destring id`k', ge(ID`k')
format ID`k' %14.0f
}

drop q10_16 idq10_16 l2 hhscntq10_16 scntIDq10_16 q10_19 idq10_19 hhscntq10_19 scntIDq10_19 q10_22 ///
idq10_22 hhscntq10_22 scntIDq10_22 q10_25 idq10_25 hhscntq10_25 scntIDq10_25 id1q10_16 lq10_16 id1q10_19 /// 
lq10_19 lq10_22 id1q10_25 lq10_25 id1q10_22 hh id hhid q10_1 IndID uid

sort ID
duplicates report ID
drop if ID == ID[_n+1]
duplicates list ID
save "E:\Data\SEPRI\SepriNetwork\hh10mod2.dta"

use "E:\Data\SEPRI\SepriNetwork\hh10.dta", clear

drop q1_1 q1_1 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q10_13 q10_14 q10_15 q10_16 q10_17 q10_18 ///
 q10_19 q10_20 q10_21 q10_22 q10_23 q10_24 q10_25 q10_26 q10_26 q10_28 q10_28 q10_31 q10_34 q10_37
 
 tab q10_27, mi
 drop  if q10_27>11
 gen str2  IndID =  string( q10_27 , "%02.0f")
 order IndID, a( q10_27 )
 gen uid = id + IndID
 order uid, a( IndID)
 destring uid, ge(ID)
 format ID %14.0f
 
 foreach k of var q10_29 q10_32 q10_35 q10_38{
 gen hhsocnet`k'  = mod(`k', 10000)
 gen str4 hhscnt`k' = string(hhsocnet`k', "%04.0f")
 order hhscnt`k' , a(`k')
 }
*Loop ends here.

foreach k of var q10_30 q10_33 q10_36 q10_39{
gen str2 scntID`k' = string(`k', "%02.0f")
order scntID`k', a(`k')
}

ren scntIDq10_30 scntIDq10_29
ren scntIDq10_33 scntIDq10_32
ren scntIDq10_36 scntIDq10_35
ren scntIDq10_39 scntIDq10_38

drop q10_30 q10_30 q10_33 q10_36 q10_36 q10_39 hhsocnetq10_29 hhsocnetq10_32 hhsocnetq10_32 hhsocnetq10_35 hhsocnetq10_35 hhsocnetq10_38

foreach k of var q10_29 q10_32 q10_35 q10_38{
gen id1`k' = hhscnt`k' + scntID`k'
gen l`k' = length(id1`k')
replace id1`k' = "." if l`k'<6
gen id`k' = stateid+ distid+ villid+ id1`k' if id1`k' != "."
order id`k', a(`k')
destring id`k', ge(ID`k')
format ID`k' %14.0f
}

drop q10_27 q10_29 idq10_29 hhscntq10_29 scntIDq10_29 q10_32 idq10_32 hhscntq10_32 scntIDq10_32 q10_35 idq10_35 hhscntq10_35 ///
scntIDq10_35 q10_38 idq10_38 hhscntq10_38 scntIDq10_38 id1q10_29 lq10_29 id1q10_32 lq10_32 id1q10_35 lq10_35 id1q10_38 l2 ///
lq10_38 hh id hhid IndID uid 

duplicates report ID
sort ID
drop if ID == ID[_n+1]
duplicates report ID

save "E:\Data\SEPRI\SepriNetwork\hh10mod3.dta"

* Merging the three datasets.

use "E:\Data\SEPRI\SepriNetwork\hh10mod1.dta", clear
merge 1:1 ID using E:\Data\SEPRI\SepriNetwork\hh10mod2.dta
drop _merge
merge 1:1 ID using E:\Data\SEPRI\SepriNetwork\hh10mod3.dta
drop _merge

save "E:\Data\SEPRI\SepriNetwork\hhmerged.dta"

*Merging with the master dataset.

use "E:\Data\SEPRI\SepriNetwork\hh1.dta", clear
drop hh id q1_1 q7_1 IndID uid
bys state district district village: gen population  = _N
bys state state district district village: drop if hhid> population
* This takes care of any data entry issues in the HH ID part of var q1_1 **See line 60.**


merge 1:1 ID using E:\Data\SEPRI\SepriNetwork\hhmerged.dta
drop if _merge == 2 | _merge == 1
* Since only members who are adults(age 18+) were surveyed for the network relations, I dropped the rest.
drop _merge
drop hhid q1_4 q1_4 q1_4a q1_5 taluk block panchayat q1_1
duplicates report ID

bys state district village: gen AdultPopulation  = _N
order AdultPopulation, a( population)

save "E:\Data\SEPRI\SepriNetwork\sep1.dta"



* USING SEPRI 2 DATA - we need to follow the exact same steps as outlined above for (SEPRI 1)

* Using SEPRI 2 Household roster.

use "E:\Data\SEPRI\Sepri2\HH\SECTION01.dta", clear

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace

* Using SEPRI 2 household income details dataset.

use "E:\Data\SEPRI\Sepri2\HH\SECTION04.dta", clear

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)
save "E:\Data\SEPRI\SepriNetwork\hh4.dta", replace

* Using SEPRI 2 migration dataset.

use "E:\Data\SEPRI\Sepri2\HH\SECTION14.dta", clear

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

sort q1_1
bys state district village q1_1: gen NoOfMigrants = _N
drop q14_1 q14_2

drop if q1_1 == q1_1[_n+1]
duplicates list q1_1

save "E:\Data\SEPRI\SepriNetwork\hh14.dta", replace

* Merging the SEPRI 2 household level datasets.

use "E:\Data\SEPRI\SepriNetwork\hh1.dta", clear
duplicates list q1_1

merge 1:1 q1_1 using E:\Data\SEPRI\SepriNetwork\hh4.dta
drop _merge
merge 1:1 q1_1 using E:\Data\SEPRI\SepriNetwork\hh14.dta
drop _merge

save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace

* Using SEPRI 2 individual(member) level data

use "E:\Data\SEPRI\Sepri2\HH\SECTION07.dta", clear
keep state - q7_1 q7_16 q7_24 q7_26 q7_28 q7_31 q7_34 q7_37
save "E:\Data\SEPRI\SepriNetwork\hh7.dta", replace

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)

sort q1_1

gen IsWorking =  1 if q7_24 ==1 | q7_26 ==1 | q7_28 ==1 | q7_31 == 1| q7_34 == 1| q7_37 == 1
replace IsWorking = 0 if IsWorking ==.

bys state district village q1_1: gen hhsize = _N
sort q1_1 q7_1
save "E:\Data\SEPRI\SepriNetwork\hh7.dta", replace

merge 1:m q1_1 using E:\Data\SEPRI\SepriNetwork\hh7.dta
order q7_1, a(q1_1)
sort q1_1 q7_1

order NoOfMigrants, a(q7_37)
drop _merge

bys state district village q1_1: egen TotEarners = total( IsWorking)
save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace

gen str2  IndID =  string( q7_1 , "%02.0f")
order IndID, a( q7_1)
gen uid = id + IndID
order uid, a( IndID)
destring uid, ge(ID)
format ID %14.0f
duplicates list ID
sort ID
drop if ID == ID[_n+1]
duplicates list ID

browse if TotEarners> hhsize


gen DependencyRatio = hhsize/ TotEarners
save "E:\Data\SEPRI\SepriNetwork\hh1.dta", replace

* Using SEPRI 2 member level dataset.

use "E:\Data\SEPRI\Sepri2\HH\SECTION10.dta", clear

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
label var q1_1 "Unique hh ID"
order q1_1, a(hhid)
sort q1_1
save "E:\Data\SEPRI\SepriNetwork\hh10.dta", replace

drop q10_2 q10_5 q10_8 q10_11 q10_14 q10_15 q10_16 q10_17 q10_18 q10_19 q10_20 q10_21 q10_22 q10_23 ///
q10_24 q10_25 q10_25 q10_26 q10_27 q10_28 q10_29 q10_30 q10_31 q10_32 q10_33 q10_34 q10_35 q10_36 q10_37 q10_38 q10_39

tab q10_1, mi
drop if q10_1>11
gen str2  IndID =  string( q10_1 , "%02.0f")
order IndID, a( q10_1 )
gen uid = id + IndID
order uid, a( IndID)
destring uid, ge(ID)
format ID %14.0f


foreach k of var q10_3 q10_6 q10_9 q10_12{
gen hhsocnet`k'  = mod(`k', 10000)
order hhsocnet`k', a(`k')
gen str4 hhscnt`k' = string(hhsocnet`k', "%04.0f")
order hhscnt`k' , a(`k')
}
*The loop ends here

foreach k of var q10_4 q10_7 q10_10 q10_13{
gen str2 scntID`k' = string(`k', "%02.0f")
order scntID`k', a(`k')
}
* The loop ends here.

ren scntIDq10_4 scntIDq10_3
ren scntIDq10_7 scntIDq10_6
ren scntIDq10_10 scntIDq10_9
ren scntIDq10_13 scntIDq10_12

drop q10_4 q10_7 q10_7 q10_10 q10_13
drop hhsocnetq10_3 hhsocnetq10_6 hhsocnetq10_9 hhsocnetq10_12

foreach k of var q10_3 q10_6 q10_9 q10_12{
gen id1`k' = hhscnt`k' + scntID`k'
gen l`k' = length(id1`k')
replace id1`k' = "." if l`k'<6
gen id`k' = stateid+ distid+ villid+ id1`k' if id1`k' != "."
order id`k', a(`k')
destring id`k', ge(ID`k')
format ID`k' %14.0f
}

* The loop ends here.

drop q10_3 idq10_3 l2 l2 hhscntq10_3 scntIDq10_3 q10_6 q10_6 idq10_6 hhscntq10_6 scntIDq10_6 q10_9 idq10_9 hhscntq10_9 scntIDq10_9 q10_12 ///
idq10_12 hhscntq10_12 scntIDq10_12 id1q10_3 lq10_3 id1q10_6 lq10_6 id1q10_9 lq10_9 id1q10_12 lq10_12 hh id hhid q10_1 IndID uid

duplicates report ID

save "E:\Data\SEPRI\SepriNetwork\hh10mod1.dta", replace

use "E:\Data\SEPRI\SepriNetwork\hh10.dta", clear

drop q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q10_13 ///
q10_27 q10_28 q10_29 q10_30 q10_31 q10_32 q10_33 q10_34 q10_35 q10_36 q10_37 q10_38 q10_39 q10_15 q10_18 q10_21 q10_24

tab q10_14, mi
drop  if q10_14>11
gen str2  IndID =  string( q10_14 , "%02.0f")
order IndID, a( q10_14)
gen uid = id + IndID
order uid, a( IndID)
destring uid, ge(ID)
format ID %14.0f

foreach k of var q10_16 q10_19 q10_22 q10_25{
gen hhsocnet`k'  = mod(`k', 10000)
gen str4 hhscnt`k' = string(hhsocnet`k', "%04.0f")
order hhscnt`k' , a(`k')
}           
* Loop ends here.
foreach k of var q10_17 q10_20 q10_23 q10_26{
gen str2 scntID`k' = string(`k', "%02.0f")
order scntID`k', a(`k')
}
ren scntIDq10_17 scntIDq10_16
ren scntIDq10_20 scntIDq10_19
ren scntIDq10_23 scntIDq10_22
ren scntIDq10_26 scntIDq10_25

drop q10_17 q10_20 q10_23 q10_26
drop hhsocnetq10_16 hhsocnetq10_16 hhsocnetq10_19 hhsocnetq10_22 hhsocnetq10_25

foreach k of var q10_16 q10_19 q10_22 q10_25{
gen id1`k' = hhscnt`k' + scntID`k'
gen l`k' = length(id1`k')
replace id1`k' = "." if l`k'<6
gen id`k' = stateid+ distid+ villid+ id1`k' if id1`k' != "."
order id`k', a(`k')
destring id`k', ge(ID`k')
format ID`k' %14.0f
}

drop q10_16 idq10_16 l2 hhscntq10_16 scntIDq10_16 q10_19 idq10_19 hhscntq10_19 scntIDq10_19 q10_22 ///
idq10_22 hhscntq10_22 scntIDq10_22 q10_25 idq10_25 hhscntq10_25 scntIDq10_25 id1q10_16 lq10_16 id1q10_19 /// 
lq10_19 lq10_22 id1q10_25 lq10_25 id1q10_22 hh id hhid q10_1 IndID uid

sort ID
duplicates report ID
drop if ID == ID[_n+1]
duplicates list ID
save "E:\Data\SEPRI\SepriNetwork\hh10mod2.dta", replace

use "E:\Data\SEPRI\SepriNetwork\hh10.dta", clear

drop q1_1 q1_1 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q10_13 q10_14 q10_15 q10_16 q10_17 q10_18 ///
 q10_19 q10_20 q10_21 q10_22 q10_23 q10_24 q10_25 q10_26 q10_26 q10_28 q10_28 q10_31 q10_34 q10_37
 
 tab q10_27, mi
 drop  if q10_27>11
 gen str2  IndID =  string( q10_27 , "%02.0f")
 order IndID, a( q10_27 )
 gen uid = id + IndID
 order uid, a( IndID)
 destring uid, ge(ID)
 format ID %14.0f
 
 foreach k of var q10_29 q10_32 q10_35 q10_38{
 gen hhsocnet`k'  = mod(`k', 10000)
 gen str4 hhscnt`k' = string(hhsocnet`k', "%04.0f")
 order hhscnt`k' , a(`k')
 }
*Loop ends here.

foreach k of var q10_30 q10_33 q10_36 q10_39{
gen str2 scntID`k' = string(`k', "%02.0f")
order scntID`k', a(`k')
}

ren scntIDq10_30 scntIDq10_29
ren scntIDq10_33 scntIDq10_32
ren scntIDq10_36 scntIDq10_35
ren scntIDq10_39 scntIDq10_38

drop q10_30 q10_30 q10_33 q10_36 q10_36 q10_39 hhsocnetq10_29 hhsocnetq10_32 hhsocnetq10_32 hhsocnetq10_35 hhsocnetq10_35 hhsocnetq10_38

foreach k of var q10_29 q10_32 q10_35 q10_38{
gen id1`k' = hhscnt`k' + scntID`k'
gen l`k' = length(id1`k')
replace id1`k' = "." if l`k'<6
gen id`k' = stateid+ distid+ villid+ id1`k' if id1`k' != "."
order id`k', a(`k')
destring id`k', ge(ID`k')
format ID`k' %14.0f
}

drop q10_27 q10_29 idq10_29 hhscntq10_29 scntIDq10_29 q10_32 idq10_32 hhscntq10_32 scntIDq10_32 q10_35 idq10_35 hhscntq10_35 ///
scntIDq10_35 q10_38 idq10_38 hhscntq10_38 scntIDq10_38 id1q10_29 lq10_29 id1q10_32 lq10_32 id1q10_35 lq10_35 id1q10_38 l2 ///
lq10_38 hh id hhid IndID uid 

duplicates report ID
sort ID
drop if ID == ID[_n+1]
duplicates report ID

save "E:\Data\SEPRI\SepriNetwork\hh10mod3.dta", replace

use "E:\Data\SEPRI\SepriNetwork\hh10mod1.dta", clear
merge 1:1 ID using E:\Data\SEPRI\SepriNetwork\hh10mod2.dta
drop _merge
merge 1:1 ID using E:\Data\SEPRI\SepriNetwork\hh10mod3.dta
drop _merge

save "E:\Data\SEPRI\SepriNetwork\hhmerged.dta", replace


use "E:\Data\SEPRI\SepriNetwork\hh1.dta", clear
drop hh id q1_1 q7_1 IndID uid
bys state district district village: gen population  = _N
bys state state district district village: drop if hhid> population



merge 1:1 ID using E:\Data\SEPRI\SepriNetwork\hhmerged.dta
drop if _merge == 2 | _merge == 1
drop _merge
drop hhid q1_4 q1_4 q1_4a q1_5 taluk block panchayat q1_1
duplicates report ID

bys state district village: gen AdultPopulation  = _N
order AdultPopulation, a( population)

save "E:\Data\SEPRI\SepriNetwork\sep2.dta"

* Appending the SEPRI 2 dataset to the SEPRI 1 dataset

use "E:\Data\SEPRI\SepriNetwork\sep1.dta", clear
append using E:\Data\SEPRI\SepriNetwork\sep2.dta

duplicates report ID

save "E:\Data\SEPRI\SepriNetwork\Sepri.dta"

* The full SEPRI dataset

* generating household ID
gen double HHID = floor(ID/100)
order HHID, b(ID)

foreach k of var q1_10 q1_10a q1_10g1 q1_10g2 q1_10g3 q1_10h q1_10n2 q1_10n1 q1_10n3 q1_17_1 q1_17_2 q1_17_3 q1_23m3 q1_23m6 ///
q1_23f3 q1_23f6 q4_11 q4_12 q4_13 q4_21 q4_22 q4_31 q4_41a q4_41b q4_42 q4_43a q4_43b q4_44 q4_45a q4_45b q4_51 q4_52 q4_53{

replace `k' = 0 if `k'==.

}
* Replacing missing values in the income/earnings' variables with zeroes.

* Generating total income & total farm income for each household.

gen TotHHIncome = q1_10g1+ q1_10g2+ q1_10g3+ q1_10n1+ q1_10n2+ q1_10n3+ q4_11+ q4_12+ q4_21+ q4_31+ q4_42+ q4_44+ q4_51+ q4_52+ q4_53
gen TotHHFarmIncome = q1_10g1+ q1_10g2+ q1_10g3+ q1_10n1+ q1_10n2+ q1_10n3+ q4_11+ q4_12
gen TotHHNetIncome  = TotHHIncome - ( q1_17_1+ q1_17_2+ q1_17_3+ q1_23m3+ q1_23m6+ q1_23f3+ q1_23f6+ q4_13+ q4_22)
gen TotHHFarmNetIncome  = TotHHFarmIncome - ( q1_17_1+ q1_17_2+ q1_17_3+ q4_13)

* Generating education categories (all adult members)
tab q7_16
gen EducationCat = .
replace EducationCat = 1 if q7_16>=1 & q7_16<=5
replace EducationCat = 2 if q7_16>=6 & q7_16<=10
replace EducationCat = 3 if q7_16>=11 & q7_16<=12
replace EducationCat = 4 if q7_16>=13 & q7_16<=15
replace EducationCat = 0 if q7_16>=16
* var q7_16 - Highest class completed
* Grade 1 -12, Graduation, Post-Graduation, Professional, Illiterate & Literate but no formal education.


* Generating primary occupation categories (hh head)

gen PrimOccuCat=6
gen PrimOccuCatNCO=0

replace PrimOccuCat = 0 if q1_6a ==1111 | q1_6a ==1112 | q1_6a ==1114 | q1_6a==1115 | q1_6a ==1116 | q1_6a ==1117
replace PrimOccuCat = 1 if q1_6a ==630 | q1_6a ==650
replace PrimOccuCat = 2 if q1_6a ==611
replace PrimOccuCat = 3 if q1_6a ==610 | q1_6a ==620
replace PrimOccuCat = 4 if q1_6a >=600 & q1_6a <=699 & q1_6a !=630 & q1_6a !=650 & q1_6a !=611 & q1_6a !=610 & q1_6a !=620
replace PrimOccuCat = 5 if q1_6a >=0 & q1_6a <=399
replace PrimOccuCat = 5 if q1_6a >=500 & q1_6a <=599
replace PrimOccuCat = 5 if q1_6a ==1113 | q1_6a ==1118
replace PrimOccuCat = 5 if q1_6a >=700 & q1_6a <=999
replace PrimOccuCat = 5 if q1_6a >=1101 & q1_6a <=1103

replace PrimOccuCatNCO = 1 if q1_6a >=0 & q1_6a <=199 
replace PrimOccuCatNCO = 2 if q1_6a >=200 & q1_6a <=299
replace PrimOccuCatNCO = 3 if q1_6a >=300 & q1_6a <=399
replace PrimOccuCatNCO = 4 if q1_6a >=400 & q1_6a <=499
replace PrimOccuCatNCO = 5 if q1_6a >=500 & q1_6a <=599
replace PrimOccuCatNCO = 5 if q1_6a ==1113
replace PrimOccuCatNCO = 6 if q1_6a >=600 & q1_6a <=699
replace PrimOccuCatNCO = 7 if q1_6a >=700 & q1_6a <=999 
replace PrimOccuCatNCO = 7 if q1_6a ==1118 
replace PrimOccuCatNCO = 8 if q1_6a >=1101 & q1_6a <=1103
replace PrimOccuCatNCO = 9 if q1_6a >=1001 & q1_6a <=1010
replace PrimOccuCatNCO = 9 if q1_6a ==1099 | q1_6a ==1119
replace PrimOccuCatNCO = 10 if q1_6a ==1111 | q1_6a ==1112 | q1_6a ==1114 | q1_6a ==1115 | q1_6a ==1116 | q1_6a ==1117

* Index for PrimOccuCat

* 0 = Unemployed
* 1 = Landless labourers
* 2 = Landless cultivators
* 3 = Landholder cultivators
* 4 = Self-employed
* 5 = Salaried employed
* 6 = Uncategorised occupation

* var PrimOccuCatNCO is based on the occupation categorisation as per the National Classification of Occupations(NCO)-2004.

* NCO 1968-2004 Index(for PrimOccuCatNCO)

* 1 = Professional, technical and related workers
* 2 = Administrative, executive and managerial workers
* 3 = Clerical and related workers
* 4 = Sales workers
* 5 = Service workers
* 6 = Farmers, fishermen, hunters, loggers and related workers
* 7 = Production and related workers, transport equipment operators and labourers
* 8 = Armed Forces
* 9 = Uncategorised occupation
* 10 = Unemployed  

* generating total & agricultural land holding( by household) categories - based on John Miller, 1960 categories.

bigtab q1_10, mi
ren q1_10 TotAgriLandHold
ren q1_10a TotIrriLandHold

gen TotLandholdCat=0
replace TotLandholdCat=1 if TotAgriLandHold >0 & TotAgriLandHold <=2
replace TotLandholdCat=2 if TotAgriLandHold >2 & TotAgriLandHold <=4
replace TotLandholdCat=3 if TotAgriLandHold >4 & TotAgriLandHold <=10
replace TotLandholdCat=4 if TotAgriLandHold >10

gen IrrigLandholdCat=0
replace IrrigLandholdCat=1 if TotIrriLandHold >0 & TotIrriLandHold <=2
replace IrrigLandholdCat=2 if TotIrriLandHold >2 & TotIrriLandHold <=4
replace IrrigLandholdCat=3 if TotIrriLandHold >4 & TotIrriLandHold <=10
replace IrrigLandholdCat=4 if TotIrriLandHold >10


* generating a dummy var IsLandHolder where 1 refers to landowners while 0 represents the landless(household level)

gen IsLandHolder=0
replace IsLandHolder=1 if TotAgriLandHold >0

* generating income categories(by households)

egen TotIncomeCat = cut( TotHHIncome ), group(4)

ren q1_6a PrimeOcc
ren q7_16 SchoolYrs
ren q1_7 caste

save "E:\Data\SEPRI\SepriNetwork\SepriNet.dta"

* vars scst & obc are caste variables  - whether a specific household belongs to the Scheduled Castes/Scheduled Tribes(SC/ST) or Other Backward Castes(OBC).

gen scst = 0
replace scst = 1 if q1_8 ==1 | q1_8 ==2
gen obc = 0
replace obc = 1 if q1_8 == 3

* Since only the adult members have been surveyed, we can't sum over their IDs to get the total no. of SCs/STs or OBCs in a given village.
* However we do have the household size for each individual households.

bys state district village HHID: gen scstHHPop = hhsize*scst
bys state district village HHID: gen obcHHPop = hhsize*obc

* Since vars scst or obc are dummy vars(1 or 0), multiplying them with the hhsize gives the total no. of SCs/STs or OBCs in a given household.
* However, since for a given hh with multiple adult members we've the same value of scstHHPop/obcHHPop, adding them up would lead to multiple counting.
* So I created two vars SCSTHHPop & OBCHHPop that would capture the corresponding values of vars scstHHPop & obcHHPop only for the first member of the hh.

sort state district village HHID ID

gen SCSTHHPop = .
gen OBCHHPop = .
bys state district village HHID: replace SCSTHHPop = scstHHPop if _n == 1
bys state district village HHID:  replace OBCHHPop = obcHHPop if _n == 1
replace SCSTHHPop = 0 if SCSTHHPop == .
replace OBCHHPop = 0  if OBCHHPop == .

* Generating total no. of SCs/STs & OBCs in the village

bys state district village: egen scstVillPop = total( SCSTHHPop)
bys state district village: egen obcVillPop = total( OBCHHPop)
drop scstHHPop SCSTHHPop obcHHPop OBCHHPop

* Removing bad network data - ensuring that there are no repetitions in the network links.

gen x1 = .
replace x1 = 1 if IDq10_3 != . & IDq10_3 == IDq10_6
replace x1 = 1 if IDq10_3 != . & IDq10_3 == IDq10_9
replace x1 = 1 if IDq10_3 != . & IDq10_3 == IDq10_12
replace x1 = 1 if IDq10_6 != . & IDq10_6 == IDq10_9
replace x1 = 1 if IDq10_6 != . & IDq10_6 == IDq10_12
replace x1 = 1 if IDq10_9 != . & IDq10_9 == IDq10_12

gen y1 = .
replace y1 = 1 if IDq10_16 != . & IDq10_16 == IDq10_19
replace y1 = 1 if IDq10_16 != . & IDq10_16 == IDq10_22
replace y1 = 1 if IDq10_16 != . & IDq10_16 == IDq10_25
replace y1 = 1 if IDq10_19 != . & IDq10_19 == IDq10_22
replace y1 = 1 if IDq10_19 != . & IDq10_19 == IDq10_25
replace y1 = 1 if IDq10_22 != . & IDq10_22 == IDq10_25

gen z1 = .
replace z1 = 1 if IDq10_29 != . & IDq10_29 == IDq10_32
replace z1 = 1 if IDq10_29 != . & IDq10_29 == IDq10_35
replace z1 = 1 if IDq10_29 != . & IDq10_29 == IDq10_38
replace z1 = 1 if IDq10_32 != . & IDq10_32 == IDq10_35
replace z1 = 1 if IDq10_32 != . & IDq10_32 == IDq10_38
replace z1 = 1 if IDq10_35 != . & IDq10_35 == IDq10_38



foreach v of varlist x1 y1 z1{
sort villid `v'
by villid `v': egen `v'_vill = total(`v')
gen  `v'frac_vill = `v'_vill/population
}
* Eliminating entire villages if 15% or more households have bad data on network links.
* Removing any hh with bad data on network links.

drop if x1frac_vill > .15 | y1frac_vill > .15 | z1frac_vill > .15
drop if x1 == 1 | y1 == 1 | z1 == 1
drop x1* y1* z1*

cd E:\Data\SEPRI\SepriNetwork
save main

* In the SEPRI datasets there are far too many data entry errors in the caste section. And since caste is a string var & there are no numeric vars casteid(unlike the REDS data)to link them,
* Same castes, albeit with slightly different spellings(due to data entry errors) would be treated as separate & that is likely to have a serious impact on our results.
* Hence I chose to use the caste data from the REDS survey(by matching the HHIDs).

* Using the REDS 2006 survey.

use "E:\Data\REDS\Listing_2006\listing2006.dta", clear

* We'll need to create HHID using the same procedure outlined above.

gen id = stateid+ districtid+ villageid
gen str4  q3_1 =  string( q3 , "%04.0f")
gen id2= id + q3_1
order id2, a(caste)
gen double q1_2 = real( id2)
order q1_2, a(id2)
sort q1_2
keep q1_2 caste
ren q1_2 HHID
save reds

duplicates report HHID
sort HHID
drop if HHID == HHID[_n+1]
duplicates report HHID
save reds, replace

use main
drop caste

* Merging the two datasets.

merge m:1 HHID using reds
order caste, a( ID)
drop if _merge == 1 | _merge == 2
drop _merge
save main, replace
duplicates report ID

* STAGE 2: Creating Social Networks.

drop if TotHHIncome == 0

* Since our analyis is at the village level we can actually use a six digit ID (HHID + MemID).

gen id = mod( ID, 1000000)
order id, a(ID)
format HHID %14.0f

sort state district village id

* For all the network vars IDq10_3, IDq10_6, IDq10_9, IDq10_12, IDq10_16, IDq10_19, IDq10_22, IDq10_25, IDq10_29, IDq10_32, IDq10_35 & IDq10_38,
* generating the six digit IDs.


gen id103 = mod( IDq10_3, 1000000)
gen id106 = mod( IDq10_6, 1000000)
gen id109 = mod( IDq10_9, 1000000)
gen id1012 = mod( IDq10_12, 1000000)
gen id1016 = mod( IDq10_16, 1000000)
gen id1019 = mod( IDq10_19, 1000000)
gen id1022 = mod( IDq10_22, 1000000)
gen id1025 = mod( IDq10_25, 1000000)
gen id1029 = mod( IDq10_29, 1000000)
gen id1032 = mod( IDq10_32, 1000000)
gen id1035 = mod( IDq10_35, 1000000)
gen id1038 = mod( IDq10_38, 1000000)

save main, replace

* Creating Link Characteristics for each network variable.

keep villid id caste q1_8
save temp, replace

drop _all
use temp
ren id id103
foreach var of varlist caste q1_8{
rename `var'  id103`var'
}
save tempx, replace
use main
merge m:1 villid id103 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id106
foreach var of varlist caste q1_8{
rename `var'  id106`var'
}
save tempx, replace
use main
merge m:1 villid id106 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id109
foreach var of varlist caste q1_8{
rename `var'  id109`var'
}
save tempx, replace
use main
merge m:1 villid id109 using tempx
drop  if _merge == 2
drop _merge
save main, replace

use temp
ren id id1012
foreach var of varlist caste q1_8{
rename `var'  id1012`var'
}
save tempx, replace
use main
merge m:1 villid id1012 using tempx
drop if _merge ==2
drop _merge
save main, replace

use temp
ren id id1016
foreach var of varlist caste q1_8{
rename `var'  id1016`var'
}
save tempx, replace
use main
merge m:1 villid id1016 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id1019
foreach var of varlist caste q1_8{
rename `var'  id1019`var'
}
save tempx, replace
use main
merge m:1 villid id1019 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id1022
foreach var of varlist caste q1_8{
rename `var'  id1022`var'
}
save tempx, replace
use main
merge m:1 villid id1022 using tempx
drop  if _merge ==2
drop _merge
save main, replace

use temp
ren id id1025
foreach var of varlist caste q1_8{
rename `var'  id1025`var'
}
save tempx, replace
use main
merge m:1 villid id1025 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id1029
foreach var of varlist caste q1_8{
rename `var'  id1029`var'
}
save tempx, replace
use main
merge m:1 villid id1029 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id1032
foreach var of varlist caste q1_8{
rename `var'  id1032`var'
}
save tempx, replace
use main
merge m:1 villid id1032 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id1035
foreach var of varlist caste q1_8{
rename `var'  id1035`var'
}
save tempx, replace
use main
merge m:1 villid id1035 using tempx
drop if _merge == 2
drop _merge
save main, replace

use temp
ren id id1038
foreach var of varlist caste q1_8{
rename `var'  id1038`var'
}
save tempx, replace
use main
merge m:1 villid id1038 using tempx
drop if _merge ==2
drop _merge
save main, replace

* Generating variables capturing the presence or absence of links.

foreach var of varlist id103 - id1038{
gen IsLink`var' = 1 if `var' != .
replace IsLink`var' = 0 if `var' == .
gen IsLinkCaste`var' = 1 if `var' != . & caste == `var'caste
replace IsLinkCaste`var' = 0 if `var' != . & caste != `var'caste
replace IsLinkCaste`var' = 0 if `var' == .
}
*Generating variables capturing total links for each individual by type (money, food or preferred adviser)

gen LinksBorrowMon = IsLinkid103+ IsLinkid106+ IsLinkid109+ IsLinkid1012
gen LinksBorrowFood = IsLinkid1016+ IsLinkid1019+ IsLinkid1022+ IsLinkid1025
gen LinksAdvice= IsLinkid1029+ IsLinkid1032+ IsLinkid1035+ IsLinkid1038

* Generating variables capturing total links for each individual formed within the same caste.

gen LinksBorrowMonCaste = IsLinkCasteid103+ IsLinkCasteid106+ IsLinkCasteid109+ IsLinkCasteid1012
gen LinksBorrowFoodCaste = IsLinkCasteid1016+ IsLinkCasteid1019+ IsLinkCasteid1022+ IsLinkCasteid1025
gen LinksAdviceCaste = IsLinkCasteid1029+ IsLinkCasteid1032+ IsLinkCasteid1035+ IsLinkCasteid1038

save main, replace

* Generating in-degress & out-degrees for each link question(type, caste etc.)

foreach var of varlist id103 - id1038{
sort villid `var'
by villid `var': gen indeg`var' = _N
replace indeg`var' = . if `var' == .
gen xcaste = `var' if IsLinkCaste`var' == 1
sort villid xcaste
by villid xcaste: gen indegcaste`var' = _N
replace indegcaste`var' = . if xcaste == .
keep villid `var' indeg`var' indegcaste`var'
rename `var' id
sort villid id
quietly by villid id:  gen dup = cond(_N==1,0,_n)
drop if dup>1
save tempindeg, replace
use main
merge 1:1 villid id using tempindeg
drop if _merge==2
drop _merge
save main, replace
}
foreach var of varlist id103- id1038{
replace indeg`var' = 0 if indeg`var' == .
replace indegcaste`var' = 0 if indegcaste`var' == .
}
gen InDegMon = indegid103+ indegid106+ indegid109+ indegid1012
gen InDegFood = indegid1016+ indegid1019+ indegid1025+ indegid1022
gen InDegAdvice = indegid1029+ indegid1032+ indegid1035+ indegid1038
gen InDegCasteMon = indegcasteid103+ indegcasteid106+ indegcasteid109+ indegcasteid1012
gen InDegCasteFood  = indegcasteid1016+ indegcasteid1019+ indegcasteid1022+ indegcasteid1025
gen IndegCasteAdvice = indegcasteid1029+ indegcasteid1032+ indegcasteid1035+ indegcasteid1038

save main, replace

gen DegFood = InDegFood+ LinksBorrowFood
gen DegMon = InDegMon + LinksBorrowMon
gen DegAdvice= InDegAdvice+ LinksAdvice

* Generating Village & Caste level characteristics.

format HHID %12.0f


* Since the SEPRI data is set at the individual level(unlike the REDS) with certain specific characteristics which are only available at the household level,
* we need to ensure that for an individual household the household specific variables are counted for the first member or the household head so as to prevent multiple counting.
* As such, for each of these hh level variables I created an alternate var that would take the value(of that var) for the first member only.
* Note - for a specific hh, all members have the same value for the household level variables.

* household size(hh level)

sort state district village HHID id
gen hsize = .
order hsize, a( hhsize)
bys state district village HHID: replace hsize = hhsize if _n == 1
replace hsize = 0 if hsize == .

* var castepop - members of a specific caste in a village.

bys state district village caste : egen castepop = total( hsize)
order scstVillPop, a( population)
order obcVillPop, a(scstVillPop)
order castepop, a(population)
sort state district village HHID id

* var castepopfrac - population share for each individual's castes.

bys state district village: gen castepopfrac = castepop/ population
order castepopfrac, a( castepop)
sort state district village HHID id

* fractionalization by caste.
* Formula: fractionalization =  1 - Sum of [(proportion of each caste)^2]
* if there is a single caste then fractionalization is 0, the number is rather high when many small groups are present.

gen frac = .
order frac, a( castepopfrac)
bys state district village caste: replace frac = castepopfrac if _n ==1
replace frac = 0  if frac == .
replace frac = frac^2
bys state district village: egen fractionalization_c = total( frac)
order fractionalization_c, a(frac)
replace fractionalization_c = 1- fractionalization_c

* Avg. age of the household head (by village & by caste + village)
* Note - Members with ID(var MemID) =  1 are hh heads.

gen MemID = mod(ID,100)
gen HHead =0
replace HHead = 1 if MemID == 1
order HHead, a( hsize)
sort state district village HHID id
gen HHeadAge = .
order HHeadAge, a( Age)
replace HHeadAge = Age if HHead == 1
bys state district village: egen avgHHHage = mean( HHeadAge)
order avgHHHage, a( HHeadAge)
bys state district village caste: egen casteavgage = mean( HHeadAge)
order casteavgage, a( avgHHHage)
sort state district village HHID id

* Proportion of male household head(by village & by caste + village)

bys state district village: egen malehead = total(Gender == 1 & HHead == 1)
bys state district village caste: egen castemalehead = total(Gender == 1 & HHead==1)
sort state district village HHID id
gen HH = .
order HH, a(HHID)
replace HH = 1 if hsize != 0
bys state district village: egen hhpopulation = total(HH)
order hhpopulation, a(population)
bys state district village: gen propmalehead = malehead/hhpopulation
bys state district village caste: egen hhcastepopulation = total(HH)
order hhcastepopulation, a(hhpopulation)
bys state district village caste: gen castepropmalehead = castemalehead/hhcastepopulation

* vars hhpopulation & hhcastepopulation captures the total no. of hh in the village & total no. of hh by caste + village  respectively.

* Mean hh size (by village & by village + caste)

sort state district village HHID id
gen HHsize = .
order HHsize, a(hsize)
bys state district village HHID: replace HHsize = hsize if _n == 1
bys state district village: egen meanhhsize = mean( HHsize)
order meanhhsize, a( HHsize)
bys state district village caste:  egen castemeanhhsize = mean(HHsize)
order castemeanhhsize, a(meanhhsize)

* Mean Dependency Ratio(by village & by village + caste)

sort state district village HHID id
gen DepRatio = .
order DepRatio, a( DependencyRatio)
bys state district village HHID: replace DepRatio = DependencyRatio if _n == 1
bys state district village: egen meandepratio = mean( DepRatio)
bys state district village caste:egen castemeandepratio = mean( DepRatio)

* Modal value of Primary occupation categories (by village & by village + caste)
* Since in certain cases there were multiple modes & unless specified(whether one is looking for the maxmode or minmode), STATA generates missing values,
* So I chose to go with both for each category


sort state district village HHID id
gen PriOcc = .
order PriOcc,a( PrimeOcc)
bys state district village HHID: replace PriOcc = PrimeOcc if _n ==1
bys state district village: egen modeoccup1 = mode( PriOcc), maxmode
bys state district village: egen modeoccup2 = mode( PriOcc), minmode
bys state district village caste: egen castemodeoccup1 = mode( PriOcc), maxmode
bys state district village caste: egen castemodeoccup2 = mode( PriOcc), minmode


* Proportion of migrants(by village & by village + caste)

sort state district village HHID id
gen migrants = .
order migrants, a( NoOfMigrants)
bys state district village HHID: replace migrants = NoOfMigrants if _n == 1
bys state district village: egen Migrants = total( migrants)
bys state district village: gen propmigrant = Migrants/ population
bys state district village caste: egen castemigrants = total( migrants)
bys state district village caste: gen castepropmigrant = castemigrants/castepop

* Total Household income percentiles(by village & by village + caste)

sort state district village HHID id
gen tothhinc = .
order tothhinc, a( TotHHIncome)
bys state district village HHID: replace tothhinc = TotHHIncome if _n==1
bys state district village: egen TotIncome90 = pctile( tothhinc ), p(90)
bys state district village: egen TotIncome75 = pctile( tothhinc ), p(75)
bys state district village: egen TotIncome50 = pctile( tothhinc ), p(50)
bys state district village: egen TotIncome25 = pctile( tothhinc ), p(25)
bys state district village: egen TotIncome10 = pctile( tothhinc ), p(10)
bys state district village: egen TotIncomeMean = mean( tothhinc)
bys state district village: egen TotIncomeSD = sd( tothhinc )

bys state district village caste: egen casteTotIncome90 = pctile( tothhinc ), p(90)
bys state district village caste: egen casteTotIncome75 = pctile( tothhinc ), p(75)
bys state district village caste: egen casteTotIncome50 = pctile( tothhinc ), p(50)
bys state district village caste: egen casteTotIncome25 = pctile( tothhinc ), p(25)
bys state district village caste: egen casteTotIncome10 = pctile( tothhinc ), p(10)
bys state district village caste: egen casteTotIncomeMean = mean( tothhinc )
bys state district village caste: egen casteTotIncomeSD = sd( tothhinc )

*Education(School yrs.) percentiles - this var is at the member level(by village & by village + caste)

sort state district village HHID id
tab SchoolYrs, nolabel
gen schoolyrs = .
order schoolyrs, a( SchoolYrs)
replace schoolyrs = SchoolYrs
replace schoolyrs = 0  if  SchoolYrs == 16 | SchoolYrs == 17 | SchoolYrs == 18
replace schoolyrs = 15 if SchoolYrs == 13
replace schoolyrs = 17 if SchoolYrs == 14
bys state district village: egen edu75 = pctile( schoolyrs ), p(75)
bys state district village: egen edu25 = pctile( schoolyrs ), p(25)
bys state district village: egen eduMean = mean( schoolyrs)
bys state district village caste: egen casteedu75 = pctile( schoolyrs ), p(75)
bys state district village caste: egen casteedu25 = pctile( schoolyrs ), p(25)
bys state district village caste: egen casteeduMean = mean( schoolyrs )

* Total land holding & total irrigated land holding - Mean (by village & by village + caste)

sort state district village HHID id
gen TotLandHolding = .
order TotLandHolding, a( TotAgriLandHold)
bys state district village HHID: replace TotLandHolding = TotAgriLandHold if _n ==1
bys state district village: egen TotLandMean = mean(TotLandHolding)
bys state district village caste: egen casteTotLandMean = mean(TotLandHolding)

sort state district village HHID id
gen IrrigLand = .
order IrrigLand, a( TotIrriLandHold)
bys state district village HHID: replace IrrigLand = TotIrriLandHold if _n == 1
bys state district village: egen TotIrriLandMean = mean(IrrigLand)
bys state district village caste: egen casteTotIrriLandMean = mean(IrrigLand)

*Total land-holders proportion (by village & by village + caste)

sort state district village HHID id
gen islandholder = .
order islandholder, a( IsLandHolder)
bys state district village HHID: replace islandholder  = IsLandHolder if _n == 1
bys state district village: egen TotLandHoldersHH = total( islandholder )
bys state district village: gen TotLandHoldersProp = TotLandHoldersHH/hhpopulation
bys state district village caste: egen casteTotLandHoldersHH = total( islandholder )
bys state district village caste: gen casteTotLandHoldersProp = casteTotLandHoldersHH/hhcastepopulation
sort state district village HHID id

save main, replace

* Total no. of links by type( money, food & preferred adviser) 

bys state district village:egen TotLinksFood = total(LinksBorrowFood)
bys state district village: egen TotLinksMon = total(LinksBorrowMon)
bys state district village: egen TotLinksAdvice = total( LinksAdvice)

*  Total no.of links made by a caste - within itself or outside - by type( money, food & preferred adviser) 

bys state district village caste: egen casteOutLinksFood = total(LinksBorrowFood)
bys state district village caste: egen casteOutLinksMon = total(LinksBorrowMon)
bys state district village caste: egen casteOutLinksAdvice = total( LinksAdvice)

*individual links received from other caste.

sort state district village HHID id
gen InDegOutcasteMon = InDegMon - InDegCasteMon
gen InDegOutcasteFood = InDegFood - InDegCasteFood
gen InDegOutcasteAdvice  = InDegAdvice  - IndegCasteAdvice

* total no. of links received by a caste from other castes.

bys state district village caste:  egen casteInLinksFood = total(InDegOutcasteFood)
bys state district village caste:  egen casteInLinksMon = total(InDegOutcasteMon)
bys state district village caste:  egen casteInLinksAdvice = total(InDegOutcasteAdvice)

* total caste links = links made by caste members + links received from other castes.

sort state district village HHID id
gen casteLinksFood = casteOutLinksFood + casteInLinksFood
gen casteLinksMon = casteOutLinksMon + casteInLinksMon
gen casteLinksAdvice = casteOutLinksAdvice + casteInLinksAdvice

* total no. of links by type within the same caste(food , money or preferred adviser)

by state district village: egen TotLinksFoodCaste = total(LinksBorrowFoodCaste)
by state district village: egen TotLinksMonCaste = total(LinksBorrowMonCaste)
by state district village: egen TotLinksAdviceCaste = total(LinksAdviceCaste)
bys state district village caste: egen casteTotLinksFoodCaste = total(LinksBorrowFoodCaste)
bys state district village caste: egen casteTotLinksMonCaste = total(LinksBorrowMonCaste)
bys state district village caste: egen casteTotLinksAdviceCaste = total(LinksAdviceCaste)

* maximum in-degrees in the village.

sort state district village HHID id
bys state district village: egen MaxInLinksMon = max(InDegMon)
bys state district village: egen MaxInLinksFood = max(InDegFood)
bys state district village: egen MaxInLinksAdvice = max(InDegAdvice)
bys state district village caste: egen casteMaxInLinksMon = max(InDegMon)
bys state district village caste: egen casteMaxInLinksFood = max(InDegFood)
bys state district village caste: egen casteMaxInLinksAdvice = max(InDegAdvice)

sort state district village HHID id
save main, replace

* incomegini by village and caste -  IF INCOME IS ZERO, it is not included in the calculation.

gen villagegini = .
gen villagecastegini = .
sort village caste
levels village, local(levels1)
foreach v of local levels1 {
qui ineqdeco tothhinc if village == `v'
replace villagegini = $S_gini if village == `v'
qui levels caste if village == `v', local(levels2)
foreach c of local levels2 {
qui ineqdeco tothhinc if village == `v' & caste == "`c'"
replace villagecastegini = $S_gini if village == `v' & caste == "`c'"
}
}
save main, replace

sort state district village HHID id

* network gini by village - IF total links are ZERO, it is not included in the calculation.
* At first we need to check whether there's any particular village where the value of any of the network vars. DegFood, DegMon or DegAdvice is zero for all the inhabitants.

bys state district village: egen SumDegFood = total(DegFood)
bys state district village: egen SumDegMon = total(DegMon)
bys state district village: egen SumDegAdvice = total(DegAdvice)
tab village if SumDegFood == 0, nolabel
tab village if SumDegMon == 0, nolabel
tab village if SumDegAdvice == 0, nolabel
save main, replace

* Turns out that in case of villages 184, 226, 227, 234, 241 & 242 the value for network var DegAdvice is zero for all the members.
* If these villages are included in the loop to generate the network gini it would encounter an error at the first instance & would cease operation.
* However, since the values of the other two network vars are non-zero for these villages, dropping them would lead to loss in info.
* So, in the first stage using the entire sample, I generated the network gini for vars DegFood & DegMon.
* Next using the truncated sample, where those specific villages were dropped, I generated the network gini for var DegAdvice.
* In the end, I merged the subsample with the original sample - network gini(for var DegAdvice) for those villages were set to missing.

sort village
gen villagegini_food = .
gen villagegini_mon = .

levels village, local(levels1)
foreach v of local levels1 {
qui ineqdeco DegFood if village == `v'
replace villagegini_food = $S_gini if village == `v'
qui ineqdeco DegMon if village == `v'
replace villagegini_mon = $S_gini if village == `v'
}
sort state district village HHID id
save main1

drop _all
use main
drop  if SumDegAdvice == 0
gen villagegini_advice = .
sort village
levels village, local(levels1)

foreach v of local levels1 {
qui ineqdeco DegAdvice if village == `v'
replace villagegini_advice = $S_gini if village == `v'
}
sort state district village HHID id
keep ID villagegini_advice
save main, replace

use main1
merge 1:1 ID using main
drop _merge
sort state district village HHID id
save main, replace

* mean variables for other castes + within caste gini.
* formula used  -> mean of var of other castes(in the village) = (VillageTotal of var - CasteTotal of var)/(hhpopulation - hhcastepopulation)

* Avg. hh head age, other castes

bys state district village: egen VilTotHHHAge = total( HHeadAge)
order VilTotHHHAge, a( casteavgage)
bys state district village caste: egen CasteTotHHHAge = total( HHeadAge)
order CasteTotHHHAge, a( VilTotHHHAge )
sort state district village HHID id
gen oc_avgHHHage = (VilTotHHHAge- CasteTotHHHAge)/( hhpopulation- hhcastepopulation)
order oc_avgHHHage, a( casteavgage)

* Avg. hh size, other castes

bys state district village: egen VilTotHHsize = total( HHsize)
order VilTotHHsize, a( HHsize)
bys state district village caste: egen CasteTotHHsize = total( HHsize)
order CasteTotHHsize, a( VilTotHHsize)
sort state district village HHID id
gen oc_meanhhsize = ( VilTotHHsize- CasteTotHHsize)/(hhpopulation - hhcastepopulation)
order oc_meanhhsize, a( meanhhsize)

* Mean dependency ratio, other castes

order meandepratio  - castemeandepratio, a( DepRatio)
bys state district village: egen VilTotDepRatio = total( DepRatio)
order VilTotDepRatio, a(DepRatio)
bys state district village caste: egen CasteTotDepRatio =total( DepRatio)
order  CasteTotDepRatio, a( VilTotDepRatio)
sort state district village HHID id
gen oc_meandepratio = ( VilTotDepRatio - CasteTotDepRatio)/(hhpopulation - hhcastepopulation)
order oc_meandepratio, a( meandepratio)

* Proportion of male hh heads, other castes

sort state district village HHID id
gen oc_malehead = malehead - castemalehead
order oc_malehead, a( castemalehead)
gen oc_hhpopulation = hhpopulation - hhcastepopulation
order oc_hhpopulation, a( oc_malehead)
gen oc_propmalehead = oc_malehead/ oc_hhpopulation
order oc_propmalehead, a( oc_hhpopulation)

* Proportion of migrants, other castes

gen oc_migrants = Migrants - castemigrants
order  oc_migrants, a( castepropmigrant)
gen oc_population = population - castepop
order oc_population, a( oc_migrants)
gen oc_propmigrants = oc_migrants/oc_population
order oc_propmigrants, a( oc_migrants)

* Mean HH income, other castes

bys state district village: egen VillTotHHincome = total( tothhinc)
order VillTotHHincome, a( tothhinc)
bys state district village caste : egen CasteTotHHincome = total( tothhinc)
order CasteTotHHincome, a( VillTotHHincome)
sort state district village HHID id
gen oc_meantotHHicome = ( VillTotHHincome- CasteTotHHincome)/(hhpopulation - hhcastepopulation)
order oc_meantotHHincome, a( casteTotIncomeMean)

* Mean school yrs, other castes

bys state district village: egen VilTotEdu = total( schoolyrs)
bys state district village caste :egen CasteTotEdu = total( schoolyrs)
order VilTotEdu - CasteTotEdu, a( schoolyrs)
sort state district village HHID id
gen oc_edumean = (VilTotEdu - CasteTotEdu)/(population - castepop)
order oc_edumean, a( casteeduMean)

* Mean irrigated land holding, other castes

bys state district village: egen VillTotIrriLand = total( IrrigLand)
bys state district village caste: egen CasteTotIrriLand = total( IrrigLand)
order VillTotIrriLand - CasteTotIrriLand, a( IrrigLand)
sort state district village HHID id
gen oc_TotIrriLandMean = (VillTotIrriLand-CasteTotIrriLand)/(hhpopulation - hhcastepopulation)
order oc_TotIrriLandMean, a( casteTotIrriLandMean)

* Proportion of land holders, other castes

gen oc_TotLandHoldersHH = TotLandHoldersHH - casteTotLandHoldersHH
order oc_TotLandHoldersHH, a( casteTotLandHoldersProp )
gen oc_TotLandHoldersProp = oc_TotLandHoldersHH/oc_hhpopulation
order oc_TotLandHoldersProp, a( oc_TotLandHoldersHH)

save main, replace

* Mean HH income & education(school yrs.) percentiles, other castes

gen oc_TotIncome75 = .
gen oc_TotIncome25 = .
gen oc_edu75 = .
gen oc_edu25 = .
gen oc_TotIncomeSD = .
gen vc = .

sort village caste
levels village , local(levels1)

foreach v of local levels1 {
qui levels caste if village == `v', local(levels2)
foreach c of local levels2 {
qui replace vc = 1  if village == `v' & caste != "`c'"
gen TotIncX = tothhinc*vc
egen x = pctile(TotIncX), p(75)
egen y = pctile(TotIncX), p(25)
egen z = sd(TotIncX)
replace oc_TotIncome75 = x if village == `v' & caste == "`c'"
replace oc_TotIncome25 = y if village == `v' & caste == "`c'"
replace oc_TotIncomeSD = z if village == `v' & caste == "`c'"
drop TotIncX x y z
gen eduX = schoolyrs *vc
egen x = pctile(eduX), p(75)
egen y = pctile(eduX), p(25)
replace oc_edu75 = x if village == `v' & caste == "`c'"
replace oc_edu25 = y if village == `v' & caste == "`c'"
drop eduX x y
replace vc = .
}
}
sort state district village HHID id

* Dropping irrelevant variables.

drop HH VilTotHHHAge CasteTotHHHAge PriOcc TotLandHolding IrrigLand VillTotIrriLand CasteTotIrriLand VilTotEdu ///
CasteTotEdu migrants hsize HHsize VilTotHHsize CasteTotHHsize HHead DepRatio VilTotDepRatio CasteTotDepRatio frac ///
tothhinc VillTotHHincome CasteTotHHincome islandholder

save main_sepri

* THE END!

