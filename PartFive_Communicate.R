###############################################################
#PART 5: Communicate
###############################################################
#26: ******************************* Introduction *****************************

#27: ******************************* R Markdown  *****************************
#27.1: ******************************* Introduction 
#A unified framework for data science, combining code, result, and prose commentary.
#Markdown documents are reproducible and support output formats including Word, PPT, etc...
#Designed to be used in 3 ways:
  #1. For communicating to decision makers, who want to focus on the conclusions, not the code behind the analysis.
  
  #2. For collaborating with other data scientists (including future you!), who are interested in both 
  #your conclusions, and how you reached them ( i.e. the code).
  
  #3. As an environment in which to do data science, as a modern day lab notebook where you can 
  #capture not only what you did, but also what you were thinking.

  #For troubleshooting & learning more:
#R Markdown Cheat Sheet: Help > Cheatsheets > R Markdown Cheat Sheet,
#R Markdown Reference Guide: Help > Cheatsheets > R Markdown Reference Guide.

#27.1.1: ******************************* Prerequisites 
#RStudio automatically installs and loads rmarkdown when neeeded


#27.2: ******************************* R Markdown Basics
#Markdown documents contain 3 types of content:
  #1. An optional YAML header surrounded by ---
  #2. Chunks of R code surrounded by ````
  #3. Text with simple text formatting such as #heading and _italics_

#When we open an .Rmd, we see a notebook interface with code and output interwoven.
#Run code chunks by clicking on the run icon.  RStudio executes and displays results inline with code.

#To produce a complete report containing all text, code, and reults, press "Knit".
#This displays the report in the viewer pane, and creates a self-contained HTML for sharing.

#When we knit, R Markdown sends the .Rmd file to knitr, http://yihui.name/knitr/>
#This executes all code chunks, and creates a new markdown .md document including the code & its output.

#The .md is then processed by pandoc, http://pandoc.org/, which creates the finished file.


#27.2.1: ******************************* Exercises
#1. Create a new notebook using File > New File > R Notebook. Read the instructions. 
#Practice running the chunks. 
#Verify that you can modify the code, re-run it, and see modified output.

#2. Create a new R Markdown document with File > New File > R Markdown??? 
#Knit it by clicking the appropriate button. 
#Knit it by using the appropriate keyboard short cut. 
#Verify that you can modify the input and see the output update.

#3. Compare and contrast the R notebook and R markdown files you created above. 
#How are the outputs similar? #How are they different? 
#How are the inputs similar? How are they different? 
#What happens if you copy the YAML header from one to the other?

#4. Create one new R Markdown document for each of the three built-in formats: HTML, PDF and Word. 
#Knit each of the three documents. How does the output differ? How does the input differ? 


#27.3: ******************************* Text Formatting with Markdown
#Prose in .Rmd files is written in Markdown, which is a lightweight set of conventions for formatting plain text files.
#Here's a guide to using Pandoc's Markdown:  
#http://r4ds.had.co.nz/r-markdown.html#text-formatting-with-markdown
#Can also refer to Help>Markdown Quick Reference



#27.3.1: ******************************* Exercises
#1. Practice what you???ve learned by creating a brief CV. The title should be your name, and you should 
#include headings for (at least) education or employment. Each of the sections should include a bulleted 
#list of jobs/degrees. Highlight the year in bold.

#2. Using the R Markdown quick reference, figure out how to:
#Add a footnote.
#Add a horizontal rule.
#Add a block quote.

#3. Copy and paste the contents of diamond-sizes.Rmd from 
#https://github.com/hadley/r4ds/tree/master/rmarkdown in to a local R markdown document. 
#Check that you can run it, then add text after the frequency polygon that describes its most 
#striking features.


#27.4: ******************************* Code Chunks
#Three ways to insert R code chunks insode an RMarkdown document:

  #1. Best is the keyboard shortcut: Ctrl + Alt + I
  #2. The "Insert" button in the editor bar
  #3. Manually typing the chunk delimiters  ```{r} and ```.

#Ctrl + Enter will run the code.  
#Ctrl + Shift + Enter will run just the chunk


#27.4.1: ******************************* Chunk Name
#Chunks can be named via an option:  ```{r by-name}
#Best to name chanunks aftr the primary object it's creating.
#Three advantages of naming:
  #1. Can easily navigate to chunks using the drop-down code navigate at lower left of script editor window
  #2. Graphics produced by chunks will have clearer names, so they can easily be used elsewhere
  #3. Can setup networks of cached chunks to avoid re-performing expensive computations on every run.

