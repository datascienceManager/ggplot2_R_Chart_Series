`ggplot2` is based on the **Grammar of Graphics**, a framework that treats every plot as a combination of independent layers. Instead of calling a single function for a specific chart type, you build a plot piece by piece.

---

## 1. The Core Philosophy (The Layers)
To create any plot, you need three essential components:
1.  **Data:** The dataframe containing your variables.
2.  **Aesthetics (`aes`):** The mapping between data variables and visual properties (x-axis, y-axis, color, size).
3.  **Geometries (`geom`):** The actual marks on the plot (points, lines, bars).



---

## 2. The Basic Template
The most basic syntax looks like this:

```r
library(ggplot2)

ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point()
```

* `ggplot()` initializes the coordinate system.
* `aes()` tells R that `displ` (engine size) goes on the x-axis and `hwy` (fuel efficiency) goes on the y-axis.
* `geom_point()` adds a layer of points (a scatterplot).

---

## 3. Intermediate: Adding Dimensions and Statistics
Once you have the basics, you can start manipulating how the data is interpreted.

### Color and Shape Mapping
You can map categorical variables to colors or shapes inside `aes()`:
```r
ggplot(mpg, aes(x = displ, y = hwy, color = class)) + 
  geom_point()
```

### Statistical Transformations
Some geoms calculate new values. For example, `geom_bar` counts the number of occurrences, and `geom_smooth` calculates a trend line (like linear regression).



### Faceting (Small Multiples)
Faceting splits your plot into multiple subplots based on a category:
* `facet_wrap(~ variable)`: Wraps a 1D ribbon of panels into 2D.
* `facet_grid(rows ~ cols)`: Creates a grid based on two variables.

---

## 4. Advanced: Customization and Polishing
Advanced usage involves fine-tuning the non-data components of the plot to make it "publication-ready."

### Scales and Guides
Scales control how data values are translated into visual space. You use them to change colors or axis breaks.
```r
ggplot(mpg, aes(x = displ, y = hwy, color = displ)) +
  geom_point() +
  scale_color_gradient(low = "blue", high = "red")
```

### Themes
Themes handle everything not related to the data: fonts, background colors, and grid lines.
* `theme_minimal()`: A clean, modern look.
* `theme_classic()`: No grid lines, looks like a standard scientific plot.
* `theme()`: Use this for granular control (e.g., `theme(axis.text.x = element_text(angle = 45))`).

### Coordinate Systems
You can switch from Cartesian coordinates to others:
* `coord_flip()`: Swaps X and Y (great for long horizontal labels).
* `coord_polar()`: Turns a bar chart into a pie or bullseye chart.

---

## Summary Table: Common Geoms
| Goal | Geom |
| :--- | :--- |
| **Trends** | `geom_line()`, `geom_smooth()` |
| **Distribution** | `geom_histogram()`, `geom_density()`, `geom_boxplot()` |
| **Amounts** | `geom_bar()`, `geom_col()` |
| **Relationships** | `geom_point()`, `geom_jitter()`, `geom_bin2d()` |



Moving into the advanced territory of `ggplot2` means moving away from "plotting data" and toward "designing a visualization." Advanced users focus on the **Scale system**, **Custom Annotations**, and **Theme inheritance**.

---

## 1. Mastering the Scale System
Scales control how data values are mapped to aesthetic properties. While `ggplot2` adds default scales, advanced users override them to control color palettes, log transformations, or custom axis labels.

### Example: Logarithmic Scaling and Custom Colors
Using the `viridis` palette (colorblind friendly) and transforming the axis without changing the underlying data.

```r
library(ggplot2)
library(viridis)

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, size = pop, color = continent)) +
  geom_point(alpha = 0.7) +
  scale_x_log10(labels = scales::dollar) + # Custom labels for currency
  scale_color_viridis_d(option = "plasma") + # Discrete viridis scale
  scale_size(range = c(1, 15), guide = "none") # Rescaling point sizes
```



---

## 2. Advanced Annotations and Highlighting
A plot is more effective when it tells a story. Instead of letting the viewer find the trend, you can highlight specific data points or regions.

### Example: Highlighting a Specific Subset
You can use a "shadow" layer to show the background data while highlighting a specific group.

```r
library(dplyr)

# Create a background dataset without the grouping variable
bg_data <- select(mpg, -class)

ggplot(mpg, aes(x = displ, y = hwy)) +
  # Layer 1: All points in light gray
  geom_point(data = bg_data, color = "grey80", alpha = 0.5) +
  # Layer 2: Highlighted points for 'suv'
  geom_point(data = filter(mpg, class == "suv"), color = "firebrick") +
  # Layer 3: Text annotation
  annotate("text", x = 6, y = 40, label = "SUVs show lower\nfuel efficiency", 
           color = "firebrick", fontface = "bold", hjust = 1) +
  theme_minimal()
```

