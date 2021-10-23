#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title



    tags$head(
      tags$title("CBEV"),
      tags$style(
        HTML(
          '.irs-single, .irs-bar-edge, .irs-bar {
                                                  background: #eb8c00;
                                                  border-top: 1px solid #eb8c00 ;
                                                  border-bottom: 1px solid #eb8c00 ;
                                                  border: #eb8c00;
                                                }
           .irs-from, .irs-to, .irs-single { background: #eb8c00 }
          .well { background: #ffffff }    '
        )
      )
    ),
  tags$style(HTML("
      #start {
        margin-top: 50px;
      }
      #end {
        margin-top: 50px;
        margin-bottom: 100px;
        min-height: 200px
      }
      #contact {
        padding-top: 20px;
      }
      #footer {
        margin-bottom: 10px;
      }
      #first {
          min-height: 580px;
          margin-top: 50px;
      }
      .second {
          border: 2px dashed blue;
      }
    ")),
  
  fluidRow(
    h6()
  ),
  fluidRow(
    column(8, offset = 1, tags$img(id="logo", src="logo-wacc-io.png", height=80)),
    column(2, id="contact",
           tags$small(tags$b("Contact:")),tags$br(),
           tags$small("cbev@wacc.io"),tags$br(),
           tags$small(""))
  ),
  fluidRow(
    column(10, offset = 1, id = "start", h1("I. Introduction to Customer-based Enterprise Valuation (CBEV)"), "[Introduction goes here]")
  ),
  
  # I. Customer Section
  fluidRow(id="first", 
           column(10, offset = 1, h1("II. Customer"), ("[Description of Customer-Section goes here]")),
    column(3, offset=1, 
           h3("Assumptions"),
           h6("Please select the appropriate parameters:"),
           h3(""),
           tabsetPanel(id='maintabset', type='tabs',
                          tabPanel('Key Metrics', wellPanel(
                            sliderInput("brand",
                                        "Brand Image Strength:",
                                        min = 0,
                                        max = 2,
                                        value = 1.1,
                                        step = 0.05),
                            sliderInput("employer",
                                        "Employer Brand Image Strength:",
                                        min = 0,
                                        max = 2,
                                        value = 1,
                                        step = 0.05),
                            sliderInput("technology",
                                        "Technology Strength:",
                                        min = 0,
                                        max = 2,
                                        value = 1,
                                        step = 0.05)
                          )),
                          tabPanel('Customers', wellPanel(
                            sliderInput("customer",
                                        "Current customers (today):",
                                        min = 0,
                                        max = 2000,
                                        value = 350,
                                        step = 50)
                          )),
                          tabPanel('Market', wellPanel(
                            sliderInput("population",
                                        "Population (today):",
                                        min = 0,
                                        max = 2000,
                                        value = 1000,
                                        step = 50),
                            sliderInput("growth",
                                        "Population Growth (in %):",
                                        min = -10,
                                        max = 10,
                                        value = 3.5,
                                        step = 0.1)
                          ))
    )),
    column(6, offset=1,
           h3("Development of customers"),
           h6("Based on select assumptions and parameters:"),
           plotOutput("Customer"),
           tags$small("*Base line: [Definition of base line goes here]"))
  ),
  
  # II. Revenue Section
  fluidRow(id="first", 
           column(10, offset = 1,
                  h1("III. Revenue"),
                  ("[Description of Revenue-Section goes here]")
            ),
           column(3, offset=1, 
                  h3("Assumptions"),
                  h6("Please select the appropriate parameters:"),
                  h3(""),
                  tabsetPanel(id='maintabset', type='tabs',
                              tabPanel('Marketing', wellPanel(
                                sliderInput("increaseSpending",
                                            "Campaigns to increases spend per order:",
                                            min = 0,
                                            max = 2,
                                            value = 1.2,
                                            step = 0.05),
                                sliderInput("increaseRate",
                                            "Campaigns to increases repeat purchasing rate:",
                                            min = 0,
                                            max = 2,
                                            value = 1,
                                            step = 0.05)
                              )),
                              tabPanel('Sales', wellPanel(
                                sliderInput("avgSpending",
                                            "Average spending per Order (actual):",
                                            min = 0,
                                            max = 200,
                                            value = 100,
                                            step = 1),
                                sliderInput("avgOrder",
                                            "Average orders per customer (actual):",
                                            min = 0,
                                            max = 20,
                                            value = 3,
                                            step = 0.1)
                              )),
                              tabPanel('Economy', wellPanel(
                                sliderInput("priceInflation",
                                            "Price Inflation (in %):",
                                            min = -10,
                                            max = 10,
                                            value = 1.0,
                                            step = 0.1)
                              )),
                              tabPanel('Simulation', wellPanel(
                                sliderInput("nbSim",
                                            "Number of simulations:",
                                            min = 0,
                                            max = 250,
                                            value = 50,
                                            step = 1)
                              ))
                  )),
           column(6, offset=1,
                  h3("Simulation of future revenue development"),
                  h6("Monte Carlo simulation based on expected customer develpement and select assumptions and parameters:"),
                  plotOutput("Test"),
                  tags$small("*Base line: [Definition of base line goes here]")
  )),
  
  # IV. Valuation
  fluidRow(id="first", 
           column(10, offset = 1,
                  h1("IV. Enterprise Valuation"),
                  ("[Description of Enterprise Valuation goes here]")
           ),
           column(3, offset=1, 
                  h3("Assumptions"),
                  h6("Please select the appropriate parameters:"),
                  h3(""),
                  h3("[Coming soon]")
                  ),
           column(6, offset=1,
                  h3("Enterprise Valauation"),
                  h6("Based on select assumptions and parameters:"),
                  h3(""),
                  h3("[Coming soon]")
           )),
  fluidRow(
    column(10, offset = 1, id = "end", h1("V. Conclusion"), "[Conclusion goes here]")
  ),
  fluidRow(
    column(10, offset = 1, id = "footer",
           h6("© 2021. All rights reserved. Digital Asset of wacc.io"),
           tags$small("TERMS OF SERVICE: This data is made available to provide immediate access for the convenience of interested persons and as a benefit to the global valuation community. Whilst we believe this data to be reliable, human or mechanical error remains a possibility. We give no warranty, expressed or implied, as to the accuracy, reliability, or completeness of this data. THE ENTIRE RISK OF USE OF THIS DATA SHALL BE WITH THE USER. By accessing this site you agree to this Terms of Service.")
           )
  )
  
))
