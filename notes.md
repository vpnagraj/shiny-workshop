# Building ‘Shiny’ Web Applications In R

> Shiny is a framework for developing interactive, web-based tools with R. This workshop will cover how to create a basic user interface, add reactive widgets and publish a Shiny app. No web development experience is required. Some familiarity with R will be helpful.

## Introduction

Shiny is a light-weight web application framework for interactive data exploration. 

What does that mean? 

It means that Shiny was built to execute R code dynamically based on user input. That's it.

If you're trying to create a "heavy" website (e.g. lots of users, complex database structure, etc.) or a native mobile app (like the kind you install on your iThing ... ), then you should probably look elsewhere.

Shiny is built to run code written in R, and it can showcase any of the computational power R is capable of.

It's maintained by RStudio, and there's robust documentation and resources for both beginners and advanced Shiny developers:

- [Tutorial for those new to Shiny](http://shiny.rstudio.com/tutorial/)
- [Collection of posts covering the basics of layout, reactivity and extensions for Shiny](http://shiny.rstudio.com/articles/)
- [RStudio 'cheatsheet' for Shiny](https://www.rstudio.com/wp-content/uploads/2015/02/shiny-cheatsheet.pdf)
- [R-Bloggers articles featuring Shiny apps](http://www.r-bloggers.com/?s=shiny)
- [RStudio webinar slides for getting started with Shiny](https://github.com/rstudio/webinars)

## 'Bones' of a Shiny App

At minimum, a Shiny app has two components:

- ui.R
- server.R

You can think of these as holding the form (ui.R) and function (server.R) of the app. It is possible to [create single file apps](http://shiny.rstudio.com/articles/single-file.html) but for the sake of clarity, we'll keep the scripts separate. Note that you must name the scripts accordingly – in other words, you can't have a ui script called my_ui.R or appui.R or youi.R ... it has to be ui.R and ditto for server.R

There are a couple ways to build out the skeleton of your first Shiny project. You could find the code for an app that you want to mimic and use that as a baseline for your ui.R and server.R scripts. But that copy-and-paste workflow can be tedious, error-prone and unnecessary if you're using RStudio ... 

Like we mentioned above, Shiny is developed by RStudio. So it's no suprise that the RStudio IDE has some Shiny-related features. In particular, the Shiny project structure makes it really easy to spin up app templates. To use this feature:

1. Create a new project in RStudio (either in a new directory or existing directory)
2. Select Shiny app and give it a name

This will create a ui.R, server.R and .Rproj file (which is useful for maintaining a relative file structure when you're working on your app ...) all in the directory you've specified.

## Scratch

The server.R script does the "work" for your Shiny app. Functionally you can do anything in a server.R script that you can in a regular R script. The only difference is that the parameter(s) you pass into that R code can be set by a user via input widgets. 

So before you sink a bunch of time into creating an app that passes the parameters _dynamically_, you probably want to test that they work _statically_. One way to do this is to create a "scratch" script – this will be a place for you to get your code working with a single input. Once it's working here, you can figure out which pieces you'd like to dynamically change within the ui.R script.

And it's worth pointing out that creating another file with a ".R" extension in the same directory as your ui.R and server.R files won't cause any conflicts.

```R
# install.packages("rentrez")
library(rentrez)

# install.packages("ggplot2")
library(ggplot2)

# install.packages("highcharter")
library(highcharter)

pubs <- entrez_search(db = "pubmed", term = "zika AND (2016[PDAT])")

pubs$count

pubcount <- function(year,term) {
    
    query <- paste(term, "AND (", year, "[PDAT])")
    entrez_search(query, db = "pubmed")$count
}

pubcount(2016,"zika")

year <- 2006:2016
year

pubs <- sapply(year, pubcount, term = "zika")

df <- data.frame(year, pubs)
df

ggplot(df, aes(year, pubs)) +
    geom_line()

hchart(df, "line", x = year, y  = pubs)
```

## Layouts

The code you've written will be the basis of your server.R script. Before you can implement that, you need to make some decisions about layout. As a default, Shiny uses the Bootstrap grid system. You can customize this to include sidebars, navbars, columns and more. All of the layout is handled within the ui.R file.

ui.R is a essentially a collection of nested functions ... that's why the code can be kind of hard to look at. The baseline function is ```shinyUI()```

Within that you can specify if you want your layout to be a ```fluidPage()``` (the default if you're using a template from RStudio), ```navbarPage()``` (as the name suggests, helpful for creating naviagtion) or ```fixedPage()``` (not recommended ... "breaks" the bootstrap).

Nested further, you can include sub layout regions like ```sidebarLayout()``` and ```fluidRow```.

And even _further_ you can nest individual elements with ```tabPanel()``` or ```sidebarPanel()``` or ```column()``` functions.

We'll stick with default sidebar layout that RStudio gives us. But you can refer to the [Shiny Application layout guide](http://shiny.rstudio.com/articles/layout-guide.html) for more advanced configurations.

```R
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

## Input / Output

You've got the "scratch" code doing what you want it to. And you've got the basic idea of what the layout will be.

But now what?

You need to decide what parameter you want to make dynamic – in other words, what variable do you want your users to be able to adjust to see how the results change. The class of this object will determine what kind of widget you'll start with. For example, if you have a continuous (numeric) variable then you may want to use a slider input or input box. On the other hand, if you have a discrete (factor) variable then you might need to use a select input or checkbox. There are [a lot of widgets](http://shiny.rstudio.com/gallery/widget-gallery.html) to choose from and a lot of ways you can use them.

Once you've decided what input method use you'll need to write the code for that widget in the ui.R script. Widgets can go inside any of the layout elements. 

Every widget needs a name – this is a semi-arbitrary distinction you can make with the first, inputId argument to the widget function. Although you can freely name the widget, it's only semi-arbitrary because it the inputId must be unique (not used by another widget) and should be somewhat meaningful as you'll be calling the widget in the server.R script as well.

```R
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("PUBPOP"),

  sidebarLayout(
    sidebarPanel(
        textInput("term", label = "pubmed search term", value = "zika")
    ),

    mainPanel(
        plotOutput("yearplot")
    )
  )
))
```

## Syntax / Punctuation

This is as good a place as any to stop and make a few comments about Shiny's syntax.

If you're not careful you can get mystified pretty easily while writing your app ... and / or spend way too much time looking for a missing comma or extra parenthesis. Debugging these syntactic errors can be a bigger headache in a Shiny app than it is an regular R script.

Fortunately, RStudio is pretty good about highlighting breaks in code syntax. With all the nested functions in the ui.R script, it's important to look out for any open parentheses. Another tip is to remember that UI elements are each arguments to functions – as such, they're separated by commas.

The server.R script has a slightly different syntax. It always starts with something like ```shinyServer(function(input, output) {``` and ends with ```})``` to close out that outermost function. Because the code inside of that first ```{``` is being defined as part of a function (and not a series of arguments) you don't need to use commas while separating objects. You will need to use the ```({``` while calling render functions for the output.

These are just a few basic tips but they might save you a headache or two, especially at the beginning. 

## server.R

The foundation for the server.R script is in the "scratch" file. For this code to work with ui.R, you need to add calls to the widget inputs / display outputs. 

Let's start with the input mechanisms ... after all, the output depends on the values that the users enter into these widgets.

Accessing an input widget is easy. Use 'input$' followed by the name you gave the 'id' argument over in the ui.R file wherever you want to the input to be a control.

Let's say, for example, you wanted to create a histogram of random values while allowing the user to select sample size. If you had a numeric input called 'samplesize' then the syntax for the server.R portion of the code would include ```hist(rand(input$samplesize))```

The code above would take care of the _input_ portion of the histogram. To finish the thought and _output_ the plot you need two more pieces ...

In the ui.R you have to specify a display output – like input widgets, these come in different flavors (e.g ```plotOutput()``` or ```textOutput()``` or ```tableOutput()```), can live anywhere in the layout and must be given an arbitrary id.

Within the server.R script you'll need to call the UI output in the same way as the input – use 'output$' followed by the name you gave the 'id' argument.

The last step is to assign the output in the server script to a render function (e.g. ```renderPlot()``` or ```renderText()```) that contains the scratch script modified with the 'input$' call.

```R
library(rentrez)
library(ggplot2)
library(highcharter)

shinyServer(function(input, output) {
    
    output$yearplot <- renderPlot({
        
        pubcount <- function(year,term) {
            
            query <- paste(term, "AND (", year, "[PDAT])")
            entrez_search(query, db = "pubmed")$count
        }
        
        year <- 2006:2016
        
        pubs <- sapply(year, pubcount, term = input$term)
        
        df <- data.frame(year, pubs)
        
        ggplot(df, aes(year, pubs)) +
            geom_line() +
            theme_minimal()
        
    })
    
})
```

## Reactivity

By building ui.R and server.R in the manner described above, the output of the app will update every time the input is changed. This fact may sound simple and could easily be taken for granted. But it demonstrates one of the fundamental features of Shiny: _reactivity_.

A reactive element will update output based on input.

By default, all of the 'render' functions are reactive:
	
- ```renderPlot()```
- ```renderText()```
- ```renderTable()```
- ```renderDataTable()``` 
- ```renderImage()```
- ```renderUI()```
- ```renderPrint()```

Reactivity may not always be desireable. In some cases, you may want to only trigger a reaction after the user has input 'signed off' on the submission of the  data ... ```actionButton()``` and ```observeEvent()``` in combination will do just that.

Shiny makes it possible to manage reactivity in different ways:

- You can *prevent* reactions with ```isolate()```

- You can *delay* reactions with ```eventReactive()```

- You can *modularize* reactions with ```reactive()```

- You can *trigger* reactions with ```observeEvent()```

Reactivity is a beast.

Credit is due to the RStudio group that put together the Shiny webinar series ... [their material](https://github.com/rstudio/webinars/blob/master/09-How-to-start-with-Shiny-Part-2/02-How-to-start-2.pdf) makes it much easier to understand the concept.

```R
library(rentrez)
library(ggplot2)
library(highcharter)

shinyServer(function(input, output) {
    
    dat <- eventReactive(input$go, {
        
        pubcount <- function(year,term) {
            
            query <- paste(term, "AND (", year, "[PDAT])")
            entrez_search(query, db = "pubmed")$count
        }
        
        year <- input$year[1]:input$year[2]
        
        pubs <- sapply(year, pubcount, term = input$term)
        
        df <- data.frame(year, pubs)
        
        df
        
    })
    
    output$yearplot <- renderPlot({

        ggplot(dat(), aes(year, pubs)) +
            geom_line() +
            theme_minimal()
        
    })
    
})
```
```R
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("PUBPOP"),

  sidebarLayout(
    sidebarPanel(
        textInput("term", label = "pubmed search term", value = "zika"),
        sliderInput("year", label = "year",min = 1950, max = 2016, value = c(2000,2016)),
        actionButton("go", "Search")
    ),

    mainPanel(
        plotOutput("yearplot")
    )
  )
))
```
## Loading Data

In some cases, it makes sense to create objects before any of the reactive stuff kicks off.

For example, you might want to load a dataset to be filtered and analyzed by the server.R code.

Anything before the ```shinyUI()``` or ```shinyServer()``` functions is only run once (when the server is started) and is available for use in the environment.

```R
library(rentrez)
library(ggplot2)
library(highcharter)

shinyServer(function(input, output) {
    
    dat <- eventReactive(input$go, {
        
        pubcount <- function(year,term) {
            
            query <- paste(term, "AND (", year, "[PDAT])")
            entrez_search(query, db = "pubmed")$count
        }
        
        year <- input$year[1]:input$year[2]
        
        pubs <- sapply(year, pubcount, term = input$term)
        
        df <- data.frame(year, pubs)
        
        df
        
    })
    
    output$yearplot <- renderPlot({

        ggplot(dat(), aes(year, pubs)) +
            geom_line() +
            theme_minimal()
        
    })
    
})
```

```R
library(shiny)

search_terms <- read.csv("pmsearchterms.csv", stringsAsFactors = FALSE)

shinyUI(fluidPage(

  # Application title
  titlePanel("PUBPOP"),

  sidebarLayout(
    sidebarPanel(
        # textInput("term", label = "pubmed search term", value = "zika"),
        selectInput("term", label = "pubmed search term", choices = search_terms$term),
        sliderInput("year", label = "year",min = 1950, max = 2016, value = c(2000,2016)),
        actionButton("go", "Search")
    ),

    mainPanel(
        plotOutput("yearplot")
    )
  )
))
```
## Theming

This will be brief. 

But yes you can totally "make the font bigger ... oh no not that big ... yeah that's perfect ... actually maybe it was better before ..."

The "tags$" syntax allows you to access individual HTML elements. For example, ```tags$b(textOutput("example"))``` in the ui.R script would make all of the text output for "example" bold.

By creating a "www" directory in the root your app file structure (i.e. next to your ui.R and server.R scripts) you can insert style-sheet (CSS) files. The CSS is used to control how individual HTML elements display on the page(s) of your Shiny app. Note that these _must_ go in a directory called "www".

If you're really into pixel pushing with CSS, try checking out [this tutorial](http://shiny.rstudio.com/articles/css.html).

And if you just want to try out some different theming options (for font size, button style, etc.) you can use the **shinythemes** package. RStudio has written [some helpful documentation](http://rstudio.github.io/shinythemes/) for that library.

```R
library(shiny)
library(shinythemes)

search_terms <- read.csv("~/Downloads/pmsearchterms.csv", stringsAsFactors = FALSE)

shinyUI(fluidPage(theme = shinytheme("flatly"),

  # Application title
  titlePanel("PUBPOP"),

  sidebarLayout(
    sidebarPanel(
        # textInput("term", label = "pubmed search term", value = "zika"),
        selectInput("term", label = "pubmed search term", choices = search_terms$term),
        sliderInput("year", label = "year",min = 1950, max = 2016, value = c(2000,2016)),
        actionButton("go", "Search")
    ),

    mainPanel(
        plotOutput("yearplot")
    )
  )
))
```

## runApp()

If you're using RStudio and are looking at either the ui.R or server.R scripts in the source viewer, you'll see a button with a green arrow that says "Run App" in the upper right corner of the panel. Pressing that button will open your app in an external RStudio window.

Your console pane in RStudio will tell you that your R session is busy listening on a local port. You can halt the app in the console with the stop sign button. 

And if you're not using RStudio (or if you want to customize _how_ the app is running) it's possible to start the app with ```runApp()```

`
runApp(display.mode="showcase")
`

```runGithub()``` is another option. Somewhere in between ```runApp()``` and hosting, this method of running an app goes to a Github repository that contains an app and then runs it from your computer locally. It is worth mentioning that for this to work you'll need all of the packages that the app uses installed in your version of R. Try it out:

```R
install.packages("shiny")
install.packages("ggplot2")
install.packages("ggthemes")
install.packages("babynames")
install.packages("scales")

shiny::runGitHub('names', 'vpnagraj') 
```  

## Hosting

Running your app locally is a great way to prototype. But it's local. That means only on your computer.

To host the app so other people can view it on the internet, you'll need a system with a Shiny server that's running and configured.

There are a few avenues you could pursue:

- [shinyapps.io](https://www.shinyapps.io/) (mix of free and fee-based options depending on up-time, number of apps and authentication)
- [Shiny Server](https://www.rstudio.com/products/shiny/shiny-server/) (free but must be configured and installed on your hardware)
- [Shiny Server Pro](https://www.rstudio.com/products/shiny-server-pro/) (fee-based but is professionally configured and maintained)

N.B. Each of these solutions has advantages and disadvantages. If you're intereseted in hosting an app, think long and hard about the budget you have for your app, the longevity of the project and any security concerns you have for the data involved.

```R
# http://shiny.rstudio.com/articles/shinyapps.html
# install.packages("devtools") 
# devtools::install_github('rstudio/rsconnect')
# devtools::install_github("rstudio/shinyapps")
library(shinyapps)
deployApp()
```
<script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script>
<link rel="stylesheet" href="http://yandex.st/highlightjs/7.3/styles/github.min.css">
<script>
  hljs.initHighlightingOnLoad();
</script>
