#' Downloads IPEDS data for a given year.
#' 
#' @param year the year of the survey
#' @param dir the directory to download the data to. Defaults to the package directory.
#' @param force if TRUE, the function will redownload the file.
#' @param cleanup if TRUE, the zip and MS Access files will be deleted after the Rda file is created.
#' @param ... other parmaters
#' @return TRUE if the data has been successfully downloaded.
#' @export
downloadIPEDS <- function(year = as.integer(format(Sys.Date(), '%Y')) - 1, 
						  useProvisional = TRUE,
						  dir = paste0(system.file(package="ipeds"), '/data/downloaded/'), 
						  force = FALSE,
						  cleanup = FALSE,
						  ...) {
	# TODO: Allow multiple years
	
	# Page containing the links to download the files.
	ipeds.download.page <- 'https://nces.ed.gov/ipeds/use-the-data/download-access-database'
	# File name fomrat: IPEDS_2017-18_Provisional.zip or IPEDS_2017-18_Final.zip
	ipeds.base.url <- 'https://nces.ed.gov/ipeds/tablefiles/zipfiles/'
	
	year.str <- paste0((year - 1), '-', (year %% 1000))
	
	file <- paste0('IPEDS_', year.str, '_Final.zip')
	url <- paste0(ipeds.base.url, file)
	if(!url.exists(url)) {
		file <- paste0('IPEDS_', year.str, '_Provisional.zip')
		url <- paste0(ipeds.base.url, file)
		if(!url.exists(url)) {
			stop(paste0(year.str, ' IPEDS database not available at: ', ipeds.download.page))
		} else if(!useProvisional) {
			stop(paste0('Final version of the ', year.str, 
						' IPEDS database is not available but the providional is. ',
						'Set useProvisional=TRUE to use.'))
		}
		warning(paste0('Downloading the provisional database for ', year.str, '.'))
	}
	
	dir.create(dir, showWarnings=FALSE)
	dest <- paste(dir, file, sep="")
	if(file.exists(dest)) {
		warning(paste0('Database for ', year.str, ' has already been downloaded.'))
		if(!force) {
			invisible(FALSE)
		}
	}
	
	download.file(url, dest, mode="wb")
	unzip(dest, exdir=dir)
	
	accdb.file <- paste0(dir, 'IPEDS', (year - 1), (year %% 1000), '.accdb')
	if(!file.exists(accdb.file)) {
		stop(paste0('Problem loading MS Access database file.\n',
					'Downloaded file: ', dest,
					'File not found: ', accdb.file))
	}
	
	# db <- RODBC::odbcConnect(paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", 
	# 								accdb.file))
	# 
	# db <- RODBC::odbcConnect(accdb.file)
	# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
	# brew install mdbtools
	tryCatch({
		db <- Hmisc::mdb.get(accdb.file)
	}, error = function(e) {
		print('Error loading the MS Access database file. Make sure mdtools is installed.')
		if(Sys.info()['sysname'] == 'Darwin') {
			print('The following terminal commands will install mdtools on Mac systems:')
			cat('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null \n')
			cat('brew install mdbtools \n')
		}
		print('Original Error:')
		print(e)
	})
	save(db, file = paste0(dir, 'IPEDS', year.str, '.Rda'))
	
	if(cleanup) {
		unlink(dest)
		unlink(accdb.file)
	}
	
	invisible(TRUE)
}
