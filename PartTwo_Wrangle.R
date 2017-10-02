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
      
#2.What happens if you try and set decimal_mark and grouping_mark to the same character? What happens to the default value of grouping_mark when you set decimal_mark to “,”? What happens to the default value of decimal_mark when you set the grouping_mark to “.”?
      
#3.I didn’t discuss the date_format and time_format options to locale(). What do they do? Construct an example that shows when they might be useful.
      
#4.If you live outside the US, create a new locale object that encapsulates the settings for the types of file you read most commonly.
      
#5.What’s the difference between read_csv() and read_csv2()?
      
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

#If you want to export a csv file to Excel, use write_excel_csv() — this writes a special character 
#(a “byte order mark”) 
#at the start of the file which tells Excel that you’re using the UTF-8 encoding.

#The most important arguments are x (the data frame to save), and path (the location to save it). 
#You can also specify how missing values are written with na, and if you want to append to an existing file.

write_csv(challenge, "challenge.csv")

#however, we do lose data type when we write to .csv.  We'd need to recreate types each time we read in.
#Two alternatives:
  #1.write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS(). 
  #These store data in R’s custom binary format called RDS:
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
  #year is clearly a variable
  #other columns are unclear, but these are likely to be values, not variables

#So, we want to gather together all columns from new_sp_m014 through newrel_f65
#Since we don't know what these mean, we'll call them "key"
#We do know the cells represent count of cases, so we'll use the variable "cases"
#Since there are so many missing values, we'll use na.rm

who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key= "key", value= "cases", na.rm = TRUE)

who1

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

#If you’d like to learn more about non-tidy data, 
#I’d highly recommend this thoughtful blog post by Jeff Leek: http://simplystatistics.org/2016/02/17/non-tidy-data/


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

#We know that some days of the year are “special”, and fewer people than usual fly on them. 
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
  mutate(name=airlines$name[match(carrier,airlines$carrier)])


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
#> # A tibble: 6 × 3
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
#1.)Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:
  
  airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("county") +
  geom_point() +
  coord_quickmap()

#(Don’t worry if you don’t understand what semi_join() does — you’ll learn about it next.)
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
#1.)What do the tail numbers that don’t have a matching record in planes have in common? 
#(Hint: one variable explains ~90% of the problems.)

#2.)Filter flights to only show flights with planes that have flown at least 100 flights.

#3.)Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models.

#4.)Find the 48 hours (over the course of the whole year) that have the worst delays. 
#Cross-reference it with the weather data. Can you see any patterns?

#5.)What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? 
#What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?

#6.) You might expect that there’s an implicit relationship between plane and airline, because each plane is 
#flown by a single airline. Confirm or reject this hypothesis using the tools you’ve learned above.

###############################################################
#13.6:Join problems  ##############################################
#A few things you should do with your data to make your joins go smoothly:
#1.) Start by identifying the primary key, or the variables which can be combined to for the primary key.  Do this
#based on an understanding of the data, not by searching empirically - later version of your data might not work the same.

#2.) Check that none of the variables in the primary key column are missing.  If a value is missing, we can't identify an abs.

#3.) Check that foreign keys match primary keys in another table.  The best way to do this is with an anti_join().  It's
#common for key not to match due to data entry errors.
#If we have missing keys, we need ot consider how to handle observations without a match.

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
#stringr isn't part of the core tidyverse, so we need ot load it:
library(stringr)
library(tidyverse)

###############################################################
#14.2: String basics  #########################################
#We can create strings with single or double quotes; there is no difference in behavior.
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
string2

#If you forget to close a quote, you'll see +, the continuation character:
#"This is a string without a closing quote

#To include a literal single or double quote in a string, you can use \ to "escape" it:
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"
#If you want to include a literal backslash, you need to double up: "\\"

#To see the raw content of a string, use writeLines():
x <- c("\"", "\\")
x
writeLines(x)


#14.2.1: String basics  #########################################


#14.2.2: String basics  #########################################


#14.2.3: String basics  #########################################


#14.2.4: String basics  #########################################


#14.2.5: String basics  #########################################


###############################################################
#14.3: Matching patterns w/ regular expressions  ################

#14.3.1: Basic Matches  ################


#14.3.2: Anchors  ################


#14.3.3: Character classes and alternatives  ################


#14.3.4: Repetition  ################


#14.3.5: Exercise  ################


###############################################################
#14.4: Tools  ##############################################


###############################################################
#14.5: Other types of pattern  ##############################################


###############################################################
#14.6: Other uses of regular expression  ##############################################


###############################################################
#14.7: stringi  ##############################################


###############################################################
#15: Factors ##############################################
###############################################################


###############################################################
#16: Dates & Times ##############################################
###############################################################

















