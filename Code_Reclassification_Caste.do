* Caste Reclassification

* Data - REDS 2006
 
* Author - Parijat Maitra

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
* If the subcastes' data were not available for these castes, I chose to keep them in their original form.
* All of these castes have been thoroughly documented.

set more off
use main

* Aryavysya -> Komati since, Komati is the more widely used name.
replace caste = "KOMATI" if caste == "ARYAVYSYA" & state == "ANDHRA PRADESH"

* Barber castes are known as Mangali in Andhra Pradesh
replace caste = "MANGALI" if caste == "BARBER" & state == "ANDHRA PRADESH"

* Bathula -> Battala - Misspelling
replace caste = "BATTALA" if caste == "BATHULA" & state == "ANDHRA PRADESH"

* Camsula -> Kamasali, Misspelling
replace caste = "KAMASALI" if caste == "CAMSULA" & state == "ANDHRA PRADESH"

* Rajaka is the official name for the Dhobi caste in Andhra; also known by Chakala/ Chakali

replace caste = "RAJAKA" if caste == "CHAKALA" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "CHAKALI" & state == "ANDHRA PRADESH"
replace caste = "RAJAKA" if caste == "DHOBI" & state == "ANDHRA PRADESH"

* Fishermen caste is called Bestha in Andhra
replace caste = "BESTHA" if caste == "FISHERS" & state == "ANDHRA PRADESH"

* Kalasali, Kamsali -> Kamasali, misspellings
replace caste = "KAMASALI" if caste == "KALASALI" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "KAMSALI" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "KAMASALA" & state == "ANDHRA PRADESH"


* Kama -> Kamma, misspellings
replace caste = "KAMMA" if caste == "KAMA" & state == "ANDHRA PRADESH"

* Kammara -> Kamasali, they refer to the same caste & Kamasali is the more widely used name(official name).

replace caste = "KAMASALI" if caste == "KAMMARA" & state == "ANDHRA PRADESH"

* Kapuvelama, Kolli, Koppalavelama, Kopplavelama & Kuppalavelama -> Velama,they refer to the same caste & Velama is the more widely used name (official name).
replace caste = "VELAMA" if caste == "KAPUVELAMA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KOLLI" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KOPPALAVELAMA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KOPPLAVELAMA" & state == "ANDHRA PRADESH"
replace caste = "VELAMA" if caste == "KUPPALAVELAMA" & state == "ANDHRA PRADESH"

* Mandivili -> Rajaka, they refer to the same caste & Rajaka is the more widely used name(official name).
replace caste = "RAJAKA" if caste == "MADIVILI" & state == "ANDHRA PRADESH"

* Mandiga -> Madiga, misspelling.
replace caste = "MADIGA" if caste == "MANDIGA" & state == "ANDHRA PRADESH"

* Marwadi -> Rajasthani, they refer to the same caste & Rajasthani is the more widely used name(official name).
replace caste = "RAJASTHANI" if caste == "MARWADI" & state == "ANDHRA PRADESH"

* Modugu -> Madiga, they refer to the same caste & Madiga is the more widely used name(official name).
replace caste = "MADIGA" if caste == "MODUGU" & state == "ANDHRA PRADESH"

* Naybrahmanalu, Mangala -> Mangali, they refer to the same caste & Mangali is the more widely used name(official name). 
replace caste = "MANGALI" if caste == "NAYBRAHMANULU" & state == "ANDHRA PRADESH"
replace caste = "MANGALI" if caste == "MANGALA" & state == "ANDHRA PRADESH"

* Palikapu -> Kapu, they refer to the same caste & Kapu is the more widely used name(official name).
replace caste = "KAPU" if caste == "PALIKAPU" & state == "ANDHRA PRADESH"

* Pujari Brahmin caste is known as Archakulu in Andhra
replace caste = "ARCHAKULU" if caste == "PUJARI" & state == "ANDHRA PRADESH"

* Rajakulu -> Rajaka, they refer to the same caste & Rajaka is the more widely used name(official name).
replace caste = "RAJAKA" if caste == "RAJAKULU" & state == "ANDHRA PRADESH"

* Rajulu -> Odde, they refer to the same caste & Odde is the more widely used name(official name).
replace caste = "ODDE" if caste == "RAJULU" & state == "ANDHRA PRADESH"

* Sakala -> Rajaka, they refer to the same caste & Rajaka is the more widely used name(official name).
replace caste = "RAJAKA" if caste == "SAKALA" & state == "ANDHRA PRADESH"

* Sali, Salilu -> Padmasali, they refer to the same caste & padmasali is the more widely used name(official name).
replace caste = "PADMASALI" if caste == "SALI" & state == "ANDHRA PRADESH"
replace caste = "PADMASALI" if caste == "SALILU" & state == "ANDHRA PRADESH"

* Telagamamdelu -> Kapu, they refer to the same caste & Kapu is the more widely used name(official name).
replace caste = "KAPU" if caste == "TELAGAMAMDELU" & state == "ANDHRA PRADESH"

* Teli, Teluku, Tentkalu -> Telakula, they refer to the same caste & Telakula is the more widely used name(official name).
replace caste = "TELAKULA" if caste == "TELI" & state == "ANDHRA PRADESH"
replace caste = "TELAKULA" if caste == "TELUKU" & state == "ANDHRA PRADESH"
replace caste = "TELAKULA" if caste == "TENTKALU" & state == "ANDHRA PRADESH"

* Vaddi, vadi -> Odde, they refer to the same caste & Odde is the more widely used name(official name).
replace caste = "ODDE" if caste == "VADDI" & state == "ANDHRA PRADESH"
replace caste = "ODDE" if caste == "VADI" & state == "ANDHRA PRADESH"

* Vedava -> Yadav, they refer to the same caste & Yadav is the more widely used name(official name).
replace caste = "YADAV" if caste == "VEDAVA" & state == "ANDHRA PRADESH"

