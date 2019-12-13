* Data preparation for visualizing Networks in Gephi.

* Author: PARIJAT MAITRA

* Version - 14

set more off
use main_reds

* PART 1 : Caste based network links at the village level.

* Gephi requires data to be in a specfic format - 
* Part 1: Nodes dataset which should have an 'ID' column(casteID in our case) & a 'Label' column(caste names), alongwith other variables.
* Part 2: Edges dataset which should have a 'Source' column(casteID) & a 'Target' column(casteIDs of the linked individuals).


egen casteID = group( villageid caste)
order casteID, a(caste)
drop if casteID == .

* Dropping irrelevant variables.

keep village villageid district - stateid caste casteID q3 q152 - q157 q168 - q170 scst NoOfCastes castepopfrac
save gephi

sort casteID

* Collapsing the dataset from the household level to the caste level.

bys casteID: drop if casteID == casteID[_n+1]
ren casteID ID
ren caste Label
order NoOfCastes, a( state)
tab state

save gephi1

* Creating caste-base network links.

clear
use gephi
keep villageid q3 casteID
save temp, replace
rename q3 q152
ren casteID q152casteID
save tempx, replace
use gephi
merge m:1 villageid q152 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q153
ren casteID q153casteID
save tempx, replace
use gephi
merge m:1 villageid q153 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q154
ren casteID q154casteID
save tempx, replace
use gephi
merge m:1 villageid q154 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q155
ren casteID q155casteID
save tempx, replace
use gephi
merge m:1 villageid q155 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q156
ren casteID q156casteID
save tempx, replace
use gephi
merge m:1 villageid q156 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q157
ren casteID q157casteID
save tempx, replace
use gephi
merge m:1 villageid q157 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q168
ren casteID q168casteID
save tempx, replace
use gephi
merge m:1 villageid q168 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q169
ren casteID q169casteID
save tempx, replace
use gephi
merge m:1 villageid q169 using tempx
drop if _merge == 2
drop _merge
save gephi, replace
use temp
ren q3 q170
ren casteID q170casteID
save tempx, replace
use gephi
merge m:1 villageid q170 using tempx
drop if _merge == 2
drop _merge
save gephi, replace

* For each network type(food, money or preferred neighbour) an individual has maximum of three links & the dataset is in wide format.
* However, to visualize these networks in Gephi, the 'Edges' data has to be set in the long format.
* Reshaping the 'Edges' network dataset.

keep village villageid casteID q152casteID q153casteID q154casteID q155casteID q156casteID q157casteID q168casteID q169casteID q170casteID
sort casteID
gen ID = _n
save gephi, replace

*Since in the 'Edges' dataset, casteIDs are not unique, I created an unique ID for each edges to reshape the data & link the reshaped data to the original casteIDs

keep village villageid casteID ID
save gephi2
use gephi
keep ID q152casteID - q170casteID
order ID, first
ren q152casteID mon1
ren q153casteID mon2
ren q154casteID mon3
ren q155casteID food1
ren q156casteID food2
ren q157casteID food3
ren q168casteID nbr1
ren q169casteID nbr2
ren q170casteID nbr3
save gephi3
keep ID mon1 mon2 mon3
save gephimon
use gephi3
keep ID food1 food2 food3
save gephifood
use gephi3
keep ID nbr1 nbr2 nbr3
save gephinbr

use gephimon
reshape long mon, i(ID) j(j)
save gephimon, replace
use gephi
joinby ID using gephimon
drop ID j
ren casteID Source
ren mon target
drop if target == .
save gephimon, replace

use gephifood
reshape long food, i(ID) j(j)
save gephifood, replace
use gephi
joinby ID using gephifood
drop ID j
ren casteID Source
ren food target
drop if target == .
save gephifood, replace

use gephinbr
reshape long nbr, i(ID) j(j)
save gephinbr, replace
use gephi
joinby ID using gephinbr
drop ID j
ren casteID Source
ren nbr target
drop if target == .
save gephinbr, replace

* File gephi1 - nodes dataset for the entire sample
* Files gephimon, gephifood & gephinbr - full sample edges dataset for each network type.
* Converting them to csv format so that they can be read by Gephi
* In Gephi I extracted the Betweenness centrality & Eigenvector centrality measures for the full sample & linked those values to the original casteIDs.

