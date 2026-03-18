
# All the credit goes to write from the web page creater "https://www.cedricscherer.com/slides/2019-08-28-intro-ggplot-statsizw#115"


setwd("/Users/datascientist/Rprogrammig/ggplot2/Ggplot2_Mar2026")

dir()

library(data.table)
library(dplyr)
library(ggplot2)


# https://www.cedricscherer.com/slides/2019-08-28-intro-ggplot-statsizw#115

chic = fread("chicago-nmmaps-custom.csv")



(g <- ggplot(chic, aes(x = date, y = temp)))

# Customise point appearance directly inside geom_point()
# color: fill colour of the points
# shape: "diamond" changes the point marker shape
# size:  controls point radius
g + geom_point(color = "firebrick", shape = "diamond", size = 2)




# Combine two styled geometries — each can have its own visual properties
g + geom_point(color = "firebrick", shape = "diamond", size = 2) +
  geom_line(color = "firebrick", linetype = "dotted", size = .3)+
  theme_classic()




# 4. Working with Axes
# 
# Well-labelled, legible axes are essential for any good plot. 
# ggplot2 offers multiple ways to control axis titles, text formatting, tick marks, and numeric scales.
# 
# 4.1 Axis Labels
# 
# There are two equivalent ways to set axis labels:
  
  
# Option 1: labs() — recommended, handles all labels in one call
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)")

# Option 2: xlab() / ylab() — older style, still valid
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  xlab("Year") +
  ylab("Temperature (°F)")

# Using R's expression() for mathematical notation or superscripts
# degree is a special symbol; paste() combines text and symbols
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(
    x = "Year",
    y = expression(paste("Temperature (", degree ~ F, ")"^"(metric units?!)"))
  )
  

# 4.2 Axis Title Styling

# All text elements in ggplot2 are controlled via theme() using element_text(). 
# You can adjust position, font size, color, and style.


# vjust moves the title closer/further from the axis (vertical justification)
# Higher vjust on x pushes the title downward; on y, it pushes it away from the axis
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title.x = element_text(vjust = 0, size = 15),
    axis.title.y = element_text(vjust = 0, size = 15)
  )

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title.x = element_text(margin = margin(t = 10), size = 15),
    axis.title.y = element_text(margin = margin(r = 10), size = 15)
  )

# face = "italic" applies italic style to both axis titles at once
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.title = element_text(size = 15, color = "firebrick", face = "italic"))

# axis.title applies to BOTH axes; axis.title.y overrides just the y-axis
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme_classic()+
  theme(
    axis.title = element_text(color = "sienna", size = 15, face = "bold"),
    axis.title.y = element_text(face = "bold.italic")  # overrides only y
  )


# 4.3 Axis Text (Tick Labels)


# Style tick labels: color applied to both axes, italic only on x
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.text = element_text(color = "dodgerblue", size = 12),
    axis.text.x = element_text(face = "italic")  # overrides only x tick labels
  )

# Rotating tick labels is useful for dense date/category axes
# vjust = 1 and hjust = 1 align the rotated text neatly to the tick marks
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.text.x = element_text(angle = 50, vjust = 1, hjust = 1, size = 12))

# Completely hide the y-axis ticks and labels (useful for clean categorical plots)
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.ticks.y = element_blank(),   # removes tick marks
    axis.text.y = element_blank()     # removes tick labels
  )

# Setting x = NULL removes the label; y = "" removes it but keeps the spacing
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = NULL, y = "")


# 4.4 Axis Limits & Scale


# ylim() clips the data — points outside the range are removed entirely
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ylim(c(0, 50))

# Custom label formatter using an anonymous function
# Appends " Degrees Fahrenheit" to each numeric tick value

#---- Custom Label can be added ----- 

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL) +
  scale_y_continuous(label = function(x) paste(x, "Degrees Fahrenheit"))