* Visali -> Visalu, misspelling
replace caste = "VISALU" if caste == "VISALI" & state == "ANDHRA PRADESH"

* Vishnu, ViswaBrahman, Vysya -> Kamsali, they refer to the same caste & Kamsali is the more widely used name(official name).
replace caste = "KAMASALI" if caste == "VISHNU" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "VISWABRAHAMAN" & state == "ANDHRA PRADESH"
replace caste = "KAMASALI" if caste == "VYSYA" & state == "ANDHRA PRADESH"

* Yalama -> Velama, misspelling
replace caste = "VELAMA" if caste == "YALAMA" & state == "ANDHRA PRADESH"

* Yeava -> Yadav, misspelling
replace caste = "YADAV" if caste == "YEAVA" & state == "ANDHRA PRADESH"

* Yerkula, Yerukula -> Yerukala, ,misspelling
replace caste = "YERUKALA" if caste == "YERKULA" & state == "ANDHRA PRADESH"
replace caste = "YERUKALA" if caste == "YERUKULA" & state == "ANDHRA PRADESH"

* Brahamin -> Brahman, misspelling
replace caste = "BRAHMAN" if caste == "BRAHAMIN" & state == "BIHAR"

* Gund -> Gond, misspelling
replace caste = "GOND" if caste == "GUND" & state == "BIHAR"

* Sahu -> Teli, they refer to the same caste & Teli is the more widely used name(official name).
replace caste = "TELI" if caste == "SAHU" & state == "BIHAR"

* Tanti -> Tatwa, they refer to the same caste & Tatwa is the more widely used name(official name).
replace caste = "TATWA" if caste == "TANTI" & state == "BIHAR"

* Viswakarma -> Lohar, they refer to the same caste & Lohar is the more widely used name(official name).
replace caste = "LOHAR" if caste == "VISHWAKARMA" & state == "BIHAR"

* Das -> Panika, they refer to the same caste & Panika is the more widely used name(official name).
replace caste = "PANIKA" if caste == "DAS" & state == "CHHATTISGARH"

* Gadaria -> Gadariya, misspelling
replace caste = "GADARIYA" if caste == "GADARIA" & state == "CHHATTISGARH"

* Kallar -> Kalwar, misspelling
replace caste = "KALWAR" if caste == "KALLAR" & state == "CHHATTISGARH"

* Kawar -> Kanwar, they refer to the same caste & Kanwar is the more widely used name(official name).
replace caste = "KANWAR" if caste == "KAWAR" & state == "CHHATTISGARH"

* Bajir, Bhajir -> Vajir, misspelling
replace caste = "VAJIR" if caste == "BAJIR" & state == "GUJARAT"
replace caste = "VAJIR" if caste == "BHAJIR" & state == "GUJARAT"

* Bavaji -> Bawaji, misspelling
replace caste = "BAWAJI" if caste == "BAVAJI" & state == "GUJARAT"

* Bhanushail -> Bhanushali, misspelling
replace caste = "BHANUSHALI" if caste == "BHANUSHAIL" & state == "GUJARAT"

* Bharvad -> Bharwad, misspelling
replace caste = "BHARWAD" if caste == "BHARVAD" & state == "GUJARAT"

* Choudhari -> Chaudhri, misspelling
replace caste = "CHAUDHRI" if caste == "CHOUDHARI" & state == "GUJARAT"

* Devipujak -> Vaghri, they refer to the same caste & Vaghri is the more widely used name(official name).
replace caste = "VAGHRI" if caste == "DEVIPUJAK" & state == "GUJARAT"

* Hindu Halpati & Hindu Kumbhar were wrongly assigned as different caste groups; they were merged into the respective parent group
replace caste = "HALPATI" if caste == "HINDU HALPATI" & state == "GUJARAT"
replace caste = "KUMBHAR" if caste == "HINDU KUMBHAR" & state == "GUJARAT"

* Kalarai -> Patel, they refer to the same caste & Patel is the more widely used name(official name).
replace caste = "PATEL" if caste == "KALARIA" & state == "GUJARAT"

* Kathlik -> Catholic, misspelling
replace caste = "CATHOLIC" if caste == "KATHLIK" & state == "GUJARAT"

* Kohli -> Koli, misspelling
replace caste = "KOLI" if caste == "KOHLI" & state == "GUJARAT"

* Malwana -> Makwana, misspelling
replace caste = "MAKWANA" if caste == "MALWANA" & state == "GUJARAT"

* Nat -> Bajaniya, they refer to the same caste & Bajaniya is the more widely used name(official name).
replace caste = "BAJANIYA" if caste == "NAT" & state == "GUJARAT"

* Sadhu -> Bawa, they refer to the same caste & Bawa is the more widely used name(official name).
replace caste = "BAWA" if caste == "SADHU" & state == "GUJARAT"

* Sama -> Samma, misspelling
replace caste = "SAMMA" if caste == "SAMA" & state == "GUJARAT"

* Sathawara -> Sathwara, misspelling
replace caste = "SATHWARA" if caste == "SATHAWARA" & state == "GUJARAT"

* Shuthar -> Suthar, misspelling
replace caste = "SUTHAR" if caste == "SHUTHAR" & state == "GUJARAT"

* Sochra Brahmin -> Sachora, misspelling
replace caste = "SACHORA" if caste == "SOCHRA BRAHMIN" & state == "GUJARAT"

* Tailor caste is known as Darji in Gujarat
replace caste = "DARJI" if caste == "TAILOR" & state == "GUJARAT"

* Taldada -> Talpada, misspelling
replace caste = "TALPADA" if caste == "TALDADA" & state == "GUJARAT"

* Vaghari, Waghri -> Vaghri, misspelling
replace caste = "VAGHRI" if caste == "VAGHARI" & state == "GUJARAT"
replace caste = "VAGHRI" if caste == "WAGHRI" & state == "GUJARAT"

