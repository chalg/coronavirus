# Libraries
library(tidyverse)
library(zoo)

# Data

data_path <- "~/R/coronavirus/data/"   # path to the data

files <- dir(data_path, pattern = "*.csv") # get file names

coronadf <- files %>%
  map_df(~ read_csv(file.path(data_path, .),
                    col_types = cols(tstamp = col_date())))

# Experiments
coronadf %>% glimpse()

corona_new_cases_tbl <- coronadf %>% 
  
  # filter(country %in% c("Australia", "Italy", "Singapore", "South Korea", "Spain",
  #                       "Kazakhstan", "Iran", "India", "Brazil", "United States", "Russia", "South Africa"),
  #        
  filter(country %in% c("Australia", "Italy", "Singapore", "South Korea", "Spain",
                        "China", "Iran", "India", "Brazil", "United States", "South Africa"),
         observation %in% c("new_cases"),
         !is.na(count)) %>% 
  group_by(country) %>% 
  # Use align = right to move NAs away from end of time series. Default is center.
  mutate(roll_mean = rollmean(count, 7, align = "right", fill = NA)) %>% 
  ungroup() %>% 
  # Add label_date in case lastest data point is missing for a particular observation.
  group_by(country) %>% 
  mutate(label_date = max(tstamp)) %>% 
  ungroup()
  
corona_new_cases_tbl %>% glimpse()

# This correlation between the US and India seems a bit too high.
corona_new_cases_tbl %>% 
  filter(country %in% c("United States", "India")) %>% 
  arrange(desc(tstamp)) %>% 
  slice(1:100) %>% 
  ggplot(aes(tstamp, count, colour = country)) +
  geom_line() +
  geom_point()

corona_new_cases_tbl %>%
  filter(!is.na(roll_mean)) %>% 
  ggplot(aes(tstamp, roll_mean, colour = country)) +
  geom_line(size = 1) +
  ggrepel::geom_text_repel(data = corona_new_cases_tbl %>% filter(tstamp == label_date),
                           aes(x = tstamp, y = roll_mean, label = country, group = country),
                           segment.size  = 0.2,
                           size          = 2,
                           segment.color = "grey50",
                           alpha         = 1,
                           hjust         = 0,
                           nudge_x       = 1,
                           direction     = "y") +
  scale_y_log10(labels = scales::comma) +
  scale_x_date(date_breaks = "2 week", date_labels = "%d %b") +
  labs(title = "Coronavirus Trend - New cases (7 day rolling mean)",
       y = "New Cases (log scale)", x = "",
       caption = "Source: @GrantChalmers | https://www.worldometers.info/coronavirus/") + 
  tidyquant::scale_colour_tq() +
  theme_light() +
  theme(plot.title = element_text(size = 11, face = "bold"),
        axis.text.x = element_text(size = 10, angle = 00),
        axis.title.x = element_text(size = 9),
        strip.text.x = element_text(size = 10, colour = "darkgreen", face = "bold"),
        plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"),
        axis.title = element_text(size = 11), legend.position = "none",
        plot.caption = element_text(size = 7.5, color = "gray50", face = "italic"),
        legend.title = element_blank())

ggsave("corona_new_cases_roll_mean_7_2.png", path = "images", width = 8, height = 6)

corona_tot_cases_1m_pop_tbl <- coronadf %>% 
  filter(country %in% c("Australia", "Italy", "Singapore", "South Korea", "Spain",
                        "Kazakhstan", "Iran", "India", "Brazil", "United States", "Russia", "South Africa"),
         observation %in% c("tot_cases_1m_pop"), #tot_cases_1m_pop
         !is.na(count)) %>% 
  group_by(country) %>% 
  mutate(roll_mean = rollmean(count, 7, align = "right", fill = NA)) %>% 
  ungroup()

