\name{getIPEDSSurvey}
\alias{getIPEDSSurvey}
\title{getIPEDSSurvey}
\usage{
  getIPEDSSurvey(surveyId, year, dir = system.file(package
  = "ipeds"))
}
\arguments{
  \item{surveyId}{The survey ID of the dictionary to
  display (i.e. surveys$SurveyID)}

  \item{year}{The year of the dictionary to display.}

  \item{dir}{the directory to download the data to.
  Defaults to the package directory}
}
\description{
  This function will return the IPEDS survey data for the
  given survey and year. Note that the first time this
  function is invoked it will attempt to download the data
  file from the IPEDS website.
}

