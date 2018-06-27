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
        # %m (2 digits)
        # %b (abbreviated name such as "Jan")
        # %B (full name, "January")
      #Day
        # %d (2 digits)
        # %e (optional leading spaces)
      #Time
        # %H 0-23 hour
        # %I 0-12, must be used with %p
        # %pAM/PM indicator
        # %Mminutes
        # %S integer seconds
        # %OS real seconds
        # %z Time zone as name, e.g. America/New York (see more in "time zones")
      parse_date("01/02/15", "%m/%d/%y")
      
      parse_date("01/02/15", "%d/%m/%y")
      
      parse_date("01/02/15", "%y/%m/%d")
      
###############################################################
#11.3.5: Exercises ##############################################      
#1.What are the most important arguments to locale()?
      
#2.What happens if you try and set decimal_mark and grouping_mark to the same character? What happens to the default value of grouping_mark when you set decimal_mark to b ,b ? What happens to the default value of decimal_mark when you set the grouping_mark to b .b ?
      
#3.I didnb t discuss the date_format and time_format options to locale(). What do they do? Construct an example that shows when they might be useful.
      
#4.If you live outside the US, create a new locale object that encapsulates the settings for the types of file you read most commonly.
      
#5.Whatb s the difference between read_csv() and read_csv2()?
      
#6.What are the most common encodings used in Europe? What are the most common encodings used in Asia? Do some googling to find out.
      
#7.Generate the correct format string to parse each of the following dates and times:
        
      d1 <- "January 1, 2010"
      d2 <- "2015-Mar-07"
      d3 <- "06-Jun-2017"
      d4 <- c("August 19 (2015)", "July 1 (2015)")
      d5 <- "12/30/14" # Dec 30, 2014
      t1 <- "1705"
      t2 <- "11:15:10.12 PM"
      
###############################################################
#11.4: Parsing a file ##############################################
###############################################################
#How does readr parse a file?  How does it guess the type of each column, and 
#how can we override the default specs?
      
###############################################################
#11.4.1: Strategy ##############################################
#readr reads the first 100 rows and uses heuristics to figure out each column type
           
###############################################################
#11.4.2: Problems ##############################################
#Defaults don't always work for large files:
  #1: First thousand rows may not be a representatitve sample
  #2. The column might contain a lot of missing values, in which case readr assumes a character vector.
challenge <- read_csv(readr_example("challenge.csv"))

#If there is an issue parsing, it's wise to pull out the problems() to explore in depth:
problems(challenge)
      
#Work column by column to resolve problems. There is a parsing problem witht he x column - 
#trailing characters after the integer.  We need a double parser:

#start by pasting column specs into original call:
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_integer(),
    y = col_character()
  )
)
  

#tweak the type of the x colum:
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)  

#but last few rows are dates in a character vector:
tail(challenge)

#we can fix that by:
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)  

tail(challenge)

#Every parse_xyz() function has a corresponding col_xyz() function. 
#use parse_xyz() when the data is in a character vector in R already; 
#use col_xyz() when you want to tell readr how to load the data.

#highly recommend always supplying col_types, building up from the print-out provided by readr.

#If you want to be really strict, use stop_for_problems() 
#this will throw an error and stop your script if there are any parsing problems.


###############################################################
#11.4.3: Other Strategies ##############################################
#A few other strategies to help parse problematic files:
#Look at more rows of data:
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)      

problems(challenge2)      

#It is sometimes easier to diagnose problems if we read everything in as character vectors:
challenge2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
                       )      

problems(challenge2)


#If reading a very large file, we might set n_max to 10,000 or 100,000 while we work through problems.

###############################################################
#11.5: Writing to a file ##############################################
###############################################################
#readr also writes back to disk via write_csv() and write_tsv().  Each always:
  #encodes strings in UTF-8
  #saves dates and times in ISO8601 format

#If you want to export a csv file to Excel, use write_excel_csv() b  this writes a special character 
#(a b byte order markb ) 
#at the start of the file which tells Excel that youb re using the UTF-8 encoding.

#The most important arguments are x (the data frame to save), and path (the location to save it). 
#You can also specify how missing values are written with na, and if you want to append to an existing file.

write_csv(challenge, "challenge.csv")

#however, we do lose data type when we write to .csv.  We'd need to recreate types each time we read in.
#Two alternatives:
  #1.write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS(). 
  #These store data in Rb s custom binary format called RDS:
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")


  #2. The feather package implements a fast binary code format which can be shared across languages:
install.packages("feather")  
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")


###############################################################
#11.6: Other types of data ##############################################
###############################################################
#Other tidyverse packages to imprt data include:
#Haven reads SPSS, Stata and SAS files
#readxl reads Excel files (.xls and .xlsx)
#DBI allows us to run SQL queries


###############################################################
#12: Tidy Data ##############################################
###############################################################
library(tidyverse)

###############################################################
#12.2: Tidy Data ##############################################
#We can organize data many different ways.

#The tidy dataset will be much easier to work with within the tidyverse.
#Three inter-related rules make the dataset tidy:
  #1. Each variable must have its own column
  #2. Each observation must have its own row
  #3. Each value must have its own cell

#Two main advantages of having tidy data:
  #1. It forces you to have a consistent way of storing data
  #2. Placing variables in columns allows R to use vectors

#Example:
table1 %>%
  mutate(rate=cases / population * 10000)

#compute cases/year:
table1 %>%
  count(year, wt = cases)

#visualize changes over time:
library(ggplot2)
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group=country), color="grey50") + 
  geom_point(aes(color=country))



###############################################################
#12.2.1: Exercises ##############################################

#1. Using prose, describe how the variables and observations are organised in each of the sample tables.

#2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
  #1 Extract the number of TB cases per country per year.
  #2 Extract the matching population per country per year.
  #3 Divide cases by population, and multiply by 10000.
  #4 Store back in the appropriate place.

#3. Which representation is easiest to work with? Which is hardest? Why?

#4. Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?

###############################################################
#12.3: Spreading and Gathering ##############################################
#most data you encounter will be untidy, for one of two reasons:
#1. Most people are unfamiliar with the principles of tidy data
#2. Data is often organized with some other purpose in mind

#When tidying data, step one is always identifying what the variables and observations are.
#Step 2 is resolving one of 2 common issues:
  #1. One variable may be spread across multiple columns
  #2. One observation may be spread across multiple rows

#To fix these two problems, the two most important functions in tidy are gather() and spread()

###############################################################
#12.3.1: Gathering ##############################################

#A common issue is when column names aren't the names of variables, but values of a variable:
table4a

#To tidy, we need to gather those columns into a new pair of variables.  We need 3 parameters:
  #The set of columns which represent values, not variables.  Here, these columns are 1999 and 2000.
  #The name of the variable whose value forms the column names.  This is the "key"; here, it's "year"
  #The name of the variable whose value is spread over the cells.  This is the "value"; here, it's # cases.

table4a %>%
  gather(`1999`, `2000`, key = "year", value="cases")# need to surround 1999 and 2000 with backticks b/c don't start w/ a letter

