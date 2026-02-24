Now let me create a comprehensive R script for the voluntary churn analysis:Here's a breakdown of what the script contains — **8 ggplot2 visualizations** across 3 analysis themes:

**Product & Payment Inactive (from VoluntaryChurn table)**
- **Plot 1** — Horizontal bar chart
- **Plot 2** — Lollipop chart
- **Plot 3** — Heatmap: Prd × Pay Method Inactive rate cross-analysis (spots the riskiest combos)
- **Plot 7** — Line chart: Inactive rate

** Behavior **
- **Plot 4** — Boxplot + jitter: watch hours distribution for active vs Inactive
- **Plot 5** — Grouped bar chart: content category preference split — inactive vs active
- **Plot 6** — Histogram: days since last active (recency) — inactive users are typically inactive longer before leaving
- **Plot 8** — Bubble scatter: avg watch hours vs inactive rate per product — identifies the most at-risk products

**Before running**, update two things:
1. The file paths in Section 2 (`read.csv("VolyInactive.csv")`)

The script also prints a **summary table** 