---

## 3. The Power of `theme()`
The `theme()` function allows for pixel-perfect control. It uses "element" functions to define styles:
* `element_text()`: Font, color, size, angle.
* `element_line()`: Color, thickness, linetype.
* `element_rect()`: Background colors, borders.
* `element_blank()`: Completely removes the element.

### Example: Creating a "Dark Mode" Publication Theme
```r
ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar() +
  theme(
    panel.background = element_rect(fill = "#2D2D2D"),
    plot.background = element_rect(fill = "#2D2D2D"),
    panel.grid.major = element_line(color = "grey30"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "white"),
    axis.title = element_text(color = "white", face = "bold"),
    legend.background = element_blank(),
    legend.text = element_text(color = "white")
  )
```



---

## 4. Multi-Plot Composition (Patchwork)
Advanced users rarely rely on `facet_wrap` alone. The `patchwork` library is the gold standard for combining entirely different types of plots into one graphic.

```r
library(patchwork)

p1 <- ggplot(mpg, aes(displ, hwy)) + geom_point()
p2 <- ggplot(mpg, aes(class)) + geom_bar()

# Use math operators to align plots!
(p1 + p2) / p1 + 
  plot_annotation(title = "Combined Vehicle Analysis", tag_levels = 'A')
```

---

## Advanced Summary Checklist
| Feature | Advanced Implementation |
| :--- | :--- |
| **Labels** | Use the `ggrepel` package to prevent text labels from overlapping. |
| **Interactivity** | Wrap a ggplot in `plotly::ggplotly()` for instant tooltips. |
| **Custom Geoms** | Use `geom_sf()` for specialized geospatial (map) data. |
| **Extensions** | Explore `gganimate` for transitions or `ggdist` for uncertainty. |







Moving into the advanced territory of `ggplot2` means moving away from "plotting data" and toward "designing a visualization." Advanced users focus on the **Scale system**, **Custom Annotations**, and **Theme inheritance**.

---

## 1. Mastering the Scale System
Scales control how data values are mapped to aesthetic properties. While `ggplot2` adds default scales, advanced users override them to control color palettes, log transformations, or custom axis labels.

### Example: Logarithmic Scaling and Custom Colors
Using the `viridis` palette (colorblind friendly) and transforming the axis without changing the underlying data.

```r
library(ggplot2)
library(viridis)

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, size = pop, color = continent)) +
  geom_point(alpha = 0.7) +
  scale_x_log10(labels = scales::dollar) + # Custom labels for currency
  scale_color_viridis_d(option = "plasma") + # Discrete viridis scale
  scale_size(range = c(1, 15), guide = "none") # Rescaling point sizes
```



---

## 2. Advanced Annotations and Highlighting
A plot is more effective when it tells a story. Instead of letting the viewer find the trend, you can highlight specific data points or regions.

### Example: Highlighting a Specific Subset
You can use a "shadow" layer to show the background data while highlighting a specific group.

```r
library(dplyr)

# Create a background dataset without the grouping variable
bg_data <- select(mpg, -class)

ggplot(mpg, aes(x = displ, y = hwy)) +
  # Layer 1: All points in light gray
  geom_point(data = bg_data, color = "grey80", alpha = 0.5) +
  # Layer 2: Highlighted points for 'suv'
  geom_point(data = filter(mpg, class == "suv"), color = "firebrick") +
  # Layer 3: Text annotation
  annotate("text", x = 6, y = 40, label = "SUVs show lower\nfuel efficiency", 
           color = "firebrick", fontface = "bold", hjust = 1) +
  theme_minimal()
```

---

## 3. The Power of `theme()`
The `theme()` function allows for pixel-perfect control. It uses "element" functions to define styles:
* `element_text()`: Font, color, size, angle.
* `element_line()`: Color, thickness, linetype.
* `element_rect()`: Background colors, borders.
* `element_blank()`: Completely removes the element.

### Example: Creating a "Dark Mode" Publication Theme
```r
ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar() +
  theme(
    panel.background = element_rect(fill = "#2D2D2D"),
    plot.background = element_rect(fill = "#2D2D2D"),
    panel.grid.major = element_line(color = "grey30"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "white"),
    axis.title = element_text(color = "white", face = "bold"),
    legend.background = element_blank(),
    legend.text = element_text(color = "white")
  )
```



---