#example 2:
table4b
table4b %>%
  gather(`1999`, `2000`, key = "year", value="population")# need to surround 1999 and 2000 with backticks b/c don't start w/ a letter

#We can then combine the tidied versions of 4a and 4b into a single tibble by using dplyr::left_join():
tidy4a <- table4a %>%
  gather(`1999`, `2000`, key = "year", value="cases")
tidy4b <- table4b %>%
  gather(`1999`, `2000`, key = "year", value="population")  
left_join(tidy4a,tidy4b) #More about left_join in Chapter 13 "Relational Data"


###############################################################
#12.3.2: Spreading ##############################################
#The opposite of gathering.  We use this when an observation is scattered accross multiple rows

#here's an example:
table2

#To tidy, we analyze using 2 parameters:
  #1. The column that contains the variable names, the "key" column.  Here, it's "type"
  #2. The column that contains the values for multiple variables, the "value" column.  Here, it's "count"
#Then, use spread:
spread(table2, key=type, value=count)

#So, spread and gather are complements:
  #gather makes the tables narrower and longer; #spread makes them wider and shorter

###############################################################
#12.3.3: Exercises ##############################################
#1. Why are gather() and spread() not perfectly symmetrical?
#Carefully consider the following example:
  
stocks <- tibble(
    year   = c(2015, 2015, 2016, 2016),
    half  = c(   1,    2,     1,    2),
    return = c(1.88, 0.59, 0.92, 0.17)
  )
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

#(Hint: look at the variable types and think about column names.)

#Both spread() and gather() have a convert argument. What does it do?

#2. Why does this code fail?

table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
#> Error in combine_vars(vars, ind_list): Position must be between 0 and n

#3. Why does spreading this tibble fail? How could you add a new column to fix the problem?

people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

#4. Tidy the simple tibble below. Do you need to spread or gather it? What are the variables?

preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)


###############################################################
#12.4: Separating and Uniting ##############################################
#table3 has a different problem: we have one column "rate" which contains 2 variables: cases & population


###############################################################
#12.4.1: Separate ##############################################
#To fix this, we use the "separate" function - the complement of which is the "unite" function:
#"separate" pulls a single column apart into multiple columns
table3
#The "rate" coulnn contains both cases and population - we need to split these on the separator character:

table3 %>%
  separate(rate, into =c("cases", "population"))
#"separate" takes the name of the column, and the names of the columns we want to split this one into

#By default, "separate" splits wherever it sees a non-alphanumeric character.
#If we want to specify, we can pass the character to the sep argument of separate.  For example:
table3 %>%
  separate(rate, into =c("cases", "population"), sep="/")

#However, in each of these separate attempts, the column type remained character - not very useful! 
#We can ask separate to try to convert the type by using convert=TRUE:
table3 %>%
  separate(rate, into =c("cases", "population"), sep="/", convert=TRUE)
#now, these are integer type!

#Can also pass a vector of integers to sep.  separate() will interpret the integers as positions to split at.
#Positive values start at 1 on the far-lefto f strings, negative values at -1 on the far right.
#When using integers, the length of sep s/b 1 less than the number of names in into.

#EX: separate the last 2 digits of each year:
table3 %>%
  separate(year, into =c("century", "year"), sep=2)


###############################################################
#12.4.2: Unite ##############################################
#The inverse of separate: combines multiple columns into a single column.
#We can use this to re-join the years we just split (result is in table5)
#unite() takes a data frame, the name of the new variable to create, and a set of columns to combine:
table5

table5 %>%
  unite(new, century, year)
#However, the default handling placed an underscore between values from different columns.  We can overwrite by using "":
table5 %>%
  unite(new, century, year, sep = "")


###############################################################
#12.4.3: Exercises ##############################################
#1. What do the extra and fill arguments do in separate()? Experiment with the various options for the following two toy datasets.

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))

#2. Both unite() and separate() have a remove argument. 
#What does it do? 
#Why would you set it to FALSE?

#3. Compare and contrast separate() and extract(). 
#Why are there three variations of separation (by position, by separator, and with groups), but only one unite?


###############################################################
#12.5: Missing Values ##############################################
#Values can be missing in two ways:
#Explicitly: i.e. flagged with an N/A
#Implicitly i.e. simply not present in the data

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66))

stocks

#Two missing values in this dat set:
#Q4 2015 return is NA
#Q1 2016 does not appear

#We can make implicit missing values explicit by representing the values differently.
#For example, putting the years into columns:
stocks %>%
  spread(year, return)

#If these aren't importnat, we can drop with na.rm = TRUE in gather():
stocks %>%
  spread(year, return) %>%
  gather(year, return, `2015`, `2016`, na.rm=TRUE)
  

#Another great tool is complete(), which takes a set of columns and finds all unique combinations:
stocks%>%
  complete(year, qtr)

#Lastly... Sometimes when a data source has been used for data entry, missing data indicates the previous value s/b carried forward:
treatment <- tribble(
  ~person, ~treatment, ~response,
  "Derrick Whitmore",1,7,
  NA,2,10,
  NA,3,9,
  "Katherine Burke",1,4
)

treatment

#We can fill these missing values with fill().  fill() takes a set of columns where we want missing value to be replaced 
#by the most recent non-missing values:
treatment %>%
  fill(person)


###############################################################
#12.5.1: Exercises ##############################################

#1. Compare and contrast the fill arguments to spread() and complete().

#2. What does the direction argument to fill() do?


###############################################################
#12.6: Case Study ##############################################
#The tidyr::who dataset contains TB cases broken down by year, country, age, gender, and diagnosis method
#The data comes from the 2014 World Health Organization Global Tuberculosis Report, 
#available at http://www.who.int/tb/country/data/download/en/.

who #A wealth of data, but very hard to work with.
#Redundant columns, missing data, odd variable codes...
#We'll need to string together multiple tidy functions into a pipeline to clean this up.

#Best place to start is usually to gather together columns which aren't variables:
  #country, iso2 and iso3 are three variable which redundantly specify country
  #year is clearly also variable
  #other columns are unclear, but these are likely to be values, not variables

<<<<<<< HEAD
#So, gather together the columns from new_sp_m014 to newre1_f65.
  #we don't know what these codes represent, so we give them the vale "key"
  #we do know cell values represent #cases, so we use the variable "cases"
  #there are many mssing values, so use na.rm:
who1 <- who%>%
  gather(new_sp_m014:newrel_f65, key= "key", value = "cases", na.rm = TRUE)

#check result:
who1

#Get a hint of the data structure of the values in the "key" column by counting them:
who1 %>%
  count(key)
=======
#So, we want to gather together all columns from new_sp_m014 through newrel_f65
#Since we don't know what these mean, we'll call them "key"
#We do know the cells represent count of cases, so we'll use the variable "cases"
#Since there are so many missing values, we'll use na.rm

who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key= "key", value= "cases", na.rm = TRUE)

who1
>>>>>>> e30908340a8d2b192f9d86b940a44723cc42a225

#We can get a hint of the structure of the values in the new key column by counting them:
who1 %>%
  count(key)

