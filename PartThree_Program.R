###############################################################
#PART 3: PROGRAMMING
###############################################################
#Learning More:
#Hands-on Programming with R, Garret Grolemund
#Advanced R, Hadley Wickham  http://adv-r.had.co.nz

###############################################################
#18: Pipes with magrittr ##############################
###############################################################
#Pipes are a powerful tool for expressing a sequence of multiple operations
#The pipe, %>%, comes from the magrittr package
library(magrittr)


###############################################################
#17.2: Piping Alternatives ##############################
#Little bunny Foo Foo
#Went hopping though the forset
#Scooping up the field mice
#And bopping them on the head

#Define an object to represent little bunny Foo Foo:
foo_foo <- little_bunny()

#Use a function for each key verb: hop(), scoop(), and bop().
#With this object and these verb, we can tell the story at least 4 ways in code:
#Save each intermediate step as a new object
#Overwrite the original object many times
#Compose functions
#Use the pipe


###############################################################
#18.2.2: Intermediate Steps ##############################
#The simplest appraoch is to save each step as a new object:
foo_foo_1 <- hop(foo_foo, through = forest) 
foo_foo_2 <- scoop(foo_foo_1, up = field mice)
foo_foo_3 <- hop(bop, on = head)

#This methodology forces you to name each intermediate element.  This causes 2 problems:
#The code is cluttered with unimportant, intermediate names.
#You have too carefully increment the suffix on each line.

#Let's take a look at an actual data manipulation pipeline where we add a new column to ggplot2::diamonds :
#R shares columns across data frames, where possible (evidenced by the size of the 2 frames below) 
diamonds <- ggplot2::diamonds

diamonds2 <- diamonds %>%
  dplyr::mutate(price_per_carat = price/carat)

pryr::object_size(diamonds) #3.46MB
pryr::object_size(diamonds2) #3.89MB
pryr::object_size(diamonds, diamonds2) #3.89MB

#How is this possible?  diamonds2 has 10 columns in common with diamonds; no need to duplicate that data.
#The variables only get copied if we modify one of them:

diamonds$aarat[1] <- NA

pryr::object_size(diamonds) #3.46MB; the carat column has been modified and cannot be shared
pryr::object_size(diamonds2) #3.89MB
pryr::object_size(diamonds, diamonds2) #4.32MB


###############################################################
#18.2.2: Overwrite the Original ##############################
#Instead of creating intermediate objects at each step, we could overwrite the original

foo_foo <- hop(foo_foo, through = forest) 
foo_foo <- scoop(foo_foo_1, up = field mice)
foo_foo <- hop(bop, on = head)

#There are two problems with this approach:
#1.) Debugging is painful; if you make a mistake, you need to run the complete pipeline from the beginning
#2.) The reptition of the object being transformed obscures what's changing on each line


###############################################################
#18.2.3: Function Composition ##############################
#Another approach: abandon assignments, and just string the function calls together:
bop(
  scoop(
    hop(foo_foo, through = forest),
    up = field_mice
  ),
  on = head
)
#But here, we have to read from the inside-out, from right to left... It's very tough to read


###############################################################
#18.2.4: Use the Pipe %>% ##############################
foo_foo %>%
  hop(through = forest) %>%
  scoop( up = field_mouse) %>%
  bop (on = head)
#This form focuses on verbs, not nouns.

#The pipe works by performing a "lexical transformation": behind the scenes, magrittr reassembles the code in the pipe
#to a form that works.  When we run a pipe like the above, magrittr does something like this:
my_pipe <- function(.) {
  . <- hop(., through = forest)
  . <- scoop(., up = field_mice)
  bop(., on = head)
}
my_pipe(foo_foo)

#This means the pipe won't work for 2 classes of functions:
#1.) Functions which use the current environment.  For example, assign() will create a new variable with the given 
#name in the current environment:
assign("x", 10)
x

"x" %>% assign(100)
x

#assign() with the pipe doesn't work because it assigns it to a temp environment used by %>%.
#If you want to use assign() with the pipe, you must be explicit about the environment:
env <- environment()
"x" %>% assign(100, envir = env)
x
#get() and load() have this same issue.


#2.) Functions which use lazy evaluation.  In R, function arguments are only computed when the function uses them,
#not prior to calling the function.  The pipe computes each element in turn, so we can't rely on this behavior:

#This is a problem with tryCatch(), which let's you capture and handle errors:
?tryCatch
tryCatch(stop("!"), error = function(e) "An error")

stop("!") %>%
  tryCatch(error = function(e) "An error")

#Other functions which have this behavior include: try(), suppressMessages(), and suppresssWarnings() in base R.


###############################################################
#18.3: When not to use the pipe ##############################
#Pipes are great for writing a fairly short linear sequence of operations.
#Consider reaching for another tool when:

#Your pipes are longer than 10 steps.  In this case, create intermediate objects with meaningful names, which makes
#debugging easier (you can more easily check intermediate results), and it makes your code easier to understand (the
#variable names can help communicate intent)

#You have multiple inputs or outputs.

#You are thinking about a directed graph with a complex dependency structure.  Pipes are linear, and complex
#relationships can result in confsing code.


###############################################################
#18.4: Other tools from magrittr ##############################
#All packages in the tidyverse automatically make %>% available, so you don't normally load magrittr explicitly.
#However, there are some other useful tools in magrittr we should try:

#When working with complex pipes, it can be useful to call a function for its side-effects.
#Maybe you want to print the current object, plot it, or save it to disk.  If a function doesn't return anything,
#this terminates the pipe.

#Use the "tee" pipe to work around this.  %T>% works like %>%, except it returns the left hand side instead of the 
#right-hand side:

rnorm(100)%>%
  matrix(ncol = 2) %>%
  plot() %>%
  str()

rnorm(100)%>%
  matrix(ncol = 2) %T>%
  plot() %>%
  str()

#If working with functions which don't have a data frame based API (you pass them individual vectors rather than a
#data frame and expressions to be evaluated in the context of that frame), you might use %$%.

# %$% explodes out the variables in a data frame so we can refer to them explictly:

mtcars %$%
  cor(disp, mpg)

###############################################################
#19: Functions ################################################
###############################################################
#Writing a function has 3 big advantages over copy-paste:
#1.) You can name your function so your code is easier to understand
#2.) As requirements change, you can change one function, rsther than changing the code in many spots
#3.) You reduce the chance of making incidental mistakes, such as changing the a variable name in one place,
#and forgetting to change it everywhere.
#Writing coe is a life-long journey... we can always improve.

###############################################################
#19.2: When Should You Write a Function #######################
#You should consider writing a function whenever you've copied and pasted a block of code > 2x.
#For example, look at this code:
df <-  tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

?rnorm

