#' Converts the year to the IPEDS academic year format.
#' 
#' IPEDS uses a YYYY-YY format for dates in files. For 2018 data release, the
#' date format would be 2017-18.
#' 
#' @param year the IPEDS release year.
#' @return a string with the cohort year
getYearString <- function(year) {
	paste0((year - 1), '-', ifelse(year %% 1000 < 10, '0', ''), (year %% 1000))
}

#' Formats the year for a specific survey.
#' 
#' Returns the formatted year for the given survey.
#' 
#' @param surveyId the survey ID from the data(surveys) data.frame.
#' @param year the IPEDS release year.
formatYear <- function(surveyId, year) {
	s = surveys[which(surveys$SurveyID==surveyId),]
	if(s['YearFormat'] == 4) {
		year = as.character(year)
	} else if(s['YearFormat'] == 2) {
		year = substr(year, 3,4)
	} else if(s['YearFormat'] == 22) {
		year = paste(substr((year-1), 3,4), substr(year, 3,4), sep='')
	} else if(s['YearFormat'] == 44) {
		year = paste((year-1), year, sep='')
	}
	year
}