#The data dictionary tells us:
  #1.) the first three letters of each column denote whether the column contains new or old cases of TB
  #2.) next two letter describe the type of TB:
    #re1 stands for relapse
    #ep stands for extrapulmonary case of TB
    #sn stands for TB cases not disgnosed by pulmonary smear
    #sp stands for smear positive
  #3.) Sixth letter gives the sex of the patient
  #4.) Remaining number give the age group: "014" = 0-14, "15-24" = 15-25, etc...


#Column names are slightly inconsistent; one is newrel rather than new_rel.  We'll use str_replace()
#to replace newrel with new_rel. (More on strings in chapter 14).
who2 <- who1 %>%
  mutate(key=stringr::str_replace(key, "newrel", "new_rel"))

who2

#We can break the "key" column down into its components with two passes of separate():
#First, split the codes at each underscore:
who3 <- who2 %>%
  separate(key, c("new","type","sexage"), sep = "_")

who3

#Next, we can drop columns which are either constant or redundant.  For example, we can drop "new" and "iso2"
who4 <- who3 %>%
  select(-new, -iso2)

who4

#Last, separate sexage into sex and age by splitting after the first character:
who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep = 1)

who5 #Congrats, the who dataset is now tidy!

###############################################################
#12.7: Non-tidy Data ##############################################

#Two main reasons to use data structure other than tidy:
  #alternative representations may have substantial space advantage or better performance
  #specialized field may have evolved different conventions for storing their data

#If you'd like to learn more about non-tidy data, 
#I'd highly recommend this thoughtful blog post by Jeff Leek: http://simplystatistics.org/2016/02/17/non-tidy-data/


###############################################################
#13: Relational Data ##############################################
###############################################################
###############################################################
#13.1:Intro ##############################################

#To work with relational data, we need verbs which work with pairs of tables.  There are
#3 families of verbs designed to work with relational data:
    #Mutating Joins: add new variables to one data frame by matching observations in another
    #Filtering Joins: filter observations from one data frame based on whether or not they match an observation in the other table
    #Set Operations:treat observations as if they were set elements

library(tidyverse)
library(nycflights13)

###############################################################
#13.2:nycflights13 ##############################################
#This data set contains 4 tibbles which are related to the flights table we used in Chapter 5.

#1.) airlines lets us look up the full carrier name from the abbreviated code:
airlines

#2.) airports gives info about each airport, identified by the faa airport code:
airports

#3.) planes gives info about each plane, identified by its tailnum:
planes

#4.) gives the weather at each NYC airport for each hour:
weather

#For nycflights13:
  #flights connects to planes via a single variable, tailnum
  #flights connects to airlines through the carrier variables
  #flights connects to airports in two ways: via the origin and dest variables
  #flights connects to weather via origin and year month day and hour.

################
#13.2.1: Exercises
#Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination. 
#What variables would you need? What tables would you need to combine?
#A: dest and origin from flights tables, and lat and long from airports table.  Join to get lat & long for both orig and dest.

#I forgot to draw the relationship between weather and airports. What is the relationship and how should it appear in the diagram?
#A: origin in weather joins with faa in airports

#weather only contains information for the origin (NYC) airports. 
#If it contained weather records for all airports in the USA, what additional relation would it define with flights?
#A: dest year month day hour orig

#We know that some days of the year are b specialb , and fewer people than usual fly on them. 
#How might you represent that data as a data frame? What would be the primary keys of that table? 
#How would it connect to the existing tables?
#A: create a holiday table, and connect to flights via year month day

###############################################################
#13.3:Key s##############################################
#Variables used to connect tables are called keys.  A key uniquely identifies an observation.
#tailnum identifies each unique plane.  
#In other instances, a combination of variables may be needed. For weather, year month day hour and original are ALL required.

#Two types of keys:
  #primary key: uniquely identifies an observation in its own table: ex: planes$tailnum
  #foreign key: uniquely identifies an observation in another table.  For example, flights$tailnum is a foreign key.
    #It appears in the flights table, where it matches each flight to a unique plane

#A variable can be a primary key and a foreign key.  
  #For example, origin is part of the weather primary key, and is also a foreign key for the airport table

#Once you've identified the primary key, you should verify they uniquely identify each observation.  We can do this by count() 
#the primary key and look for entries where n > 1:
planes %>%
  count(tailnum) %>%
  filter(n>1)

weather %>%
  count(year,month,day,hour,origin) %>%
  filter(n>1)

#Sometimes a table lacks a primary key; no combination of variables is unique to a row.  
#For example, flights liack a primary key.  Niether date + flight, nor date + tailnum are unique: 
flights %>%
  count(year,month,day,flight) %>%
  filter(n>1)

flights %>%
  count(year,month,day,tailnum) %>%
  filter(n>1)

flights %>%
  count(year,month,day, flight, tailnum) %>%
  filter(n>1)
#In cases like this, it's often useful to add a primary key by using mutate() and row_number().
#This is known as a surrogate key.

#A primary key and the corresponding foreign key in another table form a relation.
#relations are typically one-to-many.
################
#13.3.1: Exercises
#1.) Add a surrogate key to flights.
flights %>% 
  arrange(year, month, day, sched_dep_time, carrier, flight) %>%
  mutate(flight_id = row_number()) %>%
  glimpse()

#2.)Identify the keys in the following datasets
  #Lahman::Batting,
  #babynames::babynames
  #nasaweather::atmos
  #fueleconomy::vehicles
  #ggplot2::diamonds
#(You might need to install some packages and read some documentation.)

#3.)Draw a diagram illustrating the connections between the Batting, Master, and Salaries tables in the Lahman package. 

#Draw another diagram that shows the relationship between Master, Managers, AwardsManagers.

#How would you characterise the relationship between the Batting, Pitching, and Fielding tables?


###############################################################
#13.4:Mutationg joins  ##############################################
#A mutating join allows us to combine variables from more than one table.
#Like mutate(), the join functions add variables to the right, so if you have a lot of variables already, the new ones won't print.
#Let's make a narrower data set:
flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2

#Let's add the full airline name to the flights2 data.  We can do this via left_join():
flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")

#In this case, we could have gotten to the same place by using mutate() and R's base subsetting:
flights2 %>%
  select(-origin, -dest) %>%
  mutate(name=airlines$name[match(carrier,airlines$aarrier)])


###############13.4.1 Understanding Joins #######################
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_x,
  1, "y1",
  2, "y2",
  4, "y3"
)
###############13.4.2 Inner Join #######################
#The simplest type of join is the inner join.  This matches observations wherever their keys are equal.
#The output of an inner join is a new data frame which contsains the key, x values, and y values.
#We use "by" to tell dplyr which variable is the key:
x %>%
  inner_join(y, by = "key")
#Unmatched row ARE NOT INCLUDED.

###############13.4.3 Outer Joins #######################
#An outer join keeps observartions which appear in at least one of the tables.
#Three types of outer joins:
  #left join: keeps all observations in x
x %>%
  left_join(y, by = "key")

  #right join:keeps all observayions in y