# scale_y_reverse() flips the y-axis — useful for ranking plots or depth data
ggplot(chic, aes(x = date, y = temp, color = o3)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_reverse()

# Log scale compresses large ranges — useful when data spans many orders of magnitude
ggplot(chic, aes(x = date, y = temp, color = o3)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_log10(lim = c(0.1, 100))

# 
# 5. Working with Titles
# 
# Plot titles, subtitles, captions, and tags all serve different communicative purposes. 
# ggplot2 supports all of them through labs() and ggtitle(), and their appearance is controlled via theme().
  
  
# ggtitle() is a quick shorthand for adding just a title
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ggtitle("Temperatures in Chicago")

# labs() is more versatile — supports title, subtitle, caption, and tag all at once
# subtitle: appears below the title in smaller text
# caption: appears at the bottom-right, typically for data attribution
# tag: a label for the panel (e.g., "Fig. 1") placed in the top-left
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(
    x = "Year", y = "Temperature (°F)",
    title    = "Temperatures in Chicago",
    subtitle = "Seasonal pattern of daily temperatures from 1997 to 2001",
    caption  = "Data: NMMAPS",
    tag      = "Fig. 1"
  )

# Styling the title: face = "bold" makes it bold; margin adds spacing around it
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)", title = "Temperatures in Chicago") +
  theme(plot.title = element_text(face = "bold", margin = margin(10, 0, 10, 0), size = 14))

# hjust controls horizontal alignment: 0 = left, 0.5 = centre, 1 = right
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL, title = "Temperatures in Chicago", caption = "Data: NMMAPS") +
  theme(plot.title = element_text(hjust = 0, size = 16, face = "bold.italic"))

# plot.title.position = "plot" extends the title alignment to the full plot width
# (instead of being aligned to the inner panel only)
(g <- ggplot(chic, aes(x = date, y = temp)) +
    geom_point(color = "firebrick") +
    scale_y_continuous(label = function(x) paste(x, "Degrees Fahrenheit")) +
    labs(
      x = "Year", y = NULL,
      title   = "Temperatures in Chicago between 1997 and 2001 in Degrees Fahrenheit",
      caption = "Data: NMMAPS"
    ) +
    theme(
      plot.title   = element_text(size = 14, face = "bold.italic"),
      plot.caption = element_text(hjust = 0)  # left-align the caption
    ))

g + theme(
  plot.title.position   = "plot",  # align title to full plot (not just panel)
  plot.caption.position = "plot"   # align caption to full plot
)


# 
# 5.1 Custom Fonts with {showtext}
# 
# The {showtext} package lets you use any Google Font (or local font) in your plots.
# This greatly improves typographic quality.


# 9. Working with Multi-Panel Plots
# 
# Showing data in multiple panels (facets) is one of ggplot2's
# most powerful features. It allows side-by-side comparisons across groups without duplicating code.
# 

# 
# 9.1 Facet Wrap
# 
# facet_wrap() arranges panels in a ribbon that wraps to the next row when needed.

g <- ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "navy", alpha = .3,size=3) +#orangered
  labs(x = "Year", y = "Temperature (°F)")

# One panel per year, arranged in a single row
g + facet_wrap(~ year, nrow = 1)

# Two rows of panels
g + facet_wrap(~ year, nrow = 2)

# scales = "free" gives each panel its own axis scale
# Use when panels contain very different data ranges
g + facet_wrap(season~year, nrow = 2, scales = "free")+
  theme_classic()



# 
# 9.2 Facet Grid
# 
# facet_grid() arranges panels in a strict row × column matrix.

# rows = year, columns = season
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "orangered", alpha = .3) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = "Year", y = "Temperature (°F)") +
  facet_grid(  year~season)

# 9.3 Styling Facet Strip Labels

# Style the strip background (the label bar at the top of each panel)
g + facet_wrap(~ year, nrow = 1, scales = "free_x") +
  theme(
    strip.text       = element_text(face = "bold", color = "chartreuse4", hjust = .5, size = 20),
    strip.background = element_rect(fill = "navy", linetype = "dotted")
  )+
  theme_classic()




