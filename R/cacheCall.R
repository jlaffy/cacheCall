#' Generate one string from a list of strings
#'
#' @param args named list of arguments
#' @param argNames boolean indicating whether argument names should be included in the final output.
#' @param sep a character to separate arguments and their names. Defaults to ":".
#' @param collapse a character to separate arguments(+names) from one another. Defaults to "__".
#'
#' @return string of concatenated arguments
#' @export
#'
string <- function(args, argNames=FALSE, sep=":", collapse="_") {

  if (isTRUE(argNames)) {
    args <- lapply(1:length(args), function(i) paste(names(args)[i], args[[i]], sep=sep))
  }

  paste(args, collapse=collapse)
}


#' Generate filename to match Cache files
#'
#' @param pipeName the name of main function
#' @param fnName the name of function that is a step in the main function
#' @param args a list of arguments to the main function
#' @param cachePath a character string providing path to the Cache directory.
#' @param sep passed to `string`. a character to separate arguments and their names. Defaults to ":".
#' @param collapse passed to `string`. a character to separate arguments(+names) from one another. Defaults to "__".
#' @param argNames passed to `string`. Boolean indicating whether argument names should be included in the final output.
#'
#' @return character string that is the generated filename. It includes the main function and step function names, and the arguments.
#' @export
#'
makeFilename <- function(pipeName, fnName, args, cachePath, sep=":", collapse="__", argNames=FALSE) {

  if (stringr::str_sub(cachePath, -1) != "/") {
    cachePath <- paste(cachePath, "/", sep="")
  }

  components <- c(pipeName, fnName, args)
  String <- string(args=components, argNames=argNames, sep=sep, collapse=collapse)

  print(paste(cachePath, String, ".rds", sep=""))
  paste(cachePath, String, ".rds", sep="")
}


#' Call to Cache
#'
#' This function acts as a wrapper, such that for every real function call, enclosing it with `callCache()` first checks whether the output of the function call exists in `cachePath`.
#' If the file does not exist, it executes the function call and saves the output to `cachePath`. If the file does exist, it reads the file.
#' The filename is generated here and the file naming convention is determined by the function name(s) and arguments provided.
#' @param fnName the name of the function (any function) being called.
#' @param args a list of arguments that will define the filename.
#' @param pipeName Can be the name of the parent function or the name of the pipeline if there is one. Can also simply be an ID for a series of functions and files that should be grouped together. Defaults to `NULL`.
#' @param cachePath a character string providing path to the Cache directory.
#' @param ... arguments that will be passed to fnName call if it is executed.
#'
#' @return the output of the function call, either from a read-in file or from an executed call. If the latter, the corresponding file will also be saved in `cachePath`.
#' @export
#'
#' @examples
cacheCall <- function(fnName, args, pipeName=NULL, cachePath="", ...) {

  filename <- makeFilename(pipeName=pipeName, fnName=fnName, args=args, cachePath=cachePath)

  if (file.exists(filename)) {
    print('File exists')
    returning <- readRDS(filename)
  }

  else if (!file.exists(filename)) {
    returning <- do.call(fnName, list(...))
    saveRDS(returning, file=filename)
  }

  returning
}
