#Setup################
setwd("~/R/RStudio/R For Data Science")

install.packages("tidyverse")

library(tidyverse)

tidyverse_update()

install.packages(c("nycflights13","gapminder","Lahman"))

#3: ***************************** Data Visualization*****************************
#3.2: *****************************First Steps*****************************

#3.2.1 The mpg Data Frame*****************************
#load mpg data frame from ggplot2
#but first find out about the data frame:
?mpg

#load it
mpg

#3.2.2: Creating a ggplot*****************************
#create a scatterplot
ggplot(data = mpg) +  #creates a coordinate system we can add layers to
  geom_point(mapping = aes(x=displ, y=hwy)) #geom_point adds a layer of points to the plot.  Each geom fnctn takes a mapping argument, paired with aes and its x and y arguments

#3.2.3: A graphing Template*****************************
#Turn this example into a reusable graphing template:
    #ggplot(data = <DATA>) +
    #  <GEOM_FUNCTION> (mapping = aes(<MAPPINGS>))
#to make a graph, replace the bracketed sections with relevant info


#3.2.4: Exercises*****************************
#2 How many rows in mtcars?  How many columns?
nrow(mtcars)
ncol(mtcars)

#3 What does the drv variable describe?
?mpg

#4 make a scatterplot of hwy vs cyl
ggplot(data = mpg) +
  geom_point (mapping = aes(x=cyl, y=hwy))

#5 what happens if you make a scatterplot of class vs drv?  Why is this plot not useful?
ggplot(data = mpg) +
  geom_point (mapping = aes(x=class, y=drv))


#3.3: ***************************** Aesthetic Mappings *****************************
#We can add a 3rd variable to a 2-D scatterplot by mapping it to an aesthetic.  Aesthetics include size, shape, and color of points.
#For example, we can map the colors of your points to the class variable to reveal the class of each car:
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=class))
#this reveals many outliers are 2seaters - sports cars in fact.

#We could have mapped class to the size aesthetic the same way.  However, size implies order, while class variable is unordered (and we see a warning):
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, size=class))

#We could have mapped class to the alpha aesthetic which controls the transparency:
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, alpha=class))

#We could have mapped class to the shape aesthetic which controls the shape:
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, shape=class))

#SUV's don't get mapped; ggplot2 uses only 6 shapes at a time

#ggplot2 selects a scale and constructs a legend automatically.

#we can also manually set the aesthetic properties.  Here, we change the points to blue, setting the argument outside of the geom fnctn:
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy), colour="blue")

#We have to select a value which makes sense for an aesthetic:
#name of a color as character string
#size of a point in mm
#shape of a point as a number http://r4ds.had.co.nz/data-visualisation.html#fig:shapes


#3.3.1: Exercises
#1.) What's wrong with this code?  Why aren't the points blue?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue")) #color was assigned within aes(), not outside

#2.) Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset).
?mpg

#How can you see this information when you run mpg?
mpg

#info is given at the top of each column when printing the data frame. Or, use "glimpse":
glimpse(mpg)


#3.) Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = year))
#a continuous variable cannot be mapped to shape


#4.) What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = year, color = year))


#5.) What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
?geom_point #This has some great info!

#Examples:
glimpse(mtcars)

p <- ggplot(mtcars, aes(wt, mpg)) #Assign to a variable

p + geom_point() #point data & layers to scatter output

# Add aesthetic mappings
p + geom_point(aes(colour = factor(cyl))) #colors cylinders

p + geom_point(aes(shape = factor(cyl))) #assigns shapes to cyclinders

p + geom_point(aes(size = qsec)) #assigns size to quarter mile time


# Change scales
p + geom_point(aes(colour = cyl)) + scale_colour_gradient(low = "blue")

p + geom_point(aes(shape = factor(cyl))) + scale_shape(solid = FALSE)


# Set aesthetics to fixed value
ggplot(mtcars, aes(wt, mpg)) + geom_point(colour = "red", size = 3) #makes all points red, 3mm


# Varying alpha is useful for large datasets
d <- ggplot(diamonds, aes(carat, price))

d + geom_point(alpha = 1/10)

d + geom_point(alpha = 1/20)

d + geom_point(alpha = 1/100)


# For shapes that have a border (like 21), you can colour the inside and
# outside separately. Use the stroke aesthetic to modify the width of the border
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 3, stroke = 5) #size is the inside circle, stroke is the width of the border


# You can create interesting shapes by layering multiple points of different sizes
p <- ggplot(mtcars, aes(mpg, wt, shape = factor(cyl)))

p + geom_point(aes(colour = factor(cyl)), size = 4) +
  geom_point(colour = "grey90", size = 1.5)

p + geom_point(colour = "black", size = 4.5) +
  geom_point(colour = "pink", size = 4) +
  geom_point(aes(shape = factor(cyl)))

# These extra layers don't usually appear in the legend, but we can force their inclusion
p + geom_point(colour = "black", size = 4.5, show.legend = TRUE) +
  geom_point(colour = "pink", size = 4, show.legend = TRUE) +
  geom_point(aes(shape = factor(cyl)))

# geom_point warns when missing values have been dropped from the data set
# and not plotted, you can turn this off by setting na.rm = TRUE
mtcars2 <- transform(mtcars, mpg = ifelse(runif(32) < 0.2, NA, mpg))
ggplot(mtcars2, aes(wt, mpg)) + geom_point()
ggplot(mtcars2, aes(wt, mpg)) + geom_point(na.rm = TRUE)


#6.) What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)?
ggplot(mpg, aes(x = displ, y = hwy, color = displ < 5)) +
  geom_point()
#this maps color only to observations where displ <5


#3.4: ***************************** Common Problems *****************************
#One common problem when creating ggplot2 graphics is to put the + in the wrong place:
#it has to come at the end of the line, not the start. In other words, make sure you havent accidentally written code like this:
ggplot(data = mpg)
+ geom_point(mapping = aes(x = displ, y = hwy))

#If youre still stuck, try the help. You can get help about any R function by running ?function_name in the console,
# or selecting the function name and pressing F1 in RStudio.


#3.5: ***************************** Facets *****************************
#facets each display one subset of the data
#fnctn facet_wrap facets by a single variable

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2) #first argument is a data structure

#to facet on 2 variables, add facet_grid() to plot call:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl) #separate the data structures with " ~ "

