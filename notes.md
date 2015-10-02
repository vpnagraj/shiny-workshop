# Building ‘Shiny’ Web Applications In R

*Shiny is a framework for developing interactive, web-based tools with R. This workshop will cover how to create a basic user interface, add reactive widgets and publish a Shiny app. No web development experience is required. Some familiarity with R will be helpful.*

## Introduction

Shiny is a light-weight web application framework. What does that mean? 

Shiny might be the right tool if:

- You want to execute R code dynamically based on user input

You might be better off using something other than Shiny if:

- You need to create a website with lots of users
- You need to create a native mobile app


It's built to run code written in R, and is maintained by RStudio. There's really robust documentation and plenty of resources both for beginners and advanced Shiny developers:

- [Tutorial for those new to Shiny](http://shiny.rstudio.com/tutorial/)
- [Collection of posts covering the basics of layout, reactivity and extensions for Shiny](http://shiny.rstudio.com/articles/)
- [RStudio 'cheatsheet' for Shiny](https://www.rstudio.com/wp-content/uploads/2015/02/shiny-cheatsheet.pdf)
- [R-Bloggers regularly features new Shiny apps](http://www.r-bloggers.com/?s=shiny)


## 'Bones' of a Shiny App

A Shiny app has two components:

- ui.R
- server.R

You can think of these as holding the form (ui.R) and function (server.R) of the app. It is [possible to create single file apps](http://shiny.rstudio.com/articles/single-file.html) but for this workshop we'll keep the scripts separate. And note that you must name the scripts accordingly – in other words, you can't have a ui script called my_ui.R ... it has to be ui.R and ditto for server.R

There are a couple ways to build out the skeleton of your first Shiny undertaking. You could find the code for an app that you want to emulate and use that as a baseline for your ui.R and server.R scripts. But that copy-and-paste workflow can be tedious and error-prone. RStudio offers an easier method than that ... 

Like we mentioned above, Shiny is developed by RStudio. So it's no suprise that the RStudio IDE has some Shiny-related features. In particular, the Shiny project structure makes it really easy to spin up app templates. To use this feature, create a new project in RStudio (either in a new directory or existing directory), select Shiny app and give it a name. This will create a ui.R, server.R and .Rproj file (which is useful for maintaining a relative file structure when you're working on your app ...) all in the directory you've specified.