# 10. Working with Colors
# 
# Color is one of the most powerful visual channels. 
# ggplot2 provides many built-in palettes and integrates with specialist color packages.
# 
# 10.1 Discrete Color Scales


(ga <- ggplot(chic, aes(x = date, y = temp, color = season)) +
    geom_point() +
    labs(x = "Year", y = "Temperature (°F)", color = NULL))

# Manually specify colors — full control
ga + scale_color_manual(values = c("dodgerblue4", "darkolivegreen4", "darkorchid3", "goldenrod1"))

# ColorBrewer palettes — designed for perceptual distinguishability
ga + scale_color_brewer(palette = "Set1")

# Tableau palettes — familiar from data visualisation software
library(ggthemes)
ga + scale_color_tableau()

# Scientific journal palettes from {ggsci}
library(ggsci)
ga + scale_color_aaas()  # American Association for the Advancement of Science
ga + scale_color_npg()   # Nature Publishing Group

# Viridis (discrete) — perceptually uniform, colorblind-safe
ga + scale_color_viridis_d(guide = "none")





gb <- ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F):")

# Single-direction gradient (dark to light)
gb + scale_color_gradient(low = "darkkhaki", high = "darkgreen")

# Diverging gradient: values below mid get one color, above get another
# Useful when there is a meaningful midpoint (e.g., zero or the mean)
mid <- mean(chic$temp)
gb + scale_color_gradient2(midpoint = mid, low = "#dd8a0b", mid = "grey92", high = "#32a676")

# Viridis — perceptually uniform and colorblind-safe (4 variants)
gb + scale_color_viridis_c()                      # default "viridis"
gb + scale_color_viridis_c(option = "inferno")    # dark purple to yellow
gb + scale_color_viridis_c(option = "plasma")     # purple to yellow via pink
gb + scale_color_viridis_c(option = "cividis")    # blue to yellow (deuteranopia-safe)

# CARTO and Scico palettes for additional options
library(rcartocolor)
gb + scale_color_carto_c(palette = "BurgYl")

library(scico)
gb + scale_color_scico(palette = "berlin")
gb + scale_color_scico(palette = "hawaii", direction = -1)  # reverse direction





g + theme_bw()                                       # Black and white, clean
g + theme_bw(base_family = "Playfair")               # BW with custom font
g + theme_bw(base_size = 30, base_family = "Roboto Condensed")  # Larger text
g + theme_bw(base_line_size = 1, base_rect_size = 1) +# Thicker borders
theme_classic(base_line_size = 1, base_rect_size = 1)
library(ggthemes)
# Economist magazine style
ga + theme_economist() + scale_color_economist(name = NULL)

# Tufte's minimal, ink-sparing style — no gridlines, no border
ggplot(chic_2000, aes(x = temp, y = o3)) + geom_point() + theme_tufte()


# 12. Working with Lines
# 
# Reference lines help readers interpret data by anchoring specific 
# values (means, medians, thresholds). 
# ggplot2 provides several geoms for lines, segments, and curves.

# geom_hline(): horizontal line at a fixed y value
# geom_vline(): vertical line at a fixed x value
ggplot(chic, aes(x = date, y = temp, color = o3)) +
  geom_point() +
  geom_hline(yintercept = c(0, 73)) +  # two horizontal lines at y = 0 and y = 73
  labs(x = "Year", y = "Temperature (°F)")


g <- ggplot(chic, aes(x = temp, y = dewpoint)) +
  geom_point(color = "dodgerblue", alpha = .5) +
  labs(x = "Temperature (°F)", y = "Dewpoint")

# Add median reference lines — computed from the data inside aes()
g +
  geom_vline(aes(xintercept = median(temp)),     size = 1.5, color = "firebrick", linetype = "dashed") +
  geom_hline(aes(yintercept = median(dewpoint)), size = 1.5, color = "firebrick", linetype = "dashed")

