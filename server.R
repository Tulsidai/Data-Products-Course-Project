library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

region_names <- c(
  "1" = "Barima-Waini",
  "2" = "Pomeroon-Supenaam",
  "3" = "Essequibo Islands-\nWest Demerara",
  "4" = "Demerara-Mahaica",
  "5" = "Mahaica-Berbice",
  "6" = "East Berbice-\nCorentyne",
  "7" = "Cuyuni-Mazaruni",
  "8" = "Potaro-Siparuni",
  "9" = "Upper Takutu-\nUpper Essequibo",
  "10" = "Upper Demerara-\nBerbice"
)

region_type <- c(
  "1" = "Hinterland", "2" = "Coastland", "3" = "Coastland",
  "4" = "Coastland", "5" = "Coastland", "6" = "Coastland",
  "7" = "Hinterland", "8" = "Hinterland", "9" = "Hinterland",
  "10" = "Coastland"
)

area_km2 <- c(
  "1" = 20339, "2" = 6195, "3" = 3755, "4" = 2232, "5" = 4190,
  "6" = 36234, "7" = 47213, "8" = 20051, "9" = 57750, "10" = 17040
)

# 2012 final census count
pop_2012_male <- c(
  "1" = 14450, "2" = 23554, "3" = 53794, "4" = 152188,
  "5" = 24833, "6" = 54963, "7" = 9721, "8" = 6032,
  "9" = 12479, "10" = 19791
)
pop_2012_female <- c(
  "1" = 13193, "2" = 23256, "3" = 53991, "4" = 159375,
  "5" = 24987, "6" = 54689, "7" = 8654, "8" = 5045,
  "9" = 11759, "10" = 20201
)

# 2022 preliminary census count
pop_2022_total <- c(
  "1" = 38956, "2" = 56469, "3" = 143884, "4" = 347759,
  "5" = 57667, "6" = 114574, "7" = 30324, "8" = 13598,
  "9" = 29944, "10" = 45499
)
# Region 4 has published sex breakdown: 170710 male, 177049 female
# National totals: 440882 male, 437792 female
# For other regions, we apply 2012 sex ratios to 2022 totals as a reasonable estimate
pop_2022_male_national <- 440882
pop_2022_female_national <- 437792

pop_2022_male <- c(
  "1" = round(38956 * (14450 / 27643)),
  "2" = round(56469 * (23554 / 46810)),
  "3" = round(143884 * (53794 / 107785)),
  "4" = 170710,
  "5" = round(57667 * (24833 / 49820)),
  "6" = round(114574 * (54963 / 109652)),
  "7" = round(30324 * (9721 / 18375)),
  "8" = round(13598 * (6032 / 11077)),
  "9" = round(29944 * (12479 / 24238)),
  "10" = round(45499 * (19791 / 39992))
)
pop_2022_female <- pop_2022_total - pop_2022_male

# 2012 age distribution (both sexes, from Final Census Count Table 4)
age_groups <- c("0-4","5-9","10-14","15-19","20-24","25-29","30-34","35-39",
                "40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79","80-84","85+")

age_2012_male <- c(35876,35954,42302,42749,31350,25487,26103,25457,24212,21573,
                   18878,14045,10479,6638,4817,3037,1714,1134)
age_2012_female <- c(34564,35314,40837,42049,31932,26574,26996,26022,23743,21542,
                     18566,14998,11034,7197,5522,3871,2365,2024)

# Historical census totals
hist_years <- c(1946, 1960, 1970, 1980, 1991, 2002, 2012, 2022)
hist_pop <- c(375701, 560330, 701718, 759567, 723673, 751223, 746955, 878674)

# National ethnicity (2012 census, % of total)
ethnicity_labels <- c("East Indian","African","Mixed","Amerindian","Portuguese","Chinese","White","Other")
ethnicity_pct <- c(39.8, 29.3, 19.9, 10.5, 0.2, 0.2, 0.06, 0.04)