#if prefer not to facet in rows or columns dimension, use a "." instead of a variable name:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)


#3.5.1: Exercises *****************************
#1.) What happens if you facet on a continuous variable?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(~ cty)
#converts each unique value into a category

#2.) What do the empty cells in plot with "facet_grid(drv ~ cyl)" mean? How do they relate to this plot?
ggplot(data = mpg) +
  
  geom_point(mapping = aes(x = drv, y = cyl))
#there are no values for these points


#3.) What plots do the following code make?  What does the "." do?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

#this layers the categories on the side
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
#this arrays categories across the top
# "." ignores that dimension for faceting in facet_grid(rows, columns)


#4.) Take the first faceted plot in this section:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

#What are the advantages to using faceting instead of the colour aesthetic? More clearly isolates the groups.
#What are the disadvantages?Lose a bit of the context.
#How might the balance change if you had a larger dataset?


#5.)Read ?facet_wrap.
?facet_wrap

#What does nrow do? sets the number of display rows
#What does ncol do? sets the number of display columns
#What other options control the layout of the individual panels?
#Why doesnt facet_grid() have nrow and ncol variables?

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~class)


# Control the number of rows and columns with nrow and ncol
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~class, nrow = 4) #ncol = 3


#6.) When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(cyl ~ drv)


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
#A: because you read fewer groupings left to right 


#3.6: ***************************** Geometric Objects *****************************
#A GEOM is the geometrical object that a plot uses to represent data
#To change the GEOM in your plot, change the geom function you add to ggplot():

# scatterplot
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# smoothed line
?geom_smooth #for help
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#we can also set the linetype of a line within the mapping to draw a different line for each category:
#here, a different line for each type of drive:
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))



#we can make this more clear by overlaying lines on top of the raw data and coloring everything by drv:
ggplot(data = mpg) +

  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

#to add multiple geoms to the same plot, add multiple geom functions to ggplot():
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, linetype = drv, color = drv),
    show.legend = FALSE
  )



#but this winds up duplicating some code.  better to pass the mappings to ggplot(), and ggplot2
#will treat these as global mappings which apply to each geom in the graph:
ggplot(data = mpg, mapping = aes(x=displ, y=hwy)) +
  geom_point() +
  geom_smooth()

#If we place mappings in a geom function, ggplot2 treats them as local mappings for that layer only.
#So, we can display different aesthetics in different layers.  Here, we color by class:
ggplot(data = mpg, mapping = aes(x=displ, y=hwy)) +
  geom_point(mapping=aes(color=class)) +
  geom_smooth()

#Here, we color by class and draw a line for only subcompacts:
ggplot(data = mpg, mapping = aes(x=displ, y=hwy)) +
  geom_point(mapping=aes(color=class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE) #"Filter" explained next chapter

#3.6.1: Exercises###################
#1: What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
#geom_line(), geom_boxplot(), geom_histogram(), geom_area()
#https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf

#2: Run this code in your head and predict what the output will look like.
#Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

#3:What does show.legend = FALSE do? removes legend
#What happens if you remove it?
#Why do you think I used it earlier in the chapter? could be confusing with multiple layers?

#4:What does the se argument to geom_smooth() do? standard error or confidence interval


#5:Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

#they'll look the same; first is a global assignment of aesthetics, second is two layers mapped

#**************************************************************
#3.7: Statistical Transformations *****************************
#**************************************************************
?diamonds

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

#Y-axis displays count, which is not in "diamonds".  Some graphs calculate new values to plot:
#bar charts, histograms, frequenct polygons all bin data and plot bin counts
#smoothers fit a model to the data then plot a prediction from the model
#boxplots compute a summary of the data and display the information
#the algorithm used to calculate these new values is called a "stat" (statistical transformation)
#Use help on the function to find out which default stat is used.

#Can use geoms and stats interchangeably.  For example:
ggplot(data = diamonds) +
    stat_count(mapping = aes(x = cut))

#3 Reasons to use a stat explicitly:

#1:  to override the default stat.
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

#2:You want to override the default mapping from transformed variables to
# aesthetics.  For example, display proportions rather than counts:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

#3:To draw greater attention to the statistical xformation in your code.
# Here, we uses "stat_summary" to summarize y values for each unique x value.
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

#There are over 20 stats we can use.  For a complete list, see ggplot2 cheatsheet:
#https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf

#3.7.1 Exercises
#1: What is the default geom associated with stat_summary()? How could you rewrite
#the previous plot to use that geom function instead of the stat function?
?stat_summary

#2: What does geom_col() do? How is it different to geom_bar()?
#A: geom_col uses identity as its default stat.

#3: Most geoms and stats come in pairs that are almost always used
#in concert. Read through the documentation and make a list of all
#the pairs. What do they have in common?

#4: What variables does stat_smooth() compute? What parameters control its behaviour?
#stat_smooth calculates:
# y: predicted value
# ymin: lower value of the confidence interval
# ymax: upper value of the confidence interval
# se: standard error

#5: In our proportion bar chart, we need to set group = 1. Why? In other words what
#is the problem with these two graphs?
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
#appears to assign everything the same proportion if group =1 not set

#**************************************************************
#3.8: Position Adjustments *****************************
#**************************************************************
#We can color bar charts using either the "color" aesthetic or "fill":
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color=cut))

#colors the outline

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill=cut))
#colors the bars

#If we map the fill aesthetic to a different discrete variable than the x variable, bars are
#automatically stacked.  Does not work for a continuous variable:
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, fill=color))

#"stack" is the default position adjustment specified by geom_bar.  Three other options are:
#position=identity: places each object where it falls in the graph.  In other words, there are
#multiple bars layered at their respective height in a single bar of a bar graph.  For example,
#each clarity level will have a bar for each cut category (above fair, we'd see one bar, but there are
#actually 8, one for each clarity level).

#to make the objects somewhat visible, we'd need to make the bars transparent by setting "alpha" to a small value,:
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")

#or, make them completely transparent via "fill = NA".
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) +
  geom_bar(fill = NA, position = "identity")

#therefore, "identity" is not really useful for bar charts!

#position=fill: makes it easy to compare proportions across groups, by making the stacks of the bar

#chart the same height:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position="fill")

#position=dodge: places overlapping objects directly beside one another, making it easier to compare values:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position="dodge")

