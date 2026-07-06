
# Comfort Shows Data Analysis



library(tidyverse)
library(ggplot2)
library(httr)


shows_raw <- read_csv("C:/Users/Thekra/Desktop/comfort shows/R/comfort_shows_list.csv")



# structure and column types 
str(shows_raw)
dim(shows_raw)
head(shows_raw)

# column names
names(shows_raw)


# types of shows
table(shows_raw$`Title Type`)


# missing values
colSums(is.na(shows_raw))

# printing rows with missing values
shows_raw %>%
  filter(if_any(everything(), is.na))

# Runtime (mins) has one NA (Strange Planet has no runtime listed on IMDb)
# Description column is entirely NA

# distribution of IMDb ratings 
summary(shows_raw$`IMDb Rating`)

# distribution of vote counts 
summary(shows_raw$`Num Votes`)
# Big spread expected: Fleabag has ~250k, some newer shows have only ~2k

# --- Which shows have the most and fewest votes? ---
shows_raw %>%
  select(Title, `Num Votes`) %>%
  arrange(desc(`Num Votes`)) %>%
  slice(c(1:5, (n()-4):n()))   # top 5 and bottom 5

# --- Runtime: any weird values? ---
shows_raw %>%
  select(Title, `Runtime (mins)`) %>%
  arrange(`Runtime (mins)`) %>%
  print(n = Inf)
# Expect a range from ~21 mins (Ghosts) to ~61 mins (Zoey's Extraordinary Playlist)
# Strange Planet has NA — the only show with a missing runtime

# --- Year range: oldest to newest show ---
range(shows_raw$Year)
# Should span from ~1989 (Seinfeld) to 2024 (The Girls on the Bus)

# --- How many shows per year? Any year with many shows? ---
shows_raw %>%
  count(Year, sort = TRUE) %>%
  print(n = Inf)

# --- Glance at the genres column ---
shows_raw %>%
  select(Title, Genres) %>%
  print(n = Inf)
# Several shows have 2-4 genres as one string
# We'll split these properly later

# --- How many unique genres exist across the whole list? ---
shows_raw %>%
  separate_rows(Genres, sep = ", ") %>% # calling each genre separately using ", " as the delimiter
  distinct(Genres) %>%
  arrange(Genres)
# Gives us the full genre 


# ============================================================
# 3. FILTER & CLEAN (before scraping)
# ============================================================

shows <- shows_raw %>%
  filter(`Title Type` == "TV Series") %>%           # only keep TV Series
  filter(!str_detect(Genres, "Animation"))           # drop animated shows (Pokémon, Sailor Moon, Strange Planet)

# Confirm how many rows we dropped
nrow(shows_raw) - nrow(shows)   # should print 4 (1 TV Special + 3 animated shows)

# Rename and selecting necessary columns for analysis
shows <- shows %>%
  rename(
    title   = Title,
    rating  = `IMDb Rating`,
    runtime = `Runtime (mins)`,
    year    = Year,
    genres  = Genres,
    votes   = `Num Votes`
  ) %>%
  select(Const, title, rating, runtime, year, genres, votes) #Const is IMDB ID

# --- Check for missing values in our working columns ---
colSums(is.na(shows))
# With animation shows removed, runtime should have 0 NAs
# votes: 0 NAs
# rating: 0 NAs

# Confirm no NAs in runtime
sum(is.na(shows$runtime))   # should be 0

# --- Add a decade column to later analyze 1990s, 2000s, etc---
shows <- shows %>%
  mutate(decade = paste0(floor(year / 10) * 10, "s"))
# --- Add decade label as string---
shows <- shows %>%
  mutate(era = case_when(
    year < 2000 ~ "Pre-2000s",
    year < 2010 ~ "2000s",
    year < 2020 ~ "2010s",
    TRUE        ~ "2020s"
  ))


glimpse(shows)


