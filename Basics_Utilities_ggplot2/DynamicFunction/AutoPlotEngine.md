Now you’re stepping into **advanced, production-grade analytics engineering** with **ggplot2**. Let’s build a **fully dynamic plotting engine** that:

* ✅ Auto-detects variable types
* ✅ Chooses the best chart automatically
* ✅ Works with any dataset
* ✅ Produces consistent, styled outputs

---

# 🚀 1. What This Engine Will Do

Given any dataset, it will:

* Detect:

  * Numeric vs categorical vs date
* Decide:

  * Best plot type (scatter, bar, histogram, line)
* Generate:

  * Ready-to-use ggplot

---

# 🧠 2. Variable Type Detection Engine

```r id="d5a2n3"
detect_var_type <- function(x) {
  if (inherits(x, "Date") | inherits(x, "POSIXct")) {
    return("date")
  } else if (is.numeric(x)) {
    return("numeric")
  } else {
    return("categorical")
  }
}
```

---

# 🎯 3. Core Auto Plot Function

```r id="2o7l8p"
plot_auto <- function(data, x, y = NULL, color = NULL, title = "") {
  
  x_var <- deparse(substitute(x))
  y_var <- if (!missing(y)) deparse(substitute(y)) else NULL
  
  x_type <- detect_var_type(data[[x_var]])
  y_type <- if (!is.null(y_var)) detect_var_type(data[[y_var]]) else NULL
  
  # Initialize plot
  p <- ggplot(data)
  
  # ---- Case 1: Only one variable ----
  if (is.null(y_var)) {
    
    if (x_type == "numeric") {
      p <- p + aes(x = {{x}}) + geom_histogram(bins = 30, fill = "steelblue")
      
    } else {
      p <- p + aes(x = {{x}}) + geom_bar(fill = "steelblue")
    }
    
  } 
  
  # ---- Case 2: Two variables ----
  else {
    
    # numeric vs numeric → scatter
    if (x_type == "numeric" & y_type == "numeric") {
      p <- p + aes(x = {{x}}, y = {{y}}, color = {{color}}) +
        geom_point(size = 3, alpha = 0.7)
      
    }
    
    # categorical vs numeric → bar
    else if (x_type == "categorical" & y_type == "numeric") {
      p <- p + aes(x = reorder({{x}}, {{y}}), y = {{y}}, fill = {{color}}) +
        geom_col() +
        coord_flip()
    }
    
    # date vs numeric → line
    else if (x_type == "date" & y_type == "numeric") {
      p <- p + aes(x = {{x}}, y = {{y}}, color = {{color}}) +
        geom_line(size = 1.2)
    }
    
    # categorical vs categorical → count plot
    else {
      p <- p + aes(x = {{x}}, fill = {{y}}) +
        geom_bar(position = "dodge")
    }
  }
  
  p +
    labs(title = title, x = x_var, y = y_var) +
    theme_company()
}
```

---

# 📊 4. Example Usage

### 🔹 1 Variable

```r id="kdcq5m"
plot_auto(mtcars, mpg, title = "Distribution of MPG")
```

👉 Automatically → Histogram

---

### 🔹 2 Variables (numeric vs numeric)

```r id="n5mr6n"
plot_auto(mtcars, wt, mpg, color = cyl, title = "Scatter Plot")
```

👉 Automatically → Scatter plot

---

### 🔹 Categorical vs Numeric

```r id="nd6m9h"
mtcars$cyl <- as.factor(mtcars$cyl)

plot_auto(mtcars, cyl, mpg, title = "Mileage by Cylinders")
```

👉 Automatically → Bar chart

---

# 🧱 5. Add Smart Features (Production Upgrade)

## 🔹 Auto Top-N for categories

```r id="b6b3d3"
limit_top_n <- function(data, var, value, n = 10) {
  data %>%
    arrange(desc({{value}})) %>%
    head(n)
}
```

---

## 🔹 Auto Label Detection

```r id="j3o9m1"
clean_label <- function(x) {
  gsub("_", " ", tools::toTitleCase(x))
}
```

---

# 🎨 6. Plug in Your Theme

```r id="2g5t0y"
theme_company <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold"),
      legend.position = "bottom"
    )
}
```

---

# ⚡ 7. Next-Level Enhancements (Optional)

You can extend this engine to:

### 🔥 Auto Aggregation

* If categorical + numeric → auto `sum()` or `mean()`

### 🔥 Auto Insights

* “Top category contributes 45%”
* “Trend increasing over time”

### 🔥 Multi-Plot Dashboard

* Return list of plots:

```r id="d3w7f8"
list(
  plot1 = plot_auto(...),
  plot2 = plot_auto(...)
)
```

---

# 🧪 8. Real Use Case (Your Domain)

### Churn Analysis Example

```r id="z5p9t2"
df %>%
  plot_auto(country, churn_rate, title = "Churn by Country")

df %>%
  plot_auto(date, revenue, title = "Revenue Trend")
```

---

# 🚀 9. What You Just Built

You now have:

* ✅ Auto chart selection engine
* ✅ Dynamic variable handling
* ✅ Production-ready plotting system

This is **consulting-level / analytics-platform level code**.

---

# 🎯 If You Want Next Level

I can build for you:

### 🔥 1. Auto Insight Engine (Narratives + Charts)

“Top 3 countries contribute 70% revenue”

### 🔥 2. Full Dashboard Generator

Input dataset → Output full report

### 🔥 3. R Package (Your Own Library)

Like:

```r
library(AInvestmentPlots)
plot_auto(df, x, y)
```

---

Just tell me what you want next—I’ll take you to **elite level R + ggplot2 mastery** 🚀
