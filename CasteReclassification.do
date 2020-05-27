* Caste Reclassification

* Author - PARIJAT MAITRA

* Data - REDS 2006
 
* version  - 16

* Part 1 - using the original data to create a database of statewise caste list

use main_reds
sort state caste
keep village state caste
drop if caste ==  ""
egen castecode = group (state caste)
save StateCaste

bys castecode: gen HhTotal = _N

bys state caste: drop if HhTotal == HhTotal[_n+1]
drop castecode village

bys state: egen TotHH = total( HhTotal)
gen PercentHH = (HhTotal/ TotHH)*100
keep state caste HhTotal PercentHH
export excel using "StateCaste", firstrow(variables) replace

clear

* I used the generated excel database to go through each individual caste, checking to ensure that they exist, that they have 
* been assigned the correct spellings & whether a certain caste is known by different names in different parts of a particular state.

* Part 2 : Reclassification

* The following changes were made:

* All misspellings have been corrected (using government database)

* Those castes which are known by different names in different parts of the state( & hence have been treated as separate entities in the orignal survey)
* have been regrouped under a single name.

* Those castes, for which I couldn't find any records,
* I first checked for their subcastes - based on their subcastes they were assigned to a particular caste group.
* If the subcastes data were not available for these castes, I chose to keep them in their original form.
* All of these castes have been thoroughly documented.

set more off
use main

replace caste = "KOMATI" if caste == "ARYAVYSYA" & state == "ANDHRA PRADESH"
replace caste = "MANGALI" if caste == "BARBER" & state == "ANDHRA PRADESH"
replace caste = "BATTALA" if caste == "BATHULA" & state == "ANDHRA PRADESH"
replace caste = "KAMSALI" if caste == "CAMSULA" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "CHAKALA" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "CHAKALI" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "DHOBI" & state == "ANDHRA PRADESH"
replace caste = "BESTHA" if caste == "FISHERS" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "KALASALI" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "KAMSALI" & state == "ANDHRA PRADESH"
replace caste = "KAMMA" if caste == "KAMA" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "KAMMARA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KAPUVELAMA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KOLLI" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KOPPALAVELAMA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KOPPLAVELAMA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KUPPALAVELAMA" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "MADIVILI" & state == "ANDHRA PRADESH"
replace caste = "MADIGA" if caste == "MANDIGA" & state == "ANDHRA PRADESH"
replace caste = "RAJASTHANI" if caste == "MARWADI" & state == "ANDHRA PRADESH"
replace caste = "MADIGA" if caste == "MODUGU" & state == "ANDHRA PRADESH"
replace caste = "MANGALI" if caste == "NAYBRAHMANULU" & state == "ANDHRA PRADESH"
replace caste = "KAPU" if caste == "PALIKAPU" & state == "ANDHRA PRADESH"
replace caste = "ARCHAKULU" if caste == "PUJARI" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "RAJAKULU" & state == "ANDHRA PRADESH"
replace caste = "ODDE" if caste == "RAJULU" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "SAKALA" & state == "ANDHRA PRADESH"
replace caste = "PADMASALI" if caste == "SALI" & state == "ANDHRA PRADESH"
replace caste = "PADMASALI" if caste == "SALILU" & state == "ANDHRA PRADESH"
replace caste = "KAPU" if caste == "TELAGAMAMDELU" & state == "ANDHRA PRADESH"
replace caste = "TELAKULA" if caste == "TELI" & state == "ANDHRA PRADESH"
replace caste = "TELAKULA" if caste == "TELUKU" & state == "ANDHRA PRADESH"
replace caste = "TELAKULA" if caste == "TENTKALU" & state == "ANDHRA PRADESH"
replace caste = "ODDE" if caste == "VADDI" & state == "ANDHRA PRADESH"
replace caste = "ODDE" if caste == "VADI" & state == "ANDHRA PRADESH"
replace caste = "YADAV" if caste == "VEDAVA" & state == "ANDHRA PRADESH"
replace caste = "VISALU" if caste == "VISALI" & state == "ANDHRA PRADESH"
replace caste = "KAMSALI" if caste == "VISHNU" & state == "ANDHRA PRADESH"
replace caste = "KAMSALI" if caste == "VISWABRAHAMAN" & state == "ANDHRA PRADESH"
replace caste = "KAMSALI" if caste == "VYSYA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "YALAMA" & state == "ANDHRA PRADESH"
replace caste = "YADAV" if caste == "YEAVA" & state == "ANDHRA PRADESH"
replace caste = "YERUKALA" if caste == "YERKULA" & state == "ANDHRA PRADESH"
replace caste = "YERUKALA" if caste == "YERUKULA" & state == "ANDHRA PRADESH"


