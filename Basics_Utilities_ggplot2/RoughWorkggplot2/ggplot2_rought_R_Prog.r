
library(ggplot2)


theme_company <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold"),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10),
      legend.position = "bottom"
    )
}

plot_scatter <- function(data, x, y,size=NULL, color = NULL, title = "") {
  ggplot(data, aes(x = {{x}}, y = {{y}}, color = {{color}},size = {{ size}})) +
    geom_point( alpha = 0.7) +
    labs(title = title, x = deparse(substitute(x)), y = deparse(substitute(y))) +
    theme_company()}


plot_scatter(mtcars, wt, mpg,size=disp, cyl, "Weight vs Mileage")


plot_scatter <- function(data, x, y, z = NULL, color = NULL, title = "") {
  ggplot(data, aes(x = {{x}}, y = {{y}}, color = {{color}}, size = {{z}})) +
    geom_point(alpha = 0.7) +
    labs(title = title) +
    theme_company()
}








detect_var_type <- function(x) {
  if (inherits(x, "Date") | inherits(x, "POSIXct")) {
    return("date")
  } else if (is.numeric(x)) {
    return("numeric")
  } else {
    return("categorical")
  }
}




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




plot_auto(mtcars, mpg, title = "Distribution of MPG")


plot_auto(mtcars, wt, mpg, color = cyl, title = "Scatter Plot")


mtcars$cyl <- as.factor(mtcars$cyl)

plot_auto(mtcars, cyl, mpg, title = "Mileage by Cylinders")



limit_top_n <- function(data, var, value, n = 10) {
  data %>%
    arrange(desc({{value}})) %>%
    head(n)
}



clean_label <- function(x) {
  gsub("_", " ", tools::toTitleCase(x))
}








list(
  plots = list(plot1, plot2, plot3),
  insights = list("insight1", "insight2"),
  summary_table = df_summary
)



generate_insights_cat_num <- function(data, category, value) {
  
  df <- data %>%
    group_by({{category}}) %>%
    summarise(total = sum({{value}}, na.rm = TRUE)) %>%
    arrange(desc(total))
  
  total_sum <- sum(df$total)
  
  df <- df %>%
    mutate(perc = round(100 * total / total_sum, 1))
  
  top_cat <- df[1, ]
  bottom_cat <- df[nrow(df), ]
  
  insights <- list(
    paste0("Top category is ", top_cat[[1]], 
           " contributing ", top_cat$perc, "% of total."),
    
    paste0("Lowest category is ", bottom_cat[[1]], 
           " contributing ", bottom_cat$perc, "%."),
    
    paste0("Top 3 categories contribute ",
           round(sum(df$perc[1:min(3, nrow(df))]), 1), "% of total.")
  )
  
  return(list(data = df, insights = insights))
}

generate_plots <- function(data, category, value, date = NULL) {
  
  plots <- list()
  
  # Bar plot
  plots$bar <- ggplot(data, aes(x = {{category}}, y = {{value}})) +
    geom_col(fill = "steelblue") +
    coord_flip() +
    theme_company() +
    labs(title = "Category Contribution")
  
  # Distribution
  plots$dist <- ggplot(data, aes(x = {{value}})) +
    geom_histogram(bins = 30, fill = "orange") +
    theme_company() +
    labs(title = "Distribution")
  
  # Trend (if date provided)
  if (!missing(date)) {
    plots$trend <- ggplot(data, aes(x = {{date}}, y = {{value}})) +
      geom_line(color = "darkgreen") +
      theme_company() +
      labs(title = "Trend Over Time")
  }
  
  return(plots)
}






analyze_data <- function(data, category, value, date = NULL) {
  
  # Step 1: Insights
  insight_obj <- generate_insights_cat_num(data, {{category}}, {{value}})
  
  summary_df <- insight_obj$data
  insights <- insight_obj$insights
  
  # Step 2: Plots
  plots <- generate_plots(summary_df, {{category}}, total, date = date)
  
  # Step 3: Return structured output
  return(list(
    plots = plots,
    insights = insights,
    summary_table = summary_df
  ))
}



library(dplyr)