x %>%
  right_join(y, by = "key")

  #full join: keeps all observations in x and y
x %>%
  full_join(y, by = "key")
#left join is the most commonly used.  

###############13.4.4 Duplicate keys #######################
#What happens when keys are not unique?  There are 2 possibilities:
  #1.) One table has duplicate keys. This may be useful if adding information in a one-to-many relationship.
x <-  tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x,y,by="key")

  #2.) Both tables have duplicate keys. This is often an error.
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")
#> # A tibble: 6 C 3
#>     key val_x val_y
#>   <dbl> <chr> <chr>
#> 1     1    x1    y1
#> 2     2    x2    y2
#> 3     2    x2    y3
#> 4     2    x3    y2
#> 5     2    x3    y3
#> 6     3    x4    y4

###############13.4.5 Defining the key columns #######################
#Above, the pairs of tables were joined on a single variable with the same name in both tables.  This was encoded by 'by="key" '
#There are other options:

  #1.) A natural join uses all variable which appear in both tables, and is encoded by 'by=NULL'.
  #flights and weather will match on their common variables: year, month, day, hour, and orig:
flights2 %>%
  left_join(weather)

  #2.) A character vector, 'by="x" '.  Like a natural join, but uses only some of the common variables, not all of them.
  #This may be due to the fact that a variable name in one table may be present in the second table, but mean something different.
  #flights and planes have year variables, but they mean different things, therefore, join only on tailnum:
flights2 %>%
  left_join(planes, by="tailnum")
  #both year's are output, but with a suffix to denote them.

  #3.) A named character vector:' by = c("a" = "b")'.  This matches variable a in table x to variable b in table y.  The 
  #variables from x are used in the output:
flights2 %>%
  left_join(airports, c("dest"="faa"))

flights2 %>%
  left_join(airports, c("origin"="faa"))


###############13.4.6 Exercises #######################
#1.)Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Hereb s an easy way to draw a map of the United States:
  
  airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("county") +
  geom_point() +
  coord_quickmap()

#(Donb t worry if you donb t understand what semi_join() does b  youb ll learn about it next.)
#You might want to use the size or colour of the points to display the average delay for each airport.

#2.)Add the location of the origin and destination (i.e. the lat and lon) to flights.
#3.)Is there a relationship between the age of a plane and its delays?
#4.)What weather conditions make it more likely to see a delay?
#5.)What happened on June 13 2013? Display the spatial pattern of delays, and then use Google to cross-reference with the weather.

###############13.4.7 Other implementations #######################


###############################################################
#13.5:Filtering Joins  ##############################################
#These match observations in the same way as mutating joins, but affect the observations, not the variables.
#There are two types of filtering joins:
  #1.) semi_join(x,y) keeps all observations in x that have a match in y
  #2.) anti-join(x,y) drops all observations in x that have a match in y
#These are useful for matching filtered summary tables back to the original rows.  
#For example, let's say you've found the 10 most popular destinations:
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

#Now, if you want to find each flight which went to one of those destinations, construct a filter:
flights %>%
  filter(dest %in% top_dest$dest)

#Instead, use semi-join, which connects the two tables like a mutating join, but instead of adding new columns, 
#keeps only the rows in x that have a match in y:
flights %>%
  semi_join(top_dest)

#The inverse of a semi-join is an anti-join.  This keeps only the rows which DO NOT have a match.
#Very useful in diagnosing join mismatches.  For example, many flights don't have a match in planes!
flights %>%
  anti_join(planes, by="tailnum") %>%
  count(tailnum, sort=TRUE)

#########Exercises#########################################
#What does it mean for a flight to have a missing tailnum? 
#1.)What do the tail numbers that donb t have a matching record in planes have in common? 
#(Hint: one variable explains ~90% of the problems.)

#2.)Filter flights to only show flights with planes that have flown at least 100 flights.

#3.)Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models.

#4.)Find the 48 hours (over the course of the whole year) that have the worst delays. 
#Cross-reference it with the weather data. Can you see any patterns?

#5.)What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? 
#What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?

#6.) You might expect that thereb s an implicit relationship between plane and airline, because each plane is 
#flown by a single airline. Confirm or reject this hypothesis using the tools youb ve learned above.

###############################################################
#13.6:Join problems  ##############################################
#A few things you should do with your data to make your joins go smoothly:
#1.) Start by identifying the primary key, or the variables which can be combined to for the primary key.  Do this
#based on an understanding of the data, not by searching empirically - later version of your data might not work the same.

#2.) Check that none of the variables in the primary key column are missing.  If a value is missing, we can't identify an abs.

#3.) Check that foreign keys match primary keys in another table.  The best way to do this is with an anti_join().  It's
#common for key not to match due to data entry errors.
#If we have missing keys, we need to consider how to handle observations without a match.

###############################################################
#13.7:Set operations  ##############################################
#The final type of two-table verb are set operators.
#These operations work with a complete row, comparing the values of every variable.
#These expect the x and y inputs to have the same variables
  #intersect(x,y): return only the observations in both x and y
  #union(x,y): return unique observation in x and y
  #setdiff(x,y): return only the observations in x, but not in y

#Examples:
#Date Set:
df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2)

union(df1, df2)

setdiff(df1, df2)

setdiff(df2, df1)


###############################################################
#14: Strings  ##############################################
###############################################################
#stringr isn't part of the core tidyverse, so we need to load it:
library(stringr)
library(tidyverse)

###############################################################
#14.2: String basics  #########################################
#We can create strings with single or double quotes; there is no difference in behavior.  Book recommends using double, "
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
string2
writeLines(string2)

#If you forget to close a quote, you'll see +, the continuation character:
#"This is a string without a closing quote

#To include a literal single or double quote in a string, you can use \ to "escape" it:
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"
#If you want to include a literal backslash, you need to double up: "\\"

#The printed representation of a string is not the same as the string itself, because it shows the escapes.
#To see the raw content of a string, use writeLines():
x <- c("\"", "\\")
x
writeLines(x)
writeLines(string2)

#There are a few more extra characters, such as "\n" new line, and "\t" tab.
#You'll sometimes see strings such as "\u00b5", which are ways of writing non-English characters which work on all platforms.
x <- "\u00b5"
x
writeLines(x)

#Multiple strings are often stored in a character vector, which we create with c():
c("one","two","three")

#14.2.1: String Length  #########################################
The base R functions for strings can be inconsistent and therefore hard to remember.  Better to use stringr, which is more intuitive.
For example, str_length tells us the number of characters in a string:
str_length(c("a", "R for Data Science", NA))  

#The "str_" prefix is great in R Studio, since it triggers automcomplete, which lets us see all stringr functions


#14.2.2: Combining Strings #########################################
#To combine 2 or more strings, use str_c():
str_c("x","y")

#Use the sep argument to control how they are separated:
str_c("x","y", sep = ", ")

#Missing values are contagious.  If you want to print them as "NA", use str_replace_na():
x <- c("abc", NA)
str_c("|-", x, "|-")
str_c("|-", str_replace_na(x), "|-")