replace caste = "BRAHMAN" if caste == "BRAHAMIN" & state == "BIHAR"
replace caste = "GOND" if caste == "GUND" & state == "BIHAR"
replace caste = "TELI" if caste == "SAHU" & state == "BIHAR"
replace caste = "TATWA" if caste == "TANTI" & state == "BIHAR"
replace caste = "LOHAR" if caste == "VISHWAKARMA" & state == "BIHAR"

replace caste = "PANIKA" if caste == "DAS" & state == "CHHATTISGARH"
replace caste = "GADARIYA" if caste == "GADARIA" & state == "CHHATTISGARH"
replace caste = "KALWAR" if caste == "KALLAR" & state == "CHHATTISGARH"
replace caste = "KANWAR" if caste == "KAWAR" & state == "CHHATTISGARH"

replace caste = "VAJIR" if caste == "BAJIR" & state == "GUJARAT"
replace caste = "BAWAJI" if caste == "BAVAJI" & state == "GUJARAT"
replace caste = "VAJIR" if caste == "BHAJIR" & state == "GUJARAT"
replace caste = "BHANUSHALI" if caste == "BHANUSHAIL" & state == "GUJARAT"
replace caste = "BHARWAD" if caste == "BHARVAD" & state == "GUJARAT"
replace caste = "CHAUDHRI" if caste == "CHOUDHARI" & state == "GUJARAT"
replace caste = "VAGHRI" if caste == "DEVIPUJAK" & state == "GUJARAT"
replace caste = "HALPATI" if caste == "HINDU HALPATI" & state == "GUJARAT"
replace caste = "KUMBHAR" if caste == "HINDU KUMBHAR" & state == "GUJARAT"
replace caste = "PATEL" if caste == "KALARIA" & state == "GUJARAT"
replace caste = "CATHOLIC" if caste == "KATHLIK" & state == "GUJARAT"
replace caste = "KOLI" if caste == "KOHLI" & state == "GUJARAT"
replace caste = "MAKWANA" if caste == "MALWANA" & state == "GUJARAT"
replace caste = "BAJANIYA" if caste == "NAT" & state == "GUJARAT"
replace caste = "BAWA" if caste == "SADHU" & state == "GUJARAT"
replace caste = "SAMMA" if caste == "SAMA" & state == "GUJARAT"
replace caste = "SATHWARA" if caste == "SATHAWARA" & state == "GUJARAT"
replace caste = "SUTHAR" if caste == "SHUTHAR" & state == "GUJARAT"
replace caste = "SACHORA" if caste == "SOCHRA BRAHMIN" & state == "GUJARAT"
replace caste = "DARJI" if caste == "TAILOR" & state == "GUJARAT"
replace caste = "TALPADA" if caste == "TALDADA" & state == "GUJARAT"
replace caste = "VAGHRI" if caste == "VAGHARI" & state == "GUJARAT"
replace caste = "BAWAJI" if caste == "VAIRANGI BAWA" & state == "GUJARAT"
replace caste = "BAWAJI" if caste == "VAISNAV" & state == "GUJARAT"
replace caste = "VANAND" if caste == "VANAD" & state == "GUJARAT"
replace caste = "VANKAR" if caste == "VANAKAR" & state == "GUJARAT"
replace caste = "VANAND" if caste == "VANANDVAS" & state == "GUJARAT"
replace caste = "BANIA" if caste == "VANIA" & state == "GUJARAT"
replace caste = "VAGHRI" if caste == "WAGHRI" & state == "GUJARAT"