# Build master data frames
pop_regional <- data.frame(
  region = rep(as.character(1:10), 2),
  year = rep(c(2012L, 2022L), each = 10),
  stringsAsFactors = FALSE
) %>%
  mutate(
    name = region_names[region],
    type = region_type[region],
    area = area_km2[region],
    male = ifelse(year == 2012, pop_2012_male[region], pop_2022_male[region]),
    female = ifelse(year == 2012, pop_2012_female[region], pop_2022_female[region]),
    total = male + female,
    density = round(total / area, 2),
    sex_ratio = round(male / female * 100, 1),
    pct_share = NA_real_
  )

for (yr in c(2012L, 2022L)) {
  idx <- pop_regional$year == yr
  national <- sum(pop_regional$total[idx])
  pop_regional$pct_share[idx] <- round(pop_regional$total[idx] / national * 100, 2)
}

pop_historical <- data.frame(year = hist_years, population = hist_pop)

age_pyramid <- data.frame(
  age_group = factor(rep(age_groups, 2), levels = age_groups),
  sex = rep(c("Male", "Female"), each = length(age_groups)),
  count = c(age_2012_male, age_2012_female)
)

ethnicity_df <- data.frame(
  group = factor(ethnicity_labels, levels = ethnicity_labels),
  percentage = ethnicity_pct
)



gy_green  <- "#009E49"
gy_gold   <- "#FFD100"
gy_red    <- "#CE1126"
gy_black  <- "#000000"
gy_white  <- "#FFFFFF"
gy_dark   <- "#0A1A0F"
gy_panel  <- "#0F261A"
gy_card   <- "#132E1F"
gy_text   <- "#E8F5E9"
gy_muted  <- "#81C784"

gy_theme <- theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = gy_panel, colour = NA),
    panel.background = element_rect(fill = gy_panel, colour = NA),
    panel.grid.major = element_line(colour = alpha(gy_green, 0.15), linewidth = 0.3),
    panel.grid.minor = element_blank(),
    text = element_text(colour = gy_text, family = "sans"),
    plot.title = element_text(colour = gy_gold, face = "bold", size = 16, margin = margin(b = 8)),
    plot.subtitle = element_text(colour = gy_muted, size = 11, margin = margin(b = 12)),
    axis.text = element_text(colour = gy_muted, size = 10),
    axis.title = element_text(colour = gy_text, size = 12),
    legend.background = element_rect(fill = gy_panel, colour = NA),
    legend.text = element_text(colour = gy_text),
    legend.title = element_text(colour = gy_gold),
    strip.text = element_text(colour = gy_gold, face = "bold")
  )

# Regional age data for pyramid filtering
age_2012_region_male <- data.frame(
  age_group = factor(age_groups, levels = age_groups),
  r1=c(1987,2001,2164,1687,1120,832,846,740,684,642,539,355,264,228,141,114,61,45),
  r2=c(2272,2312,2830,2949,1972,1489,1427,1342,1436,1448,1293,906,724,409,347,208,119,71),
  r3=c(4705,4778,5809,6065,4623,3691,3897,3988,3740,3382,2977,2244,1551,873,719,392,232,128),
  r4=c(13952,13927,16175,16958,13410,11246,11193,10946,10096,8625,7790,5960,4605,2827,1985,1254,725,514),
  r5=c(2284,2337,3002,2926,2029,1494,1624,1673,1729,1528,1244,945,714,548,357,201,113,85),
  r6=c(4698,4898,6236,6704,4383,3521,3906,3897,3894,3561,3103,2099,1516,1010,704,453,238,142),
  r7=c(1110,1027,1017,1049,851,755,743,683,576,578,421,371,196,123,93,66,39,23),
  r8=c(813,686,727,638,488,512,436,388,374,306,231,160,101,66,49,34,16,7),
  r9=c(1880,1863,1865,1239,884,730,712,604,560,530,418,351,322,198,139,90,55,39),
  r10=c(2175,2125,2477,2534,1590,1217,1319,1196,1123,973,862,654,486,356,283,225,116,80)
)