* Vaisnav, Vairangi Bawa -> Bawaji, they refer to the same caste & Bawaji is the more widely used name(official name).
replace caste = "BAWAJI" if caste == "VAIRANGI BAWA" & state == "GUJARAT"
replace caste = "BAWAJI" if caste == "VAISNAV" & state == "GUJARAT"

* Vanad -> Vanand, misspelling
replace caste = "VANAND" if caste == "VANAD" & state == "GUJARAT"

* Vanakar -> Vankar, misspelling
replace caste = "VANKAR" if caste == "VANAKAR" & state == "GUJARAT"

* Vanandvas -> Vanand, misspelling
replace caste = "VANAND" if caste == "VANANDVAS" & state == "GUJARAT"

* Vania -> Bania, misspelling
replace caste = "BANIA" if caste == "VANIA" & state == "GUJARAT"


* Bawaria -> Baori, they refer to the same caste & Baori is the more widely used name(official name).
replace caste = "BAORI" if caste == "BAWARIA" & state == "HARYANA"

* Brahiman -> Brahman, misspelling
replace caste = "BRAHMAN" if caste == "BRAHIMAN" & state == "HARYANA"

* Chhimbe -> Chhimba, misspelling
replace caste = "CHHIMBA" if caste == "CHHIMBE" & state == "HARYANA"

* Darji -> Darzi, misspelling
replace caste = "DARZI" if caste == "DARJI" & state == "HARYANA"

* Gosai -> Goswami, they refer to the same caste & Goswami is the more widely used name(official name).
replace caste = "GOSWAMI" if caste == "GOSAI" & state == "HARYANA"

* Jheemar -> Jhinwar, they refer to the same caste & Jhinwar is the more widely used name(official name).
replace caste = "JHINWAR" if caste == "JHEEMAR" & state == "HARYANA"

*Mahabrahman -> Chaaraj, they refer to the same caste & Chaaraj is the more widely used name(official name).
replace caste = "CHAARAJ" if caste == "MAHABRAHMAN" & state == "HARYANA"

* Rangrej -> Rangrez, misspelling
replace caste = "RANGREZ" if caste == "RANGREJ" & state == "HARYANA"

* Rewari -> Rabari, they refer to the same caste & Rabari is the more widely used name(official name).
replace caste = "RABARI" if caste == "REWARI" & state == "HARYANA"

* Sunar -> Sonar, misspelling
replace caste = "SONAR" if caste == "SUNAR" & state == "HARYANA"

* Vaishya -> Baniya, they refer to the same caste & Baniya is the more widely used name(official name).
replace caste = "BANIYA" if caste == "VAISHYA" & state == "HARYANA"

* Ashur -> Asur, misspelling
replace caste = "ASUR" if caste == "ASHUR" & state == "JHARKHAND"

* Barhai -> Badhai, misspelling
replace caste = "BADHAI" if caste == "BARHAI" & state == "JHARKHAND"

* Dusad -> Dusadh, misspelling
replace caste = "DUSADH" if caste == "DUSAD" & state == "JHARKHAND"

* Gandrap -> Rajput, they refer to the same caste & Rajput is the more widely used name(official name).
replace caste = "RAJPUT" if caste == "GANDRAP" & state == "JHARKHAND"

* Sudhi -> Sundhi, misspelling
replace caste = "SUNDHI" if caste == "SUDHI" & state == "JHARKHAND"

* Adidravida, adikarnataka, dravida -> Chalavadi, they refer to the same caste & Chalavadi is the more widely used name(official name).
replace caste = "CHALAVADI" if caste == "ADIDRAVIDA" & state == "KARNATAKA"
replace caste = "CHALAVADI" if caste == "ADIKARNATAKA" & state == "KARNATAKA"
replace caste = "CHALAVADI" if caste == "DRAVIDA" & state == "KARNATAKA"

* Ambiga, walikar, gangemata, koli -> Bestha, they refer to the same caste & Bestha is the more widely used name(official name).
replace caste = "BESTHA" if caste == "AMBIGA" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "WALIKAR" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "GANGEMATA" & state == "KARNATAKA"
replace caste = "BESTHA" if caste == "KOLI" & state == "KARNATAKA"

* Balagiga, Baligar -> Balija, they refer to the same caste & Balija is the more widely used name(official name).
replace caste = "BALIJA" if caste == "BALAGIGA" & state == "KARNATAKA"
replace caste = "BALIJA" if caste == "BALIGAR" & state == "KARNATAKA"

* Baman -> Brahman, misspelling
replace caste = "BRAHMAN" if caste == "BAMAN" & state == "KARNATAKA"

* Banjara -> Lambani, they refer to the same caste & Lambani is the more widely used name(official name).
replace caste = "LAMBANI" if caste == "BANJARA" & state == "KARNATAKA"

* Bavasar, Bavasarkshatriya -> Bhavasar, they refer to the same caste & Bhavasar is the more widely used name(official name).
replace caste = "BHAVASAR" if caste == "BAVASAR" & state == "KARNATAKA"
replace caste = "BHAVASAR" if caste == "BAVASARKSHATRIYA" & state == "KARNATAKA"

* Belavva, Pujeri -> Billava, they refer to the same caste & Billava is the more widely used name(official name).
replace caste = "BILLAVA" if caste == "BELAVVA" & state == "KARNATAKA"
replace caste = "BILLAVA" if caste == "PUJERI" & state == "KARNATAKA"

* Davar, Dwar -> Dewar, they refer to the same caste & Dewar is the more widely used name(official name).
replace caste = "DEWAR" if caste == "DAVAR" & state == "KARNATAKA"
replace caste = "DEWAR" if caste == "DWAR" & state == "KARNATAKA"

* Devangashetty -> Devanga, they refer to the same caste & Devanga is the more widely used name(official name).
replace caste = "DEVANGA" if caste == "DEVANGASHETTY" & state == "KARNATAKA"

* Ganiger -> Ganiga, misspelling
replace caste = "GANIGA" if caste == "GANIGER" & state == "KARNATAKA"

