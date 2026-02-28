# A ggplot2 Tutorial for Beautiful Plotting in R

> **Author:** Cédric Scherer ([@CedScherer](https://twitter.com/CedScherer))  
> **Source:** [cedricscherer.com](https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/)
> **Source:** (https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/)
> **Last Updated:** 2020-12-02

---

## Table of Contents

1. [Setup & Installation](#1-setup--installation)
2. [Loading the Dataset](#2-loading-the-dataset)
3. [A Default ggplot](#3-a-default-ggplot)
4. [Working with Axes](#4-working-with-axes)
5. [Working with Titles](#5-working-with-titles)
6. [Working with Legends](#6-working-with-legends)
7. [Working with Backgrounds & Grid Lines](#7-working-with-backgrounds--grid-lines)
8. [Working with Margins](#8-working-with-margins)
9. [Working with Multi-Panel Plots](#9-working-with-multi-panel-plots)
10. [Working with Colors](#10-working-with-colors)
11. [Working with Themes](#11-working-with-themes)
12. [Working with Lines](#12-working-with-lines)
13. [Working with Text & Annotations](#13-working-with-text--annotations)
14. [Working with Coordinates](#14-working-with-coordinates)
15. [Working with Chart Types](#15-working-with-chart-types)
16. [Working with Ribbons & Smoothings](#16-working-with-ribbons--smoothings)
17. [Working with Interactive Plots](#17-working-with-interactive-plots)

---

## 1. Setup & Installation

```r
# Install CRAN packages
install.packages(c(
  "tidyverse", "colorspace", "corrr", "cowplot",
  "ggdark", "ggforce", "ggrepel", "ggridges", "ggsci",
  "ggtext", "ggthemes", "grid", "gridExtra", "patchwork",
  "rcartocolor", "scico", "showtext", "shiny",
  "plotly", "highcharter", "echarts4r"
))

# Install from GitHub (not on CRAN)
devtools::install_github("JohnCoene/charter")
```

---

## 2. Loading the Dataset

The tutorial uses the **Chicago NMMAPS** (National Morbidity and Mortality Air Pollution Study) dataset, filtered to 1997–2000.

```r
chic <- readr::read_csv("https://raw.githubusercontent.com/z3tt/ggplot-courses/main/data/chicago-nmmaps-custom.csv")
tibble::glimpse(chic)
head(chic, 10)
```

**Variables include:** `city`, `date`, `temp` (°F), `o3` (ozone), `dewpoint`, `pm10`, `season`, `yday`, `month`, `year`

---

## 3. A Default ggplot

```r
library(tidyverse)

# Define base plot object
(g <- ggplot(chic, aes(x = date, y = temp)))

# Add geometries
g + geom_point()                      # Scatter plot
g + geom_line()                       # Line plot
g + geom_line() + geom_point()        # Combined

# Customise point properties
g + geom_point(color = "firebrick", shape = "diamond", size = 2)

# Combine styled geometries
g + geom_point(color = "firebrick", shape = "diamond", size = 2) +
  geom_line(color = "firebrick", linetype = "dotted", size = .3)

# Set a global theme for all subsequent plots
theme_set(theme_bw())

g + geom_point(color = "firebrick")
```

---

## 4. Working with Axes

### Axis Labels

```r
# Using labs()
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)")

# Using xlab() and ylab()
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  xlab("Year") +
  ylab("Temperature (°F)")

# Using mathematical expressions / superscripts
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(
    x = "Year",
    y = expression(paste("Temperature (", degree ~ F, ")"^"(Hey, why should we use metric units?!)"))
  )
```

### Axis Title Styling

```r
# Adjust position with vjust
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title.x = element_text(vjust = 0, size = 15),
    axis.title.y = element_text(vjust = 2, size = 15)
  )

# Adjust position with margin
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title.x = element_text(margin = margin(t = 10), size = 15),
    axis.title.y = element_text(margin = margin(r = 10), size = 15)
  )

# Style: italic, colored
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.title = element_text(size = 15, color = "firebrick", face = "italic"))

# Style: different colors per axis
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title.x = element_text(color = "sienna", size = 15),
    axis.title.y = element_text(color = "orangered", size = 15)
  )

# Style: bold + bold.italic override
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title = element_text(color = "sienna", size = 15, face = "bold"),
    axis.title.y = element_text(face = "bold.italic")
  )
```

### Axis Text Styling

```r
# Color and italic x tick labels
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.text = element_text(color = "dodgerblue", size = 12),
    axis.text.x = element_text(face = "italic")
  )

# Rotate x-axis labels
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.text.x = element_text(angle = 50, vjust = 1, hjust = 1, size = 12))

# Remove y-axis ticks and text
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank()
  )

# Remove axis labels entirely
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = NULL, y = "")
```

### Axis Limits & Scale

```r
# Set y-axis limits
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ylim(c(0, 50))

# Custom y-axis label formatter
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL) +
  scale_y_continuous(label = function(x) paste(x, "Degrees Fahrenheit"))

# Reverse y-axis
ggplot(chic, aes(x = date, y = temp, color = o3)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_reverse()

# Log scale
ggplot(chic, aes(x = date, y = temp, color = o3)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_log10(lim = c(0.1, 100))
```

---

## 5. Working with Titles

```r
# Add a plot title
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ggtitle("Temperatures in Chicago")

# Full title, subtitle, caption, and tag
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(
    x = "Year", y = "Temperature (°F)",
    title = "Temperatures in Chicago",
    subtitle = "Seasonal pattern of daily temperatures from 1997 to 2001",
    caption = "Data: NMMAPS",
    tag = "Fig. 1"
  )

# Style the title: bold, margin, size
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)", title = "Temperatures in Chicago") +
  theme(plot.title = element_text(face = "bold", margin = margin(10, 0, 10, 0), size = 14))

# Right-align the title
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL, title = "Temperatures in Chicago", caption = "Data: NMMAPS") +
  theme(plot.title = element_text(hjust = 1, size = 16, face = "bold.italic"))

# Align title and caption to plot edge (not panel)
(g <- ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  scale_y_continuous(label = function(x) paste(x, "Degrees Fahrenheit")) +
  labs(
    x = "Year", y = NULL,
    title = "Temperatures in Chicago between 1997 and 2001 in Degrees Fahrenheit",
    caption = "Data: NMMAPS"
  ) +
  theme(
    plot.title = element_text(size = 14, face = "bold.italic"),
    plot.caption = element_text(hjust = 0)
  ))

g + theme(
  plot.title.position = "plot",
  plot.caption.position = "plot"
)
```

### Custom Fonts with `{showtext}`

```r
library(showtext)

font_add_google("Playfair Display", "Playfair")
font_add_google("Bangers", "Bangers")

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(
    x = "Year", y = "Temperature (°F)",
    title = "Temperatures in Chicago",
    subtitle = "Daily temperatures in °F from 1997 to 2001"
  ) +
  theme(
    plot.title = element_text(family = "Bangers", hjust = .5, size = 25),
    plot.subtitle = element_text(family = "Playfair", hjust = .5, size = 15)
  )

# Set a global font via base_family
font_add_google("Roboto Condensed", "Roboto Condensed")
theme_set(theme_bw(base_size = 12, base_family = "Roboto Condensed"))
```

---

## 6. Working with Legends

```r
# Remove legend entirely
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

# Remove only one aesthetic's legend
ggplot(chic, aes(x = date, y = temp, color = season, shape = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  guides(color = "none")

# Remove legend title
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.title = element_blank())

# Rename legend title via scale or labs
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = NULL)

# Move legend position
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "top")

# Place legend inside the plot
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = NULL) +
  theme(
    legend.position = c(.15, .15),
    legend.background = element_rect(fill = "transparent")
  )

# Horizontal legend at the top
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    legend.position = c(.5, .97),
    legend.background = element_rect(fill = "transparent")
  ) +
  guides(color = guide_legend(direction = "horizontal"))

# Style legend title (font, color, size)
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(
    x = "Year", y = "Temperature (°F)",
    color = "Seasons\nindicated\nby colors:"
  ) +
  theme(legend.title = element_text(family = "Playfair", color = "chocolate", size = 14, face = "bold"))

# Reorder legend levels using factors
chic$season <- factor(chic$season, levels = c("Winter", "Spring", "Summer", "Autumn"))

# Rename legend labels
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_color_discrete("Seasons:", labels = c("Mar-May", "Jun-Aug", "Sep-Nov", "Dec-Feb")) +
  theme(legend.title = element_text(family = "Playfair", color = "chocolate", size = 14, face = 2))

# Style legend key background
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = "darkgoldenrod1")) +
  scale_color_discrete("Seasons:")

# Enlarge legend key symbols
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = NA)) +
  scale_color_discrete("Seasons:") +
  guides(color = guide_legend(override.aes = list(size = 6)))

# Continuous color — guide variants
ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_legend())      # discrete-style

ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_bins())        # binned

ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_colorsteps())  # stepped colorbar

# Mixed geometry legend (line + point)
ggplot(chic, aes(x = date, y = o3)) +
  geom_line(aes(color = "line")) +
  geom_point(aes(color = "points")) +
  labs(x = "Year", y = "Ozone") +
  scale_color_manual(
    name = NULL, guide = "legend",
    values = c("points" = "darkorange2", "line" = "gray")
  ) +
  guides(color = guide_legend(override.aes = list(linetype = c(1, 0), shape = c(NA, 16))))
```

---

## 7. Working with Backgrounds & Grid Lines

```r
# Custom panel background and grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    panel.background = element_rect(fill = "gray90"),
    panel.grid.major = element_line(color = "gray10", size = .5),
    panel.grid.minor = element_line(color = "gray70", size = .25)
  )

# Dashed and dotted grid lines with different colors per axis
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    panel.background = element_rect(fill = "gray90"),
    panel.grid.major = element_line(size = .5, linetype = "dashed"),
    panel.grid.minor = element_line(size = .25, linetype = "dotted"),
    panel.grid.major.x = element_line(color = "red1"),
    panel.grid.major.y = element_line(color = "blue1"),
    panel.grid.minor.x = element_line(color = "red4"),
    panel.grid.minor.y = element_line(color = "blue4")
  )

# Remove minor grid lines only
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid.minor = element_blank())

# Remove all grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid = element_blank())

# Custom break intervals for grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_continuous(breaks = seq(0, 100, 10), minor_breaks = seq(0, 100, 2.5))

# Custom panel background fill and border
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "#1D8565", size = 2) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.background = element_rect(fill = "#64D2AA", color = "#64D2AA", size = 2))

# Set plot (outer) background color
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(plot.background = element_rect(fill = "gray60", color = "gray30", size = 2))
```

---

## 8. Working with Margins

```r
# Widen plot margins
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    plot.background = element_rect(fill = "gray60"),
    plot.margin = unit(c(1, 3, 1, 8), "cm")
  )
```

---

## 9. Working with Multi-Panel Plots

### Faceting

```r
g <- ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "orangered", alpha = .3) +
  labs(x = "Year", y = "Temperature (°F)")

# Facet wrap by year
g + facet_wrap(~ year, nrow = 1)
g + facet_wrap(~ year, nrow = 2)
g + facet_wrap(~ year, ncol = 3)
g + facet_wrap(~ year, nrow = 2, scales = "free")

# Facet grid: year × season
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "orangered", alpha = .3) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = "Year", y = "Temperature (°F)") +
  facet_grid(year ~ season)

# Two-variable facet wrap
g + facet_wrap(year ~ season, nrow = 4, scales = "free_x")

# Style strip labels
g + facet_wrap(~ year, nrow = 1, scales = "free_x") +
  theme(
    strip.text = element_text(face = "bold", color = "chartreuse4", hjust = 0, size = 20),
    strip.background = element_rect(fill = "chartreuse3", linetype = "dotted")
  )
```

### Custom Highlighted Strip Text (`{ggtext}`)

```r
library(ggtext)
library(rlang)

element_textbox_highlight <- function(..., hi.labels = NULL, hi.fill = NULL,
                                      hi.col = NULL, hi.box.col = NULL, hi.family = NULL) {
  structure(
    c(element_textbox(...),
      list(hi.labels = hi.labels, hi.fill = hi.fill,
           hi.col = hi.col, hi.box.col = hi.box.col, hi.family = hi.family)
    ),
    class = c("element_textbox_highlight", "element_textbox", "element_text", "element")
  )
}

element_grob.element_textbox_highlight <- function(element, label = "", ...) {
  if (label %in% element$hi.labels) {
    element$fill <- element$hi.fill %||% element$fill
    element$colour <- element$hi.col %||% element$colour
    element$box.colour <- element$hi.box.col %||% element$box.colour
    element$family <- element$hi.family %||% element$family
  }
  NextMethod()
}

g + facet_wrap(year ~ season, nrow = 4, scales = "free_x") +
  theme(
    strip.background = element_blank(),
    strip.text = element_textbox_highlight(
      family = "Playfair", size = 12, face = "bold",
      fill = "white", box.color = "chartreuse4", color = "chartreuse4",
      halign = .5, linetype = 1, r = unit(5, "pt"), width = unit(1, "npc"),
      padding = margin(5, 0, 3, 0), margin = margin(0, 1, 3, 1),
      hi.labels = c("1997", "1998", "1999", "2000"),
      hi.fill = "chartreuse4", hi.box.col = "black", hi.col = "white"
    )
  )
```

### Combining Plots

```r
library(patchwork)
p1 + p2          # Side by side
p1 / p2          # Stacked vertically
(g + p2) / p1    # Combined layout

# Complex layout string
layout <- "
AABBBB#
AACCDDE
##CCDD#
##CC###
"
p2 + p1 + p1 + g + p2 + plot_layout(design = layout)

# Using cowplot
library(cowplot)
plot_grid(plot_grid(g, p1), p2, ncol = 1)

# Using gridExtra
library(gridExtra)
grid.arrange(g, p1, p2, layout_matrix = rbind(c(1, 2), c(3, 3)))
```

---

## 10. Working with Colors

### Discrete Colors

```r
(ga <- ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = NULL))

# Manual colors
ga + scale_color_manual(values = c("dodgerblue4", "darkolivegreen4", "darkorchid3", "goldenrod1"))

# ColorBrewer
ga + scale_color_brewer(palette = "Set1")

# Tableau palette
library(ggthemes)
ga + scale_color_tableau()

# Scientific journal palettes
library(ggsci)
ga + scale_color_aaas()
ga + scale_color_npg()

# Viridis (discrete)
ga + scale_color_viridis_d(guide = "none")
```

### Continuous Colors

```r
gb <- ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F):")

gb + scale_color_continuous()

# Midpoint diverging scale
mid <- mean(chic$temp)
gb + scale_color_gradient2(midpoint = mid)
gb + scale_color_gradient(low = "darkkhaki", high = "darkgreen")
gb + scale_color_gradient2(midpoint = mid, low = "#dd8a0b", mid = "grey92", high = "#32a676")

# Viridis continuous
gb + scale_color_viridis_c()
gb + scale_color_viridis_c(option = "inferno")
gb + scale_color_viridis_c(option = "plasma")
gb + scale_color_viridis_c(option = "cividis")

# Carto and Scico palettes
library(rcartocolor)
gb + scale_color_carto_c(palette = "BurgYl")

library(scico)
gb + scale_color_scico(palette = "berlin")
gb + scale_color_scico(palette = "hawaii", direction = -1)
```

### Advanced Color Manipulation

```r
# Inverted inner point using after_scale
library(ggdark)
ggplot(chic, aes(date, temp, color = temp)) +
  geom_point(size = 5) +
  geom_point(aes(color = temp, color = after_scale(invert_color(color))), size = 2) +
  scale_color_scico(palette = "hawaii", guide = "none") +
  labs(x = "Year", y = "Temperature (°F)")

# Derived fill from color using colorspace
library(colorspace)
ggplot(chic, aes(date, temp)) +
  geom_boxplot(
    aes(color = season, fill = after_scale(desaturate(lighten(color, .6), .6))),
    size = 1
  ) +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  labs(x = "Year", y = "Temperature (°F)")
```

---

## 11. Working with Themes

### Built-in Themes

```r
g + theme_bw(base_family = "Playfair")
g + theme_bw(base_size = 30, base_family = "Roboto Condensed")
g + theme_bw(base_line_size = 1, base_rect_size = 1)

library(ggthemes)
ga + theme_economist() + scale_color_economist(name = NULL)
ggplot(chic_2000, aes(x = temp, y = o3)) + geom_point() + theme_tufte()
```

### Creating a Custom Theme

```r
theme_custom <- function(base_size = 12, base_family = "Roboto Condensed") {
  half_line <- base_size / 2
  theme(
    line = element_line(color = "black", size = .5, linetype = 1, lineend = "butt"),
    rect = element_rect(fill = "white", color = "black", size = .5, linetype = 1),
    text = element_text(family = base_family, face = "plain", color = "black",
                        size = base_size, lineheight = .9, hjust = .5, vjust = .5,
                        angle = 0, margin = margin(), debug = FALSE),
    axis.text = element_text(size = base_size * 1.1, color = "gray30"),
    panel.background = element_rect(fill = "white", color = NA),
    panel.border = element_rect(color = "gray30", fill = NA, size = .7),
    panel.grid.major = element_line(color = "gray90", size = 1),
    panel.grid.minor = element_line(color = "gray90", size = .5, linetype = "dashed"),
    plot.title = element_text(size = base_size * 1.8, hjust = .5, vjust = 1,
                              face = "bold", margin = margin(b = half_line * 1.2)),
    plot.margin = margin(base_size, base_size, base_size, base_size),
    complete = TRUE
  )
}

theme_set(theme_custom())

# Update the current theme
theme_custom <- theme_update(panel.background = element_rect(fill = "gray60"))
```

---

## 12. Working with Lines

```r
# Horizontal and vertical reference lines
ggplot(chic, aes(x = date, y = temp, color = o3)) +
  geom_point() +
  geom_hline(yintercept = c(0, 73)) +
  labs(x = "Year", y = "Temperature (°F)")

g <- ggplot(chic, aes(x = temp, y = dewpoint)) +
  geom_point(color = "dodgerblue", alpha = .5) +
  labs(x = "Temperature (°F)", y = "Dewpoint")

# Median reference lines
g +
  geom_vline(aes(xintercept = median(temp)), size = 1.5, color = "firebrick", linetype = "dashed") +
  geom_hline(aes(yintercept = median(dewpoint)), size = 1.5, color = "firebrick", linetype = "dashed")

# Regression line
reg <- lm(dewpoint ~ temp, data = chic)
g +
  geom_abline(
    intercept = coefficients(reg)[1], slope = coefficients(reg)[2],
    color = "darkorange2", size = 1.5
  ) +
  labs(title = paste0("y = ", round(coefficients(reg)[2], 2), " * x + ", round(coefficients(reg)[1], 2)))

# Line segments
g +
  geom_linerange(aes(x = 50, ymin = 20, ymax = 55), color = "steelblue", size = 2) +
  geom_linerange(aes(xmin = -Inf, xmax = 25, y = 0), color = "red", size = 1)

g +
  geom_segment(aes(x = 50, xend = 75, y = 20, yend = 45), color = "purple", size = 2)

# Curves with arrows
g +
  geom_curve(aes(x = 0, y = 60, xend = 75, yend = 0),
             size = 2, color = "tan",
             arrow = arrow(length = unit(0.07, "npc"))) +
  geom_curve(aes(x = 5, y = 55, xend = 70, yend = 5),
             curvature = -0.7, angle = 45, color = "darkgoldenrod1", size = 1,
             arrow = arrow(length = unit(0.03, "npc"), type = "closed", ends = "both"))
```

---

## 13. Working with Text & Annotations

```r
set.seed(2020)
library(dplyr)
sample <- chic |>
  dplyr::group_by(season) |>
  dplyr::sample_frac(0.01)

# geom_label and geom_text
ggplot(sample, aes(x = date, y = temp, color = season)) +
  geom_point() +
  geom_label(aes(label = season), hjust = .5, vjust = -.5) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

ggplot(sample, aes(x = date, y = temp, color = season)) +
  geom_point() +
  geom_text(aes(label = season), fontface = "bold", hjust = .5, vjust = -.25) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

# Non-overlapping labels using ggrepel
library(ggrepel)
ggplot(sample, aes(x = date, y = temp, color = season)) +
  geom_point() +
  geom_label_repel(aes(label = season), fontface = "bold") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

# Static annotation text
g +
  geom_text(aes(x = 25, y = 60, label = "This is a useful annotation"),
            stat = "unique", family = "Bangers", size = 7, color = "darkcyan")

# Facet-aware annotation using a separate data frame
ann <- data.frame(
  o3 = 30, temp = 20,
  season = factor("Summer", levels = levels(chic$season)),
  label = "Here is enough space\nfor some annotations."
)

g +
  geom_text(data = ann, aes(label = label), size = 7, fontface = "bold",
            family = "Roboto Condensed") +
  facet_wrap(~season)

# Annotation that stays fixed regardless of facet scales
library(grid)
my_grob <- grobTree(textGrob(
  "This text stays in place!", x = .1, y = .9, hjust = 0,
  gp = gpar(col = "black", fontsize = 15, fontface = "bold")
))

g + annotation_custom(my_grob) + facet_wrap(~season, scales = "free_x")
```

### Rich Text with `{ggtext}`

```r
library(ggtext)

# Markdown-rendered labels
lab_md <- "This plot shows **temperature** in *°F* versus **ozone level** in *ppm*"
g + geom_richtext(aes(x = 35, y = 3, label = lab_md), stat = "unique")

# HTML-rendered labels
lab_html <- "&#9733; This shows <b style='color:red;'>temperature</b> versus <b style='color:blue;'>ozone</b> &#9733;"
g + geom_richtext(aes(x = 33, y = 3, label = lab_html), stat = "unique")

# Styled text box
lab_long <- "**Lorem ipsum dolor**<br><i style='font-size:8pt;color:red;'>Lorem ipsum dolor sit amet...</i>"
g + geom_textbox(aes(x = 40, y = 10, label = lab_long), width = unit(15, "lines"), stat = "unique")
```

---

## 14. Working with Coordinates

```r
# Expand axis to include zero
ggplot(chic_high, aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  labs(x = "Temperature higher than 25°F", y = "Ozone higher than 20 ppb") +
  expand_limits(x = 0, y = 0)

# Clip off to prevent cropping points at edges
ggplot(chic_high, aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  expand_limits(x = 0, y = 0) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_cartesian(clip = "off")

# Fixed aspect ratio
ggplot(chic, aes(x = temp, y = temp + rnorm(nrow(chic), sd = 20))) +
  geom_point(color = "sienna") +
  labs(x = "Temperature (°F)", y = "Temperature (°F) + random noise") +
  xlim(c(0, 100)) + ylim(c(0, 150)) +
  coord_fixed(ratio = 1/5)

# Flip coordinates
ggplot(chic, aes(x = season, y = o3)) +
  geom_boxplot(fill = "indianred") +
  labs(x = "Season", y = "Ozone") +
  coord_flip()

# Polar coordinates (radar/pie)
chic |>
  dplyr::group_by(season) |>
  dplyr::summarize(o3 = median(o3)) |>
  ggplot(aes(x = season, y = o3)) +
  geom_col(aes(fill = season), color = NA) +
  labs(x = "", y = "Median Ozone Level") +
  coord_polar() +
  guides(fill = FALSE)

# Pie chart
ggplot(chic_sum, aes(x = "", y = rel)) +
  geom_col(aes(fill = season), width = 1, color = NA) +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Set1", name = "Season:") +
  theme(axis.ticks = element_blank(), panel.grid = element_blank())

# Reverse factor order on axis
library(forcats)
ggplot(chic, aes(x = temp, y = fct_rev(season))) +
  geom_jitter(aes(color = season), orientation = "y", show.legend = FALSE) +
  labs(x = "Temperature (°F)", y = NULL)
```

---

## 15. Working with Chart Types

```r
# Bar chart
ggplot(chic, aes(year)) +
  geom_bar(aes(fill = season), color = "grey", size = 2) +
  labs(x = "Year", y = "Observations", fill = "Season:")

# Scatter — outline shape
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(shape = 21, size = 2, stroke = 1, color = "#3cc08f", fill = "#c08f3c") +
  labs(x = "Year", y = "Temperature (°F)")

# Boxplot variants by season
g <- ggplot(chic, aes(x = season, y = o3, color = season)) +
  labs(x = "Season", y = "Ozone") +
  scale_color_brewer(palette = "Dark2", guide = "none")

g + geom_boxplot()
g + geom_jitter(width = .3, alpha = .5)
g + geom_violin(fill = "gray80", size = 1, alpha = .5)
g + geom_violin(fill = "gray80", size = 1, alpha = .5) +
  geom_jitter(alpha = .25, width = .3) + coord_flip()

# Sina plot (ggforce)
library(ggforce)
g + geom_violin(fill = "gray80", size = 1, alpha = .5) +
  geom_sina(alpha = .25) + coord_flip()

# Violin + boxplot combined
g + geom_violin(aes(fill = season), size = 1, alpha = .5) +
  geom_boxplot(outlier.alpha = 0, coef = 0, color = "gray40", width = .2) +
  scale_fill_brewer(palette = "Dark2", guide = "none") +
  coord_flip()

# Rug plot
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point(show.legend = FALSE) +
  geom_rug(sides = "r", alpha = .3, show.legend = FALSE) +
  labs(x = "Year", y = "Temperature (°F)")

# Correlation heatmap
library(tidyverse)
corm <-
  chic |>
  select(death, temp, dewpoint, pm10, o3) |>
  corrr::correlate(diagonal = 1) |>
  corrr::shave(upper = FALSE) |>
  pivot_longer(cols = -rowname, names_to = "colname", values_to = "corr") |>
  mutate(rowname = fct_inorder(rowname), colname = fct_inorder(colname))

ggplot(corm, aes(rowname, fct_rev(colname), fill = corr)) +
  geom_tile() +
  geom_text(aes(label = format(round(corr, 2), nsmall = 2), color = abs(corr) < .75)) +
  coord_fixed(expand = FALSE) +
  scale_color_manual(values = c("white", "black"), guide = "none") +
  scale_fill_distiller(palette = "PuOr", na.value = "white", direction = 1, limits = c(-1, 1)) +
  labs(x = NULL, y = NULL)

# 2D density and hex bin plots
ggplot(chic, aes(temp, o3)) +
  geom_density_2d() +
  labs(x = "Temperature (°F)", y = "Ozone Level")

ggplot(chic, aes(temp, o3)) +
  geom_hex(aes(color = ..count..)) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1) +
  scale_color_distiller(palette = "YlOrRd", direction = 1) +
  labs(x = "Temperature (°F)", y = "Ozone Level")

# Ridge plots
library(ggridges)
ggplot(chic, aes(x = temp, y = factor(year), fill = year)) +
  geom_density_ridges(alpha = .8, color = "white", scale = 2.5, rel_min_height = .01) +
  labs(x = "Temperature (°F)", y = "Year") +
  guides(fill = FALSE) +
  theme_ridges()

ggplot(chic, aes(x = temp, y = season, fill = ..x..)) +
  geom_density_ridges_gradient(scale = .9, gradient_lwd = .5, color = "black") +
  scale_fill_viridis_c(option = "plasma", name = "") +
  labs(x = "Temperature (°F)", y = "Season") +
  theme_ridges(grid = FALSE)
```

---

## 16. Working with Ribbons & Smoothings

### Ribbons & Area Charts

```r
chic$o3run <- as.numeric(stats::filter(chic$o3, rep(1/30, 30), sides = 2))

# Ribbon (fills from 0 to value)
ggplot(chic, aes(x = date, y = o3run)) +
  geom_ribbon(aes(ymin = 0, ymax = o3run), fill = "orange", alpha = .4) +
  geom_line(color = "chocolate", lwd = .8) +
  labs(x = "Year", y = "Ozone")

# Area chart (shorthand ribbon to zero)
ggplot(chic, aes(x = date, y = o3run)) +
  geom_area(color = "chocolate", lwd = .8, fill = "orange", alpha = .4) +
  labs(x = "Year", y = "Ozone")

# Confidence band (±1 SD)
chic$mino3 <- chic$o3run - sd(chic$o3run, na.rm = TRUE)
chic$maxo3 <- chic$o3run + sd(chic$o3run, na.rm = TRUE)

ggplot(chic, aes(x = date, y = o3run)) +
  geom_ribbon(aes(ymin = mino3, ymax = maxo3), alpha = .5,
              fill = "darkseagreen3", color = "transparent") +
  geom_line(color = "aquamarine4", lwd = .7) +
  labs(x = "Year", y = "Ozone")
```

### Smoothing Lines

```r
# Default GAM smooth with SE band
ggplot(chic, aes(x = date, y = temp)) +
  labs(x = "Year", y = "Temperature (°F)") +
  stat_smooth() +
  geom_point(color = "gray40", alpha = .5)

# Linear model, no SE
ggplot(chic, aes(x = temp, y = death)) +
  labs(x = "Temperature (°F)", y = "Deaths") +
  stat_smooth(method = "lm", se = FALSE, color = "firebrick", size = 1.3) +
  geom_point(color = "gray40", alpha = .5)

# Polynomial smooth
ggplot(chic, aes(x = o3, y = temp)) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5),
    color = "black", fill = "firebrick"
  ) +
  geom_point(color = "gray40", alpha = .3) +
  labs(x = "Ozone Level", y = "Temperature (°F)")

# Multiple GAM smooths with different k values
cols <- c("darkorange2", "firebrick", "dodgerblue3")

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "gray40", alpha = .3) +
  labs(x = "Year", y = "Temperature (°F)") +
  stat_smooth(aes(col = "1000"), method = "gam", formula = y ~ s(x, k = 1000), se = FALSE, size = 1.3) +
  stat_smooth(aes(col = "100"),  method = "gam", formula = y ~ s(x, k = 100),  se = FALSE, size = 1) +
  stat_smooth(aes(col = "10"),   method = "gam", formula = y ~ s(x, k = 10),   se = FALSE, size = .8) +
  scale_color_manual(name = "k", values = cols)
```

---

## 17. Working with Interactive Plots

```r
# Base ggplot for interactivity
g <- ggplot(chic, aes(date, temp)) +
  geom_line(color = "grey") +
  geom_point(aes(color = season)) +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  labs(x = NULL, y = "Temperature (°F)") +
  theme_bw()

# plotly: wrap any ggplot
library(plotly)
ggplotly(g)

# ggiraph: interactive geoms with tooltips
library(ggiraph)
g_interactive <- ggplot(chic, aes(date, temp)) +
  geom_line(color = "grey") +
  geom_point_interactive(aes(color = season, tooltip = season, data_id = season)) +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  labs(x = NULL, y = "Temperature (°F)") +
  theme_bw()

girafe(ggobj = g_interactive)

# highcharter
library(highcharter)
hchart(chic, "scatter", hcaes(x = date, y = temp, group = season))

# echarts4r
library(echarts4r)
chic |>
  e_charts(date) |>
  e_scatter(temp, symbol_size = 7) |>
  e_visual_map(temp) |>
  e_y_axis(name = "Temperature (°F)") |>
  e_legend(FALSE)

# charter
library(charter)
chic$date_num <- as.numeric(chic$date)
chart(data = chic, caes(date_num, temp)) |>
  c_scatter(caes(color = season, group = season)) |>
  c_colors(RColorBrewer::brewer.pal(4, name = "Dark2"))
```

---

## Resources

- 📘 [ggplot2 Reference](https://ggplot2.tidyverse.org/reference/)
- 🔌 [ggplot2 Extensions Gallery](https://exts.ggplot2.tidyverse.org/)
- 🎨 [R Color Names](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf)
- ✏️ [Tidyverse Style Guide](https://style.tidyverse.org)
- 📖 [The Grammar of Graphics](https://link.springer.com/chapter/10.1007/978-3-642-21551-3_13)
- 🧰 [theme() reference](https://ggplot2.tidyverse.org/reference/theme.html)

---

*Based on `DetailAnalysis.R` by [Cédric Scherer](https://www.cedricscherer.com)*