age_2012_region_female <- data.frame(
  age_group = factor(age_groups, levels = age_groups),
  r1=c(1909,1977,2167,1573,1013,744,710,642,536,535,375,312,212,173,126,109,50,30),
  r2=c(2185,2379,2746,2864,1839,1413,1420,1450,1452,1348,1185,964,706,437,351,237,165,115),
  r3=c(4503,4688,5519,6011,4734,3872,4028,4040,3675,3391,2856,2203,1630,996,814,489,318,224),
  r4=c(13558,13663,15903,17052,14065,12074,12073,11702,10349,9241,8312,6818,5087,3193,2383,1751,1098,1053),
  r5=c(2161,2290,2776,2994,2019,1682,1807,1689,1628,1451,1238,994,842,491,351,305,156,113),
  r6=c(4392,4638,5998,6484,4445,3646,3918,3870,3732,3526,2868,2317,1570,1152,914,585,346,288),
  r7=c(1205,1069,940,920,831,633,573,518,486,413,323,260,159,116,82,64,34,28),
  r8=c(800,707,641,514,473,371,323,290,212,201,168,121,71,47,40,29,24,13),
  r9=c(1783,1769,1829,1310,885,683,642,515,445,412,358,314,254,222,148,81,60,49),
  r10=c(2068,2134,2318,2327,1628,1456,1502,1306,1228,1024,883,695,503,370,313,221,114,111)
)