## 4. Multi-Plot Composition (Patchwork)
Advanced users rarely rely on `facet_wrap` alone. The `patchwork` library is the gold standard for combining entirely different types of plots into one graphic.

```r
library(patchwork)

p1 <- ggplot(mpg, aes(displ, hwy)) + geom_point()
p2 <- ggplot(mpg, aes(class)) + geom_bar()

# Use math operators to align plots!
(p1 + p2) / p1 + 
  plot_annotation(title = "Combined Vehicle Analysis", tag_levels = 'A')
```

---

## Advanced Summary Checklist
| Feature | Advanced Implementation |
| :--- | :--- |
| **Labels** | Use the `ggrepel` package to prevent text labels from overlapping. |
| **Interactivity** | Wrap a ggplot in `plotly::ggplotly()` for instant tooltips. |
| **Custom Geoms** | Use `geom_sf()` for specialized geospatial (map) data. |
| **Extensions** | Explore `gganimate` for transitions or `ggdist` for uncertainty. |





To elevate your charts from "data dumps" to "stories," you need to guide the viewer's eye. This is done through **strategic labeling**, **selective highlighting**, and **statistical overlays**.

---

## 1. Highlighting in Bar Charts
A common advanced technique is using a conditional `fill` within `aes()`. This prevents the "rainbow effect" and focuses the user's attention on a specific category.

```r
library(ggplot2)
library(dplyr)

# Data prep: Calculate average hwy by class
df_bar <- mpg %>% 
  group_by(class) %>% 
  summarise(mean_hwy = mean(hwy)) %>%
  mutate(highlight = if_else(class == "midsize", "Highlight", "Normal"))

ggplot(df_bar, aes(x = reorder(class, mean_hwy), y = mean_hwy, fill = highlight)) +
  geom_col() +
  # Manually define the colors
  scale_fill_manual(values = c("Highlight" = "royalblue", "Normal" = "grey80")) +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none") # Remove legend as color explains itself
```

---

## 2. Highlighting Lines and Adding Average Lines
When dealing with time series or continuous data, an **average line** (also called a "reference line") provides context. We use `geom_hline()` for horizontal lines or `geom_vline()` for vertical ones.

### Example: Time Series with Threshold Line
```r
# Calculate the overall average
avg_hwy <- mean(mpg$hwy)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_line(color = "grey70") + # Background lines
  # Add a horizontal dotted average line
  geom_hline(yintercept = avg_hwy, linetype = "dashed", color = "red", size = 1) +
  # Add a text label for the average line
  annotate("text", x = 6, y = avg_hwy + 2, label = paste("Avg:", round(avg_hwy, 1)), color = "red") +
  labs(title = "Engine Displacement vs Highway MPG", subtitle = "Red dashed line indicates fleet average") +
  theme_light()
```



---

## 3. Advanced Labels (The `ggrepel` Package)
Standard labels in `ggplot2` (`geom_text`) often overlap, making them unreadable. The `ggrepel` package is the industry standard for "smart" labels that move away from each other and the data points.

```r
# install.packages("ggrepel")
library(ggrepel)

# Selecting only a few points to label to avoid clutter
label_data <- mpg %>% filter(hwy > 40 | displ > 6.5)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(alpha = 0.3) +
  geom_text_repel(data = label_data, aes(label = model), 
                  box.padding = 0.5, 
                  point.padding = 0.5,
                  segment.color = "grey50") +
  theme_classic()
```

[Image showing ggrepel label placement vs standard geom_text overlap]

---

## 4. Creating a "Custom Legend" with Direct Labels
Advanced designers often remove the legend entirely and label the lines or bars directly. This reduces the "cognitive load" of the viewer looking back and forth between the chart and the legend.

### The "Label at the End" Technique:
```r
# Get the last point of each line
line_labels <- mpg %>%
  group_by(class) %>%
  filter(displ == max(displ)) %>%
  slice(1) # Ensure one point per class

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_line(stat = "smooth", method = "loess", se = FALSE, size = 1) +
  # Label lines directly at the end
  geom_text_repel(data = line_labels, aes(label = class), 
                  hjust = 0, nudge_x = 0.2, direction = "y") +
  scale_color_viridis_d() +
  theme_minimal() +
  theme(legend.position = "none") # No legend needed!
```

### Pro-Tips for Reference Lines:
* **Linetype:** Use `linetype = "dotted"` or `"dashed"` for secondary info (like averages) and `linetype = "solid"` for primary data.
* **Alpha:** Set the alpha of your main data slightly lower ($0.5-0.7$) so the reference line is clearly visible.
* **Order:** Place the `geom_hline()` *after* the main geom if you want it to appear on top, or *before* if you want it in the background.


