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
- [R-Bloggers articles featuring Shiny apps](http://www.r-bloggers.com/?s=shiny)


## 'Bones' of a Shiny App

At minimum, a Shiny app has two components:

- ui.R
- server.R

You can think of these as holding the form (ui.R) and function (server.R) of the app. It is possible to [create single file apps](http://shiny.rstudio.com/articles/single-file.html) but for the sake of clarity, we'll keep the scripts separate. Note that you must name the scripts accordingly – in other words, you can't have a ui script called my_ui.R or appui.R or youi.R ... it has to be ui.R and ditto for server.R

There are a couple ways to build out the skeleton of your first Shiny project. You could find the code for an app that you want to mimic and use that as a baseline for your ui.R and server.R scripts. But that copy-and-paste workflow can be tedious, error-prone and unnecessary if you're using RStudio ... 

Like we mentioned above, Shiny is developed by RStudio. So it's no suprise that the RStudio IDE has some Shiny-related features. In particular, the Shiny project structure makes it really easy to spin up app templates. To use this feature:

1. Create a new project in RStudio (either in a new directory or existing directory)
2. Select Shiny app and give it a name.

This will create a ui.R, server.R and .Rproj file (which is useful for maintaining a relative file structure when you're working on your app ...) all in the directory you've specified.

## Scratch

The server.R script does the "work" for your Shiny app. Functionally you can do anything in a server.R script that you can in a regular R script. The only difference is that the parameter(s) you pass can into that R code can be set by a user via input widgets. 

So before you sink a bunch of time into creating an app that passes the parameters _dynamically_, you probably want to test that they work _statically_. One way to do this is to create a "scratch" script – this will be a place for you to get your code working with a single input. Once it's working here, you can figure out which pieces you'd like to dynamically change within the ui.R script.

And it's worth pointing out that creating another file with a ".R" extension in the same directory as your ui.R and server.R files won't cause any conflicts.

```
# load reentrez package for pubmed query
library(rentrez)

# specify author
author <- "Gawande AA"

# build query string
myterm <- paste(author, "[Author]", sep="")

# run query
q <- entrez_search("pubmed", myterm, retmax = 9999)

# check that it worked
q$ids
q$count

# make a data frame out of the author and count
df <- data.frame(Author=author, Total.Publications = as.numeric(q$count))

# specify another author
author2 <- "Oz MC"

# build another query string
myterm2 <- paste(author2, "[Author]", sep="")

# run another query
q2 <- entrez_search("pubmed", myterm2, retmax = 9999)

# make another data frame out of the author and count
df2 <- data.frame(Author=author2, Total.Publications = as.numeric(q2$count))

# combine the two data frames
combo_df <- rbind(df,df2)

# load ggplot2 for viz
library(ggplot2)

# make a barplot of publication counts by authors
g <- 
    ggplot(combo_df, aes(x=Author, y=Total.Publications)) +
    geom_bar(stat = "identity") +
    ggtitle("Pubmed Publication Authorship Comparison")
g

```

## Layouts

The code you've written will be the basis of your server.R script. Before you can implement that, you need to make some decisions about layout. As a default, shiny uses the Bootstrap grid system. You can customize this to include sidebars, navbars, columns and more. All of the layout is handled within the ui.R file.

ui.R is a essentially a collection of nested functions ... that's why the code can be kind of hard to look at. The baseline function is ```shinyUI()```

Within that you can specify if you want your layout to be a ```fluidPage()``` (the default if you're using a template from RStudio), ```navbarPage()``` (as the name suggests, helpful for creating naviagtion) or ```fixedPage()``` (not recommended ... "breaks" the bootstrap).

Nested further, you can include sub layout regions like ```sidebarLayout()``` and ```fluidRow```.

And even _further_ you can nest individual elements with ```tabPanel()``` or ```sidebarPanel()``` or ```column()``` functions.

We'll stick with default sidebar layout that RStudio gives us. But you can refer to the [Shiny Application layout guide](http://shiny.rstudio.com/articles/layout-guide.html) for more advanced configurations.

```
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

    ),

    # Show a plot of the generated distribution
    mainPanel(
    )
  )
))

```

## 'Hello Widget'

You've got the "scratch" code doing what you want it to. And you've got the basic idea of what the layout will be.

But now what?

You need to decide what parameter you want to make dynamic – in other words, what variable do you want your users to be able to adjust to see how the results change. The class of this object will determine what kind of widget you'll start with. For example, if you have a continuous (numeric) variable then you may want to use a slider input or input box. On the other hand, if you have a discrete (factor) variable then you might need to use a select input or checkbox. There are [a lot of widgets](http://shiny.rstudio.com/gallery/widget-gallery.html) to choose from and a lot of ways you can use them.

Once you've decided what input method use you'll need to write the code for that widget in the ui.R script. Widgets can go inside any of the layout elements. 

Every widget needs a name – this is a semi-arbitrary distinction you can make with the first, inputId argument to the widget function. Although you can freely name the widget, it's only semi-arbitrary because it the inputId must be unique (not used by another widget) and should be somewhat meaningful as you'll be calling the widget in the server.R script as well.

```
library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Pubmed Publication Authorship"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "author1",
                        label = "First Author",
                        choices = "Gawande AA"),   
            selectInput(inputId = "author2",
                        label = "Second Author",
                        choices = "Oz MC")
        ),
        
        mainPanel(
            plotOutput("comparison")
        )
    )
))

```

## ;,})!

This is as good a place as any to stop and make a few comments about Shiny's syntax.

If you're not careful you can get mystified pretty easily while writing your app ... and / or spend way too much time looking for a missing comma or extra parenthesis. Debugging these syntactic errors can be a bigger headache in a Shiny app than it is an regular R script.

Fortunately, RStudio is pretty good about highlighting breaks in code syntax. With all the nested functions in the ui.R script, it's important to look out for any open parentheses. Another tip is to remember that UI elements are each arguments to functions – as such, they're separated by commas.

The server.R script has a slightly different syntax. It always starts with something like ```shinyServer(function(input, output) {``` and ends with ```})``` to close out that outermost function. Because the code inside of that first ```{``` is being defined as part of a function (and not a series of arguments) you don't need to use commas while separating objects. You will need to use the ```({``` while calling render functions for the output.

These are just a few basic tips but they might save you a headache or two, especially at the beginning. 

## server.R






