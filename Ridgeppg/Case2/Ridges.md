
# 🔹 1️⃣ What is a Ridgeline Plot?

A ridgeline plot shows **multiple density distributions stacked vertically**.

It is built using:

* ggplot2
* ggridges

It helps compare:

* Customer tenure by product
* Revenue distribution by country
* Churn probability by segment
* Watch time by plan

---

# 🔹 2️⃣ Install & Load Packages

```r
install.packages("ggplot2")
install.packages("ggridges")
install.packages("dplyr")

library(ggplot2)
library(ggridges)
library(dplyr)
```

---

# 🔹 3️⃣ Basic Ridgeline Plot (Beginner Level)

### 🔸 Example Dataset

We’ll simulate OTT churn tenure data.

```r
set.seed(123)

data <- data.frame(
  product = rep(c("Basic", "Standard", "Premium"), each = 500),
  tenure_months = c(
    rnorm(500, mean = 6, sd = 2),
    rnorm(500, mean = 12, sd = 3),
    rnorm(500, mean = 18, sd = 4)
  )
)
```

---

### 🔸 Basic Ridgeline

```r
ggplot(data, aes(x = tenure_months, y = product)) +
  geom_density_ridges()
```

### 🔎 What Happens Here?

* `x` = numeric variable (distribution)
* `y` = categorical variable
* `geom_density_ridges()` computes density automatically

---

# 🔹 4️⃣ Improve Visual Quality (Intermediate)

```r
ggplot(data, aes(x = tenure_months, y = product, fill = product)) +
  geom_density_ridges(alpha = 0.7, color = "white") +
  theme_minimal() +
  labs(
    title = "Customer Tenure Distribution by Plan",
    x = "Tenure (Months)",
    y = "Subscription Plan"
  ) +
  theme(legend.position = "none")
```

---

# 🔹 5️⃣ Control Overlap (scale parameter)

```r
geom_density_ridges(scale = 1.5)
```

* `scale > 1` → more overlap
* `scale < 1` → more separation

For executive slides, use:

```r
scale = 1.2
```

---

# 🔹 6️⃣ Add Quantile Lines (Advanced Insight)

```r
ggplot(data, aes(x = tenure_months, y = product, fill = product)) +
  geom_density_ridges(
    quantile_lines = TRUE,
    quantiles = 2,
    alpha = 0.7
  ) +
  theme_minimal()
```

This shows:

* Median split
* Distribution skewness
* Retention differences

---

# 🔹 7️⃣ Gradient Ridgeline (Advanced Analytics Style)

Very powerful for churn probability.

```r
ggplot(data, aes(x = tenure_months, y = product, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 1.2) +
  scale_fill_viridis_c() +
  theme_minimal()
```

This shows:

* Density intensity
* Tail risk
* Concentration zones

---

# 🔹 8️⃣ Using Real Business Data (Churn Example)

Suppose you have:

```r
churn_data
# columns:
# product, churn_probability
```

```r
ggplot(churn_data, aes(x = churn_probability, y = product, fill = product)) +
  geom_density_ridges(alpha = 0.6) +
  theme_minimal()
```

### Business Insight You Can Say:

* Premium plan shows tighter distribution → stable retention
* Basic plan shows right skew → high churn risk segment
* Median churn probability differs across plans

---

# 🔹 9️⃣ Ordering by Mean / Median (Executive Ready)

This is important for board presentation.

```r
data %>%
  group_by(product) %>%
  mutate(mean_tenure = mean(tenure_months)) %>%
  ungroup() %>%
  ggplot(aes(
    x = tenure_months,
    y = reorder(product, mean_tenure),
    fill = product
  )) +
  geom_density_ridges(alpha = 0.7) +
  theme_minimal()
```

Now products are sorted by performance.

---

# 🔹 🔟 Faceted Ridgeline (Country + Product)

```r
ggplot(data, aes(x = tenure_months, y = product, fill = product)) +
  geom_density_ridges(alpha = 0.6) +
  facet_wrap(~ region) +
  theme_minimal()
```

Great for:

* Country comparison
* Product-country churn
* Segment behavior

---

# 🔹 1️⃣1️⃣ Weighted Ridgeline (Revenue Impact)

If you want revenue-weighted density:

```r
ggplot(data, aes(
  x = tenure_months,
  y = product,
  weight = revenue,
  fill = product
)) +
  geom_density_ridges()
```

Very powerful for contribution analysis.

---

# 🔹 1️⃣2️⃣ Performance Tips (Large Data)

For large datasets (millions rows):

* Use `data.table` summarization first
* Sample data
* Precompute density

---

# 🔹 1️⃣3️⃣ Common Mistakes

❌ Using categorical variable in x
❌ Too many categories (over 15 becomes unreadable)
❌ Forgetting to control scale
❌ Not sorting categories

---

# 🔹 1️⃣4️⃣ When to Use Ridgeline vs Boxplot vs Histogram

| Use Case                   | Best Plot  |
| -------------------------- | ---------- |
| Compare distribution shape | Ridgeline  |
| Compare median & IQR       | Boxplot    |
| Single group distribution  | Histogram  |
| Time trend                 | Line chart |

---

# 🔹 1️⃣5️⃣ Executive-Level Narrative Example

If presenting churn tenure:

> Premium customers show right-shifted distribution with median ~18 months.
> Basic customers cluster below 8 months indicating early churn concentration.
> Standard plan shows wide variance suggesting mixed retention quality.

This is how you convert ridgeline → business insight.

---

# 🔹 Bonus: Clean Reusable Function

```r
plot_ridgeline <- function(data, x_var, y_var, title = "") {
  ggplot(data, aes_string(x = x_var, y = y_var, fill = y_var)) +
    geom_density_ridges(alpha = 0.7, scale = 1.2) +
    theme_minimal() +
    labs(title = title) +
    theme(legend.position = "none")
}
```

Usage:

```r
plot_ridgeline(data, "tenure_months", "product",
               "Tenure Distribution by Plan")
```

---

