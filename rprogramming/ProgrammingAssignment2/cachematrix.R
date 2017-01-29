## Functions to create matrices that can cache
## their inverses


## This function returns an object that can hold
## a matrix and its inverse
##
## setData sets the matrix data
## getData returns the matrix
## getInverse computes the inverse of the matrix 
##	      or returns the cached value of the 
##            iverse, getInverse(force=T) will 
##            recompute the inverse.
makeCacheMatrix <- function(x = matrix()) 
{
	inverse <- NULL
	setData <- function(y)
	{
		x <<- y
		inverse <<- NULL
	}
	getData <- function() x
	getInverse <- function(...)
	{
		if (is.null(inverse))
		{
			inverse <<- solve(x, ...)	
		}
		else
		{
			message("using cached value")
		}
		return(inverse)
	}
	list(setData=setData,
	     getData=getData,
	     getInverse=getInverse)
}


## Calls getInverse on the CacheMatrix
cacheSolve <- function(x, ...) 
{
 	       x$getInverse(...)
}