df$a <- (df$a -min(df$a, na.rm=TRUE))/
  (max(df$a, na.rm=TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b -min(df$b, na.rm=TRUE))/
  (max(df$b, na.rm=TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c -min(df$a, na.rm=TRUE))/
  (max(df$c, na.rm=TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d -min(df$d, na.rm=TRUE))/
  (max(df$d, na.rm=TRUE) - min(df$d, na.rm = TRUE))

#This code rescales each column from 0 to 1.  But there's a mistake in the second df$b code.
#Extracting repeated code prevents this type fo mistake.

#To write a function, first analayze the code.  How many inputs does it have? 
df$a <- (df$a -min(df$a, na.rm=TRUE))/
  (max(df$a, na.rm=TRUE) - min(df$a, na.rm = TRUE))
#This code only has one input: df$a.  

#To make the inputs more clear, re-write using temporary variables with general names:
x <- df$a
(x - min(x, na.rm = TRUE))/
  (max(x, na.rm=TRUE) - min(x, na.rm = TRUE))

#There's some duplication in the code.  We compute the range 3 times, but it makes sense to do it in one step:
?range #returns a vector containing the min and max of all the given arguments.
rng <- range(x, na.rm = TRUE)
(x-rng[1])/(rng[2]-rng[1])

#Pulling out intermediate calcs into a named variable makes more clear what the code is doing.

#Now we turn it into a function:
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x-rng[1])/(rng[2]-rng[1])
}
rescale01(c(0,5,10)) #This rescales these 3 numbers 

#There are 3 key steps in creating a function:
#1.) Pick a name for the fuction.  Here, we used rescale01 because then fnctn scales from 0 to 1
#2.) List the inputs, or arguments, to the function inside function(). Here, we have just one input, x.  
#3.) Place the code you develop in the body of the function, a {} block which follow function(). 

#It's easier to start with working code and then turn it into a function than to just attempt writing a fnctn.
#It's also smart to check your function with a few different inputs:
rescale01(c(-10,0,10)) 
rescale01(c(1,2,3,NA,5)) #This rescales these 3 numbers 

####As you write more functions, you'll want to convert this informal type of test into formal, automated testing.
####Learn more about this at http://r-pkgs.had.nz.tests.html

#Now we can simplify the original example:
df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)
#We'll learn more about how to further reduce this duplication in Chapter 21, Iteration with purrr

#Another advantage: if our requirements change, we only need to change the code in one place.
#Let's say we discover one of our variables contains an infinite value.  rescale01 will fail:
x <- c(1:10, Inf)
rescale01(x)

#We only have to alter the code in one spot:
?range
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite=TRUE) #indicates all non-finite values s/b eliminated
  (x-rng[1])/(rng[2]-rng[1])
}

rescale01(x)


###############################################################
#19.2.1: Exercises ############################################


###############################################################
#19.3: Functions Are for Humans and Computers #################
#Some things you shoud bear in mind when writing funtions:

#The name of the funtion is important; it should be short and descriptive.
#Function names s/b verbs, and arguments s/b nouns.

#If you have a family of functions, make sure the names of the functions and arguments are consistent
#Good:
input_select()
input_checkbox()
input_text()

#Not Good:
select_input()
checkbox_input()
text_input()

#Use plenty of comments to explain your code.

#USE this when breaking code into chunks ============================
#or use this --------------------------------------------------------
#Ctrl + Shift + R can create these headers:
# Section Label Example  --------------------------------------------------


###############################################################
#19.3.1: Exercises ##################################
#1.) Read the source code for each of the following three functions, puzzle out what they do, 
#and then brainstorm better names.

f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}#returns whether a function has a common prefix.  A better name fould be "has_prefix()"

f1(c("str_c", "str_a"), "str_")

f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}#This function drops the last element. "drop_last()" is a better name.
f2(1:3)

f3 <- function(x, y) {
  rep(y, length.out = length(x))
}#repeats y once for each member of x.  "recycle" might be a good name.
f3(1:3,4)


#2.) Take a function that you???ve written recently and spend 5 minutes brainstorming a better name 
#for it and its arguments.

#3.) Compare and contrast rnorm() and MASS::mvrnorm(). How could you make them more consistent?

rnorm?
  
  #4.) Make a case for why norm_r(), norm_d() etc would be better than rnorm(), dnorm(). 
  #Make a case for the opposite.
  
  
  ###############################################################
#19.4: Conditional Execution ##################################
#An if statement allows us to conditionally execute code:
if(condition) {
  #code executed when condition is TRUE
} else {
  #code executed when condition is FALSE
}


#An example which returns a logical vector describing whether each element of a vector is named:
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms !=""
  }
}

###############################################################
#19.4.1: Conditions ##################################

#The condition must evaluate to either TRUE or FALSE.
#If it's a vector, we'll get a warning message, if NA, we'll get an error.
if(c(TRUE, FALSE)) {}

if(NA) {}

#Use || (or) and && (and) to combine multiple logic operations.
#These operators are "short-circuiting": as soon as || sees the first TRUE, it stops evaluating.
#As soon as && sees a FALSE, it stops.

#Never use | or & in an if statement: these are vectorized operations which apply to multiple values.

#Be careful when testing for equality, as == is also vectorized, which means we can get more than one output.
#Either check the length is already 1, collapse with all() or any(), or use the non-vectorized identical().
identical(0L, 0) #identical() is very strict, and doesn't coerce types

#Be wary of floating point numbers:
x <- sqrt(2)^2
x

x == 2

x-2

#Use dplyr::near() for comparisons instead, as describes in chapter 5, "comparisons".

#Remember, x==NA doesn't do anything useful.


###############################################################
#19.4.2: Multiple Conditions ##################################
#We can chain multiple if statements together:
If(this) {
  #do that
} else if (that) {
  #do something else
} else {
  #
}

#If you have a very long set of chained "if" statements, consider re-writing the code.  The switch()
#Function allows you to evaluate selected code based on postion or name:
function(x,y,op) {
  switch(op,
         plus = x + y, 
         minus = x - y,
         times = x * y,
         divide = x / y,
         stop("Unknown op!")
  )
}

#cut() is used to discretize continuous variables, and can also eliminate long chains of if() statements.


###############################################################
#19.4.3: Code Style ##################################
#Both "if" and "function" should almost always be followed by squiggly brackets {}, and the contents s/b indented
#by two spaces.  This makes it easier to see the hierarchy in the code by skimming the left-hand margin.

#An opening curly brace should never be on its own line, and should always be followed by  new line.
#A closing curly brace should always go on its own line unless followed by "else".
#Always indent the code inside curly braces

#Good
if (y<0 && debug) {
  message("Y is negative")
}

if (y==0) {
  log(x)
} else {
  y^x
}

#Bad
if (y < 0 && debug)
  message("Y is negative")

if(y==0) {
  log(x)
}
else {
  y^x
}

#But it's okay to drop the curly braces if you have a very short "if" statement which can fit on 1 line:
y <- 10
x <- if(y<20) "Too low" else "Too high"
x

#But only for very brief "if" statements; otherwise the full form is easier to read:
if(y<20) {
  x <- "Too low"
} else {
  x <- "Too high"
}

x



###############################################################
#19.4.4: Exercises ##################################
#1.) What???s the difference between if and ifelse()? Carefully read the help and construct three examples that illustrate the key differences.

#2.) Write a greeting function that says ???good morning???, ???good afternoon???, or ???good evening???, depending on the time of day. (Hint: use a time argument that defaults to lubridate::now(). That will make it easier to test your function.)

#3.) Implement a fizzbuzz function. It takes a single number as input. If the number is divisible by three, it returns ???fizz???. If it???s divisible by five it returns ???buzz???. If it???s divisible by three and five, it returns ???fizzbuzz???. Otherwise, it returns the number. Make sure you first write working code before you create the function.

#4.) How could you use cut() to simplify this set of nested if-else statements?

if (temp <= 0) {
  "freezing"
} else if (temp <= 10) {
  "cold"
} else if (temp <= 20) {
  "cool"
} else if (temp <= 30) {
  "warm"
} else {
  "hot"
}

#How would you change the call to cut() if I???d used < instead of <=? What is the other chief advantage of cut() for this problem? (Hint: what happens if you have many values in temp?)

