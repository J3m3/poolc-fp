panic <- function() { stop("Panic!") }

f <- function(x) { 100 }

f(panic()) # This will not raise an error

#########################

a <- 10

side_effect_add <- function() {
  a <<- 1
  a
}

g <- function(x) { a }

g(side_effect_add()) # This will return 10