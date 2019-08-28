#' Downloads IPEDS data for a given year.
#'
#' This function will download IPEDS data in MS Access file format (OSX/Linux)
#' or as individual zipped CSV files (Windows). By default,
#' files are downloaded to a subfolder of the ipeds package in the system's
#' R library directory. Once downloaded, the source file(s) will be converted
#' to a R data file for faster loading in subsequent R sessions.
#'
#' @param year the year of the survey
#' @param dir the directory to download the data to. Defaults to the package directory.
#' @param useProvisional if TRUE, provisional data files will be downloaded if
#'        the final version is not available.
#' @param force if TRUE, the function will redownload the file.
#' @param cleanup if TRUE, the zip and MS Access files will be deleted after the Rda file is created.
#' @param ... other parameters passed to url_exists.
#' @return TRUE if the data has been successfully downloaded.
#' @export
download_ipeds <-
  function(year = as.integer(format(Sys.Date(), '%Y')) - 1,
           dir = paste0(system.file(package = "ipeds"), '/data/downloaded'),
           useProvisional = TRUE,
           force = FALSE,
           cleanup = FALSE,
           ...) 
{
    if (length(year) > 1) {
      status <- TRUE
      for (i in year) {
        status <- status &
          download_ipeds(
            year = i,
            dir = dir,
            userProvisional = useProvisional,
            force = force,
            cleanup = cleanup,
            ...
          )
      }
      invisible(status)
    }
    if (Sys.info()['sysname'] == 'Windows') {
      # Windows platforms start here
      data('surveys', envir = environment())
      for (i in 1:nrow(surveys)) {
        tryCatch(
          do.call('<-', list((
            paste(as.character(surveys[i, 'SurveyID']), year, sep = '')
          ), suppressWarnings(getIPEDSSurvey((surveys[i, 'SurveyID']), year)))
          ),
          error = function(e) {
            simpleError(paste("Error downloading survey:", surveys[i, 'SurveyID'], surveys[i, 'Title']))
          }
        )
      }
      
      # For all the successfully downloaded surveys, extract the data from the .csv
      valid_surveys <- c()
      valid_files <- c()
      for (i in 1:nrow(surveys)) {
        s = surveys[i, ]
        
        file = paste(s[1, 'DataFilePre'], formatYear(s[1, 'SurveyID'], year),
                     s[1, 'DataFilePost'], sep = '')
        
        fname <- paste(dir, '/', file, ".csv", sep = "")
        if (file.exists(fname)) {
          message(paste('Reading', file))
          do.call('<-', list(file, read.csv(fname, stringsAsFactors = FALSE)))
          valid_surveys <- c(valid_surveys, i)
          valid_files <- c(valid_files, file)
          if (cleanup) {
            unlink(fname)
          }
        }
      }
      # save all the valid surveys into one Rds
      valid_surveys <- surveys[valid_surveys, ]
      db <- vector('list', length(valid_files))
      names(db) <- valid_files
      for (i in 1:length(db)) {
        db[[i]] <- get(names(db)[i])
      }
      save(db, file = paste0(dir, '/', 'IPEDS', year, '.Rda'))
    }
    else {
      # Non-Windows platforms start here
      dir <- paste0(dir, '/')
      year.str <- paste0((year - 1), '-', (year %% 1000))
      
      file <- paste0('IPEDS_', year.str, '_Final.zip')
      url <- paste0(ipeds.base.url, file)
      if (!url_exists(url, ...)) {
        message(paste0('Final data not available for ', year.str))
        file <- paste0('IPEDS_', year.str, '_Provisional.zip')
        url <- paste0(ipeds.base.url, file)
        if (!url_exists(url, ...)) {
          stop(paste0(
            year.str,
            ' IPEDS database not available at: ',
            ipeds.download.page
          ))
        } else if (!useProvisional) {
          stop(
            paste0(
              'Final version of the ',
              year.str,
              ' IPEDS database is not available but the providional is. ',
              'Set useProvisional=TRUE to use.'
            )
          )
        }
        warning(paste0('Downloading the provisional database for ', year.str, '.'))
      }
      
      dir.create(dir, showWarnings = FALSE, recursive = TRUE)
      dest <- paste(dir, file, sep = "")
      
      if (!file.exists(dest) | force) {
        download.file(url, dest, mode = "wb")
      } else {
        message('Zip file already downloaded. Set force=TRUE to redownload.')
      }
      
      unzip(dest, exdir = dir)

      accdb.file <-
        paste0(dir, 'IPEDS', (year - 1), (year %% 1000), '.accdb')
      if (!file.exists(accdb.file)) {
        stop(
          paste0(
            'Problem loading MS Access database file.\n',
            'Downloaded file: ',
            dest,
            'File not found: ',
            accdb.file
          )
        )
      }
      
      # Need to have mdtools installed. From the terminal (on Mac):
      # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
      # brew install mdbtools
      tryCatch({
        db <- Hmisc::mdb.get(accdb.file, stringsAsFactors = FALSE)
        save(db, file = paste0(dir, 'IPEDS', year.str, '.Rda'))
      }, error = function(e) {
        print('Error loading the MS Access database file. Make sure mdtools is installed.')
        if (Sys.info()['sysname'] == 'Darwin') {
          print('The following terminal commands will install mdtools on Mac systems:')
          cat(
            'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null \n'
          )
          cat('brew install mdbtools \n')
        }
        print('Original Error:')
        print(e)
      })
      if (cleanup) {
        unlink(dest)
        unlink(accdb.file)
      }
    }
invisible(TRUE)
}