#str_ is vectorized, and recycles shorter vetors to match the longest vector:
str_c("prefix-", c("a","b","c"), "-suffix")

#Objects of length 0 are silently dropped.  This is useful in conjunction with if
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, ", ", name,
  if(birthday) " - and Happy Birthday",
  "."  
)

#To collapse a vector of strings into a single string, use collapse:
str_c(c("x","y","z"),collapse = ", ")


#14.2.3: Subsetting Strings #########################################
#We can extract parts of a string using str_sub().  
#As well as the string, str_sub() takes start and end argument which indicate the inclusive portion of the string:
?str_sub
x <- c("Apple", "Banana", "Pear")
str_sub(x,1,3)

#negative numbers count backward from the end of the string:
str_sub(x,-3,-1)

#Note that sub_str() will not fail if the string is too short; it will return what it can:
str_sub("a",1,5)

#We can use the assignment form of str_sub() to modify strings:
#Let's change first letters t0 lower case
str_sub(x, 1, 1) <- str_to_lower(str_sub(x,1,1))
x


#14.2.4: Locales #########################################
x <- c("apple", "eggplant", "banana")
str_sort(x)


#14.2.5: Exercises #########################################
#1.)In code that doesn't use stringr, you'll often see paste() and paste0(). What'???'s the difference between the two functions? 
#What stringr function are they equivalent to? 
#How do the functions differ in their handling of NA?

#2.)In your own words, describe the difference between the sep and collapse arguments to str_c().

#3.)Use str_length() and str_sub() to extract the middle character from a string. 
#What will you do if the string has an even number of characters?

#4.)What does str_wrap() do? When might you want to use it?

#5.)What does str_trim() do? Whats the opposite of str_trim()?

#6.)Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c. 
#Think carefully about what it should do if given a vector of length 0, 1, or 2.

###############################################################
#14.3: Matching patterns w/ regular expressions  ################
#"Regexps" are a terse language which allows us to describe patterns in strings.
#To learn regular exressions, we'll use str_view() and str_view_all()
#These take a character vector and a regular expression, and show you how they match

#14.3.1: Basic Matches  ################
#Simplest pattern  - match exact strings:
x <- c("apple", "banana", "pear")
str_view(x,"an") #highlights "an" in banana (in the Viewer pane).

#Slightly more cmplex is ., which matches any character (except a new line) - aka a wild card:
str_view(x, ".a") #any character followed by "a"

#Since "." matches any character, how would we match the character "."?  Use an "escape"...
#To create the regular expression, we need \\
dot <- "\\."
#But the expression itself only contains one:
writeLines(dot)
#And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

#Since \ is used as an escape character in regular expressions, how do we match a literal \?
#We need to escape it, creating a regular expression \\.  To create this, we need to use a string, which also needs to escape \.
#So, we need to write "\\\\"
x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")

#14.3.1.1: Exercises  ################
#1.) Explain why each of these strings don???t match a \: "\", "\\", "\\\".

#2.) How would you match the sequence "'\?

#3.) What patterns will the regular expression \..\..\.. match? How would you represent it as a string?


#14.3.2: Anchors  ################
#By default, regular exxpressions will match any part of a string.
#It can be useful to anchor them so that they match from the start or the end of a string.
  # use ^ to mtch the start of the string
  # use $ to match the end of the string 

x <- c("apple", "banana", "pear")
str_view(x, "^a")

str_view(x, "$a")
#To help remember which is which: You begin with Power ^, you end with money $".

#To force a regular expression to only match a complete string, anchor it with both:
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")

str_view(x, "^apple$")

#We can match the boundary between words with \b.  For example, use \bsum\b to avoid matching summarize, summary, rowsum,...


#14.3.3: Character classes and alternatives  ################
#There are special patterns which match more than one character.  We saw the wildcard, ., earlier
#Four other useful tools:
  #\d matches any digit
  #\s matches any whitespace
  #[abc] matches any a,b, or c
  #[^abc] matches anything except a,b, or c

#We can use alternation to pick between one or more alternative patterns.  For example, abc|d..f will match either "abc" or "deaf".
#If precedence gets confusing, use parentheses to make it clearer:

str_view(c("grey","gray"), "gr(e|a)y")


#14.3.4: Repetition  ################
#Next step up in power is controlling how many times a pattern matches:
  #?: 0 or 1
  #+: 1 or more
  #*: 0 or more

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")

str_view(x, "CC+")

str_view(x, 'C[LX]+')

#We can also specify the number of matches precisely:
  #{n}  : exactly n
  #{n,} : n or more
  #{,m} : at most m
  #{n,m}: between n and m

str_view(x, "C{2}")

str_view(x, "C{2,}")

str_view(x, "C{2,3}")
#By default, these strings are considered "greedy"; they will match the longest string possible.
#Make them lazy (shortest strring possible) by putting a ? after them:
str_view(x, "C{2,3}?")

str_view(x, 'C[LX]+?')

#14.3.5: Grouping and Backreferences  ################
#As described above, parentheses can be used to disambiguate complex expressions.
#Parentheses can also be used to to define "groups" which we can refer to with backreferences such as: \1, \2, etc...
str_view(fruit, "(..)\\1", match=TRUE) #.. is a double wildcard; so this finds any 2 letter groups which repeat at least once


###############################################################
#14.4: Tools  ##############################################
#Now we learn how to apply the regular expression tools to real problems, such as:
  #Determine which strings match a pattern
  #Find the position of matches
  #Extract the content of matches
  #Replace matches with new values
  #Split a string based on a match

#CAUTION!: Do not try to solve every problem with a single regular expression.  
#It's often preferable to break the problem into more manageable chunks.


#14.4.1: Detect Matches  ##############################################
#To determine whether a character vector matches a pattern, use str_detect().  THis returns
# a logical vestor the same length as the input:
x <- c("apple", "banana", "pear")
str_detect(x, "e")

#Remember, when we use a logical vector in a numeric contest, FALSE = 0, TRUE=1
#This makes sum() and mean() useful if we want to ask questions about matches across a large vector

#How many words start with "t"?:
sum(str_detect(words, "^t")) 

#What proportion of words end with a vowel?:
mean(str_detect(words, "[aeiou]$")) 

#As mentioned above, for very complex logical conditions, it's better to combine multiple str_detect() calls.
#For example, here are two ways to find all words which don't contain any vowels:

#Find all words containing at least one vowel, and negate:
no_vowels_1 <- !str_detect(words, "[aeiou]")
#Find all words which contain only consonants
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")

#do the results agree?
identical(no_vowels_1, no_vowels_2)

#We get the same results, but option one is easier to read

#Common use of str_detect is to select elements which match a pattern.
#We can do this with a logical sub-setting, or by using the str_subset() wrapper:
words[str_detect(words, "x$")]
str_subset(words, "x$")

#More often, strings will be one column of a data frame, and we should use a filter instead:
df <- tibble(
  word = words,
  i = seq_along(word)
)
df %>%
  filter(str_detect(words, "x$"))

#A variation on str_detect() is str_count():  Rather than a simple yes or no, it returns the # of matches:
x <- c("apple", "banana", "pear")

