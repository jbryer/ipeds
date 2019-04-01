#' Available IPEDS databases
#' 
#' This function will return a data frame listing status of available IPEDS
#' databases since 2007, including the download status.
#' 
#' @param dir directory where IPEDS databases are to be downloaded.
#' @return a data.frame with final and provisional columns indicating whether
#'         those databases are available for download. The downloaded column 
#'         indicates whether that database has already been downloaded.
#' @export
available_ipeds <- function(dir = getOption('ipeds.download.dir')) {
	firstYear <- 2007
	results <- data.frame(year = firstYear:as.integer(format(Sys.Date(), '%Y')),
						  year_string = getYearString(firstYear:as.integer(format(Sys.Date(), '%Y'))),
						  final = FALSE,
						  provisional = FALSE,
						  downloaded = FALSE,
						  download_date = as.Date(NA),
						  download_size = as.character(NA),
						  stringsAsFactors = FALSE)
	for(i in 1:nrow(results)) {
		year.str <- results[i,]$year_string
		file.final <- paste0('IPEDS_', year.str, '_Final.zip')
		url.final <- paste0(ipeds.base.url, file.final)
		results[i,]$final <- url.exists(url.final)
		file.prov <- paste0('IPEDS_', year.str, '_Provisional.zip')
		url.prov <- paste0(ipeds.base.url, file.prov)
		results[i,]$provisional <- url.exists(url.prov)
		download.file <- paste0(dir, '/IPEDS', year.str, '.Rda')
		results[i,]$downloaded <- file.exists(download.file)
		if(results[i,]$downloaded) {
			fi <- file.info(paste0(dir, '/IPEDS', year.str, '.Rda'))
			results[i,]$download_date <- fi[1,'ctime']
			results[i,]$download_size <- paste0(round(fi[1,'size'] / 10^6, digits=1), ' MB')
		}
	}
	return(results)
}