#position=jitter: adds a small amount of random noise for each point; very useful for scatterplots with overplotting
#overplotting problem would occur if, say, we have 126 of 234 observations displayed, and 109 are in one spot.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

#Because this is such a useful operation, ggplot2 comes with a shorthand for
#"geom_point(position = "jitter")": "geom_jitter()":
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))


#3.8.1: Exercises ###################
#1. What is the problem with this plot? Overplotting!
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

#How could you improve it?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

#2.What parameters to geom_jitter() control the amount of jittering? "width=", "height="
?geom_jitter

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 0.25)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 0.5)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 0.5, height = 0.5)

#3.Compare and contrast geom_jitter() with geom_count()
?geom_count

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

#geom_count increases the size of the data points to represent # observations

#4.Whats the default position adjustment for geom_boxplot()? "position_dodge"
#Create a visualisation of the mpg dataset that demonstrates it.
ggplot(data = mpg, aes(x = drv, y = hwy, color = class)) +
  geom_boxplot()

#**************************************************************
#3.9: Coordinate Systems *****************************
#**************************************************************
#Default coordinate system is Cartesian.  However, tehre are several alternates.

#coord_flip() switches x and y axes.  Works for horizontal boxplts and long labels on the x-axis:
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

#coord_quickmap() sets the correct aspect ratio for maps
library("maps")
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#coord_polar() uses polar coordinates
bar <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()

bar + coord_polar()

#3.9.1: Exercises ###################
#1. Turn a stacked bar chart into a pie chart using coord_polar().

#2. What does labs() do? Read the documentation.

#3. Whats the difference between coord_quickmap() and coord_map()?
?coord_quickmap
?coord_map

#4. What does the plot below tell you about the relationship between city and highway mpg? hwy>city
#Why is coord_fixed() important? A: Puts the intersection at a 45 degree angle
?coord_fixed

#What does geom_abline() do? A: Adds a reference line to the plot
?geom_abline

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()

#**************************************************************
#3.10: The Layered Grammar of Graphics *****************************
#**************************************************************
#by layering , we can make almost any plot in ggplot2.  Here's a template:
# ggplot(data = <DATA>) +
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>,
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

#this template takes 7 parameters, shown here in brackets.
#These 7 parameters compose the grammar of graphics

#**************************************************************
#4.0: Workflow: Basics ****************************
#**************************************************************

#4.1 Coding Basics ###################
#Use R as a calculator:
1 /200 * 30

(59+73+2)/3

sin(pi /2)

1.40254 ^(1/8)

#Create new objects:
x <- 3*4

#use "Alt and -" as a shortcut for "<-"

#4.2 What's in a Name? ###################
#Object names must start with a letter, and contain only letters, numbers, "_", and "."

#you can inspect an object by typing its name:
x

#Create another object:
this_is_a_really_long_name <- 2.5

#To inspect, type "this", press TAB
this_is_a_really_long_name

#4.3 Calling Functions ###################
#R has many built-in functions, called by: function_name(arg1 = val1, arg2 = val2, ...)
seq(1,10)

#make an assignment:
x <- "hello world"

y <- seq(1,10,length.out = 4)

#make an assignment, AND immediately check the result:
(y <- seq(1,10,length.out = 4))

#4.4 Practice ########################
#3.Press Alt + Shift + K. What happens? How can you get to the same place using the menus?
#Keyboard shortcut menu!

#**************************************************************
#5.0: Data Transformation ****************************
#**************************************************************
#this uses the dplyr package

#**************************************************************
#5.1.2 nycflights13 (data frame containing all 336k flights departing NYC in 2013)*****************************
#**************************************************************
library(nycflights13) #from the Bureau of Transportation Statistics:http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236

?flights
flights
#This prints differently because it's a "tibble" - a data frame tweaked to work better in the tidyverse.
#tibbles are covered in depth in the "Wrangle" section
#under the headers, note the type of each variable:
#int = integer, dbl = doubles (aka real numbers), chr = character vector/string, dttm = date-time
#lgl =logical (true/false vectors), fctr = factors(to represent categorical values with fixed possible values), date = dates

#**************************************************************
#5.1.3: dplyr basics*****************************
#**************************************************************
#Five key functions allow us to solve almost all data manipulation challenges:
#filter() pick observations by their values
#arrange() reorder the rows
#select() select variables by name
#mutate() create new variables with functions of existing variables
#summarise() collapse many values to a single summary
#These 5 can be used with group_by() to change the scope from entire set to group-by-group

#1.) first argument is a data frame.
#2.) next arguments describe what to do with the data frame, using the variable names sans quotes
#3.) result is a new data frame

#We can chain together multiple commands to obtain complex results.

#**************************************************************
#5.2: Filter rows with filter()*****************************
#**************************************************************
#select all flights on January 1st:
filter(flights, month==1, day==1)

#this does not modify the input, so if we want to save the result, we need to make an assignment:
jan1 <- filter(flights, month==1, day==1)

#if you want to both print the result and assign, wrap the assignment in parentheses:
(jan1 <- filter(flights, month==1, day==1))

#5.2.1: Comparisons ###################
#R uses the standard operators: >, >=, <, <=, !=, and ==
#Beware floating point numbers.  Truncating can cause issues:
1/49 * 49 == 1
#Result is "FALSE".  Instead, use "near":
near(1/49 * 49, 1)

#**************************************************************
#5.2.2: Logical operators*****************************
#**************************************************************
#& is "and"
#| is "or"
#! is "not"

#Examples: (Draw Venn diagrams to accompany)
#y & ! x
#x
#x | y
#x & y
#xor(x, y)
#x & !y
#y

#Find all flights which departed in November OR December:
filter(flights, month==11|month==12)

#useful shorthand is x %in% y:
filter(flights, month %in% c(11,12))

#Remember DeMorgan's Law:  !(x & y) is the same as !x | !y , and !(x | y) is the same as !x & !y.
#for example, we can use either to find flights that weren't delayed by more than 2 hours:
filter(flights, !(arr_delay>120 | dep_delay>120))

filter(flights, arr_delay<=120 & dep_delay<=120)

#WARNING: When using complicated, multi-part filters, consider making them explicit variables instead.
#This makes checking work much easier.