#5.) What happens if you use switch() with numeric values?

#6.) What does this switch() call do? What happens if x is ???e????

switch(x, 
       a = ,
       b = "ab",
       c = ,
       d = "cd"
)
#Experiment, then carefully read the documentation.


###############################################################
#19.5: Function Arguments #####################################
#The arguments to a function typically fall into 2 braod sets:
#1 supplies the data to compute on, the 2nd supplies arguments which contr the details of the function.

#For example:
#In log(), the data is x, and the detail is the base of the algorithm
?log
log()

#In mean(), the data is x, and the detail is how much to trim from the ends (trim) and how to handle missing values (na.rm) 
?mean
x <- c(0:10, 50)
xm <- mean(x)
xm
c(xm, mean(x, trim = 0.2)) 

#In t.test(),the data are x and y, and the details of the test are alternative, mu, paired, var.equal and conf.level.
?t.test

#In str_(), we can supply any number of strings, and details ar controlled by sep and collapse
?str_c

#Data arguments geneally come first, and detail arguments at the end.  Detail arguments usually have default values.
#We can specify a default value the same way we call a fnctn with a named argument:

#Compute confidence interval around mean using normal approximation:
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x)/sqrt(length(x))
  alpha <- 1- conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha /2))
}

x <- runif(100)
mean_ci(x)
mean_ci(x,conf = 0.99)

#When calling a function, we typically omit the data argument names - but if we override the default value, 
#we should use the full name:

#Good:
mean(1:10, na.rm=TRUE)

#Bad:
mean(1:10,,FALSE)
?mean

#Always place a space around = in function calls, and always put spaces after commas.

###############################################################
#19.5.1: Choosing Names #####################################
#Longer, more descriptive names are typically better, but there some common short names:
#x, y, z :vectors
#w: a vector of weights
#df: a data frame
#i , j : numeric indices
#n :length, or number of rows
#p : number of columns


###############################################################
#19.5.2: Checking Values #####################################
#It's easy to call your function with invalid inputs.  To avoid this, it's useful to make constraints explicit.
#For example, imagine we've written a function for weighted summary statistics:
wt_mean <- function(x, w) {
  sum(x * w) / sum(x)
}
wt_var <- function(x, w) {
  mu <- wt_mean(x, w)
  sum(w * (x - mu) ^ 2) / sum(w)
}
wt_sd <- function(x, w) {
  sqrt(wt_var(x, w))
}

#What happens if x and w aren't the same length?
wt_mean(1:6, 1:3)
#Because R recylces vectors, we don't get an error.

#It's good to chrck important preconditions and throw an error with stop() if they aren't TRUE:
wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("'x' and 'w' must be the same length", call. = FALSE)
  }
  sum(x * w) / sum(x)
}

#Now what happens if x and w aren't the same length?
wt_mean(1:6, 1:3)

#Another useful check is the built-in stopifnot() function: It checks that each 
#argument is true and if not, produces a generic error message:

wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  
  if(na.rm) {
    miss <- is.na(x) | in.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  sum(x * w) / sum(x)
}

wt_mean(1:6, 6:1, na.rm = "foo")


###############################################################
#19.5.3: Dot-dot-dot(...) #####################################
#Many functions in R take an arbitrary number of inputs:
sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

stringr::str_c("a", "b", "c", "d", "e", "f")

#These functions rely on a special argument: ... (pronounced dot-dot-dot)
#This argument captures any number of arguments which aren't otherwise matched.
#We can then send those ... onto another function- a useful catch-all if your function wraps another function.

#For example, here are some helper functions that wrap around str_c:
commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])

rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}

rule("Important Output")
#Here, ... lets me dealforward on any arguments that i don't want to deal with to str_c().
#However, any mispelled arguments will not raise arrors, so typos can go unnoticed:
x <- c(1,2)
sum(x, na.mr = TRUE)


###############################################################
#19.5.4: Lazy Evalaution #####################################
#Arguments in R are lazily evaluated: they're not computed until needed.
#If they're never used, they're never called.
#Read more about lazy evaluation in: http://adv-r.had.co.nz/Functions.html#lazy-evaluation


###############################################################
#19.5.5: Exercises #####################################
#1.) What does commas(letters, collapse = "-") do? Why?

#2.) It???d be nice if you could supply multiple characters to the pad argument, e.g. 
#rule("Title", pad = "-+"). Why doesn???t this currently work? How could you fix it?

#3.) What does the trim argument to mean() do? When might you use it?

#4.) The default value for the method argument to cor() is c("pearson", "kendall", "spearman").
#What does that mean? What value is used by default?


###############################################################
#19.6: Return Values ##########################################
#Two thigs you should consider when returning a value:
#1. Does returning make your function easier to read?
#2. Can you make your function pipeable?


#19.6.1: Explicit Return Statements ##########################################
#The value returned by  function is usually the last statement it evaluates, but we can return early via return().
#It's best to save the use of return() to signal you can return early with a simpler solution - for example, if inputs are empty.

complicated_function <- function(x, y, z) {
  if(length(x) == 0 || length(y) == 0) {
    return(0)
  }
  
  #complicated code here
}

#Another reason would be when we have one complex and one simple block.  Instead of:
f <- function() {
  if(x) {
    #Do
    #something
    #which 
    #takes
    #many
    #lines
    #to
    #express
  } else {
    #return something short
  }
}

#write this way instead:
f <- function() {
  if(!x) {
    return(something_short)
  }
  #Do
  #something
  #which 
  #takes
  #many
  #lines
  #to
  #express
}


#19.6.2: Writing Pipeable Functions ##########################################
#Thinking about the return value is important if you want to write your own pipeable functions.
#Two main types of pipeable functions:

#Transformations- a clear primary object is passed in as the first argument, and a modified version is 
#returned by the function.  

#Side-effects- the passed object is not transformed.  Instead, the function performs an action on the object,
#such as drawing a plot or saving a file:

show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, sep = "")
  
  invisible(df)
}

#If we call this interactively, invisible() means the input df doesn't get printed:
show_missings(mtcars)

#It's still there, it's just not printed by default:
x <- show_missings(mtcars)
class(x)
dim(x)

#And we can still use in a pipe:
mtcars %>%
  show_missings() %>%
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>%
  show_missings()


###############################################################
#19.7: Environment ############################################
#The last compnent of a function is its environment, which can be crucial to how functions work.
#The environment controls how R finds the value associated with a name.  For example:
f <- function(x) {
  x + y
}
#In many programming languages, this would be an error: y is not defined in the function.
#R uses lexical scoping to find the value associated with a name.  R will look in the 
#environment where the function was defined:

y <- 100
f(10)

y <- 1000
f(10)

#The advantage is this allows R to be very consistent.  Every name is looked up using the same set of rules.
#For f(), this includes the behavior of { and +.  This allows us to do some interesting things:
'+' <- function(x, y) {
  if (runif(1) < 0.1) {
    sum(x,y)
  } else {
    sum(x, y) * 1.1
  }
}
table(replicate(1000, 1 + 2))
?replicate

###############################################################
#20: Vectors ##################################################
###############################################################
#Most functions will work with vectors.  
#Hadley is working on tools to allow functions which work with tibbles. See  https://github.com/hadley/lazyeval.

#We'll use a handful of functions from purrr package to avoid inconsistencies in base R:
library(purrr)