mtcars$cyl <- as.factor(mtcars$cyl)

result <- analyze_data(mtcars, cyl, mpg)

# Access plots
result$plots$bar
result$plots$dist

# Print insights
result$insights




results_list <- list()

for (col in c("country", "product", "segment")) {
  results_list[[col]] <- analyze_data(df, !!sym(col), revenue)
}



unlist(result$insights)



library(patchwork)

result$plots$bar + result$plots$dist







fmt_perc <- function(x) paste0(round(x, 1), "%")


generate_narrative <- function(summary_df, category_name, value_name) {
  
  total_value <- sum(summary_df$total, na.rm = TRUE)
  
  # Top & bottom
  top <- summary_df[1, ]
  bottom <- summary_df[nrow(summary_df), ]
  
  # Top 3 contribution
  top3_contribution <- sum(summary_df$perc[1:min(3, nrow(summary_df))])
  
  # Concentration check
  concentration_flag <- ifelse(top3_contribution > 70, "highly concentrated",
                               ifelse(top3_contribution > 50, "moderately concentrated",
                                      "well distributed"))
  
  paragraph <- paste0(
    "The total ", value_name, " across all ", category_name, " is ",
    round(total_value, 2), ". ",
    
    "The leading ", category_name, " is '", top[[1]], 
    "', contributing ", fmt_perc(top$perc), " of the total, ",
    "while the lowest contributor is '", bottom[[1]], 
    "' at ", fmt_perc(bottom$perc), ". ",
    
    "The top three ", category_name, " collectively account for ",
    fmt_perc(top3_contribution), ", indicating that the distribution is ",
    concentration_flag, ". ",
    
    if (top$perc > 40) {
      paste0("This suggests a strong dependency on the top ", category_name,
             ", which may pose a concentration risk.")
    } else {
      paste0("The distribution appears relatively balanced, reducing dependency risk.")
    }
  )
  
  return(paragraph)
}


analyze_data <- function(data, category, value, date = NULL) {
  
  insight_obj <- generate_insights_cat_num(data, {{category}}, {{value}})
  
  summary_df <- insight_obj$data
  insights <- insight_obj$insights
  
  plots <- generate_plots(summary_df, {{category}}, total, date = date)
  
  # 🔥 NEW: Narrative
  narrative <- generate_narrative(
    summary_df,
    category_name = deparse(substitute(category)),
    value_name = deparse(substitute(value))
  )
  
  return(list(
    plots = plots,
    insights = insights,
    narrative = narrative,
    summary_table = summary_df
  ))
}


result <- analyze_data(mtcars, cyl, mpg)

cat(result$narrative)



generate_trend_narrative <- function(data, date, value) {
  
  df <- data %>%
    arrange({{date}})
  
  start_val <- df[[deparse(substitute(value))]][1]
  end_val <- df[[deparse(substitute(value))]][nrow(df)]
  
  growth <- ((end_val - start_val) / start_val) * 100
  
  trend <- ifelse(growth > 0, "increased", "decreased")
  
  paste0(
    "Over the observed period, ", deparse(substitute(value)),
    " has ", trend, " by ", round(abs(growth), 1), 
    "%, moving from ", round(start_val, 2),
    " to ", round(end_val, 2), "."
  )
}


paste(
  result$narrative ,
  generate_trend_narrative(df, date, revenue)
)





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


library(patchwork)

p1 <- ggplot(mpg, aes(displ, hwy)) + geom_point()
p2 <- ggplot(mpg, aes(class)) + geom_bar()

# Use math operators to align plots!
(p1 + p2) / p1 + 
  plot_annotation(title = "Combined Vehicle Analysis", tag_levels = 'A')


install.packages('gapminder')

library(gapminder)

library(ggplot2)
library(viridis)

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, size = pop, color = continent)) +
  geom_point(alpha = 0.7) +
  scale_x_log10(labels = scales::dollar) + # Custom labels for currency
  scale_color_viridis_d(option = "plasma") + # Discrete viridis scale
  scale_size(range = c(1, 15), guide = "none") # Rescaling point sizes



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






library(ggplot2)
library(dplyr)
library(lubridate)

