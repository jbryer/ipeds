`ipeds`: R Package for Accessing the Integrated Postsecondary Education
Data System from R
================

<!-- 
[![Build Status](https://api.travis-ci.org/jbryer/ipeds.svg)](https://travis-ci.org/jbryer/ipeds?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/ipeds)](http://cran.r-project.org/package=ipeds)
![Downloads](http://cranlogs.r-pkg.org/badges/ipeds)
-->

#### Installation

<!--
The `ipeds` package can be downloaded from [CRAN](https://cran.r-project.org) as follows:


```r
install.packages('ipeds')
```
-->

To install the latest development version from Github use the
\`remotes\`\` package:

``` r
remotes::install_github('jbryer/ipeds')
```

On Linux or Mac, this package requires [mdbtools](https://github.com/brianb/mdbtools).
The following commands will install `mdbtools` on Mac:

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null \n')
    brew install mdbtools

On Windows, this package requires the Microsoft Access ODBC Driver. This driver comes with Microsoft Access. If you do not have Microsoft Access installed, or the Architecture differs from R (32bit vs 64bit), you can install the stand alone driver from [Microsoft](https://www.microsoft.com/en-us/download/details.aspx?id=54920)


#### Using the `ipeds` package

The vignette also has useful information for getting started:

``` r
vignette('ipeds')
```

The `available_ipeds` will return a `data.frame` indicating which
databases are available for download and my have already been
downloaded.

``` r
ipeds::available_ipeds()
```

    ## IPEDS data files will be downloaded to /Users/jbryer/Dropbox (Personal)/Projects/ipeds/data/downloaded/
    ## Use options("ipeds.download.dir" = "/PATH/TO/DOWNLOAD") to override this.

    ##    year year_string final provisional downloaded download_date download_size
    ## 1  2007     2006-07  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 2  2008     2007-08  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 3  2009     2008-09  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 4  2010     2009-10  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 5  2011     2010-11  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 6  2012     2011-12  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 7  2013     2012-13  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 8  2014     2013-14  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 9  2015     2014-15  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 10 2016     2015-16  TRUE        TRUE      FALSE          <NA>          <NA>
    ## 11 2017     2016-17  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 12 2018     2017-18  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 13 2019     2018-19  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 14 2020     2019-20  TRUE       FALSE      FALSE          <NA>          <NA>
    ## 15 2021     2020-21  TRUE        TRUE       TRUE    2023-02-15       55.6 MB
    ## 16 2022     2021-22 FALSE        TRUE      FALSE          <NA>          <NA>
    ## 17 2023     2022-23 FALSE       FALSE      FALSE          <NA>          <NA>

The `download_ipeds` will download an IPEDS database for a given year.

``` r
ipeds::download_ipeds(2021)
```

    ## Zip file already downloaded. Set force=TRUE to redownload.

    ## 34 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 
    ## 41 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 
    ## 87 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 
    ## 120 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 
    ## 13 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 
    ## 35 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 
    ## 13 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 
    ## 34 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 
    ## 111 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 
    ## 36 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 
    ## 115 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 
    ## 34 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 
    ## 35 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 
    ## 35 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 
    ## 56 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 
    ## 248 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 
    ## 36 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 
    ## 28 variables; Processing variable:1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28

The `load_ipeds` will return a list of all the survey tables (as
`data.frame`s) for the given year.

``` r
ipeds2021 <- ipeds::load_ipeds(2021)
names(ipeds2021)
```

    ##  [1] "ADM2020"         "C2020_A"         "C2020_B"         "C2020_C"        
    ##  [5] "C2020DEP"        "CUSTOMCGIDS2020" "DRVAL2020"       "DRVC2020"       
    ##  [9] "DRVEF122020"     "DRVEF2020"       "DRVF2020"        "DRVGR2020"      
    ## [13] "DRVIC2020"       "DRVOM2020"       "EAP2020"         "EF2020"         
    ## [17] "EF2020A"         "EF2020A_DIST"    "EF2020B"         "EF2020C"        
    ## [21] "EF2020D"         "EFFY2020"        "EFFY2020_DIST"   "EFIA2020"       
    ## [25] "F1920_F1A"       "F1920_F3"        "Filenames20"     "FLAGS2020"      
    ## [29] "GR200_20"        "GR2020"          "GR2020_L2"       "HD2020"         
    ## [33] "IC2020"          "IC2020_AY"       "IC2020_PY"       "IC2020Mission"  
    ## [37] "S2020_IS"        "S2020_NH"        "S2020_OC"        "S2020_SIS"      
    ## [41] "SAL2020_IS"      "sectiontable20"  "SFA1920_P1"      "SFA1920_P2"     
    ## [45] "SFAV1920"        "Tables20"        "valuesets20"     "vartable20"     
    ## [49] "AL2020"          "DRVADM2020"      "DRVHR2020"       "EF2020CP"       
    ## [53] "F1920_F2"        "GR2020_PELL_SSL" "OM2020"          "SAL2020_NIS"

The `ipeds_help` function will return the data dictionary for the given
year.

``` r
View(ipeds_help(year=2021))
```

If the `table` parameter is specified, then the data dictionary for the
given survey is returned (i.e. the variables in that table, see
`data(surveys)` for the available survey IDs).

``` r
View(ipeds_help(table = 'HD', year = 2021))
```

To load a specific table, the `ipeds_survey` function will return a
`data.frame` with the data.

``` r
hd2021 <- ipeds::ipeds_survey(table = 'HD', year = 2021)
names(hd2021)
```

    ##  [1] "UNITID"   "INSTNM"   "IALIAS"   "ADDR"     "CITY"     "STABBR"  
    ##  [7] "ZIP"      "FIPS"     "OBEREG"   "CHFNM"    "CHFTITLE" "GENTELE" 
    ## [13] "EIN"      "DUNS"     "OPEID"    "OPEFLAG"  "WEBADDR"  "ADMINURL"
    ## [19] "FAIDURL"  "APPLURL"  "NPRICURL" "VETURL"   "ATHURL"   "DISAURL" 
    ## [25] "SECTOR"   "ICLEVEL"  "CONTROL"  "HLOFFER"  "UGOFFER"  "GROFFER" 
    ## [31] "HDEGOFR1" "DEGGRANT" "HBCU"     "HOSPITAL" "MEDICAL"  "TRIBAL"  
    ## [37] "LOCALE"   "OPENPUBL" "ACT"      "NEWID"    "DEATHYR"  "CLOSEDAT"
    ## [43] "CYACTIVE" "POSTSEC"  "PSEFLAG"  "PSET4FLG" "RPTMTH"   "INSTCAT" 
    ## [49] "C18BASIC" "C18IPUG"  "C18IPGRD" "C18UGPRF" "C18ENPRF" "C18SZSET"
    ## [55] "C15BASIC" "CCBASIC"  "CARNEGIE" "LANDGRNT" "INSTSIZE" "F1SYSTYP"
    ## [61] "F1SYSNAM" "F1SYSCOD" "CBSA"     "CBSATYPE" "CSA"      "NECTA"   
    ## [67] "COUNTYCD" "COUNTYNM" "CNGDSTCD" "LONGITUD" "LATITUDE" "DFRCGID" 
    ## [73] "DFRCUSCG"

Mapping variable factors.

``` r
names(hd2021) <- tolower(names(hd2021))
hd2021 <- ipeds::recodeDirectory(hd2021)

IvyLeague <- c("186131","190150","166027","130794","215062","182670","217156","190415")
hd2021.ivy <- hd2021[which(hd2021$unitid %in%IvyLeague),]
p <- hd2021.ivy[, c("instnm", "webaddr", "stabbr", "control")]
names(p) <- c("Institution", "Web Address", "State", "Sector")
p
```

    ##                                      Institution           Web Address State
    ## 638                              Yale University https://www.yale.edu/    CT
    ## 1511                          Harvard University      www.harvard.edu/    MA
    ## 1982                           Dartmouth College    www.dartmouth.edu/    NH
    ## 2050                        Princeton University    www.princeton.edu/    NJ
    ## 2163 Columbia University in the City of New York     www.columbia.edu/    NY
    ## 2169                          Cornell University      www.cornell.edu/    NY
    ## 2979                  University of Pennsylvania        www.upenn.edu/    PA
    ## 3058                            Brown University        www.brown.edu/    RI
    ##                      Sector
    ## 638  Private not-for-profit
    ## 1511 Private not-for-profit
    ## 1982 Private not-for-profit
    ## 2050 Private not-for-profit
    ## 2163 Private not-for-profit
    ## 2169 Private not-for-profit
    ## 2979 Private not-for-profit
    ## 3058 Private not-for-profit

Use the enrollment survey data.

``` r
enrollment <- ipeds::ipeds_survey(table = 'EFFY', year = 2021)
names(enrollment) <- tolower(names(enrollment))

enrollment <- enrollment[which(enrollment$unitid %in% c(IvyLeague) ),]
enrollment <- merge(enrollment, hd2021[, c("unitid", "instnm", "control")], by = "unitid", all.x = TRUE, sort = FALSE)
enrollment <- enrollment[which(enrollment[,"effylev"] == 1),] # Level 1 is Undergraduate

p <- enrollment[, c("instnm", "efytotlt", "control")]
names(p) <- c("Institution", "Total Undergraduate Enrollment", "Sector")
p
```

    ##                                     Institution Total Undergraduate Enrollment
    ## 1                               Yale University                          14910
    ## 28                           Harvard University                          41024
    ## 46                            Dartmouth College                           7177
    ## 69                         Princeton University                           8532
    ## 100 Columbia University in the City of New York                          33882
    ## 110                          Cornell University                          24594
    ## 134                  University of Pennsylvania                          30688
    ## 146                            Brown University                          10807
    ##                     Sector
    ## 1   Private not-for-profit
    ## 28  Private not-for-profit
    ## 46  Private not-for-profit
    ## 69  Private not-for-profit
    ## 100 Private not-for-profit
    ## 110 Private not-for-profit
    ## 134 Private not-for-profit
    ## 146 Private not-for-profit
