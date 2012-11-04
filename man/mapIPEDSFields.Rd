\name{mapIPEDSFields}
\alias{mapIPEDSFields}
\title{mapIPEDSFields}
\usage{
  mapIPEDSFields(programCIPCode, educationalProgramType,
    educationalProgramName, educationalAwardLevel,
    ethnicityColumn, genderColumn)
}
\arguments{
  \item{programCIPCode}{The name of the column containing
  the CIP codes.}

  \item{educationalProgramType}{The name of the column
  containing the program types.}

  \item{educationalProgramName}{The name of the column
  containing the program names.}

  \item{educationalAwardLevel}{The name of the column
  containing the award levels.}

  \item{ethnicityColumn}{The name of the column containing
  student ethnicities.}

  \item{genderColumn}{The name of the column containing
  student genders.}
}
\description{
  This function creates a mapping between the field
  (column) names from source data frame and the names used
  by the ipeds package.
}

