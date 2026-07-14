## Data Dictionary

**File:** `comfort_shows_list.csv`
**Rows:** 63 · **Columns:** 16


- **Position** *(integer)* — row number in the IMDb list

- **Const** *(character)* — IMDb unique ID for the title (e.g. `tt0386676`) — used as the lookup key for the TMDB API

- **Created** *(date)* — date the entry was added to the IMDb list

- **Modified** *(date)* — date the entry was last modified

- **Description** — empty in this export; IMDb artifact, ignored

- **Title** *(character)* — show name

- **Original Title** *(character)* — original-language title if different from Title

- **URL** *(character)* — IMDb page URL for the title

- **Title Type** *(character)* — content type; either `TV Series` or `TV Special`

- **IMDb Rating** *(numeric)* — average IMDb user rating on a 0–10 scale

- **Runtime (mins)** *(numeric)* — average episode runtime in minutes, not total series runtime

- **Year** *(integer)* — premiere year

- **Genres** *(character)* — comma-separated genre tags (e.g. `"Comedy, Drama, Romance"`); use `separate_rows()` to split into one genre per row

- **Num Votes** *(integer)* — total number of IMDb user ratings

- **Release Date** *(date)* — full premiere date

- **Directors** *(character)* — not meaningful for TV series, ignored
