

Below is a **clean, reusable plotting framework** you can plug into real projects (churn, finance, dashboards, etc.). Everything is modular, consistent, and scalable.

---

# 🧱 1. Core Design Principles (Production-Ready)

A good reusable plotting system should:

* ✅ Be **function-based**
* ✅ Use **standard naming**
* ✅ Accept **dynamic inputs**
* ✅ Apply **consistent themes**
* ✅ Be **pipe-friendly** with **dplyr**

---

# 🎨 2. Global Theme (Set Once)

```r
theme_company <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold"),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10),
      legend.position = "bottom"
    )
}
```

---

# 📊 3. Reusable Plot Functions

## 🔹 3.1 Scatter Plot (Generic)

```r
plot_scatter <- function(data, x, y, color = NULL, title = "") {
  ggplot(data, aes(x = {{x}}, y = {{y}}, color = {{color}})) +
    geom_point(size = 3, alpha = 0.7) +
    labs(title = title, x = deparse(substitute(x)), y = deparse(substitute(y))) +
    theme_company()
}
```

👉 Usage:

```r
plot_scatter(mtcars, wt, mpg, cyl, "Weight vs Mileage")
```

---

## 🔹 3.2 Line Chart (Time Series)

```r
plot_line <- function(data, x, y, group = NULL, title = "") {
  ggplot(data, aes(x = {{x}}, y = {{y}}, color = {{group}}, group = {{group}})) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    labs(title = title) +
    theme_company()
}
```

---

## 🔹 3.3 Bar Chart (Top-N Ready)

```r
plot_bar <- function(data, x, y, fill = NULL, top_n = NULL, title = "") {
  
  df <- data
  
  if (!is.null(top_n)) {
    df <- df %>%
      arrange(desc({{y}})) %>%
      head(top_n)
  }
  
  ggplot(df, aes(x = reorder({{x}}, {{y}}), y = {{y}}, fill = {{fill}})) +
    geom_col() +
    coord_flip() +
    labs(title = title) +
    theme_company()
}
```

---

## 🔹 3.4 Distribution Plot (Histogram + Density)

```r
plot_distribution <- function(data, var, title = "") {
  ggplot(data, aes(x = {{var}})) +
    geom_histogram(aes(y = ..density..), bins = 30, alpha = 0.6) +
    geom_density(color = "blue", size = 1) +
    labs(title = title) +
    theme_company()
}
```

---

## 🔹 3.5 Boxplot (Category Comparison)

```r
plot_box <- function(data, x, y, fill = NULL, title = "") {
  ggplot(data, aes(x = {{x}}, y = {{y}}, fill = {{fill}})) +
    geom_boxplot() +
    labs(title = title) +
    theme_company()
}
```

---

## 🔹 3.6 KPI Trend Plot (Business Use)

```r
plot_kpi_trend <- function(data, date, value, title = "") {
  ggplot(data, aes(x = {{date}}, y = {{value}})) +
    geom_line(color = "darkgreen", size = 1.2) +
    geom_point(size = 2) +
    labs(title = title) +
    theme_company()
}
```

---

# 📈 4. Advanced Business Plots

## 🔹 4.1 Pareto Chart (80/20 Rule)

```r
plot_pareto <- function(data, category, value) {
  
  df <- data %>%
    arrange(desc({{value}})) %>%
    mutate(
      cum_perc = cumsum({{value}}) / sum({{value}})
    )
  
  ggplot(df, aes(x = reorder({{category}}, {{value}}))) +
    geom_col(aes(y = {{value}}), fill = "steelblue") +
    geom_line(aes(y = cum_perc * max({{value}}), group = 1), color = "red") +
    coord_flip() +
    theme_company()
}
```

---

## 🔹 4.2 Heatmap

```r
plot_heatmap <- function(data, x, y, fill) {
  ggplot(data, aes(x = {{x}}, y = {{y}}, fill = {{fill}})) +
    geom_tile() +
    theme_company()
}
```

---

## 🔹 4.3 Dumbbell Chart

```r
plot_dumbbell <- function(data, category, start, end) {
  ggplot(data, aes(y = {{category}})) +
    geom_segment(aes(x = {{start}}, xend = {{end}}, yend = {{category}}),
                 color = "grey") +
    geom_point(aes(x = {{start}}), color = "red", size = 3) +
    geom_point(aes(x = {{end}}), color = "blue", size = 3) +
    theme_company()
}
```

---

# 🔁 5. Wrapper Function (One Function for Everything)

```r
plot_auto <- function(data, type, ...) {
  
  switch(type,
         "scatter" = plot_scatter(data, ...),
         "line"    = plot_line(data, ...),
         "bar"     = plot_bar(data, ...),
         "dist"    = plot_distribution(data, ...),
         "box"     = plot_box(data, ...),
         stop("Invalid plot type")
  )
}
```

---

# 🧪 6. Example: Real Business Workflow

```r
library(dplyr)

df %>%
  group_by(country) %>%
  summarise(revenue = sum(revenue)) %>%
  plot_bar(country, revenue, top_n = 10, title = "Top Countries by Revenue")
```

---

# 📦 7. Production Best Practices

### ✅ Naming Convention

* `plot_*` → all functions
* `theme_*` → styling
* `calc_*` → metrics

---

### ✅ Error Handling

Add validation:

```r
if (!is.data.frame(data)) stop("Input must be a dataframe")
```

---

### ✅ Package Structure (Advanced)

Turn this into your own R package:

```
R/
  plot_scatter.R
  plot_bar.R
  theme_company.R
```



# 🎯 If You Want Next Level

I can take this further for you:

### 🔥 Option 1

👉 Build a **complete churn analysis dashboard (end-to-end)**

### 🔥 Option 2

👉 Create a **plug-and-play R package (your own ggplot framework)**

### 🔥 Option 3

👉 Generate **auto insights + plots (AI-style reporting in R)**

---

Just tell me what you want next—and I’ll build it like a production system 🚀
