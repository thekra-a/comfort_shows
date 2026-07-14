
## **The Media We Consume for Comfort**
#### *Analysis of your good ol' heartwarming TV shows*

------------------------


#### **1. Introduction**

With the mass rise in media content produced and consumed daily, researchers ought to answer if certain media types can be used as a form of comfort experience. In fact, a growing body of evidence has highlighted that certain types of media can produce soothing effects during times of physical or social stressors. Similar to comfort food (Wansink et al., 2003), comfort media is classified as a comfort experience that creates a positive psychological impact such as reduced distress and mood regulation with low cognitive arousal (Grady et al., 2025). 

Among many differentiating characteristics, comfort shows can be nostalgic, a feeling of yearning or ‘homesickness’ for a time period, rather than a place, but not necessarily. Nostalgic watches are associated with an emotional attachment to certain positive time periods in a person's life (e.g. childhood) offering a sense of security and connection. Another key characteristic that makes a show “comforting” is the predictable storyline. This not only spares you mind the *decision fatigue* at the end of a long day at word, but both minimum conginitive and emotional involvement reduce the anxiety associated with the anticipation of unknown events.


#### **2. Methods**

This analysis covered list of thirty-six comfort shows created by an IMDB user (see Data Sources section for links) to run an exploratory data analysis. The main inclusion criteria were English-speaking, TV series.

**Data Source**

* Show titles, IMDB ID, ratings, votes, runtime, genres, year: [IMDb personal list export](https://www.imdb.com/list/) 
* Number of seasons and episodes per show scraped using TMDB API: [TMDB API](https://www.themoviedb.org/documentation/api)

A full data dictionary is available in the `data` folder of this repository.


#### **3. Tech Stack**


**Language:** R | **Data manipulation:** `tidyverse` (`dplyr`, `tidyr`, `stringr`, `forcats`) | **API calls:** `httr` | **Visualisation:** `ggplot2` | **Version control:** Git, GitHub


#### **4. Data Analysis**

* **4.1 Data Extraction**

The data used in this analysis was obtained from two sources: 

* **a direct export from IMDB**
A list of 63 shows was exported directly from IMDB as a CSV file (see *Data Sources* section above for links, see *data dictiornary.md* for a descripton of the data.) The list was inspected using `str()`, `head()`, `summary()`, `colSums(is.na())`, as well as a manual review of the genres column to assess the most suitable data cleaning strategy.

* **webscraping using The Movies Data Base (TMDB) API**
TMDB is an open-source movie and TV shows databased manually built by a community of movie enthusiasts. I've tried to originally scrape the data directly from IMDB using `read_html()`, however, the fuction failed due to IMDB's protection against bot scraping requests, leaving an API the next viable option :)


* **4.2 Data Cleaning**

Data cleaning included several steps such as `mutate()`, `rename()`Genre tags required special handling as each show had 2–4 genres as a single comma-separated string (e.g. `"Comedy, Drama, Romance"`). These were split using `separate_rows()` so each genre could be counted independently. This means one show contributes a count to every genre it belongs to, and totals across genres.

* **4.3 Exploratory Data Analysis (EDA) and visualization**

Discriptive statistics were used to summarize the data using `summary()` and `ggplot2()`. 
* See results section for the analysis and plots.
* See HTML file in this repository for the full narrative and interactive charts



#### **5. Results**

A list of 63 shows were extracted from a personal IMDb export, and a total 59 TV series were retained for analysis. 

**IMDb Rating**

<img width="470" height="275" alt="image" src="https://github.com/user-attachments/assets/28872716-0bb9-4fcb-9fe6-676391f3de4f" />

Figure. 1 displays the top 10 shows by IMDb rating. The Office recorded the highest rating at 9.0, followed by Seinfeld (8.9), and Fleabag and Ted Lasso (both 8.7).

**Vote Count**

<img width="470" height="275" alt="image" src="https://github.com/user-attachments/assets/9dc12ce2-7f02-447a-8142-70e587c64100" />

Figure.2 displays the top 10 shows by total number of IMDb user votes. *The Office* recorded the highest vote count at 834,899, followed by *How I Met Your Mother* (782,945) and *Supernatural* (540,283).

**Genres**

<img width="470" height="275" alt="image" src="https://github.com/user-attachments/assets/b957750e-6386-4f9c-b969-9cfeec925214" />

Figure.3 displays the frequency of different genres across all 59 shows where a total of 15 distinct genres were identified. *Comedy* was the most frequently occurring genre (45 shows), followed by *Drama* (27) and *Romance* (14). 

**Premier Year**

<img width="470" height="275" alt="image" src="https://github.com/user-attachments/assets/7d3ed69b-58c6-4191-9e9f-1943708b2cde" />

Figure.4 displays the number of shows by premiere year, spanning 1989 to 2024. 2021 was the year with the highest number of shows aired (9 shows), followed by 2011 and 2015 with five shows each.


#### **6. Limitations**
This analysis is subject to several limitations. First, comfort is a highly subjective and personal experience, the shows included in this list reflect the creator's preference and may not align with what others consider comforting. As a result, the findings should not be interpreted as universally representative of comfort media.

Second, the dataset was limited to English-language TV series. Many viewers find comfort in other forms of media such as films, anime, K-Drama or even comfort creators on YouTube, all of which were not included in this analysis. Expanding the dataset to incorporate a broader range of international content would provide a more comprehensive understanding of comfort media consumption across different audiences.

-------------------------------------
#### **7. References**

1. Grady, S.M., Eden, A. and Wolfers, L.N. (2026) 'Examining Comfort Media: A Tool for Self-Regulation and Refuge?', Mass Communication and Society, 29(2), pp. 245–268. https://doi.org/10.1080/15205436.2025.2519191.
2. Wasnik, A., Yadav, A., Chuttani, K. and Singh, G. (2004) 'Evidence for existence of a common biological mechanism for homeostatic modulation of memory by melatonin and L-arginine in mice', Physiological Behaviour, 81(2), pp. 299–308. https://doi.org/10.1016/j.physbeh.2003.12.012.
