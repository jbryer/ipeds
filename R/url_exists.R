#' Returns whether the given URL is valid.
#' 
#' This function was posted on StackOverflow here:
#' https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r
#' 
#' @param x a single URL
#' @param non_2xx_return_value what to do if the site exists but the
#'        HTTP status code is not in the `2xx` range. Default is to return `FALSE`.
#' @param quiet if not `FALSE`, then every time the `non_2xx_return_value` condition
#'        arises a warning message will be displayed. Default is `FALSE`.
#' @param ... other params (`timeout()` would be a good one) passed directly
#'        to `httr::HEAD()` and/or `httr::GET()`
#' @author hrbrmstr
#' @importFrom httr status_code
url_exists <- function(x, non_2xx_return_value = FALSE, quiet = TRUE,...) {
	# you don't need thse two functions if you're alread using `purrr`
	# but `purrr` is a heavyweight compiled pacakge that introduces
	# many other "tidyverse" dependencies and this doesn't.
	
	capture_error <- function(code, otherwise = NULL, quiet = TRUE) {
		tryCatch(
			list(result = code, error = NULL),
			error = function(e) {
				if(!quiet)
					message("Error: ", e$message)
				
				list(result = otherwise, error = e)
			},
			interrupt = function(e) {
				stop("Terminated by user", call. = FALSE)
			}
		)
	}
	
	safely <- function(.f, otherwise = NULL, quiet = TRUE) {
		function(...) capture_error(.f(...), otherwise, quiet)
	}
	
	sHEAD <- safely(httr::HEAD)
	sGET <- safely(httr::GET)
	
	# Try HEAD first since it's lightweight
	res <- sHEAD(x, ...)
	
	if(is.null(res$result) || ((httr::status_code(res$result) %/% 200) != 1)) {
		res <- sGET(x, ...)
		
		if(is.null(res$result)) {
			return(FALSE) # or whatever you want to return on "hard" errors
		}
		
		if(((httr::status_code(res$result) %/% 200) != 1)) {
			if(!quiet) {
				warning(sprintf("Requests for [%s] responded but without an HTTP status code in the 200-299 range", x))
			}
			return(non_2xx_return_value)
		}
		
		return(TRUE)
	} else {
		return(TRUE)
	}
}
