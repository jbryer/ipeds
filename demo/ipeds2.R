# This demonstrates version 2 of the package.

library(ipeds)

# Where the package will download data files.
getIPEDSDownloadDirectory()

# We can override the download directory
dir <- paste0(getwd(), '/data-raw/downloaded/')
options('ipeds.download.dir' = dir)
getIPEDSDownloadDirectory()


# data.frame of available IPEDS surveyss
ipeds::available_ipeds()

# Download data
ipeds::download_ipeds(year = 2017)

# Get list of available tables
View(ipeds_help(year = 2017))

# Get data dictionary
View(ipeds_help(table = 'HD2016', year = 2017))

# This loads all the surveys from a given year. The result is a list of data frames
ipeds2017 <- ipeds::load_ipeds(year = 2017)
names(ipeds2017)

# Get at table
hd <- ipeds_survey(table = 'HD2016', year = 2017)
str(hd)