* Godali -> Gondhali, misspelling
replace caste = "GONDHALI" if caste == "GODALI" & state == "KARNATAKA"

* Gonday -> Gonda, misspelling
replace caste = "GONDA" if caste == "GONDAY" & state == "KARNATAKA"

* Gowda -> Vokkaliga, they refer to the same caste & Vokkaliga is the more widely used name(official name).
replace caste = "VOKKALIGA" if caste == "GOWDA" & state == "KARNATAKA"

* Helawar -> Helava, they refer to the same caste & Helava is the more widely used name(official name).
replace caste = "HELAVA" if caste == "HELAWAR" & state == "KARNATAKA"

* Hindukrubi, kurava -> Kuraba, they refer to the same caste & Kuraba is the more widely used name(official name).
replace caste = "KURUBA" if caste == "HINDUKRUBI" & state == "KARNATAKA"
replace caste = "KURUBA" if caste == "KURAVA" & state == "KARNATAKA"

* Holaya, Holer -> Holeya, they refer to the same caste & Holeya is the more widely used name(official name).
replace caste = "HOLEYA" if caste == "HOLAYA" & state == "KARNATAKA"
replace caste = "HOLEYA" if caste == "HOLER" & state == "KARNATAKA"

* Kanabar -> Kambar, they refer to the same caste & Kambar is the more widely used name(official name).
replace caste = "KAMBAR" if caste == "KANABAR" & state == "KARNATAKA"

* Koravaru, Korawar, Korma -> Korama, they refer to the same caste & Korama is the more widely used name(official name).
replace caste = "KORAMA" if caste == "KORAVARU" & state == "KARNATAKA"
replace caste = "KORAMA" if caste == "KORAWAR" & state == "KARNATAKA"
replace caste = "KORAMA" if caste == "KORMA" & state == "KARNATAKA"

* Kristan -> Christian, misspelling
replace caste = "CHRISTIAN" if caste == "KRISTAN" & state == "KARNATAKA"

* Kumrar -> Kumbara, misspelling
replace caste = "KUMBARA" if caste == "KUMRAR" & state == "KARNATAKA"

* Madat-> Madad, misspelling
replace caste = "MADAD" if caste == "MADAT" & state == "KARNATAKA"

* Madduala -> Maddala, misspelling
replace caste = "MADDALA" if caste == "MADDUALA" & state == "KARNATAKA"

* Madhevashashetty, madhivala, madivalashetty, madiwal, marivala -> Madivala, they refer to the same caste & Madivala is the more widely used name(official name).
replace caste = "MADIVALA" if caste == "MADEVASHASHETTY" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADHIVALA" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADIVALASHETTY" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MADIWAL" & state == "KARNATAKA"
replace caste = "MADIVALA" if caste == "MARIVALA" & state == "KARNATAKA"

* Hindulingayat, Malagar, Malgar -> Lingayat, they refer to the same caste & Lingayat is the more widely used name(official name).
replace caste = "LINGAYAT" if caste == "HINDULINGAYAT" & state == "KARNATAKA"
replace caste = "LINGAYAT" if caste == "MALAGAR" & state == "KARNATAKA"
replace caste = "LINGAYAT" if caste == "MALGAR" & state == "KARNATAKA"

* they refer to the same caste & Bhajantri is the more widely used name(official name).
replace caste = "BHAJANTRI" if caste == "NAYANAKBHIRYA" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYANAKSHATHRIYYAN" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYANKSHATRIYA" & state == "KARNATAKA"
replace caste = "BHAJANTRI" if caste == "NAYNAKISHTHRAJA" & state == "KARNATAKA"

* they refer to the same caste & Sudugadu Siddaru is the more widely used name(official name).
replace caste = "SUDUGADU SIDDARU" if caste == "S.SIDDARU" & state == "KARNATAKA"
replace caste = "SUDUGADU SIDDARU" if caste == "SUDIGADUSIDDHA" & state == "KARNATAKA"

* Sirian -> Syrian, misspelling
replace caste = "SYRIAN" if caste == "SIRIAN" & state == "KARNATAKA"

* Sunagar, Swnagar -> Sunagara, they refer to the same caste & Sunagara is the more widely used name(official name).
replace caste = "SUNAGARA" if caste == "SUNAGAR" & state == "KARNATAKA"
replace caste = "SUNAGARA" if caste == "SWNAGAR" & state == "KARNATAKA"

* Uddar, uppara, vddar - > Uppar, they refer to the same caste & Uppar is the more widely used name(official name).
replace caste = "UPPAR" if caste == "UDDAR" & state == "KARNATAKA"
replace caste = "UPPAR" if caste == "UPPARA" & state == "KARNATAKA"
replace caste = "UPPAR" if caste == "VDDAR" & state == "KARNATAKA"

* Viswakarma -> Achari, they refer to the same caste & Achari is the more widely used name(official name).
replace caste = "ACHARI" if caste == "VISHWAKARMA" & state == "KARNATAKA"

* Wadar, Wadeyar -> Waddar, they refer to the same caste & Waddar is the more widely used name(official name).
replace caste = "WADDAR" if caste == "WADAR" & state == "KARNATAKA"
replace caste = "WADDAR" if caste == "WADEYAR" & state == "KARNATAKA"


* barbar caste is known as Ambattan in Kerala
replace caste = "AMBATTAN" if caste == "BARBAR" & state == "KERALA"

* they refer to the same caste & Dheevara is the more widely used name(official name).
replace caste = "DHEEVARA" if caste == "ARAYAN" & state == "KERALA"
replace caste = "DHEEVARA" if caste == "DWEEPARA" & state == "KERALA"
replace caste = "DHEEVARA" if caste == "VALAN" & state == "KERALA"
replace caste = "DHEEVARA" if caste == "VELAN" & state == "KERALA"

* Full form of GSB is used.
replace caste = "GAUD SARASWAT BRAHMAN" if caste == "G.S.B." & state == "KERALA"