replace caste = "BAORI" if caste == "BAWARIA" & state == "HARYANA"
replace caste = "BRAHMAN" if caste == "BRAHIMAN" & state == "HARYANA"
replace caste = "CHHIMBA" if caste == "CHHIMBE" & state == "HARYANA"
replace caste = "DARZI" if caste == "DARJI" & state == "HARYANA"
replace caste = "GOSWAMI" if caste == "GOSAI" & state == "HARYANA"
replace caste = "JHINWAR" if caste == "JHEEMAR" & state == "HARYANA"
replace caste = "CHAARAJ" if caste == "MAHABRAHMAN" & state == "HARYANA"
replace caste = "RANGREZ" if caste == "RANGREJ" & state == "HARYANA"
replace caste = "RABARI" if caste == "REWARI" & state == "HARYANA"
replace caste = "SONAR" if caste == "SUNAR" & state == "HARYANA"
replace caste = "BANIYA" if caste == "VAISHYA" & state == "HARYANA"

replace caste = "ASUR" if caste == "ASHUR" & state == "JHARKHAND"
replace caste = "BADHAI" if caste == "BARHAI" & state == "JHARKHAND"
replace caste = "DUSADH" if caste == "DUSAD" & state == "JHARKHAND"
replace caste = "RAJPUT" if caste == "GANDRAP" & state == "JHARKHAND"
replace caste = "SUNDHI" if caste == "SUDHI" & state == "JHARKHAND"


replace caste = "CHALAVADI" if caste == "ADIDRAVIDA" & state == "KARNATAKA"
replace caste = "CHALAVADI" if caste == "ADIKARNATAKA" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "AMBIGA" & state == "KARNATAKA"
replace caste = "BALIJA" if caste == "BALAGIGA" & state == "KARNATAKA"
replace caste = "BALIJA" if caste == "BALIGAR" & state == "KARNATAKA"
replace caste = "BRAHMAN" if caste == "BAMAN" & state == "KARNATAKA"
replace caste = "LAMBANI" if caste == "BANJARA" & state == "KARNATAKA"
replace caste = "BHAVASAR" if caste == "BAVASAR" & state == "KARNATAKA"
replace caste = "BHAVASAR" if caste == "BAVASARKSHATRIYA" & state == "KARNATAKA"
replace caste = "BILLAVA" if caste == "BELAVVA" & state == "KARNATAKA"
replace caste = "DEWAR" if caste == "DAVAR" & state == "KARNATAKA"
replace caste = "DEVANGA" if caste == "DEVANGASHETTY" & state == "KARNATAKA"
replace caste = "CHALAVADI" if caste == "DRAVIDA" & state == "KARNATAKA"
replace caste = "DEWAR" if caste == "DWAR" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "GANGEMATA" & state == "KARNATAKA"
replace caste = "GANIGA" if caste == "GANIGER" & state == "KARNATAKA"
replace caste = "GONDHALI" if caste == "GODALI" & state == "KARNATAKA"
replace caste = "GONDA" if caste == "GONDAY" & state == "KARNATAKA"
replace caste = "VOKKALIGA" if caste == "GOWDA" & state == "KARNATAKA"
replace caste = "HELAVA" if caste == "HELAWAR" & state == "KARNATAKA"
replace caste = "KURUBA" if caste == "HINDUKRUBI" & state == "KARNATAKA"
replace caste = "LINGAYAT" if caste == "HINDULINGAYAT" & state == "KARNATAKA"
replace caste = "HOLEYA" if caste == "HOLAYA" & state == "KARNATAKA"
replace caste = "HOLEYA" if caste == "HOLER" & state == "KARNATAKA"
replace caste = "KAMBAR" if caste == "KANABAR" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "KOLI" & state == "KARNATAKA"
replace caste = "KORAMA" if caste == "KORAVARU" & state == "KARNATAKA"
replace caste = "KORAMA" if caste == "KORAWAR" & state == "KARNATAKA"
replace caste = "KORAMA" if caste == "KORMA" & state == "KARNATAKA"
replace caste = "CHRISTIAN" if caste == "KRISTAN" & state == "KARNATAKA"
replace caste = "KUMBARA" if caste == "KUMRAR" & state == "KARNATAKA"
replace caste = "KURUBA" if caste == "KURAVA" & state == "KARNATAKA"
replace caste = "MADAD" if caste == "MADAT" & state == "KARNATAKA"
replace caste = "MADDALA" if caste == "MADDUALA" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADEVASHASHETTY" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADHIVALA" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADIVALASHETTY" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADIWAL" & state == "KARNATAKA"
replace caste = "LINGAYAT" if caste == "MALAGAR" & state == "KARNATAKA"
replace caste = "LINGAYAT" if caste == "MALGAR" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MARIVALA" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYANAKBHIRYA" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYANAKSHATHRIYYAN" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYANKSHATRIYA" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYNAKISHTHRAJA" & state == "KARNATAKA"
replace caste = "BILLAVA" if caste == "PUJERI" & state == "KARNATAKA"
replace caste = "SUDUGADU SIDDARU" if caste == "S.SIDDARU" & state == "KARNATAKA"
replace caste = "SUDUGADU SIDDARU" if caste == "SUDIGADUSIDDHA" & state == "KARNATAKA"
replace caste = "SYRIAN" if caste == "SIRIAN" & state == "KARNATAKA"
replace caste = "SUNAGARA" if caste == "SUNAGAR" & state == "KARNATAKA"
replace caste = "SUNAGARA" if caste == "SWNAGAR" & state == "KARNATAKA"
replace caste = "UPPAR" if caste == "UDDAR" & state == "KARNATAKA"
replace caste = "UPPAR" if caste == "UPPARA" & state == "KARNATAKA"
replace caste = "UPPAR" if caste == "VDDAR" & state == "KARNATAKA"
replace caste = "ACHARI" if caste == "VISHWAKARMA" & state == "KARNATAKA"
replace caste = "WADDAR" if caste == "WADAR" & state == "KARNATAKA"
replace caste = "WADDAR" if caste == "WADEYAR" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "WALIKAR" & state == "KARNATAKA"

