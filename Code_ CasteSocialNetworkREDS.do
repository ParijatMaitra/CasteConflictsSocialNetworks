// Caste Dynamics & Social Network in rural India//
// Data Source - RURAL ECONOMIC AND DEMOGRAPHIC SURVEY(REDS) 2006//

//Author : PARIJAT MAITRA //

* Using REDS 2006 Data


use "listing2006.dta" 

* Variables districtid, villageid & castecode are coded as strings - changing them to numerics.

destring districtid villageid castecode, replace
rename q12 caste


* We need to find the no. of migrants in each household.
* Variable q3 -  unique hh listing no.
* Variable srno - serial no. of migrants in the hh.
* Variable q33 - year of migration
* We need to ensure that there are no duplicates by var q3.

sort state districtid villageid q3 srno
drop if srno[_n+1] > srno[_n] 
gen num_migrant = srno
replace num_migrant = 0 if q33==0
drop srno 



* Calculating total gross income & net income for each households.



foreach k of var q79 q80 q84 q85 q89 q90 q94 q95 q99 q100 q107 q108 q112 q116 q117 q118 q119 q120 q121 q122 q123 q124 q125 q126 q127 q128 q129 q130 q131 {
	replace `k' = 0 if `k'==.
}

gen TotIncome= q79 + q84 + q89 + q94 + q99 + q107 + q112 + q116 + q117 + q118 + q119 + q120 + q121 + q122 + q123 + q124 + q125 + q126 + q127 + q128 + q129 + q130 + q131

gen FarmIncome = q79 + q84 + q89 + q94 + q99



gen TotNetIncome= q79-q80 + q84-q85 + q89-q90 + q94-q95 + q99-q100 + q107-q108 + q112 + q116 + q117 + q118 + q119 + q120 + q121 + q122 + q123 + q124 + q125 + q126 + q127 + q128 + q129 + q130 + q131

gen FarmNetIncome = q79-q80 + q84-q85 + q89-q90 + q94-q95 + q99-q100

sum TotNetIncome, detail

corr q68 TotIncome

* var q68  - irrigated land holding(in acres.)

* Generating education categories.
* var q20  - no. of years in school.


egen EducationCat=cut(q20), at(0,5,10,30) icodes
replace EducationCat=EducationCat+1
replace EducationCat=0 if q20==0


* Generating tenure categories - how long the family has lived in the village.
* var q21- tenure.

egen TenureCat=cut(q21), at(0,20,50,100,200,300,1000,2000) icodes


* Generating primary occupation(of the hh head) categories - 

* var PrimOccucat is more suitable for our purpose.

* Index for PrimOccuCat

* 0 = Unemployed
* 1 = Landless labourers
* 2 = Landless cultivators
* 3 = Landholder cultivators
* 4 = Self-employed
* 5 = Salaried employed
* 6 = Uncategorised occupation

* var PrimOccuCatNCO is based on the occupation categorisation as per National Classification of Occupations(NCO)-2004.

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


gen PrimOccuCat=6     
gen PrimOccuCatNCO=0  


replace PrimOccuCat = 0 if q18==1111 | q18==1112 | q18==1114 | q18==1115 | q18==1116 | q18==1117 
replace PrimOccuCat = 1 if q18==630 | q18==650 
replace PrimOccuCat = 2 if q18==611 
replace PrimOccuCat = 3 if q18==610 | q18==620 
replace PrimOccuCat = 4 if q18>=600 & q18<=699 & q18!=630 & q18!=650 & q18!=611 & q18!=610 & q18!=620 
replace PrimOccuCat = 5 if q18>=0 & q18<=399  
replace PrimOccuCat = 5 if q18>=500 & q18<=599
replace PrimOccuCat = 5 if q18==1113 | q18==1118
replace PrimOccuCat = 5 if q18>=700 & q18<=999 
replace PrimOccuCat = 5 if q18>=1101 & q18<=1103 