#20.2: Vector Basics ##########################################
#There are two type of vectors:
#1 Atomic vectors, of which there are 6 types: 
#a logical 
#b integer (also known as numeric vector) 
#c double  (also known as numeric vector)
#d character 
#e complex   (rarely used) 
#f raw       (rarely used)
#2 Lists, which are also called recursive vectors, since lists can contain other lists.

#The major difference between atomic and lists is that atomic vectors are homogenous, while lists can be heterogenous.

#NULL is often used to represent the absence of a vector (as opposed to NA, the absence of a value in a vector).

#Every vector has 2 key properties:
#1.) Its type, which we can determine with typeof():
typeof(letters)
typeof(1:10)

#2.) Its length, which we can determine with length():
x <- list("a", "b", 1:10)
x
length(x)

#Vectors can also contain additional metadata in the form of attributes, which are used to create augmented vectors.
#Four important types of augmented vectors:

#Factors are built on top of integer values
#Dates and date-times are built on top of numeric vectors
#Data frames and tibbles are built on top of lists

#20.3: Important Types of Atomic Vectors ######################

#20.3.1: Logical ######################################
#The simplest type of atomic vector, because they take one of three values: FALSE, TRUE, or NA.
#Can be created by comparison operators (see 5.2.1) or c():
1:10 %% 3 == 0

c(TRUE, TRUE, FALSE, NA)


#20.3.2: Numeric ######################################
#Integer and double values are known collectively as numeric vectors.
#In R, numbers are double by default.  To make an integer, place an L after the number:
typeof(1)
typeof(1L)
1.5L

#There are 2 important distinctions between integers and doubles:
#1.) Doubles are approximations; they represent floating point numbers which cannot always be precisely represented 
#with a fixed amount of memory.  For example, what is the square of the square root of 2?
x <- sqrt(2) ^ 2
x
x-2
#Instead of comparing floating point numbers using ==, we should use dplyr::near(), which allows for a bit of tolerance.

#2.) Integers have one special value: NA, while doubles have four: NA, NaN, Inf, and -Inf. The latter 3 can arise during division:
c(-1, 0, 1) / 0

#Avoid using == to check for these special values.  Instead, use the helper functions is.infinite(),  is.finite(), and is.nan().


#20.3.3: Character ######################################
#These are the most complex type of atomic vector, because each element of a character vector is a string, 
#and a string can contain an arbitrary amount of data. 

#R uses a global string pool, meaning each unique string is only stored in memory once, and every use of 
#the string points to that representation.  This reduces the amount of memory needed. 

#We can see this with pryr::object_size():
x <- "This is a reasonably long string."
pryr::object_size(x)

y <- rep(x, 1000)
pryr::object_size(y)
#y isn't 1000x as big as x, because each instance is a pointer to x, and a pointer is only 8 bytes.
#(8 * 1000) + 152 = 8.14kB 

#20.3.4: Missing Values ######################################
#Each type of atomic vector has its own missing value:
NA #logical
NA_integer_ #integer
NA_real_ #double
NA_character_ #character
#R will auto-convert NA, but this is good to know as some functions are very strict.


#20.3.5: Exercises ######################################
#1.) Desribe the difference between is.finite(x) and !is.infinite(x)
x <- c(1,2,3,Inf, NaN, -Inf)

is.finite(x)
!is.finite(x)

#2.) Read the source code for dplyr::near().  (Hint: to see the source code, drop the ()) How does it work?
dplyr::near

.Machine$double.eps
#Rather than checking for x=y, the function checks whether x is within the square root of .Machine$double - the smallest floating number.

#3.) A logical vector can take 3 values.  How many possible values can an integer value take?  

#A double?


#4.)Brainstorm at least 4 functions which allow you to convert a double to an integer.  How do they differ?


#5.) What functions from readr allow you to turn a string into a logical, integer and a double value?
#The functions parse_logical, parse_integer, and parse_number


#20.4: Using Atomic Vectors ###################################
#Some important tools for working with atomic vectors include:
#1.) how to convert from one type to another, and when that happens automatically
#2.) how to tell if an object is a certain kind of vector
#3.) what happens when we work with vectors of different lengths
#4.) how to name the elements of a vector
#5.) How to pull out elements of interest


#20.4.1: Coercion ###################################
#Two ways to convert - or coerce - one type of vector to another:

#1.) Explicit coercion happens when you call a function such as as.logical(), as.integer(), as.double(), or as.character().
#If possible, fix this further upstream; for example, tweak your readr "col_types" specification.

#2.) Implicit coercion happens when you use a vector in a specific context which expects a certain type of vector.  For 
#example, when you use a logial vector with numeric summary function, or use a double vector where an integer vector is expected.

#The sum of a logical vector is the number of TRUEs, and the mean is the proportion of TRUEs:
?sample

x <- sample(20, 100, replace = TRUE)

x

y <- x > 10
sum(y) #How many are > 10?
mean(y) #What proportion are > 10?

#When you create a vector with multiple types with c(), the most complex type wins:
typeof(c(TRUE, 1L))
typeof(c(1L, 1.5))
typeof(c(1.5, "a"))
#An atomic vector cannot have multiple types; if you need multiple types, use a list.


#20.4.2: Test Functions ###################################
#You may want to do different things depending on the type of vector.  The is_* function provided by purrr are helpful:
is.logical(x)
is.integer(x)
is.double(x)
is.numeric(x)
is.character(x)
is.atomic(x)
is.list(x)
is.vector(x)
#Each of these also comes in a scalar version, such as is_scalar_atomic(), which checks the length is 1.
is.scalar.atomic(x)

#20.4.3: Scalars and recycling rules ###################################
#R implicitly coerces the length of vectors.  This is called vector recycling - the shorter 
#vector is repeated to match the longer vector.

#This is most useful when mixing vectors and scalars (single numbers where vector length = 1)
?sample
sample(20) + 100 #100 has a vector length 1 and is recycled
?runif
runif(10) > 0.5 #0.5 is recycled in the function

#In R, basic mathematical operators work with vectors.  You should never need to perform explicit iteration
#when performing simple mathematical computations.

#What happens if you add 2 vectors of different lengths?
1:10 + 1:2
#R expands the shortest vector to the same length as the longest by recycling.  This is silent
#except when the length of the longer is not an integer multiple of the shorter:
1:10 + 1:3

#Since this can silently conceal problems, vectorized functions in the tidyverse will throw errors.
#If you want to recycle, you must do this via rep():
tibble(x = 1:4, y = 1:2) #throws an error

tibble(x = 1:4, y = rep(1:2, 2)) #repeats y twice

tibble(x = 1:4, y = rep(1:2, each=2)) #repeats each element twice in a row

#20.4.4: Naming vectors ###################################
#All types of vectors can be named during creation with c():
c(x = 1, y = 2, z= 4)

#...or after the fact with purrr::set_names()
purrr::set_names(1:3, c("a", "b", "c"))


#20.4.5: Subsetting ###################################
#We used dplyr::filter() to filter rows in a tibble; but filter() only works with tibbles.

#For vectors, [] is the subsetting function, and is called like x[a]. 

#There are 4 types of things we can subset a vector with:
#1.) A numeric vector containing only integers.  
#These integers must be all positive, negative, or zero.

#Subsetting with positive vectors keeps the elements at those positions:
x <- c("one", "two", "three", "four", "five")
x[c(3,2,5)]

#By repeating a position, you can make a longer output than the input:
x[c(1,1,5,5,5,2)]

#Subsetting with negative integers drops the elements at those positions:
x <- c("one", "two", "three", "four", "five")
x[c(-2,-3,-5)]