#how many times does "a" appear in each?
str_count(x, "a")

#On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

#We can also use str_count() with mutate():
df %>%
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

#NOTE: Matches neer overlap.  For example, in "abababa", how many times will the pattern "aba" match?
#Answer: regular expressions says 2, not three:
str_count("abababa", "aba")
str_view_all("abababa", "aba")


#14.4.2: Exercises  ##############################################



#14.4.3: Extract Matches  ##############################################
#To extract the exact text of a match, use str_extract().
#Let's use a more complicated example, which was orignally used to test VOIP:
#These are the Harvard Sentences, provided in stringr::sentences (there are 720 sentences):

length(sentences)
head(sentences)

#If we want to find all sentences which contain a color, we first create a vector of color names:
colors <- c(
  "red", "orange", "yellow", "green", "blue", "purple"
)
#and then turn it into a regular expression:
color_match <-str_c(colors, collapse = "|")

color_match

#Next, select the sentences which contain a color, and then extract the color to figure out which it is:
has_color <- str_subset(sentences, color_match)

has_color

matches <- str_extract(has_color, color_match)

head(matches)
#Note: str_extract() only extracts the first match.  We can see this if we select all sentences which have >1 match:
more <- sentences[str_count(sentences, color_match) >1]
str_view_all(more, color_match)

str_extract(more, color_match)

#AWorking with a single match alows us to extract much simpler data structures.
#To get all matches, use str_extract_all().  This returns a list:
str_extract_all(more, color_match)

#Use simplify=TRUE,, and str_extract_all will return a matrix withshort matches expanded to the same length as the longest:
str_extract_all(more, color_match, simplify = TRUE)



#14.4.4: Grouped Matches  ##############################################
#We can use parentheses to extract parts of a complex match.
#Suppose we want to extract nouns from sentences.  Our heuristic is anything which follows "a" or "the" is a noun.
#Since defining a word isn't easy, we create an approximation:  a sequence of at least one character which isn't a space.
noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)

has_noun %>%
  str_extract(noun)
#str_extract gives us the complete match; str_match() yields each individual component.
#It returns a matrix, with ne column for the complete match followed by one column for each group:
has_noun %>%
  str_match(noun)

#If your data is in a tibble, it's often easier to use tidyr::extract().
#Works like str_match(), but requires naming the matches, which are then places into columns:

tibble(sentence = sentences) %>%
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = FALSE
  )

#If we want all matches for each string, use str_extract_all()


#14.4.5: Replacing Matches  ##############################################
#str_replace() and str_replace_all() all you to replace matches with new strings.
#Replace a pattern with a fixed string:
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

#With str_replace_all(), we can perform multiple replacements by supplying named vector:
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1"="one", "2"="two", "3"="three"))

#Insted of replacing with a fixed string, you can use backreferences to insert components of the match.
#here, we flip the order of the second and third words:
sentences %>%
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%
  head(5)


#14.4.6: Splitting  ##############################################
#Use str_split to split a string into pieces.  For example, split sentences into words:
sentences%>%
  head(5)%>%
  str_split(" ")

#Because each component might contain a different # of pieces, this returns a list.
#If working with a length-1 vector, it's easier to extract the first elelment of the list:
"a|b|c|d" %>%
  str_split("\\|") %>%
  .[[1]]

#Or, we can use simplify = TRUE to return a matrix:
sentences %>%
  head(5) %>%
  str_split(" ", simplify = TRUE)

#You can also request a max number of pieces:
fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n=2, simplify = TRUE)

#Instead of splitting strings by patterns, we can split by character, line, sentence, or word boundary:
x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))

str_split(x, " ")[[1]]

str_split(x, boundary("word"))[[1]]


#14.4.7: Find Matches  ##############################################
#str_locate() and str_locate_all() give us the starting and ending position of each match.
#You can use sr_locate to find the matching pattern, and str_sub to extract or modify them.



###############################################################
#14.5: Other types of Pattern  ##############################################
#When we use a pattern that's astring, it's automatically wrapped into a call to regex():

#The regular call:
str_view(fruit, "nana")
#Is shorthand for 
str_view(fruit, regex("nana"))

#We can use other arguments of regex() to control details of the match:

  #ignore_case = TRUE allows characters to match either their upper or lower case form
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))


  #multiline = TRUE allows ^ and $ to match the start and end of each line, rather than the 
  #start and end of each string.
x <-  "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]  
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]  

  #comments = TRUE allows you to use comments and white space to make complex regular expressions more understandable.
  #Spaces are ignored, as is everything after #.  To match a literal space, you need to escape it: "\\ ".
phone <- regex("
    \\(?       #Optional opening parens
    (\\d{3})    #area code
    [)- ]?     #optional closing parens, dash, or space
    (\\d{3})   #another 3 numbers
    [ -]?      #optional space or dash
    (\\d{4})   #4 more numbers   
    ", comments = TRUE)

str_match("514-791-8141", phone)
  
  #dotall = TRUE allows . to match everything, including \n.
#There are three other functions you can use nstead of regex():
  
  #fixed() matches exactly the specified sequence of bytes. It ignores all special regular expressions and 
#operates at a very low level, so you can avoid complex escaping.
fixed = str_detect(sentences, fixed("the"))
  
  #coll() compares strings using standard collation rules.  Useful for case-intensive matching.  coll() takes a local parameter
#that compares which rules are used for comparing charcters.
i <- c("I", "??", "i", "??")
i
str_subset(i, coll("i", ignore_case = TRUE))

str_subset(
  i,
  coll("i", ignore_case = TRUE, locale = "tr")
)

  #boundary() can be used with functions other than str_split()
x <- "This is a sentence"
str_view_all(x, boundary("word"))

str_extract_all(x, boundary("word"))


###############################################################
#14.6: Other uses of Regular Expression  ##############################################
#Two useful functiions in base R which also use regular expressions:

  #apropos() searches all objects available from teh global environment - useful if you can't remember the name of a function
apropos("replace")

  #dir() lists all the files in a directory.  The pattern argument takes a regular expression and only returns filenames that match the pattern.
head(dir(pattern = "\\.Rmd$"))

###############################################################
#14.7: stringi  ##############################################
#stringr is built on top of stringi. stringr is a more limited set of functions (42 vs. 234 for stringi)
#if you are struggling with something in stringr, try stringi.
#The main difference is the prefix: str_ versus stri_.


###############################################################
#15: Factors##############################################
###############################################################
#In R, factors are used to work with categorical variables - variables which have a fixed and known set of outcomes.

#Prerequisites: forcats package deals with categorical variables, but is not part of the base tidyverse.
library(tidyverse)
library(forcats)
library(dplyr)
library(ggplot2)

###############################################################
#15.2: Creating Factors  ##############################################
#Say you have a variable which records month:
x1 <- c("Dec", "Apr", "Jan", "Mar")
#Using a string to record these has 2 problems:
  #There are only 12 months, and nothing is saving us from typos:
x2 <- c("Dec", "Apr", "Jam", "Mar" )
  #It doesn't sort in a useful way:
sort(x1)

#Fix both problems with a factor.  Start by creating a list of valid levels:
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"
)
#Now, we can create a factor:
y1 <- factor(x1, levels=month_levels)
y1
sort(y1)
#Any values not in the set are silently converted to NA:
y2 <- factor(x2, levels = month_levels)
y2