replace PrimOccuCatNCO = 1 if q18>=0 & q18<=199 
replace PrimOccuCatNCO = 2 if q18>=200 & q18<=299 
replace PrimOccuCatNCO = 3 if q18>=300 & q18<=399 
replace PrimOccuCatNCO = 4 if q18>=400 & q18<=499 
replace PrimOccuCatNCO = 5 if q18>=500 & q18<=599
replace PrimOccuCatNCO = 5 if q18==1113 
replace PrimOccuCatNCO = 6 if q18>=600 & q18<=699 
replace PrimOccuCatNCO = 7 if q18>=700 & q18<=999 
replace PrimOccuCatNCO = 7 if q18==1118 	
replace PrimOccuCatNCO = 8 if q18>=1101 & q18<=1103 	
replace PrimOccuCatNCO = 9 if q18>=1001 & q18<=1010 
replace PrimOccuCatNCO = 9 if q18==1099 | q18==1119 
replace PrimOccuCatNCO = 10 if q18==1111 |q18==1112 |q18==1114 |q18==1115 |q18==1116 |q18==1117





* Generating land holdings(in acres) & total land value 
replace q68=0 if q68==.
replace q72=0 if q72==.

gen TotLandHolding = q68 + q72
gen TotLandValue = q68*q69 + q72*q73

* Dependency Ratio - households.

gen DependencyRatio=q14/q15



* Generating landholding categories - for total land and irrigated land (based on John Miller, 1960 categories)

gen TotLandholdCat=0
replace TotLandholdCat=1 if TotLandHolding>0 & TotLandHolding<=2
replace TotLandholdCat=2 if TotLandHolding>2 & TotLandHolding<=4
replace TotLandholdCat=3 if TotLandHolding>4 & TotLandHolding<=10
replace TotLandholdCat=4 if TotLandHolding>10 

gen IsLandHolder=0
replace IsLandHolder=1 if TotLandHolding>0


gen IrrigLandholdCat=0
replace IrrigLandholdCat=1 if q68>0 & q68<=2
replace IrrigLandholdCat=2 if q68>2 & q68<=4
replace IrrigLandholdCat=3 if q68>4 & q68<=10
replace IrrigLandholdCat=4 if q68>10


* generating total income categories by quartiles

egen TotIncomeCat = cut(TotIncome), group(4)


* renaming important variables.

rename q16 age
rename q17 gender
rename q18 PrimeOcc
rename q20 SchoolYrs
rename q22 IsMigrant
rename q21 HhTenure
rename q68 IrrigLand
gen IrrigLandPrice = IrrigLand*q69
rename q72 UnirrigLand
gen UnirrigLandPrice = UnirrigLand*q73

tab q45
* var q45 - whether any family member has contested local elections. 1 - Yes, 2 - No.
* But var q45 also seems to have other values - possibly data-entry errors.

drop if q45 == 1099 | q45 == 0 | q45 == 3 | q45 == 4 | q47 ==4

*vars q40 to q47 - deals with family members contesting local body elections where 1 - Yes, 2 - No.
* we're changing no-contest to 0 for convenience.

replace q40 = 0 if q40 == 2
replace q41 = 0 if q41 == 2
replace q42 = 0 if q42 == 2
replace q43 = 0 if q43 == 2
replace q44 = 0 if q44 == 2
replace q45 = 0 if q45 == 2
replace q46 = 0 if q46 == 2
replace q47 = 0 if q47 == 2

gen ContestPanchayat = q40+q41+q42+q43+q44+q45+q46+q47

* vars scst & obc are caste variables  - whether a specific household belongs to the Scheduled Castes/Scheduled Tribes(SC/ST) or Other Backward Castes(OBC).


gen scst = 0
replace scst = 1 if q11==1 | q11 ==2

gen obc= 0
replace obc = 1 if q11 == 3

*Removing outliers/errors.

drop if age==0
drop if SchoolYrs > 16 // 99.26% of population covered
drop if HhTenure > 2000 // 99.99% of the population covered.
drop if HhTenure == 0 // 2.36% observations dropped.
drop if IrrigLand > 71.87 // 99.99% observations covered.
drop if TotIncome > 4000000 // 99.99% of the population covered.
drop if TotIncome == 0 // data entry error (3,156 hh or 2.74%)  
drop if q14 > 20 //99.74% for family size
drop if DependencyRatio > 20 // 99.97%