* Misspelling
replace caste = "GUPTAN" if caste == "GUPTHAN" & state == "KERALA"

* they refer to the same caste & Nair is the more widely used name(official name).
replace caste = "NAIR" if caste == "HAIRUA" & state == "KERALA"
replace caste = "NAIR" if caste == "HINDU" & state == "KERALA"
replace caste = "NAIR" if caste == "MANNADIYAR" & state == "KERALA"

* Misspelling
replace caste = "MAPPILA" if caste == "MAPPILLA" & state == "KERALA"

* Misspelling
replace caste = "PATHAN" if caste == "MAPTHAN" & state == "KERALA"

* they refer to the same caste & Mudaliyar is the more widely used name(official name).
replace caste = "MUDALIYAR" if caste == "MUDALI" & state == "KERALA"

* Misspelling
replace caste = "NAMBUDIRI" if caste == "NAMBUDHIRI" & state == "KERALA"

* Misspelling
replace caste = "PANAN" if caste == "PAANAN" & state == "KERALA"

* they refer to the same caste & Cheruman is the more widely used name(official name).
replace caste = "CHERUMAN" if caste == "PALAYA" & state == "KERALA"

* Misspelling
replace caste = "PANDARAM" if caste == "PANGARAM" & state == "KERALA"

* Misspelling
replace caste = "PERUVANNAN" if caste == "PARA VANNAN" & state == "KERALA"

* Misspelling
replace caste = "PARAVAR" if caste == "PARAVAN" & state == "KERALA"

* they refer to the same caste & Bilava is the more widely used name(official name).
replace caste = "BILAVA" if caste == "POOJARI" & state == "KERALA"

* they refer to the same caste & Rowther is the more widely used name(official name).
replace caste = "ROWTHER" if caste == "RAKITHAR" & state == "KERALA"
replace caste = "ROWTHER" if caste == "RANTHER" & state == "KERALA"
replace caste = "ROWTHER" if caste == "ROUTHER" & state == "KERALA"
replace caste = "ROWTHER" if caste == "YRAKITHER" & state == "KERALA"

* Misspelling
replace caste = "THIYYA" if caste == "THIYA" & state == "KERALA"

* they refer to the same caste & Vadugar is the more widely used name(official name).
replace caste = "VADUGAR" if caste == "VADUKKAR" & state == "KERALA"
replace caste = "VADUGAR" if caste == "VARDUKA" & state == "KERALA"
replace caste = "VADUGAR" if caste == "VEDUVAR" & state == "KERALA"

* Vanican(Vatican) -> Catholic
replace caste = "CATHOLIC" if caste == "VANICAN" & state == "KERALA"

* Misspelling
replace caste = "VARIYAR" if caste == "VARRIYAR" & state == "KERALA"



* Misspelling
replace caste = "BARHAI" if caste == "BADHAI" & state == "MADHYA PRADESH"

* Misspelling
replace caste = "BASOR" if caste == "BASHOR" & state == "MADHYA PRADESH"

* they refer to the same caste & Beldar is the more widely used name(official name).
replace caste = "BELDAR" if caste == "BHUJWA" & state == "MADHYA PRADESH"

* Misspelling
replace caste = "BINJHWAR" if caste == "BINJWAR" & state == "MADHYA PRADESH"

* Darji(tailor) caste is officially known as Namdev in M.P.
replace caste = "NAMDEV" if caste == "DARJI" & state == "MADHYA PRADESH"

* they refer to the same caste & Saraswat Brahman is the more widely used name(official name).
replace caste = "SARASWAT BRAHMAN" if caste == "DOSANDHI" & state == "MADHYA PRADESH"


* they refer to the same caste & Kalar is the more widely used name(official name).
replace caste = "KALAR" if caste == "KALWAR" & state == "MADHYA PRADESH"
replace caste = "KALAR" if caste == "KOLWAR" & state == "MADHYA PRADESH"

* they refer to the same caste & Banjara is the more widely used name(official name).
replace caste = "BANJARA" if caste == "MAITHARE" & state == "MADHYA PRADESH"

* Misspelling
replace caste = "MUSAHAR" if caste == "MUSHAR" & state == "MADHYA PRADESH"

* they refer to the same caste & Sonar is the more widely used name(official name).
replace caste = "SONAR" if caste == "SONI" & state == "MADHYA PRADESH"

* Misspelling
replace caste = "BHOPE" if caste == "BHOEP" & state == "MAHARASHTRA"

* Buddha -> Buddhist
replace caste = "BUDDHIST" if caste == "BUDDHA" & state == "MAHARASHTRA"

* Washerman caste(Dhobi) is officially called Parit in Maharashtra
replace caste = "PARIT" if caste == "DHOBI" & state == "MAHARASHTRA"

* Misspelling
replace caste = "HANBAR" if caste == "HANBER" & state == "MAHARASHTRA"

* Misspelling
replace caste = "KOLI" if caste == "HOLI" & state == "MAHARASHTRA"

* Misspelling
replace caste = "KHARVI" if caste == "KARVI" & state == "MAHARASHTRA"

* Misspelling
replace caste = "KUNBI" if caste == "KUMBI" & state == "MAHARASHTRA"

* Misspelling
replace caste = "MANE" if caste == "MANNE" & state == "MAHARASHTRA"

* they refer to the same caste & Mang is the more widely used name(official name).
replace caste = "MANG" if caste == "MATANG" & state == "MAHARASHTRA"

* they refer to the same caste & Chattri is the more widely used name(official name).
replace caste = "CHATTRI" if caste == "PARDESI" & state == "MAHARASHTRA"

* Misspelling
replace caste = "PARDHI" if caste == "PARDI" & state == "MAHARASHTRA"

* Misspelling
replace caste = "PARDHAN" if caste == "PARDHSN" & state == "MAHARASHTRA"

