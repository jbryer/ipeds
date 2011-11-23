\name{twelveMonthEnrollment}
\alias{twelveMonthEnrollment}
\title{twelveMonthEnrollment}
\usage{
  twelveMonthEnrollment(data, mappings = NULL,
  institutionId = NA, institutionName = NA, documentId =
  "a", createdDate = format(Sys.time(),
  "\%Y-\%m-\%dT\%H:\%M:\%S"), noteMessage = NA,
  transmissionType = "Original", documentType =
  "Application", reportingPeriod = "July-June",
  undergraduateContactHours = NULL,
  undergraduateCreditHours = NULL, graduateCreditHours =
  NULL)
}
\arguments{
  \item{data}{A data frame containing the required fields
  for IPEDS reporting.}

  \item{mappings}{The mapping between the fields in data
  and IPEDS (see \code{\link{mapIPEDSFields}} function)}

  \item{institutionId}{The IPEDS institution ID the data is
  being generated for.}

  \item{institutionName}{The name of the institution.}

  \item{documentId}{Use specified.}

  \item{createdDate}{The date the document is created.}

  \item{noteMessage}{Optional note message to include in
  the generated file.}

  \item{transmissionType}{Either original for first upload
  or replace.}

  \item{documentType}{Defaults to application}

  \item{reportingPeriod}{}

  \item{undergraduateContactHours}{The total number of
  undergraduate contact hours for the given reporting
  period.}

  \item{undergraduateCreditHours}{The total number of
  undergraduate credit hours for the given reporting
  period.}

  \item{graduateCreditHours}{The total number of graduate
  credit hours for the given reporting period.}
}
\description{
  This function generates a XML file for the twelve month
  enrollment survey.
}

