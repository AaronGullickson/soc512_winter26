# Making Pictures
# Soc 412/512
# Winter 2026


# Load stuff --------------------------------------------------------------

# load packages
library(tidyverse)
#library(ggplot2) - don't need this because its part of the tidyverse

# color packages
library(wesanderson)

# additional
library(ggrepel)
library(ggthemes)

# load data
load(url("https://github.com/AaronGullickson/practical_analysis/raw/master/data/nyc.RData"))


# Make a picture ----------------------------------------------------------

ggplot(nyc, aes(x = poverty, y = amtcapita))+
  # add geoms
  geom_point(alpha = 0.7, aes(color = borough, size = popn))+
  geom_smooth(method = "lm", se = FALSE, color = "grey10")+
  #geom_text_repel(aes(label = health_area))+
  #annotate("text", x = 0.3, y = 20, label = "Some text")+
  # adjust scale
  scale_y_log10(breaks = c(1, 10, 100, 1000, 10000), 
                # we could do labels manually or use the scales 
                # package
                #labels = c("$1", "$10", "$100", "$1000", "$10,000")
                labels = scales::dollar)+
  scale_x_continuous(labels = scales::percent)+
  #scale_color_brewer(palette = "Dark2")+
  #scale_color_manual(values = c("orchid", "darkgreen",
  #                              "hotpink", "firebrick", "navyblue"))+
  #scale_color_manual(values = wes_palette("Moonrise3"))+
  scale_color_viridis_d()+
  #facet_wrap(~borough)+
  #facet_grid(var1~var2)+
  # always label your aesthetics
  labs(x = "poverty rate", 
       y = "social service funding per capita",
       color = "borough",
       size = "population")+
  theme_bw()#+
  #theme(legend.position = "bottom", 
        #panel.background = element_rect(fill = "hotpink"),
   #     axis.text = element_text(size = 1),
  #      axis.title = element_text(size = 16))
  