#If you omit levels, they'll be taken from teh data in alphabetical order:
factor(x1)

#If you want the order of the levels to match the order of the first appearance in the data,
#you can create but setting the levels to unique(x), or after the fact with fct_inorder():
f1 <- factor(x1, levels=unique(x1))
f1

f2 <- x1 %>% factor() %>% fct_inorder()
f2


###############################################################
#15.3: General Social Survey  ##############################################
#For the balance of the chapter, we'll focus on forcats::gss_cat, a sample fo data from the General Social Survey (http://gss.norc.org)
gss_cat
?gss_cat

#When factors are stored in a tibble, it's not easy to see levels.  One way to see them is with count():
gss_cat %>%
  count(race)

#Or with a bar chart:
ggplot(gss_cat, aes(race))+
  geom_bar()

#By default, ggplot2 will drop levels which don't have any value.
#To force them in:
ggplot(gss_cat, aes(race))+
  geom_bar() +
  scale_x_discrete(drop = FALSE)
#These represent valid levels which simply didn't occur in our set.

###############################################################
#15.4: Modifying Factor Order  ##############################################
#It's often useful to change the order of the factor levels in a visualization.
#For example, we want to explore the #hours spent watching TV per religion.
relig <- gss_cat %>%
  group_by(relig) %>%
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
  )

ggplot(relig, aes(tvhours, relig)) + geom_point()

#We can improve the readability of the plot by reordering, using fct_reorder().  This takes 3 arguments:
  #f, the factor whose level you want to modify
  #x, a numeric vector that you want to use to reorder the levels
  #Optionally, fun, a function which is used if there are multiple values of x for each value of f.  Default value is median:

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

#As we make more complicated xforms, move them out of aes() and into a separate mutate() step:
relig %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig))+
  geom_point()

#Create a similar plot to see how averge age varies across reported income level:
rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarize(
    age=mean(age, na.rm=TRUE),
    tvhours=mean(tvhours, na.rm=TRUE),
    n=n()
  )


ggplot(
  rincome,
  aes(age, fct_reorder(rincome, age))
) + geom_point()
#This re-ordering makes little sense, because income level has an intrinsic order

#But, it does make sense to pull N/A to the front of the order, along with other special levels
#For this, we use fct_relevel() - which allows us to re-order bits and pieces
?fct_relevel

ggplot(
  rincome,
  aes(age, fct_relevel(rincome, "Not applicable"))
) +
  geom_point()

#When coloring lines on a plot, a second kind of re-ordering is useful.  fct_reorder2() reorders the factors by the y
#values associated with the highest x values.  That way, the colors line up with the legend:
by_age <- gss_cat %>%
  filter(!is.na(age)) %>%     #remove obs where age = NA
  group_by(age, marital) %>%  #order by age, marital status
  count() %>%                 #count number in each group
  mutate(prop = n/sum(n))#adds a new column of information #######SUM isn't working..???

ggplot(by_age, aes(age, prop, color = marital )) +
  geom_line(na.rm = TRUE)

ggplot(
  by_age,
  aes(age, prop, color = fct_reorder2(marital, age, prop))
)  +
  geom_line() +
  labs(color = "marital")

#For bar plots, use fct_infreq() to order levels in increasing frequency
#You might want to combine with fct_rev()
?fct_rev
gss_cat%>%
  mutate(marital=marital %>% fct_infreq() %>% fct_rev())%>%
  ggplot(aes(marital)) +
  geom_bar()


###############################################################
#15.5: Modifying Factor Levels  ##############################################
#Changing the values of levels is more powerful than changing the order.
#This alows us to clarify labels for publication and collapse levels for high level displays.
#fct_recode() is the most general and powerful too.  For example:

gss_cat %>% count(partyid) #returns a 10x2 tibble

#Let's tweak the levels to be longer:
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
      "Republican, strong"    = "Strong republican",
      "Republican, weak"      = "Not str republican",
      "Independent, near rep" = "Ind, near rep",
      "Independent, near dem" = "Ind, near dem",
      "Democrat, weak"      = "Not str democrat",
      "Democrat, strong"    = "Strong democrat"
)) %>%
  count(partyid)
#fct_recode() will leave levels which aren't explicitly mentioned exactly as they were.

#We can combine groups by assigning multiple old levels to a new level:
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",  
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
                              )) %>%
  count(partyid)

#If we want to collapse a large number of fields, fct_collapse() is a useful variation.
#With fct_collapse, we feed a vector of lod levels into a new variable:
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
                                )) %>%
  count(partyid)

#We may also want to lump together all small groups to simplify a plot or table.  Use fct_lump() to do this:
gss_cat %>%
  mutate(relig=fct_lump(relig)) %>%
  count(relig)
#If this lumps too many together, use the n parameter:
gss_cat %>%
  mutate(relig=fct_lump(relig, n=3)) %>%
  count(relig, sort = TRUE)


###############################################################
#16: Dates & Times with Lubridate##############################
###############################################################
#This chapter focuses on the lubridate package, which makes it easier to work with dates and times in R
#lubridate is not part of the core tidyverse
library(tidyverse)
library(lubridate)
library(nycflights13)

###############################################################
#16.2: Creating Date/Times  ##############################################
#There are three types of date/time data which refer to an instance in time:
  #A date.  Tibbles print this as <date>.
  #A time within a day.  Tibbles print this as <time>.
  #A date-time is a date plus a time.  Tibbles print this as <dttm>.  Elsewhere in R, these are called POSIXct.
#This chapter focuses on date and date-time.  
#R doesn't have a native class for storing times.  If you need one, use the hms package.

#Always use the simplest possible data type for your needs.  Date-times are substantially more complicated than Date.

#To get current date or date-time, use today() or now():
today() #Date

now() #date-time

#Otherwise, there are three ways to create a date/time:
  #From a string
  #From individual date-time components
  #From an existing date/time object

#16.2.1: From Strings  ##############################################
#Use helpers provided by lubridate - they automatically work out the format once you specify the order of the components.
#Just identify the order in which year, month and day appear, then arrange y, m and d in the same order:
ymd("2017-01-31")
mdy("01-31-2017")
dmy("31-01-2017")

#The function also takes unquoted numbers, as you might need when filtering date/time data:
ymd(20170131)

#To create date-time, add an underscore and one or more of h, m , and s:
ymd_hms("20170131 20:11:59")
mdy_hm("01/31/2017 08:01")


#16.2.2: From Individual Components  ##############################################
#Sometime date-time components will be spread across multile columns, as in thre flights data
flights %>%
  select(year, month, day, hour, minute)

#To create a date-time from this, use make_date() for dates, or make_datetime() for date-times
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(
    departure=make_datetime(year, month, day, hour, minute)
  )