replace caste = "DHEEVARA" if caste == "ARAYAN" & state == "KERALA"
replace caste = "AMBATTAN" if caste == "BARBAR" & state == "KERALA"
replace caste = "DHEEVARA" if caste == "DWEEPARA" & state == "KERALA"
replace caste = "GAUD SARASWAT BRAHMAN" if caste == "G.S.B." & state == "KERALA"
replace caste = "GUPTAN" if caste == "GUPTHAN" & state == "KERALA"
replace caste = "NAIR" if caste == "HAIRUA" & state == "KERALA"
replace caste = "NAIR" if caste == "HINDU" & state == "KERALA"
replace caste = "NAIR" if caste == "MANNADIYAR" & state == "KERALA"
replace caste = "MAPPILA" if caste == "MAPPILLA" & state == "KERALA"
replace caste = "PATHAN" if caste == "MAPTHAN" & state == "KERALA"
replace caste = "MUDALIYAR" if caste == "MUDALI" & state == "KERALA"
replace caste = "NAMBUDIRI" if caste == "NAMBUDHIRI" & state == "KERALA"
replace caste = "PANAN" if caste == "PAANAN" & state == "KERALA"
replace caste = "CHERUMAN" if caste == "PALAYA" & state == "KERALA"
replace caste = "PANDARAM" if caste == "PANGARAM" & state == "KERALA"
replace caste = "PERUVANNAN" if caste == "PARA VANNAN" & state == "KERALA"
replace caste = "PARAVAR" if caste == "PARAVAN" & state == "KERALA"
replace caste = "BILAVA" if caste == "POOJARI" & state == "KERALA"
replace caste = "ROWTHER" if caste == "RAKITHAR" & state == "KERALA"
replace caste = "ROWTHER" if caste == "RANTHER" & state == "KERALA"
replace caste = "ROWTHER" if caste == "ROUTHER" & state == "KERALA"
replace caste = "THIYYA" if caste == "THIYA" & state == "KERALA"
replace caste = "VADUGAR" if caste == "VADUKKAR" & state == "KERALA"
replace caste = "DHEEVARA" if caste == "VALAN" & state == "KERALA"
replace caste = "CATHOLIC" if caste == "VANICAN" & state == "KERALA"
replace caste = "VADUGAR" if caste == "VARDUKA" & state == "KERALA"
replace caste = "VARIYAR" if caste == "VARRIYAR" & state == "KERALA"
replace caste = "VADUGAR" if caste == "VEDUVAR" & state == "KERALA"
replace caste = "DHEEVARA" if caste == "VELAN" & state == "KERALA"
replace caste = "ROWTHER" if caste == "YRAKITHER" & state == "KERALA"