* Total population or no. of households in each village.

by state districtid villageid: egen population = max(q3)

* vars q152, q153 & q154 - household IDs of neighbours (in order of preference) from whom a paricular hh would choose to borrow money in times of crises.
* vars q155, q156 & q157 - household IDs of neighbours (in order of preference) from whom a paricular hh would choose to borrow food in times of crises.
* vars q168, q169 & q170 - household IDs of most preferred neighbours (in order of preference).

* We need to ensure that there are no repetitions in the network vars.
* We use the following code to elimate bad network data.


gen x1 = .
replace x1 = 1 if q152 !=. & q152 == q153
replace x1 = 1 if q152 !=. & q152 == q154
replace x1 = 1 if q153 !=. & q153 == q154



gen y1 = .
replace y1 = 1 if q155 !=. & q155 == q156
replace y1 = 1 if q155 !=. & q155 == q157
replace y1 = 1 if q156 !=. & q156 == q157

gen z1 = .
replace z1 = 1 if q168 !=. & q168 == q170
replace z1 = 1 if q168 !=. & q168 == q170
replace z1 = 1 if q169 !=. & q169 == q170

tab x1
tab y1
tab z1

tab villageid if x1 == 1
tab villageid if y1 == 1
tab villageid if z1 == 1


* We're going to elimninate entire villages if 15% or more households have bad data on network links.
* We're also going to remove any hh with bad data on links.