#Here, we do the same thing for each of the 4 tie columns in "flights".  
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time),
  )

flights_dt

#Now, we can visualize the distribution of departure times across the year:
flights_dt %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 86400) #86400 seconds = 1 day

#Or, within a single day:
flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) #600 seconds = 10 minutes


#16.2.3: From Other Types  ##############################################
#To switch between a date-time and a date, use as_datetime() or as_date():
as_datetime(today())

as_date(now())


#16.2.4: Exercises  ##############################################



###############################################################
#16.3: Date-time components  ##############################################
#This section focuses on the accessor functions year(), month(), mday() (day of the month), 
#yday() (day of the year), wday() (day of the week), hour(), minute(), and second().

#16.3.1: Getting components  ##############################################
datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)
month(datetime)
mday(datetime)
yday(datetime)
wday(datetime)

#For month & day, we can set label = TRUE to return the abbreviated day of the month or day of the week.
#Set abbr = FALSE to return the full name:
month(datetime, label = TRUE)
month(datetime, label = TRUE, abbr = FALSE)

#Use wday() to see more flights depart on weekdays than weekends:
flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>%
  ggplot(aes(x = wday)) +
  geom_bar()

#we can examine the departure delay by minute within the hour.
flights_dt %>%
  mutate(minute = minute(dep_time)) %>%
  group_by(minute) %>%
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>%
  ggplot(aes(minute, avg_delay)) +
  geom_line()
#Flights leaving between 20-30 and 50-60 minutes have lower delays
#Pattern doesn't hold for scheduled departure time:
flights_dt %>%
  mutate(minute = minute(sched_dep_time)) %>%
  group_by(minute) %>%
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>%
  ggplot(aes(minute, avg_delay)) +
  geom_line()


#16.3.2: Rounding components  ##############################################
#We can round the date to a nearby unit of time by using
  #floor_date()
  #round_date()
  #ceiling_date()
#Each ceiling_date() function takes a vector of dates to adjust and the name of the unit to round down (floor), round up (ceiling),
# or round to:
flights_dt %>%
  count(week = floor_date(dep_time, "week")) %>%
  ggplot(aes(week, n)) +
  geom_line()
#This gives us the umber of flights per week

#16.3.3: Setting components  ##############################################
#We can set the components of date/time:
(datetime <- ymd_hms("2016-07-08 12:34:56"))

year(datetime) <- 2020
datetime #change year to 2020

month(datetime) <- 01
datetime

#Or, create a new date-time with update(), which allows us to set multiple values at once:
update(datetime, year = 2020, month=2, mday=2, hour=2)

#If values are too big, they will roll over:
ymd("2015-02-01") %>%
  update(mday=30)

#You can use update() to show the distribution of flights across the course of the day for every day of the year:
flights_dt %>%
  mutate(dep_hour = update(dep_time, yday = 1)) %>%
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 300)

#16.3.4: Exercises  ##############################################


###############################################################
#16.4: Time Spans  ##############################################
#Here, we learn how arithmetic with dates works, ad learn about 3 classes of time spans:
  #Durations represent an exact numer of soaps
  #Periods represent human units like weeks and months
  #Intervals represent starting and ending point

#16.4.1: Durations  ##############################################
#When we subtract to dates in R, we get a difftime object:

#How old is Hadley?
h_age <- today() - ymd(19791014)
h_age

#Since difftime records in a variety of measures (seconds, minutes, hours, days, or weeks)
#lubridate provides duration as an alternative to difftime:
as.duration(h_age)

#Durations come with a number of convenient constructs:
dseconds(15)
dminutes(10)
dhours(c(12, 24)) 
ddays(0:5)
dweeks(3)
dyears(1)
#Durations always record in seconds, and convert to larger units.

#We can add, multiply, subtract and divide units:
2 * dyears(1)
dyears(1) + dweeks(12) + dhours(168)
tomorrow <- today() + ddays(1)
tomorrow
last_year <- today() - dyears(1)
last_year

#16.4.2: Periods  ##############################################
#lubridate provides periods to work with "human" times, like days and months - instead of seconds:
seconds(15)
minutes(10)
hours(c(12,24))
days(7)
months(1:6)
weeks(3)
years(1)

#We can add and multiply periods:
10 * (months(6) + days(1))

days(50) + hours(25) + minutes(2)

#...and add them to dates:
#Leap year
ymd("2016-01-01") + dyears(1) #duration doesn't properly handle leap year
ymd("2016-01-01") + years(1) #periods version handles the leap year and daylight savings time

#Some of our flights (over 10,000) appear to have arrived before they departed - because they arrived on the next day:
flights_dt %>%
  filter(arr_time < dep_time)

#We can fix this by adding days(1) to the arrival time of each flight:
flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),
    sched_arr_time = sched_arr_time + days(overnight * 1)
  )

flights_dt %>% 
  filter(overnight, arr_time < dep_time) 

#16.4.3: Intervals  ##############################################
#An interval is a duration with a starting point.
next_year <- today() + years(1)
next_year

#To find out how many periods fall into an interval, use integer division:
(today() %--% next_year) / ddays(1)

#16.4.4: Summary  ##############################################
#Rule of thumb: pick the simplest data structure possible
#Use duration if you only care about physical time
#use a period if you need to add a human time
#If you need to figure out how long an interval is in human units, use an interval


#16.4.5: Exercises  ##############################################



###############################################################
#16.5: Time Zones  ##############################################
#R uses the international standard IANA time zones
#These have a fairy consistent form of <continent>/<city>
# http://www.iana.org/time-zones

#You can find your current time zone via:
Sys.timezone()
#The complete list of time zones:
OlsonNames()

#The time xone is an attribute of date-time which only controls printing.  These represent the same instant in time:
(x1 <- ymd_hms("2015-06-01 12:00:00", tz="America/New_York"))

(x2 <- ymd_hms("2015-06-01 18:00:00", tz="Europe/Copenhagen"))

x1 - x2

x3 <- c(x1, x2)


#Unless specified otherwise, lubridate always uses UTC (Coordinated Universal Time)

#We can change the time zone 2 ways:
  #Keep the instant the same, and change the display.  Use this when the instant is correct, but you want a more natural display:
x3a <- with_tz(x3, tzone = "Australia/Lord_Howe")
x3a


  #Change the underlying instant in time (when you have an instant which has been labeled with the wrong time zone)
x3b <- force_tz(x3, tzone = "Australia/Lord_Howe")
x3b

x3b-x3

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
purrr::set_names()
  

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


#20.7: Augmented Vectors ######################################
#Atomic vectors and lists are building blocks for important vector types like factors and dates.  
  #These are referred to as augmented vectors, because they are vectors with additional attributes such as class.
  #Because they have a class, they behave differently than atomic vectors.
  
  #Four important augmented vectors: Factors, Date-times and times, and Tibbles
  
#20.7.1: Factors ######################################


#20.7.2: Dates and Date-times ######################################


#20.7.3: Tibbles ######################################


#20.7.4: Exercises ######################################


###############################################################
#21: Iterations with purrr ####################################
###############################################################





