replace caste = "BARHAI" if caste == "BADHAI" & state == "MADHYA PRADESH"
replace caste = "BASOR" if caste == "BASHOR" & state == "MADHYA PRADESH"
replace caste = "BELDAR" if caste == "BHUJWA" & state == "MADHYA PRADESH"
replace caste = "BINJHWAR" if caste == "BINJWAR" & state == "MADHYA PRADESH"
replace caste = "NAMDEV" if caste == "DARJI" & state == "MADHYA PRADESH"
replace caste = "SARASWAT BRAHMAN" if caste == "DOSANDHI" & state == "MADHYA PRADESH"
replace caste = "KALAR" if caste == "KALWAR" & state == "MADHYA PRADESH"
replace caste = "KALAR" if caste == "KOLWAR" & state == "MADHYA PRADESH"
replace caste = "BANJARA" if caste == "MAITHARE" & state == "MADHYA PRADESH"
replace caste = "MUSAHAR" if caste == "MUSHAR" & state == "MADHYA PRADESH"
replace caste = "SONAR" if caste == "SONI" & state == "MADHYA PRADESH"


replace caste = "BHOPE" if caste == "BHOEP" & state == "MAHARASHTRA"
replace caste = "BUDDHIST" if caste == "BUDDHA" & state == "MAHARASHTRA"
replace caste = "PARIT" if caste == "DHOBI" & state == "MAHARASHTRA"
replace caste = "HANBAR" if caste == "HANBER" & state == "MAHARASHTRA"
replace caste = "KOLI" if caste == "HOLI" & state == "MAHARASHTRA"
replace caste = "KHARVI" if caste == "KARVI" & state == "MAHARASHTRA"
replace caste = "KUNBI" if caste == "KUMBI" & state == "MAHARASHTRA"
replace caste = "MANE" if caste == "MANNE" & state == "MAHARASHTRA"
replace caste = "MANG" if caste == "MATANG" & state == "MAHARASHTRA"
replace caste = "CHATTRI" if caste == "PARDESI" & state == "MAHARASHTRA"
replace caste = "PARDHI" if caste == "PARDI" & state == "MAHARASHTRA"
replace caste = "PARDHAN" if caste == "PARDHSN" & state == "MAHARASHTRA"
replace caste = "WADHAI" if caste == "SUTAR" & state == "MAHARASHTRA"