* they refer to the same caste & Wadhai is the more widely used name(official name).
replace caste = "WADHAI" if caste == "SUTAR" & state == "MAHARASHTRA"

* Misspelling
replace caste = "ALIA" if caste == "ALIAL" & state == "ORISSA"

* Misspelling
replace caste = "BADHAI" if caste == "BADHEI" & state == "ORISSA"

* they refer to the same caste & Kandara is the more widely used name(official name).
replace caste = "KANDARA" if caste == "BAISTAMBA" & state == "ORISSA"

* they refer to the same caste & Chasa is the more widely used name(official name).
replace caste = "CHASA" if caste == "BANGALI" & state == "ORISSA"

* Misspelling
replace caste = "BANAYAT" if caste == "BENAYAT" & state == "ORISSA"

* they refer to the same caste & Jogi is the more widely used name(official name).
replace caste = "JOGI" if caste == "BHATERA" & state == "ORISSA"

* they refer to the same caste & Bauri is the more widely used name(official name).
replace caste = "BAURI" if caste == "BHOI" & state == "ORISSA"

* Misspelling
replace caste = "DANDASI" if caste == "DANBASI" & state == "ORISSA"

* Misspelling
replace caste = "DUMAL" if caste == "DUMA" & state == "ORISSA"

* Misspelling
replace caste = "GOUD" if caste == "GAUD" & state == "ORISSA"

* they refer to the same caste & Nair is the more widely used name(official name).
replace caste = "NAIR" if caste == "GHANTORA" & state == "ORISSA"

* Misspelling
replace caste = "GOKHA" if caste == "GHUKHA" & state == "ORISSA"

* they refer to the same caste & Mativansa is the more widely used name(official name).
replace caste = "MATIVANSA" if caste == "JYOTSKA" & state == "ORISSA"

* they refer to the same caste & Kaibarta is the more widely used name(official name).
replace caste = "KAIBARTA" if caste == "KAIBART" & state == "ORISSA"
replace caste = "KAIBARTA" if caste == "KEUTA" & state == "ORISSA"

* Misspelling
replace caste = "KARANA" if caste == "KARAN" & state == "ORISSA"

* Misspelling
replace caste = "KANDARA" if caste == "KENDARA" & state == "ORISSA"

* Misspelling
replace caste = "KHARIA" if caste == "KHADIA" & state == "ORISSA"

* they refer to the same caste & Kolha is the more widely used name(official name).
replace caste = "KOLHA" if caste == "KHEJARI" & state == "ORISSA"

* they refer to the same caste & Mahanty is the more widely used name(official name).
replace caste = "MAHANTY" if caste == "KHETRIYA" & state == "ORISSA"

* Misspelling
replace caste = "KOLAH" if caste == "KOLAR" & state == "ORISSA"

* Misspelling
replace caste = "KUILTA" if caste == "KULTA" & state == "ORISSA"

* Misspelling
replace caste = "KUMHAR" if caste == "KUMBHAR" & state == "ORISSA"

* Misspelling
replace caste = "NIARI" if caste == "NIHAR" & state == "ORISSA"

* Misspelling
replace caste = "PANO" if caste == "PANA" & state == "ORISSA"

* Misspelling
replace caste = "SHIA" if caste == "SIHAMUSLIM" & state == "ORISSA"

* they refer to the same caste & Kansari is the more widely used name(official name).
replace caste = "KANSARI" if caste == "THATARI" & state == "ORISSA"

*they refer to the same caste & Potali Baniya is the more widely used name(official name).
replace caste = "POTALI BANIYA" if caste == "VAISYA" & state == "ORISSA"

* Misspelling
replace caste = "BHARBHUNJA" if caste == "BHARBHOOJA" & state == "PUNJAB"

* Misspelling
replace caste = "CHHIMBA" if caste == "CHHIMBE" & state == "PUNJAB"

* Misspelling
replace caste = "CHAUDHRY" if caste == "CHOUDHARY" & state == "PUNJAB"

* they refer to the same caste & Kumhar is the more widely used name(official name).
replace caste = "KUMHAR" if caste == "GHUMAIR" & state == "PUNJAB"

* Misspelling
replace caste = "GOGNA" if caste == "GONGA" & state == "PUNJAB"

* they refer to the same caste & Jatsikh is the more widely used name(official name).
replace caste = "JATSIKH" if caste == "KAHTIYAL" & state == "PUNJAB"


* they refer to the same caste & Kashyap Rajput is the more widely used name(official name).
replace caste = "KASHYAP RAJPUT" if caste == "KEHSAVRAJAN" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "KESHAVRAJPUT" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "KEWAT" & state == "PUNJAB"
replace caste = "KASHYAP RAJPUT" if caste == "NISHAD" & state == "PUNJAB"

* Misspellings
replace caste = "MAHAR" if caste == "MAHER" & state == "PUNJAB"
replace caste = "MAHAR" if caste == "MARY" & state == "PUNJAB"

* they refer to the same caste & Christian is the more widely used name(official name).
replace caste = "CHRISTIAN" if caste == "MASSEY" & state == "PUNJAB"

* Misspelling
replace caste = "RAMGARIHA" if caste == "RAMGRHIA" & state == "PUNJAB"

* Misspelling
replace caste = "SAHOTA" if caste == "SOHATA" & state == "PUNJAB"

* they refer to the same caste & Sunar is the more widely used name(official name).
replace caste = "SUNAR" if caste == "SWARNKAR" & state == "PUNJAB"

* they refer to the same caste & Arora is the more widely used name(official name).
replace caste = "ARORA" if caste == "VAISHYA" & state == "PUNJAB"

* they refer to the same caste & Bawaria is the more widely used name(official name).
replace caste = "BAWARIA" if caste == "BANWARI" & state == "RAJASTHAN"

* Misspelling
replace caste = "BAORI" if caste == "BARI" & state == "RAJASTHAN"

* Misspelling
replace caste = "BHARBHUNJA" if caste == "BHARBHOOJA" & state == "RAJASTHAN"

