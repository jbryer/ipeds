#' Returns
#' 
#' @inheritParams download_ipeds
#' @param table the IPEDS survey result to return.
#' @export
ipeds_survey <- function(year = as.integer(format(Sys.Date(), '%Y')) - 1,
						 dir = paste0(system.file(package="ipeds"), '/data/downloaded/'),
						 table) {
	db <- load_ipeds(year = year, dir = dir)
	df <- db[[table]]
	if(is.null(df)) {
		year2 <- (year-1) %% 1000
		year2 <- ifelse(year2 < 10, paste0('0', year2), as.character(year2))
		data(surveys)
		survey.info <- surveys[surveys$SurveyID == table,]
		if(nrow(survey.info) == 0) {
			stop(paste0('Could not find ', table, ' in data(surveys). Specify the full table name with year.'))
		}
		table.name <- paste0(survey.info[1,]$DataFilePre,
							 ifelse(survey.info[1,]$YearFormat == 2, year2, (year-1)),
							 survey.info[1,]$DataFilePost)
		df <- db[[table.name]]
	}
	return(df)
}