replace caste = "ALIA" if caste == "ALIAL" & state == "ORISSA"
replace caste = "BADHAI" if caste == "BADHEI" & state == "ORISSA"
replace caste = "KANDARA" if caste == "BAISTAMBA" & state == "ORISSA"
replace caste = "CHASA" if caste == "BANGALI" & state == "ORISSA"
replace caste = "BANAYAT" if caste == "BENAYAT" & state == "ORISSA"
replace caste = "JOGI" if caste == "BHATERA" & state == "ORISSA"
replace caste = "BAURI" if caste == "BHOI" & state == "ORISSA"
replace caste = "DANDASI" if caste == "DANBASI" & state == "ORISSA"
replace caste = "DUMAL" if caste == "DUMA" & state == "ORISSA"
replace caste = "GOUD" if caste == "GAUD" & state == "ORISSA"
replace caste = "NAIR" if caste == "GHANTORA" & state == "ORISSA"
replace caste = "GOKHA" if caste == "GHUKHA" & state == "ORISSA"
replace caste = "MATIVANSA" if caste == "JYOTSKA" & state == "ORISSA"
replace caste = "KAIBARTA" if caste == "KAIBART" & state == "ORISSA"
replace caste = "KARANA" if caste == "KARAN" & state == "ORISSA"
replace caste = "KANDARA" if caste == "KENDARA" & state == "ORISSA"
replace caste = "KAIBARTA" if caste == "KEUTA" & state == "ORISSA"
replace caste = "KHARIA" if caste == "KHADIA" & state == "ORISSA"
replace caste = "KOLHA" if caste == "KHEJARI" & state == "ORISSA"
replace caste = "MAHANTY" if caste == "KHETRIYA" & state == "ORISSA"
replace caste = "KOLAH" if caste == "KOLAR" & state == "ORISSA"
replace caste = "KUILTA" if caste == "KULTA" & state == "ORISSA"
replace caste = "KUMHAR" if caste == "KUMBHAR" & state == "ORISSA"
replace caste = "NIARI" if caste == "NIHAR" & state == "ORISSA"
replace caste = "PANO" if caste == "PANA" & state == "ORISSA"
replace caste = "SHIA" if caste == "SIHAMUSLIM" & state == "ORISSA"
replace caste = "KANSARI" if caste == "THATARI" & state == "ORISSA"
replace caste = "POTALI BANIYA" if caste == "VAISYA" & state == "ORISSA"


replace caste = "BHARBHUNJA" if caste == "BHARBHOOJA" & state == "PUNJAB"
replace caste = "CHHIMBA" if caste == "CHHIMBE" & state == "PUNJAB"
replace caste = "CHAUDHRY" if caste == "CHOUDHARY" & state == "PUNJAB"
replace caste = "KUMHAR" if caste == "GHUMAIR" & state == "PUNJAB"
replace caste = "GOGNA" if caste == "GONGA" & state == "PUNJAB"
replace caste = "JATSIKH" if caste == "KAHTIYAL" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "KEHSAVRAJAN" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "KESHAVRAJPUT" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "KEWAT" & state == "PUNJAB"
replace caste = "MAHAR" if caste == "MAHER" & state == "PUNJAB"
replace caste = "MAHAR" if caste == "MARY" & state == "PUNJAB"
replace caste = "CHRISTIAN" if caste == "MASSEY" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "NISHAD" & state == "PUNJAB"
replace caste = "RAMGARIHA" if caste == "RAMGRHIA" & state == "PUNJAB"
replace caste = "SAHOTA" if caste == "SOHATA" & state == "PUNJAB"
replace caste = "SUNAR" if caste == "SWARNKAR" & state == "PUNJAB"
replace caste = "ARORA" if caste == "VAISHYA" & state == "PUNJAB"


replace caste = "BAWARIA" if caste == "BANWARI" & state == "RAJASTHAN"
replace caste = "BAORI" if caste == "BARI" & state == "RAJASTHAN"
replace caste = "BHARBHUNJA" if caste == "BHARBHOOJA" & state == "RAJASTHAN"
replace caste = "KOLI" if caste == "BUNKAR" & state == "RAJASTHAN"
replace caste = "DHOLI" if caste == "DHALI" & state == "RAJASTHAN"
replace caste = "GAUR" if caste == "GARUA" & state == "RAJASTHAN"
replace caste = "BANJARA" if caste == "GAWARIYA" & state == "RAJASTHAN"
replace caste = "GHANCHI" if caste == "GHACHI" & state == "RAJASTHAN"
replace caste = "GOSAIN" if caste == "GIRUI" & state == "RAJASTHAN"
replace caste = "GOSAIN" if caste == "GOSAI" & state == "RAJASTHAN"
replace caste = "LAKHARA" if caste == "KAKHERA" & state == "RAJASTHAN"
replace caste = "MAZHABI" if caste == "MAZABI" & state == "RAJASTHAN"
replace caste = "GOSWAMI" if caste == "PURI" & state == "RAJASTHAN"
replace caste = "DEWASI" if caste == "RABARI" & state == "RAJASTHAN"
replace caste = "RANA" if caste == "RAMA" & state == "RAJASTHAN"
replace caste = "MALI" if caste == "SAINIBRAHMAN" & state == "RAJASTHAN"
replace caste = "SOMRA" if caste == "SAMAR" & state == "RAJASTHAN"
replace caste = "SARGARA" if caste == "SARAGARA" & state == "RAJASTHAN"
replace caste = "SARAN" if caste == "SARYAN" & state == "RAJASTHAN"
replace caste = "SANSI" if caste == "SASUI" & state == "RAJASTHAN"