#The chunk named "setup" will run automatically one before anything else.


#27.4.2: ******************************* Chunk Options
#Chunk output can be customized with options - arguments supplied to chunk header.
#Knitr provides about 60 options.  See the full list at http://yihui.name/knitr/options/

#The most important set of options controls whether the code block executes and which results insert 
#into the finished report.

  #eval = FALSE prevents code from being executed.  Useful for displaying sample code or disabling a large block.
  #include = FALSE runs the code, but doesn't show the code or results in the final document.
  #message = FALSE or warning = FALSE prevents messages or warnings from appearing in the final file.
  #results = 'hide' hides printouts
  #fig.show = 'hide' hides plots 
  #error = TRUE causes the render to continue even if there's an error - useful if you need to debug your .Rmd.

#27.4.3: ******************************* Table
#By default, RMd prints data frames and matrices as you'd see them in the console:
mtcars[1:5, ]

#If you prefer the data be displayed with additional formatting, use the knitr::kable function.
knitr::kable(
  mtcars[1:5, ], 
  caption = "A knitr kable."
)

#?knitr::kable to see the other ways in which you can customise the table. 
#For even deeper customization, consider the xtable, stargazer, pander, tables, and ascii packages.

#27.4.4: ******************************* Caching
#Each knit of a document starts from scratch by default, which can be painful if you have heavy compute embedded.
#Use cache=TRUE to save the output of the chunk to a special file on disk; if the code doesn't change,
#knitr will use the cached results.

#Use caching with care; by default, it's based on the code only, not its dependencies.  For example,
#here, the processed_data chunk depends on the raw_data chunk:
```{r raw_data}
rawdata <- readr::read_csv("a_very_large_file.csv")
```

```{r processed_data, cache = TRUE}
processed_data <- rawdata %>% 
  filter(!is.na(import_var)) %>% 
  mutate(new_variable = complicated_transformation(x, y, z))
```
#Caching the processed_data means it'll get re-run if the dplyr pipeline is changed, but not if read_csv() changes 

#Avoid this problem with the "dependson" chunk option:
```{r processed_data, cache = TRUE, dependson = "raw_data"}
processed_data <- rawdata %>% 
  filter(!is.na(import_var)) %>% 
  mutate(new_variable = complicated_transformation(x, y, z))
```
#dependson should contain a character vector of every chunk the cached chunk depends on.  Knitr will 
#update the results whenevrer it detects one of the dependencies has changed.

#Note: the chunks won't update if the contents of "a_very_large_file.csv" change; knitr only tracks changes
#within the .Rmd file.

#HOWEVER, if you want to also track changes in that source file, use the "cache.extra" option.
#This invalidates the cache whenever it changes.  

#Another good function is file.info() ; it returns info abou the file, including when it was last modified.
#Together, we can write:
```{r raw_data, cache.extra = file.info("a_very_large_file.csv")}
rawdata <- readr::read_csv("a_very_large_file.csv")
```
#Clear out all of the caches with knitr::clean_cache().


#27.4.5: ******************************* Global Options
#Can change default chunk chunk options by calling knitr::opts_chunk$set() in a chunk code.

#For example, you could set the preferred comment formatting:
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE
)

#or, to hide code by default:
knitr::opts_chunk$set(
  echo = FALSE
)
#You'd then have to type echo = TRUE for chunks where you want to display the code.


#27.4.6: ******************************* Inline Code
#Another way to embed R code into a markdown document: directly into the text, with `r`.
#THis is useful when metoning properties of the data in the text.  For example:
 
We have data about `r nrow(diamonds)` diamonds. Only `r nrow(diamonds) - nrow(smaller)` 
are larger than 2.5 carats. The distribution of the remainder is shown below:

#When the report is knit, the results of the R code are inserted into the text.
  
#When inserting numbers like this, use format() to set the number of digits, and "big.mark" to make 
#numbers easier to read.  It's useful to combine these in a helper function:
  
comma <- function(x) format(x, digits = 2, big.mark = ",")
comma(3452345)
  
  
#27.4.7: ******************************* Exercises
#1. Add a section that explores how diamond sizes vary by cut, color, and clarity. 
#Assume you???re writing a report for someone who doesn???t know R, and instead of 
#setting echo = FALSE on each chunk, set a global option.

#2. Download diamond-sizes.Rmd from https://github.com/hadley/r4ds/tree/master/rmarkdown. 
#Add a section that describes the largest 20 diamonds, including a table that displays 
#their most important attributes.

#3. Modify diamonds-sizes.Rmd to use comma() to produce nicely formatted output. 
#Also include the percentage of diamonds that are larger than 2.5 carats.

