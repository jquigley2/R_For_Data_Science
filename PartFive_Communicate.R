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



#28.2: ******************************* Label



#28.3: ******************************* Annotations



#28.4: ******************************* Scales



#28.5: ******************************* Zooming



#28.6: ******************************* Themes



#28.7: ******************************* Saving Plots



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