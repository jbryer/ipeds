library(devtools)

document()
install()
install(build_vignettes = TRUE)
build()
check()

library(ipeds)
ls('package:ipeds')
data(package = 'ipeds')

# This is where the data files will be downloaded by default
(ipeds.dir.sys <- paste0(system.file(package="ipeds"), '/data/downloaded/'))
# For development purposes, we will save IPEDS data files here (to save across installs)
(ipeds.dir <- 'data-raw')

options('ipeds.download.dir' = ipeds.dir)
getOption('ipeds.download.dir')

# This will copy pre-processed data files in the data-raw to the system location.
# This is convenient for testing purposes since each install will delete the data
# files in the system's R package directory.
# ipeds.files <- list.files(ipeds.dir, pattern = '*.Rda')
# dir.create(ipeds.dir.sys, recursive = TRUE)
# file.copy(from = paste0(ipeds.dir, '/', ipeds.files),
# 		  to = paste0(ipeds.dir.sys, '/', ipeds.files))

# What IPEDS databases are available?
available_ipeds()

# Download IPEDS data files
download_ipeds(year = 2018:2017) # May want to copy to system folder (see above)
# download_ipeds(year = 2016:2007)
tools::resaveRdaFiles(ipeds.dir) # Compress the data files further

# Get all the tables for a given year
ipeds <- load_ipeds(year = 2018)
names(ipeds)

# Data dictionaries
View(ipeds_help(2018))
View(ipeds_help(2018, table = 'HD'))

# Get the directory table.
ipeds.directory <- ipeds_survey(2018, table = 'HD') # Directory table
dim(ipeds.directory)

# This is the list of available survey tables. This may not be exhaustive.
# Please report new surveys.
data(surveys)
View(surveys)

################################################################################
# Tables in the most recent database that are not in the data(surveys) data.frame.
# This will edit the data/surveys.Rda file with new survey IDs.
current.tables <- ipeds_help()
year <- as.integer(format(Sys.Date(), '%Y')) - 2
table.names <- paste0(
	as.character(surveys$DataFilePre),
	ifelse(surveys$YearFormat == 2, (year - 2000), year),
	as.character(surveys$DataFilePost) )
missing.tables <- current.tables[!current.tables$TableName %in% table.names,
			   c('TableName', 'Survey', 'TableTitle')]
names(missing.tables) <- c('SurveyID', 'Survey', 'Title')
missing.tables$DataFilePre <- ''
missing.tables$DataFilePost <- ''
missing.tables$YearFormat <- as.integer(NA)
for(i in 1:nrow(missing.tables)) {
	if(length(grep(as.character(year), missing.tables[i,]$SurveyID)) > 0) {
		split <- strsplit(missing.tables[i,]$SurveyID, as.character(year), fixed = TRUE)[[1]]
		missing.tables[i,]$DataFilePre <- split[1]
		if(length(split) > 1) {
			missing.tables[i,]$DataFilePost <- split[2]
		}
		missing.tables[i,]$YearFormat <- 4
		missing.tables[i,]$SurveyID <- paste0(split, collapse = '')
	} else {
		print(paste0("Could not split row ", i))
	}
}
missing.tables <- missing.tables[!is.na(missing.tables$YearFormat),]
if(any(missing.tables$SurveyID %in% surveys$SurveyID)) {
	stop('Newly identified SurveyID already exists in surveys data.frame!')
} else {
	surveys <- rbind(surveys, missing.tables)
	save(surveys, file = 'data/surveys.rda')
}

################################################################################
# Test an alternative way of reading aacdb files on Windows
# NOTE: Currently does not work

Sys.info()['sysname'] == 'Windows' # Check for Windows
Sys.info()['machine']  # Probably needs to be 32-bit
library(RODBC)
db <- file.path(file.choose())
channel <- RODBC::odbcConnectAccess2007(db)
subset(sqlTables(conn), TABLE_TYPE == "TABLE")
sqlTables(channels)