#4. Set up a network of chunks where d depends on c and b, and both b and c depend on a. 
#Have each chunk print lubridate::now(), set cache = TRUE, then verify your understanding of caching.


#27.5: ******************************* Troubleshooting
#Troubleshooting a Markdown doc is more challenging, since we're not in an interactive session. Some tips:

#Try to recreate in an interactive session.


#27.6: ******************************* YAML header
#Tweaking the parameters of the YAML (yet another markup language) header allows us to control many
#other while document settings.  Below are details on 2:


#27.6.1: ******************************* Parameters
#Parameters are useful when re-rendering the same report with distinct values for various key inputs.
#For example, producing a sales report by branch, exam results by student, or demographic summaries by country.
#Use the "params" field to declare one or more parameters.

#Example.  This uses a my_class parameter to determine which class of cars to display:
---
  output: html_document
params:
  my_class: "compact"
---
  
  ```{r setup, include = FALSE}
library(ggplot2)
library(dplyr)

class <- mpg %>% filter(class == params$my_class)
```

# Fuel economy for `r params$my_class`s

```{r, message = FALSE}
ggplot(class, aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
```
#Can write atomic vectors directly into the YAML header.  Can also run arbitrary R expressions
#by prefacing the parameter value with !r.  This is good for specifying data/time parameters:
params:
  start: !r lubridate::ymd("2015-01-01")
  snapshot: !r lubridate::ymd_hms("2015-01-01 12:30:00")

#Click "Knit with Parameters" in the knitr dropdown menu to set parameters, render and preview report.
  
#Customize the dialogue by setting other options inthe header:
  # http://rmarkdown.rstudio.com/developer_parameterized_reports.html#parameter_user_interfaces
  
#If we need to produce many parameterized reports, call rmarkdown::render() with a list of params:
rmarkdown::render("fuel-economy.Rmd", params = list(my_class = "suv"))
    
#This setup is particularly powerful when used with purrr::pwalk().  
#The next example creates a report for each value of class found in mpg. 
#First, create a data frame which has one row for each class, giving the filename of the report and the params:
reports <- tibble(
  class = unique(mpg$class),
  filename = stringr::str_c("fuel-economy-", class, ".html"),
  params = purrr::map(class, ~ list(my_class = .))
)

reports

#Then, match the column names to the argument names of render(), and use purrr's parallel walk to call
#render() once for each row:
reports %>% 
  select(output_file = filename, params) %>% 
  purrr::pwalk(rmarkdown::render, input = "fuel-economy.Rmd")


#27.6.2: ******************************* Bibliographies & Citations
#Pandoc cab generate citations and bibliography in several styles.
#To use, specify a bibliography file by using the bibliograhy field in the file's header.
#The file should contain a path from the directory that contains the .Rmd file to the file with the bibliography file:

bibliography: rmarkdown.bib

#To create a citation within the .Rmd file, use a key composed of @ + the citation identifier from the bibliography file.
#Place the citation in square brackets.  For example:
# Separate multiple citations with a `;`: Blah blah [@smith04; @doe99].
# 
# You can add arbitrary comments inside the square brackets: 
#   Blah blah [see @doe99, pp. 33-35; also @smith04, ch. 1].
# 
# Remove the square brackets to create an in-text citation: @smith04 
# says blah, or @smith04 [p. 33] says blah.
# 
# Add a `-` before the citation to suppress the author's name: 
# Smith says blah [-@smith04].

#When R Markdown renders the file, it will build and append a bibliography, which will contain all cited 
#references, but no section heading.  It's common to # References or # Bibliography.

#Reference a CSL (citation style language) file in the "csl" field to change the style of the citations:
bibliography: rmarkdown.bib
csl: apa.csl

#Common bibliography styles found here: http://github.com/citation-style-language/styles


#27.7: ******************************* Learning More
#The best place to stay on top of innovations is the official R Markdown website: 
#http://rmarkdown.rstudio.com

#We recommend two free resources that will teach you about Git:

#???Happy Git with R???: a user friendly introduction to Git and GitHub from R users, by Jenny Bryan. 
#The book is freely available online: http://happygitwithr.com

#The ???Git and GitHub??? chapter of R Packages, by Hadley. 
#You can also read it for free online: http://r-pkgs.had.co.nz/git.html.



#28: ******************************* Graphics for Communication *****************************
#28.1: ******************************* Introduction
#28.1.1: ***************************** Prerequisites
#Rather than loading ggplot2 extensions from packages such as ggrepel and viridis here, we'll refer to their functions
#explicitly, via :: notation.
library(tidyverse)


