require(devtools)

document()
install()
build()
check()

library(ipeds)
ls('package:ipeds')

# This is where the data files will be downloaded by default
paste0(system.file(package="ipeds"), '/data/downloaded/')
# For development purposes, we will save IPEDS data files here (to save across installs)
ipeds.dir <- 'data-raw'

# What IPEDS databases are available?
available_ipeds(dir = ipeds.dir)

# Download IPEDS data files
download_ipeds(year = 2018:2017, dir = ipeds.dir)
# download_ipeds(year = 2016:2007, dir = ipeds.dir)
tools::resaveRdaFiles(ipeds.dir) # Compress the data files further

# Get all the tables for a given year
ipeds <- load_ipeds(year = 2018, dir = ipeds.dir)
names(ipeds)

# Data dictionaries
View(ipeds_help(2018, dir = ipeds.dir))
View(ipeds_help(2018, table = 'HD', dir = ipeds.dir))

# Get the directory table.
ipeds.directory <- ipeds_survey(2018, table = 'HD', dir = ipeds.dir) # Directory table
dim(ipeds.directory)

# This is the list of available survey tables. This may not be exhaustive.
# Please report new surveys.
data(surveys)
View(surveys)

# Tables in the most recent database that are not in the data(surveys) data.frame.
# TODO: These should be added to the data/surveys.csv file.
current.tables <- ipeds_help(dir = ipeds.dir)
year <- as.integer(format(Sys.Date(), '%Y')) - 2
table.names <- paste0(
	as.character(surveys$DataFilePre),
	ifelse(surveys$YearFormat == 2, (year - 2000), year),
	as.character(surveys$DataFilePost) )
View(current.tables[!current.tables$TableName %in% table.names,
			   c('Survey', 'TableName', 'TableTitle')])

