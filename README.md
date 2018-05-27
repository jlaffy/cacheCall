# `cacheCall`: Call to Cache

## Description


 This function acts as a wrapper, such that for every real function call, enclosing it with `callCache()` first checks whether the output of the function call exists in `cachePath` .
 If the file does not exist, it executes the function call and saves the output to `cachePath` . If the file does exist, it reads the file.
 The filename is generated here and the file naming convention is determined by the function name(s) and arguments provided.


## Usage

```r
cacheCall(fnName, args, pipeName = NULL, cachePath = "", ...)
```


## Arguments

Argument      |Description
------------- |----------------
```fnName```     |     the name of the function (any function) being called.
```args```     |     a list of arguments that will define the filename.
```pipeName```     |     Can be the name of the parent function or the name of the pipeline if there is one. Can also simply be an ID for a series of functions and files that should be grouped together. Defaults to `NULL` .
```cachePath```     |     a character string providing path to the Cache directory.
```...```     |     arguments that will be passed to fnName call if it is executed.

## Value


 the output of the function call, either from a read-in file or from an executed call. If the latter, the corresponding file will also be saved in `cachePath` .