#28.2: ******************************* Label
#Easiest way to start turning exploratory into expository graphics is via good labeling:

#add a title:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel Efficiency generally decreases with engine size:")

#Use the title to explain the findings, not just what's in the plot.
#Two additional labels:
  #subtitle - adds additional detail in smaller font
  #caption - adds text at the bottom right of the plot - great for noting source of data

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel Efficiency generally decreases with engine size...",
       subtitle = "with the exception of 2 seaters (due to their light weight)",
       caption = "data from fueleconomy.gov")

#Use labs() to replace the axis and legend titles, using more detailed variable names with units:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel Efficiency generally decreases with engine size...",
       subtitle = "with the exception of 2 seaters (due to their light weight)",
       caption = "data from fueleconomy.gov",
       x = "Engine Displacement (litres)", 
       y = "Hwy Fuel Economy (mpg)", 
       color = "Car Type")

#Can use mathematical equations instead of text strings; just switch out "" for quote().
#Read about the available options in 
?plotmath

#generate a df:
df <- tibble(
  x = runif(10),
  y = runif(10)
)

#plot the df:
ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
  )

#28.2.1: ******************************* Exercises
#1. Create one plot on the fuel economy data with customized title, subtitle, caption, x, y, and colour labels.

#2. The geom_smooth() is somewhat misleading because the hwy for large engines is skewed upwards due to 
#the inclusion of lightweight sports cars with big engines. 
#Use your modelling tools to fit and display a better model.

#3. Take an exploratory graphic that you???ve created in the last month, and add informative titles to make it easier for others to understand.



#28.3: ******************************* Annotations
#it's often useful to label individual observations or groups of observations.
#geom_text() is the first tool to try.

#Two possible sources of labels:
  #1. You may have a tibble which provides labels.  Here, we pull out the most efficient car in each class 
  #with dplyr, then label it on the plot:

best_in_class <- mpg %>%
  group_by(class)%>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)
#hard to read!

#Switching to geom_label() draws a rectangle behind the text, which makes this easier to read, and...
#we use nudge_y parameter to move the labels slightly above the corresponding points:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5)
#New Beetle and Jetta are still on top of each other...

#Use ggrepel to adjust labels and prevent overlap:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) + #adds a second layer of large, hollow points
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

#If we want a single label in the upper righthand corner of the plot, we can create a new df using summarize()
#to compute the max values of x and y to determine positioning:
label <- mpg %>%
  summarise(
    displ = max(displ), 
    hwy = max(hwy),
    label = "Increasing engine size is \nrelated to decreasing fuel economy." #use \n to break the text line
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")

#If you want the text right on the borders, use +Inf and -Inf:
label <- tibble(
  displ = Inf,
  hwy = Inf,
  label = "Increasing engine size is \nrelated to decreasing fuel economy."
) 

ggplot(mpg, aes(displ, hwy)) +
  geom_point() + 
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")

#hjust can take left, center or right, and vjust can take top, center, or bottom  

#Can also use stringr::str_wrap() to automatically add line breaks, given the number of characters you want per line:
"Increasing engine size is related to decreasing fuel economy." %>%
  stringr::str_wrap(width = 40) %>%
  writeLines()

#In addition to geom_text, there are many other geoms available to annotate the plots:

  #geom_hline() and geom_vline() add reference lines.  Can make them thick (size = 2) and white (color = white),
  #and lay them in under the plot.

  #use geom_rect() to draw a rectangle around points of interest.  Set the perimter via xmin, xmax, ymin, ymax

  #geom_segment() with the "arrow" argument to draw attention to a point with an arrow.  Use aesthetics x and y 
  #to map starting point, and xend and yend to define the end location


#28.3.1: ******************************* Exercises
#1. Use geom_text() with infinite positions to place text at the four corners of the plot.

#2. Read the documentation for annotate(). How can you use it to add a text label to a plot without 
#having to create a tibble?
  
#3. How do labels with geom_text() interact with faceting? 
#How can you add a label to a single facet? 
#How can you put a different label in each facet? (Hint: think about the underlying data.)

#4. What arguments to geom_label() control the appearance of the background box?
  
#5. What are the four arguments to arrow()? How do they work? 
#Create a series of plots that demonstrate the most important options.


#28.4: ******************************* Scales
#3rd way to improve plots for communication is adjusting the scales.
#ggplot2 automatically adds scales.  For example:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class))

#ggplot2 automatically adds scales behind the scenes:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color=class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()
#Note the naming scheme for scales:
  #scale_ followed by name of aesthetic, then _, then name of scale.
  #Default scales are:
    #continuous
    #discrete
    #datetime
    #date
#There are many non-default scales as well.


#28.4.1: ******************************* Axis Ticks & Legend Keys
#"breaks" and "labels" are the two primary ways to affect the appearance of ticks on the axes and keys.
#Breaks control the position of the ticks
#Labels control the text label associated with each tick/key

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) #min, max, by