# Simulated data
df <- data.frame(
  user_id = rep(1:100, each = 10),
  date = seq(as.Date("2026-03-25"), as.Date("2026-04-03"), by="day"),
  active = sample(c(0, 1), 1000, replace = TRUE)
)

# The "Event Date"
match_date <- as.Date("2026-03-30")

# Calculate relative time
df_plot <- df %>%
  mutate(days_from_match = as.numeric(date - match_date)) %>%
  group_by(days_from_match) %>%
  summarise(churn_rate = 1 - mean(active)) # Churn = 1 minus activity rate



ggplot(df_plot, aes(x = days_from_match, y = churn_rate)) +
  # 1. Add background shading for 'Before' and 'After'
  annotate("rect", xmin = -Inf, xmax = 0, ymin = -Inf, ymax = Inf, 
           fill = "grey90", alpha = 0.5) +
  annotate("text", x = -2, y = max(df_plot$churn_rate), label = "PRE-MATCH", 
           fontface = "italic", color = "grey40") +
  
  # 2. Add the actual data points and line
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue") +
  
  # 3. The Match Event Line
  geom_vline(xintercept = 0, linetype = "dashed", color = "firebrick", size = 1.2) +
  annotate("label", x = 0, y = min(df_plot$churn_rate), label = "MATCH DAY", 
           fill = "firebrick", color = "white", fontface = "bold") +
  
  # 4. Add an average line for both periods to show the 'Jump'
  geom_smooth(data = filter(df_plot, days_from_match <= 0), method = "lm", 
              se = FALSE, color = "black", linetype = "dotted") +
  geom_smooth(data = filter(df_plot, days_from_match >= 0), method = "lm", 
              se = FALSE, color = "black", linetype = "dotted") +
  
  labs(title = "User Churn Impact: Football Match Event",
       subtitle = "Relative churn rates centered around Match Day (t=0)",
       x = "Days Relative to Match",
       y = "Churn Rate (%)") +
  theme_minimal()







ggplot(df, aes(x = date, y = factor(user_id), fill = factor(active))) +
  geom_tile() +
  scale_fill_manual(values = c("0" = "firebrick", "1" = "seagreen"), 
                    labels = c("Inactive", "Active"), name = "Status") +
  geom_vline(xintercept = as.numeric(match_date), color = "white", size = 1) +
  theme_minimal() +
  theme(axis.text.y = element_blank()) + # Hide user IDs if there are too many
  labs(title = "User Activity Heatmap", x = "Date", y = "Individual Users")







library(ggplot2)
library(dplyr)

# 1. Define the Match Schedule (The Rectangles)
matches <- data.frame(
  match_name = c("Match 1", "Match 2", "Match 3"),
  start = as.Date(c("2026-04-05", "2026-04-12", "2026-04-19")),
  end = as.Date(c("2026-04-06", "2026-04-13", "2026-04-20"))
)

# 2. Daily Subscriber Data (The Lines)
dates <- seq(as.Date("2026-04-01"), as.Date("2026-04-30"), by="day")
df_subs <- data.frame(
  date = dates,
  subs = cumsum(sample(c(10, -5, 20), length(dates), replace=TRUE)),
  churners = sample(2:15, length(dates), replace=TRUE)
)






ggplot() +
  # Layer 1: Match Highlight Windows
  geom_rect(data = matches, 
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
            fill = "chartreuse4", alpha = 0.2) +
  
  # Layer 2: Match Labels at the top
  geom_text(data = matches, 
            aes(x = start + 0.5, y = max(df_subs$subs), label = match_name), 
            angle = 90, vjust = -0.5, color = "chartreuse4", fontface = "bold") +
  
  # Layer 3: Subscriber Line
  geom_line(data = df_subs, aes(x = date, y = subs), color = "dodgerblue4", size = 1) +
  
  # Layer 4: Churner Bar Chart (scaled to fit)
  geom_col(data = df_subs, aes(x = date, y = churners * 5), fill = "firebrick", alpha = 0.6) +
  
  # Formatting
  scale_y_continuous(
    name = "Total Subscribers",
    sec.axis = sec_axis(~./5, name = "Daily Churners") # Secondary Axis
  ) +
  labs(title = "Subscriber Dynamics Across Competition Season",
       subtitle = "Green regions indicate Match Days | Blue Line = Subs | Red Bars = Churn",
       x = "Date") +
  theme_minimal() +
  theme(
    axis.title.y.right = element_text(color = "firebrick"),
    axis.title.y.left = element_text(color = "dodgerblue4"),
    panel.grid.minor = element_blank()
  )