* they refer to the same caste & Koli is the more widely used name(official name).
replace caste = "KOLI" if caste == "BUNKAR" & state == "RAJASTHAN"

* Misspelling
replace caste = "DHOLI" if caste == "DHALI" & state == "RAJASTHAN"

* Misspelling
replace caste = "GAUR" if caste == "GARUA" & state == "RAJASTHAN"

* they refer to the same caste & Banjara is the more widely used name(official name).
replace caste = "BANJARA" if caste == "GAWARIYA" & state == "RAJASTHAN"

* Misspelling
replace caste = "GHANCHI" if caste == "GHACHI" & state == "RAJASTHAN"

* they refer to the same caste & Gosain is the more widely used name(official name).
replace caste = "GOSAIN" if caste == "GIRUI" & state == "RAJASTHAN"
replace caste = "GOSAIN" if caste == "GOSAI" & state == "RAJASTHAN"

* Misspelling
replace caste = "LAKHARA" if caste == "KAKHERA" & state == "RAJASTHAN"

* Misspelling
replace caste = "MAZHABI" if caste == "MAZABI" & state == "RAJASTHAN"

* they refer to the same caste & Goswami is the more widely used name(official name).
replace caste = "GOSWAMI" if caste == "PURI" & state == "RAJASTHAN"

* they refer to the same caste & Dewasi is the more widely used name(official name).
replace caste = "DEWASI" if caste == "RABARI" & state == "RAJASTHAN"

* Misspelling
replace caste = "RANA" if caste == "RAMA" & state == "RAJASTHAN"

* they refer to the same caste & Mali is the more widely used name(official name).
replace caste = "MALI" if caste == "SAINIBRAHMAN" & state == "RAJASTHAN"

* they refer to the same caste & Somra is the more widely used name(official name).
replace caste = "SOMRA" if caste == "SAMAR" & state == "RAJASTHAN"

* Misspelling
replace caste = "SARGARA" if caste == "SARAGARA" & state == "RAJASTHAN"

* Misspelling
replace caste = "SARAN" if caste == "SARYAN" & state == "RAJASTHAN"

* Misspelling
replace caste = "SANSI" if caste == "SASUI" & state == "RAJASTHAN"

* they refer to the same caste & Mutharaiyar is the more widely used name(official name).
replace caste = "MUTHARAIYAR" if caste == "ABLAKAROR" & state == "TAMIL NADU"
replace caste = "MUTHARAIYAR" if caste == "AMBALAAR" & state == "TAMIL NADU"
replace caste = "MUTHARAIYAR" if caste == "AMBALAM" & state == "TAMIL NADU"
replace caste = "MUTHARAIYAR" if caste == "MUTHIRIAR" & state == "TAMIL NADU"


* they refer to the same caste & Kammalar is the more widely used name(official name)+ Misspelling
replace caste = "KAMMALAR" if caste == "ACHARY" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "ASARI" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "PATTHAR" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "VISHWAKARMA" & state == "TAMIL NADU"
replace caste = "KAMMALAR" if caste == "RAMMALAR" & state == "TAMIL NADU"

* they refer to the same caste & Paraiyar is the more widely used name(official name).
replace caste = "PARAIYAR" if caste == "ADIDRAVIDA" & state == "TAMIL NADU"
replace caste = "PARAIYAR" if caste == "ATHIDRAVIDA" & state == "TAMIL NADU"

* Misspelling
replace caste = "AGAMUDAYAR" if caste == "AGAMUDIYAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "ARCHAKAR" if caste == "ARCHAGAR" & state == "TAMIL NADU"

* they refer to the same caste & Arunthatiyar is the more widely used name(official name).
replace caste = "ARUNTHATHIYAR" if caste == "ARUNDUDHI" & state == "TAMIL NADU"
replace caste = "ARUNTHATHIYAR" if caste == "ARUNTHATHI" & state == "TAMIL NADU"

* Misspelling
replace caste = "IYER" if caste == "AYYAR" & state == "TAMIL NADU"
replace caste = "IYER" if caste == "IYYAR" & state == "TAMIL NADU"

* they refer to the same caste & Aandipandaram is the more widely used name(official name).
replace caste = "ANDIPANDARAM" if caste == "BANDARAM" & state == "TAMIL NADU"

* Misspelling
replace caste = "VANIYAR" if caste == "BANNIYAR" & state == "TAMIL NADU"

* they refer to the same caste & Chettiar is the more widely used name(official name).
replace caste = "CHETTIAR" if caste == "CHETTIYAR" & state == "TAMIL NADU"
replace caste = "CHETTIAR" if caste == "CHETTY" & state == "TAMIL NADU"

* Misspelling
replace caste = "KURAVAN" if caste == "CURAVAN" & state == "TAMIL NADU"

* they refer to the same caste & Vannar is the more widely used name(official name).
replace caste = "VANNAR" if caste == "VANAR" & state == "TAMIL NADU"
replace caste = "VANNAR" if caste == "DHOBI" & state == "TAMIL NADU"

* they refer to the same caste & Tholuva is the more widely used name(official name).
replace caste = "THOLUVA" if caste == "DUBE" & state == "TAMIL NADU"

* they refer to the same caste & Vellalar is the more widely used name(official name).
replace caste = "VELLALAR" if caste == "DULUVAR" & state == "TAMIL NADU"
replace caste = "VELLALAR" if caste == "SOLEYA" & state == "TAMIL NADU"

* Misspelling
replace caste = "KARUNEEGAR" if caste == "KARUNEGAR" & state == "TAMIL NADU"

* they refer to the same caste & Kongu Vellalar is the more widely used name(official name).
replace caste = "KONGU VELLALAR" if caste == "KAUVNDER" & state == "TAMIL NADU"

* Misspelling
replace caste = "KRISHNA VAGA" if caste == "KRISHNANVAGAI" & state == "TAMIL NADU"

