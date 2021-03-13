library(readr)
library(dplyr)
library(ggplot2)
library(patchwork)
library(repr)


function(input, output, session) {
  
  characters = read_csv("C:/Users/Asus/Desktop/le tout/2020-2021/Master 20-21/Analyse des donnees  ethiene/Rshiny/dansmarue_small.csv")
  chara= characters %>% mutate(characters,mois =format(DATEDECL,"%m"),annee =format(DATEDECL,"%y") ) 
  
  output$plot <- renderPlot({
    pointData <- characters %>% filter( TYPE == input$plotType)
    ggplot(pointData) +
      geom_point(aes(x = long, y = lat, color = CODE_POSTAL), size = 3, alpha = .2) +
      coord_map(projection = "mercator")+
      labs(title = 'Incidents déclarés à Paris entre 2018 et 2019',
           subtitle = paste('Incidents de type ',toString(input$plotType), sep=" "),
           caption = 'Sources : Données "Dans ma Rue"2018-2019',
           x = "Longitude", y = "Latitude")
  })
  
  output$plot2 <- renderPlot({
    pointData <- characters %>% filter( TYPE == input$plotType)
    ggplot(pointData) +
      geom_point(aes(x = long, y = lat, color = CODE_POSTAL), size = 3, alpha = .2) +
      coord_map(projection = "mercator") +
      labs(title = 'Incidents déclarés à Paris entre 2018 et 2019',
           subtitle = paste('Incidents de type ',toString(input$plotType), sep=" "),
           caption = 'Sources : Données "Dans ma Rue"2018-2019',
           x = "Longitude", y = "Latitude")+
      facet_wrap(~SOUSTYPE) 
  })
  
  
  
  output$summary <- renderPlot({
    
    chara= characters %>% mutate(characters,mois =format(DATEDECL,"%m"),annee =format(DATEDECL,"%y") )
    carteData <- chara %>%
      filter(TYPE %in% input$checkGroup)%>% arrange(desc(annee)) 
    ggplot(carteData) +
      geom_point(aes(long, lat, colour = TYPE), size = .5, alpha = .3) +
      facet_grid(annee~TYPE) +
      coord_map(projection = "mercator") +
      scale_colour_discrete(guide = FALSE) +
      labs(title = 'Incidents déclarés à Paris entre 2018 et 2019',
           subtitle = paste('Incidents de type ',toString(input$checkGroup), sep=" "),
           caption = 'Sources : Données "Dans ma Rue"2018-2019',
           x = "Longitude", y = "Latitude")
  })
  
  
  output$summary2 <- renderPlot({
    Moisettype <- chara %>% filter(TYPE %in% input$checkGroup) %>% 
      group_by(Type=TYPE, Mois = mois) %>% 
      summarise(nb = n())
    
    ggplot(Moisettype, aes(x=Mois, y=nb, fill = Type)) + 
      geom_col() + 
      theme_bw() + 
      facet_wrap(~Type,ncol = 2)+
      labs(title = 'Le nombre des incidents par mois selon chaque type entre 2018 et 2019',
           caption = 'Sources : Données "Dans ma Rue"2018-2019')
  })
  
  
  output$tableau <- renderPlot({
    type <- chara %>% filter(annee == input$annee) %>% group_by(TYPE) %>% summarise(nb = n())
    type$fraction = type$nb /sum(type$nb)
    type$ymax = cumsum(type$fraction)
    type$ymin = c(0, head(type$ymax, n=-1))
    
    ggplot(type, aes(ymax=ymax, ymin=ymin,xmax=4, xmin=3, fill=TYPE)) + 
      geom_rect(color="black") + coord_polar(theta="y") + xlim(c(2, 4))+
      labs(title = paste('Le pourcentage des incidents par chaque type pour anne ',input$annee, sep=" "),
           caption = 'Sources : Données "Dans ma Rue"2018-2019')
    
  })
  
  output$tableau3 <- renderPlot({
    chara= characters %>% mutate(characters,mois =format(DATEDECL,"%m"),annee =format(DATEDECL,"%y") )
    var =input$range
    print(var[1])
    arrdtData <- chara %>% filter(between(CODE_POSTAL,var[1],var[2]) ) %>%
      group_by(annee, CODE_POSTAL) %>%
      summarise(NbIncidents = n()) %>%
      ungroup() %>%
      mutate(annee = as.character(annee))
    ggplot(arrdtData) +
      geom_col(aes(CODE_POSTAL, NbIncidents, fill = annee), position = "dodge") +
      scale_color_manual(values=c("#E69F00", "#56B4E9")) +
      theme(legend.position="bottom",
            axis.text.x = element_text(angle = 45, hjust = 1))+
      labs(title = 'Le nombre des incidents par code postal entre 2018 et 2019',
           caption = 'Sources : Données "Dans ma Rue"2018-2019',
           x = "Code postal", y = "Nombre d'incidents")
  })
  
}