#Use labels the same way, or set to null to suppress the labels altogether:
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

#Breaks and labels can also control the appearance of legends.  Collectively,
#breaks and legends are called GUIDES.
#Axes are used for x and y aesthetics; legends are used for everything else.

#breaks can also be used when we have few data points and want to highlight the 
#exact start and end dates of the observations:
presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(start, id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(NULL, breaks = presidential$start, date_labels = "'%y")
#The specs of breaks and labels for date and datetime scales are a bit different:
  #date_labels take a format specification, in the same from as parse_datetime().
  #date_breaks (not shown) take a string like "2 days" or 1 Month".


#28.4.2: ******************************* Legend Layout
#There are better ways to tweak legends than breaks and labels.

#To control the overall position of the legend, use a theme() setting.  
#Themes control the non-data portion of the plots.
#"legend.position" controls where the legend is drawn:
base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class))

base + theme(legend.position = "left")
base + theme(legend.position = "top")
base + theme(legend.position = "bottom")
base + theme(legend.position = "right") #the default
#Or, use legend.position = "none" to suppress the legend display.

#Control the individual legends by using guides() along with guide_legend() or guide_colorbar().

#This example shows how to control the # of rows via nrow, and how to override an aesthetic to make the points bigger.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 1, override.aes = list(size = 4)))


#28.4.3: ******************************* Replacing a Scale
#Two types of scales most commonly switched out are continuous position scales and color scales.

#Example:
#As described earlier, we can better see the relation between carats and price if we log xform the variables:
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

#However, now the axes are labeled with xformed values, which are hard to interpret.
#We can xform the axes to the original form:
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10()

#Color scale is also often customized, say to the Color Brewer scale, which is geared to address color blindness.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

#using color brewer:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1") #http://colorbrewer2.org/ 

#A simpler technique is adding a redundant shape mapping:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

#You may have a pre-defined color mapping, say Blue for Dems, Red for Republicans:
presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(start, id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "red", Democratic = "blue"))

#Or, for continuous color, use the built-in scale_color_gradient() or scale_fill_gradient().
#If you have a diverging scale, use scale_color_gradient2 (you can give positive values different 
#colors than you give negative values, or distinguish above vs. below mean).

#Another option is scale_color_viridis() from the viridis package.This gives a continuous analog of
#the ColorBrewer scales.  An example:
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x,y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()


#28.4.4: ******************************* Exercises 
#1. Why doesn???t the following code override the default scale?
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_colour_gradient(low = "white", high = "red") +
  coord_fixed()

#2. What is the first argument to every scale? How does it compare to labs()?
  
#3. Change the display of the presidential terms by:
  
  #a. Combining the two variants shown above.
  #b. Improving the display of the y axis.  
  #c. Labelling each term with the name of the president.
  #d. Adding informative plot labels.
  #e. Placing breaks every 4 years (this is trickier than it seems!).

#4. Use override.aes to make the legend on the following plot easier to see:
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = cut), alpha = 1/20)



#28.5: ******************************* Zooming
#Three ways to control plot limits:
  #1. Adjust what data are plotted
  #2. Set the limits in each scale
  #3. Setting xlim and ylim in coord_cartesian()

#To zoom into one region, it's best to use coord_cartesian():

ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5,7), ylim = c(10, 30))

mpg %>% 
  filter(displ >= 5, displ <= 7, hwy >10, hwy <=30) %>% 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()




#28.6: ******************************* Themes
                               


#28.7: ******************************* Saving Plots



#28.7.1: ******************************* Figure Sizing



#28.7.2: ******************************* Other Important Options



#28.8: ******************************* Learning More



#29: ******************************* R Markdown formats *****************************
#29.1: ******************************* Introduction



#29.2: ******************************* Output Options



#29.3: ******************************* Documents



#29.4: ******************************* Notebooks



#29.5: ******************************* Presentations



#29.6: ******************************* Dashboards



#29.7: ******************************* Interactitivty



#29.8: ******************************* Websites



#29.9: ******************************* Other formats



#29.10: ******************************* Learning More


#30: ******************************* R Markdown Workflow *****************************