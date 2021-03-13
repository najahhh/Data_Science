library(markdown)
library(readr)
library(dplyr)
library(ggplot2)
library(patchwork)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Visualtion des données",titleWidth = 250),
  dashboardSidebar(width=250 , 
    sidebarMenu(
      # Setting id makes input$tabs give the tabName of currently-selected tab
      id = "tabs",
      menuItem("Distribution Des incidents ", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Taux des incidents", icon = icon("th"), tabName = "widgets"),
      menuItem("Distribution par année", icon = icon("bar-chart-o"),tabName = "charts")
      )
  ),
  dashboardBody(
    tabItems(
      tabItem("dashboard",
              fluidPage(
                selectInput("plotType", "Type des incidents:",
                            c("Objets abandonnés" = "Objets abandonnés",
                              "Mobiliers urbains" = "Mobiliers urbains",
                              "Graffitis, tags, affiches et autocollants"="Graffitis, tags, affiches et autocollants",
                              "Autos, motos, vélos..."="Autos, motos, vélos...",
                              "Propreté"="Propreté",
                              "Voirie et espace public"="Voirie et espace public",
                              "Eau"="Eau",
                              "Arbres, végétaux et animaux"="Arbres, végétaux et animaux",
                              "Éclairage / Électricité"="Éclairage / Électricité",
                              "Activités commerciales et professionnelles"="Activités commerciales et professionnelles"
                            )),
                plotOutput("plot"),hr(),
                
                plotOutput("plot2")
                
              )
      ),
      tabItem("widgets",
              fluidPage(
                selectInput("annee", "Année:",
                            c("2018" = "18",
                              "2019" = "19" )),
                plotOutput("tableau"),
                hr(),
                sliderInput("range", "Code postal (les arrondissements):",
                            min = 75000, max = 75020,
                            value = c(75000,75020),step=1),
                plotOutput("tableau3")
              )
              
      ),
      tabItem("charts",
              fluidPage(
                checkboxGroupInput("checkGroup", "Type des incidents:",
                                   c("Objets abandonnés" = "Objets abandonnés",
                                     "Mobiliers urbains" = "Mobiliers urbains",
                                     "Graffitis, tags, affiches et autocollants"="Graffitis, tags, affiches et autocollants",
                                     "Autos, motos, vélos..."="Autos, motos, vélos...",
                                     "Propreté"="Propreté",
                                     "Voirie et espace public"="Voirie et espace public",
                                     "Eau"="Eau",
                                     "Arbres, végétaux et animaux"="Arbres, végétaux et animaux",
                                     "Éclairage / Électricité"="Éclairage / Électricité",
                                     "Activités commerciales et professionnelles"="Activités commerciales et professionnelles"
                                   )),
                plotOutput("summary"),hr(),
             
                plotOutput("summary2")
              )
      )
    )

  )
)