# Create relative days for each match period
match_windows <- matches %>%
  group_by(match_name) %>%
  reframe(date = seq(start - 2, start + 3, by="day")) %>%
  left_mutate(relative_day = as.numeric(date - min(date)) - 2) %>%
  inner_join(df_subs, by = "date")

ggplot(match_windows, aes(x = relative_day, y = churners, fill = match_name)) +
  geom_area(alpha = 0.4) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  facet_wrap(~match_name) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Churn Spike Analysis: Match Comparison",
       x = "Days from Kickoff (0 = Match Day)",
       y = "Number of Churners") +
  theme_bw()




library(ggplot2)
library(dplyr)

# Corrected Data Processing
match_windows <- matches %>%
  group_by(match_name) %>%
  # Create a sequence of 6 days for each match
  reframe(date = seq(start - 2, start + 3, by="day")) %>% 
  group_by(match_name) %>%
  # Calculate relative day: 0 is Match Day
  mutate(relative_day = as.numeric(date - (min(date) + 2))) %>% 
  inner_join(df_subs, by = "date")

# The Visualization
ggplot(match_windows, aes(x = relative_day, y = churners, fill = match_name)) +
  # Use geom_area for a polished "mountain" look
  geom_area(alpha = 0.5, position = "identity") + 
  # Highlight the Match Day specifically
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", size = 0.8) +
  # Separate panels for each match
  facet_wrap(~match_name) +
  scale_fill_viridis_d(option = "magma") +
  labs(
    title = "Churn Spike Comparison Across Season",
    subtitle = "T=0 represents Kickoff Day",
    x = "Days Relative to Match",
    y = "Number of Churners"
  ) +
  theme_minimal()



geom_rect(aes(xmin = 0, xmax = 1, ymin = -Inf, ymax = Inf), 
          fill = "grey", alpha = 0.02)









library(ggplot2)
library(dplyr)

# Define the 'Tournament' window
tournament_start <- as.Date("2026-04-10")
tournament_end   <- as.Date("2026-04-20")

# Calculate averages for the 'Before' and 'After' periods
stats <- df_subs %>%
  mutate(period = case_when(
    date < tournament_start ~ "Before",
    date > tournament_end   ~ "After",
    TRUE ~ "During"
  )) %>%
  group_by(period) %>%
  summarise(avg_subs = mean(subs), 
            start_date = min(date), 
            end_date = max(date)) %>%
  filter(period != "During") # We only want to compare Before vs After


P = 
ggplot() +
  # 1. Shaded Region for the Group of Matches
  geom_rect(aes(xmin = tournament_start, xmax = tournament_end, 
                ymin = -Inf, ymax = Inf), 
            fill = "orange", alpha = 0.1) +
  
  # 2. Main Subscriber Line
  geom_line(data = df_subs, aes(x = date, y = subs), color = "grey40", size = 0.5) +
  
  # 3. Horizontal segments for Averages
  geom_segment(data = stats, 
               aes(x = start_date, xmax = end_date, 
                   y = avg_subs, yend = avg_subs, color = period), 
               size = 1.5) +
  
  # 4. Text Labels for the Averages
  geom_label(data = stats, 
             aes(x = (start_date + (end_date - start_date)/2), 
                 y = avg_subs, label = paste("Avg:", round(avg_subs))),
             vjust = -0.5) +
  
  # 5. Label the Group of Matches
  annotate("text", x = tournament_start + (tournament_end - tournament_start)/2, 
           y = max(df_subs$subs), label = "TOURNAMENT PERIOD", 
           color = "orange4", fontface = "bold", angle = 0) +
  
  scale_color_manual(values = c("Before" = "steelblue", "After" = "firebrick")) +
  labs(title = "Subscriber Retention: Pre vs Post Tournament",
       subtitle = "Shaded area represents the group of matches",
       x = "Date", y = "Total Subscribers") +
  theme_minimal() +
  theme(legend.position = "none")

