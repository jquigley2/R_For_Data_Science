###############################################################
#9: Introduction ##############################################
###############################################################
#Wrangling: the art of getting data into R in a useful form for viz and analysis

#In Tibbles, we'll learn about the variant of the data frame, what makes them different and how to create them

#In Data Import, we'll learn how to get data into R

#In Tidy Data, we'll learn about tidy data: a consistent way of storing data which makes xform, viz, and 
#analysis easier.


###############################################################
#10: Tibbles ##############################################
###############################################################
#10.1: Introduction ##############################################
###############################################################
#Tibbles are data frames with some slight tweaks.  The tibble package provides opinionated
#data frames whivh make working in the tidyverse easier.

#If you want to learn more about tibles:
vignette("tibble")

library(tidyverse)


###############################################################
#10.2: Creating tibbles ##############################################
###############################################################
#We can coerce a data frame into a tibble with as_tibble():
as_tibble(iris)

#We can create a new tibble from individual vectors with tibble(); it will automatically
#recycle inputs of length 1, and allow us to refer to variables just created:
tibble(
  x=1:5,
  y=1,
  z=x^2 + y
)

#tibble does much less than data.frame():
  #never changes the type of input;
  #never changes the name of variables;
  #never creates row names

#It's possible for tibbles to have column names which are non-sntactic;
#For example, they moght not start with a letter, or might contain a space.
#To refer to these, we need to surrond them with backticks, '
tb <- tibble(
  ':)' = "smile",
  ' ' = "space",
  '2000' = "number"
)

tb
#We also need backticks when working with these variables in other packages such as ggplot2, dplyr, and tidyr

#Antoher way to create a tibble is with tribble: short for transposed tribble.
#tribble() is customized for data entry in code:
#column headings are defined by formulas (i.e. they start with ~), and 
#entries are separeated by commas.  This allows us to lay out small amounts of data in easy to read form.

tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5
)
#Good idea to add a comment - the line with # - to make it clear where the header is.

###############################################################
#10.3: Tibbles vs. data.frame ##############################################
###############################################################
#Two main differences between the usage of tibble and data.frame: printing and subsetting.