replace caste = "MUTHARAIYAR" if caste == "ABLAKAROR" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "ACHARY" & state == "TAMIL NADU"
replace caste = "PARAIYAR" if caste == "ADIDRAVIDA" & state == "TAMIL NADU"
replace caste = "AGAMUDAYAR" if caste == "AGAMUDIYAR" & state == "TAMIL NADU"
replace caste = "MUTHARAIYAR" if caste == "AMBALAAR" & state == "TAMIL NADU"
replace caste = "MUTHARAIYAR" if caste == "AMBALAM" & state == "TAMIL NADU"
replace caste = "ARCHAKAR" if caste == "ARCHAGAR" & state == "TAMIL NADU"
replace caste = "ARUNTHATHIYAR" if caste == "ARUNDUDHI" & state == "TAMIL NADU"
replace caste = "ARUNTHATHIYAR" if caste == "ARUNTHATHI" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "ASARI" & state == "TAMIL NADU"
replace caste = "PARAIYAR" if caste == "ATHIDRAVIDA" & state == "TAMIL NADU"
replace caste = "IYER" if caste == "AYYAR" & state == "TAMIL NADU"
replace caste = "ANDIPANDARAM" if caste == "BANDARAM" & state == "TAMIL NADU"
replace caste = "VANIYAR" if caste == "BANNIYAR" & state == "TAMIL NADU"
replace caste = "CHETTIAR" if caste == "CHETTIYAR" & state == "TAMIL NADU"
replace caste = "CHETTIAR" if caste == "CHETTY" & state == "TAMIL NADU"
replace caste = "KURAVAN" if caste == "CURAVAN" & state == "TAMIL NADU"
replace caste = "VANNAR" if caste == "DHOBI" & state == "TAMIL NADU"
replace caste = "THOLUVA" if caste == "DUBE" & state == "TAMIL NADU"
replace caste = "VELLALAR" if caste == "DULUVAR" & state == "TAMIL NADU"
replace caste = "IYER" if caste == "IYYAR" & state == "TAMIL NADU"
replace caste = "KARUNEEGAR" if caste == "KARUNEGAR" & state == "TAMIL NADU"
replace caste = "KONGU VELLALAR" if caste == "KAUVNDER" & state == "TAMIL NADU"
replace caste = "KRISHNA VAGA" if caste == "KRISHNANVAGAI" & state == "TAMIL NADU"
replace caste = "KURAVAN" if caste == "KULAVAR" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LABBARI" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LAPPA" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LAPPEE" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LEBBAI" & state == "TAMIL NADU"
replace caste = "PILLAI" if caste == "LILLAI" & state == "TAMIL NADU"
replace caste = "THEVAR" if caste == "MANYAKARAN" & state == "TAMIL NADU"
replace caste = "MOOPANAR" if caste == "MOOPNAR" & state == "TAMIL NADU"
replace caste = "MUDALIYAR" if caste == "MOTHALIAR" & state == "TAMIL NADU"
replace caste = "MOOPANAR" if caste == "MUPPAN" & state == "TAMIL NADU"
replace caste = "MOOPANAR" if caste == "MUPPAR" & state == "TAMIL NADU"
replace caste = "MUTHARAIYAR" if caste == "MUTHIRIAR" & state == "TAMIL NADU"
replace caste = "NAICKER" if caste == "NAIKAR" & state == "TAMIL NADU"
replace caste = "MARUTHUVAR" if caste == "NAVITHAR" & state == "TAMIL NADU"
replace caste = "MARUTHUVAR" if caste == "PANDITHAR" & state == "TAMIL NADU"
replace caste = "PARAIYAN" if caste == "PARAYAN" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "PATTHAR" & state == "TAMIL NADU"
replace caste = "PILLAI" if caste == "PILLAMER" & state == "TAMIL NADU"
replace caste = "KALLAR" if caste == "RAJALIAR" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "RAMMALAR" & state == "TAMIL NADU"
replace caste = "ROWTHER" if caste == "RAOUTHER" & state == "TAMIL NADU"
replace caste = "ROWTHER" if caste == "RAWHAR" & state == "TAMIL NADU"
replace caste = "REDDY" if caste == "REDDIYAR" & state == "TAMIL NADU"
replace caste = "SERVAI" if caste == "SERUAI" & state == "TAMIL NADU"
replace caste = "CHETTIAR" if caste == "SETIYAR" & state == "TAMIL NADU"
replace caste = "SAURASHTRA BRAHMIN" if caste == "SHAWRASTRA" & state == "TAMIL NADU"
replace caste = "VELLALAR" if caste == "SOLEYA" & state == "TAMIL NADU"
replace caste = "KURUKKAL" if caste == "THAYSIGAR" & state == "TAMIL NADU"
replace caste = "VALAYAR" if caste == "VALLALAR" & state == "TAMIL NADU"
replace caste = "VANNAR" if caste == "VANAR" & state == "TAMIL NADU"
replace caste = "VANNIYAR" if caste == "VANIYAR" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "VISHWAKARMA" & state == "TAMIL NADU"
replace caste = "YADAV" if caste == "YADAVAR" & state == "TAMIL NADU"