P


# Assuming 'stats' has the Before/After averages
avg_before <- stats$avg_subs[stats$period == "Before"]
avg_after  <- stats$avg_subs[stats$period == "After"]


P +
  geom_curve(aes(x = tournament_start, y = avg_before, 
                 xend = tournament_end, yend = avg_after),
             curvature = -0.2, arrow = arrow(length = unit(0.3, "cm")), color = "purple")





library(ggplot2)
library(dplyr)
library(tidyr)

# Sample EPL Match Data
epl_data <- data.frame(
  match = c("Ars vs Tot", "Liv vs Che", "Mnc vs Mnu", "New vs Whu", "Avl vs Eve", "Bre vs Ful"),
  date = as.Date(c("2026-04-05", "2026-04-12", "2026-04-19", "2026-04-26", "2026-05-03", "2026-05-10")),
  purchases = c(1200, 1500, 2200, 800, 950, 700),
  churners = c(300, 450, 200, 600, 400, 550)
)

# Reshape for ggplot (Long Format)
epl_long <- epl_data %>%
  pivot_longer(cols = c(purchases, churners), names_to = "type", values_to = "count")


# Define a 'Big Match' window (e.g., April 15 to April 22)
highlight_start <- as.Date("2026-04-15")
highlight_end   <- as.Date("2026-04-22")

ggplot(epl_long, aes(x = date, y = count, fill = type)) +
  # 1. Background highlight for the "Big Match" week
  geom_rect(aes(xmin = highlight_start, xmax = highlight_end, ymin = 0, ymax = Inf),
            fill = "gold", alpha = 0.01, inherit.aes = FALSE) +
  
  # 2. Grouped Bar Chart
  geom_col(position = "dodge", width = 5) + # width adjusted for date axis
  
  # 3. Dynamic Labels for Match Names
  geom_text(aes(label = match, y = -100), angle = 45, hjust = 1, size = 3, color = "black", 
            data = filter(epl_long, type == "purchases")) +
  
  # 4. Reference line for Average Churn
  geom_hline(yintercept = mean(epl_data$churners), linetype = "dashed", color = "firebrick") +
  annotate("text", x = max(epl_data$date), y = mean(epl_data$churners) + 100, 
           label = "Avg Churn", color = "firebrick", hjust = 1) +
  
  # 5. Styling
  scale_fill_manual(values = c("purchases" = "#2ECC71", "churners" = "#E74C3C"),
                    labels = c("New Subscribers", "Churned Users")) +
  scale_x_date(date_breaks = "1 week", date_labels = "%b %d") +
  labs(title = "EPL Match Impact: Subscribers vs. Churn",
       subtitle = "Highlighted area: Manchester Derby Week",
       x = "Match Date", y = "User Count", fill = "Metric") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 16),
        axis.text.x = element_text(vjust = -1))




# Calculate net growth
epl_data <- epl_data %>% mutate(net = purchases - churners)

ggplot() +
  geom_col(data = epl_long, aes(x = date, y = count, fill = type), position = "dodge") +
  geom_line(data = epl_data, aes(x = date, y = net, group = 1), color = "black", size = 1) +
  geom_point(data = epl_data, aes(x = date, y = net)) +
  # Add labels for the line
  geom_label(data = epl_data, aes(x = date, y = net, label = net), vjust = -1)








# Source - https://stackoverflow.com/q/39177706
# Posted by watchtower, modified by community. See post 'Timeline' for change history
# Retrieved 2026-04-03, License - CC BY-SA 3.0

