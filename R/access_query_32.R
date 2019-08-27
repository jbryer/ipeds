#' Extracts tables from an Access database
#' 
#' This function will extract all tables from the supplied 
#' Access database. 
#' 
#' @param db_path the path to the Access database
#' @return List of the tables that were extracted.
#' @export
#' 
getTable <- function(theTable, ODBC_con, ODBC_str, sock_con, sock_port) {
  message(paste('Beginning table',theTable))
  expr <- "library(svSocket)"
  expr <- c(expr, "library(RODBC)")
  expr <- c(expr, sprintf("%s <- odbcDriverConnect('%s')", ODBC_con, ODBC_str))
  expr <- c(expr, sprintf("if('%1$s' %%in%% sqlTables(%2$s)$TABLE_NAME) {%1$s <- sqlFetch(%2$s, '%1$s')} else {%1$s <- 'table %1$s not found'}", theTable, ODBC_con))
  expr <- c(expr, sprintf("%s <- socketConnection(port=%i)", sock_con, sock_port))
  expr <- c(expr, sprintf("evalServer(%s, %s, %s)", sock_con, theTable, theTable))
  expr <- c(expr, "odbcCloseAll()")
  expr <- c(expr, sprintf("close(%s)", sock_con))
  expr <- paste(expr, collapse=";")
  
  # launch 32 bit R session and run expressions
  prog <- file.path(R.home(), "bin", "i386", "Rscript.exe")
  system2(prog, args=c("-e", shQuote(expr)), stdout=NULL, wait=TRUE, invisible=TRUE)
  message(paste('Table',theTable,'retrieved'))
}

access_query_32 <- function(db_path = "~/path/to/access.accdb") {
  library(svSocket)
  
  # variables to make values uniform
  sock_port <- 8642L
  sock_con <- "sv_con"
  ODBC_con <- "a32_con"
  
  if (file.exists(db_path)) {
    
    # build ODBC string
    ODBC_str <- local({
      s <- list()
      s$path <- paste0("DBQ=", gsub("(/|\\\\)+", "/", path.expand(db_path)))
      s$driver <- "Driver={Microsoft Access Driver (*.mdb, *.accdb)}"
      s$threads <- "Threads=4"
      s$buffer <- "MaxBufferSize=4096"
      s$timeout <- "PageTimeout=5"
      paste(s, collapse=";")
    })
    
    # start socket server to transfer data to 32 bit session
    startSocketServer(port=sock_port, server.name="access_query_32", local=TRUE)
    
    # first get the list of available tables
    expr <- "library(svSocket)"
    expr <- c(expr, "library(RODBC)")
    expr <- c(expr, sprintf("%s <- odbcDriverConnect('%s')", ODBC_con, ODBC_str))
    expr <- c(expr, sprintf("theTables <- sqlTables(%1$s)",  ODBC_con))
    expr <- c(expr, sprintf("%s <- socketConnection(port=%i)", sock_con, sock_port))
    expr <- c(expr, sprintf("evalServer(%s, %s, %s)", sock_con, 'theTables', 'theTables'))
    expr <- c(expr, "odbcCloseAll()")
    expr <- c(expr, sprintf("close(%s)", sock_con))
    expr <- paste(expr, collapse=";")
    
    # launch 32 bit R session and run expressions
    prog <- file.path(R.home(), "bin", "i386", "Rscript.exe")
    system2(prog, args=c("-e", shQuote(expr)), stdout=NULL, wait=TRUE, invisible=TRUE)
    message('Table list retrieved')
    
    # then iterate over the list of tables and pull them in one by one
    # but skip the metadata tables that start with "MSys"
    lapply(theTables[which(substr(theTables$TABLE_NAME,1,4)!='MSys' & substr(theTables$TABLE_NAME,1,1)!='C'),3], function(X) getTable(X, ODBC_con, ODBC_str, sock_con, sock_port))
    
    # stop socket server
    stopSocketServer(port=sock_port)
    
  } else {
    warning("database not found: ", db_path)
  }
  return(theTables)
}