###############################################################
#10.3.1: Printing ##############################################
#Tibbles have a refined print method that shows only the first 10 rows, and all the columns it can fit.
#Each column also reports its type:
tibble(
  a = lubridate::now() + runif(1e3) *86400,
  b = lubridate::today() + runif(1e3) *30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

#Tibbles are designed to not overwhelm your console by acidentally printing too much.
#If we want to print more, we can explicitly print() the data frame and control number of rows and width:
nycflights13::flights %>%
  print(n=10, width = Inf)

#We can also conrol default behavior by setting options:
options(tibble.print_max = n, tibble.print_min = m) 
options(dplyr.print_min = Inf) # to always show all rows
#Use package?tibble to see all options

#Final option: Use R's built-in viewer to get a scrollable view of entire data set:
nycflights13::flights %>%
  View()


###############################################################
#10.3.1: Printing ##############################################
#If we want to pull out a single variable, we use $ and [[.
# [[ can extract by name or position; $ only extracts by name:
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

View(df)

#Extract by name:
df$x

#or:
df[["x"]]

#Extract by position:
df[[1]]
df[[2]]


###############################################################
#10.4: Interacting with older Code ##############################################
###############################################################
#Some older functions don't work with tibbles.  In this case, turn them back to data frames:
class(as.data.frame(tb))

#The main reason tibbles may not work is due to the use of [ function.

###############################################################
#10.5: Exercises ##############################################
###############################################################
#1. How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame).

#2. Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? 
#Why might the default data frame behaviours cause you frustration?
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

#3. If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract the reference variable from a tibble?

#4. Practice referring to non-syntactic names in the following data frame by:
  
  #1.Extracting the variable called 1.

  #2.Plotting a scatterplot of 1 vs 2.

  #3.Creating a new column called 3 which is 2 divided by 1.

  #4.Renaming the columns to one, two and three.

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

#5. What does tibble::enframe() do? When might you use it?

#6. What option controls how many additional column names are printed at the footer of a tibble?


###############################################################
#11: Data Import ##############################################
###############################################################
#11.1: Introduction ##############################################
###############################################################
#11.1.1 Prerequisite: We'll load files with the "readr" package
library(tidyverse)
###############################################################
#11.2: Getting started ##############################################
###############################################################
#Many of readrs' functions deal with turning flat files into data frames:
#read_csv() reads comma delimited files
#read_cvs2() reads semicolon delimited files
#read_tsv() reads in tab-delimited files  
#read_delim() reads in files with any delimiter
#read_fwf() reads fixed width files
#we can specify fields either by their widths with fwf_widths(), or their position with fwf_positions().
#read_table() reads a variation of fixed width files where columns are separated by white space.
#read_log() reads Apache log files

#check out webreadr, built on top of read_log()

#These all have a similar syntax; if you know how to use read_csv(), you can use any of these!

#First argument is most iportant: teh path to read the file.
heights <- read_csv("diamonds.csv")

#Can also suply an inline .csv file:
read_csv("a,b,c
         1,2,3
         4,5,6")

#In both instances, read_csv() uses the first line as column headers.
#Two cases where we might wnt to tweak this behavior:
#1. If there are a few lines of metadata atop the file, use skip = n, or use comment = "#'
# to drop all lines that start with # (or whatever symbol is used for comments)
read_csv("the first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)

read_csv("#A comment i want to skip
         x,y,z
         1,2,3", comment = "#")

#2. The data may not have column names.  Use col_names = FALSE, and read_csv() will not treat the
# first row as coluns, and will assign them sequential headings from x1 to xn:
read_csv("1,2,3\n4,5,6", col_names = FALSE) #  "\n" is a shortcut for adding a new line.

# Or, we can pass column names in:
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))


#11.2.1: Compared to base R ##############################################
#Why not use the base function, read.csv()?
  
  #readr functions are about 10x faster, and long running jobs have a progress bar
    #data.table::fread() is even faster!

  #readr functions produce tibbles, and don't convert character vectors to factors

  #readr functions are more reproducible.

#11.2.2: Exercises:
#1. What function would you use to read a file where fields were separated with ???|????
read_delim(file, delim = "|")

#2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() 
#have in common?


#3. What are the most important arguments to read_fwf()?
?read_fwf() #col_positions is most important

#4. Sometimes strings in a CSV file contain commas. To prevent them from causing problems, 
#they need to be surrounded by a quoting character, like " or '. By convention, 
#read_csv() assumes that the quoting character will be ", and if you want to change it 
#you???ll need to use read_delim() instead. 

#What arguments do you need to specify to read the following text into a data frame?:

"x,y\n1,'a,b'"

x <- "x,y\n1,'a,b'"

read_delim(x, ",", quote = "'")

#5. Identify what is wrong with each of the following inline CSV files. 
#What happens when you run the code?
read_csv("a,b\n1,2,3\n4,5,6") #uneven line length; skips 3rd column
read_csv("a,b,c\n1,2\n1,2,3,4") #uneven; n/a for 3rd entry row #2, skips fourth entry row 3
read_csv("a,b\n\"1") #extra quote
read_csv("a,b\n1,2\na,b") #nothing?
read_csv("a;b\n1;3") #colon-separated, use read_csv2() instead


###############################################################
#11.3: Parsing a vector ##############################################
###############################################################
#The parse_*() functions take a character vector and return a specialized vector (logical, integer, or date):
str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2001-01-01", "1979-10-14")))
#These functions are an important building block in readr; they fit together to parse files

#The parse_*() functions are uniform: 1st argument is a character vector to parse, "na" specifies 
#which strings s/b treated as missing:
parse_integer(c("1", "231", ".", "456"), na = ".")

#If parsing fails, we get a warning:
x <- parse_integer(c("123", "345", "abc", "123.45"))

#...and all failures are missing in the output:
x

#If there are many parsing failures, use problems() to retrieve the complete set.
#problems() returns a tibble we can manipulate with dplyr:
problems(x)

#8 particularly important parsers:
#1. parse_logical() and parse_integer() parse logicals and integers, respectively.

#2. parse_double() is a strict numeric parser, and and parse_number() is a flexible numeric parser.

#3. parse_charater() - one complication: character encodings 

#4. parse_factor() creates factors, whuch R uses to represent categorical factors with fixed & known values.

#5. parse_datetime(), parse_date(), and parse_time() allow us to parse various time & date specs.  These 
#are most complicated, since dates come in so many forms.

###############################################################
#11.3.1: Numbers ##############################################
#Three problems make parsing a number tricky:
  #1. People write numbers differently in different parts of the world.  Some write decimals with ".", 
  #some with ",". 

    #For this prolem, readr has the notion of a "locale":
    parse_double("1.23")


    parse_double("1,23", locale = locale(decimal_mark = ","))
    
  #2. Numbers are often surrounded by labels such as $ or %

    #parse_number() ignores non-numeric characters before and after thr number.  Usefule for currencies 
    #and percentages, as well as extracting numbers from text:
    parse_number("$100")
    
    parse_number("10%")
    
    parse_number("Or even extracting numbers from $10.45 text like this!")
  
  #3. Numbers often contain grouping numbers to make reading easier, such as "," in 1,000,000 
    #A combination of parse_number() and locale can solve this issue:
    # Used in America
    parse_number("$123,456,789")
    
    # Used in many parts of Europe
    parse_number("123.456.789", locale = locale(grouping_mark = "."))
    
    # Used in Switzerland
    parse_number("123'456'789", locale = locale(grouping_mark = "'"))
    
###############################################################
#11.3.2: Strings ##############################################
#There are multiple ways to represent the same string.  In R, we can get at the underlying representation
#of a string using charToRaw():
    charToRaw("Hadley")
    #Each hexdecimal number reps a byte of information.  This is ASCII encoding.
    
    #readr uses UTF-8, which is supported just about everywhere (even supports emojis).
    
    #This will fail for data produced by older systems which do not understand UTF-8.  To fix this, we 
    #need to specify the encoding in parse_character():
    x1 <- "El Ni\xf1o was particularly bad this year"
    
    x1
    
    parse_character(x1, locale = locale(encoding = "Latin1"))
    
    # If you???d like to learn more I???d recommend reading the 
    #detailed explanation at http://kunststube.net/encoding/.
    
###############################################################
#11.3.3: Factors ##############################################
#R uses factors to represent categorical values which have a known set of possible values.
    #Give parse_factor() a vector of known levels to generate a warning whenever an 
    #unexpected value is present:
    fruit <- c("apple", "banana")
    parse_factor(c("apple", "banana", "bananana"), levels = fruit)

    #However, if we have many prolematic values, it's often easier to leave as character vectors
    #and then use tools we'll learn in strings and factors to clean them up.    
        
###############################################################
#11.3.4: Dates & times ##############################################
#Parser used depends on whether you want a date (# days since 1970-01-01), a date-time (# seconds since midnigight 1970-01-01),
#or a time (# seconds since midnight).
    #parse_datetime() expects an ISO8601 date-time - an international standard with components arranged
      #From biggest to smallest: year, month, day, hour, minute, second
  
      parse_datetime("2010-10-01T2010")
      
      parse_datetime("20101010")
  
      #if you work with dates and times frequently, I recommend 
      #reading https://en.wikipedia.org/wiki/ISO_8601  

    #parse_date() expects a 4 digit year, a - or  /, the month, a - or a /, then the day:
      parse_date("2010-10-10")
      
    #parse_time expects the hour, : or ., minutes, optionally : and seconds and an optional am/pm specifier:
      library(hms)
      
      parse_time("01:10 am")
    
      parse_time("20:10:01")
      
    #We can also create our own date time format using the following:
      #Year
        # %Y (4 digit year)
        # %y (2 digit year: 00-69 -> 2000 - 2069; 70-99 -> 1970-1999)
      #Month
        # %m
        # %m
        # %m
      #Day
      
      #Time
      
      
###############################################################
#11.4: Parsing a file ##############################################
###############################################################


###############################################################
#11.5: Writing to a file ##############################################
###############################################################


###############################################################
#11.6: Other types of data ##############################################
###############################################################