foreach v of varlist x1 y1 z1{
sort villageid `v'
by villageid `v': egen `v'_vill = total(`v')
gen  `v'frac_vill = `v'_vill/population
}



drop if x1frac_vill > .15 | y1frac_vill > .15 | z1frac_vill > .15

drop if x1 == 1 | y1 == 1 | z1 == 1 


drop x1* y1* z1*

save main, replace


* Creating Link Characteristics.

* Network Variables q152-q157 q168-q170


* For each of these variables x, we get the characteristics for
* caste castecode sid
* age gender DependencyRatio
* num_migrant HhTenure IsMigrant
* PrimeOcc SchoolYrs TotIncome 
* IrrigLand UnirrigLand TotLandholdCat IrrigLandholdCat  TotLandHolding IsLandHolder 
* IrrigLandPrice UnirrigLandPrice TotLandValue 
* PrimOccuCat EducationCat TenureCat TotIncomeCat 




drop _all

use main
keep villageid q1-obc
drop q152-q157 q168-q170
order villageid
order q3, a(villageid)
order sid, a(q3)
order UnirrigLandPrice, last
save temp, replace

*Checking for duplicates

sort villageid q3
quietly by villageid q3:  gen dup = cond(_N==1,0,_n)
tab dup

*no duplicates here*
drop dup



* for var q152

drop _all
use temp
rename q3 q152
foreach var of varlist sid-UnirrigLandPrice {
	rename `var'  q152`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q152 using tempx
drop if _merge == 2
drop _merge

save main, replace

* for var q153

drop _all
use temp

rename q3 q153
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q153`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q153 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q154

drop _all
use temp

rename q3 q154
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q154`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q154 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q155

drop _all
use temp

rename q3 q155
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q155`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q155 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q156

drop _all
use temp

rename q3 q156
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q156`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q156 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q157

drop _all
use temp

rename q3 q157
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q157`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q157 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q168

drop _all
use temp

rename q3 q168
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q168`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q168 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q169

drop _all
use temp

rename q3 q169
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q169`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q169 using tempx
drop if _merge == 2
drop _merge
save main, replace

* for var q170

drop _all
use temp

rename q3 q170
foreach var of varlist sid-UnirrigLandPrice {

	rename `var'  q170`var'
}
save tempx, replace

drop _all
use main

merge m:1 villageid q170 using tempx
drop if _merge == 2
drop _merge
save main, replace

* Generating variables capturing the presence or absence of links.


foreach var of varlist q152-q157 q168-q170{
gen IsLink`var' = 1 if `var' != .
replace IsLink`var' = 0 if `var' == .
gen IsLinkCaste`var' = 1 if `var' != . & caste == `var'caste
replace IsLinkCaste`var' = 0 if `var' != . & caste != `var'caste
replace IsLinkCaste`var' = 0 if `var' == . 
gen IsLinkSid`var' = 1 if `var' != . & sid == `var'sid
replace IsLinkSid`var' = 0 if `var' != . & sid != `var'sid
replace IsLinkSid`var' = 0 if `var' == . 
}


* Generating variables capturing total links per hh by type (money, food or preferred neighbour)

gen LinksBorrowMon = IsLinkq152 + IsLinkq153 + IsLinkq154
gen LinksBorrowFood = IsLinkq155 + IsLinkq156 + IsLinkq157
gen LinksNbr = IsLinkq168 + IsLinkq169 + IsLinkq170

* Generating variables capturing total links per hh formed within the same caste.

gen LinksBorrowMonCaste = IsLinkCasteq152 + IsLinkCasteq153 + IsLinkCasteq154
gen LinksBorrowFoodCaste = IsLinkCasteq155 + IsLinkCasteq156 + IsLinkCasteq157
gen LinksNbrCaste = IsLinkCasteq168 + IsLinkCasteq169 + IsLinkCasteq170

* Generating variables capturing total links per hh formed within hh living in the same streets(var sid - street id)

gen LinksBorrowMonSid = IsLinkSidq152 + IsLinkSidq153 + IsLinkSidq154
gen LinksBorrowFoodSid = IsLinkSidq155 + IsLinkSidq156 + IsLinkSidq157
gen LinksNbrSid = IsLinkSidq168 + IsLinkSidq169 + IsLinkSidq170

save main, replace

* Generating outdegrees for each link question(by caste, street, type etc.)

foreach var of varlist q152-q157 q168-q170{

sort villageid `var'
by villageid `var': gen indeg`var' = _N
replace indeg`var' = . if `var' == . 


gen xcaste = `var' if IsLinkCaste`var' == 1 
sort villageid xcaste 
by villageid xcaste: gen indegcaste`var' = _N 
replace indegcaste`var' = . if xcaste == . 

gen xsid = `var' if IsLinkSid`var' == 1 
sort villageid xsid 
by villageid xsid: gen indegsid`var' = _N 
replace indegsid`var' = . if xsid == . 

keep villageid `var' indeg`var' indegcaste`var' indegsid`var' 
rename `var' q3

sort villageid q3
quietly by villageid q3:  gen dup = cond(_N==1,0,_n)
drop if dup>1
save tempindeg, replace

use main
merge 1:1 villageid q3 using tempindeg
drop if _merge==2
drop _merge
save main, replace

}

foreach var of varlist q152-q157 q168-q170{
replace indeg`var' = 0 if indeg`var' == .
replace indegcaste`var' = 0 if indegcaste`var' == . 
replace indegsid`var' = 0 if indegsid`var' == . 
}

gen InDegMon = indegq152 + indegq153 + indegq154
gen InDegFood = indegq155 + indegq156 + indegq157
gen InDegNbr = indegq168 + indegq169 + indegq170


gen InDegCasteMon = indegcasteq152 + indegcasteq153 + indegcasteq154
gen InDegCasteFood = indegcasteq155 + indegcasteq156 + indegcasteq157
gen InDegCasteNbr = indegcasteq168 + indegcasteq169 + indegcasteq170


gen InDegSidMon = indegsidq152 + indegsidq153 + indegsidq154
gen InDegSidFood = indegsidq155 + indegsidq156 + indegsidq157
gen InDegSidNbr = indegsidq168 + indegsidq169 + indegsidq170

save main, replace

gen DegFood = InDegFood + LinksBorrowFood
gen DegMon = InDegMon + LinksBorrowMon
gen DegNbr = InDegNbr + LinksNbr


* Generating Village & Caste level characteristics.


sort state districtid villageid caste


* fractionalization by caste.

* Formula: fractionalization =  1 - (proportion of each caste)^2 
* if there is a single caste then fractionalization is 0, the number is very high when many small groups are present.


bysort districtid villageid caste: gen castepop = _N

* castepopfrac - population share for each individual's caste.

gen castepopfrac = castepop/population
sort state districtid villageid
by state districtid villageid: egen fractionalization_c = total(castepopfrac) 
replace fractionalization_c = 1 - fractionalization_c/population


* mean age of hh head, village-wise.

by state districtid villageid: egen avgage = mean(age)

* mean age of hh head by caste.

sort state districtid villageid caste
by state districtid villageid caste: egen casteavgage = mean(age)


*Proportion of male hh heads.

by state districtid villageid: egen malehead = total(gender==1)
gen propmalehead = malehead/population

*Gender of hh head = male by caste.

by state districtid villageid caste: egen castemalehead = total(gender==1)
gen castepropmalehead = castemalehead/castepop

* count by religion.

by state districtid villageid: egen religion1 = total(q10==1)
by state districtid villageid: egen religion2 = total(q10==2)
gen hindu_prop = religion1/population

* count by religion caste.

by state districtid villageid caste: egen castereligion1 = total(q10==1)
by state districtid villageid caste: egen castereligion2 = total(q10==2)
gen castehindu_prop = castereligion1/castepop

* number of streets in the village.

by state districtid villageid: egen maxsid = max(sid)

* number of streets by caste.

by state districtid villageid caste: egen castesid = nvals(sid)

* average hh size.

by state districtid villageid: egen meanhhsize = mean(q14)

* average hh size by caste.

by state districtid villageid caste: egen castemeanhhsize = mean(q14)

* dependency ratio.

gen depratio = q14/q15
by state districtid villageid: egen meandepratio = mean(depratio)

*dependency ratio by caste.

by state districtid villageid caste: egen castemeandepratio = mean(depratio)


* modal value of primary occupation.

by state districtid villageid: egen modeoccup1 = mode(PrimeOcc)
by state districtid villageid: egen modeoccup2 = mode(q19)

* modal value of primary occupation by caste.

by state districtid villageid caste: egen castemodeoccup1 = mode(PrimeOcc)
by state districtid villageid caste: egen castemodeoccup2 = mode(q19)


* how long have they lived in the village(tenure).

by state districtid villageid: egen time75 = pctile(HhTenure), p(75)
by state districtid villageid: egen time25 = pctile(HhTenure), p(25)
by state districtid villageid: egen meantime = mean(HhTenure)

* time in the village(tenure) by caste.

by state districtid villageid caste: egen castetime75 = pctile(HhTenure), p(75)
by state districtid villageid caste: egen castetime25 = pctile(HhTenure), p(25)
by state districtid villageid caste: egen castemeantime = mean(HhTenure)

* total no of migrants from the village and as a proportion of the village population.

by state districtid villageid: egen migrants = total(num_migrant)
gen propmigrant = migrants/population

* total migrants from the caste + village and as a proportion of the population.

by state districtid villageid caste: egen castemigrants = total(num_migrant)
gen castepropmigrant = castemigrants/castepop


*total income percetiles

by state districtid villageid: egen TotIncome90 = pctile(TotIncome), p(90)
by state districtid villageid: egen TotIncome75 = pctile(TotIncome), p(75)
by state districtid villageid: egen TotIncome50 = pctile(TotIncome), p(50)
by state districtid villageid: egen TotIncome25 = pctile(TotIncome), p(25)
by state districtid villageid: egen TotIncome10 = pctile(TotIncome), p(10)
by state districtid villageid: egen TotIncomeMean = mean(TotIncome)
by state districtid villageid: egen TotIncomeSD = sd(TotIncome)


* total income percetiles by caste.

by state districtid villageid caste: egen casteTotIncome90 = pctile(TotIncome), p(90)
by state districtid villageid caste: egen casteTotIncome75 = pctile(TotIncome), p(75)
by state districtid villageid caste: egen casteTotIncome50 = pctile(TotIncome), p(50)
by state districtid villageid caste: egen casteTotIncome25 = pctile(TotIncome), p(25)
by state districtid villageid caste: egen casteTotIncome10 = pctile(TotIncome), p(10)
by state districtid villageid caste: egen casteTotIncomeMean = mean(TotIncome)
by state districtid villageid caste: egen casteTotIncomeSD = sd(TotIncome)


* education percetiles.

by state districtid villageid: egen edu75 = pctile(SchoolYrs), p(75)
by state districtid villageid: egen edu25 = pctile(SchoolYrs), p(25)
by state districtid villageid: egen eduMean = mean(SchoolYrs)

* education percetiles by caste.

by state districtid villageid caste: egen casteedu75 = pctile(SchoolYrs), p(75)
by state districtid villageid caste: egen casteedu25 = pctile(SchoolYrs), p(25)
by state districtid villageid caste: egen casteeduMean = mean(SchoolYrs)


* total land holding - mean.

by state districtid villageid: egen TotLandMean = mean(TotLandHolding)

* total land holding mean by caste.

by state districtid villageid caste: egen casteTotLandMean = mean(TotLandHolding)

* total irrigated land  - mean.

by state districtid villageid: egen TotIrriLandMean = mean(IrrigLand)

* total irrigated land mean by caste.

by state districtid villageid caste: egen casteTotIrriLandMean = mean(IrrigLand)

* total land holders proportion.

by state districtid villageid: egen TotLandHolders = total(IsLandHolder)
replace TotLandHolders = TotLandHolders/population

* total land holders by caste.

by state districtid villageid caste: egen casteTotLandHolders = total(IsLandHolder)
replace casteTotLandHolders = casteTotLandHolders/castepop


* total links by type( money, food & preferred neighbour)

sort state districtid villageid
by state districtid villageid: egen TotLinksFood = total(LinksBorrowFood)
by state districtid villageid: egen TotLinksMon = total(LinksBorrowMon)
by state districtid villageid: egen TotLinksNbr = total(LinksNbr)

*  total links made by a caste - within itself or outside.

sort state districtid villageid caste
by state districtid villageid caste: egen casteOutLinksFood = total(LinksBorrowFood)
by state districtid villageid caste: egen casteOutLinksMon = total(LinksBorrowMon)
by state districtid villageid caste: egen casteOutLinksNbr = total(LinksNbr)

* individual links received from other caste.

gen InDegOutcasteMon = InDegMon - InDegCasteMon
gen InDegOutcasteFood = InDegFood - InDegCasteFood
gen InDegOutcasteNbr = InDegNbr - InDegCasteNbr


* total links received by a caste from other castes.

by state districtid villageid caste: egen casteInLinksFood = total(InDegOutcasteFood)
by state districtid villageid caste: egen casteInLinksMon = total(InDegOutcasteMon)
by state districtid villageid caste: egen casteInLinksNbr = total(InDegOutcasteNbr)

* total caste links = links made by caste members + links received from other castes.

gen casteLinksFood = casteOutLinksFood + casteInLinksFood
gen casteLinksMon = casteOutLinksMon + casteInLinksMon
gen casteLinksNbr = casteOutLinksNbr + casteInLinksNbr


* total link by type within same caste.

by state districtid villageid: egen TotLinksFoodCaste = total(LinksBorrowFoodCaste)
by state districtid villageid: egen TotLinksMonCaste = total(LinksBorrowMonCaste)
by state districtid villageid: egen TotLinksNbrCaste = total(LinksNbrCaste)

by state districtid villageid caste: egen casteTotLinksFoodCaste = total(LinksBorrowFoodCaste)
by state districtid villageid caste: egen casteTotLinksMonCaste = total(LinksBorrowMonCaste)
by state districtid villageid caste: egen casteTotLinksNbrCaste = total(LinksNbrCaste)

* total links by type within same street.

by state districtid villageid: egen TotLinksFoodSid = total(LinksBorrowFoodSid)
by state districtid villageid: egen TotLinksMonSid = total(LinksBorrowMonSid)
by state districtid villageid: egen TotLinksNbrSid = total(LinksNbrSid)

by state districtid villageid caste: egen casteTotLinksFoodSid = total(LinksBorrowFoodSid)
by state districtid villageid caste: egen casteTotLinksMonSid = total(LinksBorrowMonSid)
by state districtid villageid caste: egen casteTotLinksNbrSid = total(LinksNbrSid)

* maximum in-degrees in the village.

by state districtid villageid: egen MaxInLinksMon = max(InDegMon)
by state districtid villageid: egen MaxInLinksFood = max(InDegFood)
by state districtid villageid: egen MaxInLinksNbr = max(InDegNbr)

by state districtid villageid caste: egen casteMaxInLinksMon = max(InDegMon)
by state districtid villageid caste: egen casteMaxInLinksFood = max(InDegFood)
by state districtid villageid caste: egen casteMaxInLinksNbr = max(InDegNbr)

* incomegini by village and caste -  IF INCOME IS ZERO, it is not included in calculation.

gen villagegini = .
gen villagecastegini = .


sort villageid caste
levels villageid, local(levels1)
foreach v of local levels1 {
	qui ineqdeco TotIncome if villageid == `v'  
	replace villagegini = $S_gini if villageid == `v' 
	qui levels caste if villageid == `v', local(levels2)
	foreach c of local levels2 {
	qui ineqdeco TotIncome if villageid == `v' & caste == "`c'"
	replace villagecastegini = $S_gini if villageid == `v' & caste == "`c'"
}
}