clear
use gephi1
export delimited using "C:\Users\Parijat\Desktop\Gephi\gephi1", replace
clear
use gephimon
export delimited using "C:\Users\Parijat\Desktop\Gephi\gehimon", replace
clear
use gephifood
export delimited using "C:\Users\Parijat\Desktop\Gephi\gephifood", replace
clear
use gephinbr
export delimited using "C:\Users\Parijat\Desktop\Gephi\gephinbr", replace
clear

import delimited C:\Users\Parijat\Desktop\BetCentEigenCent.csv, clear
save gephi3

* Since Gephi doesn't have any 'by' or 'if' option, so for each specific village I needed a unique dataset for the nodes & an unique dataset for each network type
* The following loops split the datasets(Nodes & Edges) into 242 parts - there are 242 villages & convert them into csv format.

use gephi1
levels villageid, local(levels1)
foreach v of local levels1 {
keep if villageid == `v'
export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\CasteNode_`v'", replace
clear
use gephi1
}
clear

use gephimon
levels villageid, local(levels1)
foreach v of local levels1 {
keep if villageid == `v'
export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\CasteEdgeMon_`v'", replace
clear
use gephimon
}
clear

use gephifood
levels villageid, local(levels1)
foreach v of local levels1 {
keep if villageid == `v'
export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\CasteEdgeFood_`v'", replace
clear
use gephifood
}
clear

use gephinbr
levels villageid, local(levels1)
foreach v of local levels1 {
keep if villageid == `v'
export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\CasteEdgeNbr_`v'", replace
clear
use gephinbr
}
clear

* Part 2: Household level network links.
* This part follows the same steps as outlined above.

use main_reds
keep village villageid district districtid state stateid q3 caste scst
ren q3 ID
ren caste Label
order state stateid district districtid village villageid scst ID Label
save gephicomm
clear
use main_reds
keep village villageid q3 q152 q153 q154 q155 q156 q157 q168 q169 q170
gen ID = _n
save gephicomm2
keep ID q152 - q170
order ID, first
ren q152 mon1
ren q153 mon2
ren q154 mon3
ren q155 food1
ren q156 food2
ren q157 food3
ren q168 nbr1
ren q169 nbr2
ren q170 nbr3
save gephicomm3

keep ID mon1 mon2 mon3
save gephicommon
use gephicomm3
keep ID food1 food2 food3
save gephicomfood
use gephicomm3
keep ID nbr1 nbr2 nbr3
save gephicomnbr

use gephicommon
reshape long mon, i(ID) j(j)
save gephicommon, replace
use gephicomfood
reshape long food, i(ID) j(j)
save gephicomfood, replace
use gephicomnbr
reshape long nbr, i(ID) j(j)
save gephicomnbr, replace

use gephicomm2
drop q152 - q170
save gephicomm2, replace
joinby ID using gephicommon
drop ID j
ren q3 Source
ren mon target
drop  if target == .
save gephicommon, replace

use gephicomm2
joinby ID using gephicomfood
drop ID j
ren q3 Source
ren food target
drop  if target == .
save gephicomfood, replace

use gephicomm2
joinby ID using gephicomnbr
drop ID j
ren q3 Source
ren nbr target
drop  if target == .
save gephicomnbr, replace

clear

use gephicomm
levels villageid, local(levels1)
foreach v of local levels1 {
  keep if villageid == `v'
  export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\Node_`v'", replace
  clear
  use gephicomm
}
clear

use gephicommon
levels villageid, local(levels1)
foreach v of local levels1 {
 keep if villageid == `v'
 export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\EdgeMon_`v'", replace
 clear
 use gephicommon
}
clear

use gephicomfood
levels villageid, local(levels1)
foreach v of local levels1 {
  keep if villageid == `v'
  export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\EdgeFood_`v'", replace
  clear
  use gephicomfood
}
clear

use gephicomnbr
levels villageid, local(levels1)
foreach v of local levels1 {
  keep if villageid == `v'
  export delimited using  "C:\Users\Parijat\Desktop\Gephi\Network\EdgeNbr_`v'", replace
  clear
  use gephicomnbr
}
clear

* The End!
