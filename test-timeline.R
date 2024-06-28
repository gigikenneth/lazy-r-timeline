library(shiny)
library(timevis)

# Timeline data with URLs
timeline_data <- data.frame(
  id = 1:32,
  content = c("R was created by Ross Ihaka and Robert Gentleman",
              "R is released under the GNU licence",
              "Ross Ihaka and Robert Gentleman's paper 'R: A Language for Data Analysis and Graphics' is published",
              "The Comprehensive R Archive Network (CRAN) was created",
              "The first stable version of R, version 1.0.0, is released",
              "The first edition of R News is published. Creation of Bioconductor",
              "The R Foundation is launched",
              "By the end of the year there are around 400 packages on CRAN",
              "R 2.0.0 is released with lots of new features",
              "The first UseR! conference is hosted in Austria",
              "Sasha Goodman's rseek website makes searching for R-related content easier. ggplot2 is released",
              "The R Journal supersedes R News",
              "Version 0.92 of the RStudio integrated development environment (IDE) is released",
              "The {shiny} package is released. R-Ladies is founded",
              "R 3.0.0 released with full support for 64bit architectures",
              "First stable release of {rmarkdown}",
              "{ggplot2} version 2.0.0 is released",
              "Jumping Rivers Ltd is founded. {tidyverse} version 1.0.0 is released",
              "CRAN surpasses 10,000 packages",
              "Tidy Tuesday starts",
              "R 4.0.0 is released. CRAN now has over 15,000 packages",
              "RStudio becomes a B Corp",
              "The first Shiny in Production conference is held in Newcastle-upon-Tyne, England",
              "RStudio announce the release of Quarto. RStudio becomes Posit",
              "First public release of WebR package",
              "Appsilon was founded",
              "Rhino was created",
              "Rhinoverse was launched",
              "The first ShinyConf was held",
              "Pharmaverse was founded",
              "Rhinoverse package {shiny.semantic} was released",
              "Rhinoverse package {shiny.router} was released"),
  start = as.Date(c("1993-01-01", "1995-01-01", "1996-01-01", "1997-01-01", "2000-02-29",
                    "2001-01-01", "2003-01-01", "2004-01-01", "2004-01-01", "2004-01-01",
                    "2007-01-01", "2009-01-01", "2011-01-01", "2012-01-01", "2013-01-01",
                    "2014-01-01", "2015-01-01", "2016-01-01", "2017-01-01", "2018-01-01",
                    "2020-01-01", "2020-01-01", "2022-01-01", "2022-01-01", "2023-01-01",
                    "2013-01-01", "2021-01-01", "2022-01-01", "2021-01-01", "2021-01-01",
                    "2021-07-01", "2021-10-01")),
  url = c("https://en.wikipedia.org/wiki/R_(programming_language)",
          "https://www.gnu.org/licenses/gpl-3.0.html",
          "https://www.tandfonline.com/doi/abs/10.1080/10618600.1996.10474713",
          "https://cran.r-project.org/",
          "https://cran.r-project.org/src/base/R-1/",
          "https://cran.r-project.org/doc/Rnews/",
          "https://www.r-project.org/foundation/",
          "https://cran.r-project.org/",
          "https://cran.r-project.org/src/base/R-2/",
          "https://user2022.r-project.org/",
          "https://rseek.org/",
          "https://journal.r-project.org/",
          "https://posit.co/products/open-source/rstudio/",
          "https://shiny.rstudio.com/",
          "https://cran.r-project.org/bin/windows/base/old/3.0.0/",
          "https://rmarkdown.rstudio.com/",
          "https://ggplot2.tidyverse.org/",
          "https://www.jumpingrivers.com/",
          "https://cran.r-project.org/",
          "https://github.com/rfordatascience/tidytuesday",
          "https://cran.r-project.org/bin/windows/base/old/4.0.0/",
          "https://bcorporation.net/directory/rstudio",
          "https://shiny-in-production.org/",
          "https://quarto.org/",
          "https://github.com/r-wasm/webr",
          "https://appsilon.com/",
          "https://appsilon.com/rhino/",
          "https://appsilon.com/rhino/",
          "https://appsilon.com/shinyconf/",
          "https://pharmaverse.org/",
          "https://github.com/Appsilon/shiny.semantic",
          "https://appsilon.github.io/shiny.router/")
)

# Ensure data is sorted by the start date
timeline_data <- timeline_data[order(timeline_data$start),]

# Define UI
ui <- fluidPage(
  titlePanel("Interactive R Timeline"),
  sidebarLayout(
    sidebarPanel(
      helpText("This is an interactive timeline of significant events in the history of R."),
      uiOutput("link")
    ),
    mainPanel(
      timevisOutput("timeline")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  output$timeline <- renderTimevis({
    timevis(
      data = timeline_data,
      options = list(
        editable = FALSE,
        multiselect = TRUE,
        min = "1990-01-01",
        max = "2030-12-31"
      )
    )
  })
  
  observeEvent(input$timeline_selected, {
    selected_id <- input$timeline_selected
    if (length(selected_id) == 1) {
      selected_url <- timeline_data$url[timeline_data$id == selected_id]
      output$link <- renderUI({
        if (!is.na(selected_url)) {
          tags$a(href = selected_url, target = "_blank", "Learn more")
        } else {
          NULL
        }
      })
    } else {
      output$link <- renderUI({
        NULL
      })
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
