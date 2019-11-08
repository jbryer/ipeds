#' Access to the Integrated Postsecondary Education Data System (IPEDS)
#' 
#' @name ipeds-package
#' @docType package
#' @title Integrated Postsecondary Education Data System
#' @author \email{jason@@bryer.org}
#' @keywords package institutional research ipeds nces
#' @import RCurl
#' @importFrom Hmisc mdb.get
#' @importFrom utils download.file unzip browseURL data read.csv
NA

#' List of available surveys to load from IPEDS
#' 
#' @name surveys
#' @docType data
#' @format a data.frame with IPEDS survey IDs and titles.
#' @references National Center for Educational Statistics. Integrated 
#'      Postsecondary Education Data System \url{https://surveys.nces.ed.gov/ipeds/}
#' @keywords data
NA

#' Classification of Instructional Programs (CIP) Codes
#' 
#' The Classification of Instructional Programs (CIP) provides a taxonomic 
#' scheme that supports the accurate tracking and reporting of fields of study 
#' and program completions activity. CIP was originally developed by the 
#' U.S. Department of Education's National Center for Education Statistics (NCES) 
#' in 1980, with revisions occurring in 1985, 1990, and 2000.
#' 
#' @name cipcodes
#' @docType data
#' @format a data.frame with 2,318 observations of 8 variables.
#' @references National Center for Educational Statistics: https://nces.ed.gov/ipeds/cipcode
#' @keywords data
NA

#' Crosswalk of 2000 CIP codes to 2010 CIP codes
#'  
#' Maps the 2000 CIP codes with the 2010 CIP codes.
#' 
#' @name crosswalk 
#' @docType data
#' @format a data.frame with 2,202 observations of 6 variables.
#' @references NCES https://nces.ed.gov/ipeds/cipcode/crosswalk.aspx?y=55
#' @keywords data
NA

# Page containing the links to download the files.
ipeds.download.page <- 'https://nces.ed.gov/ipeds/use-the-data/download-access-database'
# File name fomrat: IPEDS_2017-18_Provisional.zip or IPEDS_2017-18_Final.zip
ipeds.base.url <- 'https://nces.ed.gov/ipeds/tablefiles/zipfiles/'
# Old URL. TODO: Remove in future version
ipedsDataUrl <- 'http://nces.ed.gov/ipeds/datacenter/data/'

utils::globalVariables(c('surveys', 'db'))

.onLoad <- function(libname, pkgname) {
	ethnicityLevels <<- c('HispanicAnyRace', 'AmericanIndianOrAlaskaNative', 'Asian', 
						  'BlackOrAfricanAmerican', 'NativeHawaiianOrPacificIslander', 
						  'White', 'TwoOrMoreRaces', 'NonresidentAlien', 
						  'RaceEthnicityUnknown')
	genderLevels <<- c('Male', 'Female')
	if(is.null(getOption('ipeds.download.dir'))) {
		dir <- paste0(system.file(package="ipeds"), '/data/downloaded/')
		packageStartupMessage(paste0('IPEDS data files will be downloaded to ', dir,
			'\nUse options("ipeds.download.dir" = "/PATH/TO/DOWNLOAD") to override this.'))
		options('ipeds.download.dir' = dir)
	}
}
