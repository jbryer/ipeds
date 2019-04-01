#' Access to the Integrated Postsecondary Education Data System (IPEDS)
#' 
#' @name ipeds-package
#' @docType package
#' @title Integrated Postsecondary Education Data System
#' @author \email{jason@@bryer.org}
#' @keywords package institutional research ipeds nces
#' @import RCurl
#' @importFrom Hmisc mdb.get
NA

#' List of available surveys to load from IPEDS
#' 
#' @name surveys
#' @docType data
#' @format a data.frame with IPEDS survey IDs and titles.
#' @references National Center for Educational Statistics. Integrated 
#'      Postsecondary Education Data System \url{https://surveys.nces.ed.gov/ipeds/}
#' @keywords data
NULL

# Page containing the links to download the files.
ipeds.download.page <- 'https://nces.ed.gov/ipeds/use-the-data/download-access-database'
# File name fomrat: IPEDS_2017-18_Provisional.zip or IPEDS_2017-18_Final.zip
ipeds.base.url <- 'https://nces.ed.gov/ipeds/tablefiles/zipfiles/'
# Old URL. TODO: Remove in future version
ipedsDataUrl <- 'http://nces.ed.gov/ipeds/datacenter/data/'

.onLoad <- function(libname, pkgname) {
	ethnicityLevels <<- c('HispanicAnyRace', 'AmericanIndianOrAlaskaNative', 'Asian', 
						  'BlackOrAfricanAmerican', 'NativeHawaiianOrPacificIslander', 
						  'White', 'TwoOrMoreRaces', 'NonresidentAlien', 'RaceEthnicityUnknown')
	genderLevels <<- c('Male', 'Female')
	if(is.null(getOption('ipeds.download.dir'))) {
		dir <- paste0(system.file(package="ipeds"), '/data/downloaded/')
		# message(paste0('IPEDS data files will be downloaded to ', dir))
		options('ipeds.download.dir' = dir)
	}
}
