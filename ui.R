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

ui <- fluidPage(
  tags$head(
    tags$link(href = "https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Playfair+Display:wght@700;900&display=swap", rel = "stylesheet"),
    tags$style(HTML(sprintf("
      body {
        background: %s;
        color: %s;
        font-family: 'DM Sans', sans-serif;
        margin: 0;
        padding: 0;
      }
      .container-fluid { max-width: 1100px; margin: auto; padding: 20px; }

      /* Header */
      .app-header {
        text-align: center;
        padding: 40px 20px 30px;
        border-bottom: 3px solid %s;
        margin-bottom: 30px;
        background: linear-gradient(180deg, %s 0%%, %s 100%%);
      }
      .app-header h1 {
        font-family: 'Playfair Display', serif;
        font-weight: 900;
        font-size: 2.4em;
        color: %s;
        margin: 0 0 6px 0;
        letter-spacing: 0.5px;
      }
      .app-header .subtitle {
        color: %s;
        font-size: 1.05em;
        font-weight: 400;
      }
      .app-header .flag-bar {
        height: 5px;
        background: linear-gradient(90deg, %s 0%%, %s 33%%, %s 66%%, %s 100%%);
        margin-top: 20px;
        border-radius: 3px;
      }

      /* Cards */
      .stat-card {
        background: %s;
        border: 1px solid %s;
        border-radius: 10px;
        padding: 18px;
        margin-bottom: 15px;
        text-align: center;
      }
      .stat-card .stat-value {
        font-family: 'Playfair Display', serif;
        font-size: 2em;
        font-weight: 900;
        color: %s;
      }
      .stat-card .stat-label {
        color: %s;
        font-size: 0.85em;
        margin-top: 4px;
      }

      /* Sidebar controls */
      .well {
        background: %s !important;
        border: 1px solid %s !important;
        border-radius: 10px !important;
        color: %s !important;
      }
      .control-label, label { color: %s !important; font-weight: 500; }
      select, .selectize-input {
        background: %s !important;
        color: %s !important;
        border: 1px solid %s !important;
      }
      .selectize-dropdown { background: %s !important; color: %s !important; }
      .selectize-dropdown-content .option:hover { background: %s !important; }

      .radio label { color: %s !important; }

      /* Tabs */
      .nav-tabs { border-bottom: 2px solid %s; }
      .nav-tabs > li > a {
        color: %s !important;
        background: transparent !important;
        border: none !important;
        font-weight: 500;
        padding: 10px 18px;
      }
      .nav-tabs > li.active > a, .nav-tabs > li > a:hover {
        color: %s !important;
        border-bottom: 3px solid %s !important;
        background: transparent !important;
      }

      /* Plot outputs */
      .shiny-plot-output { border-radius: 8px; overflow: hidden; }

      /* Documentation tab */
      .doc-section {
        background: %s;
        border: 1px solid %s;
        border-radius: 10px;
        padding: 24px;
        margin-bottom: 20px;
        line-height: 1.7;
      }
      .doc-section h3 {
        color: %s;
        font-family: 'Playfair Display', serif;
        margin-top: 0;
      }
      .doc-section p, .doc-section li { color: %s; }
      .doc-section strong { color: %s; }
      .doc-section code {
        background: %s;
        color: %s;
        padding: 2px 6px;
        border-radius: 3px;
        font-size: 0.9em;
      }

      hr { border-color: %s; }
      .footer {
        text-align: center;
        color: %s;
        font-size: 0.8em;
        padding: 20px 0;
        border-top: 1px solid %s;
        margin-top: 30px;
      }
    ",
    gy_dark, gy_text,
    gy_green,
    gy_dark, gy_panel,
    gy_gold,
    gy_muted,
    gy_green, gy_gold, gy_red, gy_black,
    gy_card, alpha(gy_green, 0.3),
    gy_gold,
    gy_muted,
    gy_card, alpha(gy_green, 0.3), gy_text,
    gy_gold,
    gy_dark, gy_text, alpha(gy_green, 0.4),
    gy_dark, gy_text,
    gy_green,
    gy_text,
    alpha(gy_green, 0.3),
    gy_muted,
    gy_gold, gy_gold,
    gy_card, alpha(gy_green, 0.3),
    gy_gold,
    gy_text, gy_gold,
    gy_dark, gy_green,
    alpha(gy_green, 0.2),
    gy_muted,
    alpha(gy_green, 0.2)
    )))
  ),

  # Header
  div(class = "app-header",
    h1("\U0001F1EC\U0001F1FE  Guyana National Census"),
    div(class = "subtitle", "Population & Housing Census \u2022 2012 & 2022 \u2022 Bureau of Statistics"),
    div(class = "flag-bar")
  ),

  # Summary stat cards
  fluidRow(
    column(3, div(class = "stat-card",
      div(class = "stat-value", "878,674"),
      div(class = "stat-label", "2022 Population")
    )),
    column(3, div(class = "stat-card",
      div(class = "stat-value", "+17.6%"),
      div(class = "stat-label", "Growth from 2012")
    )),
    column(3, div(class = "stat-card",
      div(class = "stat-value", "10"),
      div(class = "stat-label", "Administrative Regions")
    )),
    column(3, div(class = "stat-card",
      div(class = "stat-value", "214,999 km\u00B2"),
      div(class = "stat-label", "Total Land Area")
    ))
  ),

  br(),

  tabsetPanel(id = "main_tabs", type = "tabs",

    # TAB 1: Regional comparison
    tabPanel("Regional Population",
      br(),
      sidebarLayout(
        sidebarPanel(width = 3,
          radioButtons("reg_year", "Census Year",
            choices = c("2012" = "2012", "2022" = "2022", "Compare Both" = "both"),
            selected = "both"
          ),
          selectInput("reg_metric", "Metric",
            choices = c(
              "Total Population" = "total",
              "Population Density (per km\u00B2)" = "density",
              "Sex Ratio (males per 100 females)" = "sex_ratio",
              "Share of National Population (%)" = "pct_share"
            )
          ),
          checkboxInput("reg_sort", "Sort by value", value = TRUE),
          hr(),
          helpText("Data: Bureau of Statistics, Guyana. 2012 Final Census Count; 2022 Preliminary Report.")
        ),
        mainPanel(width = 9,
          plotOutput("plot_regional", height = "520px")
        )
      )
    ),

    # TAB 2: Population pyramid
    tabPanel("Age & Sex Pyramid",
      br(),
      sidebarLayout(
        sidebarPanel(width = 3,
          helpText("Population pyramid based on the 2012 Census final adjusted count, the most recent census with published age-sex breakdowns."),
          selectInput("pyr_regions", "Filter by Region(s)",
            choices = c("All Regions (National)" = "all", setNames(as.character(1:10), paste0("Region ", 1:10, " \u2013 ", region_names))),
            selected = "all"
          ),
          hr(),
          helpText("Age-sex data for the 2022 Census is not yet published in the preliminary report.")
        ),
        mainPanel(width = 9,
          plotOutput("plot_pyramid", height = "560px")
        )
      )
    ),

    # TAB 3: Historical trend
    tabPanel("Historical Trend",
      br(),
      sidebarLayout(
        sidebarPanel(width = 3,
          helpText("Population of Guyana from independence-era to present, based on decennial censuses."),
          checkboxInput("hist_labels", "Show population labels", value = TRUE),
          hr(),
          helpText("Source: Bureau of Statistics census timeline. Figures from 1946\u20132022 official census counts.")
        ),
        mainPanel(width = 9,
          plotOutput("plot_historical", height = "480px")
        )
      )
    ),

    # TAB 4: Ethnicity
    tabPanel("Ethnic Composition",
      br(),
      sidebarLayout(
        sidebarPanel(width = 3,
          helpText("Ethnic composition of Guyana based on the 2012 Census (most recent with published ethnicity data)."),
          radioButtons("eth_type", "Chart Type",
            choices = c("Bar Chart" = "bar", "Pie Chart" = "pie"),
            selected = "bar"
          ),
          hr(),
          helpText("Source: 2012 Census Compendium 2 \u2013 Population Composition.")
        ),
        mainPanel(width = 9,
          plotOutput("plot_ethnicity", height = "480px")
        )
      )
    ),

    # TAB 5: Coastland vs Hinterland
    tabPanel("Coast vs Hinterland",
      br(),
      sidebarLayout(
        sidebarPanel(width = 3,
          radioButtons("ch_year", "Census Year",
            choices = c("2012" = "2012", "2022" = "2022"),
            selected = "2022"
          ),
          helpText("Guyana's population is heavily concentrated on the narrow coastal strip. The hinterland regions (1, 7, 8, 9) cover over two-thirds of the land area but hold a small fraction of the population."),
          hr(),
          helpText("Data: Bureau of Statistics.")
        ),
        mainPanel(width = 9,
          plotOutput("plot_coast_hint", height = "480px")
        )
      )
    ),

    # TAB 6: Documentation
    tabPanel("About / Documentation",
      br(),
      div(class = "doc-section",
        h3("Welcome to the Guyana Census"),
        p("This interactive application lets you explore data from Guyana's Population & Housing Census, comparing the ", strong("2012 (final adjusted)"), " and ", strong("2022 (preliminary)"), " census results across all 10 administrative regions."),
        p("It was built as a course project for the Johns Hopkins Developing Data Products course on Coursera.")
      ),
      div(class = "doc-section",
        h3("How to Use This App"),
        tags$ul(
          tags$li(strong("Regional Population:"), " Compare regions using total population, density, sex ratio, or population share. Toggle between 2012, 2022, or a side-by-side comparison. Check ", tags$code("Sort by value"), " to rank regions."),
          tags$li(strong("Age & Sex Pyramid:"), " View the national age-sex distribution from 2012. Select individual regions to see their structure."),
          tags$li(strong("Historical Trend:"), " See how Guyana's population has changed across census years since 1946."),
          tags$li(strong("Ethnic Composition:"), " Explore the ethnic makeup of Guyana from the 2012 Census as a bar or pie chart."),
          tags$li(strong("Coast vs Hinterland:"), " Compare population and land area between Guyana's coastal and hinterland regions.")
        )
      ),
      div(class = "doc-section",
        h3("Data Sources"),
        tags$ul(
          tags$li("Bureau of Statistics (Guyana) \u2013 Final 2012 Census Count"),
          tags$li("Bureau of Statistics (Guyana) \u2013 2012 Census Compendium 1 & 2"),
          tags$li("Bureau of Statistics (Guyana) \u2013 Preliminary Report, 2022 National Population & Housing Census"),
          tags$li("Guyana Lands and Surveys Commission Fact Page")
        ),
        p("All data is publicly available at ", tags$a(href = "https://statisticsguyana.gov.gy/census/", target = "_blank", "statisticsguyana.gov.gy/census"))
      ),
      div(class = "doc-section",
        h3("Notes"),
        tags$ul(
          tags$li("The 2022 figures are preliminary and subject to revision in the final report."),
          tags$li("Sex breakdowns by region for 2022 are estimated using 2012 sex ratios applied to 2022 regional totals, except for Region 4 where the breakdown was published."),
          tags$li("Age-sex and ethnicity data for the 2022 Census have not yet been released."),
          tags$li("Population density uses the area figures from the Guyana Lands and Surveys Commission.")
        )
      )
    )
  ),

  div(class = "footer",
    "\u00A9 2026 \u2022 Tulsidai Singh \u2022 Data: Bureau of Statistics, Guyana"
  )
)