corona_tot_cases_1m_pop_tbl %>%
  filter(!is.na(roll_mean)) %>% 
  ggplot(aes(tstamp, roll_mean)) +
  geom_line(size = 1, colour = "cornflowerblue") +
  # ggrepel::geom_label_repel(data = corona_tot_cases_1m_pop_tbl %>% filter(tstamp == max(tstamp) - 7),
  #                           aes(x = tstamp, y = roll_mean, label = country, group = country), size = 2.5) +
  scale_y_continuous(labels = scales::comma) +
  # scale_y_log10(labels = scales::comma) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  # expand_limits(y = 0) +
  labs(title = "Coronavirus Trend - Total Cases per 1M Population (7 day rolling mean)",
       y = "Total Cases per 1M Population", x = "",
       caption = "Source: @GrantChalmers | https://www.worldometers.info/coronavirus/") +
  facet_wrap(~ country, scales = "free_y") +
  theme_light() +
  theme(plot.title = element_text(size = 11, face = "bold"),
        axis.text.x = element_text(size = 10, angle = 00),
        axis.title.x = element_text(size = 9, angle = 90),
        strip.text.x = element_text(size = 10, colour = "darkgreen", face = "bold"),
        plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"),
        axis.title = element_text(size = 11), legend.position = "none",
        plot.caption = element_text(size = 7.5, color = "gray50", face = "italic"),
        legend.title = element_blank())

ggsave("corona_tot_cases_1m_pop_roll_mean_7_log10.png", path = "images", width = 8, height = 6)

remotes::install_github("business-science/timetk")
install.packages('timetk')

library(timetk)
# corona_total_cases_tbl <- coronadf %>%
#     filter(country %in% c("Australia", "Italy", "Singapore", "South Korea", "Spain",
#                         "Kazakhstan", "Iran", "India", "Brazil", "United States", "Russia", "South Africa"),
#          # 
#          # filter(country %in% c("Australia", "Italy", "Singapore", "South Korea", "Spain",
#          #                       "China", "Iran", "India", "Brazil", "United States"),
#          observation %in% c("total_cases"),
#          !is.na(count)) %>% 
#   group_by(country) %>% 
#   # Use align = right to move NAs away from end of time series. Default is center.
#   mutate(roll_mean = rollmean(count, 7, align = "right", fill = NA)) %>% 
#   ungroup() 
# 
# corona_total_cases_tbl %>% glimpse()
# 
# 
# corona_total_cases_tbl %>% 
#   filter(!is.na(roll_mean)) %>% 
#   ggplot(aes(tstamp, roll_mean, colour = country, label = country)) +
#   geom_line(size = 1) +
#   ggrepel::geom_text_repel(data = corona_total_cases_tbl %>% filter(tstamp == max(tstamp)),
#                            size = 2.5,
#                            alpha = 1,
#                            hjust = 0,
#                            nudge_x = 1,
#                            direction = "y") +
#   scale_y_log10(labels = scales::comma) +
#   # scale_y_continuous(labels = scales::comma) +
#   scale_x_date(date_breaks = "2 week", date_labels = "%d %b") +
#   labs(title = "Coronavirus Trend - Total cases (7 day rolling mean)",
#        y = "Total Cases (log scale)", x = "",
#        caption = "Source: @GrantChalmers | https://www.worldometers.info/coronavirus/") + 
#   # facet_wrap(~ country) +
#   tidyquant::scale_colour_tq() +
#   theme_light() +
#   theme(plot.title = element_text(size = 11, face = "bold"),
#         axis.text.x = element_text(size = 10, angle = 00),
#         axis.title.x = element_text(size = 9),
#         strip.text.x = element_text(size = 10, colour = "darkgreen", face = "bold"),
#         plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"),
#         axis.title = element_text(size = 11), legend.position = "none",
#         plot.caption = element_text(size = 7.5, color = "gray50", face = "italic"),
#         legend.title = element_blank())
# 
# ggsave("corona_total_cases_roll_mean_7_log10.png", path = "images", width = 8, height = 6)
# 
