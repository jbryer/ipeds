#' View the data dictionary for the given survey and year.
#' 
#' This function will open the dictionary for the given IPEDS survey and year. 
#' Note that the first time this function is invoked it will attempt to download 
#' the dictionary file from the IPEDS website.
#'
#' @title ipedsHelp
#' @param surveyId The survey ID of the dictionary to display (i.e. surveys$SurveyID)
#' @param year The year of the dictionary to display.
#' @export
ipedsHelp <- function(surveyId, year) {
	warning("This function has been departed and will be removed in a future version. Use ipeds_help instead.")
	
	s = surveys[which(surveys$SurveyID==surveyId),]
	if(nrow(s) != 1) {
		stop(paste('IPEDS survey with id', surveyId, 'not found'))
	}
	dir = system.file(package="ipeds")
	dir.create(paste(dir, '/data/dict/', sep=''), showWarnings=FALSE)
	fileBase = tolower(paste(s[1,'DataFilePre'], formatYear(surveyId, year), s[1,'DataFilePost'], sep=''))
	files = list.files(paste(dir, '/data/dict/', sep=''), pattern=paste(fileBase, '.*', sep=''))
	if(length(files) > 0) {
		file = files[1]
	} else {
		dest = paste(dir, '/data/dict/', s[1,'DataFilePre'], formatYear(surveyId, year), s[1,'DataFilePost'], '_Dict', '.zip', sep='')
		url = paste(ipedsDataUrl, s[1,'DataFilePre'], formatYear(surveyId, year), s[1,'DataFilePost'], '_Dict', '.zip', sep='')
		download.file(url, dest, mode="wb")
		unzip(dest, exdir=paste(dir, "/data/dict", sep=""))
		unlink(dest)
		files = list.files(paste(dir, '/data/dict/', sep=''), pattern=paste(fileBase, '.*', sep=''))
		file = files[1]
	}
	browseURL(paste(dir, '/data/dict/', file, sep=''))
}

#' Download the data dictionary for the given year.
#' 
#' Internal function.
#' 
#' @param year the IPEDS year to download the data dictionary.
downloadHelp <- function(year) {
	dir = system.file(package="ipeds")
	dir.create(paste(dir, '/data/dict/', sep=''), showWarnings=FALSE)
	for(i in 1:nrow(surveys)) {
		s = surveys[i,]
		file = tolower(paste(s[1,'DataFilePre'], year, s[1,'DataFilePost'], '.html', sep=''))
		dest = paste(dir, '/data/dict/', file, sep='')
		if(!file.exists(dest)) {
			dest = paste(dir, '/data/dict/', s[1,'DataFilePre'], year, s[1,'DataFilePost'], '_Dict', '.zip', sep='')
			url = paste(ipedsDataUrl, s[1,'DataFilePre'], year, s[1,'DataFilePost'], '_Dict', '.zip', sep='')
			download.file(url, dest, mode="wb")
			unzip(dest, exdir=paste(dir, "/data/dict", sep=""))
			unlink(dest)
		}
	}
}
