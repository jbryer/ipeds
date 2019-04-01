# Page containing the links to download the files.
ipeds.download.page <- 'https://nces.ed.gov/ipeds/use-the-data/download-access-database'
# File name fomrat: IPEDS_2017-18_Provisional.zip or IPEDS_2017-18_Final.zip
ipeds.base.url <- 'https://nces.ed.gov/ipeds/tablefiles/zipfiles/'

#' Downloads IPEDS data for a given year.
#' 
#' This function will download IPEDS data in MS Access file format. By default,
#' files are downloaded to a subfolder of the ipeds package in the system's
#' R library directory. Once downloaded, the MS Access database will be converted
#' to a R data file for faster loading in subsequent R sessions.
#' 
#' @param year the year of the survey
#' @param dir the directory to download the data to. Defaults to the package directory.
#' @param userProvisional if TRUE, provisional data files will be downloaded if 
#'        the final version is not available.
#' @param force if TRUE, the function will redownload the file.
#' @param cleanup if TRUE, the zip and MS Access files will be deleted after the Rda file is created.
#' @param ... currently unused.
#' @return TRUE if the data has been successfully downloaded.
#' @export
download_ipeds <- function(year = as.integer(format(Sys.Date(), '%Y')) - 1, 
						  dir = paste0(system.file(package="ipeds"), '/data/downloaded'), 
						  useProvisional = TRUE,
						  force = FALSE,
						  cleanup = FALSE,
						  ...) {
	if(length(year) > 1) {
		for(i in year) {
			download_ipeds(year = i,
						   dir = dir,
						   userProvisional = useProvisional,
						   force = force,
						   cleanup = cleanup,
						   ...)
		}
		return()
	}
	
	dir <- paste0(dir, '/')
	year.str <- paste0((year - 1), '-', (year %% 1000))
	
	file <- paste0('IPEDS_', year.str, '_Final.zip')
	url <- paste0(ipeds.base.url, file)
	if(!url.exists(url)) {
		message(paste0('Final data not available for ', year.str))
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

	if(!file.exists(dest) | force) {
		download.file(url, dest, mode="wb")
		unzip(dest, exdir=dir)
	} else {
		message('Zip file already downloaded. Set force=TRUE to redownload.')
	}
	
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
		save(db, file = paste0(dir, 'IPEDS', year.str, '.Rda'))
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
	
	if(cleanup) {
		unlink(dest)
		unlink(accdb.file)
	}
	
	invisible(TRUE)
}

getYearString <- function(year) {
	paste0((year - 1), '-', ifelse(year %% 1000 < 10, '0', ''), (year %% 1000))
}