#**************************************************************
#5.2.3 Missing values*****************************
#**************************************************************
#NA s represent missing values, and are contagious: almost any operation relating to an NA will return NA as well
#To determine whether a value is NA, use is.na()
x <-  NA
is.na(x)

#filter only includes rows where the condition is TRUE.  It excludes both FALSE and NA values.
#To preserve missing values, ask for the expplicitly:
df <- tibble(x = c(1, NA, 3))

filter(df, x>1)

filter(df, is.na(x) | x>1)

#**************************************************************
#5.2.4 Exercises*****************************
#**************************************************************
#1. Find all flights that:

  # Had an arrival delay of two or more hours
  filter(flights, arr_delay>120)
  
  # Flew to Houston (IAH or HOU)
  filter(flights, dest %in% c("IAH","HOU"))
  
  # Were operated by United, American, or Delta
  airlines
  
  filter(flights, carrier %in% c("UA","AA", "DL"))
  
  # Departed in summer (July, August, and September)
  filter(flights, month %in% c(7,8,9))
  
  #or
  filter(flights, between(month, 7, 9))
  
  # Arrived more than two hours late, but didnt leave late
  filter(flights, arr_delay > 120 & dep_delay <=0)
  
  # Were delayed by at least an hour, but made up over 30 minutes in flight
  filter(flights, dep_delay - arr_delay > 30 & dep_delay >=60)
  
  # Departed between midnight and 6am (inclusive)
  filter(flights, between(dep_time, 0000, 0600))
  
  filter(flights, dep_time == 2400)
  
  filter(flights, (dep_time == 2400 | dep_time <= 0600))
  
  filter(flights, !between(dep_time, 0601, 2359))

#2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed 
  #to answer the previous challenges?
?between

#This is a shortcut for x >= left & x <= right, implemented efficiently in C++ for local values,
#and translated to the appropriate SQL for remote tables.
#Usage: between(x, left, right)
filter(flights, between(dep_time, 0000, 0600))
  
  
#3. How many flights have a missing dep_time?
filter(flights, is.na(dep_time)) #8,255

#What other variables are missing? Arrival times.
#What might these rows represent? Cancelled flights.

#4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing?
#Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
NA^0 #anything raised to 0 is 1
NA | TRUE

#**************************************************************
#5.3 Arrange rows with arrange()*****************************
#**************************************************************
#arrange() changes the order of rows (like SORT in Excel)
arrange(flights, year, month, day, dep_time)

#use desc() to arrange in descending order:
arrange(flights, desc(sched_dep_time))
#missing values are sorted to the end

#*************************************************************
#5.3.1 Exercises*****************************
#**************************************************************
#How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, desc(is.na(dep_time)), dep_time)

#Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)

#Sort flights to find the fastest flights.
arrange(flights, arr_time - dep_time)

#Which flights travelled the longest? Which travelled the shortest?
arrange(flights, distance)
arrange(flights, desc(distance))

#**************************************************************
#5.4 Select columns with select()*****************************
#**************************************************************
#select() allows us to narrow the set of variables in a data set

#select columns by name:
select(flights, year, month, day)

#select all columns between year and day, inclusive:
select(flights, year:day)

#select all columns EXCEPT those from year to day, inclusive:
select(flights, -(year:day))

#helper functions you can use within select():
  #starts_with("abc"): matches names that begin with abc.
  #ends_with("xyz"): matches names that end with xyz.
  #contains("ijk"): matches names that contain ijk.
  #matches("(.)\\1"): selects variables that match a regular expression. This one matches any variables 
  #that contain repeated characters.
  #num_range("x", 1:3) matches x1, x2 and x3.
#See ?select for more details.

#select() can be used to rename variables, but its rarely useful because
#it drops all of the variables not explicitly mentioned. Instead, use rename(),
#which is a variant of select() that keeps all the variables that arent explicitly mentioned:
rename(flights, tail_num = tailnum)

#Another option is to use select() in conjunction with the everything() helper.
#This is useful if you have a handful of variables youd like to move to the start of the data frame.
select(flights, time_hour, air_time, everything())

#**************************************************************
#5.4.1 Exercises*****************************
#**************************************************************
#1.Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with("dep") , starts_with("arr"))
select(flights, matches("^(dep|arr)_(time|delay)$"))

#2.What happens if you include the name of a variable multiple times in a select() call?
select(flights, year, month, day, year, year)
#ignores duplicates

#3.What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
vars

?one_of #allows you to select variables with a character vector instead of an unquoted variable name.

#Can then pass character vector to select():
select(flights, one_of(vars))

#4.Does the result of running the following code surprise you? #not case-sensitive by default
select(flights, contains("TIME"))

#How do the select helpers deal with case by default? ignore_case = TRUE

#How can you change that default?
select(flights, contains("TIME", ignore.case = FALSE))

#**************************************************************
#5.5 Add new variables with mutate()*****************************
#**************************************************************
#mutate() adds new columns which are functions of existing columns
#always adds them to the end of the data set

#Let's create a smaller data set:
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
)

#create a "speed" variable:
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance/air_time* 60
)

#we can refer to our newly-created variable:
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

#If only keep new variables, use transmute():
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

#**************************************************************
#5.5.1 Useful creation functions*****************************
#**************************************************************
#Many functions we can use with mutate()
#Function must be vectorized: takes a vector of values as input, creates a vector of same size as output
  #Arithmetic Functions: +, -, *, /, ^.  Also useful in conjuntion with aggregate functions discussed below.
  #Modular arithmetic: %/% (integer division) and %% (remainder), where x==y * (x %/% y) + (x %% y)
  #This allows us to break integers into pieces.  For example, can compute hour and minute from dep_time with:
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

#Logs: log(), log2(), log10()
#Logarithms are useful for xforming data ranging across multiple orders of magnitude.
#They convert multiplicative relationships into additive (see "Modeling").
#Editor's Note: recommend using log2(), since it's most intuitive.  differnce of 1 on log scale = doubling,
#difference of -1 = halving

#Offsets: lead() and lag() allow us to refer to leading and lagging values.
#Uses: Allows you to compute running differences (eg x - lag(x) ) ,find when values change (x != lag(x))
#Most useful in conjunction with group_by()
y <-  c(1,3,5,7,9)
lag(y)
lead(y)