# ============================================================
# 4. SCRAPE SEASONS + EPISODES FROM IMDb
# ============================================================
# the logic for this extraction is as follows: 
# > match imdb_id (from the csv file) with TMDB ID (if available) and store in find_data object
# > using find_data, extract tv show details and store in details object
# > parse details object to create episodes_data dataframe
# > join episode_data with shows dataframes on Const (imdb ID)


api_key <- "######"


get_show_info <- function(imdb_id) {
  
  # Find the TMDb ID using the IMDb ID
  find_url <- paste0(
    "https://api.themoviedb.org/3/find/", imdb_id,
    "?api_key=", api_key,
    "&external_source=imdb_id"
  )
  
  find_data <- GET(find_url) %>%
    content(as = "parsed", simplifyVector = TRUE)
  

  # Get season and episode counts
  tmdb_id <- find_data$tv_results$id[1]
  
  details_url <- paste0(
    "https://api.themoviedb.org/3/tv/", tmdb_id,
    "?api_key=", api_key
  )
  
  details <- GET(details_url) %>%
    content(as = "parsed", simplifyVector = TRUE)
  
  data.frame(
    imdb_id = imdb_id,
    seasons = details$number_of_seasons,
    episodes = details$number_of_episodes
  )
}

episode_data <- map_dfr(shows$Const, get_show_info)

shows <- shows %>%
  left_join(episode_data, by = c("Const" = "imdb_id"))


# ============================================================
# 5. Exploratory data analysis
# ============================================================

# 5.1 Overview

# 5.1.1 Total shows
nrow(shows)
# 5.1.2 Year range
print(min(shows$year), "–", max(shows$year))

# 5.2 Ratings

# 5.2.1 Average IMDB rating
round(mean(shows$rating), 2)
# 5.2.2 Highest rated show
shows$title[which.max(shows$rating)]
# 5.2.3.Lowest rated show
shows$title[which.min(shows$rating)]
# 5.2.4 
cat("Shows rated 8.5+:   ", sum(shows$rating >= 8.5), "\n")
cat("Shows rated below 7:", sum(shows$rating < 7), "\n\n")

cat("--- VOTES (POPULARITY) ---\n")
cat("Most voted:  ", shows$title[which.max(shows$votes)],
    "(", format(max(shows$votes), big.mark = ","), "votes )\n")
cat("Least voted: ", shows$title[which.min(shows$votes)],
    "(", format(min(shows$votes), big.mark = ","), "votes )\n")
cat("Median votes:", format(median(shows$votes), big.mark = ","), "\n\n")

cat("--- EPISODE COUNTS ---\n")
cat("Most episodes: ", shows$title[which.max(replace_na(shows$episodes, 0))],
    "(", max(shows$episodes, na.rm = TRUE), "eps,",
    shows$seasons[which.max(replace_na(shows$episodes, 0))], "seasons )\n")
cat("Fewest episodes:", shows %>% filter(!is.na(episodes)) %>%
    slice_min(episodes, n = 1) %>% pull(title),
    "(", min(shows$episodes, na.rm = TRUE), "eps )\n")
cat("Average episodes per show:", round(mean(shows$episodes, na.rm = TRUE), 0), "\n\n")

cat("--- RUNTIME ---\n")
shows <- shows %>%
  mutate(
    total_runtime_hrs = runtime * episodes / 60
  )
cat("Total hours of TV (estimated):",
    round(sum(shows$total_runtime_hrs, na.rm = TRUE)), "hrs\n")
cat("That's roughly",
    round(sum(shows$total_runtime_hrs, na.rm = TRUE) / 24), "days of continuous watching\n")
cat("Longest single show by hours:", shows %>%
    filter(!is.na(total_runtime_hrs)) %>%
    slice_max(total_runtime_hrs, n = 1) %>%
    mutate(label = paste0(title, " (", total_runtime_hrs, " hrs)")) %>%
    pull(label), "\n\n")

cat("--- GENRES ---\n")
genre_counts <- shows %>%
  separate_rows(genres, sep = ", ") %>%
  count(genres, sort = TRUE)