#DO NOT mix negative and positive integers.

#2.) Subsetting with a logical vector keeps all values corresponding to TRUE:
x <- c(10,3,NA, 5,8,1,NA)

#Retrieve all non-missing values from x:
x[!is.na(x)]

#All even or missing values of x:
x[x %% 2 ==0]

#3.) If you have a named vector, can subset it with a character vector:  
x <- c(abc=1, def=2,efg=3)
x
x[c("def", "efg")]

#Can also use a character vector to duplicate individual entries:
x[c("efg", "efg")]

#4.) The simplest type of subsetting is nothing, x[], which returns the complete x.
#This is useful when retrieving only certain rows OR columns.

#If x is 2d, then x[1,] retrieves the first row and all columns.
# x[,1] retrieves only the first column.
# x[,-1] will retrieve all except the first column.

#For more about subsetting, refer to the "Subsetting" chapter of Advanced R (http://bit.ly/subsetadvR)

#20.4.6: Exercises ######################################

#1.) What does mean(is.na(x)) tell you about a vector x? What about sum(!is.finite(x))?

mean(is.na(x)) #Tells us what % of entries are N/A
sum(!is.finite(x)) #Tells us how many NA entries we have.

#2.)Carefully read the documentation of is.vector(). What does it actually test for? 
#Why does is.atomic() not agree with the definition of atomic vectors above?
?is.vector
is.vector(x)

#3.) Compare and contrast setNames() with purrr::set_names().

#4.) Create functions that take a vector as input and returns:

#a.) The last value. Should you use [ or [[?

#b.) The elements at even numbered positions.

#c.) Every element except the last value.

#d.) Only even numbers (and no missing values).

#e.) Why is x[-which(x > 0)] not the same as x[x <= 0]?

#5.) What happens when you subset with a positive integer that???s bigger than the length of the vector? 
#What happens when you subset with a name that doesn???t exist?


#20.5: Recursive Vectors ######################################
#Lists are more complex than atomic vectors, because lists can contain other lists.
#They are sutiable for representing hierarchical or tree-like structures.
#Create a list with list():
x <- list(1, 2, 3)
x

#A useful tool for working with lists is str(), which focuses on the structure, not the contents:
str(x)

x_named <- list(a=1, b=2, c=3)
str(x_named)

#Unlike vectors, lists() can consist of a mix of objects:
y <- list("a", 1L, 1.5, TRUE)
str(y)

#Lists can even contain other lists:
z <- list(list(1,2), list(3,4))
str(z)

#20.5.1: Visualizing Lists ######################################
#See OneNote for depiction


#20.5.2: Subsetting ######################################
#3 ways to subset a list:
a <- list(a = 1:3, b="a string", c= pi, d= list(-1,-5))

#1.) [ extracts a sublist.  The result will always be a list:
str(a[1:2])

#As with vectors, we can subet with a logical, integer, or character vector.

#2.) [[extracts a single component from a list.  It removes a level of hierarchy from the list:
str(y)
str(y[[1]])
str(y[[4]])

#3.) $ is shorthand for extracting named elements of a list:
a$a
a$c
a$d


#20.5.3: Lists of condiments ######################################
#skip

#20.5.4: Exercises ######################################


#20.6: Attributes #############################################
#Any vector can contain additional metadata through its attributes.
#Think of attributes as a list of named vectors which can be attached to any object.

#Get and set individual attributes with attr(), or see them all at once with attributes()
x <- 1:10
attr(x, "greeting")

attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)
x

#There are 3 important attributes used to implement fundamental parts of R:

#Names are used to name the elements of a vector
#Dimensions (or 'dims') make a vector behave like a matrix or an array
#Class is used to implement the S3 object-oriented system
#A detailed discussion of object-oriented programming is found here: http://bit.ly/OOproadvR

#A typical generic function:
as.Date
#The call to "UseMethod" means this is a generic fiunction, and will call a specific method -
# a function - based on the class of the first argument.

#We can list all the methods for a generic with methods():
methods("as.Date")  

#For example, if x is a character vector, as.Date() will call as.Date.character().
#If x is a factor, it'll call as.Data.factor().

#The most important S3 generic is print(), which controls how an object is printed when we type its name into the console.


#20.7: Augmented Vectors ######################################
#Atomic vectors and lists are building blocks for important vector types like factors and dates.  
#These are referred to as augmented vectors, because they are vectors with additional attributes such as class.
#Because they have a class, they behave differently than atomic vectors.

#Four important augmented vectors: Factors, Date-times and times, and Tibbles

#20.7.1: Factors ######################################
#Factors are designed to represent categorical data.
#These are built on top of integers, and have a levels attribute:

x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
attributes(x)
x

#20.7.2: Dates and Date-times ######################################
#Dates in R are numeric vectors that represent the number of days since January 1, 1970:
x <- as.Date("1971-01-01")
unclass(x)
typeof(x)
attributes(x)

#Date-times are numeric vectors with the class POSIXct that represent the number of seconds since January 1, 1970:
x <- lubridate::ymd_hm("1970-01-01 01:00")
unclass(x)
typeof(x)
attributes(x)

#tzone attribute is optional; it shows how the time is printed:
attr(x, "tzone") <-  "US/Pacific"
x

#another type of date-time is called POSIXlt.  These are built on top of named lists:
y <- as.POSIXlt(x)
typeof(y)
attributes(y)

#You'll see these occassionally in base R, as they are necessary to extract specific 
#date components (month, day, second, etc...). POSIXct's are easier to work with, so if
#you have a POSIXlt, convert it to a regular time via lubridate::as_date_time().

#20.7.3: Tibbles ######################################
#Tibbles are augmented lists. They have class "tbl_df" + "tbl" + "data.frame", and 
#names (column) and row.names attributes:
tb <- tibble::tibble(x=1:5, y=5:1)
typeof(tb)

attributes(tb)

#The difference between a tibble and a list is that all of the elements of a data frame 
#must be vectors of the same length.  All functions that work with tibbles enforce the constraint.

#Traditional data.frames have a very similar structure:
df <- data.frame(x=1:5, y=5:1)
typeof(df)
attributes(df) 

#20.7.4: Exercises ######################################
#1.) What does hms::hms(3600) return? 
x <- hms::hms(3600)
#How does it print? 
#What primitive type is the augmented vector built on top of? 
typeof(x)
#What attributes does it use?
attributes(x)

#2.) Try and make a tibble that has columns with different lengths. What happens?
tb <- tibble::tibble(x=1:4, y=5:1)


#3.) Based on the definition above, is it ok to have a list as a column of a tibble?
tb <- tibble::tibble(x = 1:3, y = list("a", 1, list(1:3)))
#Yes, it's fine

###############################################################
#21: Iterations with purrr ####################################
###############################################################
#21.1: Introduction ######################################
#In Chapter 19 - Functions, we covered reducing duplication in code by creating functions 
#instead of copy-pasting.  There are 3 main benefits to reducing code duplication:

#1. Easier to see intent of code - you notice what is different rather than what is the same

#2. Easier to respond to changes in requirements.  As needs change, you only need to change 
#the code in one place.

#3. Likely fewer bugs, because each line is used in more places.

#Functions is one means of reducing duplication. Iteration is another.  This helps when we need to 
#do the same thing to multiple inputs - repeating operations on different columns or data sets.

#Two important iteration paradigms: imperative programming and functional programming.
#Imperative Programming- tools like for loops and while loops.  Very explicit iteration, but very verbose.

