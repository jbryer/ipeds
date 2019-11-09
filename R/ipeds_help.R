#' Returns data.frame with the data dictionary.
#' 
#' This will return a data.frame with a list of all the tables available for the given
#' IEPDS year. Or, if the table parameter is specified, a data.frame with all the
#' variables available in that table.
#' 
#' @inheritParams download_ipeds
#' @param table if specified, the variable information for the given survey result table is returned.
#' @export
ipeds_help <- function(table,
					   year = as.integer(format(Sys.Date(), '%Y')) - 1,
					   dir = getIPEDSDownloadDirectory()) {
	db <- load_ipeds(year = year, dir = dir)
	year2 <- (year-1) %% 1000
	year2 <- ifelse(year2 < 10, paste0('0', year2), as.character(year2))
	if(missing(table)) {
		df <- db[[paste0('Tables', year2)]]
	} else {
		vartable <- db[[paste0('vartable', year2)]]
		df <- vartable[vartable$TableName == table,] # if the user specifies the exact table name with year
		if(nrow(df) == 0) {
			data('surveys', envir = environment())
			survey.info <- surveys[surveys$SurveyID == table,]
			if(nrow(survey.info) == 0) {
				stop(paste0('Could not find ', table, ' in data(surveys). Specify the full table name with year.'))
			}
			table.name <- paste0(survey.info[1,]$DataFilePre,
								 ifelse(survey.info[1,]$YearFormat == 2, year2, year),
								 survey.info[1,]$DataFilePost)
			df <- vartable[vartable$TableName == paste0(table, (year-1)),]
		}
	}
	return(df)
}
