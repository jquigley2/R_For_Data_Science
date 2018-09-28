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
#Chunks can be names via an option:  ```{r by-name}
#Three advantages of naming:
  #1. Can easily navigate to chunks using the drop-down code navigate at lower left of script editor window
  #2. Graphics produced by chunks will have clearer names, so they can easily be used elsewhere
  #3. Can setup networks of cached chunks to avoid re-performing expensive computations on every run.

#The chunk named "setup" will run automatically one before anything else.


#27.4.2: ******************************* Chunk Options
#Chunk output can be customized with options - arguments supplied to chunk header.
#Knitr provides about 60 options.  See the full list at http://yihui.name/knitr/options/

#The most important set of options controls whether the code block executes and which results insert into the finished report.
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



#27.4.5: ******************************* Global Options



#27.4.6: ******************************* Inline Code



#27.4.7: ******************************* Exercises



#27.5: ******************************* Troubleshooting



#27.6: ******************************* YAML header



#27.7: ******************************* Learning More



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