#Functional Programming (FP) offers tools to extract out the duplicated code, so each common 
#for loop code gets its own function.  Allows for much less code, easier, with fewer errors.

#21.1.1: Prerequisites ######################################
library(tidyverse) #to load purrr

#21.2: For Loops ######################################
#Imagine this simple tibble: 
df <- tibble(
  a=rnorm(10),
  b=rnorm(10),
  c=rnorm(10),
  d=rnorm(10)
)

#Compute the median of each column.  We could do this with copy and paste:
median(df$a)
median(df$b)
median(df$c)
median(df$d)

#However, this breaks our rule of thumb: Never copy and paste >2x. Instead, use a loop!:
output <- vector("double", ncol(df)) #1. output
for (i in seq_along(df)) {           #2. sequence
  output[[i]] <- median(df[[i]])     #3. body
}
output

#Every "for loop" has 3 components:
#1. The output: output <- vector("double", length(x))  Before starting a loop, we must allocate 
#sufficient space for the output. This is very important, as it will speed the loop.

#General way of creating an empty vector of a given length is the vector() function.
#It has 2 arguments: The type of vector ("logical", "integer", "double") and the length.

#2. The sequence: i in seq_along(df)  This determines what to loop over. Each run of the "for loop"
#will assign i to a different value from seq_along(df).  It's useful to think of i as a pronoun, like "it".

#3. The body: output[[i]] <- median(df[[i]])  This is the code that does the work.
#It's run repeatedly, each time with a different value for i.  The first iteration will run 
#output[[1]] <- median(df[[1]]), the second iteration will run output[[2]] <- median(df[[2]])...

#21.2.1: For Loops Exercises ######################################
#1. Write for loops to:

#Compute the mean of every column in mtcars.
str(mtcars)

output <- vector("double", ncol(mtcars)) #1. output
for (i in seq_along(mtcars)) {           #2. sequence
  output[[i]] <- mean(mtcars[[i]])     #3. body
}
output

#Determine the type of each column in nycflights13::flights.
library(nycflights13)
str(nycflights13::flights)

output <- vector("list", ncol(flights)) #1. output
names(output) <- names(flights)
for (i in names(flights)) {           #2. sequence
  output[[i]] <- class(flights[[i]])     #3. body
}
output

#Compute the number of unique values in each column of iris.
str(iris) #check structure

iris_uniq <- vector("integer", ncol(iris)) #1. output

names(iris_uniq) <- names(iris) #set names of output columns = to those of the data frame 

for (i in names(iris)) {           #2. sequence
  iris_uniq[i] <- length(unique(iris[[i]]))     #3. body
}

iris_uniq

#Generate 10 random normals for each of ??=???10, 0, 10, and 100.
#set number of items to draw
n <- 10 
#Set values of the mean:
mu <- c(-10,0,10,100)

normals <- vector("list", length(mu)) #1. output
for (i in seq_along(normals)) {           #2. sequence
  normals[[i]] <- rnorm(n, mean = mu[i])     #3. body
}

normals

#2. Eliminate the for loop in each of the following examples by taking advantage of an existing function that works with vectors:
out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}

#With function:
str_c(letters, collapse = "")

x <- sample(100)
stdev <- 0
for (i in seq_along(x)) {
  stdev <- stdev + (x[i] - mean(x)) ^ 2
}
stdev <- sqrt(stdev / (length(x) - 1))

#With function:
sd(x)

x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
  out[i] <- out[i - 1] + x[i]
}

#With function:
all.equal(cumsum(x), out)

#3. Combine your function writing and for loop skills:
#c. Convert the song ???99 bottles of beer on the wall??? to a function. Generalise to any number of any vessel containing any liquid on any surface.



#4. It???s common to see for loops that don???t preallocate the output and instead increase the length of a vector at each step:

output <- vector("integer", 0)
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
output

#How does this affect performance? Design and execute an experiment.




#21.3: For loop variations######################################
#There are 4 variations on the basic "for loop" theme:
#1. Modifying an existing object, instead of creating a new object
#2. Looping over names or values, instead of indices
#3. Handling outputs of unknown length
#4. Handling sequences of unknown length

#21.3.1: Modify an existing object##############################
#We want to rescale every object in a data frame, as we did here via a function:
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#To solve via looping, think about the 3 components:
#1. Output: same as the input
#2. Sequence: think of the df as a list of columns; iterate over each column with seq_along(df).
#3. Body: apply rescale01()

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}

#21.3.2: Looping patterns##############################
#Three basic ways to loop over a vector.
#The most basic is looping over numeric vectors with for (i in seq_along(xs)), and extracting the value with
#x[[i]].  There are 2 other forms:

#1. Loop over the elements: for (x in xs).  This is useful only if you want to plot or save a file
#2. Loop over the names: for(nm in names(xs)).  This gives us name, and we can use this to access the value 
#with x[[nm]].  Useful if we want to use the name in a plot title or file name.

#If creating named output, make sure to name the results vector like:
results <- vector("list", length(x))
name(results) <- names(x)

#Itereation over numerical indices is the most general form; given the exact position we can extract both name and value:
for(i in seq_along(x)) {
  name <- names(x)[[i]]
  value <- x[[i]]
}

#21.3.3: Unknown output length##############################
#Sometimes we don't know what the length of the output will be.  For example, if we want to simulate
#some random vectors of random lengths. We might be tempted to progressively grow the vector:

means <- c(0,1,2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100,1)
  output <- c(output, rnorm(n, means[[i]]))
}

str(output)

#This is inefficient: in each iteration, R has to copy all of the data from the previous iterations.

#In technical terms, we get quadratic (O(n^2)) behavior - a loop with 3 times as many elements 
#will take 9 times as long to run! 

#It's better to save the results in a list, then combine into a single vector after the loop finishes:

out <- vector("list", length(means)) 
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}

str(out)
str(unlist(out)) #flattens a list of vectors into a single vector

#This quadratic pattern occurs in other places as well.
#1. we might be generating a long string.  Instead of pasting together each iteration, save the 
#output in a character vector and combine that vector into a single string with paste(output, collapse = "").

#2. When generating a large df... Instead of sequentially rbind()ing each iteration, save the output in a list, 
# then use dplyr::bind_rows(output) to combine.


#21.3.4: Unknown sequence length##############################
#Sometimes we don't know how long a sequence should run; for example, running a simulation until we get 
#three heads in a row.  Here, use a "while" loop rather than a "for" loop.

#A while loop only has 2 components: a conditon and a body:
while(condition) {
  #body
}

#While loops are more general than for loops; we can re-write any for loop as a while loop, but not vice versa:
for (i in seq_along(x)) {
  # body
}

#is equivalent to...

i <- 1
while (i <= length(x)) {
  #body
  i <- i + 1
}

#Here's a while loop to find how many tries it takes to get 3 heads in a row:
flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0