replace caste = "ARAKH" if caste == "AARAKH" & state == "UTTAR PRADESH"
replace caste = "HELA" if caste == "BANGALI" & state == "UTTAR PRADESH"
replace caste = "BHISHTI" if caste == "BHISTI" & state == "UTTAR PRADESH"
replace caste = "BHARBHUNJA" if caste == "BHURJI" & state == "UTTAR PRADESH"
replace caste = "BRIJBASI NAT" if caste == "BRIJBASINAT" & state == "UTTAR PRADESH"
replace caste = "BEHNA" if caste == "DHUNIYA" & state == "UTTAR PRADESH"
replace caste = "DUSADH" if caste == "DUSHAD" & state == "UTTAR PRADESH"
replace caste = "GOSAIN" if caste == "GOSAI" & state == "UTTAR PRADESH"
replace caste = "KAHAR" if caste == "KANHAR" & state == "UTTAR PRADESH"
replace caste = "KANDU" if caste == "KHANDU" & state == "UTTAR PRADESH"
replace caste = "LODHA" if caste == "LODH" & state == "UTTAR PRADESH"
replace caste = "LUNIA" if caste == "LUNIYA" & state == "UTTAR PRADESH"

replace caste = "KALU" if caste == "KAMLU" & state == "WEST BENGAL"
replace caste = "KOIBARTA" if caste == "KOIBARTR" & state == "WEST BENGAL"
replace caste = "KOL" if caste == "KOLHU" & state == "WEST BENGAL"
replace caste = "MAHISHYA" if caste == "MAHAISHYA" & state == "WEST BENGAL"
replace caste = "MOIRA" if caste == "MAYRA" & state == "WEST BENGAL"
replace caste = "TELI" if caste == "MUELLU" & state == "WEST BENGAL"
replace caste = "NUNIYA" if caste == "MUNIYA" & state == "WEST BENGAL"
replace caste = "NAMASUDRA" if caste == "NOMOSUDRA" & state == "WEST BENGAL"
replace caste = "SARNAKAR" if caste == "SARBJAR" & state == "WEST BENGAL"
replace caste = "SUNRI" if caste == "SURI" & state == "WEST BENGAL"
replace caste = "TANTUBAI" if caste == "TANTI" & state == "WEST BENGAL"
replace caste = "TANTUBAI" if caste == "TUNTUBAI" & state == "WEST BENGAL"
replace caste = "AGURI" if caste == "UGRAKSHTRIYA" & state == "WEST BENGAL"
replace caste = "KARMAKAR" if caste == "VARMAKAR" & state == "WEST BENGAL"

save redsmain

