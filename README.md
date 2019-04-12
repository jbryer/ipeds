### R Package for Accessing the Integrated Postsecondary Education Data System from R

<!-- 
[![Build Status](https://api.travis-ci.org/jbryer/ipeds.svg)](https://travis-ci.org/jbryer/ipeds?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/ipeds)](http://cran.r-project.org/package=ipeds)
![Downloads](http://cranlogs.r-pkg.org/badges/ipeds)
-->

#### Installation

The `ipeds` package can be downloaded from [CRAN](https://cran.r-project.org) as follows:

```
> install.packages('ipeds')
```

Or, you may wish to download the latest development version from Github using the `devtools` package:

```
> devtools::install_github('jbryer/ipeds')
```

This package requires [mdbtools](https://github.com/brianb/mdbtools). The following commands will install `mdbtools` on Mac:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null \n')
brew install mdbtools
```

#### Using the `ipeds` package

The vignette also has useful information for getting started:

```
vignette('ipeds')
```

The `available_ipeds` will return a `data.frame` indicating which databases are available for download and my have already been downloaded.

```
> ipeds::available_ipeds()

   year year_string final provisional downloaded download_date download_size
1  2007     2006-07  TRUE       FALSE      FALSE          <NA>          <NA>
2  2008     2007-08  TRUE       FALSE      FALSE          <NA>          <NA>
3  2009     2008-09  TRUE       FALSE      FALSE          <NA>          <NA>
4  2010     2009-10  TRUE       FALSE      FALSE          <NA>          <NA>
5  2011     2010-11  TRUE       FALSE      FALSE          <NA>          <NA>
6  2012     2011-12  TRUE       FALSE      FALSE          <NA>          <NA>
7  2013     2012-13  TRUE       FALSE       TRUE    2019-04-01         38 MB
8  2014     2013-14  TRUE       FALSE       TRUE    2019-04-01       37.6 MB
9  2015     2014-15  TRUE       FALSE       TRUE    2019-04-01       39.4 MB
10 2016     2015-16  TRUE        TRUE       TRUE    2019-04-01       48.8 MB
11 2017     2016-17  TRUE       FALSE       TRUE    2019-04-01       41.9 MB
12 2018     2017-18 FALSE        TRUE       TRUE    2019-04-01       50.7 MB
13 2019     2018-19 FALSE       FALSE      FALSE          <NA>          <NA>
```

The `download_ipeds` will download an IPEDS database for a given year.

```
> ipeds::download_ipeds(2018)
```

The `load_ipeds` will return a list of all the survey tables (as `data.frame`s) for the given year.

```
> ipeds2018 <- ipeds::load_ipeds(2018)
> names(ipeds2018)
 [1] "ADM2017"         "C2017_A"         "C2017_B"         "C2017_C"        
 [5] "C2017DEP"        "CUSTOMCGIDS2017" "DRVAL2017"       "DRVC2017"       
 [9] "DRVEF122017"     "DRVEF2017"       "DRVF2017"        "DRVGR2017"      
[13] "DRVIC2017"       "DRVOM2017"       "EAP2017"         "EF2017"         
[17] "EF2017A"         "EF2017A_DIST"    "EF2017B"         "EF2017C"        
[21] "EF2017D"         "EFFY2017"        "EFIA2017"        "F1617_F1A"      
[25] "F1617_F2"        "F1617_F3"        "Filenames17"     "FLAGS2017"      
[29] "GR200_17"        "GR2017"          "GR2017_L2"       "HD2017"         
[33] "IC2017"          "IC2017_AY"       "IC2017_PY"       "IC2017Mission"  
[37] "S2017_IS"        "S2017_NH"        "S2017_OC"        "S2017_SIS"      
[41] "SAL2017_IS"      "sectiontable17"  "SFA1617_P1"      "SFA1617_P2"     
[45] "SFAV1617"        "Tables17"        "valuesets17"     "AL2017"         
[49] "DRVADM2017"      "DRVHR2017"       "GR2017_PELL_SSL" "OM2017"         
[53] "SAL2017_NIS"     "vartable17"
```

The `ipeds_help` function will return the data dictionary for the given year.

```
> View(ipeds_help(2018))
```

If the `table` parameter is specified, then the data dictionary for the given survey is returned (i.e. the variables in that table, see `data(surveys)` for the available survey IDs).

```
View(ipeds_help(table = 'HD', year = 2018))
```

Finally, to load a specific table, the `ipeds_survey` function will return a `data.frame` with the data.

```
> hd2018 <- ipeds_survey(table = 'HD', year = 2018)
> names(hd2018)
 [1] "UNITID"   "INSTNM"   "IALIAS"   "ADDR"     "CITY"     "STABBR"   "ZIP"     
 [8] "FIPS"     "OBEREG"   "CHFNM"    "CHFTITLE" "GENTELE"  "EIN"      "DUNS"    
[15] "OPEID"    "OPEFLAG"  "WEBADDR"  "ADMINURL" "FAIDURL"  "APPLURL"  "NPRICURL"
[22] "VETURL"   "ATHURL"   "DISAURL"  "SECTOR"   "ICLEVEL"  "CONTROL"  "HLOFFER" 
[29] "UGOFFER"  "GROFFER"  "HDEGOFR1" "DEGGRANT" "HBCU"     "HOSPITAL" "MEDICAL" 
[36] "TRIBAL"   "LOCALE"   "OPENPUBL" "ACT"      "NEWID"    "DEATHYR"  "CLOSEDAT"
[43] "CYACTIVE" "POSTSEC"  "PSEFLAG"  "PSET4FLG" "RPTMTH"   "INSTCAT"  "C15BASIC"
[50] "C15IPUG"  "C15IPGRD" "C15UGPRF" "C15ENPRF" "C15SZSET" "CCBASIC"  "CARNEGIE"
[57] "LANDGRNT" "INSTSIZE" "F1SYSTYP" "F1SYSNAM" "F1SYSCOD" "CBSA"     "CBSATYPE"
[64] "CSA"      "NECTA"    "COUNTYCD" "COUNTYNM" "CNGDSTCD" "LONGITUD" "LATITUDE"
[71] "DFRCGID"  "DFRCUSCG"
```

