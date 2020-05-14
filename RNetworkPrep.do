* Data preparation for visualizing village-wise household level caste Networks in R.

* Author: PARIJAT MAITRA

* Version - 14


set more off
use main_reds
cd E:\Data\Network
log using Net.log

* dropping irrelevant vars.

keep villageid q3 caste q168 - q170 scst

tab villageid
codebook villageid

* var q3 - household id in a given village.
* Since across villages, q3 is not unique,
* I created a unique hh ID taking into account q3 and the village ID

egen UniqueID = group( villageid q3)
order UniqueID, a( villageid)
duplicates report UniqueID
save RNetwork

* renaming network vars as nodes & edges.
* each hh is linked to maximum 3 other households.

ren ( q3 q168 q169 q170) (Node Edge1 Edge2 Edge3)
keep villageid UniqueID Node caste scst
save Node

* There are 240 villages in the sample.
* Since the village level networks exist in isolation(not linked to other villlages in the sample)
* I had to split the sample(both edgelist & nodelist) into 240 subsamples.
* The following algorithm was used for this purpose.

levels villageid, local(levels1)
foreach v of local levels1 {
keep if villageid == `v'
egen castecode = group(caste)
order Node, first
ren Node Edge
save Node_`v'
clear
use Node
}
clear

use RNetwork
keep villageid Node Edge1 Edge2 Edge3
save Edge
levels villageid, local(levels1)
foreach v of local levels1 {
keep if villageid == `v'
reshape long Edge, i(Node) j(Num)
drop Num
drop if Edge == .
order Node Edge, first
save Edge_`v'
clear
use Edge
}
clear


* Since this is a undirected network, so as to ensure that no nodal household in the edgelist is missing from the primary nodelist,
* I used the following algorithm.

foreach v of local levels1 {
use Node_`v'
merge 1:m Edge using Edge_`v'
drop Node
sort Edge
drop if Edge == Edge[ _n+1]
drop _merge UniqueID
ren Edge Node
save Node_`v', replace
clear
}
clear

* The End!
