#' This function will return the IPEDS survey data for the given survey and year. 
#' Note that the first time this function is invoked it will attempt to download 
#' the data file from the IPEDS website.
#'
#' @title getIPEDSSurvey
#' @param surveyId The survey ID of the dictionary to display (i.e. surveys$SurveyID)
#' @param year The year of the dictionary to display.
#' @param dir the directory to download the data to. Defaults to the package directory
#' @param stringsAsFactors ogical: should character vectors be converted to factors? 
#'        Note that this is overridden by as.is and colClasses, both of which allow 
#'        finer control.
#' @param ... other parmaters passed to \code{\link{read.csv}}
#' @export
getIPEDSSurvey <- function(surveyId, year, 
						   dir = system.file(package="ipeds"),
						   stringsAsFactors = FALSE, ...) {
	warning("This function has been departed and will be removed in a future version. Use ipeds_survey instead.")
	
	s = surveys[which(surveys$SurveyID==surveyId),]
	if(nrow(s) != 1) {
		stop(paste('IPEDS survey with id', surveyId, 'not found'))
	}
	#dir = system.file(package="ipeds")
	file = paste(s[1,'DataFilePre'], year, s[1,'DataFilePost'], sep='')
	dest = paste(dir, "/data/downloaded/", file, '.csv', sep="")
	if(!file.exists(dest)) {
		r = try(downloadIPEDSSurvey(surveyId, year, dir=dir), FALSE)
  		if(class(r) == "try-error") {
  			r = NULL
  		}
	} else {
		r = read.csv(dest, stringsAsFactors=stringsAsFactors, ...)
	}
 	if(!is.null(r)) {
	 	names(r) = tolower(names(r))
 	}
	r
}

#' Downloads a given IPEDS survey data file.
#' 
#' @title downloadIPEDSSurvey
#' @param surveyId the survey ID from the surveys data frame
#' @param year the year of the survey
#' @param dir the directory to download the data to. Defaults to the package directory
#' @param stringsAsFactors ogical: should character vectors be converted to factors? 
#'        Note that this is overridden by as.is and colClasses, both of which allow 
#'        finer control.
#' @param ... other parmaters passed to \code{\link{read.csv}}
#' @export
downloadIPEDSSurvey <- function(surveyId, year, dir=system.file(package="ipeds"),
								stringsAsFactors=FALSE, ...) {
	warning("This function has been departed and will be removed in a future version. Use download_ipeds instead.")

	s = surveys[which(surveys$SurveyID==surveyId),]
	#dir = system.file(package="ipeds")
	file = paste(s[1,'DataFilePre'], formatYear(surveyId, year), 
				 s[1,'DataFilePost'], sep='')
	url = paste(ipedsDataUrl, file, '.zip', sep='')
	dir.create(paste(dir, '/data/downloaded/', sep=''), showWarnings=FALSE)
	dest = paste(dir, "/data/downloaded/", file, '.zip', sep="")
	download.file(url, dest, mode="wb")
	unzip(dest, exdir=paste(dir, "/data/downloaded", sep=""))
	unlink(dest)
	fname <- paste(dir, "/data/downloaded/", file, ".csv", sep="")
	if(!file.exists(fname)) {
		# Check to see if the filename is in lowercase
		fname <- paste(dir, "/data/downloaded/", tolower(file), ".csv", sep="")
	}
	r = read.csv(fname, stringsAsFactors=stringsAsFactors, ...)
	return(r)
}


#' Downloads all available surveys for the given year.
#' 
#' @title downloadAllSurveys
#' @param year the year to download
#' @param ... other parameters passed to \code{\link{downloadIPEDSSurvey}}
#' @export
downloadAllSurveys <- function(year, ...) {
	warning("This function has been departed and will be removed in a future version. Use download_ipeds instead.")
	data('surveys', envir = environment())
	for(i in 1:nrow(surveys)) {
		tryCatch(downloadIPEDSSurvey(surveys[i,'SurveyID'], year, ...), error=function(e) { 
			warning(paste("Error downloading survey:",surveys[i,'SurveyID'], surveys[i,'Title'])) })
	}
}