while(nheads < 3) {
  if(flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips

#21.3.5: Exercises##############################
#1. Imagine you have a directory full of CSV files that you want to read in. 
#You have their paths in a vector: 
files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)
#, and now want to read each one with read_csv(). 
#Write the for loop that will load them into a single data frame.

#First, pre-allocate a list:
df <- vector("list", length(files))

#Then, read each file as data frame into an element in the list:
for(fname in seq_along(files)) {
  df[[i]] <- read_csv(files[[i]])
}
#This creates a list of data frames.

#Then, create a single data frame from the list of data frames:
df <- bind_rows(df)

#2. What happens if you use for (nm in names(x)) and x has no names? 
x <- 1:3
print(names(x))
#If no names in the vector, it does not run the loop.

for(nm in names(x)) {
  print(nm)
  print(x[[nm]])
}

#What if only some of the elements are named? 
x <- (c(a=1,2,c=3))

names(x)

for(nm in names(x)) {
  print(nm)
  print(x[[nm]])
}

#What if the names are not unique?
x <- (c(a=1,a=2,c=3))

names(x)

for(nm in names(x)) {
  print(nm)
  print(x[[nm]])
}


#3. Write a function that prints the mean of each numeric column in a data frame, along with its name. 
#For example, show_mean(iris) would print:

show_mean(iris)
#> Sepal.Length: 5.84
#> Sepal.Width:  3.06
#> Petal.Length: 3.76
#> Petal.Width:  1.20

show_mean <- function(df, digits = 2) {
  #get max length of all variable names in the data set
  maxstr <- max(str_length(names(df)))
  for (nm in names(df)) {
    if (is.numeric(df[[nm]])) {
      cat(
        str_c(str_pad(str_c(nm, ":"), maxstr + 1L, side="right"),
              format(mean(df[[nm]]), digits = digits, nsmall = digits),
        ),
        "\n"
      )
    }
  }
}

show_mean(iris)

#(Extra challenge: what function did I use to make sure that the numbers lined up nicely, even though the 
#variable names had different lengths?)

#4. What does this code do? How does it work?
trans <- list( 
  disp = function(x) x * 0.0163871,
  am = function(x) {
    factor(x, labels = c("auto", "manual"))
  }
)

for (var in names(trans)) {
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}


#21.4: For loops vs. functions ######################################
#For loops aren't as important in R, because R is a functional programming language.  This means
#you can wrap for loops in a function, and call that function instead of using the loop directly.

#Consider this simple data frame to see why this is important:
df <- tibble(
  a=rnorm(10),
  b=rnorm(10),
  c=rnorm(10),
  d=rnorm(10)
)

#Compute the mean of very column with a for loop:
output <- vector("double", length(df))

for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}

output

#If we'll want to do this frequently, we'll extract it out into a function:
col_mean <- function(df) {
  output <- vector("double", length(df))
  
  for (i in seq_along(df)) {
    output[[i]] <- mean(df[[i]])
  }
  output
}

#Then you realize you'll also want to compute the median and standard deviation, so you copy and paste the
#col_mean function and replace mean() with median() and sd():
col_median <- function(df) {
  output <- vector("double", length(df))
  
  for (i in seq_along(df)) {
    output[[i]] <- median(df[[i]])
  }
  output
}

col_sd <- function(df) {
  output <- vector("double", length(df))
  
  for (i in seq_along(df)) {
    output[[i]] <- sd(df[[i]])
  }
  output
}

#Now we've copied and pasted the code twice: time to think about how to generalize it.
#Note it's hard to see what changes in the boilerplate.

#What if you saw a set of functions like this?
f1 <- function(x) abs(x - mean(x)) ^ 1
f2 <- function(x) abs(x - mean(x)) ^ 2
f3 <- function(x) abs(x - mean(x)) ^ 3

#Hopefully, you'd notice the duplication and extract it out:
f <- function(x,i) abs(x - mean(x)) ^ i
#This reduced the amount of cose and the chance of a bug.

#We can do the same thing with col_mean(), col_median(), and col_sd():
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  
  for (i in seq_along(df)) {
    out[[i]] <- fun(df[[i]])
  }
  out
}

col_summary(df,median)
col_summary(df,mean)
col_summary(df,sd)

#Passing a function to another function is very powerful, and is one of the elements which makes R 
#a functional programming language.
?apply

#21.5: The map functions ######################################
#The purrr package provides a family of functions for looping over a vector, doing something to each element
#and saving the results:

#map() makes a list.
#map_lgl() makes a logical vector.
#map_int() makes an integer vector.
#map_dbl() makes a double vector.
#map_chr() makes a character vector.

#Each of these takes a vector as an input, applies a function to each piece, then returns a new vector the same length.
#The type of vector is determined by the suffix to the map function.

map_dbl(df, mean)
map_dbl(df, median)
map_dbl(df, sd)

#You can see the focus is on the operation being performed rather than the code required to loop over every element.

#THis is even more apparent when using the pipe:

df %>% map_dbl(mean)
df %>% map_dbl(median)
df %>% map_dbl(sd)

#There are a few differences between map*() and col_summary():
#purrr functions are implemented in C for speed

#The second argument, .f, the function to apply, can be a formula, a character vector, or an integer vector.

#map_*() uses ... to pass along additional arguments to .f each time it's called:
map_dbl(df, mean, trim = 0.5)

#The map function also preserves names:
z <- list(x=1:3, y=4:5)

map_int(z, length)

#21.5.1: Shortcuts ######################################
#A few shortcuts to use with .f to save a little typing...
#Saw we want to fit a linear model to each group in a dataset.
#Here, we split mtcars into 3 sets (one for each amount of cylinders) and fit the same linear model to each:
models <- mtcars %>%
  split(.$cyl) %>%
  map(function(df) lm(mpg~ wt, data = df))

#purrr provides a one-sided formula as a convenient shortcut:
models <- mtcars %>%
  split(.$cyl) %>%
  map(~lm(mpg ~ wt, data = .))
#here, we've used . as a pronoun: it refers to the current list element, like i referred to the current index in the for loop.

#When looking at many models, we'll want to extract summary stats like R^2.
#To do this, first run summary() and then extract the r.squared component using the shorthand for anonymous functions:
models %>%
  map(summary) %>%
  map_dbl(~.$r.squared)

#Extracting named components is so common that purrr provides an even shorter shortcut: using a string:
models %>%
  map(summary) %>%
  map_dbl("r.squared")

#We can also use an integer to select elements by position:
x <- list(list(1,2,3), list(4,5,6), list(7,8,9))
x %>% map_dbl(2)


#21.5.2: Base R ######################################
#There are similarities between purrr and the apply family of functions.

#lapply() is similar to map(), except that map() is consistent with all functions in purrr, 
#and we can use the shortcuts for .f

#Base sapply() is a wrapper around lapply() that automatically simplifies output.
#This si good for interactive work, but problematic in a function because you never know what 
#sort of output you'll get:
x1 <- list(
  c(0.27, 0.37, 0.57, 0.91, 0.20),
  c(0.90, 0.94, 0.66, 0.63, 0.06), 
  c(0.21, 0.18, 0.69, 0.38, 0.77)
)

x2 <- list(
  c(0.50, 0.72, 0.99, 0.38, 0.78), 
  c(0.93, 0.21, 0.65, 0.13, 0.27), 
  c(0.39, 0.01, 0.38, 0.87, 0.34)
)

threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()
x2 %>% sapply(threshold) %>% str()

#vapply() is a safer alternative to sapply(), because you supply additional arguments to define the type.
#however, vapply() is a lot of typing: vapply(df, is.numeric, logical(1)) is equivalent to map_lgl(df, is.numeric).
#vapply() can produce matrices, map cannot.

#21.5.3 Exercises
#1. Write code that uses one of the map functions to:
#a. Compute the mean of every column in mtcars.
map_dbl(mtcars, mean)  

#b. Determine the type of each column in nycflights13::flights.
map(nycflights13::flights, class)

#c. Compute the number of unique values in each column of iris.
map_int(iris, ~length(unique(.)))