server <- function(input, output, session) {

  # --- Regional Population Plot ---
  output$plot_regional <- renderPlot({
    metric <- input$reg_metric
    yr <- input$reg_year

    metric_label <- switch(metric,
      "total" = "Total Population",
      "density" = "Population Density (persons per km\u00B2)",
      "sex_ratio" = "Sex Ratio (males per 100 females)",
      "pct_share" = "Share of National Population (%)"
    )

    if (yr == "both") {
      df <- pop_regional
    } else {
      df <- pop_regional %>% filter(year == as.integer(yr))
    }

    df$region_label <- paste0("Region ", df$region, "\n", df$name)

    if (input$reg_sort && yr != "both") {
      df$region_label <- reorder(df$region_label, df[[metric]])
    } else {
      df$region_label <- factor(df$region_label,
        levels = unique(df$region_label[order(as.integer(df$region))]))
    }

    if (yr == "both") {
      df$year_f <- factor(df$year)
      if (input$reg_sort) {
        ord <- df %>% filter(year == 2022) %>% arrange(!!sym(metric)) %>% pull(region_label)
        df$region_label <- factor(df$region_label, levels = ord)
      }
      p <- ggplot(df, aes(x = region_label, y = .data[[metric]], fill = year_f)) +
        geom_col(position = position_dodge(width = 0.8), width = 0.7) +
        scale_fill_manual(values = c("2012" = gy_green, "2022" = gy_gold), name = "Census Year") +
        coord_flip()
    } else {
      p <- ggplot(df, aes(x = region_label, y = .data[[metric]])) +
        geom_col(fill = if (yr == "2012") gy_green else gy_gold, width = 0.65) +
        coord_flip()
    }

    fmt <- if (metric == "total") label_comma() else label_number(accuracy = 0.1)
    if (metric %in% c("pct_share", "sex_ratio")) fmt <- label_number(accuracy = 0.1)

    p + scale_y_continuous(labels = fmt, expand = expansion(mult = c(0, 0.1))) +
      labs(title = metric_label, subtitle = if (yr != "both") paste("Census", yr) else "2012 vs 2022",
           x = NULL, y = NULL) +
      gy_theme +
      theme(axis.text.y = element_text(size = 9, lineheight = 0.95))
  })

  # --- Population Pyramid ---
  output$plot_pyramid <- renderPlot({
    sel <- input$pyr_regions

    if (sel == "all") {
      df <- age_pyramid
    } else {
      col <- paste0("r", sel)
      m <- age_2012_region_male[[col]]
      f <- age_2012_region_female[[col]]
      df <- data.frame(
        age_group = factor(rep(age_groups, 2), levels = age_groups),
        sex = rep(c("Male", "Female"), each = length(age_groups)),
        count = c(m, f)
      )
    }

    df$count_plot <- ifelse(df$sex == "Male", -df$count, df$count)
    max_val <- max(abs(df$count_plot))

    region_label <- if (sel == "all") "National" else paste0("Region ", sel, " \u2013 ", region_names[sel])

    ggplot(df, aes(x = age_group, y = count_plot, fill = sex)) +
      geom_col(width = 0.85) +
      coord_flip() +
      scale_y_continuous(
        labels = function(x) label_comma()(abs(x)),
        limits = c(-max_val * 1.1, max_val * 1.1)
      ) +
      scale_fill_manual(values = c("Male" = gy_green, "Female" = gy_gold), name = "Sex") +
      labs(title = paste("Population Pyramid \u2013", region_label),
           subtitle = "2012 Census (Final Adjusted Count)",
           x = "Age Group", y = "Population") +
      geom_vline(xintercept = 0, colour = gy_muted, linewidth = 0.3) +
      gy_theme
  })

  # --- Historical Trend ---
  output$plot_historical <- renderPlot({
    p <- ggplot(pop_historical, aes(x = year, y = population)) +
      geom_area(fill = alpha(gy_green, 0.25), colour = NA) +
      geom_line(colour = gy_gold, linewidth = 1.2) +
      geom_point(colour = gy_gold, size = 3.5, shape = 21, fill = gy_dark, stroke = 1.5)

    if (input$hist_labels) {
      p <- p + geom_text(aes(label = label_comma()(population)),
                         colour = gy_text, size = 3.5, vjust = -1.5, fontface = "bold")
    }

    p + scale_x_continuous(breaks = hist_years) +
      scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.15)),
                         limits = c(0, NA)) +
      labs(title = "Population of Guyana Over Time",
           subtitle = "Decennial Census Counts, 1946\u20132022",
           x = "Census Year", y = "Population") +
      gy_theme
  })

  # --- Ethnicity ---
  output$plot_ethnicity <- renderPlot({
    if (input$eth_type == "bar") {
      ggplot(ethnicity_df, aes(x = reorder(group, percentage), y = percentage)) +
        geom_col(fill = gy_gold, width = 0.6) +
        geom_text(aes(label = paste0(percentage, "%")), hjust = -0.2,
                  colour = gy_text, size = 4, fontface = "bold") +
        coord_flip() +
        scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
        labs(title = "Ethnic Composition of Guyana",
             subtitle = "2012 Census (%  of total population)",
             x = NULL, y = "Percentage (%)") +
        gy_theme
    } else {
      eth_cols <- c(gy_green, gy_gold, gy_red, "#4CAF50", "#FFA726", "#AB47BC", "#29B6F6", "#78909C")
      ggplot(ethnicity_df, aes(x = "", y = percentage, fill = group)) +
        geom_col(width = 1, colour = gy_dark, linewidth = 0.5) +
        coord_polar("y") +
        scale_fill_manual(values = eth_cols, name = "Ethnic Group") +
        labs(title = "Ethnic Composition of Guyana",
             subtitle = "2012 Census") +
        gy_theme +
        theme(axis.text = element_blank(), axis.title = element_blank(),
              panel.grid = element_blank())
    }
  })

  # --- Coastland vs Hinterland ---
  output$plot_coast_hint <- renderPlot({
    yr <- as.integer(input$ch_year)
    df <- pop_regional %>% filter(year == yr)

    summary_df <- df %>%
      group_by(type) %>%
      summarise(
        population = sum(total),
        area = sum(area),
        .groups = "drop"
      ) %>%
      mutate(
        pop_pct = round(population / sum(population) * 100, 1),
        area_pct = round(area / sum(area) * 100, 1)
      )

    plot_df <- summary_df %>%
      select(type, Population = pop_pct, `Land Area` = area_pct) %>%
      pivot_longer(-type, names_to = "measure", values_to = "pct")

    ggplot(plot_df, aes(x = measure, y = pct, fill = type)) +
      geom_col(position = "stack", width = 0.55) +
      geom_text(aes(label = paste0(pct, "%")),
                position = position_stack(vjust = 0.5),
                colour = gy_dark, fontface = "bold", size = 5) +
      scale_fill_manual(values = c("Coastland" = gy_gold, "Hinterland" = gy_green),
                        name = "Region Type") +
      scale_y_continuous(labels = label_percent(scale = 1)) +
      labs(title = "Coastland vs Hinterland",
           subtitle = paste0(yr, " Census \u2013 Share of Population vs Share of Land Area"),
           x = NULL, y = NULL) +
      gy_theme +
      theme(axis.text.x = element_text(size = 14, face = "bold"))
  })
}