save main, replace

* network gini by village - IF total links are ZERO, it is not included in the calculation.

gen villagegini_food = .
gen villagegini_mon = .
gen villagegini_nbr = .


sort villageid 
levels villageid, local(levels1)
foreach v of local levels1 {
	qui ineqdeco DegFood if villageid == `v'  
	replace villagegini_food = $S_gini if villageid == `v' 
	
	qui ineqdeco DegMon if villageid == `v'  
	replace villagegini_mon = $S_gini if villageid == `v' 
	
	qui ineqdeco DegNbr if villageid == `v'  
	replace villagegini_nbr = $S_gini if villageid == `v' 

}




* mean variables for other castes + within caste gini.

foreach var of varlist avgage hindu_prop meanhhsize meandepratio propmalehead meantime propmigrant TotIncomeMean eduMean TotIrriLandMean TotLandHolders{
gen oc_`var' = (`var'*population - caste`var'*castepop)/(population - castepop)
}

* % variables for other castes.


gen oc_TotIncome75 = .
gen oc_TotIncome25 = .
gen oc_edu75 = .
gen oc_edu25 = .
gen oc_TotIncomeSD = .
gen vc = .


sort villageid caste
levels villageid, local(levels1)
foreach v of local levels1 {
	qui levels caste if villageid == `v', local(levels2)
	foreach c of local levels2 {
	
	qui replace vc = 1  if villageid == `v' & caste != "`c'"
	
	gen TotIncX = TotIncome*vc
	egen x = pctile(TotIncX), p(75)
	egen y = pctile(TotIncX), p(25)
	egen z = sd(TotIncX)
	replace oc_TotIncome75 = x if villageid == `v' & caste == "`c'" 
	replace oc_TotIncome25 = y if villageid == `v' & caste == "`c'" 
	replace oc_TotIncomeSD = z if villageid == `v' & caste == "`c'" 
	drop TotIncX x y z
	
	gen eduX = SchoolYrs*vc
	egen x = pctile(eduX), p(75)
	egen y = pctile(eduX), p(25)
	replace oc_edu75 = x if villageid == `v' & caste == "`c'" 
	replace oc_edu25 = y if villageid == `v' & caste == "`c'" 
	drop eduX x y
	
	replace vc = .
}
}
drop dup
save main, replace

* The END!


