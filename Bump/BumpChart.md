
✅ Multi-metric bump chart (Revenue + Churn together)
✅ Reusable enterprise-grade bump chart function
✅ Production design principles

---

# 🎯 Concept: Multi-Metric Bump Charts

Instead of:

```
Only revenue ranking
```

We plot:

```
Revenue Rank
Churn Rank (Risk Rank)
Engagement Rank
```

This helps answer:

👉 Who makes money
👉 Who is risky
👉 Who is sticky

Perfect for OTT strategy.

---

---

# 🟢 Sample Data

```r id="a8x9k1"
library(dplyr)
library(ggplot2)
library(ggrepel)

df <- data.frame(
  year = rep(2019:2022, 3),

  store = rep(c("Plan A","Plan B","Plan C"), each = 4),

  revenue = c(500,600,700,800,
              450,550,500,480,
              650,640,660,700),

  churn_rate = c(0.12,0.10,0.09,0.08,
                 0.18,0.20,0.17,0.16,
                 0.07,0.06,0.05,0.04)
)
```

---

---

# 🟢 Step 1 — Create Ranking Metrics

Important rule:

👉 Revenue → Higher = Better
👉 Churn → Lower = Better

So:

```r id="y8s4l1"
df_rank <- df %>%
  group_by(year) %>%
  mutate(
    revenue_rank = rank(-revenue),
    churn_rank = rank(churn_rate)
  ) %>%
  ungroup()
```

---

---

# 🟢 Step 2 — Convert to Long Format (Very Important ⭐)

Enterprise dashboards always use long format.

```r id="u9k2p7"
df_long <- df_rank %>%
  select(year, store, revenue_rank, churn_rank) %>%
  pivot_longer(
    cols = c(revenue_rank, churn_rank),
    names_to = "metric",
    values_to = "rank"
  )
```

Now you have:

| year | store | metric | rank |

---

---

# 🟢 Step 3 — Multi Metric Bump Chart

```r id="b7m3k2"
ggplot(df_long,
       aes(x = year,
           y = rank,
           group = interaction(store, metric),
           color = metric)) +

  geom_bump(size = 1.2) +
  geom_point(size = 3) +

  scale_y_reverse() +

  facet_wrap(~metric, scales = "free_y") +

  theme_minimal() +

  labs(
    title = "Revenue vs Churn Ranking Movement",
    subtitle = "Enterprise performance tracking"
  )
```

---

---

# 🟢 Enterprise-Level Version (Recommended ⭐⭐⭐⭐⭐)

Add labels only at final year:

```r id="z7v4k2"
ggplot(df_long,
       aes(x = year,
           y = rank,
           group = interaction(store, metric),
           color = store)) +

  geom_line(size = 1.3) +
  geom_point(size = 3) +

  geom_text_repel(
    data = subset(df_long, year == max(year)),
    aes(label = store),
    nudge_x = 0.3
  ) +

  scale_y_reverse() +
  theme_minimal() +
  facet_wrap(~metric)
```

---

---

# 🏆 Reusable Enterprise Bump Chart Function ⭐⭐⭐⭐⭐

This is the real power move.

Use this in production analytics teams.

---

## Generic Function

```r id="f2p7z3"
plot_bump_chart <- function(data,
                            time_col,
                            category_col,
                            metric_col,
                            title_text){

  library(dplyr)
  library(ggplot2)
  library(ggrepel)

  data_rank <- data %>%
    group_by(.data[[time_col]]) %>%
    mutate(rank_metric = rank(-.data[[metric_col]])) %>%
    ungroup()

  ggplot(data_rank,
         aes(
           x = .data[[time_col]],
           y = rank_metric,
           group = .data[[category_col]],
           color = .data[[category_col]]
         )) +

    geom_line(size = 1.2) +
    geom_point(size = 3) +

    geom_text_repel(
      data = subset(data_rank,
                    .data[[time_col]] == max(data_rank[[time_col]])),
      aes(label = .data[[category_col]]),
      nudge_x = 0.3
    ) +

    scale_y_reverse() +
    theme_minimal() +

    labs(title = title_text)
}
```

---

---

# 🟢 Example Usage

```r id="k8q2p1"
plot_bump_chart(
  data = df,
  time_col = "year",
  category_col = "store",
  metric_col = "revenue",
  title_text = "Revenue Ranking Movement"
)
```

---

---

# 🔥 OTT Analytics Use Cases (You Will Love This)

You can reuse this for:

✅ Subscription plan ranking
✅ Country performance ranking
✅ Content genre popularity
✅ Churn risk ranking
✅ Watch hour engagement ranking

Example mapping:

| Business Question         | Bump Metric    |
| ------------------------- | -------------- |
| Best revenue contributors | Revenue        |
| Risk customers            | Churn          |
| Sticky content            | Watch time     |
| Market expansion          | Country growth |

---

---

# ⚠ Enterprise Design Rules (Very Important)

## ✅ Always rank metrics before plotting

Never plot raw values.

---

## ✅ Use facet_wrap for multiple metrics

Keeps visualization readable.

---

## ✅ Label only final time period

Avoid clutter.

---

## ✅ Limit categories to 8–10

Otherwise bump charts become unreadable.

