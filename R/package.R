#' List of available surveys to load from IPEDS
#' 
#' @name surveys
#' @docType data
#' @references National Center for Educational Statistics. Integrated Postsecondary Education Data System \url{https://surveys.nces.ed.gov/ipeds/}
#' @keywords data
NULL

.onLoad <- function(libname, pkgname) {
	ethnicityLevels <<- c('HispanicAnyRace', 'AmericanIndianOrAlaskaNative', 'Asian', 'BlackOrAfricanAmerican', 'NativeHawaiianOrPacificIslander', 'White', 'TwoOrMoreRaces', 'NonresidentAlien', 'RaceEthnicityUnknown')
	genderLevels <<- c('Male', 'Female')
	ipedsDataUrl <<- 'http://nces.ed.gov/ipeds/datacenter/data/'
	#data(surveys)
}
