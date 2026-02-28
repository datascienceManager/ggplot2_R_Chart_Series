# A ggplot2 Tutorial for Beautiful Plotting in R

> **Author:** Cédric Scherer ([@CedScherer](https://twitter.com/CedScherer))  
> **Source:** [cedricscherer.com](https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/)  
> **Last Updated:** 2020-12-02

This document is a fully annotated walkthrough of the `DetailAnalysis.R` script. Every section includes explanations of *what* the code does and *why* certain approaches are used, making it suitable as both a learning guide and a reference for everyday ggplot2 work.

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

Before running any code, you need to install all the required packages. This tutorial uses `{ggplot2}` at its core (loaded via the `{tidyverse}` collection) plus a wide range of extension packages that unlock additional plot types, color palettes, fonts, text rendering, and interactivity.

```r
# Install all required CRAN packages at once
install.packages(c(
  "tidyverse",    # Core data manipulation + ggplot2
  "colorspace",   # Advanced color manipulation
  "corrr",        # Correlation matrices
  "cowplot",      # Plot composition and alignment
  "ggdark",       # Dark mode themes
  "ggforce",      # Extra geoms (sina plots, etc.)
  "ggrepel",      # Non-overlapping text labels
  "ggridges",     # Ridge / joy plots
  "ggsci",        # Scientific journal color palettes
  "ggtext",       # Markdown and HTML in plot text
  "ggthemes",     # Extra themes (Economist, Tufte, etc.)
  "grid",         # Low-level graphics (grobs)
  "gridExtra",    # Arrange multiple plots
  "patchwork",    # Combine plots with intuitive operators
  "rcartocolor",  # CARTO color palettes
  "scico",        # Perceptually uniform scientific palettes
  "showtext",     # Use Google Fonts and custom fonts
  "shiny",        # Interactive web apps
  "plotly",       # Interactive charts (wraps ggplot)
  "highcharter",  # Highcharts-based interactive charts
  "echarts4r"     # Apache ECharts-based interactive charts
))

# {charter} is not on CRAN, so it must be installed directly from GitHub
devtools::install_github("JohnCoene/charter")
```

> 💡 You only need to run `install.packages()` once. After that, use `library()` to load packages in each session.

---

## 2. Loading the Dataset

The tutorial uses the **Chicago NMMAPS** (National Morbidity and Mortality Air Pollution Study) dataset, limited to the city of Chicago from 1997 to 2000. It contains daily environmental and health measurements — a rich source for demonstrating different types of visualisations.

```r
# Load data directly from GitHub using readr (part of tidyverse)
chic <- readr::read_csv("https://raw.githubusercontent.com/z3tt/ggplot-courses/main/data/chicago-nmmaps-custom.csv")

# Get a compact overview of the data structure (column names, types, sample values)
tibble::glimpse(chic)

# Preview the first 10 rows
head(chic, 10)
```

### Dataset Variables

| Column     | Type    | Description                        |
|------------|---------|------------------------------------|
| `city`     | chr     | City name (`"chic"` for Chicago)   |
| `date`     | date    | Date of observation                |
| `temp`     | dbl     | Daily temperature in °F            |
| `o3`       | dbl     | Ozone level (ppb)                  |
| `dewpoint` | dbl     | Dew point temperature              |
| `pm10`     | dbl     | Particulate matter (PM10)          |
| `season`   | chr     | Season (Winter/Spring/Summer/Autumn)|
| `yday`     | dbl     | Day of year (1–365)                |
| `month`    | chr     | Month abbreviation (Jan, Feb, …)   |
| `year`     | dbl     | Year (1997–2000)                   |

> 💡 `glimpse()` is more informative than `str()` for tibbles — it shows all columns, their types, and a few sample values in a single compact view.

---

## 3. A Default ggplot

`{ggplot2}` works by layering components onto a plot object. You start by defining the **data** and **aesthetics** (which variables map to which visual properties), then add one or more **geometry layers** to decide how the data is drawn.

```r
library(tidyverse)

# Step 1: Define the canvas — data + aesthetic mappings
# Wrapping in () immediately prints the object
(g <- ggplot(chic, aes(x = date, y = temp)))
# This creates a blank panel — no geometry has been specified yet
```

> ⚠️ `ggplot()` alone produces an empty plot. You must add a `geom_*` layer to draw anything.

```r
# Step 2: Add geometry layers

g + geom_point()               # Scatter plot — each row becomes a dot
g + geom_line()                # Line plot — connects observations in order
g + geom_line() + geom_point() # Layered — both line and points drawn together
```

> 💡 Layers are added with `+`. Order matters — later layers are drawn on top of earlier ones.

```r
# Customise point appearance directly inside geom_point()
# color: fill colour of the points
# shape: "diamond" changes the point marker shape
# size:  controls point radius
g + geom_point(color = "firebrick", shape = "diamond", size = 2)

# Combine two styled geometries — each can have its own visual properties
g + geom_point(color = "firebrick", shape = "diamond", size = 2) +
  geom_line(color = "firebrick", linetype = "dotted", size = .3)

# theme_set() changes the default theme for ALL plots in the current session
# theme_bw() gives a clean black-and-white look, removing the grey background
theme_set(theme_bw())

g + geom_point(color = "firebrick")
```

> 💡 Colors can be specified as named R colors (`"firebrick"`), hex codes (`"#b22222"`), or using `rgb()`. A full list of named R colors is available [here](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf).

---

## 4. Working with Axes

Well-labelled, legible axes are essential for any good plot. ggplot2 offers multiple ways to control axis titles, text formatting, tick marks, and numeric scales.

### 4.1 Axis Labels

There are two equivalent ways to set axis labels:

```r
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
```

### 4.2 Axis Title Styling

All text elements in ggplot2 are controlled via `theme()` using `element_text()`. You can adjust position, font size, color, and style.

```r
# vjust moves the title closer/further from the axis (vertical justification)
# Higher vjust on x pushes the title downward; on y, it pushes it away from the axis
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    axis.title.x = element_text(vjust = 0, size = 15),
    axis.title.y = element_text(vjust = 2, size = 15)
  )

# margin() is more precise than vjust — t = top, r = right, b = bottom, l = left
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
  theme(
    axis.title = element_text(color = "sienna", size = 15, face = "bold"),
    axis.title.y = element_text(face = "bold.italic")  # overrides only y
  )
```

### 4.3 Axis Text (Tick Labels)

```r
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
```

### 4.4 Axis Limits & Scale

```r
# ylim() clips the data — points outside the range are removed entirely
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ylim(c(0, 50))

# Custom label formatter using an anonymous function
# Appends " Degrees Fahrenheit" to each numeric tick value
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
```

---

## 5. Working with Titles

Plot titles, subtitles, captions, and tags all serve different communicative purposes. ggplot2 supports all of them through `labs()` and `ggtitle()`, and their appearance is controlled via `theme()`.

```r
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
  theme(plot.title = element_text(hjust = 1, size = 16, face = "bold.italic"))

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
```

### 5.1 Custom Fonts with `{showtext}`

The `{showtext}` package lets you use any Google Font (or local font) in your plots. This greatly improves typographic quality.

```r
library(showtext)

# Register fonts from Google Fonts — give them a short name for use in R
font_add_google("Playfair Display", "Playfair")  # Elegant serif font
font_add_google("Bangers", "Bangers")             # Bold display font

# Use the registered fonts in theme() via family = "..."
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(
    x = "Year", y = "Temperature (°F)",
    title    = "Temperatures in Chicago",
    subtitle = "Daily temperatures in °F from 1997 to 2001"
  ) +
  theme(
    plot.title    = element_text(family = "Bangers",  hjust = .5, size = 25),
    plot.subtitle = element_text(family = "Playfair", hjust = .5, size = 15)
  )

# Set a Google Font as the base font for ALL theme text in one call
font_add_google("Roboto Condensed", "Roboto Condensed")
theme_set(theme_bw(base_size = 12, base_family = "Roboto Condensed"))
```

---

## 6. Working with Legends

Legends are automatically generated from aesthetic mappings (color, shape, fill, etc.). ggplot2 provides extensive control over their position, appearance, and content.

### 6.1 Showing and Hiding Legends

```r
# Remove all legends — useful when the plot is self-explanatory
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

# Remove only one aesthetic's legend, keep others
# Here, color legend is removed but shape legend remains
ggplot(chic, aes(x = date, y = temp, color = season, shape = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  guides(color = "none")
```

### 6.2 Legend Title

```r
# Remove the legend title via theme()
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.title = element_blank())

# Alternatively, set it to NULL via labs() — cleaner syntax
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = NULL)
```

### 6.3 Legend Position

```r
# Move legend to the top of the plot
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "top")

# Place legend inside the plot area using relative coordinates (0–1)
# c(.15, .15) = 15% from left, 15% from bottom
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = NULL) +
  theme(
    legend.position   = c(.15, .15),
    legend.background = element_rect(fill = "transparent")  # no white box
  )

# Horizontal legend at the top using guides()
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    legend.position   = c(.5, .97),
    legend.background = element_rect(fill = "transparent")
  ) +
  guides(color = guide_legend(direction = "horizontal"))
```

### 6.4 Legend Labels and Ordering

```r
# Reorder legend by converting season to a factor with explicit levels
chic$season <- factor(chic$season, levels = c("Winter", "Spring", "Summer", "Autumn"))

# Rename legend labels with scale_color_discrete()
# Here, months are used as shorthand labels for each season
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_color_discrete("Seasons:", labels = c("Mar-May", "Jun-Aug", "Sep-Nov", "Dec-Feb")) +
  theme(legend.title = element_text(family = "Playfair", color = "chocolate", size = 14, face = 2))

# Enlarge the legend key symbols (overrides the actual geom size in the legend only)
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = NA)) +
  scale_color_discrete("Seasons:") +
  guides(color = guide_legend(override.aes = list(size = 6)))
```

### 6.5 Continuous Color Guides

```r
# guide_legend() — shows discrete swatches even for continuous scale
# guide_bins()   — groups values into binned steps
# guide_colorsteps() — shows a stepped gradient bar
ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_colorsteps())  # most compact option for continuous data
```

### 6.6 Mixed Geometry Legends

```r
# When a plot has both lines and points, the default legend may show both markers
# Use override.aes to control exactly what appears in the legend keys
ggplot(chic, aes(x = date, y = o3)) +
  geom_line(aes(color = "line")) +
  geom_point(aes(color = "points")) +
  labs(x = "Year", y = "Ozone") +
  scale_color_manual(
    name   = NULL,
    guide  = "legend",
    values = c("points" = "darkorange2", "line" = "gray")
  ) +
  guides(color = guide_legend(override.aes = list(
    linetype = c(1, 0),    # show line for "line" key, none for "points"
    shape    = c(NA, 16)   # no shape for "line" key, circle for "points"
  )))
```

---

## 7. Working with Backgrounds & Grid Lines

The `theme()` function controls every non-data element of a plot — including the panel background, grid lines, and the outer plot background.

```r
# Customise panel background (the data area) and grid line appearance
# panel.background controls the fill of the plotting area
# panel.grid.major controls the primary grid lines
# panel.grid.minor controls the secondary (lighter) grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    panel.background = element_rect(fill = "gray90"),
    panel.grid.major = element_line(color = "gray10", size = .5),
    panel.grid.minor = element_line(color = "gray70", size = .25)
  )

# Fine-grained control: set different linetype/color for x and y grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    panel.grid.major   = element_line(size = .5,  linetype = "dashed"),
    panel.grid.minor   = element_line(size = .25, linetype = "dotted"),
    panel.grid.major.x = element_line(color = "red1"),   # vertical major lines
    panel.grid.major.y = element_line(color = "blue1"),  # horizontal major lines
    panel.grid.minor.x = element_line(color = "red4"),
    panel.grid.minor.y = element_line(color = "blue4")
  )

# Remove only minor grid lines — a common choice for clean publication plots
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid.minor = element_blank())

# Remove all grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid = element_blank())

# Control break intervals manually for more or fewer grid lines
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_continuous(
    breaks       = seq(0, 100, 10),   # major grid every 10 degrees
    minor_breaks = seq(0, 100, 2.5)   # minor grid every 2.5 degrees
  )

# Change the panel border color and fill
# panel.background fill changes the interior data area
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "#1D8565", size = 2) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.background = element_rect(fill = "#64D2AA", color = "#64D2AA", size = 2))

# plot.background is the OUTER area surrounding the panel
# setting fill here colors the entire plot canvas
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(plot.background = element_rect(fill = "gray60", color = "gray30", size = 2))
```

---

## 8. Working with Margins

Plot margins control the whitespace between the plot boundary and its surroundings. The `margin()` function uses the order: **top, right, bottom, left** (clockwise from top).

```r
# unit(c(top, right, bottom, left), "cm") sets plot margins in centimetres
# Here a large left margin (8 cm) is added — useful when embedding in reports
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    plot.background = element_rect(fill = "gray60"),
    plot.margin     = unit(c(1, 3, 1, 8), "cm")
  )
```

> 💡 Margin units can be `"cm"`, `"mm"`, `"in"`, `"pt"` or `"lines"`. Using `"lines"` scales margin size relative to the font size.

---

## 9. Working with Multi-Panel Plots

Showing data in multiple panels (facets) is one of ggplot2's most powerful features. It allows side-by-side comparisons across groups without duplicating code.

### 9.1 Facet Wrap

`facet_wrap()` arranges panels in a ribbon that wraps to the next row when needed.

```r
g <- ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "orangered", alpha = .3) +
  labs(x = "Year", y = "Temperature (°F)")

# One panel per year, arranged in a single row
g + facet_wrap(~ year, nrow = 1)

# Two rows of panels
g + facet_wrap(~ year, nrow = 2)

# scales = "free" gives each panel its own axis scale
# Use when panels contain very different data ranges
g + facet_wrap(~ year, nrow = 2, scales = "free")
```

### 9.2 Facet Grid

`facet_grid()` arranges panels in a strict row × column matrix.

```r
# rows = year, columns = season
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "orangered", alpha = .3) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = "Year", y = "Temperature (°F)") +
  facet_grid(year ~ season)
```

### 9.3 Styling Facet Strip Labels

```r
# Style the strip background (the label bar at the top of each panel)
g + facet_wrap(~ year, nrow = 1, scales = "free_x") +
  theme(
    strip.text       = element_text(face = "bold", color = "chartreuse4", hjust = 0, size = 20),
    strip.background = element_rect(fill = "chartreuse3", linetype = "dotted")
  )
```

### 9.4 Highlighted Strip Labels with `{ggtext}`

`{ggtext}` allows individual strip labels to be styled differently — for example, to highlight specific years.

```r
library(ggtext)
library(rlang)

# Define a custom element that can highlight specific labels
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
    element$fill      <- element$hi.fill    %||% element$fill
    element$colour    <- element$hi.col     %||% element$colour
    element$box.colour<- element$hi.box.col %||% element$box.colour
    element$family    <- element$hi.family  %||% element$family
  }
  NextMethod()
}

# Use the custom element in theme() — year labels get a green highlighted box
g + facet_wrap(year ~ season, nrow = 4, scales = "free_x") +
  theme(
    strip.background = element_blank(),
    strip.text = element_textbox_highlight(
      family = "Playfair", size = 12, face = "bold",
      fill = "white", box.color = "chartreuse4", color = "chartreuse4",
      halign = .5, linetype = 1, r = unit(5, "pt"), width = unit(1, "npc"),
      padding = margin(5, 0, 3, 0), margin = margin(0, 1, 3, 1),
      hi.labels  = c("1997", "1998", "1999", "2000"),  # which labels to highlight
      hi.fill    = "chartreuse4",
      hi.box.col = "black",
      hi.col     = "white"
    )
  )
```

### 9.5 Combining Plots with `{patchwork}`

`{patchwork}` is the most intuitive package for assembling multiple ggplot objects. It uses simple operators: `+` for side-by-side, `/` for stacking.

```r
library(patchwork)

p1 + p2        # Side by side
p1 / p2        # Stacked (p1 on top, p2 below)
(g + p2) / p1  # Top row: g and p2; bottom row: p1

# Complex layouts can be described as a text string
# # = empty space; letters indicate which plot fills each cell
layout <- "
AABBBB#
AACCDDE
##CCDD#
##CC###
"
p2 + p1 + p1 + g + p2 + plot_layout(design = layout)

# cowplot: more control over alignment and axis matching
library(cowplot)
plot_grid(plot_grid(g, p1), p2, ncol = 1)

# gridExtra: matrix-based layout
library(gridExtra)
grid.arrange(g, p1, p2, layout_matrix = rbind(c(1, 2), c(3, 3)))
```

---

## 10. Working with Colors

Color is one of the most powerful visual channels. ggplot2 provides many built-in palettes and integrates with specialist color packages.

### 10.1 Discrete Color Scales

```r
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
```

### 10.2 Continuous Color Scales

```r
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
```

### 10.3 Advanced Color Techniques

```r
# after_scale() modifies an aesthetic AFTER the scale has been applied
# Here, inner points get an inverted version of the outer point color
library(ggdark)
ggplot(chic, aes(date, temp, color = temp)) +
  geom_point(size = 5) +
  geom_point(aes(color = temp, color = after_scale(invert_color(color))), size = 2) +
  scale_color_scico(palette = "hawaii", guide = "none") +
  labs(x = "Year", y = "Temperature (°F)")

# Derive a lighter, desaturated fill automatically from the border color
# desaturate() removes saturation; lighten() increases lightness
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

Themes control all non-data visual elements. ggplot2 ships with several built-in themes, and you can create fully custom ones.

### 11.1 Built-in Themes

```r
g + theme_bw()                                       # Black and white, clean
g + theme_bw(base_family = "Playfair")               # BW with custom font
g + theme_bw(base_size = 30, base_family = "Roboto Condensed")  # Larger text
g + theme_bw(base_line_size = 1, base_rect_size = 1) # Thicker borders

library(ggthemes)
# Economist magazine style
ga + theme_economist() + scale_color_economist(name = NULL)

# Tufte's minimal, ink-sparing style — no gridlines, no border
ggplot(chic_2000, aes(x = temp, y = o3)) + geom_point() + theme_tufte()
```

### 11.2 Creating a Full Custom Theme

A custom theme function lets you define every element once and reuse it across all plots. This is ideal for consistent branding in reports or publications.

```r
# theme_custom() inherits from theme() and sets every element explicitly
# complete = TRUE tells ggplot2 this is a fully specified theme (not an override)
theme_custom <- function(base_size = 12, base_family = "Roboto Condensed") {
  half_line <- base_size / 2
  theme(
    # Global defaults for all line, rect, and text elements
    line = element_line(color = "black", size = .5, linetype = 1, lineend = "butt"),
    rect = element_rect(fill = "white", color = "black", size = .5, linetype = 1),
    text = element_text(family = base_family, face = "plain", color = "black",
                        size = base_size, lineheight = .9),

    # Axis tick labels — slightly larger than base_size
    axis.text        = element_text(size = base_size * 1.1, color = "gray30"),
    axis.text.x      = element_text(margin = margin(t = .8 * half_line / 2), vjust = 1),
    axis.text.y      = element_text(margin = margin(r = .8 * half_line / 2), hjust = 1),

    # Axis titles — bold and larger
    axis.title.x     = element_text(margin = margin(t = half_line), vjust = 1,
                                    size = base_size * 1.3, face = "bold"),
    axis.title.y     = element_text(angle = 90, vjust = 1, margin = margin(r = half_line),
                                    size = base_size * 1.3, face = "bold"),

    # Panel styling — white background, grey border
    panel.background = element_rect(fill = "white", color = NA),
    panel.border     = element_rect(color = "gray30", fill = NA, size = .7),
    panel.grid.major = element_line(color = "gray90", size = 1),
    panel.grid.minor = element_line(color = "gray90", size = .5, linetype = "dashed"),

    # Plot title — large, centred, bold
    plot.title       = element_text(size = base_size * 1.8, hjust = .5, vjust = 1,
                                    face = "bold", margin = margin(b = half_line * 1.2)),
    plot.subtitle    = element_text(size = base_size * 1.3, hjust = .5, vjust = 1,
                                    margin = margin(b = half_line * .9)),
    plot.caption     = element_text(size = rel(0.9), hjust = 1, vjust = 1,
                                    margin = margin(t = half_line * .9)),
    plot.margin      = margin(base_size, base_size, base_size, base_size),
    complete = TRUE
  )
}

# Activate the custom theme globally
theme_set(theme_custom())

# theme_update() modifies specific elements of the current global theme
# without redefining it entirely — useful for quick adjustments
theme_custom <- theme_update(panel.background = element_rect(fill = "gray60"))
```

---

## 12. Working with Lines

Reference lines help readers interpret data by anchoring specific values (means, medians, thresholds). ggplot2 provides several geoms for lines, segments, and curves.

```r
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

# geom_abline(): draw a line using intercept and slope (e.g., regression line)
reg <- lm(dewpoint ~ temp, data = chic)
g +
  geom_abline(
    intercept = coefficients(reg)[1],
    slope     = coefficients(reg)[2],
    color = "darkorange2", size = 1.5
  ) +
  labs(title = paste0("y = ", round(coefficients(reg)[2], 2),
                      " * x + ", round(coefficients(reg)[1], 2)))

# geom_linerange(): vertical or horizontal line segments between two points
# Useful for error bars, ranges, or whiskers
g +
  geom_linerange(aes(x = 50, ymin = 20, ymax = 55), color = "steelblue", size = 2) +
  geom_linerange(aes(xmin = -Inf, xmax = 25, y = 0), color = "red", size = 1)

# geom_segment(): draws a line from (x, y) to (xend, yend)
g +
  geom_segment(aes(x = 50, xend = 75, y = 20, yend = 45), color = "purple", size = 2)

# geom_curve(): like geom_segment but draws a curved arc
# arrow = arrow() adds an arrowhead — useful for annotation pointers
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

Adding labels and annotations directly to a plot is far more effective than relying solely on a legend or caption.

### 13.1 Labels and Text

```r
set.seed(2020)
library(dplyr)

# Sample ~1% of observations per season for readable labeling
sample <- chic |>
  dplyr::group_by(season) |>
  dplyr::sample_frac(0.01)

# geom_label(): draws text inside a solid rectangular box
ggplot(sample, aes(x = date, y = temp, color = season)) +
  geom_point() +
  geom_label(aes(label = season), hjust = .5, vjust = -.5) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

# geom_text(): draws plain text without a box
ggplot(sample, aes(x = date, y = temp, color = season)) +
  geom_point() +
  geom_text(aes(label = season), fontface = "bold", hjust = .5, vjust = -.25) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")
```

### 13.2 Non-Overlapping Labels with `{ggrepel}`

`{ggrepel}` automatically moves labels so they don't overlap each other or their data points, connected by a small line.

```r
library(ggrepel)

ggplot(sample, aes(x = date, y = temp, color = season)) +
  geom_point() +
  geom_label_repel(aes(label = season), fontface = "bold") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

# Combine background data (grey) with highlighted sample points and repelled labels
ggplot(sample, aes(x = date, y = temp)) +
  geom_point(data = chic, size = .5) +           # all data in grey
  geom_point(aes(color = season), size = 1.5) +  # sample points in color
  geom_label_repel(aes(label = season, fill = season),
                   color = "white", fontface = "bold", segment.color = "grey30") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")
```

### 13.3 Fixed Annotations

```r
g <- ggplot(chic, aes(x = temp, y = dewpoint)) +
  geom_point(alpha = .5) +
  labs(x = "Temperature (°F)", y = "Dewpoint")

# stat = "unique" ensures the label is drawn only once (not once per data point)
g +
  geom_text(aes(x = 25, y = 60, label = "This is a useful annotation"),
            stat = "unique", family = "Bangers", size = 7, color = "darkcyan")

# For faceted plots, use a separate annotation data frame
# The season column must match the facet variable so each panel gets its label
ann <- data.frame(
  o3 = 30, temp = 20,
  season = factor("Summer", levels = levels(chic$season)),
  label  = "Here is enough space\nfor some annotations."
)

ggplot(chic, aes(x = o3, y = temp)) +
  geom_point() +
  labs(x = "Ozone", y = "Temperature (°F)") +
  geom_text(data = ann, aes(label = label), size = 7, fontface = "bold",
            family = "Roboto Condensed") +
  facet_wrap(~season)

# annotation_custom() + grid::grobTree() places a label at fixed RELATIVE coordinates
# (0–1 scale), so it stays in the same position regardless of facet axis scales
library(grid)
my_grob <- grobTree(textGrob(
  "This text stays in place!", x = .1, y = .9, hjust = 0,
  gp = gpar(col = "black", fontsize = 15, fontface = "bold")
))

g + annotation_custom(my_grob) + facet_wrap(~season, scales = "free_x")
```

### 13.4 Rich Text with `{ggtext}`

`{ggtext}` enables **Markdown** and **HTML** formatting inside plot text — bold, italic, colors, and more.

```r
library(ggtext)

# geom_richtext() renders Markdown syntax (**bold**, *italic*)
lab_md <- "This plot shows **temperature** in *°F* versus **ozone level** in *ppm*"
g + geom_richtext(aes(x = 35, y = 3, label = lab_md), stat = "unique")

# HTML tags give even finer control — inline colors, font sizes, symbols
lab_html <- "&#9733; Shows <b style='color:red;'>temperature</b> vs <b style='color:blue;'>ozone</b> &#9733;"
g + geom_richtext(aes(x = 33, y = 3, label = lab_html), stat = "unique")

# geom_textbox() wraps long text into a box with automatic line breaking
lab_long <- "**Lorem ipsum dolor**<br><i style='font-size:8pt;color:red;'>Lorem ipsum dolor sit amet, consectetur adipiscing elit...</i>"
g + geom_textbox(aes(x = 40, y = 10, label = lab_long), width = unit(15, "lines"), stat = "unique")
```

---

## 14. Working with Coordinates

Coordinate systems transform how data coordinates map onto the physical plane of the plot.

```r
# expand_limits() extends the axis to include a specific value
# without clipping data — useful when you want the origin visible
ggplot(chic_high, aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  labs(x = "Temperature > 25°F", y = "Ozone > 20 ppb") +
  expand_limits(x = 0, y = 0)

# coord_cartesian(clip = "off") prevents ggplot from clipping points
# that sit exactly on the axis boundary
ggplot(chic_high, aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  expand_limits(x = 0, y = 0) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_cartesian(clip = "off")

# coord_fixed() enforces a fixed aspect ratio between x and y axes
# ratio = 1 means 1 unit on x = 1 unit on y (true square)
# ratio = 1/5 means 1 unit on y = 5 units on x
ggplot(chic, aes(x = temp, y = temp + rnorm(nrow(chic), sd = 20))) +
  geom_point(color = "sienna") +
  labs(x = "Temperature (°F)", y = "Temperature + noise") +
  xlim(c(0, 100)) + ylim(c(0, 150)) +
  coord_fixed(ratio = 1/5)

# coord_flip() rotates the entire plot 90 degrees — swaps x and y
# Particularly useful for horizontal bar charts and boxplots
ggplot(chic, aes(x = season, y = o3)) +
  geom_boxplot(fill = "indianred") +
  labs(x = "Season", y = "Ozone") +
  coord_flip()

# coord_polar() maps Cartesian coordinates to polar (radial) space
# Creates radar charts, rose charts, or — with theta = "y" — pie charts
chic |>
  dplyr::group_by(season) |>
  dplyr::summarize(o3 = median(o3)) |>
  ggplot(aes(x = season, y = o3)) +
  geom_col(aes(fill = season), color = NA) +
  labs(x = "", y = "Median Ozone Level") +
  coord_polar() +
  guides(fill = FALSE)

# Pie chart: coord_polar(theta = "y") maps the y aesthetic to the angle
ggplot(chic_sum, aes(x = "", y = rel)) +
  geom_col(aes(fill = season), width = 1, color = NA) +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Set1", name = "Season:") +
  theme(axis.ticks = element_blank(), panel.grid = element_blank())

# fct_rev() reverses the order of factor levels on the axis
library(forcats)
ggplot(chic, aes(x = temp, y = fct_rev(season))) +
  geom_jitter(aes(color = season), orientation = "y", show.legend = FALSE) +
  labs(x = "Temperature (°F)", y = NULL)
```

---

## 15. Working with Chart Types

ggplot2 supports a rich library of `geom_*` functions for different chart types. Here are some of the most useful.

### 15.1 Bar and Point Charts

```r
# Stacked bar chart — geom_bar() counts rows per group by default
ggplot(chic, aes(year)) +
  geom_bar(aes(fill = season), color = "grey", size = 2) +
  labs(x = "Year", y = "Observations", fill = "Season:")

# shape = 21 uses a filled circle with a separate border color
# stroke controls the border thickness
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(shape = 21, size = 2, stroke = 1, color = "#3cc08f", fill = "#c08f3c") +
  labs(x = "Year", y = "Temperature (°F)")
```

### 15.2 Distribution Charts

```r
g <- ggplot(chic, aes(x = season, y = o3, color = season)) +
  labs(x = "Season", y = "Ozone") +
  scale_color_brewer(palette = "Dark2", guide = "none")

g + geom_boxplot()                           # Shows median, IQR, whiskers, outliers
g + geom_jitter(width = .3, alpha = .5)      # Raw points with horizontal jitter to avoid overplotting
g + geom_violin(fill = "gray80", size = 1, alpha = .5)  # Shows full density distribution shape

# Violin + jitter: density shape + raw data together
g + geom_violin(fill = "gray80", size = 1, alpha = .5) +
  geom_jitter(alpha = .25, width = .3) + coord_flip()

# Sina plot (ggforce): like a violin but with actual data points shaped to density
library(ggforce)
g + geom_violin(fill = "gray80", size = 1, alpha = .5) +
  geom_sina(alpha = .25) + coord_flip()

# Violin + boxplot: best of both worlds — shape + summary statistics
g + geom_violin(aes(fill = season), size = 1, alpha = .5) +
  geom_boxplot(outlier.alpha = 0, coef = 0, color = "gray40", width = .2) +
  scale_fill_brewer(palette = "Dark2", guide = "none") +
  coord_flip()
```

### 15.3 Rug Plots

A rug plot adds a 1D density strip along one axis to show data distribution without taking up much space.

```r
# sides = "r" places the rug on the right side of the y-axis only
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point(show.legend = FALSE) +
  geom_rug(sides = "r", alpha = .3, show.legend = FALSE) +
  labs(x = "Year", y = "Temperature (°F)")
```

### 15.4 Correlation Heatmap

```r
library(tidyverse)

# Step 1: compute the lower triangle of the correlation matrix
corm <-
  chic |>
  select(death, temp, dewpoint, pm10, o3) |>
  corrr::correlate(diagonal = 1) |>    # compute all pairwise correlations
  corrr::shave(upper = FALSE) |>       # keep only the lower triangle
  pivot_longer(cols = -rowname, names_to = "colname", values_to = "corr") |>
  mutate(rowname = fct_inorder(rowname), colname = fct_inorder(colname))

# Step 2: draw tiles with correlation values
# abs(corr) < .75 determines whether to print white or black text for contrast
ggplot(corm, aes(rowname, fct_rev(colname), fill = corr)) +
  geom_tile() +
  geom_text(aes(label = format(round(corr, 2), nsmall = 2), color = abs(corr) < .75)) +
  coord_fixed(expand = FALSE) +
  scale_color_manual(values = c("white", "black"), guide = "none") +
  scale_fill_distiller(palette = "PuOr", na.value = "white", direction = 1, limits = c(-1, 1)) +
  labs(x = NULL, y = NULL)
```

### 15.5 Density and Hex Bin Plots

```r
# 2D contour density lines
ggplot(chic, aes(temp, o3)) +
  geom_density_2d() +
  labs(x = "Temperature (°F)", y = "Ozone Level")

# Hex binning — groups nearby points into hexagonal bins, colored by count
# Ideal for large datasets where individual points would overlap
ggplot(chic, aes(temp, o3)) +
  geom_hex(aes(color = ..count..)) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1) +
  scale_color_distiller(palette = "YlOrRd", direction = 1) +
  labs(x = "Temperature (°F)", y = "Ozone Level")
```

### 15.6 Ridge Plots

Ridge plots (from `{ggridges}`) show overlapping density curves for multiple groups — ideal for comparing distributions across categories or time periods.

```r
library(ggridges)

# Basic ridgeline plot
ggplot(chic, aes(x = temp, y = factor(year), fill = year)) +
  geom_density_ridges(alpha = .8, color = "white", scale = 2.5, rel_min_height = .01) +
  labs(x = "Temperature (°F)", y = "Year") +
  guides(fill = FALSE) +
  theme_ridges()

# Gradient fill — color varies along x, showing both shape and value
ggplot(chic, aes(x = temp, y = season, fill = ..x..)) +
  geom_density_ridges_gradient(scale = .9, gradient_lwd = .5, color = "black") +
  scale_fill_viridis_c(option = "plasma", name = "") +
  labs(x = "Temperature (°F)", y = "Season") +
  theme_ridges(grid = FALSE)
```

---

## 16. Working with Ribbons & Smoothings

### 16.1 Ribbons and Area Charts

Ribbons fill the area between two y values (`ymin` and `ymax`), making them perfect for showing uncertainty bands or cumulative totals.

```r
# Compute a 30-day running average of ozone using a moving average filter
chic$o3run <- as.numeric(stats::filter(chic$o3, rep(1/30, 30), sides = 2))

# geom_ribbon() fills between ymin and ymax
# alpha makes it semi-transparent so the line remains visible
ggplot(chic, aes(x = date, y = o3run)) +
  geom_ribbon(aes(ymin = 0, ymax = o3run), fill = "orange", alpha = .4) +
  geom_line(color = "chocolate", lwd = .8) +
  labs(x = "Year", y = "Ozone")

# geom_area() is shorthand for geom_ribbon(ymin = 0) — fills from zero to the value
ggplot(chic, aes(x = date, y = o3run)) +
  geom_area(color = "chocolate", lwd = .8, fill = "orange", alpha = .4) +
  labs(x = "Year", y = "Ozone")

# Confidence band: ribbon between mean ± 1 SD shows measurement uncertainty
chic$mino3 <- chic$o3run - sd(chic$o3run, na.rm = TRUE)
chic$maxo3 <- chic$o3run + sd(chic$o3run, na.rm = TRUE)

ggplot(chic, aes(x = date, y = o3run)) +
  geom_ribbon(aes(ymin = mino3, ymax = maxo3), alpha = .5,
              fill = "darkseagreen3", color = "transparent") +
  geom_line(color = "aquamarine4", lwd = .7) +
  labs(x = "Year", y = "Ozone")
```

### 16.2 Smoothing Lines

Smooth trend lines help reveal underlying patterns in noisy data.

```r
# stat_smooth() / geom_smooth() fits a flexible curve through the data
# Default method is GAM (Generalized Additive Model) for n > 1000
ggplot(chic, aes(x = date, y = temp)) +
  labs(x = "Year", y = "Temperature (°F)") +
  stat_smooth() +            # adds shaded confidence interval by default
  geom_point(color = "gray40", alpha = .5)

# method = "lm" fits a straight linear regression line
# se = FALSE removes the confidence band
ggplot(chic, aes(x = temp, y = death)) +
  labs(x = "Temperature (°F)", y = "Deaths") +
  stat_smooth(method = "lm", se = FALSE, color = "firebrick", size = 1.3) +
  geom_point(color = "gray40", alpha = .5)

# Polynomial smooth: I(x^n) adds polynomial terms to the formula
# Higher degrees allow more wiggly fits
ggplot(chic, aes(x = o3, y = temp)) +
  geom_smooth(
    method  = "lm",
    formula = y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5),
    color   = "black", fill = "firebrick"
  ) +
  geom_point(color = "gray40", alpha = .3) +
  labs(x = "Ozone Level", y = "Temperature (°F)")

# Compare GAM smooths with different complexity (k = number of basis functions)
# Higher k = more flexible curve; lower k = smoother, more generalised
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

Interactive plots allow readers to explore data themselves — hovering for values, zooming, filtering by group. Several R packages wrap ggplot2 objects into interactive HTML widgets.

```r
# First, build a standard ggplot to use as a base
g <- ggplot(chic, aes(date, temp)) +
  geom_line(color = "grey") +
  geom_point(aes(color = season)) +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  labs(x = NULL, y = "Temperature (°F)") +
  theme_bw()
```

### 17.1 `{plotly}` — Instant Interactivity

```r
library(plotly)
# ggplotly() wraps ANY ggplot object into an interactive HTML widget
# Users can hover, zoom, pan, and click to highlight series
ggplotly(g)
```

### 17.2 `{ggiraph}` — Fine-grained Tooltips

```r
library(ggiraph)
# ggiraph uses _interactive versions of geoms (e.g. geom_point_interactive)
# tooltip = the text shown on hover; data_id = used for linked highlighting
g_interactive <- ggplot(chic, aes(date, temp)) +
  geom_line(color = "grey") +
  geom_point_interactive(aes(color = season, tooltip = season, data_id = season)) +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  labs(x = NULL, y = "Temperature (°F)") +
  theme_bw()

girafe(ggobj = g_interactive)  # renders the interactive SVG widget
```

### 17.3 `{highcharter}` — Highcharts Integration

```r
library(highcharter)
# hchart() creates a Highcharts chart directly from a data frame
# group = season automatically creates a separate series per season
hchart(chic, "scatter", hcaes(x = date, y = temp, group = season))
```

### 17.4 `{echarts4r}` — Apache ECharts

```r
library(echarts4r)
# Pipe-based API: start with data, add chart layers step by step
chic |>
  e_charts(date) |>                    # set x axis
  e_scatter(temp, symbol_size = 7) |>  # add scatter layer
  e_visual_map(temp) |>                # add a color legend mapped to temp
  e_y_axis(name = "Temperature (°F)") |>
  e_legend(FALSE)
```

### 17.5 `{charter}` — Chart.js Wrapper

```r
library(charter)
# Dates must be converted to numeric — charter doesn't handle date class directly
chic$date_num <- as.numeric(chic$date)

chart(data = chic, caes(date_num, temp)) |>
  c_scatter(caes(color = season, group = season)) |>
  c_colors(RColorBrewer::brewer.pal(4, name = "Dark2"))
```

---

## Resources

| Resource | Link |
|---|---|
| ggplot2 Reference | [ggplot2.tidyverse.org/reference](https://ggplot2.tidyverse.org/reference/) |
| ggplot2 Extensions Gallery | [exts.ggplot2.tidyverse.org](https://exts.ggplot2.tidyverse.org/) |
| R Color Names | [stat.columbia.edu](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf) |
| Tidyverse Style Guide | [style.tidyverse.org](https://style.tidyverse.org) |
| The Grammar of Graphics | [Springer](https://link.springer.com/chapter/10.1007/978-3-642-21551-3_13) |
| theme() Reference | [ggplot2.tidyverse.org/reference/theme](https://ggplot2.tidyverse.org/reference/theme.html) |
| showtext Fonts | [Google Fonts](https://fonts.google.com) |

---

*Based on `DetailAnalysis.R` by [Cédric Scherer](https://www.cedricscherer.com). Annotations and explanations added for educational use.*
