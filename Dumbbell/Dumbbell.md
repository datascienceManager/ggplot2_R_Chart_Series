

#Correct Dumbbell Chart Method (Recommended)

Use **`geom_segment()`** instead of `geom_line()`.

---

## Example Dataset (With Negative Values)

```r id="h9p2k1"
library(ggplot2)
library(dplyr)

df2 <- data.frame(
  company = rep(c("A","B","C"),2),
  variable = rep(c("Before","After"), each = 3),
  value = c(-20, -10, 5,   # Before values
            30, 15, -5)    # After values
)
```

---

---

## ⭐ Proper Dumbbell Chart With Negative Values

```r id="k3j9m2"
df_wide <- df2 %>%
  tidyr::pivot_wider(names_from = variable,
                     values_from = value)

ggplot(df_wide,
       aes(y = company)) +

  geom_segment(
    aes(x = Before,
        xend = After,
        yend = company),
    size = 1.5
  ) +

  geom_point(
    aes(x = Before),
    color = "blue",
    size = 4
  ) +

  geom_point(
    aes(x = After),
    color = "red",
    size = 4
  ) +

  theme_minimal()
```

---

---

# ⭐ Why This Works (Important)

Instead of plotting:

```r
geom_line()
```

Use:

```r
geom_segment(x, xend)
```

Because:

👉 Dumbbell charts are **start → end comparisons**
👉 Not time series lines

---

---

# ⭐ Add Negative Axis Properly

Always add:

```r id="j7q3p1"
scale_x_continuous(limits = c(min(df_wide$Before, df_wide$After),
                              max(df_wide$Before, df_wide$After)))
```

Otherwise ggplot may auto-truncate negative values.

---

---

# ⭐ Executive Presentation Version (Best Looking ⭐⭐⭐⭐⭐)

```r id="z1q8v4"
ggplot(df_wide,
       aes(y = company)) +

  geom_segment(
    aes(x = Before,
        xend = After,
        yend = company),
    size = 2,
    color = "grey60"
  ) +

  geom_point(aes(x = Before),
             size = 6,
             color = "black") +

  geom_point(aes(x = After),
             size = 6,
             color = "darkred") +

  theme_minimal() +
  labs(
    title = "Performance Change Analysis",
    x = "Value Change"
  )
```

---

---

# ⚠ Common Mistakes (Avoid These)

## ❌ Using geom_line()

Not correct for dumbbell charts.

---

## ❌ Not reshaping data

Always pivot to wide format.

---

## ❌ Forgetting axis limits when negative values exist

Axis may auto clip data.

---

# 🎯 Formula for Percentage Change

[
Percentage\ Change = \frac{After - Before}{Before} \times 100
]

⚠ Important:

* If Before = 0 → handle carefully (avoid divide by zero).

---

---

# 🟢 Sample Data

```r id="p7m2k1"
library(dplyr)
library(tidyr)
library(ggplot2)

df <- data.frame(
  company = c("A","B","C"),
  before = c(100, 80, 60),
  after = c(120, 60, 90)
)
```

---

---

# 🟢 Calculate Percentage Change

```r id="k3n9l1"
df <- df %>%
  mutate(
    pct_change = ((after - before) / before) * 100
  )
```

---

---

# 🟢 Convert to Long Format (Needed for Dumbbell)

```r id="z8h1p4"
df_long <- df %>%
  pivot_longer(
    cols = c(before, after),
    names_to = "period",
    values_to = "value"
  )
```

---

---

# ⭐ Percentage Change Dumbbell Chart (Best Method ⭐⭐⭐⭐⭐)

```r id="v4n8k2"
df_wide <- df %>%
  select(company, before, after)

ggplot(df_wide, aes(y = company)) +

  geom_segment(
    aes(x = before,
        xend = after,
        yend = company),
    size = 2,
    color = "grey60"
  ) +

  geom_point(aes(x = before),
             size = 5,
             color = "blue") +

  geom_point(aes(x = after),
             size = 5,
             color = "red") +

  geom_text(
    aes(
      x = after,
      label = paste0(round(((after-before)/before)*100,1), "%")
    ),
    hjust = -0.2,
    size = 4,
    fontface = "bold"
  ) +

  theme_minimal() +
  labs(
    title = "Percentage Change Analysis",
    x = "Value"
  )
```

---

---

# ⭐ Executive Dashboard Version (Best for PPTs)

Add change labels:

```r id="b9l2m4"
geom_text(
  aes(
    x = after,
    label = paste0(
      "Change: ",
      round(((after-before)/before)*100,1),
      "%"
    )
  ),
  hjust = -0.3
)
```

---

---

# 🚀 Enterprise-Level Best Practice (Very Important)

## ✔ Always Show:

* Absolute values
* Percentage change

Example storytelling:

> Revenue increased from 100 → 120
> (+20%)

Never show percentage alone.

---

---

# ⚠ Handling Negative Values (Very Important For You)

If you have negative values:

Use:

```r id="q1v8p3"
pct_change = ifelse(before == 0,
                    NA,
                    (after-before)/abs(before)*100)
```

Prevents divide-by-zero and distortion.

---

---



---