#Cumulative and Rolling Aggregate: R provides functions for running sums, products , mins, maxes:
#cumsum(), cumprod(), cummin(), cummax()
cumsum(y)
cumprod(y)
cummin(y)
cummax(y)

#dplyr provides cummean() for cumulative means
cummean(y)

#For rolling sums, use RcppRoll package
library(RcppRoll)
roll_sum(y, 2)

#Logical comparisons: <, <=, >, >=, !=
#Wise to store interim values in new variables if you are working with a complex sequence of logical values

#Ranking: Number of ranking functions. 
#min_rank() does the most usual type fo ranking.
#Defaults to giving smallest values smallest rank.  Use desc(x) to give largest values the smallest ranks.
x <- c(5, 1, 3, 2, 2, NA)
min_rank(x)
min_rank(desc(x))

#Others include: row_number(), dense_rank(), percent_rank(), cume_dist(), ntile().
row_number(x) #equivalent to min_rank, except ties.method = min rather than =first
?row_number

dense_rank(x)#like min_rank, but no gaps between ranks after ties
percent_rank(x)#ranks converted to 0 - 1
ntile(x,2)
cume_dist(x)#cumulative distribution function. Proportion of all values less than or equal to the current rank

#**************************************************************
#5.5.2 Exercises *****************************
#**************************************************************
#1.Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because 
#theyre not really continuous numbers. 
#Convert them to a more convenient representation of number of minutes since midnight.
mutate(flights,
       dep_time_mins = dep_time %/% 100 * 60 + dep_time %% 100,
       sched_dep_time_mins = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %>%
  
select(dep_time, dep_time_mins, sched_dep_time, sched_dep_time_mins)



#2.Compare air_time with arr_time - dep_time. 
#What do you expect to see? expect to see no difference.
#What do you see? 
transmute(flights,
       arr_time,
       dep_time,
       my_air_time_calc = arr_time - dep_time,
       air_time,
       difference = my_air_time_calc - air_time
       )
#What do you need to do to fix it?
transmute(flights,
          arr_time,
          dep_time,
          my_air_time_calc = (arr_time %/% 100 * 60 + arr_time %% 100) - (dep_time %/% 100 * 60 + dep_time %% 100),
          air_time,
          difference = my_air_time_calc - air_time
)

#3.Compare dep_time, sched_dep_time, and dep_delay. 
#How would you expect those three numbers to be related?
mutate(flights,
          dep_time,
          sched_dep_time,
          dep_delay,
          my_dep_delay_time_calc = (dep_time %/% 100 * 60 + dep_time %% 100) - (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100),
          dep_delay - my_dep_delay_time_calc
          ) %>%
filter(dep_delay != my_dep_delay_time_calc) %>%
select(4:6,20)  

#4.Find the 10 most delayed flights using a ranking function. 
#How do you want to handle ties? Carefully read the documentation for min_rank().
arrange(flights, min_rank(desc(dep_delay))) %>%
filter(min_rank(desc(dep_delay)) <= 10)

#5.What does 1:3 + 1:10 return? Why?
1:3 + 1:10
#warns that "object length is not a multiple of shorter obest length.
#In other words, the vector lengths are inconsistent.  Result is that 1,2,3 is repeated while being added to 1:10

#6.What trigonometric functions does R provide?
#cos, sin, tan, acos, asin, atan


#**************************************************************
#5.6 Grouped Summaries with summarize() *****************************
#**************************************************************
#summarise() collapses a data frame to a single row:
summarize(flights, delay = mean(dep_delay, na.rm = TRUE)) #na.rm = TRUE removes NA values prior to calculation

#summarize() is far more powerful when paired with group_by()
#This changes the unit of analysis from the complete dataset to to individual groups (subtotals).
#Then, when using dplyr verbs on a grouped data frame they'll be automatically applied "by group".  For example:
by_day <- group_by(flights, year, month, day)

by_day

summarize(by_day, delay=mean(dep_delay, na.rm = TRUE))


#**************************************************************
#5.6.1 Combining multiple operations with the pipe *****************************
#**************************************************************
#If we want to explore the relationship  between distance and average delay for each location, we might write:
by_dest <-  group_by(flights, dest)#first, group flights by destination

delay <-  summarize(by_dest,#summarize to compute: 
                    count = n(), #number of flights
                    dist = mean(distance, na.rm = TRUE), #avg distance
                    delay = mean(arr_delay, na.rm = TRUE) #average delay
                    )

delay 

delay <- filter(delay, count > 20, dest != "HNL") #remove "noisy" data and Honolulu

delay

arrange(delay, desc(count)) #sort desc by count 

#graph the result:
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

#This is slow, because we have to create 3 separate data frames.
#We can use pipe instead, %>%
delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(), #number of flights
    dist = mean(distance, na.rm = TRUE), #avg distance
    delay = mean(arr_delay, na.rm = TRUE) #average delay
  ) %>%
  filter(count>20, dest != "HNL")

delays

arrange(delay, desc(count)) #sort desc by count 
#x %>% f(y) turns into f(x, y), and x %>% f(y) %>% g(z) turns into g(f(x, y), z) and so on. 
#You can use the pipe to rewrite multiple operations in a way that you can read left-to-right, top-to-bottom.
#pipes are explained in more detail later
#ggplot2 does not work with pipe; ggvis - ggplot2 successor - will.


#**************************************************************
#5.6.2 Missing values *****************************
#**************************************************************
#What happens if we don't set the na.rm argument?
flights %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))
#cannot calculate where there are missing values.

#Since NA's represent cancelled flights, we could also remove missing flights:
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

#and then summarized:
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

#**************************************************************
#5.6.3 Counts *****************************
#**************************************************************
#When aggregating, it's wise to include either a count n() or a count of non-missing values sum(!is.na(x)):
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x=delay)) +
  geom_freqpoly(binwwidth = 10)
#some flights are delayed by 5 hours!

#We can get better insight if we draw a scatterplot of number of flights versus average delay
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
      )

ggplot(data = delays, mapping = aes(x=n, y=delay)) +
  geom_point(alpha=1/10)
#Naturally, there is much wider variance per plane when there is a low # flights

#It's often useful to filter out the groups with very few observations to see more of the pattern:
delays %>%
  filter( n > 25) %>% #keep only planes with >25 flights
  ggplot(mapping = aes(x = n, y = delay)) + #here, the + acts as %>% for ggplot2
  geom_point(alpha = 1/10)