#d. Generate 10 random normals for each of ?? =  ???10, 0, 10, and 100.
map(c( ???10, 0, 10, 100),rnorm, n=10)

#2. How can you create a single vector that for each column in a data frame indicates whether or not it???s a factor?
?map_lgl
map_lgl(mtcars, is.factor)

#3. What happens when you use the map functions on vectors that aren???t lists? What does map(1:5, runif) do? Why?
map(1:5, runif)

#4. What does map(-2:2, rnorm, n = 5) do? Why? What does map_dbl(-2:2, rnorm, n = 5) do? Why?
map(-2:2, rnorm, n = 5) #takes samples of n=5 from normal distributions of means -2,-1,0,1,2 and returns a list for each
map_dbl(-2:2, rnorm, n = 5)#map_dbl expects the function to return a numeric vector of length one.  Instead, try:
flatten_dbl(map(-2:2, rnorm, n=5))

#5. Rewrite map(x, function(df) lm(mpg ~ wt, data = df)) to eliminate the anonymous function.
map(list(mtcars), ~lm(mpg ~wt, data=.))


#21.6: Dealing with failure ######################################
#When we use the map functions to repeat many procedures, we have an increased chance of failure.
#This results in a failure message, and no output at all.  Here, we learn how to deal with this with safely().

#safely() is an adverb; it takes a function (a verb) and returns a modified version.
#The modified version won't throw an error; instead, it returns a list with 2 elements:

#1. result is the original result.  If there was and error, this will be NULL
#2. error is an object error; if the operation was successful, this will ne NULL

#An example:
safe_log <- safely(log)
str(safe_log(10))

str(safe_log(a))

#safely is designed to work with map.
x <- list(1, 10, "a")
y <- x %>%map(safely(log))
str(y)

#Would be better if we had 2 lists: one with all of the errors, a second with all the output.
#Easy to get this using purrr::transpose():
y <- y%>% transpose()
str(y)

#Typically will look at either the values of X where y is an error, or work with y's which are okay:
is_ok <- y$error %>% map_lgl(is_null)
x[!is_ok]

y$result[is_ok] %>% flatten_dbl()

#Two other useful adverbs in purrr:
#possibly() also always succeeds.  You give it a default value to return when there's an error:
x <- list(1,10,"a")
x %>% map_dbl(possibly(log, NA_real_))

#quietly() performs a role similar to safely(), but instead of capturing errors, it captures
#printed output, messages, and warnings:
x <- list(1,-1)
x %>% map(quietly(log)) %>% str()


#21.7: Mapping over multiple arguments ######################################
#map2() and pmap() allow us to iterate along multiple related inputs in parallel.

#For example, simulate some random normals with different means:
mu <- list(5, 10, -3)
mu %>%
  map(rnorm, n=5) %>%
  str()

#But, what if we also want to vary the stdev?
#use map2():
sigma <- list(1,5,10)

map2(mu, sigma, rnorm, n=5) %>% str()
#Note: arguments which vary for each call come before the function; arguments which are static for each call come after.

#map2() is just a wrapper around a for loop:
map2 <- function(x, y, f, ...) {
  out <- vector("list", length(x))
  for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]], y[[i]],...)
  }
  out
}

#We can imagine map3(), map4(), etc...
#purrr provides pmap() so that we can provide a lists of arguments
?pmap

n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)
args1 %>%
  pmap(rnorm) %>%
  str()

#pmap uses positional matching when calling the function if you don't name the elements of the list.
#It's better to name the arguments:
args2 <- list(mean=mu, sd=sigma, n=n)

args2 %>%
  pmap(rnorm) %>%
  str()

#Since the arguments are the same length, it makes sense to store them in a data frame:
params <- tribble(
  ~mean, ~sd, ~n,
  5, 1, 1, 
  10, 5, 3,
  -3, 10, 5
)
params%>%
  pmap(rnorm)

#21.7.1: Invoking Different Functions ######################################
#In addition to varying the arguments to the function, you might want to vary the function itself:
f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min=-1, max=1),
  list(sd = 5),
  list(lambda = 10)
)

#To handle this case, use invoke_map():
invoke_map(f, param, n = 5) %>% str()
#First argument is the list of functions, second a list of list with arguments for each function.

#can use tribble to make creting the matching pairs easier:
sim <- tribble(
  ~f, ~params,
  "runif", list(min=-1, max=1),
  "rnorm", list(sd=5),
  "rpois", list(lambda = 10)
)
sim %>%
  mutate(sim = invoke_map(f, params, n=10))


#21.8: Walk ######################################
#Walk is an alternative to map, used when calling a fnction for side effects rather than for its return value.
#For example, if you want to render output to a screen, or to save files.  For example:

x <-  list(1, "a", 3)

x %>% 
  walk(print)

#walk2() or pwalk() are much more useful.  For example, if you have a list of plots and a vector of filenames:
library(ggplot2)
plots <- mtcars %>%
  split(.$cyl) %>%
  map(~ggplot(., aes(mpg, wt)) + geom_point())
paths <- stringr::str_c(names(plots), ".pdf")

pwalk(list(paths, plots), ggsave, path = tempdir())


#21.9: Other patterns of for loops ######################################
#These are less useful, but good to know about.

#21.9.1: Predicate Functions ######################################
#A number of functions work with predicate functions that return either a single TRUE or FALSE

#keep() and discard() retain certain elements of the input where the predicate is TRUE or False, respectively:
str(iris)

iris %>%
  keep(is.factor) %>%
  str()

iris %>%
  discard(is.factor) %>%
  str()

#some() and every() determine whether the predicate is true for any or all of the elements:
x <- list(1:5, letters, list(10))

x %>%
  some(is_character)

x %>%
  every(is_character)

#detect() finds the first element where the predicate is true; detect_index()  returns its position:
x <- sample(10)
x

x %>%
  detect(~.>5)

x %>%
  detect_index(~.>5)

#head_while() and tail_while() take elements from the start or end of a vector while a predicate is true
x %>%
  head_while(~.>5)

x %>%
  tail_while(~.>5)


#21.9.2: Reduce and Accumulate ######################################
#You may have a complex lists you want to reduce to a simple list by repeatedly applyng a function.
#Say you have a list of data frames, and want to reduce to a single df by joining the elements together:

dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name=c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs %>% reduce(full_join)

#Or maybe you have a list of vectors and want to find the intersection:
vs <- list(
  c(1,3,5,6,10),
  c(1,2,3,7,8,10),
  c(1,2,3,4,8,9,10)
)

vs %>% reduce(intersect)

#Accumulate() is similar, but keeps all of the interim results.  For insance, for a cumulative sum:
x <- sample(10)
x
x %>% accumulate(`+`)


#21.9.3: Exercises ######################################
#1. Implement your own version of every() using a for loop. 
#Compare it with purrr::every(). 
#What does purrr???s version do that your version doesn???t?

#2. Create an enhanced col_sum() that applies a summary function to every numeric column in a data frame.

#3. A possible base R equivalent of col_sum() is:
col_sum3 <- function(df, f) {
  is_num <- sapply(df, is.numeric)
  df_num <- df[, is_num]
  
  sapply(df_num, f)
}

#But it has a number of bugs as illustrated with the following inputs:
df <- tibble(
  x = 1:3, 
  y = 3:1,
  z = c("a", "b", "c")
)
# OK
col_sum3(df, mean)
# Has problems: don't always return numeric vector
col_sum3(df[1:2], mean)
col_sum3(df[1], mean)
col_sum3(df[0], mean)

#What causes the bugs?