structure(list(name = c("Nixon", "Ford", "Carter", "Reagan", 
                        "Bush", "Clinton", "Bush", "Obama"), start = structure(c(-346L, 
                                                                                 1681L, 2576L, 4037L, 6959L, 8420L, 11342L, 14264L), class = "Date"), 
               end = structure(c(1681L, 2576L, 4037L, 6959L, 8420L, 11342L, 
                                 14264L, 17186L), class = "Date"), party = c("Republican", 
                                                                             "Republican", "Democratic", "Republican", "Republican", "Democratic", 
                                                                             "Republican", "Democratic")), .Names = c("name", "start", 
                                                                                                                      "end", "party"), row.names = c(NA, -8L), class = c("tbl_df", 
                                                                                                                                                                         "tbl", "data.frame"))
# Source - https://stackoverflow.com/a/39178519
# Posted by Cyrus Mohammadian
# Retrieved 2026-04-03, License - CC BY-SA 3.0


presidential <- subset(presidential, start > economics$date[1])


ggplot(economics) +
  geom_rect(
    aes(xmin = start, xmax = end, fill = party),
    ymin = -Inf, ymax = Inf, alpha = 0.2,
    data = presidential
  ) +
  geom_vline(
    aes(xintercept = as.numeric(start)),
    data = presidential,
    colour = "grey50", alpha = 0.5
  ) +
  geom_text(
    aes(x = start, y = 2500, label = name),
    data = presidential,
    size = 3, vjust = 0, hjust = 0, nudge_x = 50, check_overlap = TRUE
  ) +
  geom_line(aes(date, unemploy)) +
  geom_rect(
    aes(xmin = start, xmax = end, fill = "chartreuse"),
    ymin = 10000, ymax = Inf, alpha = 0.4,
    data = presidential
  ) +
  geom_text(
    aes(x = as.Date("1993-01-20"), y = 12000, label = "High unemployment"),
    size = 3, vjust = 0, hjust = 0, color = "forestgreen"
  )+
  scale_fill_manual(values = c("chartreuse", "red", "blue"), labels=c("High Unemployment","Democrat","Republican"))+labs(fill="")+
  theme_classic()









library(ggplot2)
library(dplyr)

# 1. Create the 'Events' Data (Like the 'presidential' dataset)
epl_events <- data.frame(
  match_name = c("Ars vs Tot", "Liv vs Che", "Mnc vs Mnu"),
  start = as.Date(c("2026-04-04", "2026-04-11", "2026-04-18")),
  end   = as.Date(c("2026-04-06", "2026-04-13", "2026-04-20")),
  importance = c("Derby", "Big Six", "Title Decider")
)


# 2. The Main Chart
ggplot(df_subs) + # df_subs is your daily subscriber/churn data
  # Layer 1: Background shading based on match importance
  geom_rect(
    data = epl_events,
    aes(xmin = start, xmax = end, fill = importance),
    ymin = -Inf, ymax = Inf, alpha = 0.2
  ) +
  # Layer 2: Vertical separator lines
  geom_vline(
    data = epl_events,
    aes(xintercept = as.numeric(start)),
    colour = "grey50", alpha = 0.5
  ) +
  # Layer 3: Match Name Labels
  geom_text(
    data = epl_events,
    aes(x = start, y = max(df_subs$subs) * 0.9, label = match_name),
    size = 3.5, vjust = 0, hjust = 0, nudge_x = 0.2, fontface = "bold"
  ) +
  # Layer 4: The Actual Subscriber Line
  geom_line(aes(x = date, y = subs), color = "black", size = 0.8) +
  # Layer 5: Highlight 'High Churn' zone at the top
  geom_rect(
    data = epl_events,
    aes(xmin = start, xmax = end),
    ymin = max(df_subs$subs) * 0.95, ymax = Inf, fill = "firebrick", alpha = 0.4
  ) +
  # Layer 6: Static Annotation for the zone
  annotate("text", x = min(df_subs$date), y = max(df_subs$subs), 
           label = "Peak Churn Risk", color = "firebrick", size = 3, hjust = 0) +
  # Layer 7: Custom Colors
  scale_fill_manual(
    values = c("Derby" = "gold", "Big Six" = "skyblue", "Title Decider" = "orchid"),
    name = "Match Type"
  ) +
  labs(
    title = "EPL Match Windows & Subscriber Fluctuations",
    x = "Timeline", y = "Total Subscribers"
  ) +
  theme_minimal()