* Misspelling
replace caste = "KURAVAN" if caste == "KULAVAR" & state == "TAMIL NADU"

* they refer to the same caste & Labbai is the more widely used name(official name).
replace caste = "LABBAI" if caste == "LABBARI" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LAPPA" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LAPPEE" & state == "TAMIL NADU"
replace caste = "LABBAI" if caste == "LEBBAI" & state == "TAMIL NADU"

* they refer to the same caste & Pillai is the more widely used name(official name)+ misspelling
replace caste = "PILLAI" if caste == "LILLAI" & state == "TAMIL NADU"
replace caste = "PILLAI" if caste == "PILLAMER" & state == "TAMIL NADU"

* they refer to the same caste & Thevar is the more widely used name(official name).
replace caste = "THEVAR" if caste == "MANYAKARAN" & state == "TAMIL NADU"


* they refer to the same caste & Moopanar is the more widely used name(official name)+ Misspelling
replace caste = "MOOPANAR" if caste == "MOOPNAR" & state == "TAMIL NADU"
replace caste = "MOOPANAR" if caste == "MUPPAN" & state == "TAMIL NADU"
replace caste = "MOOPANAR" if caste == "MUPPAR" & state == "TAMIL NADU"

* they refer to the same caste & Mudaliyar is the more widely used name(official name).
replace caste = "MUDALIYAR" if caste == "MOTHALIAR" & state == "TAMIL NADU"

* they refer to the same caste & Naicker is the more widely used name(official name).
replace caste = "NAICKER" if caste == "NAIKAR" & state == "TAMIL NADU"

* they refer to the same caste & Maruthuvar is the more widely used name(official name).
replace caste = "MARUTHUVAR" if caste == "NAVITHAR" & state == "TAMIL NADU"
replace caste = "MARUTHUVAR" if caste == "PANDITHAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "PARAIYAN" if caste == "PARAYAN" & state == "TAMIL NADU"

* they refer to the same caste & Kallar is the more widely used name(official name).
replace caste = "KALLAR" if caste == "RAJALIAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "ROWTHER" if caste == "RAOUTHER" & state == "TAMIL NADU"
replace caste = "ROWTHER" if caste == "RAWHAR" & state == "TAMIL NADU"

* they refer to the same caste & Reddy is the more widely used name(official name).
replace caste = "REDDY" if caste == "REDDIYAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "SERVAI" if caste == "SERUAI" & state == "TAMIL NADU"

* Misspelling
replace caste = "CHETTIAR" if caste == "SETIYAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "SAURASHTRA BRAHMIN" if caste == "SHAWRASTRA" & state == "TAMIL NADU"

* they refer to the same caste & Kurukkal is the more widely used name(official name).
replace caste = "KURUKKAL" if caste == "THAYSIGAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "VALAYAR" if caste == "VALLALAR" & state == "TAMIL NADU"

* Misspelling
replace caste = "VANNIYAR" if caste == "VANIYAR" & state == "TAMIL NADU"

* they refer to the same caste & Yadav is the more widely used name(official name).
replace caste = "YADAV" if caste == "YADAVAR" & state == "TAMIL NADU"


* Misspelling
replace caste = "ARAKH" if caste == "AARAKH" & state == "UTTAR PRADESH"

* they refer to the same caste & Hela is the more widely used name(official name).
replace caste = "HELA" if caste == "BANGALI" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "BHISHTI" if caste == "BHISTI" & state == "UTTAR PRADESH"

* they refer to the same caste & Bharbhunja is the more widely used name(official name).
replace caste = "BHARBHUNJA" if caste == "BHURJI" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "BRIJBASI NAT" if caste == "BRIJBASINAT" & state == "UTTAR PRADESH"

* they refer to the same caste & Behna is the more widely used name(official name).
replace caste = "BEHNA" if caste == "DHUNIYA" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "DUSADH" if caste == "DUSHAD" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "GOSAIN" if caste == "GOSAI" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "KAHAR" if caste == "KANHAR" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "KANDU" if caste == "KHANDU" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "LODHA" if caste == "LODH" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "LUNIA" if caste == "LUNIYA" & state == "UTTAR PRADESH"

* Misspelling
replace caste = "KALU" if caste == "KAMLU" & state == "WEST BENGAL"

* Misspelling
replace caste = "KOIBARTA" if caste == "KOIBARTR" & state == "WEST BENGAL"

* Misspelling
replace caste = "KOL" if caste == "KOLHU" & state == "WEST BENGAL"

* Misspelling
replace caste = "MAHISHYA" if caste == "MAHAISHYA" & state == "WEST BENGAL"

* Misspelling
replace caste = "MOIRA" if caste == "MAYRA" & state == "WEST BENGAL"

* they refer to the same caste & Teli is the more widely used name(official name).
replace caste = "TELI" if caste == "MUELLU" & state == "WEST BENGAL"

* Misspelling
replace caste = "NUNIYA" if caste == "MUNIYA" & state == "WEST BENGAL"

* Misspelling
replace caste = "NAMASUDRA" if caste == "NOMOSUDRA" & state == "WEST BENGAL"

* Misspelling
replace caste = "SARNAKAR" if caste == "SARBJAR" & state == "WEST BENGAL"

* Misspelling
replace caste = "SUNRI" if caste == "SURI" & state == "WEST BENGAL"

* they refer to the same caste & Tantubai is the more widely used name(official name)+ Misspelling
replace caste = "TANTUBAI" if caste == "TANTI" & state == "WEST BENGAL"
replace caste = "TANTUBAI" if caste == "TUNTUBAI" & state == "WEST BENGAL"

* they refer to the same caste & Aguri is the more widely used name(official name).
replace caste = "AGURI" if caste == "UGRAKSHTRIYA" & state == "WEST BENGAL"

* Misspelling
replace caste = "KARMAKAR" if caste == "VARMAKAR" & state == "WEST BENGAL"

save redsmain

* The End!
