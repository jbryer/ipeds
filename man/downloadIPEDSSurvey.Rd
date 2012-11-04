\name{downloadIPEDSSurvey}
\alias{downloadIPEDSSurvey}
\title{downloadIPEDSSurvey}
\usage{
  downloadIPEDSSurvey(surveyId, year,
    dir = system.file(package = "ipeds"))
}
\arguments{
  \item{surveyId}{the survey ID from the surveys data
  frame}

  \item{year}{the year of the survey}

  \item{dir}{the directory to download the data to.
  Defaults to the package directory}
}
\description{
  Downloads a given IPEDS survey data file.
}