#RStudio Tip########################
#Ctrl + Enter runs the currrent command
#Once run, if you change a variable, you can re-send with Ctrl + Shift + P
#Ctrl + Shift + S runs the whole script!

batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

#another example:
batters %>%
  filter(ab>100) %>%
  ggplot(mapping = aes(x=ab, y=ba))+
  geom_point() +
  geom_smooth(se=FALSE)
#We can see that more at bats is positively correlated with BA

#DBSS also affects ranking:
batters %>%
  arrange(desc(ba))
#You can find a good explanation of this problem at http://varianceexplained.org/r/empirical_bayes_baseball/ 
#and http://www.evanmiller.org/how-not-to-sort-by-average-rating.html


#**************************************************************
#5.6.4 Useful summary functions *****************************
#**************************************************************
#R provides many other useful summary functions:

#Measures of Location: median
#It's sometimes usefult to combine aggregation with subsetting:

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

#Measures of Spread: 
#Standard Deviation: sd(x), 
#Interquartile Range: IQR(x), 
#Median Absolute Deviation: mad(x)
not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

#Measures of Rank: min(x), max(x), 
#Quantiles: quantile(x,0.25) will find a value of x that is greater thn 25% of the values and less than 75%
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

#Measures of Position: first(x), nth(x,2), last(x)
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

#These are complementary to filtering on ranks. Filtering gives all variables, with each 
#observation in a separate row:
not_cancelled%>%
  group_by(year, month,day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range (r))

#Measures of Count:
#n() takes no arguments and returns size of the group
#sum(!is.na()) count number of non-missing values
#n_distinct() counts number of unique values

#which destinations have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

#dplyr provides an additional helper if we want a count:
not_cancelled %>%
  count(dest)

#We can provide a "weight" variable.  Here, we examine the total number of miles a plane flew:
not_cancelled %>%
  count(tailnum, wt=distance) %>%
  arrange(desc(n))


#Counts and proportions of logical values: sum(x > 10), mean(y == 10)
#Used with numeric function, TRUE is converted to 1 and FALSE to 0, so
#sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion!

#Example: How many flights left before 5am?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))


#Example: what proportion of flights are delayed by more than one hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))


#**************************************************************
#5.6.5 Grouping by multiple variables *****************************
#**************************************************************
#When grouping by multiple variables, each summary peels off one level of grrouping.
#Makes it easy to progressively roll up a data set:

daily <-  group_by(flights, year, month, day)

(per_day <- summarize(daily, flights =n()))

(per_month <- summarize(per_day, flights = sum(flights)))

(per_year <- summarize(per_month, flights = sum(flights)))


#**************************************************************
#5.6.6 Ungrouping *****************************
#**************************************************************
#Use ungroup() to remove grouping and return to operating on ungrouped data:
daily %>%
  ungroup() %>%             #no longer grouped by date
  summarize(flights = n())  #all flights


#**************************************************************
#5.6.7 Exercises *****************************
#**************************************************************
#1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. 
#Consider the following scenarios:
  
  #A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
  
  #A flight is always 10 minutes late.
  
  #A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
  
  #99% of the time a flight is on time. 1% of the time its 2 hours late.

  #Which is more important: arrival delay or departure delay?

#3. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).

#4. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?

#5. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?

#6. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

#7. What does the sort argument to count() do. When might you use it?


#**************************************************************
#5.7 Grouped mutates and filters *****************************
#**************************************************************
#Grouping is most useful in conjunction with summarize(), but you can also do convenient operations 
#with mutate() and filter().

#Find the worst members of each group:
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

#Find all groups bigger than a threshold:
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n()>365)
popular_dests

#Standardize to compute per group statistics:
popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)

#**************************************************************
#5.7.1 Exercise *****************************
#**************************************************************
#1. Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.

#2. Which plane (tailnum) has the worst on-time record?

#3. What time of day should you fly if you want to avoid delays as much as possible?

#4. For each destination, compute the total minutes of delay. For each, flight, compute the proportion of the total delay for its destination.

#5. Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using lag() explore how the delay of a flight is related to the delay of the immediately preceding flight.

#6. Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?

#7. Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.

#8. For each plane, count the number of flights before the first delay of greater than 1 hour.


#**************************************************************
#6 Workflow: SCripts *****************************
#**************************************************************
#Ctrl + Enter executes the current R expression in the console
#Ctrl + Shift + S executes teh complete script in one step.

#Never include install.packages() or setwd() in a shared script.  
#Not cool to change someone else' settings

#R Studio also highlights syntax errors and warns of potential code problems.


#**************************************************************
#7: Exploratory Data Analysis *****************************
#**************************************************************

#**************************************************************
#7.1: Introduction *****************************
#**************************************************************
#EDA: An iterative cycle to
  #1: generate questions about the data
  #2: search for answers by visualizing, transforming, and modelling the data
  #3: Use what we learn to refine questions and/or generate new answers

#EDA is a integral part of data cleaning.


#**************************************************************
#7.1.1: Prerequisites *****************************
#**************************************************************
library(tidyverse)


#**************************************************************
#7.2: Questions *****************************
#**************************************************************
#Two types of questions are always useful when exploring your data:
  #1: What type of variation occurs within my variables?
  #2: What type of covariation occurs between my variales?

#Some terms:
# Variable- a quantity, quality, or property we can measure
# Value- state of a variable when we measure it.  Measurements may change through time.
# Observation- set of measurements made under similar conditions (typically at the same time)
# Tabular data- a set of value, each associated with a variable and an observation.
  #Tabular data is "tidy" if each value is in its own cell, each variable in its own column, and
  #each observation in its own row.


#**************************************************************
#7.3: Variation *****************************
#**************************************************************
#Tendency of the value of the variable to change from measurement to measurement.
#You are likely to get different measurements on continuous variables just via measurement error.
#Best way to examine is by visually examining teh distribution


#**************************************************************
#7.3.1: Visualizing distributions *****************************
#**************************************************************
#Methodology employed depend on whether the variable is categorical or continuous
#To examine the distribution of a categorical variable, use a bar chart:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x=cut))

#We can compute the counts with dplyr::count():
diamonds %>%
  count(cut)

