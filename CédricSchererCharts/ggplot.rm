# A ggplot2 Tutorial for Beautiful Plotting in R

> **Author:** Cédric Scherer  
> **Original Post:** [cedricscherer.com](https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/)  
> **Last Updated:** 2023-05-05

---

## Overview

A comprehensive tutorial for creating beautiful, publication-ready plots in R using `{ggplot2}`. Originally inspired by Zev Ross's *Beautiful plotting in R: A ggplot2 cheatsheet*, this guide has been significantly expanded to cover modern packages, chart types, and best practices.

---

## Table of Contents

1. [Preparation](#preparation)
2. [The Dataset](#the-dataset)
3. [The {ggplot2} Package](#the-ggplot2-package)
4. [A Default ggplot](#a-default-ggplot)
5. [Working with Axes](#working-with-axes)
6. [Working with Titles](#working-with-titles)
7. [Working with Legends](#working-with-legends)
8. [Working with Backgrounds & Grid Lines](#working-with-backgrounds--grid-lines)
9. [Working with Margins](#working-with-margins)
10. [Working with Multi-Panel Plots](#working-with-multi-panel-plots)
11. [Working with Colors](#working-with-colors)
12. [Working with Themes](#working-with-themes)
13. [Working with Lines](#working-with-lines)
14. [Working with Text](#working-with-text)
15. [Working with Coordinates](#working-with-coordinates)
16. [Working with Chart Types](#working-with-chart-types)
17. [Working with Ribbons (AUC, CI, etc.)](#working-with-ribbons)
18. [Working with Smoothings](#working-with-smoothings)
19. [Working with Interactive Plots](#working-with-interactive-plots)
20. [Remarks, Tips & Resources](#remarks-tips--resources)

---

## Preparation

### Source Files

- **RMarkdown script:** [GitHub](https://github.com/Z3tt/Z3tt/blob/master/content/post/2019-08-05_ggplot2-tutorial.Rmd)
- **R script (code only):** [Download](https://www.cedricscherer.com/codes/ggplot-tutorial-cedric-raw.R)

### Install Required Packages

```r
# Install CRAN packages
install.packages(
  c("ggplot2", "tibble", "tidyr", "forcats", "purrr", "prismatic", "corrr", 
    "cowplot", "ggforce", "ggrepel", "ggridges", "ggsci", "ggtext", "ggthemes", 
    "grid", "gridExtra", "patchwork", "rcartocolor", "scico", "showtext", 
    "shiny", "plotly", "highcharter", "echarts4r")
)

# Install from GitHub (not on CRAN)
install.packages("devtools")
devtools::install_github("JohnCoene/charter")
```

### Package Summary

| Package | Purpose |
|---|---|
| `{ggplot2}` / `{tidyverse}` | Core plotting |
| `{dplyr}`, `{tibble}`, `{tidyr}`, `{forcats}` | Data wrangling |
| `{patchwork}` | Multi-panel plots |
| `{ggtext}` | Advanced text rendering |
| `{ggrepel}` | Non-overlapping text labels |
| `{ggforce}` | Sina plots and extras |
| `{ggridges}` | Ridge/joy plots |
| `{ggsci}`, `{rcartocolor}`, `{scico}` | Color palettes |
| `{showtext}` | Custom fonts |
| `{cowplot}`, `{gridExtra}` | Plot composition |
| `{corrr}` | Correlation matrices |
| `{prismatic}` | Color manipulation |
| `{plotly}`, `{highcharter}`, `{echarts4r}`, `{ggiraph}` | Interactive charts |
| `{shiny}` | Interactive apps |

---

## The Dataset

This tutorial uses data from the **National Morbidity and Mortality Air Pollution Study (NMMAPS)**, limited to **Chicago, 1997–2000**.

```r
chic <- readr::read_csv("https://cedricscherer.com/data/chicago-nmmaps-custom.csv")
```

### Variables

| Column | Type | Description |
|---|---|---|
| `city` | chr | City name (`"chic"`) |
| `date` | date | Date of observation |
| `temp` | dbl | Temperature (°F) |
| `o3` | dbl | Ozone level |
| `dewpoint` | dbl | Dew point |
| `pm10` | dbl | Particulate matter (PM10) |
| `season` | chr | Season (Winter/Spring/Summer/Fall) |
| `yday` | dbl | Day of year |
| `month` | chr | Month abbreviation |
| `year` | dbl | Year |

---

## The {ggplot2} Package

> *"ggplot2 is a system for declaratively creating graphics, based on The Grammar of Graphics. You provide the data, tell ggplot2 how to map variables to aesthetics, what graphical primitives to use, and it takes care of the details."*

### Core Elements

1. **Data** — the raw data to plot
2. **Geometries** (`geom_*`) — shapes that represent the data
3. **Aesthetics** (`aes()`) — position, color, size, shape, transparency
4. **Scales** (`scale_*`) — maps data to aesthetic dimensions
5. **Statistical transformations** (`stat_*`) — summaries like quantiles and fitted curves
6. **Coordinate system** (`coord_*`) — transformation for data mapping
7. **Facets** (`facet_*`) — grid arrangement of plots
8. **Visual themes** (`theme()`) — background, grids, fonts, colors

---

## A Default ggplot

```r
library(ggplot2)

# Define the base plot
(g <- ggplot(chic, aes(x = date, y = temp)))

# Add geometries
g + geom_point()                          # Scatter plot
g + geom_line()                           # Line plot
g + geom_line() + geom_point()            # Combined

# Customize geometry properties
g + geom_point(color = "firebrick", shape = "diamond", size = 2)

# Set a global theme
theme_set(theme_bw())
```

> 💡 **Tip:** Wrapping an assignment in `()` prints the object immediately: `(g <- ggplot(...))`.

---

## Working with Axes

```r
# Change axis labels
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)")

# Use superscripts/symbols in axis labels
labs(x = "Year", y = expression(paste("Temperature (", degree ~ F, ")")))

# Limit axis range
scale_x_date(limits = as.Date(c("1997-01-01", "1999-12-31")))
scale_y_continuous(limits = c(-20, 100))

# Reverse axis
scale_y_reverse()

# Format axis ticks
scale_y_continuous(breaks = seq(-20, 100, by = 20), labels = function(x) paste0(x, "°F"))
```

---

## Key Concepts

### Color Specification

Colors can be specified as:
- Named colors: `"firebrick"`, `"steelblue"` — see [full list](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf)
- Hex codes: `"#b22222"`
- RGB: `rgb(178, 34, 34, maxColorValue = 255)`

### Theme Customization

```r
# Apply built-in themes
theme_set(theme_bw())      # Black and white
theme_set(theme_minimal()) # Minimal
theme_set(theme_classic()) # Classic

# Customize individual elements
theme(
  axis.title = element_text(size = 14, face = "bold"),
  legend.position = "bottom",
  panel.grid.minor = element_blank()
)
```

### Multi-Panel Plots

```r
library(patchwork)
p1 + p2          # Side by side
p1 / p2          # Stacked
(p1 + p2) / p3   # Combined layout

# Or use faceting
facet_wrap(~season)
facet_grid(year ~ season)
```

---

## Resources

- 📘 [ggplot2 Reference](https://ggplot2.tidyverse.org/reference/)
- 🔌 [ggplot2 Extensions](https://exts.ggplot2.tidyverse.org/)
- 🎨 [R Color Palette](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf)
- 📖 [Statistical Methods in Environmental Epidemiology with R](http://www.springer.com/de/book/9780387781662)
- ✏️ [Tidyverse Style Guide](https://style.tidyverse.org)

---

*Based on the tutorial by [Cédric Scherer](https://www.cedricscherer.com). Original inspiration from Zev Ross's [Beautiful plotting in R: A ggplot2 cheatsheet](http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/).*