print(genre_counts)
cat("\n")

cat("--- BY DECADE ---\n")
shows %>%
  group_by(decade) %>%
  summarise(
    n            = n(),
    avg_rating   = round(mean(rating), 2),
    avg_episodes = round(mean(episodes, na.rm = TRUE), 0)
  ) %>%
  print()
cat("\n")


cat("High rating but low votes (potential hidden insights):\n")
shows %>%
  filter(rating >= 8.0, votes < 50000) %>%
  select(title, rating, votes) %>%
  arrange(desc(rating)) %>%
  print()

cat("\nHigh votes but lower rating (overhyped?):\n")
shows %>%
  filter(votes >= 200000, rating < 8.0) %>%
  select(title, rating, votes) %>%
  arrange(desc(votes)) %>%
  print()


# ============================================================
# 8. Data visualizatoin
# ============================================================


# Figure. 1 Top 15 shows by IMDb rating 
top_rated <- shows %>%
  arrange(desc(rating)) %>%
  slice(1:15) %>%
  mutate(title = fct_reorder(title, rating))

ggplot(top_rated, aes(x = rating, y = title)) +
  geom_col() +
  labs(title = "Top 15 Shows by IMDb Rating", x = "Rating", y = NULL)


# Figure. 2 Top 15 shows by vote count
top_votes <- shows %>%
  arrange(desc(votes)) %>%
  slice(1:15) %>%
  mutate(title = fct_reorder(title, votes))

ggplot(top_votes, aes(x = votes, y = title)) +
  geom_col() +
  labs(title = "Top 15 Shows by IMDb Votes", x = "Votes", y = NULL)


# Figure. 3 Genre frequency
genre_counts <- shows %>%
  separate_rows(genres, sep = ", ") %>%
  count(genres, sort = TRUE) %>%
  mutate(genres = fct_reorder(genres, n))

ggplot(genre_counts, aes(x = n, y = genres)) +
  geom_col() +
  labs(title = "Genre Frequency", x = "Number of shows", y = NULL)


# Figure. 4 Shows by premiere year
year_counts <- shows %>%
  count(year, name = "n")

ggplot(year_counts, aes(x = year, y = n)) +
  geom_col() +
  labs(title = "Shows by Premiere Year", x = "Year", y = "Number of shows")


# Figure. 5 Average rating by decade
ggplot(decade_avg, aes(x = decade, y = avg_rating)) +
  geom_col() +
  labs(title = "Average IMDb Rating by Decade", x = "Decade", y = "Avg Rating")


# Figure. 6 Episode count distribution 
shows %>%
  filter(!is.na(episodes)) %>%
  mutate(ep_bin = cut(
    episodes,
    breaks = c(0, 25, 50, 100, 150, 200, Inf),
    labels = c("1–25", "26–50", "51–100", "101–150", "151–200", "200+")
  )) %>%
  count(ep_bin) %>%
  ggplot(aes(x = ep_bin, y = n)) +
  geom_col() +
  labs(title = "Episode Count Distribution", x = "Episode range", y = "Number of shows")


# Figure. 7 Top 15 shows by episode count
top_episodes <- shows %>%
  filter(!is.na(episodes)) %>%
  arrange(desc(episodes)) %>%
  slice(1:15) %>%
  mutate(title = fct_reorder(title, episodes))

ggplot(top_episodes, aes(x = episodes, y = title)) +
  geom_col() +
  labs(title = "Top 15 Shows by Episode Count", x = "Total episodes", y = NULL)


# Figure. 8 Runtime vs episodes (bubble)
shows %>%
  filter(!is.na(episodes), !is.na(runtime)) %>%
  ggplot(aes(x = runtime, y = episodes, size = rating)) +
  geom_point(alpha = 0.6) +
  labs(title = "Runtime vs Episodes", x = "Episode runtime (mins)", y = "Total episodes", size = "Rating")