#Use a histogram to examine the distribution of a continuous variable
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x=carat), binwidth = 0.5)

#We can compute this by hand by using dplyr::count() and ggplot2::cut_width():
diamonds %>%
  count(cut_width(carat, 0.5)) #to cut into equal-width bins

diamonds %>%
  count(cut_number(carat, 5)) #to cut into roughly equal-populated bins

#always explore a variety of binwidths, as they can expose different patterns.
#For example, look at the distribution when we zoom in on diamonds <3 carats:
smaller <- diamonds %>%
  filter(carat <3)

ggplot(data = smaller) +
  geom_histogram(mapping = aes(x=carat), binwidth = 0.1)

#If we want to overlay multiple histograms in the same plot, use geom_freqpoly().
#This uses lines rather than bars to graph the data - much cleared to see:
ggplot(data=smaller, mapping = aes(x=carat, color = cut)) +
  geom_freqpoly(binwidth=0.1)


#**************************************************************
#7.3.2: Typical Values *****************************
#**************************************************************
#Look for anything unexpected:
  #Which values are most common? Why?
  #Which values are rare? Why? Does that match your expectations?
  #Can you see any unusual patterns? What might explain them?

#Clusters of similar values suggest there are clusters/subgroups within your data set.
  #How are the observations within each cluster similar to each other?
  #How are the separate clusters different?
  #How can you explain or describe the clusters?
  #Why might the appearance of the clusters be misleading?


#**************************************************************
#7.3.3: Unusual Values *****************************
#**************************************************************
#When we have outliers, they can be difficult to see in a histogram.  For example:
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
#The only indication of an outlier is the large width on the x-axis

#To make is easier to see outliers, zoom in with coord_cartesian():
ggplot(diamonds) +
  geom_histogram(mapping = aes(x=y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50)) #zooms into the y-axis plot; can also zoom into x-axis

#Now, we can see three unusual values: 0, 30 and 60.  Pluck them with dplyr:

unusual <- diamonds %>%
  filter(y < 3 | y >20) %>% #drop all buy diamonds with y value <3 or >20
  select(price, x, y, z) %>%
  arrange(y)
unusual
#y is a width variable.  Diamonds can't have 0 width so these must be measurement errors.
#Diamonds of 30mm or 60mm width are 1" and 2" wide, and don'd cost a fortune - likely also mesurement errors.
#We should exclude these from any models since they are measurement errors.


#**************************************************************
#7.3.4: Exercises *****************************
#**************************************************************
#1. Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? Think about a diamond and how you might decide which dimension is the length, width, and depth.

#2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)

#3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?

#4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?


#**************************************************************
#7.4: Missing Values *****************************
#**************************************************************
#If we have uusual values in the data set, we have 2 options (3 really - we can impute the bad/missing values):
#1. Drop the entire row with the strange values:
diamonds2 <- diamonds %>%
  filter(between(y, 3, 20))

#2. Replace the unusual values with missing values.  Best way to do this is use mutate() to replace the original:
diamonds2 <-  diamonds %>%
  mutate(y=ifelse(y<3 | y>20, NA, y))
#ifelse has 3 arguments: test is a logical vestor, reult contains value of 2nd argument, yes, if true, and 3rd argument, no, if false

#ggplot2 doesn't include NAs in the plot, but notes they are missing:
ggplot(data = diamonds2, mapping = aes(x=x, y=y)) +
  geom_point()

#To suppress the warning, set na.rm+TRUE:
ggplot(data = diamonds2, mapping = aes(x=x, y=y)) +
  geom_point(na.rm = TRUE)

#We might want to explore what makes observtions with missing values different to observations with recorded values.
#Here we compare cancellations/non-cancellations at various departure times:
nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min /60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1/4)
#(this doesn't really tell us much - proportion would be helpful!)

#**************************************************************
#7.4.1: Exercises *****************************
#**************************************************************
#1. What happens to missing values in a histogram? What happens to missing values in a bar chart? Why is there a difference?

#2. What does na.rm = TRUE do in mean() and sum()?


#**************************************************************
#7.5: covariation *****************************
#**************************************************************
#The tendency for variables to vary together in a related way

#**************************************************************
#7.5.1: A categorical and continuous variable *****************************
#**************************************************************
#Common to explore the distribution of a continuous variable broken dow by a categorical variable.
#Using the default settings of geom_freqpoly is not that useful for comparison because the height is determined by count.
#Thus, if one group is much smaller, it's hard to see differences in shape:
ggplot(data = diamonds, mapping = aes(x=price)) +
  geom_freqpoly(mapping = aes(colour=cut), binwidth = 500)

#If we plot density instead, the comparison is easier,  Density means the area under each curve will be 1:
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
#It appears that fair cut diamonds may have the highest average price - but there's a lot going on here.

#A boxplot is alternative way to display the distribution of a continuous variable broken down by category.
#Each boxplot consists of:
  #A box strechting from 25th to 75th percentile - a distance known as the interquartile range
  #In the middle of the box is a line representing the median.
    #These lines tell us about the spread and whether the data is skewed
  #Visual points display observtions >1.5x IQR outside of either edge
  #Whiskers on either edge extend to the farthest non-outlier on either side

ggplot(data = diamonds, mapping = aes(x=cut, y=price)) +
  geom_boxplot()

#cut is an ordered factor: fair < good < very good...
#When a variable isn't ordered, we might want to re-order to make the display more intuitive.
#We can use the reorder() function to do this:

#First, we look at the class variable in the mpg dataset to examine how mileage varies:
ggplot(data=mpg, mapping = aes(x=class, y=hwy)) +
  geom_boxplot()

#Then, we reorder by class by median value of hwy:
ggplot(data=mpg) +
  geom_boxplot(mapping = aes(reorder(class, hwy, FUN = median),y=hwy))

#Since this boxplot has long variable names, it'll be easier to view if we flip it with coord_flip:
ggplot(data=mpg) +
  geom_boxplot(mapping = aes(reorder(class, hwy, FUN = median),y=hwy)) +
  coord_flip()


#**************************************************************
#7.5.1.1: Exercises *****************************
#**************************************************************
#1. Use what youve learned to improve the visualisation of the departure times of cancelled vs. non-cancelled flights.

#2. What variable in the diamonds dataset is most important for predicting the price of a diamond? How is that variable correlated with cut? Why does the combination of those two relationships lead to lower quality diamonds being more expensive?

