#' Loads IPEDS data for a given year.
#' 
#' This function will return a large list with all the tables for a given IPEDS
#' year. It is recommended to use the \code{\link{ipeds_survey}} function instead.
#' 
#' @inheritParams download_ipeds
#' @return a list with all tables (as data.frames) for the given year.
#' @export
load_ipeds <- function(year = as.integer(format(Sys.Date(), '%Y')) - 1,
					   dir = getOption('ipeds.download.dir')) {
	year.str <- getYearString(year)
	file <- paste0(dir, '/IPEDS', year.str, '.Rda')
	if(!file.exists(file)) {
		stop(paste0('Data file for ', year.str, ' not available. ',
					'Try running the following function first:\n',
					'download_ipeds(year = ', year, ', dir = "', dir, '")'))
	}
	load(file)
	invisible(db)
}
