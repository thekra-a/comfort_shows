
## **The Media We Consume for Comfort**
#### *Analysis of your good ol' heartwarming TV shows*

-----\n---

#### **1. Introduction**

With the mass rise in media content produced and consumed daily, researchers ought to answer if certain media types can be used as a form of comfort experience. In fact, a growing body of evidence has highlighted that certain types of media can produce soothing effects during times of physical or social stressors. Similar to comfort food (Wansink et al., 2003), comfort media is classified as a comfort experience that creates a positive psychological impact such as reduced distress and mood regulation with low cognitive arousal (Grady et al., 2025). 

Among many differentiating characteristics, comfort shows can be nostalgic *(a feeling of yearning or ‘homesickness’ for a time period, rather than a place)*, but not necessarily. Nostalgic watches are associated with an emotional attachment to certain positive time periods in a person's life (e.g. childhood) offering a sense of security and connection. Another key characteristic that makes a show “comforting” is the predictable storyline. This not only spares you mind the 'decision fatigue' at the end of a long day at word, but also minimum conginitive and emotional involvement is required which reduces the anxiety associated with the anticipation of unknown events.


#### **2. Methods**

Comfort is a widely subjective and personal experience. This analysis covered list of thirty-six comfort shows created by an IMDB user (see Data Sources section for links) to run an exploratory data analysis. The main inclusion criteria were English-speaking, TV series.



##### **2.1 Data Source**

* Show titles, IMDB ID, ratings, votes, runtime, genres, year | [IMDb personal list export](https://www.imdb.com/list/) |
| 
* Number of seasons and episodes per show scraped using TMDB API| [TMDB API](https://www.themoviedb.org/documentation/api) |


A full data dictionary is available in the `data` folder of this repository.



#### **3. Tech Stack**


**Language:** R | **Data manipulation:** | `tidyverse` (`dplyr`, `tidyr`, `stringr`, `forcats`) | **API calls:** `httr` | **Visualisation:** `ggplot2` | **Version control:** | Git, GitHub |



#### **4. Data Analysis**


* **4.1 Data extraction**

The data used in this analysis was obtained from two sources: 

* **a direct export from IMDB**
A list of 63 shows was exported directly from IMDB as a CSV file (see *Data Sources* section above for links, see *data dictiornary.md* for a descripton of the data. The list was inspected using `str()`, `head()`, `summary()`, `colSums(is.na())`, as well as a manual review of the genres column to assess the most suitable data cleaning strategy.

* **webscraping using The Movies Data Base (TMDB) API**
TMDB is an open-source movie and TV shows databased manually built by a community of movie enthusiasts. I've tried to originally scrape the data directly from IMDB using `read_html()`, however, the fuction failed due to IMDB's protection against bot scraping requests, leaving an API the next viable option :)


* **4.2 Data Cleaning**

Data cleaning included several steps such as `mutate()`, `rename()`Genre tags required special handling as each show had 2–4 genres as a single comma-separated string (e.g. `"Comedy, Drama, Romance"`). These were split using `separate_rows()` so each genre could be counted independently. This means one show contributes a count to every genre it belongs to, and totals across genres.

* **4.3 Exploratory Data Analysis (EDA) and visualization**

Discriptive statistics were used to summarize the data using `summary()` and `ggplot2()`. 
* See results section for the analysis and plots.
* See HTML file in this repository for the full narrative and interactive charts



#### **5. Results**

A list of 63 shows were extracted. 

```{r echo=FALSE}

```


#### **6. Limitations**


#### **7. References**