#3. Install the ggstance package, and create a horizontal boxplot. How does this compare to using coord_flip()?

#4. One problem with boxplots is that they were developed in an era of much smaller datasets and tend to display a prohibitively large number of outlying values. One approach to remedy this problem is the letter value plot. Install the lvplot package, and try using geom_lv() to display the distribution of price vs cut. What do you learn? How do you interpret the plots?

#5. Compare and contrast geom_violin() with a facetted geom_histogram(), or a coloured geom_freqpoly(). What are the pros and cons of each method?

#6. If you have a small dataset, its sometimes useful to use geom_jitter() to see the relationship between a continuous and categorical variable. The ggbeeswarm package provides a number of methods similar to geom_jitter(). List them and briefly describe what each one does.


#**************************************************************
#7.5.2: Two categorical variables *****************************
#**************************************************************
#We'll want to count the number of observations for each combination of two variables.
#One way would be to use geom_count():
ggplot(data = diamonds) +
  geom_count(mapping=aes(x=cut, y=color))

#We could also count with dplyr:
diamonds %>%
  count(color, cut)

#We can then vsiualize using geom_tile():
diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x=color, y=cut)) +
  geom_tile(mapping=aes(fill=n))
  

#**************************************************************
#7.5.3: Two continuous variables *****************************
#**************************************************************
#A scatterplot is an effective way of exaining covariation of two continuous variables:
ggplot(data=diamonds) +
  geom_point(mapping = aes(x=carat, y=price))

#However, as the number of observations grows, scatterplots are less effective - points begin to overplot
#One way to overcome this is to use the alpha asesthetic to add transparency:
ggplot(data=diamonds) +
  geom_point(mapping = aes(x=carat, y=price), alpha=1/100)

#Another solution is to use bin.  We've already used geom_histogram() and geom_freqpoly() to bin in one dimension.
#Now, we use geom_bin2d() and geom_hex() to bin in 2 dimensions:
ggplot(data=smaller) +
  geom_bin2d(mapping = aes(x=carat, y=price))

install.packages("hexbin")

library(hexbin)

ggplot(data=smaller) +
  geom_hex(mapping = aes(x=carat, y=price))

#Another option: bin one continuous variable so it acts like a categorical variable, and
#use one of the techniques escribed to visualize a categorical/continuous combo.
ggplot(data=smaller, mapping = aes(x=carat, y=price)) +
  geom_boxplot(mapping=aes(group = cut_width(carat, 0.1))) #cut_width(x,width) divides x into bins of width width 
#Boxplots will look the same regardless of # observations.  Set varwidth = TRUE to make width proportional:

#Can also display the same # of points in each bin via cut_number():
ggplot(data=smaller, mapping = aes(x=carat, y=price)) +
  geom_boxplot(mapping=aes(group = cut_number(carat, 20))) #cut_width(x,width) divides x into bins of width width 


#**************************************************************
#7.5.3.1: Exercises *****************************
#**************************************************************
#1. Instead of summarising the conditional distribution with a boxplot, you could use a frequency 
#polygon. What do you need to consider when using cut_width() vs cut_number()? 
#How does that impact a visualisation of the 2d distribution of carat and price?

#2. Visualise the distribution of carat, partitioned by price.

#3. How does the price distribution of very large diamonds compare to small diamonds? 
#Is it as you expect, or does it surprise you?

#4. Combine two of the techniques youve learned to visualise the combined distribution of cut, 
#carat, and price.

#5. Two dimensional plots reveal outliers that are not visible in one dimensional plots. 
#For example, some points in the plot below have an unusual combination of x and y values, 
#which makes the points outliers even though their x and y values appear normal when examined separately.
#Why is a scatterplot a better display than a binned plot for this case?


#**************************************************************
#7.6: Patterns and Models *****************************
#**************************************************************
#If you spot a pattern in the data, ask yourself:
  #Could this pattern be due to coincidence?
  #How can you describe the relationship implied in the pattern?
  #How strong is the implied relationship?
  #What other variables might impact the relationship?
  #Does the relationship change if you look at subgroups?

#Old Faithful eruptions last longer the longer the wait:
ggplot(data = faithful) +
  geom_point(mapping = aes(x=eruptions, y=waiting))
#notice the two clusters

#If we want to explore the relationship between cut and price, we'd need to control for carat.
#We can regress price against carats, then examine the residuals grouped by cut:

library(modelr) #this package described in last section of the book

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>%
  add_residuals(mod) %>% #adds residuals to the data frame
  mutate(resid = exp(resid))

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))

#now we've removed the impact of carats, so we can see the impact of cut:
ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))
#nnow we see higher cut quality leads to higher price!


#**************************************************************
#7.7: ggplot2 calls *****************************
#**************************************************************
#We can write teh previous plot more concisely:
ggplot(diamonds2, aes(cut, resid)) +
  geom_boxplot()

#**************************************************************
#7.8: Learning more *****************************
#**************************************************************
#Id highly recommend grabbing a copy of the ggplot2 book: https://amzn.com/331924275X. 
#Its been recently updated, so it includes dplyr and tidyr code.

#Another useful resource is the R Graphics Cookbook by Winston Chang. 
#Much of the contents are available online at http://www.cookbook-r.com/Graphs/

#I also recommend Graphical Data Analysis with R, by Antony Unwin. 


#**************************************************************
#8: Workflow: Projects *****************************
#**************************************************************


#**************************************************************
#8.1: What is real? *****************************
#**************************************************************
#Press Ctrl + Shift + F10 to restart R Studio
#press Ctrl + Shift + S to re-run the current script

#**************************************************************
#8.2: Where does your analysis live? *****************************
#**************************************************************
#You can find out your current workimg directory by typing getwd()


#**************************************************************
#8.3: Paths & Directories *****************************
#**************************************************************
#Better to uss forward slashes in directpry paths; if use backslash, you need 2
#Should not use absoluge paths since no one you share with will have the samedirectory structure


#**************************************************************
#8.4: RStudio Projects *****************************
#**************************************************************
getwd()

library(tidyverse)

ggplot(diamonds, aes(carat, price)) + 
  geom_hex()
ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")


#**************************************************************
#8.5: Summary *****************************
#**************************************************************




















