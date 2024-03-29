% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ipeds_survey.R
\name{ipeds_survey}
\alias{ipeds_survey}
\title{IPEDS Survey Table}
\usage{
ipeds_survey(
  table,
  year = as.integer(format(Sys.Date(), "\%Y")) - 1,
  dir = getIPEDSDownloadDirectory()
)
}
\arguments{
\item{table}{the IPEDS survey result to return.}

\item{year}{the year of the survey}

\item{dir}{the directory to download the data to. Defaults to the package directory.}
}
\value{
a data.frame
}
\description{
This function returns the data for the specified table and year. The table
can be specified using either the full table name within the original database
(e.g. "HD2017") or with just the survey ID as specified in the \code{data(surveys)}
data frame (e.g. "HD").
}
