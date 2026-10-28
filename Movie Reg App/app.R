# ============================================================
# MOVIEREC - KOLLYWOOD MOVIE INTELLIGENCE
# Explainable hybrid movie recommendation + analytics platform (R + Shiny)
# Save this file as app.R and click "Run App" in RStudio.
# ============================================================

if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny", repos = "https://cloud.r-project.org")
}
library(shiny)

# Leo dashboard media
leo_poster_url <- "https://image.tmdb.org/t/p/w500/rzSBCrS7ZSkB8quje1Na31gRze.jpg"
leo_trailer_url <- "https://www.youtube.com/watch?v=Po3jStA673E"


# --------------------------- DATA ----------------------------

# 120 Tamil films released 2007-2026. Ratings for the 104 original titles are yours;
# the 16 added titles use approximate ratings (Parasakthi and Vaa Vaathiyaar from IMDb's 2026 list)
# - please verify those against your preferred source.
movies <- data.frame(
  movie_id = 1:120,
  title = c("Paruthiveeran","Polladhavan","Chennai 600028","Mozhi","Sivaji","Vaaranam Aayiram",
            "Subramaniapuram","Dasavathaaram","Ayan","Pasanga","Naadodigal","Paiyaa",
            "Vinnaithaandi Varuvaayaa","Madrasapattinam","Enthiran","Ko","Aaranya Kaandam","Mankatha",
            "Deiva Thirumagal","Aadukalam","Engeyum Eppodhum","Naan Ee","Pizza","Vazhakku Enn 18/9",
            "Thuppakki","Soodhu Kavvum","Raja Rani","Arrambam","Jigarthanda","Madras",
            "Kaaviya Thalaivan","Kaththi","I","Papanasam","OK Kanmani","Indru Netru Naalai",
            "Thani Oruvan","Irudhi Suttru","Dhuruvangal Pathinaaru","Kabali","Aandavan Kattalai",
            "Uriyadi","Iraivi","Joker","Aruvi","Vikram Vedha","Theeran Adhigaaram Ondru","Mersal",
            "Arjun Reddy Tamil Dub","Maanagaram","Meyaadha Maan","96","Ratsasan","Vada Chennai",
            "Pariyerum Perumal","Kaala","2.0","Merku Thodarchi Malai","Super Deluxe","Asuran","Kaithi",
            "Petta","Comali","To Let","Soorarai Pottru","Kannum Kannum Kollaiyadithaal","Oh My Kadavule",
            "Nasir","Master","Jai Bhim","Doctor","Maanaadu","Sarpatta Parambarai","Karnan","Mandela",
            "Nenjam Marappathillai","Koozhangal","Seththumaan","Don","Vikram","Thiruchitrambalam",
            "Ponniyin Selvan: Part I","Nenjuku Needhi","Love Today","Gargi","Vendhu Thanindhathu Kaadu",
            "Kadaisi Vivasayi","Viduthalai Part 1","Maamannan","Por Thozhil","Good Night","Mark Antony",
            "Jailer","Leo","Chithha","Parking","Dada","Blue Star","Aranmanai 4","Maharaja","Garudan",
            "Lubber Pandhu","Meiyazhagan","Amaran","Kanguva","Raayan","GOAT","Brother","Dragon",
            "Tourist Family","Good Bad Ugly","Retro","Thug Life","Coolie","Vidaamuyarchi","Kuberaa",
            "Veera Dheera Sooran","Suriya 45","Parasakthi","Vaa Vaathiyaar"),
  genre = c("Crime|Drama|Romance","Action|Crime|Drama","Comedy|Drama|Sport","Comedy|Drama|Romance",
            "Action|Drama|Thriller","Drama|Romance","Crime|Drama|Romance","Action|Sci-Fi|Thriller",
            "Action|Crime|Thriller","Drama|Family","Comedy|Drama","Action|Adventure|Romance",
            "Drama|Romance","Drama|Romance","Action|Sci-Fi|Thriller","Action|Thriller",
            "Crime|Drama|Thriller","Action|Crime|Thriller","Drama|Family","Action|Crime|Drama",
            "Drama|Romance|Thriller","Action|Comedy|Fantasy","Horror|Mystery|Thriller",
            "Crime|Drama|Romance","Action|Thriller","Comedy|Crime","Comedy|Drama|Romance",
            "Action|Thriller","Comedy|Crime|Drama","Drama|Crime","Drama|Musical","Action|Drama",
            "Action|Drama|Romance","Crime|Drama|Thriller","Drama|Romance","Comedy|Sci-Fi",
            "Action|Crime|Thriller","Drama|Sport","Crime|Mystery|Thriller","Action|Crime|Drama",
            "Comedy|Drama","Action|Thriller","Crime|Drama","Comedy|Drama","Drama",
            "Action|Crime|Thriller","Action|Crime|Thriller","Action|Drama|Thriller","Drama|Romance",
            "Action|Crime|Thriller","Comedy|Drama|Romance","Drama|Romance","Crime|Mystery|Thriller",
            "Crime|Drama","Drama","Action|Crime|Drama","Action|Sci-Fi|Thriller","Drama",
            "Comedy|Drama|Thriller","Action|Drama","Action|Crime|Thriller","Action|Drama","Comedy|Drama",
            "Drama","Drama","Comedy|Crime|Romance","Comedy|Fantasy|Romance","Drama",
            "Action|Drama|Thriller","Crime|Drama","Comedy|Crime|Thriller","Action|Sci-Fi|Thriller",
            "Action|Drama|Sport","Action|Drama","Comedy|Drama","Horror|Mystery","Drama","Drama",
            "Comedy|Drama","Action|Crime|Thriller","Comedy|Drama|Romance","Action|Adventure|Drama",
            "Drama","Comedy|Romance","Drama|Thriller","Action|Crime|Drama","Drama|Family",
            "Crime|Drama|Thriller","Drama|Thriller","Crime|Mystery|Thriller","Comedy|Drama|Romance",
            "Action|Comedy|Sci-Fi","Action|Comedy|Crime","Action|Crime|Thriller","Drama|Thriller",
            "Drama|Thriller","Drama|Romance","Drama|Sport","Comedy|Horror","Action|Drama|Thriller",
            "Action|Drama|Thriller","Comedy|Drama|Sport","Drama|Family","Action|Drama",
            "Action|Adventure|Fantasy","Action|Crime|Drama","Action|Sci-Fi|Thriller",
            "Comedy|Drama|Family","Comedy|Drama|Romance","Comedy|Drama|Family","Action|Comedy",
            "Action|Drama|Romance","Action|Crime|Drama","Action|Crime|Thriller","Action|Thriller",
            "Crime|Drama|Thriller","Action|Crime|Drama","Action|Drama","Action|Drama",
            "Action|Comedy|Fantasy"),
  year = c(2007,2007,2007,2007,2007,2008,2008,2008,2009,2009,2009,2010,2010,2010,2010,2011,2011,2011,
           2011,2011,2011,2012,2012,2012,2012,2013,2013,2013,2014,2014,2014,2014,2015,2015,2015,2015,
           2015,2016,2016,2016,2016,2016,2016,2016,2016,2017,2017,2017,2017,2017,2017,2018,2018,2018,
           2018,2018,2018,2018,2019,2019,2019,2019,2019,2019,2020,2020,2020,2020,2021,2021,2021,2021,
           2021,2021,2021,2021,2021,2021,2022,2022,2022,2022,2022,2022,2022,2022,2022,2023,2023,2023,
           2023,2023,2023,2023,2023,2023,2023,2024,2024,2024,2024,2024,2024,2024,2024,2024,2024,2024,
           2025,2025,2025,2025,2025,2025,2025,2025,2025,2025,2026,2026),
  rating = c(8.0,7.6,7.6,8.0,7.6,8.2,8.2,7.4,7.8,8.0,7.9,6.9,8.0,7.9,7.1,7.4,8.0,7.6,8.2,7.6,8.1,7.7,7.9,
             7.9,8.1,8.3,7.6,6.8,8.3,8.0,7.4,8.0,5.4,8.0,7.4,7.8,8.4,7.4,8.2,6.1,8.0,7.7,7.8,7.9,8.0,8.2,
             8.2,7.5,7.5,8.1,7.1,8.5,8.3,8.6,8.7,6.8,6.1,8.0,8.2,8.5,8.4,7.3,6.9,8.0,8.6,7.7,8.0,7.4,7.2,
             9.0,7.4,8.0,8.4,8.0,8.0,6.0,7.8,7.7,6.9,8.3,7.9,7.6,7.2,7.4,8.1,7.4,8.1,8.3,7.3,8.1,7.8,7.3,
             7.1,7.2,8.2,8.0,7.9,7.5,5.3,8.4,7.5,8.0,8.1,8.3,4.8,6.6,6.0,6.0,7.5,8.0,6.5,6.8,6.5,7.0,6.3,
             7.0,7.1,6.8,6.2,4.5),
  stringsAsFactors = FALSE
)

stopifnot(nrow(movies) == 120, !anyDuplicated(tolower(movies$title)),
          all(movies$year >= 2007 & movies$year <= 2026))

genre_list <- strsplit(movies$genre, "\\|")
genres <- genre_list
all_genres <- sort(unique(unlist(genre_list)))

genre_matrix <- matrix(
  0, nrow = nrow(movies), ncol = length(all_genres),
  dimnames = list(NULL, all_genres)
)
for (i in seq_len(nrow(movies))) {
  genre_matrix[i, genre_list[[i]]] <- 1
}

set.seed(123)
number_of_users <- 50
rating_matrix <- matrix(
  sample(c(0,0,0,0,1,2,3,4,5),
         nrow(movies) * number_of_users,
         replace = TRUE),
  nrow = nrow(movies),
  ncol = number_of_users
)

# -------------------- RECOMMENDATION MODEL -------------------

cosine_similarity <- function(a, b) {
  d <- sqrt(sum(a * a)) * sqrt(sum(b * b))
  if (d == 0) return(0)
  sum(a * b) / d
}

normalize_scores <- function(x) {
  if (!length(x)) return(x)
  d <- max(x) - min(x)
  if (d == 0) return(rep(0, length(x)))
  (x - min(x)) / d
}

similarity_scores <- function(idx, type = c("content", "collaborative")) {
  type <- match.arg(type)
  v <- if (type == "content") genre_matrix[idx, ] else rating_matrix[idx, ]
  s <- numeric(nrow(movies))
  for (i in seq_len(nrow(movies))) {
    if (i != idx) {
      z <- if (type == "content") genre_matrix[i, ] else rating_matrix[i, ]
      s[i] <- cosine_similarity(v, z)
    }
  }
  s
}

recommend_movies <- function(selected_movie, n = 10, content_weight = 0.5,
                             minimum_rating = 0, minimum_year = 2007,
                             maximum_year = 2026, selected_genre = "All") {
  idx <- which(tolower(movies$title) == tolower(selected_movie))
  if (!length(idx)) return(NULL)
  idx <- idx[1]
  
  content <- normalize_scores(similarity_scores(idx, "content"))
  collaborative <- normalize_scores(similarity_scores(idx, "collaborative"))
  hybrid <- content_weight * content + (1 - content_weight) * collaborative
  
  eligible <- movies$rating >= minimum_rating &
    movies$year >= minimum_year &
    movies$year <= maximum_year
  
  if (selected_genre != "All") {
    eligible <- eligible &
      grepl(selected_genre, movies$genre, fixed = TRUE)
  }
  
  eligible[idx] <- FALSE
  hybrid[!eligible] <- -1
  ord <- order(hybrid, decreasing = TRUE)
  ord <- ord[hybrid[ord] >= 0]
  ord <- head(ord, n)
  
  if (!length(ord)) return(NULL)
  
  data.frame(
    Rank = seq_along(ord),
    Movie = movies$title[ord],
    Genre = movies$genre[ord],
    Year = movies$year[ord],
    Rating = movies$rating[ord],
    Content_Score = round(content[ord], 3),
    Collaborative_Score = round(collaborative[ord], 3),
    Hybrid_Score = round(hybrid[ord], 3),
    stringsAsFactors = FALSE
  )
}


# --------------------- PRESENTATION HELPERS -------------------
# Pure, non-reactive helpers used to build UI fragments out of the
# REAL dataset above. No fabricated data is introduced.

card_palette <- c("#4f46e5","var(--acc2)","#ef4444","#10b981","#06b6d4","#a855f7","#ec4899","#f97316")

# ------------------------------------------------------------
# CINEMATIC POSTER SHOWCASE - flavor metadata (badge/tagline)
# This table supplies the badge + tagline text used on the poster
# card for the movies below. It carries NO image URLs - the actual
# poster image for every one of the 120 movies comes from the single
# central poster database defined further down (poster_data /
# get_poster_url()), never from this table.
# ------------------------------------------------------------

poster_catalog <- data.frame(
  title = c("LEO", "VIKRAM", "JAILER", "MASTER", "KAITHI", "ASURAN", "96", "VADA CHENNAI", "SOORARAI POTTRU", "JAI BHIM", "RATSASAN", "THANI ORUVAN", "AYAN", "GHILLI", "MANKATHA", "PIZZA", "SOODHU KAVVUM", "SUPER DELUXE", "PARIYERUM PERUMAL", "MADRAS", "JIGARTHANDA", "AARANYA KAANDAM", "MOUNA RAGAM", "NAYAKAN", "THALAPATHI", "INDIAN", "ENTHIRAN", "OK KANMANI", "VETTAIYAADU VILAIYAADU", "PUDHUPETTAI", "VISHWAROOPAM", "THEERAN ADHIGAARAM ONDRU", "MAANAADU", "DOCTOR", "DON", "THIRUCHITRAMBALAM", "LOVE TODAY", "PARKING", "MAHARAJA", "COOLIE", "GOOD BAD UGLY", "RETRO", "THUG LIFE", "KUBERAA", "DRAGON", "PETTA", "KAALA", "VIKRAM VEDHA", "MERSAL", "SARPATTA PARAMBARAI", "KARNAN", "PONNIYIN SELVAN: PART I", "VIDUTHALAI PART 1", "MAAMANNAN", "AMARAN", "KANGUVA", "RAAYAN", "GOAT", "VEERA DHEERA SOORAN", "GARUDAN", "MEIYAZHAGAN", "VIDAAMUYARCHI"),
  year = c(2023,2022,2023,2021,2019,2019,2018,2018,2020,2021,2018,2015,2009,2004,2011,2012,2013,2019,2018,2014,2014,2011,1986,1987,1991,1996,2010,2015,2006,2006,2013,2017,2021,2021,2022,2022,2022,2023,2024,2025,2025,2025,2025,2025,2025,2019,2018,2017,2017,2021,2021,2022,2023,2023,2024,2024,2024,2024,2025,2025,2024,2025),
  genre = c("Action  -  Crime  -  Thriller", "Action  -  Crime  -  Thriller", "Action  -  Crime  -  Drama", "Action  -  Drama  -  Thriller", "Action  -  Crime  -  Thriller", "Action  -  Drama", "Romance  -  Drama", "Crime  -  Drama", "Drama  -  Biography", "Drama  -  Legal", "Crime  -  Mystery  -  Thriller", "Action  -  Thriller", "Action  -  Thriller", "Action  -  Romance", "Action  -  Crime  -  Thriller", "Horror  -  Mystery  -  Thriller", "Comedy  -  Crime", "Drama  -  Thriller", "Drama", "Drama  -  Politics", "Crime  -  Comedy  -  Drama", "Crime  -  Thriller", "Romance  -  Drama", "Crime  -  Drama", "Action  -  Drama", "Action  -  Drama", "Action  -  Sci-Fi", "Romance  -  Drama", "Crime  -  Thriller", "Crime  -  Drama", "Action  -  Thriller", "Action  -  Crime", "Action  -  Sci-Fi  -  Thriller", "Comedy  -  Action", "Comedy  -  Drama", "Romance  -  Comedy  -  Drama", "Romance  -  Comedy", "Drama  -  Thriller", "Action  -  Drama  -  Thriller", "Action  -  Crime  -  Thriller", "Action  -  Comedy", "Romance  -  Action  -  Drama", "Action  -  Drama", "Crime  -  Thriller  -  Drama", "Romance  -  Comedy  -  Drama", "Action  -  Drama", "Action  -  Drama", "Action  -  Crime  -  Thriller", "Action  -  Thriller", "Drama  -  Sport", "Drama  -  Crime", "Action  -  Drama  -  History", "Action  -  Crime  -  Thriller", "Action  -  Drama", "Action  -  Drama  -  War", "Action  -  Adventure  -  Fantasy", "Action  -  Drama  -  Sport", "Action  -  Sci-Fi", "Action  -  Drama", "Action  -  Thriller", "Comedy  -  Drama", "Action  -  Thriller"),
  badge = c("FAN FAVORITE","MASS HIT","TRENDING","FAN FAVORITE","TOP PICK","CRITICS PICK","FAN FAVORITE","TOP PICK","FAN FAVORITE","CRITICS PICK","THRILLER PICK","TOP PICK","CLASSIC","CLASSIC","MASS HIT","CULT PICK","CULT CLASSIC","CRITICS PICK","CRITICS PICK","TOP PICK","CULT CLASSIC","CULT PICK","CLASSIC","LEGEND","LEGEND","CLASSIC","BLOCKBUSTER","FAN FAVORITE","THRILLER PICK","CULT CLASSIC","ACTION PICK","TOP PICK","TRENDING","FAN FAVORITE","FAN FAVORITE","FAN FAVORITE","TRENDING","TRENDING","TRENDING","NEW RELEASE","NEW RELEASE","NEW RELEASE","NEW RELEASE","NEW RELEASE","NEW RELEASE","MASS HIT","MASS HIT","CULT CLASSIC","BLOCKBUSTER","CRITICS PICK","CRITICS PICK","EPIC","FAN FAVORITE","POLITICAL DRAMA","FAN FAVORITE","TRENDING","MASS HIT","MASS HIT","ACTION PICK","MASS HIT","FAN FAVORITE","TRENDING"),
  tagline = c("BLOODY SWEET","ONCE UPON A TIME","THE SHOW BEGINS","ONCE A TEACHER","ONE NIGHT. ONE FIGHT.","EVERY ACTION HAS A REACTION","SOME MEMORIES NEVER FADE","A CITY. A STORY. A LEGACY.","DREAM BIG. FLY HIGH.","JUSTICE LIVES ON","THE HUNT BEGINS","THE PERFECT RIVAL","PLAY THE GAME","MASS NEVER GETS OLD","BAD BOYS PLAY TO WIN","ONE NIGHT. MANY SECRETS.","DREAM BIG. STEAL BIG.","EVERYONE HAS A STORY","LOVE. CASTE. RESISTANCE.","WALLS REMEMBER EVERYTHING","DIRECTOR MEETS DON","THE CITY HAS NO HEROES","LOVE FINDS A WAY","AN EPIC OF SURVIVAL","FRIENDSHIP. HONOUR. DESTINY.","CORRUPTION HAS AN ENEMY","THE FUTURE HAS ARRIVED","LOVE IN THE DIGITAL AGE","THE HUNT NEVER STOPS","BORN TO RULE","THE MISSION BEGINS","THE CASE IS PERSONAL","THE LOOP NEVER ENDS","MISSION: RESCUE","COLLEGE. FRIENDS. LIFE.","LIFE FINDS LOVE","LOVE HAS RULES","THE PARKING WAR","A FATHER'S REVENGE","THALAIVAR MASS","ONE MAN. THREE FACES.","LOVE - LAUGHTER - WAR","THE GANGSTER RETURNS","THE RISE OF DEVA","WORST STUDENT OF THE DECADE","POWER HAS A PRICE","LAND IS EVERYTHING","TWO SIDES OF JUSTICE","THALAPATHY UNLEASHED","THE ARENA NEVER FORGETS","A REVOLUTION RISES","AN EMPIRE AWAITS","THE FIGHT FOR FREEDOM","A LEADER IS BORN","A SOLDIER'S STORY","AN EMPIRE OF WAR","THE ROAD TO REVENGE","THE ULTIMATE HUNT","BORDERS OF COURAGE","BLOOD RUNS DEEP","EVERY FRAME A MEMORY","NO WAY BACK"),
  stringsAsFactors = FALSE
)

# ============================================================
# CENTRAL POSTER DATABASE - ONE mapping for all 120 movies
# ============================================================
# This is the ONLY poster architecture in the app. There is no
# Wikipedia API call, no generator=search, no guessed Commons
# filenames and no network request of any kind while the app runs
# or renders. The mapping is built ONCE when the app starts.
#
# Resolution order for each title in movies$title:
#   1. www/posters/<slug>.jpg|jpeg|png|webp   (local file - preferred)
#   2. poster_cache.csv (title, poster_url)   (optional, read once)
#   3. verified_posters below                 (hand-checked direct URLs)
#
# To fill in the remaining posters, run fetch_posters.R ONCE from the
# project folder (needs a free TMDB API key). It downloads each poster
# into www/posters/ sequentially, with a pause between requests, and
# never runs inside the app. Titles that still have no poster are
# reported honestly (About page + console) and shown as a flat
# "POSTER UNAVAILABLE" card - never a fake or gradient poster.
# ============================================================

POSTER_CACHE_FILE <- "poster_cache.csv"

# Hand-verified direct image URLs (kept from the previous version).
verified_posters <- c(
  "Leo"             = leo_poster_url,
  "Coolie"          = "https://media.tamilmdb.com/i/movie/0d/97/7239/175x245/6627c3e20e066.jpeg",
  "Thug Life"       = "https://media.tamilmdb.com/i/movie/e1/43/7055/175x245/6548f985d0435.jpeg",
  "Good Bad Ugly"   = "https://image.tmdb.org/t/p/w500/8DbYYluzdiGDAZzsaP7DWGbwfLd.jpg",
  "Retro"           = "https://image.tmdb.org/t/p/w500/yGv62UIUfjrEUlItYPJXb1zU0lB.jpg",
  "Kuberaa"         = "https://image.tmdb.org/t/p/w500/xjLC5DeA4FQTBv4xe8r3wYqh8lu.jpg",
  "Dragon"          = "https://image.tmdb.org/t/p/w500/b77Su1i74L28InBsyaFlfWPDpeE.jpg",
  "Vada Chennai"    = "https://images.moviebuff.com/fdbde7b5-fa19-448d-8904-0f879010855a?w=600",
  "Soorarai Pottru" = "https://images.moviebuff.com/e02c51c1-1a47-4469-9ba4-05b1f311b8a6?w=600"
)

poster_slug <- function(title) {
  s <- tolower(title)
  s <- gsub("[^a-z0-9]+", "_", s)
  gsub("^_+|_+$", "", s)
}

# Image files that are really in www/posters (folders are ignored).
poster_files <- function() {
  d <- file.path("www", "posters")
  if (!dir.exists(d)) return(character(0))
  f <- list.files(d)
  f[grepl("\\.(jpg|jpeg|jfif|png|webp)$", f, ignore.case = TRUE) & !dir.exists(file.path(d, f))]
}
poster_key <- function(x) gsub("[^a-z0-9]", "", tolower(x))
poster_file_key <- function(fn) {
  b <- sub("\\.(jpg|jpeg|jfif|png|webp)$", "", fn, ignore.case = TRUE)
  b <- sub("\\.(jpg|jpeg|jfif|png|webp)$", "", b, ignore.case = TRUE)   # e.g. don.jpg.jpg
  b <- sub("\\s*\\(\\d+\\)$", "", b)                                   # e.g. don (1)
  poster_key(b)
}

# Exact <slug>.<ext> first; otherwise any file whose name matches the title
# when spaces, capitals, punctuation, "(1)" and double extensions are ignored.
local_poster_path <- function(title) {
  slug <- poster_slug(title)
  for (ext in c("jpg", "jpeg", "png", "webp")) {
    candidate <- file.path("www", "posters", paste0(slug, ".", ext))
    if (file.exists(candidate)) return(paste0("posters/", slug, ".", ext))
  }
  files <- poster_files()
  if (length(files)) {
    keys <- vapply(files, poster_file_key, character(1))
    hit <- which(keys == poster_key(title))
    if (length(hit)) return(paste0("posters/", utils::URLencode(files[hit[1]])))
  }
  NA_character_
}

# Built ONCE at startup. Reads local files and one optional CSV only.
build_poster_data <- function() {
  base <- data.frame(
    movie_id = movies$movie_id, title = movies$title, year = movies$year,
    stringsAsFactors = FALSE
  )
  base$poster_url <- NA_character_

  # 1) Optional cache (poster_cache.csv) - used only as a fallback.
  if (file.exists(POSTER_CACHE_FILE)) {
    cached <- tryCatch(
      utils::read.csv(POSTER_CACHE_FILE, stringsAsFactors = FALSE),
      error = function(e) NULL
    )
    if (!is.null(cached) && all(c("title", "poster_url") %in% names(cached))) {
      m <- match(base$title, cached$title)
      ok <- !is.na(m) & !is.na(cached$poster_url[m]) & nzchar(cached$poster_url[m])
      base$poster_url[ok] <- cached$poster_url[m[ok]]
    }
  }

  # 2) Hand-verified posters (including your supplied LEO poster) ALWAYS beat
  #    the cache, because a title search can pick a different film with the same name.
  v <- unname(verified_posters[base$title])
  base$poster_url[!is.na(v)] <- v[!is.na(v)]

  # Local files always win over remote URLs.
  local_hits <- vapply(base$title, local_poster_path, character(1))
  has_local <- !is.na(local_hits)
  base$poster_url[has_local] <- local_hits[has_local]
  
  base$poster_url[is.na(base$poster_url)] <- ""
  base$trailer_url <- vapply(base$title, function(t) {
    paste0("https://www.youtube.com/results?search_query=",
           utils::URLencode(paste(t, "official trailer"), reserved = TRUE))
  }, character(1))
  base$trailer_url[base$title == "Leo"] <- leo_trailer_url
  base
}

poster_data <- build_poster_data()

get_poster_url <- function(title) {
  i <- match(tolower(title), tolower(poster_data$title))
  if (is.na(i)) return("")
  poster_data$poster_url[i]
}

get_trailer_url <- function(title) {
  i <- match(tolower(title), tolower(poster_data$title))
  if (is.na(i)) {
    return(paste0("https://www.youtube.com/results?search_query=",
                  utils::URLencode(paste(title, "official trailer"), reserved = TRUE)))
  }
  poster_data$trailer_url[i]
}

# Honest validation of the poster mapping.
poster_report <- function() {
  u <- poster_data$poster_url
  is_remote <- grepl("^https?://", u)
  is_local  <- grepl("^posters/", u)
  has <- nzchar(u)
  local_missing_file <- is_local & !file.exists(file.path("www", utils::URLdecode(u)))
  invalid <- has & !is_remote & !is_local
  list(
    total_movies   = nrow(movies),
    mapped         = sum(has & !local_missing_file & !invalid),
    missing        = poster_data$title[!has | local_missing_file | invalid],
    local_files    = sum(is_local & !local_missing_file),
    remote_urls    = sum(is_remote),
    duplicate_titles = unique(movies$title[duplicated(tolower(movies$title))]),
    missing_local_files = poster_data$title[local_missing_file],
    invalid_paths  = poster_data$title[invalid],
    all_ids_resolve = all(movies$movie_id %in% poster_data$movie_id)
  )
}

validate_posters <- function() {
  message("Posters folder: ", normalizePath(file.path("www", "posters"), mustWork = FALSE),
          " (", length(poster_files()), " image files found)")
  r <- poster_report()
  message("Movies in dataset: ", r$total_movies)
  message("Poster mappings: ", r$mapped)
  message("Missing posters: ", length(r$missing))
  if (length(r$missing)) {
    message("Missing: ", paste(r$missing, collapse = ", "))
    message("Run fetch_posters.R once (needs TMDB_API_KEY) to download them into www/posters/.")
  }
  if (length(r$duplicate_titles)) message("Duplicate titles: ", paste(r$duplicate_titles, collapse = ", "))
  invisible(r)
}
validate_posters()


# ------------------------------------------------------------
# PREMIUM LOGIN SCREEN
# Tilted, slowly scrolling poster wall + glass sign-in card.
# Every poster comes from the central get_poster_url(). If an image
# fails to load (or none was resolved), a styled title-card fallback
# is shown instead, so the wall never has empty holes.
# ------------------------------------------------------------

mr_svg <- function(paths, size = 18, fill = "none") {
  HTML(paste0(
    "<svg width='", size, "' height='", size, "' viewBox='0 0 24 24' fill='", fill,
    "' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' ",
    "stroke-linejoin='round' aria-hidden='true'>", paths, "</svg>"
  ))
}

mr_icons <- list(
  user  = "<path d='M20 21a8 8 0 0 0-16 0'/><circle cx='12' cy='7' r='4'/>",
  lock  = "<rect x='4' y='11' width='16' height='10' rx='2.5'/><path d='M8 11V7a4 4 0 0 1 8 0v4'/>",
  eye   = "<path d='M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z'/><circle cx='12' cy='12' r='3'/>",
  arrow = "<path d='M5 12h14M13 6l6 6-6 6'/>",
  check = "<path d='M20 6 9 17l-5-5'/>",
  play  = "<path d='M8 5v14l11-7z' fill='currentColor'/>",
  film  = "<rect x='3' y='3' width='18' height='18' rx='2.5'/><path d='M7 3v18M17 3v18M3 8h4M3 12h18M3 16h4M17 8h4M17 16h4'/>",
  grid    = "<rect x='3' y='3' width='7' height='7' rx='1.5'/><rect x='14' y='3' width='7' height='7' rx='1.5'/><rect x='3' y='14' width='7' height='7' rx='1.5'/><rect x='14' y='14' width='7' height='7' rx='1.5'/>",
  compass = "<circle cx='12' cy='12' r='9'/><path d='m16 8-2 6-6 2 2-6z'/>",
  heart2  = "<path d='M20.8 8.6c0 4.7-8.8 10.4-8.8 10.4S3.2 13.3 3.2 8.6a4.6 4.6 0 0 1 8.8-2 4.6 4.6 0 0 1 8.8 2z'/>",
  users   = "<path d='M17 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'/><circle cx='9' cy='7' r='4'/><path d='M23 21v-2a4 4 0 0 0-3-3.87'/><path d='M16 3.13a4 4 0 0 1 0 7.75'/>",
  info    = "<circle cx='12' cy='12' r='9'/><path d='M12 16v-5'/><path d='M12 8h.01'/>",
  gear    = "<circle cx='12' cy='12' r='3'/><path d='M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.6 1.7 1.7 0 0 0-1.9.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.9 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.6-1 1.7 1.7 0 0 0-.3-1.9l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.9.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.9-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.9V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z'/>",
  logout2 = "<path d='M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'/><path d='M16 17l5-5-5-5'/><path d='M21 12H9'/>",
  search  = "<circle cx='11' cy='11' r='7'/><path d='m21 21-4.3-4.3'/>",
  bell    = "<path d='M6 8a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6'/><path d='M10.3 21a1.9 1.9 0 0 0 3.4 0'/>",
  message = "<path d='M21 15a2 2 0 0 1-2 2H8l-4 4V5a2 2 0 0 1 2-2h13a2 2 0 0 1 2 2z'/>",
  star    = "<path d='m12 2 3.1 6.6 7.2.8-5.4 5 1.5 7.2L12 18l-6.4 3.6 1.5-7.2-5.4-5 7.2-.8z' fill='currentColor'/>",
  download= "<path d='M12 3v13'/><path d='m7 11 5 5 5-5'/><path d='M5 21h14'/>",
  share   = "<circle cx='18' cy='5' r='3'/><circle cx='6' cy='12' r='3'/><circle cx='18' cy='19' r='3'/><path d='m8.6 13.5 6.8 3.9'/><path d='m15.4 6.5-6.8 4'/>",
  pause   = "<rect x='6' y='4' width='4' height='16' rx='1'/><rect x='14' y='4' width='4' height='16' rx='1'/>",
  volume  = "<path d='M11 5 6 9H2v6h4l5 4z'/><path d='M15.5 8.5a5 5 0 0 1 0 7'/>",
  expand  = "<path d='M8 3H5a2 2 0 0 0-2 2v3'/><path d='M16 3h3a2 2 0 0 1 2 2v3'/><path d='M21 16v3a2 2 0 0 1-2 2h-3'/><path d='M8 21H5a2 2 0 0 1-2-2v-3'/>"
)

# Badge text derived only from real fields already in `movies`
# (rating/year), or from poster_catalog's hand-written badge when one
# exists for that title. Nothing here is invented movie data - it is
# just which label a real number/year earns on the card.
card_badge_for <- function(title, year = NA, rating = NA) {
  cat_row <- poster_catalog[toupper(poster_catalog$title) == toupper(title), ]
  if (nrow(cat_row)) return(cat_row$badge[1])
  if (!is.na(year) && year >= 2024) return("NEW RELEASE")
  if (!is.na(rating) && rating >= 8.3) return("TOP RATED")
  if (!is.na(year) && year < 2000) return("CLASSIC")
  "FEATURED"
}
card_tagline_for <- function(title) {
  cat_row <- poster_catalog[toupper(poster_catalog$title) == toupper(title), ]
  if (nrow(cat_row)) return(cat_row$tagline[1])
  NULL
}

# One poster tile: styled fallback card underneath, real poster image
# (from the central get_poster_url()) on top.
login_tile <- function(t, i) {
  mrow <- movies[tolower(movies$title) == tolower(t), ][1, ]
  col1 <- card_palette[(i %% length(card_palette)) + 1]
  col2 <- card_palette[((i + 3) %% length(card_palette)) + 1]
  url <- get_poster_url(t)
  
  div(
    class = "mr-tile",
    style = paste0("--c1:", col1, ";--c2:", col2, ";"),
    div(class = "mr-tile-fb",
        span(class = "mr-fb-year", mrow$year),
        span(class = "mr-fb-title", mrow$title),
        span(class = "mr-fb-tag", card_badge_for(mrow$title, mrow$year, mrow$rating))),
    if (nzchar(url)) tags$img(
      src = url,
      alt = paste(t, "poster"),
      loading = "lazy",
      decoding = "async",
      onerror = "this.style.display='none';"
    ),
    div(class = "mr-tile-gloss")
  )
}

# Poster wall: n_cols columns, each with its own order, speed and
# direction, drawn from ALL 120 movies (not just a subset).
login_poster_wall <- function(n_cols = 8, per_col = 12) {
  pool <- movies$title
  cols <- lapply(seq_len(n_cols), function(cc) {
    ord <- order((seq_along(pool) * (2 * cc + 1) * 31 + cc * 17) %% 97)
    picks <- pool[ord][seq_len(min(per_col, length(pool)))]
    tiles <- lapply(seq_along(picks), function(k) login_tile(picks[k], cc * 7 + k))
    div(
      class = paste("mr-col", if (cc %% 2 == 0) "mr-down" else "mr-up"),
      style = paste0("animation-duration:", 95 + (cc %% 4) * 22, "s;",
                     "animation-delay:-", cc * 11, "s;"),
      div(class = "mr-col-track", tiles),
      div(class = "mr-col-track", `aria-hidden` = "true", tiles)
    )
  })
  div(class = "mr-wall", div(class = "mr-wall-inner", cols))
}

# Ambient poster-collage backdrop used behind the logged-in dashboard.
# A dimmed, blurred, static wall of real posters from the central
# poster database, with glowing color orbs and film grain on top for
# depth - the same premium ingredients as the login screen, tuned down
# so text on every tab stays fully readable.
cinema_backdrop <- function(n = 55) {
  pool <- movies$title
  ord <- order((seq_along(pool) * 37 + 11) %% 97)
  picks <- rep(pool[ord], length.out = n)
  tiles <- lapply(picks, function(t) {
    url <- get_poster_url(t)
    div(class = "cine-tile", style = if (nzchar(url)) paste0("background-image:url('", url, "')") else "")
  })
  div(
    class = "cine-bg",
    div(class = "cine-wall", tiles),
    div(class = "cine-shade"),
    div(class = "cine-orb co1"),
    div(class = "cine-orb co2"),
    div(class = "cine-grain")
  )
}

# ---------------------------------------------------------------
# CINEMATIC LOGIN: letterbox-open intro, tilted poster wall, projector
# beam, dust, lens flare, grain and a premium "admit one" ticket card.
# (input ids unchanged: uname, pwd, login, guest, remember_me)
# ---------------------------------------------------------------
lg_wall <- function(n_cols = 9, per_col = 8) {
  pool <- movies$title
  cols <- lapply(seq_len(n_cols), function(cc) {
    ord <- order((seq_along(pool) * (2 * cc + 1) * 31 + cc * 17) %% 97)
    picks <- pool[ord][seq_len(min(per_col, length(pool)))]
    tiles <- lapply(seq_along(picks), function(k) {
      url <- get_poster_url(picks[k])
      i <- cc * 7 + k
      div(class = "lg-tile",
          style = paste0("--c1:", card_palette[(i %% length(card_palette)) + 1],
                         ";--c2:", card_palette[((i + 3) %% length(card_palette)) + 1],
                         if (nzchar(url)) paste0(";--u:url('", url, "')") else ""))
    })
    div(class = paste("lg-col", if (cc %% 2 == 0) "dn" else "up"),
        style = sprintf("animation-duration:%ds;animation-delay:-%ds", 110 + (cc %% 4) * 25, cc * 9),
        div(class = "lg-track", tiles),
        div(class = "lg-track", `aria-hidden` = "true", tiles))
  })
  div(class = "lg-wall", cols)
}

login_screen <- function() {
  yr <- range(movies$year)
  top_titles <- head(movies$title[order(-movies$rating, -movies$year)], 24)
  moods <- c("Drama", "Thriller", "Romance", "Action", "Comedy", "Drama")
  dust <- lapply(1:28, function(i)
    tags$i(style = sprintf("left:%d%%;--s:%dpx;--d:%ds;--dl:-%ds;--sw:%dpx",
                           (i * 53) %% 100, 2 + (i %% 3), 14 + (i * 7) %% 14, (i * 3) %% 17, 20 + (i * 11) %% 50)))
  chip <- function(ico, txt) div(class = "lg-chip", mr_svg(ico, 18), span(txt))
  num <- function(v, dec = "0", from = NULL)
    tags$span(class = "lg-num", `data-count` = as.character(v), `data-dec` = dec, `data-delay` = "2300",
              `data-from` = if (!is.null(from)) as.character(from), v)
  stat <- function(i, big, label)
    div(class = "lg-stat lg-in", style = sprintf("--d:%.2fs", 0.8 + i * 0.1),
        div(class = "lg-stat-n", big), div(class = "lg-stat-l", label))
  credit <- function() lapply(top_titles, function(t) tagList(span(toupper(t)), tags$em(HTML("&#10022;"))))
  
  div(
    class = "lg",
    tags$link(rel = "stylesheet",
              href = "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,800;1,600&display=swap"),
    
    # ----- cinematic backdrop -----
    div(class = "lg-stage",
        lg_wall(9, 8),
        div(class = "lg-grade"), div(class = "lg-beam"), div(class = "lg-shade"),
        div(class = "lg-dust", dust), div(class = "lg-flare"), div(class = "lg-grain")),
    
    # ----- letterbox bars + title-card intro -----
    div(class = "lg-bar t"), div(class = "lg-bar b"),
    div(class = "lg-intro",
        div(class = "lg-intro-in",
            span(class = "lg-intro-reel", mr_svg(mr_icons$film, 46)),
            div(class = "lg-intro-t", "MOVIEREC"),
            div(class = "lg-intro-l"),
            div(class = "lg-intro-s", "A KOLLYWOOD PREMIERE"))),
    
    div(
      class = "lg-scroll",
      div(class = "lg-top lg-in", style = "--d:0s",
          div(class = "lg-logo",
              span(class = "lg-logo-mark", mr_svg(mr_icons$film, 22)),
              div(div(class = "lg-logo-t", "Movie", tags$b("Rec")),
                  div(class = "lg-logo-s", "MOVIE RECOMMENDATION SYSTEM"))),
          div(class = "lg-pill", span(class = "lg-rec"), "PREMIERE EDITION  -  KOLLYWOOD")),
      
      div(
        class = "lg-main",
        # ---------------- hero ----------------
        div(class = "lg-hero",
            div(class = "lg-kick lg-in", style = "--d:0.05s",
                span(class = "lg-rec"), "NOW SHOWING", span(class = "lg-kick-sep"), "TAMIL CINEMA, PERSONALISED"),
            tags$h1(class = "lg-h",
                    div(class = "lg-ln", span(style = "--d:0s", "Step into the")),
                    div(class = "lg-ln big", span(class = "g", style = "--d:0.12s", "Kollywood")),
                    div(class = "lg-ln it", span(style = "--d:0.24s", "spotlight."))),
            div(class = "lg-mood lg-in", style = "--d:0.5s", "Tonight, I'm in the mood for",
                span(class = "lg-rot", div(class = "lg-rot-in", lapply(moods, tags$b)))),
            tags$p(class = "lg-sub lg-in", style = "--d:0.6s",
                   "A personalised movie recommendation system for Kollywood lovers - hybrid AI picks, mood discovery and side-by-side compare, built with R and Shiny."),
            div(class = "lg-chips lg-in", style = "--d:0.7s",
                chip(mr_icons$compass, "AI recommendations"), chip(mr_icons$heart2, "Mood discovery"),
                chip(mr_icons$film, "Watchlist"), chip(mr_icons$grid, "Trending")),
            div(class = "lg-stats",
                stat(1, num(nrow(movies)), "Tamil movies"),
                stat(2, num(length(all_genres)), "Genres"),
                stat(3, tagList(num(yr[1], from = yr[1] - 25), HTML("&nbsp;&ndash;&nbsp;"), num(yr[2], from = yr[2] - 25)), "Years of cinema"),
                stat(4, num(format(max(movies$rating), nsmall = 1), dec = "1"), "Top rating"))),
        
        # ---------------- ticket sign-in card ----------------
        div(class = "lg-tkwrap lg-in", style = "--d:0.35s",
            div(class = "lg-tkshadow",
                div(class = "lg-ticket",
                    div(class = "lg-spot"),
                    div(class = "lg-perf"),
                    div(class = "lg-tk-top",
                        div(class = "lg-tk-l",
                            div(class = "lg-tk-k", "MOVIEREC  -  PREMIERE PASS"),
                            tags$h2("Welcome ", span(class = "lg-it", "back")),
                            div(class = "lg-tk-s", "Sign in for your personalised Kollywood picks.")),
                        div(class = "lg-stamp", HTML("ADMIT<br>ONE"))),
                    div(class = "lg-tk-body",
                        div(class = "lg-field",
                            span(class = "lg-ico", mr_svg(mr_icons$user, 19)),
                            textInput("uname", NULL, placeholder = "Username or email")),
                        div(class = "lg-field",
                            span(class = "lg-ico", mr_svg(mr_icons$lock, 19)),
                            passwordInput("pwd", NULL, placeholder = "Password"),
                            tags$button(type = "button", class = "lg-eye", `aria-label` = "Show or hide password",
                                        onclick = "var i=document.getElementById('pwd');if(i){i.type=(i.type==='password')?'text':'password';}",
                                        mr_svg(mr_icons$eye, 18))),
                        actionButton("login", tagList("Sign In", mr_svg(mr_icons$arrow, 18)), class = "lg-btn lg-gold"),
                        div(class = "lg-or", span("or")),
                        actionButton("guest", "Continue as guest", class = "lg-btn lg-ghost"),
                        div(class = "lg-row",
                            tags$label(tags$input(type = "checkbox", id = "remember_me"), "Remember me"),
                            tags$a(href = "#", "Need help?")),
                        div(class = "lg-signup", "New to MovieRec? ", tags$b("Sign up now.")),
                        div(class = "lg-barcode"),
                        div(class = "lg-hint",
                            "Student prototype login for a Kollywood movie recommendation system. ",
                            "Not affiliated with or endorsed by Netflix. No real account is required. ",
                            "Posters belong to their respective owners.")))))
      )
    ),
    
    # ----- end credits marquee -----
    div(class = "lg-credits", div(class = "lg-credits-in", credit(), credit())),
    
    # Press Enter in either field to sign in (added once, even after logout/login).
    tags$script(HTML(
      "if(!window.__mrLoginKeys){window.__mrLoginKeys=1;
       document.addEventListener('keydown',function(e){
         if(e.key==='Enter'&&e.target&&(e.target.id==='uname'||e.target.id==='pwd')){
           setTimeout(function(){var b=document.getElementById('login');if(b)b.click();},350);
         }});}"
    ))
  )
}

lg_css <- r"---(
.lg{--bh:7vh;--gold:#e8b75a;--gold2:#f7d794;--ink:#f6efe3;--mut:#b9ad98;position:fixed;inset:0;z-index:50;overflow:hidden;background:#040302;color:var(--ink);
font-family:'Poppins','Inter',system-ui,sans-serif}
.lg *{box-sizing:border-box}
@keyframes lg-up{from{opacity:0;transform:translateY(26px)}}
@keyframes lg-line{to{transform:none}}
@keyframes lg-fade{to{opacity:1}}
@keyframes lg-spin{to{transform:rotate(360deg)}}
@keyframes lg-bar{to{height:var(--bh)}}
@keyframes lg-intro-out{to{opacity:0;visibility:hidden}}
@keyframes lg-track-up{to{transform:translateY(-50%)}}
@keyframes lg-track-dn{from{transform:translateY(-50%)}to{transform:none}}
@keyframes lg-beam{0%,100%{opacity:.55;transform:rotate(-2deg)}7%{opacity:.7}12%{opacity:.48}19%{opacity:.66}50%{opacity:.6;transform:rotate(2.5deg)}63%{opacity:.5}70%{opacity:.68}}
@keyframes lg-flare{0%{left:-60%;opacity:0}6%{opacity:.95}20%{left:115%;opacity:0}100%{left:115%;opacity:0}}
@keyframes lg-dust{0%{transform:translate(0,0);opacity:0}15%{opacity:.8}100%{transform:translate(var(--sw),-110vh);opacity:0}}
@keyframes lg-grain{0%{transform:translate(0,0)}20%{transform:translate(-3%,2%)}40%{transform:translate(2%,-3%)}60%{transform:translate(-2%,-1%)}80%{transform:translate(3%,3%)}100%{transform:translate(0,0)}}
@keyframes lg-shine{to{background-position:220% 0}}
@keyframes lg-pulse{50%{opacity:.35;transform:scale(.8)}}
@keyframes lg-marq{to{transform:translateX(-50%)}}
@keyframes lg-rot{0%,16%{transform:translateY(0)}20%,36%{transform:translateY(-1.5em)}40%,56%{transform:translateY(-3em)}60%,76%{transform:translateY(-4.5em)}80%,96%{transform:translateY(-6em)}100%{transform:translateY(-7.5em)}}
@keyframes lg-nudge{50%{transform:translateX(5px)}}
@keyframes lg-sweep{0%,55%{left:-70%}100%{left:150%}}
@keyframes lg-intro-t{from{letter-spacing:1em;opacity:0}to{letter-spacing:.34em;opacity:1}}
@keyframes lg-intro-l{from{width:0}to{width:240px}}
@keyframes lg-intro-in{from{opacity:0;transform:scale(.7) rotate(-90deg)}to{opacity:1;transform:none}}

/* ---------- backdrop ---------- */
.lg-stage{position:absolute;inset:0;overflow:hidden;perspective:1500px}
.lg-wall{position:absolute;left:50%;top:50%;width:170vmax;height:170vmax;margin:-85vmax 0 0 -85vmax;display:grid;grid-template-columns:repeat(9,1fr);gap:14px;
transform:rotateX(16deg) rotateZ(-14deg);translate:calc(var(--nx,0) * -34px) calc(var(--ny,0) * -22px);transition:translate .5s ease-out}
.lg-col{display:flex;flex-direction:column;overflow:visible;animation:linear infinite}
.lg-col.up{animation-name:lg-track-up}.lg-col.dn{animation-name:lg-track-dn}
.lg-track{display:flex;flex-direction:column;gap:14px;padding-bottom:14px}
.lg-tile{aspect-ratio:2/3;border-radius:10px;background:var(--u,none) center/cover no-repeat,linear-gradient(145deg,var(--c1),var(--c2));
filter:brightness(.42) saturate(1.15) contrast(1.05);box-shadow:0 10px 30px rgba(0,0,0,.6)}
.lg-grade{position:absolute;inset:0;mix-blend-mode:soft-light;background:linear-gradient(120deg,rgba(255,150,40,.28),transparent 45%,rgba(30,120,170,.28))}
.lg-beam{position:absolute;top:-12%;left:34%;width:60%;height:135%;transform-origin:50% 0;pointer-events:none;mix-blend-mode:screen;filter:blur(18px);
background:linear-gradient(180deg,rgba(255,236,190,.34),rgba(232,183,90,.1) 55%,transparent 90%);clip-path:polygon(46% 0,54% 0,100% 100%,0 100%);animation:lg-beam 9s ease-in-out infinite}
.lg-shade{position:absolute;inset:0;pointer-events:none;
background:radial-gradient(ellipse at 32% 48%,rgba(4,3,2,.5),rgba(3,2,2,.93) 78%),linear-gradient(180deg,rgba(0,0,0,.9),transparent 24%,transparent 68%,rgba(0,0,0,.96))}
.lg-dust{position:absolute;inset:0;pointer-events:none;overflow:hidden}
.lg-dust i{position:absolute;bottom:-10px;width:var(--s);height:var(--s);border-radius:50%;background:#ffe6b0;opacity:0;box-shadow:0 0 8px rgba(255,220,150,.9);
animation:lg-dust var(--d) linear infinite;animation-delay:var(--dl)}
.lg-flare{position:absolute;top:36%;left:-60%;width:55%;height:3px;pointer-events:none;opacity:0;filter:blur(1.5px);
background:linear-gradient(90deg,transparent,rgba(255,226,170,.9),#fff,rgba(255,226,170,.9),transparent);box-shadow:0 0 44px 8px rgba(232,183,90,.45);
animation:lg-flare 11s ease-in-out 4.2s infinite}
.lg-grain{position:absolute;inset:-50%;pointer-events:none;opacity:.13;animation:lg-grain .8s steps(1) infinite;
background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='220' height='220'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}

/* ---------- letterbox + intro ---------- */
.lg-bar{position:fixed;left:0;right:0;height:50.5vh;background:#000;z-index:60;pointer-events:none;animation:lg-bar 1.5s cubic-bezier(.77,0,.18,1) 1.5s forwards}
.lg-bar.t{top:0}.lg-bar.b{bottom:0}
.lg-bar:after{content:'';position:absolute;left:0;right:0;height:1px;background:linear-gradient(90deg,transparent,rgba(232,183,90,.75),transparent)}
.lg-bar.t:after{bottom:0}.lg-bar.b:after{top:0}
.lg-intro{position:fixed;inset:0;z-index:61;display:grid;place-items:center;pointer-events:none;animation:lg-intro-out .45s ease 1.25s forwards}
.lg-intro-in{display:flex;flex-direction:column;align-items:center;gap:16px}
.lg-intro-reel{color:var(--gold);filter:drop-shadow(0 0 18px rgba(232,183,90,.8));animation:lg-intro-in 1s cubic-bezier(.2,.8,.2,1) both}
.lg-intro-t{font-family:'Playfair Display',Georgia,serif;font-weight:800;font-size:clamp(28px,5vw,58px);color:var(--ink);padding-left:.34em;animation:lg-intro-t 1.3s cubic-bezier(.2,.8,.2,1) .15s both}
.lg-intro-l{height:1px;background:linear-gradient(90deg,transparent,var(--gold),transparent);animation:lg-intro-l 1.2s ease .3s both}
.lg-intro-s{font-size:11px;letter-spacing:.5em;color:var(--gold);animation:lg-fade 1s .5s both;opacity:0}

/* ---------- layout ---------- */
.lg-in{animation:lg-up .95s cubic-bezier(.2,.8,.2,1) both;animation-delay:calc(1.95s + var(--d,0s))}
.lg-scroll{position:absolute;inset:0;z-index:5;overflow-y:auto;overflow-x:hidden;display:flex;flex-direction:column;
padding:calc(var(--bh) + 16px) clamp(18px,4vw,64px) calc(var(--bh) + 58px)}
.lg-top{display:flex;align-items:center;justify-content:space-between;gap:14px}
.lg-logo{display:flex;align-items:center;gap:13px}
.lg-logo-mark{width:44px;height:44px;border-radius:50%;display:grid;place-items:center;color:var(--gold);border:1px solid rgba(232,183,90,.55);
background:rgba(232,183,90,.08);box-shadow:0 0 22px rgba(232,183,90,.3)}
.lg-logo-mark svg{animation:lg-spin 14s linear infinite}
.lg-logo-t{font-family:'Playfair Display',Georgia,serif;font-size:26px;font-weight:600;color:#fff;line-height:1}
.lg-logo-t b{color:var(--gold);font-weight:800}
.lg-logo-s{font-size:9.5px;letter-spacing:.3em;color:var(--mut);margin-top:5px}
.lg-pill{display:inline-flex;align-items:center;gap:10px;padding:9px 18px;border-radius:999px;font-size:11px;letter-spacing:.22em;color:var(--gold2);
border:1px solid rgba(232,183,90,.4);background:rgba(232,183,90,.07);backdrop-filter:blur(8px)}
.lg-rec{display:inline-block;width:9px;height:9px;border-radius:50%;background:#ff2a2a;box-shadow:0 0 12px #ff2a2a;animation:lg-pulse 1.5s ease-in-out infinite}
.lg-main{flex:1;display:grid;grid-template-columns:minmax(0,1.15fr) minmax(340px,440px);gap:clamp(24px,5vw,84px);align-items:center;padding:clamp(16px,3vh,40px) 0}

/* ---------- hero ---------- */
.lg-kick{display:flex;align-items:center;gap:12px;font-size:11.5px;letter-spacing:.3em;color:var(--gold2);margin-bottom:18px;flex-wrap:wrap}
.lg-kick-sep{width:30px;height:1px;background:rgba(232,183,90,.6)}
.lg-h{margin:0;font-weight:400;line-height:1}
.lg-ln{display:block;overflow:hidden;padding:.08em 0}
.lg-ln>span{display:block;transform:translateY(112%);animation:lg-line 1.05s cubic-bezier(.2,.8,.2,1) forwards;animation-delay:calc(2s + var(--d,0s))}
.lg-ln:not(.big):not(.it){font-size:clamp(20px,2.4vw,34px);font-weight:300;letter-spacing:.16em;text-transform:uppercase;color:#efe6d6}
.lg-ln.big{font-family:'Playfair Display',Georgia,serif;font-weight:800;font-size:clamp(44px,6.8vw,106px);text-transform:uppercase;letter-spacing:.01em;line-height:1.02}
.lg-ln.big .g{display:block;background:linear-gradient(100deg,#fff1c9 0%,#f5c26b 28%,#b9782a 52%,#ffe7a8 74%,#f5c26b 100%);background-size:220% 100%;
-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent;animation:lg-line 1.05s cubic-bezier(.2,.8,.2,1) forwards,lg-shine 7s linear 3s infinite;
animation-delay:calc(2s + var(--d,0s)),3s;filter:drop-shadow(0 6px 26px rgba(232,183,90,.28))}
.lg-ln.it{font-family:'Playfair Display',Georgia,serif;font-style:italic;font-weight:600;font-size:clamp(30px,4.2vw,64px);color:#fff;margin-top:-.05em}
.lg-mood{display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin-top:18px;font-size:clamp(14px,1.5vw,18px);color:#d9cfbc;font-weight:300}
.lg-rot{display:inline-block;height:1.5em;overflow:hidden}
.lg-rot-in{display:flex;flex-direction:column;animation:lg-rot 12.5s ease-in-out 2.5s infinite}
.lg-rot-in b{display:block;height:1.5em;line-height:1.5em;font-family:'Playfair Display',Georgia,serif;font-style:italic;font-weight:600;color:var(--gold);
border-bottom:1px solid rgba(232,183,90,.5)}
.lg-sub{max-width:560px;margin:16px 0 0;font-size:15px;line-height:1.75;color:var(--mut)}
.lg-chips{display:flex;flex-wrap:wrap;gap:10px;margin-top:22px}
.lg-chip{display:inline-flex;align-items:center;gap:9px;padding:9px 15px;border-radius:999px;font-size:12.5px;color:#efe6d6;
border:1px solid rgba(232,183,90,.28);background:rgba(255,255,255,.04);backdrop-filter:blur(8px);transition:transform .25s,border-color .25s,background .25s}
.lg-chip svg{color:var(--gold)}
.lg-chip:hover{transform:translateY(-3px);border-color:var(--gold);background:rgba(232,183,90,.12)}
.lg-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px;margin-top:26px;max-width:640px}
.lg-stat{padding:14px 16px;border-radius:16px;background:linear-gradient(160deg,rgba(232,183,90,.1),rgba(255,255,255,.02));border:1px solid rgba(232,183,90,.25);backdrop-filter:blur(10px);transition:transform .25s,box-shadow .25s}
.lg-stat:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(232,183,90,.2)}
.lg-stat-n{font-family:'Playfair Display',Georgia,serif;font-size:clamp(19px,1.9vw,26px);font-weight:800;color:var(--gold2);white-space:nowrap;line-height:1.1}
.lg-stat-l{font-size:10px;letter-spacing:.16em;color:var(--mut);text-transform:uppercase;margin-top:5px}

/* ---------- ticket ---------- */
.lg-tkwrap{justify-self:end;width:100%;max-width:440px}
.lg-tkshadow{filter:drop-shadow(0 34px 50px rgba(0,0,0,.75)) drop-shadow(0 0 36px rgba(232,183,90,.14))}
.lg-ticket{--notch:158px;position:relative;border-radius:26px;overflow:hidden;background:#0a0705;
transform:perspective(1100px) rotateY(calc(var(--nx,0) * 9deg)) rotateX(calc(var(--ny,0) * -7deg));transition:transform .25s ease-out;
-webkit-mask:radial-gradient(circle 15px at 0 var(--notch),#0000 97%,#000) left/51% 100% no-repeat,radial-gradient(circle 15px at 100% var(--notch),#0000 97%,#000) right/51% 100% no-repeat;
mask:radial-gradient(circle 15px at 0 var(--notch),#0000 97%,#000) left/51% 100% no-repeat,radial-gradient(circle 15px at 100% var(--notch),#0000 97%,#000) right/51% 100% no-repeat}
.lg-ticket:before{content:'';position:absolute;inset:-60%;background:conic-gradient(from 0deg,transparent 0 68%,rgba(232,183,90,.95) 84%,transparent 100%);animation:lg-spin 7s linear infinite}
.lg-ticket:after{content:'';position:absolute;inset:1.5px;border-radius:24.5px;background:linear-gradient(160deg,#1b140d,#0a0705 60%)}
.lg-spot{position:absolute;inset:1.5px;z-index:1;border-radius:24.5px;pointer-events:none;
background:radial-gradient(420px circle at var(--mx,50%) var(--my,0%),rgba(232,183,90,.15),transparent 62%)}
.lg-perf{position:absolute;z-index:2;left:24px;right:24px;top:var(--notch);border-top:2px dashed rgba(232,183,90,.38)}
.lg-tk-top{position:relative;z-index:2;height:var(--notch);padding:26px 28px 0;display:flex;justify-content:space-between;gap:12px}
.lg-tk-k{font-size:10px;letter-spacing:.3em;color:var(--gold)}
.lg-tk-top h2{margin:8px 0 6px;font-family:'Playfair Display',Georgia,serif;font-weight:800;font-size:34px;line-height:1.05;color:#fff}
.lg-it{font-style:italic;font-weight:600;color:var(--gold)}
.lg-tk-s{font-size:12.5px;color:var(--mut);line-height:1.5;max-width:230px}
.lg-stamp{align-self:flex-start;transform:rotate(9deg);padding:8px 12px;border:2px solid rgba(232,183,90,.7);border-radius:8px;font-size:11px;font-weight:700;letter-spacing:.2em;
text-align:center;line-height:1.35;color:var(--gold);box-shadow:0 0 18px rgba(232,183,90,.25),inset 0 0 12px rgba(232,183,90,.12)}
.lg-tk-body{position:relative;z-index:2;padding:26px 28px 22px}
.lg-field{position:relative;margin-bottom:14px}
.lg-ico{position:absolute;left:17px;top:50%;transform:translateY(-50%);z-index:3;color:#a98f5c;display:grid;transition:color .25s}
.lg-field:focus-within .lg-ico{color:var(--gold2)}
.lg .lg-field .form-group{margin:0;width:100%}
.lg .lg-field input.form-control{height:54px;width:100%;padding:0 48px 0 50px;border-radius:14px;font-size:15px;color:#fff!important;
background:rgba(255,255,255,.04)!important;border:1px solid rgba(232,183,90,.22)!important;box-shadow:none!important;transition:border-color .25s,background .25s,box-shadow .25s}
.lg .lg-field input.form-control:focus{border-color:var(--gold)!important;background:rgba(232,183,90,.07)!important;box-shadow:0 0 0 4px rgba(232,183,90,.14),0 0 24px rgba(232,183,90,.22)!important;outline:none}
.lg .lg-field input.form-control::placeholder{color:#8b806c}
.lg .lg-field input:-webkit-autofill{-webkit-text-fill-color:#fff;box-shadow:0 0 0 100px #1c150d inset!important}
.lg-eye{position:absolute;right:8px;top:50%;transform:translateY(-50%);z-index:3;width:38px;height:38px;border:0;border-radius:50%;background:transparent;color:#a98f5c;cursor:pointer;display:grid;place-items:center;transition:color .2s,background .2s}
.lg-eye:hover{color:var(--gold2);background:rgba(232,183,90,.12)}
.lg .lg-btn.btn{position:relative;overflow:hidden;width:100%;height:54px;border-radius:14px;display:flex;align-items:center;justify-content:center;gap:12px;font-size:15px;font-weight:600;letter-spacing:.04em;cursor:pointer;transition:transform .2s,box-shadow .25s,background .25s}
.lg .lg-btn.lg-gold{margin-top:6px;border:0;color:#1a1005;background:linear-gradient(100deg,#f7d794,#e8b75a 50%,#c98a2b);box-shadow:0 12px 34px rgba(232,183,90,.38)}
.lg .lg-btn.lg-gold:after{content:'';position:absolute;top:0;left:-70%;width:40%;height:100%;transform:skewX(-20deg);background:linear-gradient(100deg,transparent,rgba(255,255,255,.65),transparent);animation:lg-sweep 4s ease-in-out infinite}
.lg .lg-btn.lg-gold:hover{transform:translateY(-3px);box-shadow:0 18px 46px rgba(232,183,90,.55)}
.lg .lg-btn.lg-gold:hover svg{animation:lg-nudge .7s ease-in-out infinite}
.lg .lg-btn.lg-ghost{color:var(--ink);background:rgba(255,255,255,.03);border:1px solid rgba(232,183,90,.4)}
.lg .lg-btn.lg-ghost:hover{transform:translateY(-3px);background:rgba(232,183,90,.12);border-color:var(--gold)}
.lg-or{display:flex;align-items:center;gap:14px;margin:14px 0;font-size:11px;letter-spacing:.3em;color:#7d725f;text-transform:uppercase}
.lg-or:before,.lg-or:after{content:'';flex:1;height:1px;background:linear-gradient(90deg,transparent,rgba(232,183,90,.3),transparent)}
.lg-row{display:flex;justify-content:space-between;align-items:center;margin-top:16px;font-size:12.5px;color:var(--mut)}
.lg-row label{display:inline-flex;align-items:center;gap:8px;margin:0;font-weight:400;cursor:pointer}
.lg-row input{accent-color:var(--gold);width:15px;height:15px}
.lg-row a{color:var(--gold2)!important;text-decoration:none!important}
.lg-row a:hover{text-decoration:underline!important}
.lg-signup{text-align:center;margin-top:14px;font-size:13px;color:var(--mut)}
.lg-signup b{color:var(--gold2);cursor:pointer}
.lg-barcode{height:34px;margin:18px auto 12px;width:72%;opacity:.55;
background:repeating-linear-gradient(90deg,#e8b75a 0 2px,transparent 2px 5px,#e8b75a 5px 6px,transparent 6px 10px,#e8b75a 10px 13px,transparent 13px 15px)}
.lg-hint{font-size:10px;line-height:1.55;color:#6f6552;text-align:center}

/* ---------- end credits ---------- */
.lg-credits{position:absolute;left:0;right:0;bottom:calc(var(--bh) + 10px);z-index:6;overflow:hidden;opacity:0;animation:lg-fade 1s 2.8s forwards;pointer-events:none;
-webkit-mask-image:linear-gradient(90deg,transparent,#000 10%,#000 90%,transparent);mask-image:linear-gradient(90deg,transparent,#000 10%,#000 90%,transparent)}
.lg-credits-in{display:flex;align-items:center;width:max-content;animation:lg-marq 80s linear infinite;font-size:11px;letter-spacing:.32em;color:#9a8e78}
.lg-credits-in span{margin:0 22px}
.lg-credits-in em{font-style:normal;color:var(--gold);opacity:.7}

/* ---------- responsive ---------- */
@media(max-width:1000px){.lg-main{grid-template-columns:1fr}.lg-tkwrap{justify-self:center}.lg-pill{display:none}}
@media(max-width:560px){.lg{--bh:5vh}.lg-stats{grid-template-columns:repeat(2,minmax(0,1fr))}.lg-ticket{--notch:170px}.lg-credits{display:none}}
@media(prefers-reduced-motion:reduce){
.lg *,.lg *:before,.lg *:after{animation:none!important}
.lg-bar{height:var(--bh)}.lg-intro{display:none}.lg-ln>span{transform:none}.lg-credits{opacity:1}.lg-ticket:before{display:none}}
)---"

lg_js <- r"---(
(function(){
  if (window.__lgJs) { return; }
  window.__lgJs = true;
  var busy = false;
  document.addEventListener('mousemove', function(e){
    var root = document.querySelector('.lg');
    if (!root || busy) { return; }
    busy = true;
    window.requestAnimationFrame(function(){
      busy = false;
      root.style.setProperty('--nx', (e.clientX / window.innerWidth - 0.5).toFixed(3));
      root.style.setProperty('--ny', (e.clientY / window.innerHeight - 0.5).toFixed(3));
      var t = root.querySelector('.lg-ticket');
      if (t) {
        var r = t.getBoundingClientRect();
        t.style.setProperty('--mx', ((e.clientX - r.left) / r.width * 100).toFixed(1) + '%');
        t.style.setProperty('--my', ((e.clientY - r.top) / r.height * 100).toFixed(1) + '%');
      }
    });
  });
})();
)---"

login_css <- r"---(
.mr-login{position:fixed;inset:0;overflow:hidden;background:#05070d;color:#f4f4f5;z-index:50;
font-family:'Inter',system-ui,-apple-system,'Segoe UI',Arial,sans-serif}
.mr-login *{box-sizing:border-box}

/* ---------- poster wall ---------- */
.mr-bg{position:absolute;inset:0;overflow:hidden;z-index:0}
.mr-wall{position:absolute;inset:-28% -14%;transform:rotate(-11deg);pointer-events:none}
.mr-wall-inner{display:grid;grid-template-columns:repeat(8,1fr);gap:14px;align-items:start}
.mr-col{will-change:transform;animation:mr-up linear infinite}
.mr-col.mr-down{animation-name:mr-down}
.mr-col-track{display:flex;flex-direction:column;gap:14px;padding-bottom:14px}
.mr-tile{position:relative;width:100%;aspect-ratio:2/3;border-radius:12px;overflow:hidden;
background:linear-gradient(160deg,var(--c1),var(--c2));
box-shadow:0 14px 34px rgba(0,0,0,.55),0 0 0 1px rgba(255,255,255,.08)}
.mr-tile img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;display:block}
.mr-tile-fb{position:absolute;inset:0;display:flex;flex-direction:column;justify-content:flex-end;
gap:4px;padding:12px;background:linear-gradient(to top,rgba(0,0,0,.7),rgba(0,0,0,.05) 65%)}
.mr-fb-year{font-size:10px;letter-spacing:.2em;opacity:.85}
.mr-fb-title{font-family:'Bebas Neue',Impact,'Arial Narrow',sans-serif;font-size:clamp(18px,2vw,28px);
line-height:1;letter-spacing:.03em;color:#fff}
.mr-fb-tag{font-size:9px;letter-spacing:.16em;color:var(--acc)}
.mr-tile-gloss{position:absolute;inset:0;pointer-events:none;
background:linear-gradient(135deg,rgba(255,255,255,.18),transparent 35%,transparent 70%,rgba(0,0,0,.28))}
@keyframes mr-up{from{transform:translateY(0)}to{transform:translateY(-50%)}}
@keyframes mr-down{from{transform:translateY(-50%)}to{transform:translateY(0)}}

/* ---------- atmosphere ---------- */
.mr-shade{position:absolute;inset:0;z-index:1;pointer-events:none;background:
linear-gradient(90deg,rgba(5,7,13,.97) 0%,rgba(5,7,13,.82) 34%,rgba(5,7,13,.45) 62%,rgba(5,7,13,.72) 100%),
linear-gradient(180deg,rgba(5,7,13,.78) 0%,rgba(5,7,13,0) 24%,rgba(5,7,13,0) 66%,rgba(5,7,13,.97) 100%)}
.mr-orb{position:absolute;border-radius:50%;filter:blur(100px);z-index:1;pointer-events:none}
.mr-orb.o1{width:520px;height:520px;left:-140px;top:-160px;background:var(--acc2);opacity:.22}
.mr-orb.o2{width:580px;height:580px;right:-180px;bottom:-220px;background:#6366f1;opacity:.34}
.mr-grain{position:absolute;inset:0;z-index:2;pointer-events:none;opacity:.07;mix-blend-mode:overlay;
background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='.85' numOctaves='2' stitchTiles='stitch'/></filter><rect width='100%25' height='100%25' filter='url(%23n)'/></svg>")}
.mr-filmstrip{position:absolute;left:0;right:0;bottom:0;height:16px;z-index:4;pointer-events:none;
background:linear-gradient(90deg,rgba(255,255,255,.16) 0 12px,transparent 12px 26px) 0 5px/26px 6px repeat-x,rgba(0,0,0,.65)}

/* ---------- layout ---------- */
.mr-scroll{position:absolute;inset:0 0 16px 0;z-index:3;overflow-y:auto;overflow-x:hidden;
display:flex;flex-direction:column}
.mr-top{display:flex;align-items:center;justify-content:space-between;padding:22px clamp(18px,4vw,56px)}
.mr-logo{display:flex;align-items:center;gap:11px}
.mr-logo-mark{width:38px;height:38px;border-radius:11px;display:grid;place-items:center;color:#141821;
background:linear-gradient(135deg,var(--acc),var(--acc2));box-shadow:0 8px 24px rgba(var(--acc2-rgb),.45)}
.mr-logo-text{font-family:'Bebas Neue',Impact,'Arial Narrow',sans-serif;font-size:31px;letter-spacing:.14em;
color:#fff;line-height:1}
.mr-logo-text b{color:var(--acc);font-weight:400}
.mr-pill{font-size:10.5px;letter-spacing:.2em;padding:8px 15px;border-radius:999px;color:#d7dbe3;
border:1px solid rgba(255,255,255,.16);background:rgba(255,255,255,.06);backdrop-filter:blur(8px)}
.mr-main{flex:1;width:100%;max-width:1400px;margin:0 auto;display:grid;align-items:center;
grid-template-columns:minmax(0,1.15fr) minmax(0,.85fr);gap:clamp(24px,5vw,80px);
padding:10px clamp(18px,4vw,56px) 40px}

/* ---------- hero ---------- */
.mr-eyebrow{display:inline-flex;align-items:center;gap:10px;font-size:11px;letter-spacing:.2em;font-weight:700;
color:var(--acc);padding:8px 15px;border-radius:999px;background:rgba(var(--acc-rgb),.09);
border:1px solid rgba(var(--acc-rgb),.28)}
.mr-dot{width:7px;height:7px;border-radius:50%;background:var(--acc);animation:mr-pulse 2s infinite}
.mr-headline{font-family:'Bebas Neue',Impact,'Arial Narrow',sans-serif;font-weight:400;
font-size:clamp(54px,8vw,120px);line-height:.92;letter-spacing:.01em;margin:22px 0 18px;color:#fff;
text-shadow:0 10px 40px rgba(0,0,0,.6)}
.mr-headline span{background:linear-gradient(100deg,var(--acc),#f97316 55%,#ef4444);
-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent}
.mr-sub{max-width:520px;font-size:16px;line-height:1.7;color:#b9c0cc;margin:0 0 24px}
.mr-chips{display:flex;flex-wrap:wrap;gap:10px;margin-bottom:30px;max-width:600px}
.mr-chip{display:inline-flex;align-items:center;gap:8px;font-size:12.5px;font-weight:600;color:#e6e9ef;
padding:9px 14px;border-radius:999px;background:rgba(255,255,255,.07);
border:1px solid rgba(255,255,255,.12);backdrop-filter:blur(8px)}
.mr-chip svg{color:var(--acc)}
.mr-stats{display:flex;flex-wrap:wrap;gap:clamp(18px,3vw,44px);padding-top:22px;max-width:600px;
border-top:1px solid rgba(255,255,255,.12)}
.mr-stat-n{font-family:'Bebas Neue',Impact,'Arial Narrow',sans-serif;font-size:38px;line-height:1;
letter-spacing:.04em;color:#fff}
.mr-stat-l{font-size:10.5px;letter-spacing:.18em;color:#8f98a8;margin-top:5px;text-transform:uppercase}

/* ---------- sign-in card ---------- */
@property --a{syntax:'<angle>';initial-value:0deg;inherits:false}
.mr-card-wrap{display:flex;justify-content:center}
.mr-card{position:relative;width:440px;max-width:100%;padding:38px 38px 28px;border-radius:24px;
background:linear-gradient(160deg,rgba(22,27,39,.78),rgba(8,11,18,.88));
-webkit-backdrop-filter:blur(22px) saturate(140%);backdrop-filter:blur(22px) saturate(140%);
box-shadow:0 30px 80px rgba(0,0,0,.65),inset 0 1px 0 rgba(255,255,255,.08);
animation:mr-rise .7s cubic-bezier(.2,.8,.2,1) both}
.mr-card:before{content:'';position:absolute;inset:0;border-radius:24px;padding:1.5px;pointer-events:none;
background:conic-gradient(from var(--a),rgba(var(--acc-rgb),0) 0%,rgba(var(--acc-rgb),.95) 12%,
rgba(249,115,22,.8) 22%,rgba(var(--acc-rgb),0) 34%,rgba(255,255,255,.08) 60%,rgba(var(--acc-rgb),0) 100%);
-webkit-mask:linear-gradient(#000 0 0) content-box,linear-gradient(#000 0 0);
-webkit-mask-composite:xor;mask-composite:exclude;animation:mr-spin 7s linear infinite}
@keyframes mr-spin{to{--a:360deg}}
.mr-avatar{width:54px;height:54px;border-radius:16px;display:grid;place-items:center;color:var(--acc);
margin-bottom:16px;background:linear-gradient(135deg,rgba(var(--acc-rgb),.22),rgba(249,115,22,.12));
border:1px solid rgba(var(--acc-rgb),.35)}
.mr-card h2{margin:0 0 6px;font-size:28px;font-weight:800;letter-spacing:-.01em;color:#fff}
.mr-card-sub{margin:0 0 24px;color:#98a1b1;font-size:14px;line-height:1.55}

.mr-field{position:relative;margin-bottom:14px}
.mr-field .shiny-input-container{width:100%!important;max-width:100%!important;margin:0!important}
.mr-field label.control-label{display:none!important}
.mr-field input.form-control,.mr-field input[type=text],.mr-field input[type=password]{
width:100%!important;height:52px!important;padding:0 16px 0 46px!important;border-radius:14px!important;
border:1px solid rgba(255,255,255,.12)!important;background:rgba(255,255,255,.05)!important;color:#fff!important;
font-size:14.5px!important;box-shadow:none!important;transition:border-color .2s,background .2s,box-shadow .2s}
.mr-field input[type=password]{padding-right:50px!important}
.mr-field input::placeholder{color:#7f8898!important;opacity:1}
.mr-field input:focus{outline:none!important;border-color:var(--acc)!important;background:rgba(var(--acc-rgb),.06)!important;
box-shadow:0 0 0 4px rgba(var(--acc-rgb),.14)!important}
.mr-ico{position:absolute;left:16px;top:26px;transform:translateY(-50%);color:#7f8898;z-index:2;
pointer-events:none;display:flex;transition:color .2s}
.mr-field:focus-within .mr-ico{color:var(--acc)}
.mr-eye{position:absolute;right:8px;top:26px;transform:translateY(-50%);width:36px;height:36px;border:0;
border-radius:10px;background:transparent;color:#8a93a4;cursor:pointer;display:grid;place-items:center;z-index:2}
.mr-eye:hover{color:var(--acc);background:rgba(255,255,255,.06)}

.mr-card .mr-btn{width:100%!important;height:52px;border-radius:14px!important;border:0!important;
font-size:15px!important;font-weight:800!important;letter-spacing:.02em;display:flex!important;
align-items:center;justify-content:center;gap:10px;cursor:pointer;position:relative;overflow:hidden;
transition:transform .2s,box-shadow .25s,background .25s}
.mr-card .mr-btn-primary{background:linear-gradient(135deg,var(--acc),var(--acc2) 55%,#f97316)!important;
color:#141821!important;box-shadow:0 12px 30px rgba(var(--acc2-rgb),.38)}
.mr-card .mr-btn-primary:hover{transform:translateY(-2px);box-shadow:0 18px 42px rgba(var(--acc2-rgb),.55)}
.mr-card .mr-btn-primary:after{content:'';position:absolute;top:0;left:-60%;width:40%;height:100%;
background:linear-gradient(100deg,transparent,rgba(255,255,255,.55),transparent);transform:skewX(-20deg);
animation:mr-shine 3.8s ease-in-out infinite}
.mr-card .mr-btn-ghost{background:rgba(255,255,255,.06)!important;color:#e9ecf2!important;
border:1px solid rgba(255,255,255,.16)!important}
.mr-card .mr-btn-ghost:hover{background:rgba(255,255,255,.12)!important;transform:translateY(-1px)}
.mr-divider{display:flex;align-items:center;gap:14px;margin:16px 0;color:#6e7785;font-size:11px;
letter-spacing:.2em;text-transform:uppercase}
.mr-divider:before,.mr-divider:after{content:'';flex:1;height:1px;background:rgba(255,255,255,.1)}
.mr-row{display:flex;align-items:center;justify-content:space-between;margin:18px 0 6px;font-size:12.5px;
color:#b7bcc7}
.mr-row label{display:flex;align-items:center;gap:8px;cursor:pointer;font-weight:500;margin:0}
.mr-row input{accent-color:var(--acc);margin:0}
.mr-row a{color:#b7bcc7;text-decoration:none}
.mr-row a:hover{color:var(--acc)}
.mr-signup{color:#8a92a3;font-size:13.5px;margin-top:10px}
.mr-signup b{color:#fff;cursor:pointer}
.mr-signup b:hover{color:var(--acc)}
.mr-hint{font-size:10.5px;color:#6e7785;margin-top:20px;line-height:1.65;padding-top:16px;
border-top:1px solid rgba(255,255,255,.08)}

@keyframes mr-rise{from{opacity:0;transform:translateY(22px) scale(.98)}to{opacity:1;transform:none}}
@keyframes mr-shine{0%,55%{left:-60%}100%{left:130%}}
@keyframes mr-pulse{0%{box-shadow:0 0 0 0 rgba(var(--acc-rgb),.6)}70%{box-shadow:0 0 0 9px rgba(var(--acc-rgb),0)}
100%{box-shadow:0 0 0 0 rgba(var(--acc-rgb),0)}}

/* ---------- responsive ---------- */
@media(max-width:980px){
.mr-main{grid-template-columns:1fr;gap:26px;padding-top:0}
.mr-hero{text-align:center;display:flex;flex-direction:column;align-items:center}
.mr-headline{font-size:clamp(46px,12vw,78px)}
.mr-sub,.mr-chips,.mr-stats{display:none}
.mr-wall-inner{grid-template-columns:repeat(5,1fr)}
.mr-col:nth-child(n+6){display:none}
.mr-shade{background:linear-gradient(180deg,rgba(5,7,13,.6) 0%,rgba(5,7,13,.82) 45%,rgba(5,7,13,.97) 100%)}}
@media(max-width:560px){
.mr-card{padding:28px 22px 22px;border-radius:20px}
.mr-pill{display:none}
.mr-wall-inner{grid-template-columns:repeat(4,1fr);gap:10px}
.mr-col:nth-child(n+5){display:none}}
@media(prefers-reduced-motion:reduce){
.mr-col,.mr-card,.mr-card:before,.mr-card .mr-btn-primary:after,.mr-dot{animation:none!important}}
)---"


login_neon_css <- r"---(
/* ===== DARK PURPLE & NEON (login only) ===== */
.mr-login{--acc:#d946ef;--acc2:#7c3aed;--acc-rgb:217,70,239;--acc2-rgb:124,58,237;
--neon-pink:#e040fb;--neon-blue:#2f9bff;--neon-cyan:#22d3ee;
background:radial-gradient(1200px 700px at 12% 0%,#2a0a55 0%,transparent 60%),
radial-gradient(900px 700px at 100% 100%,#3b0a6e 0%,transparent 55%),#07021a;
font-family:'Poppins','Inter',system-ui,sans-serif}
.mr-shade{background:
linear-gradient(90deg,rgba(7,2,26,.97) 0%,rgba(10,3,34,.86) 36%,rgba(18,5,52,.5) 64%,rgba(10,3,34,.78) 100%),
linear-gradient(180deg,rgba(7,2,26,.8) 0%,rgba(7,2,26,0) 24%,rgba(7,2,26,0) 62%,rgba(7,2,26,.97) 100%)}
.mr-orb.o1{background:#a21caf;opacity:.38}
.mr-orb.o2{background:#4f46e5;opacity:.5}
.mr-tile{box-shadow:0 14px 34px rgba(0,0,0,.6),0 0 0 1px rgba(168,85,247,.35),0 0 22px rgba(168,85,247,.22)}
.mr-tile-gloss{background:linear-gradient(135deg,rgba(217,70,239,.22),transparent 38%,transparent 66%,rgba(79,70,229,.32))}
.mr-filmstrip{background:linear-gradient(90deg,rgba(168,85,247,.55) 0 12px,transparent 12px 26px) 0 5px/26px 6px repeat-x,rgba(7,2,26,.85);
box-shadow:0 -6px 24px rgba(168,85,247,.35)}

/* logo */
.mr-logo-mark{width:46px;height:46px;border-radius:50%;color:#fff;
background:linear-gradient(135deg,#a855f7,#6d28d9);box-shadow:0 0 24px rgba(168,85,247,.8),inset 0 0 10px rgba(255,255,255,.25)}
.mr-logo-wrap{display:flex;flex-direction:column;gap:4px}
.mr-logo-text{font-family:'Poppins',sans-serif;font-weight:700;font-size:28px;letter-spacing:.01em;text-transform:none}
.mr-logo-text b{color:var(--neon-pink);font-weight:700;text-shadow:0 0 14px rgba(224,64,251,.7)}
.mr-logo-tag{font-size:9.5px;letter-spacing:.26em;color:#a9a3c4}
.mr-pill{border-color:rgba(168,85,247,.5);background:rgba(124,58,237,.14);color:#e9d5ff;box-shadow:0 0 18px rgba(168,85,247,.25)}

/* hero */
.mr-headline{font-family:'Bebas Neue',Impact,sans-serif;text-transform:uppercase;margin:0 0 14px;
font-size:clamp(52px,6.4vw,104px);line-height:.95;letter-spacing:.015em}
.mr-headline .mr-h-small{display:inline-block;color:#fff;background:none;-webkit-text-fill-color:#fff;
font-size:.78em;text-shadow:0 6px 30px rgba(0,0,0,.6)}
.mr-headline .mr-h-neon{display:inline-block;font-size:1.28em;line-height:.95;
background:linear-gradient(90deg,#e040fb 0%,#a855f7 45%,#6366f1 100%);
-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent;
filter:drop-shadow(0 0 18px rgba(217,70,239,.55))}
.mr-tagline{font-size:clamp(14px,1.5vw,19px);font-weight:500;letter-spacing:.06em;color:#e6e0ff;margin:0 0 10px}
.mr-sub{color:#b4aed0;font-size:15px;max-width:440px;margin-bottom:26px}

/* feature icons */
.mr-feats{display:flex;flex-wrap:wrap;gap:clamp(16px,2.6vw,38px);margin-bottom:30px}
.mr-feat{display:flex;flex-direction:column;gap:9px;align-items:flex-start}
.mr-feat-ico{width:54px;height:54px;border-radius:14px;display:grid;place-items:center;color:var(--fc);
background:rgba(var(--fr),.10);border:1.5px solid var(--fc);box-shadow:0 0 18px rgba(var(--fr),.55),inset 0 0 12px rgba(var(--fr),.2)}
.mr-feat-l{font-size:12.5px;font-weight:500;line-height:1.35;color:#d8d3ee}
.mr-feat.f1{--fc:#a78bfa;--fr:167,139,250}
.mr-feat.f2{--fc:#ff4d8d;--fr:255,77,141}
.mr-feat.f3{--fc:#22d3ee;--fr:34,211,238}
.mr-feat.f4{--fc:#fb923c;--fr:251,146,60}

/* stats */
.mr-stats{border-top:1px solid rgba(168,85,247,.25);max-width:640px;gap:clamp(18px,3vw,46px)}
.mr-stat-n{font-family:'Bebas Neue',Impact,sans-serif;font-size:44px;letter-spacing:.03em}
.mr-stat.s1 .mr-stat-n{color:#e040fb;text-shadow:0 0 16px rgba(224,64,251,.6)}
.mr-stat.s2 .mr-stat-n{color:#c084fc;text-shadow:0 0 16px rgba(192,132,252,.55)}
.mr-stat.s3 .mr-stat-n{color:#38bdf8;text-shadow:0 0 16px rgba(56,189,248,.6)}
.mr-stat.s4 .mr-stat-n{color:#3b9dff;text-shadow:0 0 16px rgba(59,157,255,.6)}
.mr-stat-l{color:#9a93b8}

/* glass card */
.mr-card{background:linear-gradient(160deg,rgba(40,16,86,.62),rgba(12,5,38,.9));
box-shadow:0 30px 80px rgba(0,0,0,.7),0 0 60px rgba(168,85,247,.28),inset 0 1px 0 rgba(255,255,255,.1)}
.mr-card:before{background:conic-gradient(from var(--a),rgba(217,70,239,0) 0%,rgba(217,70,239,1) 12%,
rgba(99,102,241,.95) 26%,rgba(217,70,239,0) 38%,rgba(168,85,247,.5) 64%,rgba(217,70,239,0) 100%)}
.mr-avatar{width:60px;height:60px;border-radius:16px;color:#fff;
background:linear-gradient(135deg,#d946ef,#7c3aed);border:0;box-shadow:0 0 26px rgba(217,70,239,.7)}
.mr-card h2{font-size:32px;font-weight:800}
.mr-neon-word{color:var(--neon-pink);text-shadow:0 0 18px rgba(224,64,251,.6)}
.mr-card-sub{color:#b4aed0}
.mr-field input.form-control,.mr-field input[type=text],.mr-field input[type=password]{
border:1px solid rgba(168,85,247,.28)!important;background:rgba(20,8,52,.55)!important}
.mr-field input:focus{border-color:#d946ef!important;background:rgba(124,58,237,.12)!important;
box-shadow:0 0 0 3px rgba(217,70,239,.2),0 0 20px rgba(217,70,239,.3)!important}
.mr-ico,.mr-eye{color:#9d8fc7}
.mr-card .mr-btn-primary{background:linear-gradient(90deg,#e040fb 0%,#9333ea 45%,#2f9bff 100%)!important;color:#fff!important;
box-shadow:0 10px 34px rgba(168,85,247,.55),0 0 24px rgba(47,155,255,.3)}
.mr-card .mr-btn-primary:hover{box-shadow:0 16px 46px rgba(217,70,239,.7),0 0 32px rgba(47,155,255,.45)}
.mr-card .mr-btn-ghost{background:rgba(255,255,255,.03)!important;color:#fff!important;border:1.5px solid rgba(196,181,253,.55)!important}
.mr-card .mr-btn-ghost:hover{background:rgba(168,85,247,.16)!important;box-shadow:0 0 22px rgba(168,85,247,.4)}
.mr-divider{color:#8c83ad}.mr-divider:before,.mr-divider:after{background:rgba(168,85,247,.28)}
.mr-row,.mr-row a{color:#c7c1e0}.mr-row a:hover{color:var(--neon-pink)}
.mr-row input{accent-color:#d946ef}
.mr-signup{color:#b4aed0}.mr-signup b{color:var(--neon-pink);text-shadow:0 0 12px rgba(224,64,251,.5)}
.mr-signup b:hover{color:#fff}
.mr-hint{color:#7d7499;border-top-color:rgba(168,85,247,.2)}

@media(max-width:980px){.mr-feats{justify-content:center}.mr-feats,.mr-tagline{display:flex}.mr-tagline{justify-content:center}
.mr-hero .mr-stats,.mr-hero .mr-sub{display:none}}
)---"


# Small reusable poster layer for compact rows (sidebar rail, "maybe you
# like" strip): a real image from the central get_poster_url() when one
# is known, with the same colored title-card fallback used everywhere
# else so a missing/broken image never leaves a visual gap.
photo_layer <- function(title, id, class_name = "photo-layer") {
  col1 <- card_palette[(id %% length(card_palette)) + 1]
  col2 <- card_palette[((id + 3) %% length(card_palette)) + 1]
  url <- get_poster_url(title)
  div(
    class = class_name,
    style = paste0("--c1:", col1, ";--c2:", col2, ";"),
    div(class = paste0(class_name, "-fb"), span(title)),
    if (nzchar(url)) tags$img(
      src = url, alt = paste(title, "poster"), loading = "lazy",
      onerror = "this.style.display='none';"
    )
  )
}
# ============================================================
# FEATURE LAYER (additive)
# Everything below is built ON TOP of the original model above.
# cosine_similarity(), normalize_scores(), similarity_scores() and
# recommend_movies() are NOT modified. The matrices below are just
# those same functions evaluated once at startup instead of once per
# page render.
# ============================================================

n_movies <- nrow(movies)
stopifnot(all(movies$movie_id == seq_len(n_movies)))

year_lo <- 2007L
year_hi <- 2026L

or_default <- function(x, d) {
  if (is.null(x) || !length(x) || (length(x) == 1 && is.na(x))) d else x
}

norm01 <- function(x) normalize_scores(x)

pretty_genre <- function(g) gsub("|", " - ", g, fixed = TRUE)

# Raw cosine similarity of every movie to every other movie.
content_raw <- t(sapply(seq_len(n_movies), function(i) similarity_scores(i, "content")))
collab_raw  <- t(sapply(seq_len(n_movies), function(i) similarity_scores(i, "collaborative")))

# Per-seed min-max normalisation, exactly as recommend_movies() does it.
content_norm <- t(apply(content_raw, 1, normalize_scores))
collab_norm  <- t(apply(collab_raw, 1, normalize_scores))

# ---- Application-derived signals (synthetic demo users only) ----
demo_n_ratings <- rowSums(rating_matrix > 0)
demo_likes     <- rowSums(rating_matrix >= 4)
demo_five      <- rowSums(rating_matrix == 5)

# How often each movie lands in another movie's Top-10 (hybrid, 50/50).
reco_freq <- numeric(n_movies)
for (i in seq_len(n_movies)) {
  h <- 0.5 * content_norm[i, ] + 0.5 * collab_norm[i, ]
  h[i] <- -1
  top <- order(h, decreasing = TRUE)[1:10]
  reco_freq[top] <- reco_freq[top] + 1
}

trending_score   <- 0.5 * norm01(movies$rating) + 0.3 * norm01(movies$year) + 0.2 * norm01(demo_likes)
popularity_score <- 0.5 * norm01(demo_n_ratings) + 0.5 * norm01(reco_freq)
gem_score        <- ifelse(movies$rating >= 7.5, norm01(movies$rating) * (1 - popularity_score), -1)

critic_titles <- poster_catalog$title[poster_catalog$badge == "CRITICS PICK"]
critics_ids <- which(toupper(movies$title) %in% critic_titles | movies$rating >= 8.5)
critics_ids <- critics_ids[order(movies$rating[critics_ids], decreasing = TRUE)]

top_by <- function(score, n) {
  head(order(score, decreasing = TRUE), n)
}

# ---- Mood Studio: moods mapped onto genres that exist in the data ----
mood_defs <- list(
  "Feel Good"  = list(icon = "smile", genres = c("Comedy", "Family", "Musical")),
  "Adrenaline" = list(icon = "flame", genres = c("Action", "Adventure", "Sport")),
  "Romantic"   = list(icon = "heart", genres = c("Romance", "Musical")),
  "Thoughtful" = list(icon = "bulb", genres = c("Drama", "Mystery")),
  "Thrilling"  = list(icon = "eye", genres = c("Thriller", "Mystery", "Crime")),
  "Funny"      = list(icon = "smile", genres = c("Comedy")),
  "Escape"     = list(icon = "rocket", genres = c("Fantasy", "Adventure", "Sci-Fi")),
  "Action"     = list(icon = "bolt", genres = c("Action")),
  "Emotional"  = list(icon = "drop", genres = c("Drama", "Family", "Romance"))
)

# ---- Profile-based recommendation (extends the original logic) ----
# A "profile" is a set of seed movies. Each seed contributes its own
# normalised content / rating-pattern similarity vector (the same ones
# recommend_movies() uses); the profile is their average. With one seed
# this reduces exactly to recommend_movies().
profile_scores <- function(seeds, content_weight = 0.5) {
  cvec <- colMeans(content_norm[seeds, , drop = FALSE])
  kvec <- colMeans(collab_norm[seeds, , drop = FALSE])
  list(content = cvec, collab = kvec,
       hybrid = content_weight * cvec + (1 - content_weight) * kvec)
}

recommend_profile <- function(seeds, n = 10, content_weight = 0.5,
                              minimum_rating = 0, minimum_year = 2007,
                              maximum_year = 2026, selected_genre = "All") {
  if (!length(seeds)) return(NULL)
  sc <- profile_scores(seeds, content_weight)
  eligible <- movies$rating >= minimum_rating &
    movies$year >= minimum_year & movies$year <= maximum_year
  if (selected_genre != "All") {
    eligible <- eligible & grepl(selected_genre, movies$genre, fixed = TRUE)
  }
  eligible[seeds] <- FALSE
  h <- sc$hybrid
  h[!eligible] <- -1
  ord <- order(h, decreasing = TRUE)
  ord <- ord[h[ord] >= 0]
  ord <- head(ord, n)
  if (!length(ord)) return(NULL)
  data.frame(
    Rank = seq_along(ord),
    movie_id = movies$movie_id[ord],
    Movie = movies$title[ord],
    Genre = movies$genre[ord],
    Year = movies$year[ord],
    Rating = movies$rating[ord],
    Content_Score = round(sc$content[ord], 3),
    Collaborative_Score = round(sc$collab[ord], 3),
    Hybrid_Score = round(h[ord], 3),
    stringsAsFactors = FALSE
  )
}

with_ids <- function(df) {
  if (is.null(df)) return(NULL)
  df$movie_id <- movies$movie_id[match(df$Movie, movies$title)]
  df
}

# ---- Taste profile, computed from session activity ----
compute_taste <- function(fav_ids, watch_ids, ratings_df) {
  w <- stats::setNames(numeric(length(all_genres)), all_genres)
  ids <- c(fav_ids, watch_ids, ratings_df$movie_id)
  wt <- c(rep(1, length(fav_ids)), rep(0.5, length(watch_ids)),
          pmax(0, (ratings_df$rating - 2) / 3))
  keep <- wt > 0
  ids <- ids[keep]
  wt <- wt[keep]
  if (!length(ids)) return(NULL)
  for (k in seq_along(ids)) {
    g <- genre_list[[ids[k]]]
    w[g] <- w[g] + wt[k]
  }
  list(pct = round(w / max(w) * 100), ids = ids, wt = wt)
}

preference_match <- function(target, taste) {
  if (is.null(taste)) return("No profile yet (favourite or rate a few movies)")
  v <- mean(taste$pct[genre_list[[target]]])
  if (v >= 60) "Strong" else if (v >= 30) "Moderate" else "Weak"
}

# Plain-language reasons built only from real model quantities.
why_items <- function(target, seeds) {
  seeds <- setdiff(seeds, target)
  out <- character(0)
  if (length(seeds)) {
    shared <- intersect(genre_list[[target]], unique(unlist(genre_list[seeds])))
    for (g in shared) out <- c(out, paste0("Similar ", g, " genre"))
    if (mean(collab_norm[seeds, target]) >= 0.6) out <- c(out, "Similar rating pattern")
  }
  if (movies$rating[target] >= 8) out <- c(out, paste0("High catalog rating (", movies$rating[target], ")"))
  if (!length(out)) out <- "Closest overall hybrid score in the catalog"
  head(out, 6)
}

why_ui <- function(target, seeds) {
  items <- why_items(target, seeds)
  tags$ul(class = "why-list",
          lapply(items, function(x) tags$li(HTML("&#10003;&nbsp;"), x)))
}

with_seed <- function(seed, expr) {
  old <- if (exists(".Random.seed", envir = .GlobalEnv)) get(".Random.seed", envir = .GlobalEnv) else NULL
  on.exit({
    if (is.null(old)) {
      if (exists(".Random.seed", envir = .GlobalEnv)) rm(".Random.seed", envir = .GlobalEnv)
    } else {
      assign(".Random.seed", old, envir = .GlobalEnv)
    }
  })
  set.seed(seed)
  expr
}

# ============================================================
# AVERAGE COMPONENT SCORES (used by Recommendation Analytics)
# For each movie j: mean over every other movie i of how strongly j
# is recommended from i (normalised content / rating-pattern / 50-50
# hybrid). Same normalised matrices the model uses.
# ============================================================
avg_off_diag <- function(m) (colSums(m) - diag(m)) / (nrow(m) - 1)
avg_content <- avg_off_diag(content_norm)
avg_collab  <- avg_off_diag(collab_norm)
avg_hybrid  <- 0.5 * avg_content + 0.5 * avg_collab


# ============================================================
# HOLD-OUT EVALUATION (RMSE / MAE) on the synthetic demo ratings
# Hide a random share of the observed demo ratings, rebuild the
# rating-pattern similarity from what is left, predict the hidden
# ratings, and compare with the true (hidden) values.
# Neighbour prediction = similarity-weighted average of the user's
# own remaining ratings over the k most similar movies. The same cosine
# similarities the recommender uses supply the weights.
# ============================================================
evaluate_holdout <- function(frac = 0.2, k = 10, w = 0.5, seed = 42) {
  R <- rating_matrix
  obs <- which(R > 0, arr.ind = TRUE)
  n_obs <- nrow(obs)
  n_test <- max(1, round(frac * n_obs))
  pick <- with_seed(seed, sample.int(n_obs, n_test))
  test <- obs[pick, , drop = FALSE]
  train <- R
  train[test] <- 0
  actual <- R[test]
  
  # similarities rebuilt from TRAINING ratings only
  nr <- sqrt(rowSums(train^2))
  S_pat <- (train %*% t(train)) / (nr %o% nr)
  S_pat[!is.finite(S_pat)] <- 0
  diag(S_pat) <- 0
  S_con <- content_raw
  diag(S_con) <- 0
  S_hyb <- w * S_con + (1 - w) * S_pat
  
  global_mean <- mean(train[train > 0])
  cnt <- rowSums(train > 0)
  movie_mean <- ifelse(cnt > 0, rowSums(train) / pmax(cnt, 1), global_mean)
  
  predict_nn <- function(S) {
    pred <- numeric(n_test)
    covered <- logical(n_test)
    for (t in seq_len(n_test)) {
      i <- test[t, 1]
      u <- test[t, 2]
      rated <- which(train[, u] > 0)
      rated <- rated[rated != i]
      pred[t] <- movie_mean[i]
      if (length(rated)) {
        sims <- S[i, rated]
        ord <- order(sims, decreasing = TRUE)[seq_len(min(k, length(rated)))]
        sv <- sims[ord]
        rv <- train[rated[ord], u]
        if (sum(sv) > 0) {
          pred[t] <- sum(sv * rv) / sum(sv)
          covered[t] <- TRUE
        }
      }
    }
    list(pred = pmin(5, pmax(1, pred)), covered = mean(covered))
  }
  
  runs <- list(
    "Global mean (baseline)" = list(pred = rep(global_mean, n_test), covered = 1),
    "Movie mean (baseline)" = list(pred = movie_mean[test[, 1]], covered = 1),
    "Rating-pattern neighbours" = predict_nn(S_pat),
    "Content (genre) neighbours" = predict_nn(S_con),
    "Hybrid neighbours" = predict_nn(S_hyb))
  
  table <- data.frame(
    Method = names(runs),
    RMSE = vapply(runs, function(r) sqrt(mean((r$pred - actual)^2)), numeric(1)),
    MAE = vapply(runs, function(r) mean(abs(r$pred - actual)), numeric(1)),
    Coverage = vapply(runs, function(r) r$covered, numeric(1)),
    stringsAsFactors = FALSE, row.names = NULL)
  list(table = table, n_obs = n_obs, n_test = n_test, n_train = n_obs - n_test,
       k = k, w = w, frac = frac, seed = seed)
}

# ============================================================
# UI HELPERS
# ============================================================
pct <- function(x) paste0(round(x * 100), "%")

page_head <- function(title, sub = NULL) {
  div(class = "page-head", tags$h2(title), if (!is.null(sub)) tags$p(sub))
}

note_box <- function(...) div(class = "note-box", ...)

empty_state <- function(msg, icon = NULL) {
  div(class = "empty", tags$span(class = "icon", ic("film", 34)), msg)
}

bar_row <- function(label, value01, right = NULL) {
  v <- max(0, min(1, value01))
  div(class = "mbar",
      div(class = "mbar-top", tags$span(label),
          tags$b(if (is.null(right)) pct(v) else right)),
      div(class = "bar", div(class = "fill", style = paste0("width:", round(v * 100), "%"))))
}

# ============================================================
# THE ONE reusable poster-based movie card.
# Every page that shows a movie calls this function. The poster comes
# only from get_poster_url() (central, loaded once). If no poster file
# or URL is available the card says so plainly (flat dark card, no
# gradient, no emoji, no invented image).
# ============================================================
poster_movie_card <- function(movie_id, score = NULL, reason = NULL,
                              badge = NULL, show_actions = TRUE, extra = NULL, compact = FALSE) {
  i <- which(movies$movie_id == movie_id)
  if (!length(i)) return(NULL)
  i <- i[1]
  row <- movies[i, ]
  
  url         <- get_poster_url(row$title)
  trailer     <- get_trailer_url(row$title)
  final_badge <- if (!is.null(badge)) badge else card_badge_for(row$title, row$year, row$rating)
  tagline     <- card_tagline_for(row$title)
  safe_title  <- htmltools::htmlEscape(row$title)
  
  if (compact) {
    return(div(
      class = "poster-wrap pc",
      div(
        class = if (nzchar(url)) "pc-img" else "pc-img poster-missing",
        onclick = sprintf("Shiny.setInputValue('details_click', %d, {priority:'event'})", movie_id),
        if (nzchar(url)) tags$img(
          src = url, alt = paste(row$title, "poster"), loading = "lazy",
          onerror = "this.style.display='none';this.parentNode.classList.add('poster-missing');"
        ),
        div(class = "pc-missing", span(safe_title), span("POSTER UNAVAILABLE")),
        if (!is.null(score)) div(class = "pc-score", pct(score))
      ),
      div(class = "pc-title", safe_title),
      div(class = "pc-year", row$year)
    ))
  }

  card <- div(
    class = "cinema-poster-card",
    div(
      class = "cinema-poster-image",
      if (nzchar(url)) tags$img(
        src = url,
        alt = paste(row$title, "poster"),
        loading = "lazy",
        onerror = "this.style.display='none';this.parentNode.classList.add('poster-missing');"
      ),
      div(class = if (!nzchar(url)) "poster-fallback-icon poster-missing-force" else "poster-fallback-icon",
          span(class = "pf-year", row$year),
          span(class = "pf-title", safe_title),
          span(class = "pf-badge", "POSTER UNAVAILABLE")),
      div(class = "poster-shade"),
      div(class = "poster-badge", final_badge),
      div(
        class = "poster-info",
        div(class = "poster-movie-title", safe_title),
        if (!is.null(tagline)) div(class = "poster-tagline", tagline),
        div(class = "poster-meta",
            paste0(row$year, "  -  ", pretty_genre(row$genre), "  -  ", format(row$rating, nsmall = 1))),
        if (!is.null(score))
          div(class = "bar", div(class = "fill", style = paste0("width:", round(score * 100), "%"))),
        if (!is.null(score))
          div(class = "poster-match", paste0("MATCH ", round(score * 100), "%")),
        if (!is.null(reason))
          div(class = "poster-reason", reason),
        tags$a(
          href = trailer, target = "_blank", rel = "noopener", class = "poster-trailer-btn",
          HTML("&#9654; WATCH TRAILER")
        ),
        if (show_actions) div(
          class = "poster-actions",
          div(class = "cardbtn heart", title = "Add to Favorites",
              onclick = sprintf("Shiny.setInputValue('fav_click', %d, {priority:'event'})", movie_id),
              "Favorite"),
          div(class = "cardbtn watch", title = "Add to Watchlist",
              onclick = sprintf("Shiny.setInputValue('watch_click', %d, {priority:'event'})", movie_id),
              "Watchlist"),
          div(class = "cardbtn", title = "View details",
              onclick = sprintf("Shiny.setInputValue('details_click', %d, {priority:'event'})", movie_id),
              "Details")
        )
      )
    )
  )
  div(class = "poster-wrap", card, extra)
}

# Backward-compatible aliases (same real card).
movie_card <- function(id, score = NULL, reason = NULL, extra = NULL) {
  poster_movie_card(id, score = score, reason = reason, extra = extra)
}
poster_card <- function(row, index) {
  mid <- movies$movie_id[match(tolower(row$title), tolower(movies$title))]
  if (is.na(mid)) return(NULL)
  poster_movie_card(mid)
}

# A responsive grid of real poster cards.
poster_grid <- function(ids, scores = NULL, reasons = NULL, badges = NULL, extras = NULL) {
  ids <- ids[!is.na(ids)]
  if (!length(ids)) return(empty_state("No movies to show here yet."))
  div(class = "poster-grid", lapply(seq_along(ids), function(k) {
    poster_movie_card(
      ids[k],
      score  = if (!is.null(scores)) scores[k] else NULL,
      reason = if (!is.null(reasons)) reasons[k] else NULL,
      badge  = if (!is.null(badges)) badges[k] else NULL,
      extra  = if (!is.null(extras)) extras[[k]] else NULL
    )
  }))
}

# Horizontal-scroll rail of real poster cards (dashboard / trending).
poster_rail <- function(heading, sub, ids, scores = NULL, reasons = NULL, compact = FALSE, more = NULL) {
  if (!length(ids)) return(NULL)
  div(
    class = "cinema-poster-section",
    div(class = "cinema-poster-heading",
        h3(HTML(heading)), span(class = "ph-sub", sub),
        if (!is.null(more)) span(class = "viewall", onclick = sprintf("mrNav('%s')", more),
                                 "View All", ic("arrow", 14))),
    div(class = if (compact) "poster-rail compact" else "poster-rail", lapply(seq_along(ids), function(k)
      poster_movie_card(ids[k],
                        score = if (!is.null(scores)) scores[k] else NULL,
                        reason = if (!is.null(reasons)) reasons[k] else NULL,
                        compact = compact)))
  )
}

# One recommendation result: poster + scores + explanation.
reco_row <- function(id, cs, ks, hs, seeds = integer(0), pref = NULL, rank = NULL) {
  r <- movies[movies$movie_id == id, ]
  div(
    class = "reco-row",
    div(class = "reco-poster", poster_movie_card(id, score = hs)),
    div(
      class = "reco-body",
      tags$h3(if (!is.null(rank)) paste0(rank, ". ") else "", toupper(r$title)),
      div(class = "reco-meta",
          paste0(r$year, "  -  ", pretty_genre(r$genre), "  -  Rating ", format(r$rating, nsmall = 1))),
      div(class = "reco-match", paste0("Recommendation Match: ", pct(hs))),
      bar_row("Content Similarity", cs),
      bar_row("Rating Pattern Match", ks),
      bar_row("Hybrid Score", hs),
      if (length(seeds)) div(class = "reco-why", tags$h4("Why recommended"), why_ui(id, seeds)),
      if (!is.null(pref)) div(class = "reco-pref", HTML("User preference match: "), tags$b(pref))
    )
  )
}

reco_rows <- function(df, seeds, taste = NULL) {
  if (is.null(df) || !nrow(df)) return(empty_state("No movies match these settings. Try relaxing the filters."))
  tagList(lapply(seq_len(nrow(df)), function(k) {
    reco_row(df$movie_id[k], df$Content_Score[k], df$Collaborative_Score[k], df$Hybrid_Score[k],
             seeds = seeds,
             pref = preference_match(df$movie_id[k], taste),
             rank = df$Rank[k])
  }))
}

# Dark styling for base-R charts.
dark_par <- function(mar = c(5, 4.5, 3.5, 1)) {
  graphics::par(bg = "transparent", fg = "#cbd0d9", col.axis = "#cbd0d9", col.lab = "#cbd0d9",
                col.main = "#ff5c8a", mar = mar)
}
gold <- "#ff5c8a"
indigo <- "#8b5cf6"


# ------------------------- SVG ICON SET ---------------------
# Clean line icons used everywhere instead of emojis.
mr_icon_paths <- list(
  home    = '<path d="M3 11.5 12 4l9 7.5"/><path d="M5.5 10v10h13V10"/><path d="M10 20v-5.5h4V20"/>',
  clapper = '<rect x="3" y="9" width="18" height="12" rx="2"/><path d="M3 9l3-5h4L7 9M10 9l3-5h4l-3 5M17 9l3-5"/>',
  foryou  = '<circle cx="10" cy="8" r="3.5"/><path d="M3.5 20c.5-4 3-6 6.5-6s6 2 6.5 6"/><path d="M19 3v4M17 5h4"/>',
  trend   = '<path d="M5 20v-8M11 20V5M17 20v-5M3 20h18"/>',
  spark   = '<path d="M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8z"/><path d="M19 16v4M17 18h4"/>',
  gem     = '<path d="M6 4h12l4 5-10 11L2 9z"/><path d="M2 9h20M9 4 7 9l5 11 5-11-2-5"/>',
  gift    = '<rect x="3" y="8" width="18" height="4" rx="1"/><path d="M5 12v9h14v-9M12 8v13"/><path d="M12 8c-1-3-5-4-5-1.5C7 8 12 8 12 8zm0 0c1-3 5-4 5-1.5C17 8 12 8 12 8z"/>',
  smile   = '<circle cx="12" cy="12" r="9"/><path d="M8.5 14c1 1.8 6 1.8 7 0"/><path d="M9 9.5h.01M15 9.5h.01"/>',
  sad     = '<circle cx="12" cy="12" r="9"/><path d="M8.5 16c1-1.8 6-1.8 7 0"/><path d="M9 9.5h.01M15 9.5h.01"/>',
  neutral = '<circle cx="12" cy="12" r="9"/><path d="M9 15h6"/><path d="M9 9.5h.01M15 9.5h.01"/>',
  reel    = '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="2"/><circle cx="12" cy="6.5" r="1.4"/><circle cx="12" cy="17.5" r="1.4"/><circle cx="6.5" cy="12" r="1.4"/><circle cx="17.5" cy="12" r="1.4"/>',
  sliders = '<path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12M20 18h0"/><circle cx="16" cy="6" r="2"/><circle cx="10" cy="12" r="2"/><circle cx="18" cy="18" r="2"/>',
  compass = '<circle cx="12" cy="12" r="9"/><path d="m15.5 8.5-2 5-5 2 2-5z"/>',
  scale   = '<path d="M12 4v16M6 20h12M5 7h14"/><path d="M5 7 2.5 13a3 3 0 0 0 5 0zM19 7l-2.5 6a3 3 0 0 0 5 0z"/>',
  heart   = '<path d="M12 21s-8-5.2-8-11a4.5 4.5 0 0 1 8-2.8A4.5 4.5 0 0 1 20 10c0 5.8-8 11-8 11z"/>',
  trophy  = '<path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0zM17 5h3v2a3 3 0 0 1-3 3M7 5H4v2a3 3 0 0 0 3 3"/>',
  crown   = '<path d="M3 8l4 4 5-7 5 7 4-4-2 11H5z"/>',
  list    = '<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>',
  flask   = '<path d="M9 3h6M10 3v6L4 19a2 2 0 0 0 2 3h12a2 2 0 0 0 2-3l-6-10V3"/>',
  bulb    = '<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5c.8.8 1 1.5 1 2.5h6c0-1 .2-1.7 1-2.5A6 6 0 0 0 12 3z"/>',
  cpu     = '<rect x="6" y="6" width="12" height="12" rx="2"/><path d="M9 2v4M15 2v4M9 18v4M15 18v4M2 9h4M2 15h4M18 9h4M18 15h4"/>',
  chart   = '<path d="M3 3v18h18M7 15l4-5 4 3 5-7"/>',
  chat    = '<path d="M21 12a8 8 0 0 1-11.8 7L3 21l2-5.5A8 8 0 1 1 21 12z"/>',
  info    = '<circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 8h.01"/>',
  bot     = '<rect x="4" y="8" width="16" height="11" rx="3"/><path d="M12 8V4.5M9 13h.01M15 13h.01M9.5 16.5h5"/><circle cx="12" cy="3.5" r="1"/>',
  star    = '<path d="m12 3 2.7 5.6 6.1.9-4.4 4.3 1 6.1L12 17l-5.4 2.9 1-6.1L3.2 9.5l6.1-.9z"/>',
  flame   = '<path d="M12 21c4 0 7-2.8 7-7 0-3.2-2-5.2-3.5-7-.4 1.7-1.3 2.6-2.5 3 .3-3-1-6-3.5-8-.2 3.6-3.5 5.2-4.5 8.2C4 12 5 14 5 14c0 4 3 7 7 7z"/>',
  search  = '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>',
  play    = '<path d="M7 4.5v15l12-7.5z"/>',
  user    = '<circle cx="12" cy="8" r="4"/><path d="M4 21c.7-4.5 4-7 8-7s7.3 2.5 8 7"/>',
  bolt    = '<path d="M13 2 4 14h7l-1 8 9-12h-7z"/>',
  rocket  = '<path d="M5 15c-1.5 1.5-2 4-2 6 2 0 4.5-.5 6-2"/><path d="M12 15 9 12c1-5 5-9 12-9 0 7-4 11-9 12z"/><circle cx="15.5" cy="8.5" r="1.4"/>',
  drop    = '<path d="M12 3s6 6.2 6 11a6 6 0 0 1-12 0c0-4.8 6-11 6-11z"/>',
  eye     = '<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
  film    = '<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 4v16M17 4v16M3 9h4M3 15h4M17 9h4M17 15h4"/>',
  logout  = '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>',
  chevron = '<path d="m9 6 6 6-6 6"/>',
  arrow   = '<path d="M5 12h14M13 6l6 6-6 6"/>',
  calendar = '<rect x="3" y="5" width="18" height="16" rx="2.5"/><path d="M8 3v4M16 3v4M3 10h18"/>',
  layers   = '<path d="m12 3 9 5-9 5-9-5z"/><path d="m3 13 9 5 9-5"/>',
  bookmark = '<path d="M6 3h12v18l-6-4-6 4z"/>',
  mouse    = '<rect x="7" y="2.5" width="10" height="19" rx="5"/><path d="M12 7v4"/>'
)
ic <- function(name, size = 18) {
  p <- mr_icon_paths[[name]]
  if (is.null(p)) p <- mr_icon_paths[["film"]]
  HTML(sprintf(paste0('<svg class="mr-ic" xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" ',
                      'viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" ',
                      'stroke-linecap="round" stroke-linejoin="round">%s</svg>'),
               as.integer(size), as.integer(size), p))
}

# ------------------------- LOGO BANNER ----------------------
# Film ribbons + clapperboard + metallic MOVIE / red REC wordmark,
# drawn entirely with SVG/CSS (no image file needed).
brand_banner <- function() {
  bg_svg <- paste0(
    '<svg class="bb-art" viewBox="0 0 262 168" preserveAspectRatio="xMidYMid slice" xmlns="http://www.w3.org/2000/svg">',
    '<defs>',
    '<linearGradient id="bbg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#1a0408"/><stop offset=".55" stop-color="#0a0b14"/><stop offset="1" stop-color="#2a050c"/></linearGradient>',
    '<linearGradient id="bbr" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#5c0614"/><stop offset=".5" stop-color="#ff2d4a"/><stop offset="1" stop-color="#7a0a1b"/></linearGradient>',
    '<radialGradient id="bbo" cx=".78" cy=".2" r=".6"><stop offset="0" stop-color="#ff3b57" stop-opacity=".55"/><stop offset="1" stop-color="#ff3b57" stop-opacity="0"/></radialGradient>',
    '</defs>',
    '<rect width="262" height="168" fill="url(#bbg)"/><rect width="262" height="168" fill="url(#bbo)"/>',
    '<path d="M-10 40 C60 -10 140 70 270 20" fill="none" stroke="#12060a" stroke-width="26"/>',
    '<path d="M-10 40 C60 -10 140 70 270 20" fill="none" stroke="url(#bbr)" stroke-width="22" opacity=".85"/>',
    '<path d="M-10 40 C60 -10 140 70 270 20" fill="none" stroke="#0a0b14" stroke-width="22" stroke-dasharray="5 8" opacity=".75"/>',
    '<path d="M-20 150 C50 100 150 175 280 110" fill="none" stroke="#12060a" stroke-width="20"/>',
    '<path d="M-20 150 C50 100 150 175 280 110" fill="none" stroke="url(#bbr)" stroke-width="16" opacity=".55"/>',
    '<path d="M-20 150 C50 100 150 175 280 110" fill="none" stroke="#0a0b14" stroke-width="16" stroke-dasharray="4 7" opacity=".7"/>',
    '<g transform="translate(168 6) rotate(-14)"><rect x="0" y="16" width="74" height="42" rx="4" fill="#0d0f18" stroke="#3a3f52" stroke-width="1.5"/>',
    '<path d="M0 16 L12 0 L26 0 L14 16Z M22 16 L34 0 L48 0 L36 16Z M44 16 L56 0 L70 0 L58 16Z" fill="#e8ecf5"/>',
    '<path d="M12 16 L24 0 L26 0 L14 16Z M34 16 L46 0 L48 0 L36 16Z M56 16 L68 0 L70 0 L58 16Z" fill="#ff2d4a"/>',
    '<path d="M8 32h58M8 40h40M8 48h50" stroke="#3a3f52" stroke-width="2"/></g>',
    '</svg>')
  reel <- paste0(
    '<svg class="bb-reel" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">',
    '<defs><linearGradient id="bbs" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffffff"/><stop offset=".55" stop-color="#9aa3b2"/><stop offset="1" stop-color="#e9edf5"/></linearGradient></defs>',
    '<circle cx="24" cy="24" r="21" fill="url(#bbs)"/><circle cx="24" cy="24" r="17" fill="#10131c"/>',
    '<circle cx="24" cy="24" r="4.5" fill="url(#bbs)"/>',
    '<circle cx="24" cy="11.5" r="4.6" fill="url(#bbs)"/><circle cx="24" cy="36.5" r="4.6" fill="url(#bbs)"/>',
    '<circle cx="11.5" cy="24" r="4.6" fill="url(#bbs)"/><circle cx="36.5" cy="24" r="4.6" fill="url(#bbs)"/>',
    '<path d="M30 40c4 3 9 2 12-2" fill="none" stroke="#ff2d4a" stroke-width="2.4" stroke-linecap="round"/>',
    '</svg>')
  div(class = "brandbanner",
      HTML(bg_svg),
      div(class = "bb-ember e1"), div(class = "bb-ember e2"), div(class = "bb-ember e3"),
      div(class = "bb-word",
          span(class = "bb-m", "M"), HTML(reel), span(class = "bb-vie", "VIE"), span(class = "bb-rec", "REC")),
      div(class = "bb-sub", "KOLLYWOOD MOVIE INTELLIGENCE"),
      div(class = "bb-line"))
}

# ------------------------- SIDEBAR --------------------------
nav_item <- function(page, label, icon = "film") {
  div(class = paste("navitem", if (page == "Dashboard") "active nav-dash" else ""),
      `data-page` = page,
      onclick = sprintf("mrNav('%s')", page),
      span(class = "ni-ico", ic(icon, if (page == "Dashboard") 24 else 20)),
      if (page == "Dashboard") span(class = "ni-sep"),
      span(class = "ni-label", label),
      span(class = "ni-chev", ic("chevron", 16)))
}
nav_section <- function(title, ...) {
  tagList(div(class = "nav-sec", span(title), span(class = "nav-sec-line")), ...)
}

sidebar_nav <- function() {
  tagList(
    nav_item("Dashboard", "Dashboard", "home"),
    nav_section("DISCOVER",
                nav_item("Recommendations", "Recommendations", "clapper"),
                nav_item("ForYou", "Personalized For You", "foryou"),
                nav_item("Trending", "Trending Movies", "trend"),
                nav_item("NewReleases", "New Releases", "spark"),
                nav_item("Gems", "Hidden Gems", "gem"),
                nav_item("Surprise", "Surprise Me", "gift")),
    nav_section("MOOD & TASTE",
                nav_item("Mood", "Mood Recommendation", "smile"),
                nav_item("Genres", "Genre Explorer", "reel"),
                nav_item("Prefs", "My Preferences", "sliders")),
    nav_section("EXPLORE",
                nav_item("Explorer", "Movie Explorer", "compass"),
                nav_item("Compare", "Compare Movies", "scale"),
                nav_item("MyMovies", "My Movies", "heart")),
    nav_section("RANKINGS",
                nav_item("TopRated", "Top Rated", "star"),
                nav_item("Popular", "Popular Movies", "crown"),
                nav_item("Fans", "Fan Favorites", "heart"),
                nav_item("Leaderboard", "Leaderboard", "trophy")),
    nav_section("RECOMMENDATION LAB",
                nav_item("Lab", "Hybrid Model", "flask"),
                nav_item("Explain", "Explain Recommendation", "bulb"),
                nav_item("Model", "Model Analysis", "cpu"),
                nav_item("AnReco", "Recommendation Analytics", "chart")),
    nav_section("SYSTEM",
                nav_item("Feedback", "Feedback", "chat"),
                nav_item("About", "About", "info"))
  )
}

mr_js <- r"---(
function mrSetActive(p){
  document.querySelectorAll('.toptab').forEach(function(e){
    e.classList.toggle('active', e.getAttribute('data-page') === p);
  });
  document.querySelectorAll('.navitem').forEach(function(e){
    e.classList.toggle('active', e.getAttribute('data-page') === p);
  });
}
function mrNav(p){
  mrSetActive(p);
  Shiny.setInputValue('nav', p, {priority: 'event'});
  window.scrollTo(0, 0);
}

function mrAcct(e){
  if (e) { e.stopPropagation(); }
  var a = document.getElementById('acct');
  if (a) { a.classList.toggle('open'); }
}
function mrAcctClose(){
  var a = document.getElementById('acct');
  if (a) { a.classList.remove('open'); }
}
document.addEventListener('click', function(e){
  var a = document.getElementById('acct');
  if (a && !a.contains(e.target)) { a.classList.remove('open'); }
});

/* ---------- cursor effect: soft glow that follows the mouse + card spotlight + parallax ---------- */
(function(){
  if (window.__mrFx) { return; }
  window.__mrFx = true;
  var fine = window.matchMedia && window.matchMedia('(pointer: fine)').matches;
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var root = document.documentElement;
  var SPOT = '.card,.ftile,.reco-row,.fb2-form,.fb-board,.fb-item,.mood-card,.cinema-poster-card,.pc-img';
  function init(){
    if (!fine || reduce) { return; }
    var glow = document.createElement('div'); glow.className = 'mr-fx-glow';
    document.body.appendChild(glow);
    var mx = window.innerWidth / 2, my = window.innerHeight / 2, gx = mx, gy = my;
    document.addEventListener('mousemove', function(e){
      mx = e.clientX; my = e.clientY;
      root.style.setProperty('--px', ((mx / window.innerWidth) - 0.5) * 2);
      root.style.setProperty('--py', ((my / window.innerHeight) - 0.5) * 2);
      var t = e.target.closest ? e.target.closest(SPOT) : null;
      if (t) {
        var r = t.getBoundingClientRect();
        t.style.setProperty('--mx', (e.clientX - r.left) + 'px');
        t.style.setProperty('--my', (e.clientY - r.top) + 'px');
      }
      glow.style.opacity = 1;
    }, {passive: true});
    document.documentElement.addEventListener('mouseleave', function(){ glow.style.opacity = 0; });
    (function loop(){
      gx += (mx - gx) * 0.08; gy += (my - gy) * 0.08;
      glow.style.transform = 'translate(' + gx + 'px,' + gy + 'px)';
      window.requestAnimationFrame(loop);
    })();
  }
  if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', init); } else { init(); }
})();
function mrBg(n){
  var c = document.querySelector('.cinema');
  if (!c) { return; }
  ['crimson', 'nebula', 'aurora', 'sunset', 'midnight'].forEach(function(x){ c.classList.remove('bg-' + x); });
  c.classList.add('bg-' + n);
  document.querySelectorAll('.bgdot').forEach(function(e){ e.classList.toggle('on', e.classList.contains(n)); });
  try { localStorage.setItem('mr_bg', n); } catch (e) {}
}
function mrStar(n){
  document.querySelectorAll('.fb-star').forEach(function(e){
    e.classList.toggle('on', parseInt(e.getAttribute('data-v'), 10) <= n);
  });
  var labels = ['', 'Poor', 'Fair', 'Good', 'Very good', 'Excellent'];
  var h = document.getElementById('fb_star_hint');
  if (h) { h.textContent = n + ' / 5 - ' + labels[n]; }
  Shiny.setInputValue('fb_stars', n, {priority: 'event'});
}
function mrReact(v){
  document.querySelectorAll('.fb-react').forEach(function(e){
    e.classList.toggle('on', e.getAttribute('data-v') === v);
  });
  Shiny.setInputValue('fb_react', v, {priority: 'event'});
}
function mrTag(el){
  el.classList.toggle('on');
  var arr = [];
  document.querySelectorAll('.fb-tags:not(.fb-tags-static) .fb-tag.on').forEach(function(e){ arr.push(e.textContent); });
  Shiny.setInputValue('fb_tags', arr.length ? arr : '', {priority: 'event'});
}
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('mr_fb_reset', function(x) {
    document.querySelectorAll('.fb-star.on, .fb-react.on, .fb-tags:not(.fb-tags-static) .fb-tag.on').forEach(function(e){ e.classList.remove('on'); });
    var h = document.getElementById('fb_star_hint'); if (h) { h.textContent = 'Select a rating'; }
    Shiny.setInputValue('fb_stars', null); Shiny.setInputValue('fb_react', null); Shiny.setInputValue('fb_tags', '');
  });
  Shiny.addCustomMessageHandler('mr_active', function(p) { mrSetActive(p); window.scrollTo(0, 0); });
  Shiny.addCustomMessageHandler('mr_theme', function(cls) {
    window.__mrTheme = cls;
    var c = document.querySelector('.cinema');
    if (c) { c.className = 'cinema ' + cls; }
  });
});
)---"
section_head <- function(txt) {
  div(class = "section-head", h3(txt), div(class = "line"))
}

# ------------------------- CINEMA CSS ------------------------

cinema_css <- "
*{box-sizing:border-box}
body{margin:0;background:#05070d;color:#f4f4f5;font-family:Arial,sans-serif}
.cinema{min-height:100vh;position:relative;background:#05070d}
.cine-bg{position:fixed;inset:0;z-index:0;overflow:hidden;pointer-events:none}
.cine-wall{position:absolute;inset:-12% -8%;display:grid;grid-template-columns:repeat(11,1fr);
gap:3px;transform:scale(1.06) rotate(-2deg);filter:blur(1.6px) saturate(1.08) brightness(.8)}
.cine-tile{aspect-ratio:2/3;background-size:cover;background-position:center top;background-color:#0e1420}
.cine-shade{position:absolute;inset:0;background:
radial-gradient(circle at 80% 6%,rgba(var(--acc2-rgb),.12),transparent 28%),
radial-gradient(circle at 86% 76%,rgba(99,102,241,.16),transparent 34%),
linear-gradient(180deg,rgba(5,7,13,.90) 0%,rgba(5,7,13,.88) 35%,rgba(5,7,13,.95) 75%,rgba(5,7,13,.99) 100%),
linear-gradient(90deg,rgba(5,7,13,.7) 0%,rgba(5,7,13,.28) 42%,rgba(5,7,13,.7) 100%)}
.cine-orb{position:absolute;border-radius:50%;filter:blur(130px)}
.cine-orb.co1{width:480px;height:480px;left:-140px;top:-120px;background:var(--acc2);opacity:.15;
animation:cine-float 26s ease-in-out infinite}
.cine-orb.co2{width:540px;height:540px;right:-160px;bottom:-180px;background:#6366f1;opacity:.20;
animation:cine-float 32s ease-in-out infinite reverse}
.cine-grain{position:absolute;inset:0;opacity:.05;mix-blend-mode:overlay;
background-image:url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'><filter id='g'><feTurbulence type='fractalNoise' baseFrequency='.85' numOctaves='2' stitchTiles='stitch'/></filter><rect width='100%25' height='100%25' filter='url(%23g)'/></svg>\")}
@keyframes cine-float{0%,100%{transform:translate(0,0)}50%{transform:translate(24px,-18px)}}
@media(prefers-reduced-motion:reduce){.cine-orb{animation:none!important}}
.sidebar{position:fixed;left:0;top:0;bottom:0;width:245px;z-index:10;padding:25px 17px;
background:rgba(5,8,14,.95);border-right:1px solid rgba(255,255,255,.09);
box-shadow:10px 0 35px rgba(0,0,0,.3);overflow-y:auto}
.brand{padding:5px 12px 22px;border-bottom:1px solid #242a35;margin-bottom:18px}
.brand b{font-size:25px;color:var(--acc)}.brand small{display:block;color:#737b8a;margin-top:5px;
font-size:9px;letter-spacing:1px}
.sidebtn{width:100%;text-align:left;background:transparent!important;color:#aeb6c4!important;
border:0!important;padding:11px 13px!important;margin:3px 0;border-radius:9px!important;
font-weight:600;font-size:12px!important;transition:.18s}
.sidebtn:hover{background:rgba(var(--acc-rgb),.1)!important;color:var(--acc)!important;
transform:translateX(3px)}
.logout{margin-top:18px!important;color:#f87171!important}
.main{position:relative;z-index:1;margin-left:245px;padding:24px 32px 50px;min-height:100vh}
.top{display:flex;justify-content:space-between;align-items:center;margin-bottom:22px}
.top h3{margin:0;font-size:23px}.muted{color:#7e8795}.welcome{font-size:12px;text-align:right}
.welcome b{color:#fff}
.hero{min-height:470px;padding:32px 48px;border-radius:22px;overflow:hidden;position:relative;
border:1px solid rgba(var(--acc-rgb),.14);box-shadow:0 25px 65px rgba(0,0,0,.5),inset 0 1px 0 rgba(255,255,255,.05);
background:linear-gradient(90deg,rgba(3,5,10,.98),rgba(3,5,10,.8),rgba(3,5,10,.22)),
linear-gradient(135deg,#0d1420,#1b1410 60%,#0a0d16)}
.hero:before{content:'';position:absolute;inset:0;pointer-events:none;z-index:1;
background:radial-gradient(560px circle at 80% 42%,rgba(var(--acc-rgb),.22),transparent 62%);
mix-blend-mode:screen;animation:hero-pulse 6s ease-in-out infinite}
.hero:after{content:'';position:absolute;right:-6%;top:-18%;width:60%;height:140%;pointer-events:none;
background:radial-gradient(ellipse at center,rgba(99,102,241,.22),transparent 65%);z-index:1}
@keyframes hero-pulse{0%,100%{opacity:.75}50%{opacity:1}}

.hero-content{position:relative;z-index:3;display:flex;align-items:center;justify-content:space-between;gap:35px;min-height:430px}
.hero-copy{flex:1;min-width:0;position:relative;z-index:4}
.hero-copy h1{font-size:43px;max-width:650px;line-height:1.05;margin:12px 0}
.hero-copy p{max-width:610px;color:#b8bec9;line-height:1.7;font-size:14px}
.leo-showcase{width:285px;flex:0 0 285px;position:relative;z-index:4}
.leo-showcase:before{content:'';position:absolute;inset:-40px;border-radius:50%;z-index:0;
background:radial-gradient(circle,rgba(var(--acc-rgb),.30),transparent 70%);filter:blur(30px);
animation:leo-glow 4.5s ease-in-out infinite}
@keyframes leo-glow{0%,100%{opacity:.6;transform:scale(.94)}50%{opacity:1;transform:scale(1.04)}}
.leo-poster-frame{position:relative;width:285px;height:405px;border-radius:18px;overflow:hidden;
border:1px solid rgba(255,255,255,.18);box-shadow:0 25px 60px rgba(0,0,0,.75),0 0 45px rgba(var(--acc-rgb),.16);
transform:rotate(2deg);transition:transform .45s ease,box-shadow .45s ease}
.leo-poster-frame:hover{transform:rotate(0deg) translateY(-8px) scale(1.025);
box-shadow:0 35px 80px rgba(0,0,0,.85),0 0 55px rgba(var(--acc-rgb),.24)}
.leo-poster{width:100%;height:100%;object-fit:cover;display:block}
.leo-poster-frame:after{content:'';position:absolute;inset:0;
background:linear-gradient(180deg,rgba(0,0,0,.02) 42%,rgba(0,0,0,.25) 58%,rgba(0,0,0,.92) 100%);
pointer-events:none}
.leo-poster-info{position:absolute;left:20px;right:20px;bottom:20px;z-index:3}
.leo-title{font-size:39px;line-height:1;font-weight:900;letter-spacing:6px;color:#fff;text-shadow:0 3px 18px #000}
.leo-tagline{margin-top:7px;color:var(--acc);font-size:11px;font-weight:800;letter-spacing:2px}
.leo-meta{margin-top:7px;color:#e5e7eb;font-size:11px}
.trailer-btn{display:inline-flex;align-items:center;justify-content:center;gap:7px;margin-top:13px;
padding:9px 14px;border-radius:8px;text-decoration:none!important;font-size:11px;font-weight:800;
background:rgba(var(--acc-rgb),.96);color:#111827!important;box-shadow:0 8px 22px rgba(0,0,0,.35);
transition:transform .2s ease,filter .2s ease}
.trailer-btn:hover{transform:translateY(-2px);filter:brightness(1.08)}
@media(max-width:900px){.hero-content{flex-direction:column;align-items:flex-start}.leo-showcase{align-self:center}}
@media(max-width:550px){.leo-showcase{width:220px;flex-basis:220px}.leo-poster-frame{width:220px;height:315px}
.leo-title{font-size:30px}.hero-content{min-height:auto}}

.kicker{color:var(--acc);font-size:11px;font-weight:bold;letter-spacing:2px}
.hero h1{font-size:43px;max-width:650px;line-height:1.05;margin:12px 0}
.hero p{max-width:610px;color:#b8bec9;line-height:1.7;font-size:14px}
.gold{background:linear-gradient(135deg,var(--acc),var(--acc2))!important;color:#111827!important;
border:0!important;font-weight:800!important;border-radius:9px!important;padding:12px 21px!important;
transition:.2s}
.card{background:rgba(12,18,28,.91);border:1px solid #252c38;border-radius:15px;padding:20px;
margin-bottom:19px;box-shadow:0 12px 35px rgba(0,0,0,.25)}
.card h2,.card h3{margin-top:0}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:13px;margin:19px 0}
.stat{background:#111827;border:1px solid #252c38;border-radius:13px;padding:19px}
.stat b{display:block;color:var(--acc);font-size:29px}.stat span{color:#7f8897;font-size:10px}
.mini{background:#111827;border:1px solid #242b37;border-radius:10px;padding:14px;margin:9px 0}
.mini b{color:#fff}.mini em{float:right;color:var(--acc);font-style:normal;font-weight:bold}
.mini small{display:block;color:#7e8795;margin-top:5px}
.form-control,.selectize-input{background:#111827!important;color:#fff!important;
border:1px solid #374151!important}
.selectize-dropdown{background:#111827!important;color:#fff!important}
.shiny-input-container label{color:#cbd0d9!important;font-size:11px}
.explain{background:linear-gradient(135deg,#172131,#0e1520);border-left:4px solid var(--acc);
padding:19px;border-radius:10px}
.bar{height:8px;background:#273244;border-radius:9px;overflow:hidden;margin:5px 0 13px}
.fill{height:100%;background:linear-gradient(90deg,#4f46e5,var(--acc))}
.nav-tabs{display:none!important}.tab-content{border:0!important}
table{width:100%!important;background:#111827!important;color:#eee!important}
th{background:#27204d!important;color:var(--acc)!important;border:0!important}
td{background:#111827!important;color:#eee!important;border-color:#263041!important}
@media(max-width:900px){.sidebar{position:relative;width:100%;height:auto}.main{margin-left:0}
.stats{grid-template-columns:repeat(2,1fr)}}
@media(max-width:550px){.main{padding:18px}.hero{padding:28px}.hero h1{font-size:31px}
.stats{grid-template-columns:1fr}}
.stats{grid-template-columns:repeat(auto-fit,minmax(130px,1fr))}
.section-head{margin:26px 0 14px}
.section-head h3{margin:0 0 6px;font-size:17px}
.section-head .line{height:2px;width:52px;background:linear-gradient(90deg,var(--acc),transparent)}
.grid-cards{display:grid;grid-template-columns:repeat(auto-fill,minmax(190px,1fr));gap:16px;margin-top:10px}
.mcard{background:rgba(15,20,30,.9);border:1px solid #262d3a;border-radius:16px;overflow:hidden;
transition:transform .25s ease,box-shadow .25s ease;animation:fadeUp .45s ease both}
.mcard:hover{transform:translateY(-6px) scale(1.02);box-shadow:0 18px 40px rgba(0,0,0,.5);border-color:var(--acc)}
.mcard .poster{height:96px;display:flex;align-items:center;justify-content:center;font-size:32px;
background:linear-gradient(135deg,var(--c1,#4f46e5),var(--c2,var(--acc)));position:relative}
.mcard .poster:after{content:'';position:absolute;inset:0;
background:linear-gradient(180deg,transparent 45%,rgba(0,0,0,.55))}

.cinema-poster-section{padding:2px 0 6px}
.cinema-poster-heading{display:flex;align-items:end;justify-content:space-between;margin-bottom:14px}
.cinema-poster-heading h3{margin:0;color:#fff;font-size:18px;letter-spacing:.2px}
.cinema-poster-heading span{font-size:10px;color:#8f98a8;letter-spacing:1.4px;text-transform:uppercase}
.cinema-poster-rail{display:grid;grid-template-columns:repeat(7,minmax(145px,1fr));gap:13px;overflow-x:auto;padding:4px 2px 14px}
.cinema-poster-card{min-width:145px;border-radius:15px;overflow:hidden;background:#0c111b;border:1px solid #252e3c;
box-shadow:0 12px 30px rgba(0,0,0,.42);transition:transform .28s ease,box-shadow .28s ease,border-color .28s ease}
.cinema-poster-card:hover{transform:translateY(-8px) scale(1.025);border-color:var(--acc);
box-shadow:0 22px 48px rgba(0,0,0,.65),0 0 24px rgba(var(--acc-rgb),.12)}
.cinema-poster-image{height:320px;position:relative;overflow:hidden;background:linear-gradient(145deg,#20283a,#090c13)}
.cinema-poster-image img{width:100%;height:100%;display:block;object-fit:cover;transition:transform .5s ease}
.cinema-poster-card:hover .cinema-poster-image img{transform:scale(1.07)}
.poster-shade{position:absolute;inset:0;background:linear-gradient(180deg,rgba(0,0,0,.04) 30%,rgba(0,0,0,.15) 48%,rgba(0,0,0,.92) 100%);pointer-events:none}
.poster-fallback-icon{display:none;position:absolute;inset:0;flex-direction:column;justify-content:flex-end;
gap:5px;padding:16px;background:linear-gradient(155deg,var(--c1,#4f46e5),var(--c2,var(--acc)))}
.poster-fallback-icon .pf-year{font-size:10px;letter-spacing:.2em;color:rgba(255,255,255,.85)}
.poster-fallback-icon .pf-title{font-family:'Bebas Neue',Impact,'Arial Narrow',sans-serif;
font-size:clamp(20px,2.6vw,30px);line-height:1.05;letter-spacing:.02em;color:#fff;
text-shadow:0 2px 10px rgba(0,0,0,.4)}
.poster-fallback-icon .pf-badge{font-size:9.5px;letter-spacing:.16em;color:#141821;font-weight:900;
background:rgba(255,255,255,.85);padding:3px 8px;border-radius:5px;align-self:flex-start}
.poster-missing .poster-fallback-icon{display:flex}
.poster-missing img{display:none!important}
.poster-badge{position:absolute;left:9px;top:9px;padding:5px 7px;border-radius:5px;background:rgba(var(--acc-rgb),.96);
color:#111827;font-size:7.5px;font-weight:900;letter-spacing:1px}
.poster-info{position:absolute;left:11px;right:11px;bottom:10px;z-index:2}
.poster-movie-title{font-size:17px;font-weight:950;letter-spacing:.5px;color:#fff;line-height:1.05;text-shadow:0 2px 12px #000}
.poster-tagline{font-size:7.5px;color:var(--acc);font-weight:900;letter-spacing:1.2px;margin-top:5px}
.poster-meta{font-size:7.5px;color:#e5e7eb;margin-top:5px;line-height:1.35}
.poster-trailer-btn{display:inline-flex;margin-top:8px;padding:6px 8px;border-radius:6px;background:var(--acc);color:#111827!important;
font-size:7.5px;font-weight:900;text-decoration:none!important;letter-spacing:.2px;transition:filter .2s ease,transform .2s ease}
.poster-trailer-btn:hover{filter:brightness(1.08);transform:translateY(-1px)}
.poster-match{font-size:9.5px;color:var(--acc);font-weight:800;margin-top:4px}
.poster-reason{font-size:7.5px;color:#c9cedb;margin-top:2px;line-height:1.3}
.poster-actions{display:flex;gap:5px;margin-top:8px}
.poster-actions .cardbtn{flex:1;font-size:9px;padding:5px 0;background:rgba(10,14,22,.75);
border:1px solid rgba(255,255,255,.14);color:#e5e7eb}
.poster-actions .cardbtn:hover{background:rgba(var(--acc-rgb),.16);border-color:var(--acc);color:var(--acc)}
.poster-fallback-icon.poster-missing-force{display:flex}
@media(max-width:1250px){.cinema-poster-rail{grid-template-columns:repeat(4,minmax(175px,1fr))}}
@media(max-width:850px){.cinema-poster-rail{grid-template-columns:repeat(2,minmax(180px,1fr));overflow-x:visible}.cinema-poster-image{height:350px}}
@media(max-width:520px){.cinema-poster-rail{grid-template-columns:1fr}.cinema-poster-card{max-width:320px;margin:auto}.cinema-poster-image{height:430px}}

.mcard .cbody{padding:12px}
.mcard h4{margin:0 0 5px;font-size:12.5px;color:#fff;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.mcard .meta{font-size:9.5px;color:#8b93a3;margin-bottom:8px}
.mcard .actions{display:flex;gap:6px;padding:0 12px 12px}
.cardbtn{flex:1;text-align:center;padding:6px 0;border-radius:8px;font-size:12px;cursor:pointer;
background:#1b2331;border:1px solid #2b3240;transition:.18s;color:#cbd0d9}
.cardbtn:hover{background:#242e40;color:#fff}
.cardbtn.heart:hover{color:#f87171;border-color:#f87171}
.cardbtn.watch:hover{color:#60a5fa;border-color:#60a5fa}
.empty{text-align:center;padding:34px 15px;color:#7e8795;font-size:12px}
.empty .icon{font-size:36px;display:block;margin-bottom:10px}
.chip{display:inline-block;padding:8px 14px;margin:4px 6px 4px 0;border-radius:20px;background:#111827;
border:1px solid #2b3240;color:#cbd0d9;font-size:11.5px;cursor:pointer;transition:.18s}
.chip:hover{background:rgba(var(--acc-rgb),.13);color:var(--acc);border-color:var(--acc)}
.footer{margin-top:42px;padding:26px;text-align:center;border-top:1px solid #242a35;
color:#697184;font-size:11px;line-height:1.8}
.footer b{color:var(--acc)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.card{animation:fadeUp .45s ease both}
.gold:hover{box-shadow:0 0 22px rgba(var(--acc-rgb),.45);transform:translateY(-1px)}
.form-control:focus,.selectize-input.focus{box-shadow:0 0 0 3px rgba(var(--acc-rgb),.22)!important;
border-color:var(--acc)!important}
::-webkit-scrollbar{width:9px;height:9px}
::-webkit-scrollbar-track{background:#0a0e16}
::-webkit-scrollbar-thumb{background:#2b3240;border-radius:6px}
.modal-content{background:#0d1320!important;color:#eee!important;border:1px solid #2b3240!important;
border-radius:16px!important}
.modal-header,.modal-footer{border-color:#242b37!important}
@media(max-width:550px){.grid-cards{grid-template-columns:repeat(auto-fill,minmax(150px,1fr))}}

/* ================= TOP BAR ================= */
.topbar-search{position:relative;flex:1;max-width:420px;margin-right:18px}
.topbar-search .shiny-input-container{width:100%!important;margin:0!important}
.topbar-search input{width:100%!important;height:40px!important;padding:0 16px 0 40px!important;
border-radius:11px!important;border:1px solid #262d3a!important;background:#0e1420!important;
color:#eee!important;font-size:12.5px!important;box-shadow:none!important}
.topbar-search input:focus{border-color:var(--acc)!important;box-shadow:0 0 0 3px rgba(var(--acc-rgb),.15)!important}
.topbar-search .t-ico{position:absolute;left:13px;top:50%;transform:translateY(-50%);color:#6e7785;z-index:2}
.topbar-icons{display:flex;align-items:center;gap:14px;margin-right:16px}
.topbar-icons .t-btn{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;
justify-content:center;background:#111827;border:1px solid #262d3a;color:#aeb6c4;cursor:pointer}
.topbar-icons .t-btn:hover{color:var(--acc);border-color:var(--acc)}
.avatar-chip{display:flex;align-items:center;gap:10px}
.avatar-chip .av-circle{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;
justify-content:center;font-weight:800;font-size:13px;color:#141821;
background:linear-gradient(135deg,var(--acc),var(--acc2))}
.top{flex-wrap:wrap;gap:10px}

/* ================= SIDEBAR ICON NAV ================= */
.sidebtn-ico{display:flex!important;align-items:center;gap:12px;justify-content:flex-start!important}
.sidebtn-ico svg{flex:0 0 auto;opacity:.85}
.sidebtn.active-nav{background:linear-gradient(135deg,rgba(var(--acc-rgb),.16),rgba(var(--acc2-rgb),.08))!important;
color:var(--acc)!important;box-shadow:inset 0 0 0 1px rgba(var(--acc-rgb),.35)}
.sidebtn.active-nav svg{opacity:1}

/* ================= PLAYER HERO ================= */
.player-row{display:flex;gap:18px;align-items:flex-start;margin-bottom:19px}
.player-main{flex:1;min-width:0}
.player-aside{width:300px;flex:0 0 300px}
.player-hero{position:relative;border-radius:20px;overflow:hidden;height:400px;
box-shadow:0 22px 55px rgba(0,0,0,.5);border:1px solid #242b37}
.player-hero-fb{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;
text-align:center;padding:20px;font-family:'Bebas Neue',Impact,sans-serif;font-size:34px;color:#fff;
background:linear-gradient(160deg,var(--c1,#4f46e5),var(--c2,var(--acc)))}
.player-hero img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:center top}
.player-hero-shade{position:absolute;inset:0;background:
linear-gradient(0deg,rgba(3,5,10,.96) 0%,rgba(3,5,10,.55) 42%,rgba(3,5,10,.08) 70%),
linear-gradient(90deg,rgba(3,5,10,.55) 0%,transparent 45%)}
.player-badge{position:absolute;left:20px;top:20px;padding:6px 12px;border-radius:8px;
background:rgba(var(--acc-rgb),.95);color:#111827;font-size:10.5px;font-weight:900;letter-spacing:1px;z-index:2}
.player-controls{position:absolute;left:0;right:0;bottom:0;z-index:2;padding:18px 22px 20px}
.player-progress-track{height:5px;border-radius:5px;background:rgba(255,255,255,.22);margin-bottom:12px;
overflow:hidden;cursor:pointer}
.player-progress-fill{height:100%;background:linear-gradient(90deg,var(--acc),#ef4444);border-radius:5px}
.player-controls-row{display:flex;align-items:center;gap:14px;color:#f1f2f4}
.player-controls-row .pc-ico{width:30px;height:30px;border-radius:8px;display:flex;align-items:center;
justify-content:center;background:rgba(255,255,255,.08);cursor:pointer;flex:0 0 auto}
.player-controls-row .pc-ico:hover{background:rgba(var(--acc-rgb),.25);color:var(--acc)}
.player-controls-row .pc-label{font-size:11px;letter-spacing:.5px;color:#d7dbe3;flex:1}
.player-details{margin-top:16px}
.player-title-row{display:flex;align-items:flex-start;justify-content:space-between;gap:14px;flex-wrap:wrap}
.player-title-row h2{margin:0;font-size:24px;color:#fff;font-weight:900;letter-spacing:.3px}
.player-actions{display:flex;gap:18px}
.player-actions .pa-item{display:flex;align-items:center;gap:6px;font-size:11.5px;color:#aeb6c4;cursor:pointer}
.player-actions .pa-item:hover{color:var(--acc)}
.player-meta{display:flex;align-items:center;flex-wrap:wrap;gap:8px;margin-top:8px;font-size:11.5px;color:#9aa2b1}
.player-meta .pm-genre{padding:4px 10px;border-radius:7px;background:#111827;border:1px solid #262d3a}
.player-meta .pm-star{color:var(--acc);display:inline-flex;align-items:center;gap:4px}
.player-why{margin-top:12px;padding:13px 15px;border-radius:11px;background:rgba(var(--acc-rgb),.06);
border-left:3px solid var(--acc);font-size:12px;color:#c7cbd4;line-height:1.6}

/* ================= MAYBE YOU LIKE ================= */
.maybe-rail{display:grid;grid-template-columns:repeat(auto-fill,minmax(165px,1fr));gap:14px;margin-top:10px}
.maybe-card{position:relative;border-radius:14px;overflow:hidden;height:230px;cursor:default;
box-shadow:0 12px 28px rgba(0,0,0,.4);transition:transform .25s ease}
.maybe-card:hover{transform:translateY(-5px)}
.photo-layer{position:absolute;inset:0}
.photo-layer img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
.photo-layer-fb{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;
text-align:center;padding:10px;font-family:'Bebas Neue',Impact,sans-serif;font-size:19px;color:#fff;
background:linear-gradient(160deg,var(--c1,#4f46e5),var(--c2,var(--acc)))}
.maybe-shade{position:absolute;inset:0;background:linear-gradient(0deg,rgba(0,0,0,.92) 0%,rgba(0,0,0,.1) 55%)}
.maybe-rating{position:absolute;left:8px;top:8px;z-index:2;display:flex;align-items:center;gap:4px;
font-size:10.5px;font-weight:800;color:var(--acc);background:rgba(0,0,0,.55);padding:3px 7px;border-radius:6px}
.maybe-info{position:absolute;left:9px;right:9px;bottom:9px;z-index:2}
.maybe-info b{display:block;font-size:12.5px;color:#fff;line-height:1.2}
.maybe-info span{font-size:9.5px;color:#c3c9d4}
.maybe-play{position:absolute;right:8px;bottom:8px;z-index:2;width:26px;height:26px;border-radius:50%;
background:var(--acc);color:#111827!important;display:flex;align-items:center;justify-content:center;
text-decoration:none!important}

/* ================= ASIDE: GENRE + RECOMMEND ================= */
.aside-card{background:rgba(12,18,28,.91);border:1px solid #252c38;border-radius:15px;padding:17px;
margin-bottom:16px}
.aside-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.aside-head h4{margin:0;font-size:13.5px;color:#fff}
.aside-head span{font-size:9.5px;color:var(--acc);cursor:pointer}
.chip-row{display:flex;flex-wrap:wrap;gap:7px}
.chip-sm{padding:6px 11px;border-radius:999px;background:#111827;border:1px solid #2b3240;
color:#cbd0d9;font-size:10.5px;cursor:pointer}
.chip-sm:hover{border-color:var(--acc);color:var(--acc)}
.chip-sm.chip-active{background:var(--acc);color:#111827;border-color:var(--acc);font-weight:800}
.reco-item{position:relative;display:flex;gap:10px;align-items:center;padding:8px;border-radius:11px;
margin-bottom:8px;background:#0e1420;border:1px solid #202634}
.reco-thumb{position:relative;width:56px;height:72px;border-radius:8px;overflow:hidden;flex:0 0 auto}
.reco-thumb .photo-layer-fb{font-size:11px}
.reco-text{min-width:0;flex:1}
.reco-text b{display:block;font-size:11.5px;color:#fff;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.reco-text span{font-size:9.5px;color:#8b93a3}
.reco-play{flex:0 0 auto;width:30px;height:30px;border-radius:50%;background:rgba(var(--acc-rgb),.14);
color:var(--acc)!important;display:flex;align-items:center;justify-content:center;text-decoration:none!important}
.reco-play:hover{background:var(--acc);color:#111827!important}
@media(max-width:1100px){.player-row{flex-direction:column}.player-aside{width:100%}}
"


# ============================================================
# EXTRA CSS (additive - layered over the original cinema_css)
# ============================================================
extra_css <- r"---(
/* ---------- poster card: true 2:3 poster, readable text ---------- */
.poster-wrap{min-width:0}
.cinema-poster-image{height:auto!important;aspect-ratio:2/3}
.poster-fallback-icon{background:#10151f!important;border:1px dashed #3a4456;align-items:flex-start}
.poster-fallback-icon .pf-title{font-size:clamp(18px,2vw,26px)}
.poster-fallback-icon .pf-badge{background:#2a3242;color:#cbd0d9}
.poster-badge{font-size:9px!important;padding:5px 8px!important;letter-spacing:1.2px!important}
.poster-movie-title{font-size:19px!important}
.poster-tagline{font-size:9px!important}
.poster-meta{font-size:10px!important}
.poster-match{font-size:11px!important}
.poster-reason{font-size:9.5px!important}
.poster-trailer-btn{font-size:9.5px!important;padding:7px 10px!important;border-radius:7px!important;
background:linear-gradient(135deg,var(--acc),var(--acc2))!important}
.poster-actions .cardbtn{font-size:10px!important;padding:6px 0!important}
.poster-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:16px;margin-top:10px}
.poster-rail{display:grid;grid-auto-flow:column;grid-auto-columns:185px;gap:14px;overflow-x:auto;padding:4px 2px 14px}
.cinema-poster-section{margin-bottom:8px}
.cinema-poster-heading h3{font-size:18px}

/* ---------- navigation ---------- */
.sidebar{width:262px!important}
.main{margin-left:262px!important}
.navitem{display:flex;align-items:center;gap:11px;padding:9px 12px;margin:2px 0;border-radius:9px;cursor:pointer;
color:#aeb6c4;font-weight:600;font-size:12px;transition:.18s;user-select:none}
.navitem:hover{background:rgba(var(--acc-rgb),.10);color:var(--acc);transform:translateX(3px)}
.navitem.active{background:linear-gradient(135deg,rgba(var(--acc-rgb),.18),rgba(var(--acc2-rgb),.08));color:var(--acc);
box-shadow:inset 0 0 0 1px rgba(var(--acc-rgb),.35)}
.navitem .ni-ico{width:20px;text-align:center;font-size:14px}
.nav-sec{margin:16px 0 5px;padding:0 12px;font-size:9.5px;letter-spacing:1.6px;color:#6e7785;font-weight:800}
.navitem.logout{color:#f87171;margin-top:12px}
.sidebar{padding-bottom:30px}

/* ---------- page furniture ---------- */
.page-head{margin:2px 0 18px}
.page-head h2{margin:0 0 4px;font-size:27px;font-weight:900;letter-spacing:.4px;color:#fff}
.page-head p{margin:0;color:#8f98a8;font-size:12.5px;line-height:1.6;max-width:880px}
.note-box{background:rgba(var(--acc-rgb),.06);border:1px solid rgba(var(--acc-rgb),.22);border-left:3px solid var(--acc);
border-radius:10px;padding:11px 14px;margin:12px 0;font-size:11.5px;color:#c7cbd4;line-height:1.6}
.demo-tag{display:inline-block;padding:3px 9px;border-radius:6px;background:#27204d;color:#c7b8ff;
font-size:9.5px;font-weight:800;letter-spacing:1px;margin-left:8px;vertical-align:middle}
.mbar{margin:6px 0}
.mbar-top{display:flex;justify-content:space-between;font-size:11.5px;color:#cbd0d9}
.mbar-top b{color:var(--acc)}
.glass{background:rgba(255,255,255,.04);backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);
border:1px solid rgba(255,255,255,.09);border-radius:16px;padding:18px;box-shadow:0 12px 35px rgba(0,0,0,.28)}
.stat small{display:block;color:#6e7785;font-size:9px;margin-top:3px}
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:18px}
@media(max-width:1000px){.two-col{grid-template-columns:1fr}}
.why-list{list-style:none;padding:0;margin:6px 0 0}
.why-list li{font-size:12px;color:#cfd4de;margin:3px 0}
.why-list li:first-letter{color:#4ade80}

/* ---------- recommendation rows ---------- */
.reco-row{display:flex;gap:22px;align-items:flex-start;background:rgba(12,18,28,.88);border:1px solid #252c38;
border-radius:16px;padding:16px;margin-bottom:16px;box-shadow:0 12px 30px rgba(0,0,0,.3)}
.reco-poster{flex:0 0 190px;width:190px}
.reco-body{flex:1;min-width:0}
.reco-body h3{margin:0 0 4px;font-size:21px;color:#fff;letter-spacing:.5px}
.reco-meta{font-size:11.5px;color:#8f98a8;margin-bottom:8px}
.reco-match{font-size:15px;font-weight:900;color:var(--acc);margin-bottom:6px}
.reco-why h4{margin:12px 0 2px;font-size:12px;color:var(--acc);letter-spacing:1px;text-transform:uppercase}
.reco-pref{margin-top:8px;font-size:12px;color:#aeb6c4}
.reco-pref b{color:var(--acc)}
@media(max-width:700px){.reco-row{flex-direction:column}.reco-poster{width:100%;max-width:220px}}

/* ---------- chips & genre / mood cards ---------- */
.mood-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px;margin:10px 0 18px}
.mood-card{padding:16px 10px;text-align:center;border-radius:14px;cursor:pointer;background:rgba(15,20,30,.9);
border:1px solid #262d3a;transition:.22s;color:#e5e7eb;font-weight:700;font-size:13px}
.mood-card .mi{display:block;font-size:28px;margin-bottom:6px}
.mood-card:hover{transform:translateY(-4px);border-color:var(--acc);box-shadow:0 14px 30px rgba(0,0,0,.45)}
.mood-card.sel{background:linear-gradient(135deg,rgba(var(--acc-rgb),.22),rgba(var(--acc2-rgb),.08));border-color:var(--acc);color:var(--acc)}
.genre-card small{display:block;font-size:10px;color:#8f98a8;font-weight:500;margin-top:3px}

/* ---------- dashboard ---------- */
.hero-actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:16px}
.hero-actions .btn{border-radius:9px}
.ghost-btn{background:rgba(255,255,255,.07)!important;color:#fff!important;border:1px solid rgba(255,255,255,.18)!important;
border-radius:9px!important;font-weight:700!important}
.ghost-btn:hover{border-color:var(--acc)!important;color:var(--acc)!important}
.motd{display:grid;grid-template-columns:230px 1fr;gap:22px;align-items:start}
.motd h2{margin:0 0 6px;font-size:28px;color:#fff;letter-spacing:.6px}
@media(max-width:800px){.motd{grid-template-columns:1fr}}
.shortcut-row{display:flex;flex-wrap:wrap;gap:9px}

/* ---------- Surprise Me ---------- */
.big-surprise{width:100%;padding:26px!important;font-size:24px!important;letter-spacing:4px;border-radius:18px!important;
box-shadow:0 0 40px rgba(var(--acc-rgb),.25)}
.surprise-box{display:grid;grid-template-columns:240px 1fr;gap:24px;align-items:start;margin-top:18px}
.surprise-box h2{margin:0 0 6px;font-size:30px;color:#fff;letter-spacing:.6px}
@media(max-width:800px){.surprise-box{grid-template-columns:1fr}}
.btn-row{display:flex;flex-wrap:wrap;gap:10px;margin-top:12px}
.btn-row a,.btn-row .btn,.btn-row div.cardbtn{flex:0 0 auto;min-width:130px;padding:10px 14px!important;border-radius:9px;font-size:12px!important;font-weight:800;text-align:center;text-decoration:none!important}

/* ---------- Movie Battle ---------- */
.battle{display:grid;grid-template-columns:1fr 80px 1fr;gap:12px;align-items:start}
.battle .vs{align-self:center;text-align:center;font-size:28px;font-weight:900;color:var(--acc)}
.battle-card{max-width:260px;margin:auto}
@media(max-width:800px){.battle{grid-template-columns:1fr}}
.winner{margin-top:18px;text-align:center;padding:22px;border-radius:16px;
background:linear-gradient(135deg,rgba(var(--acc-rgb),.16),rgba(99,102,241,.12));border:1px solid rgba(var(--acc-rgb),.35)}
.winner h3{margin:0 0 6px;color:var(--acc);letter-spacing:3px;font-size:13px}
.winner .wn{font-size:30px;font-weight:900;color:#fff;letter-spacing:1px}
.cmp-table td.win{color:var(--acc)!important;font-weight:800}

/* ---------- Pipeline ---------- */
.pipe{display:flex;flex-direction:column;align-items:center;gap:4px}
.pipe-step{width:100%;max-width:560px;text-align:center;padding:12px 16px;border-radius:12px;background:#111827;
border:1px solid #2b3240;color:#e5e7eb;font-weight:700;font-size:13px}
.pipe-step small{display:block;color:#8f98a8;font-weight:400;font-size:10.5px;margin-top:2px}
.pipe-arrow{color:var(--acc);font-size:18px;line-height:1}
.pipe-step.hot{border-color:var(--acc);background:rgba(var(--acc-rgb),.07)}

/* ---------- tabs inside My Movies ---------- */
.mm-tabs>.nav-tabs{display:flex!important;flex-wrap:wrap;gap:6px;border-bottom:1px solid #242b37!important;margin-bottom:16px}
.mm-tabs>.nav-tabs>li>a{background:#111827!important;color:#aeb6c4!important;border:1px solid #2b3240!important;
border-radius:9px 9px 0 0!important;font-size:12px;font-weight:700}
.mm-tabs>.nav-tabs>li.active>a{background:linear-gradient(135deg,var(--acc),var(--acc2))!important;color:#111827!important;border-color:var(--acc)!important}

/* ---------- inputs inside dark cards ---------- */
.radio label,.checkbox label{color:#cbd0d9!important}
.irs--shiny .irs-line{background:#273244;border-color:#273244}
.irs--shiny .irs-bar{background:var(--acc);border-color:var(--acc)}
.irs--shiny .irs-single,.irs--shiny .irs-from,.irs--shiny .irs-to{background:var(--acc2);color:#111827}
.irs--shiny .irs-handle{border-color:var(--acc)}
.irs--shiny .irs-min,.irs--shiny .irs-max{background:#111827;color:#8f98a8}
.irs--shiny .irs-grid-text{color:#6e7785}
.btn-default{background:#1b2331;border:1px solid #2b3240;color:#e5e7eb}
.btn-default:hover{border-color:var(--acc);color:var(--acc);background:#1b2331}
textarea.form-control{min-height:80px}
.star-radio .radio-inline{margin-right:14px;font-size:17px}


/* ============================================================
   GLASS THEME  (nebula background + frosted panels + gradient accents)
   ============================================================ */
:root{--acc:#ff2d4a;--acc2:#b3001b;--acc-rgb:255,45,74;--acc2-rgb:179,0,27}
.cinema.bg-crimson{--acc:#ff2d4a;--acc2:#b3001b;--acc-rgb:255,45,74;--acc2-rgb:179,0,27;background-image:url('backgrounds/crimson.jpg')}
.cinema.bg-nebula{--acc:#ff5c8a;--acc2:#8b5cf6;--acc-rgb:255,92,138;--acc2-rgb:139,92,246;background-image:url('backgrounds/nebula.jpg')}
.cinema.bg-aurora{--acc:#2dd4bf;--acc2:#6366f1;--acc-rgb:45,212,191;--acc2-rgb:99,102,241;background-image:url('backgrounds/aurora.jpg')}
.cinema.bg-sunset{--acc:#fb923c;--acc2:#ec4899;--acc-rgb:251,146,60;--acc2-rgb:236,72,153;background-image:url('backgrounds/sunset.jpg')}
.cinema.bg-midnight{--acc:#60a5fa;--acc2:#7c3aed;--acc-rgb:96,165,250;--acc2-rgb:124,58,237;background-image:url('backgrounds/midnight.jpg')}
.cinema{background-color:#05030f;background-size:cover;background-position:center;background-attachment:fixed;
font-family:'Inter',system-ui,sans-serif}
.cine-bg{display:none!important}

/* frosted panels */
.card,.stat,.reco-row,.fb-board,.fb-ticket,.glass,.hero,.top,.sidebar,.winner,.cinema-poster-section,.pipe-step{
background:rgba(255,255,255,.07)!important;backdrop-filter:blur(22px) saturate(150%);-webkit-backdrop-filter:blur(22px) saturate(150%);
border:1px solid rgba(255,255,255,.16)!important;box-shadow:0 16px 44px rgba(0,0,0,.30)}
.card,.reco-row,.fb-board,.winner{border-radius:26px!important}
.stat{border-radius:20px!important}
.hero{border-radius:32px!important;background:linear-gradient(135deg,rgba(255,255,255,.12),rgba(255,255,255,.03))!important}
.top{border-radius:26px;padding:12px 22px}
.cinema-poster-section{border-radius:26px;padding:16px 18px;margin-bottom:14px}
.sidebar{left:16px!important;top:16px!important;bottom:16px!important;width:262px!important;border-radius:30px!important;overflow-y:auto;padding:22px 14px!important}
.main{margin-left:296px!important}
@media(max-width:900px){.sidebar{position:relative!important;width:auto!important;margin:12px}.main{margin-left:0!important}}

/* pill navigation */
.navitem{border-radius:999px;color:rgba(255,255,255,.78)}
.navitem:hover{background:rgba(255,255,255,.12);color:#fff;transform:translateX(3px)}
.navitem.active{background:linear-gradient(135deg,var(--acc),var(--acc2));color:#fff!important;box-shadow:0 8px 22px rgba(var(--acc-rgb),.35)}
.nav-sec{color:rgba(255,255,255,.5)}

/* gradient buttons */
.gold,.btn.gold,.btn-default.gold,a.gold{background:linear-gradient(135deg,var(--acc),var(--acc2))!important;color:#fff!important;border:0!important;
border-radius:999px!important;font-weight:800!important;box-shadow:0 10px 26px rgba(var(--acc-rgb),.35)}
.gold:hover{filter:brightness(1.1);transform:translateY(-2px)}
.ghost-btn,.btn-default{background:rgba(255,255,255,.10)!important;color:#fff!important;border:1px solid rgba(255,255,255,.28)!important;border-radius:999px!important}
.btn-default:hover,.ghost-btn:hover{background:rgba(255,255,255,.2)!important;color:#fff!important}
.poster-trailer-btn,.trailer-btn{background:linear-gradient(135deg,var(--acc),var(--acc2))!important;color:#fff!important;border-radius:999px!important}
.poster-badge{background:rgba(20,10,40,.55)!important;color:#fff!important;border:1px solid rgba(255,255,255,.3);backdrop-filter:blur(8px);border-radius:999px!important}
.cinema-poster-card{border-radius:24px!important;border:1px solid rgba(255,255,255,.22)!important;box-shadow:0 14px 34px rgba(0,0,0,.4)}
.poster-fallback-icon{background:rgba(255,255,255,.06)!important}
.poster-actions .cardbtn{background:rgba(255,255,255,.14)!important;border:1px solid rgba(255,255,255,.22)!important;border-radius:999px!important;color:#fff!important}
.poster-actions .cardbtn:hover{background:linear-gradient(135deg,var(--acc),var(--acc2))!important}
.fill{background:linear-gradient(90deg,var(--acc2),var(--acc))!important}
.bar{background:rgba(255,255,255,.14)!important}

/* chips, moods, feedback pieces */
.chip,.mood-card,.fb-react,.fb-tag,.fb-kpis div,.fb-stub,.reco-row .bar{background:rgba(255,255,255,.09)!important;border:1px solid rgba(255,255,255,.2)!important;color:#fff}
.chip:hover,.mood-card:hover,.fb-react:hover,.fb-tag:hover{border-color:var(--acc)!important}
.mood-card.sel,.fb-react.on,.fb-tag.on,.chip.on{background:linear-gradient(135deg,rgba(var(--acc-rgb),.45),rgba(var(--acc2-rgb),.45))!important;border-color:rgba(255,255,255,.5)!important;color:#fff!important}
.fb-ticket::before,.fb-ticket::after{background:rgba(10,6,30,.9)}
.fb-ticket-top{background:linear-gradient(135deg,var(--acc),var(--acc2));color:#fff}
.fb-star.on{color:var(--acc)}
.note-box{background:rgba(255,255,255,.07)!important;backdrop-filter:blur(14px);border-color:rgba(255,255,255,.15)!important;border-left-color:var(--acc)!important;border-radius:16px}

/* inputs */
.form-control,.selectize-input,.selectize-dropdown,.irs--shiny .irs-min,.irs--shiny .irs-max{background:rgba(255,255,255,.09)!important;
border:1px solid rgba(255,255,255,.22)!important;color:#fff!important;border-radius:14px!important}
.selectize-input>input,.selectize-input .item{color:#fff!important}
.selectize-dropdown{background:rgba(20,12,45,.92)!important;backdrop-filter:blur(18px)}
.selectize-dropdown .active{background:rgba(var(--acc-rgb),.35)!important;color:#fff!important}
.irs--shiny .irs-line{background:rgba(255,255,255,.18);border-color:transparent}
.table{background:transparent!important;color:#fff}
.table>thead>tr>th{border-bottom:1px solid rgba(255,255,255,.2)!important;color:rgba(255,255,255,.7)}
.table>tbody>tr>td{border-top:1px solid rgba(255,255,255,.1)!important}
.table-striped>tbody>tr:nth-of-type(odd){background:rgba(255,255,255,.04)!important}
.page-head h2{text-shadow:0 2px 18px rgba(0,0,0,.35)}
.page-head p,.muted{color:rgba(255,255,255,.65)!important}

/* background picker in the top bar */
.bg-picker{display:flex;align-items:center;gap:8px;margin-right:12px}
.bg-picker small{font-size:9px;letter-spacing:1.5px;color:rgba(255,255,255,.55);margin-right:2px}
.bgdot{width:24px;height:24px;border-radius:50%;border:2px solid rgba(255,255,255,.55);cursor:pointer;background-size:cover;background-position:center;transition:.18s}
.bgdot:hover{transform:scale(1.18);border-color:#fff}
.bgdot.nebula{background-image:url('backgrounds/nebula.jpg')}
.bgdot.aurora{background-image:url('backgrounds/aurora.jpg')}
.bgdot.sunset{background-image:url('backgrounds/sunset.jpg')}
.bgdot.midnight{background-image:url('backgrounds/midnight.jpg')}

/* ============================================================
   CINEMATIC RED REDESIGN (logo banner, hero, tiles, new fonts)
   ============================================================ */
.cinema{font-family:'Poppins','Inter',system-ui,sans-serif}
.mr-ic{flex:0 0 auto;vertical-align:middle}
.card,.stat,.reco-row,.fb-board,.fb-ticket,.glass,.top,.winner,.pipe-step{
background:rgba(10,12,22,.68)!important;border:1px solid rgba(255,255,255,.09)!important}
.cinema-poster-section{background:rgba(10,12,22,.5)!important;border:1px solid rgba(255,255,255,.07)!important}

/* ---------- sidebar + logo banner ---------- */
.sidebar{background:linear-gradient(180deg,rgba(10,12,24,.94),rgba(7,8,16,.95))!important;border:1px solid rgba(255,255,255,.08)!important;
border-radius:28px!important;padding:0 14px 22px!important;overflow-x:hidden}
.brandbanner{position:relative;height:168px;margin:0 -14px 14px;overflow:hidden;border-radius:28px 28px 20px 20px}
.bb-art{position:absolute;inset:0;width:100%;height:100%}
.bb-word{position:absolute;left:0;right:0;top:44px;display:flex;justify-content:center;align-items:center;
font-family:'Anton','Bebas Neue',Impact,sans-serif;font-size:46px;line-height:1;letter-spacing:.5px;transform:skewX(-6deg);
filter:drop-shadow(0 4px 10px rgba(0,0,0,.75)) drop-shadow(0 0 14px rgba(255,45,74,.35))}
.bb-m,.bb-vie{background:linear-gradient(180deg,#fff 0%,#aab2c1 52%,#eef1f8 100%);-webkit-background-clip:text;background-clip:text;
-webkit-text-fill-color:transparent;color:transparent}
.bb-rec{background:linear-gradient(180deg,#ff7070 0%,#e0002a 60%,#9a0018 100%);-webkit-background-clip:text;background-clip:text;
-webkit-text-fill-color:transparent;color:transparent}
.bb-reel{width:38px;height:38px;margin:0 1px;animation:bbspin 14s linear infinite}
@keyframes bbspin{to{transform:rotate(360deg)}}
.bb-sub{position:absolute;left:0;right:0;top:112px;text-align:center;font-size:9px;letter-spacing:3.2px;color:#cfd4df;font-weight:500}
.bb-line{position:absolute;left:50%;top:134px;width:96px;height:2px;margin-left:-48px;
background:linear-gradient(90deg,transparent,#ff2d4a,transparent);box-shadow:0 0 12px #ff2d4a}
.brandbanner::after{content:"";position:absolute;top:0;bottom:0;width:60px;left:-90px;transform:skewX(-20deg);
background:linear-gradient(100deg,transparent,rgba(255,255,255,.16),transparent);animation:bbsweep 6s infinite}
@keyframes bbsweep{0%,55%{left:-90px}100%{left:320px}}
.bb-ember{position:absolute;bottom:8px;width:4px;height:4px;border-radius:50%;background:#ff6a3d;box-shadow:0 0 8px #ff3b1d;opacity:0;animation:bbup 4.2s infinite}
.bb-ember.e1{left:26%;animation-delay:0s}.bb-ember.e2{left:58%;animation-delay:1.4s}.bb-ember.e3{left:82%;animation-delay:2.7s}
@keyframes bbup{0%{transform:translateY(0);opacity:0}20%{opacity:1}100%{transform:translateY(-120px);opacity:0}}

/* ---------- navigation ---------- */
.navitem{display:flex;align-items:center;gap:14px;padding:11px 10px;border-radius:14px;font-size:13.5px;font-weight:500;color:rgba(255,255,255,.88)}
.navitem:hover{background:rgba(255,255,255,.06)!important;transform:none;color:#fff}
.navitem .ni-ico{width:26px;display:flex;justify-content:center;color:rgba(255,255,255,.82)}
.navitem .ni-label{flex:1}
.navitem .ni-chev{opacity:.5;display:flex}
.navitem.active{background:linear-gradient(135deg,rgba(var(--acc-rgb),.30),rgba(var(--acc2-rgb),.22))!important;
box-shadow:inset 0 0 0 1px rgba(var(--acc-rgb),.5)!important;color:#fff!important}
.navitem.active .ni-ico{color:var(--acc)}
.navitem.nav-dash{height:54px;margin:0 0 4px;padding:0 16px;border-radius:999px;border:1.5px solid rgba(255,96,64,.95);
background:linear-gradient(90deg,rgba(255,130,40,.32),rgba(200,0,34,.42),rgba(120,0,22,.5))!important;
box-shadow:0 0 24px rgba(255,45,74,.45),inset 0 0 18px rgba(255,80,60,.22)!important}
.nav-dash .ni-ico{color:#ff7a5c}
.nav-dash .ni-sep{width:1px;height:28px;background:rgba(255,100,70,.65);margin:0 2px}
.nav-dash .ni-label{font-size:16px;font-weight:600}
.nav-sec{display:flex;align-items:center;gap:12px;margin:22px 8px 6px;padding:0;font-size:11.5px;letter-spacing:3.4px;font-weight:700;color:#6f7587}
.nav-sec-line{flex:1;height:1px;background:rgba(255,255,255,.12)}
.navitem.logout{color:#ff6b6b;margin-top:12px}

/* ---------- top bar ---------- */
.top{border-radius:999px!important;padding:8px 14px!important;gap:14px}
.toptabs{display:flex;gap:4px;flex-wrap:wrap}
.toptab{padding:10px 22px;border-radius:999px;font-size:14px;font-weight:600;color:rgba(255,255,255,.82);cursor:pointer;transition:.18s}
.toptab:hover{color:#fff;background:rgba(255,255,255,.08)}
.toptab.active{background:linear-gradient(135deg,#ff3b57,#c40a26);color:#fff;box-shadow:0 8px 22px rgba(255,45,74,.4)}
.top-right{display:flex;align-items:center;gap:14px}
.avatar-chip{display:flex;align-items:center}
.bgdot.crimson{background-image:url('backgrounds/crimson.jpg')}

/* ---------- dashboard hero (Leo) ---------- */
.dash{margin-top:4px}
.hero2{position:relative;min-height:540px;border-radius:30px;overflow:hidden;margin-bottom:18px;display:flex;align-items:flex-end;
background:#0a0508;border:1px solid rgba(255,255,255,.08);box-shadow:0 26px 70px rgba(0,0,0,.5)}
.hero2-bg{position:absolute;inset:-30px;background-size:cover;background-position:center 22%;
filter:blur(26px) saturate(1.35) brightness(.7);transform:scale(1.12)}
.hero2-art{position:absolute;right:0;top:0;bottom:0;width:62%}
.hero2-art img{width:100%;height:100%;object-fit:cover;object-position:center 12%;
-webkit-mask-image:linear-gradient(90deg,transparent 0%,#000 42%);mask-image:linear-gradient(90deg,transparent 0%,#000 42%)}
.hero2-shade{position:absolute;inset:0;background:
linear-gradient(90deg,rgba(6,4,8,.96) 0%,rgba(6,4,8,.80) 30%,rgba(6,4,8,.22) 62%,rgba(6,4,8,.04) 100%),
linear-gradient(0deg,rgba(6,4,8,.85),transparent 42%)}
.hero2-copy{position:relative;z-index:2;padding:40px 48px 46px;max-width:640px}
.hero2-kicker{display:flex;align-items:center;gap:14px;font-size:12px;letter-spacing:7px;color:#ff3b57;font-weight:700}
.hk-line{flex:0 0 130px;height:1px;background:rgba(255,59,87,.55)}
.hero2-title{font-family:'Permanent Marker','Anton',Impact,sans-serif;font-size:136px;line-height:.95;color:#ff1f3d;transform:skewX(-8deg);
margin:8px 0 0;letter-spacing:2px;text-shadow:0 0 34px rgba(255,31,61,.55),3px 5px 0 rgba(0,0,0,.45)}
.hero2-script{font-family:'Kaushan Script',cursive;font-size:40px;color:#fff;margin:-10px 0 16px 30px;transform:rotate(-4deg);
text-shadow:0 3px 14px rgba(0,0,0,.7)}
.hero2-tag{font-size:16.5px;line-height:1.65;color:rgba(255,255,255,.9);margin:0 0 12px;font-weight:400}
.hero2-meta{font-size:12px;letter-spacing:2.6px;color:rgba(255,255,255,.72);margin-bottom:22px;font-weight:600}
.hero2-actions{display:flex;flex-wrap:wrap;gap:12px}
.hero2-btn,.hero2-btn.btn{display:inline-flex;align-items:center;gap:10px;padding:15px 30px;border-radius:999px;font-size:15px;font-weight:700;
text-decoration:none!important;cursor:pointer;border:1px solid rgba(255,255,255,.28)!important;color:#fff!important;
background:rgba(18,18,26,.66)!important;backdrop-filter:blur(10px);transition:.18s}
.hero2-btn.primary{background:linear-gradient(135deg,#ff3b57,#c40a26)!important;border:0!important;box-shadow:0 12px 30px rgba(255,45,74,.45)}
.hero2-btn:hover{transform:translateY(-2px);filter:brightness(1.15)}
@media(max-width:900px){.hero2{min-height:620px}.hero2-art{width:100%}.hero2-title{font-size:92px}.hero2-copy{padding:28px}}

/* ---------- feature tiles ---------- */
.ftiles{display:grid;grid-template-columns:repeat(5,1fr);gap:14px;margin-bottom:28px}
@media(max-width:1200px){.ftiles{grid-template-columns:repeat(2,1fr)}}
.ftile{display:flex;align-items:center;gap:14px;padding:18px;border-radius:18px;cursor:pointer;
background:rgba(14,16,28,.80);border:1px solid rgba(255,255,255,.10);transition:.2s;min-width:0}
.ftile:hover{transform:translateY(-4px);border-color:rgba(255,255,255,.32);box-shadow:0 14px 30px rgba(0,0,0,.4)}
.ft-ico{width:48px;height:48px;border-radius:14px;display:flex;align-items:center;justify-content:center;flex:0 0 48px}
.ft-text b{display:block;font-size:14.5px;color:#fff;line-height:1.25;font-weight:600}
.ft-text span{font-size:11.5px;color:rgba(255,255,255,.55)}
.t-ai{background:linear-gradient(135deg,rgba(70,80,190,.45),rgba(14,16,40,.85))}.t-ai .ft-ico{color:#9aa8ff;background:rgba(120,130,255,.16)}
.t-genre{background:linear-gradient(135deg,rgba(20,130,90,.38),rgba(12,22,26,.85))}.t-genre .ft-ico{color:#34d399;background:rgba(52,211,153,.14)}
.t-top{background:linear-gradient(135deg,rgba(150,110,20,.34),rgba(24,20,14,.85))}.t-top .ft-ico{color:#fbbf24;background:rgba(251,191,36,.14)}
.t-trend{background:linear-gradient(135deg,rgba(170,70,20,.34),rgba(26,16,14,.85))}.t-trend .ft-ico{color:#fb923c;background:rgba(251,146,60,.14)}
.t-list{background:linear-gradient(135deg,rgba(170,30,70,.36),rgba(26,12,18,.85))}.t-list .ft-ico{color:#fb7185;background:rgba(251,113,133,.14)}

/* ---------- compact poster rows (title + year below) ---------- */
.dash .cinema-poster-section{background:none!important;border:0!important;box-shadow:none!important;backdrop-filter:none!important;padding:6px 0;margin-bottom:10px}
.cinema-poster-heading{display:flex;align-items:center;gap:12px;margin-bottom:14px}
.cinema-poster-heading h3{margin:0;font-size:26px;font-weight:700;color:#fff;border-left:4px solid #ff3b57;padding-left:12px;letter-spacing:.2px}
.ph-sub{font-size:11px;color:rgba(255,255,255,.45)}
.viewall{margin-left:auto;display:inline-flex;align-items:center;gap:6px;color:#ff3b57;font-weight:600;font-size:14px;cursor:pointer}
.viewall:hover{filter:brightness(1.25)}
.poster-rail.compact{grid-auto-columns:160px;gap:16px}
.pc{min-width:0}
.pc-img{position:relative;aspect-ratio:2/3;border-radius:14px;overflow:hidden;border:1px solid rgba(255,255,255,.14);cursor:pointer;
background:#10121c;transition:.22s}
.pc-img img{width:100%;height:100%;object-fit:cover;display:block}
.pc-img:hover{transform:translateY(-6px) scale(1.03);box-shadow:0 18px 36px rgba(0,0,0,.55);border-color:rgba(255,59,87,.75)}
.pc-title{margin-top:10px;font-size:15px;font-weight:600;color:#fff;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pc-year{font-size:13px;color:rgba(255,255,255,.55)}
.pc-missing{display:none;position:absolute;inset:0;flex-direction:column;justify-content:flex-end;gap:6px;padding:12px;
font-weight:700;font-size:13px;color:#fff;background:#12141f}
.pc-missing span+span{font-size:9px;letter-spacing:1px;color:#8f98a8}
.pc-img.poster-missing .pc-missing{display:flex}
.pc-score{position:absolute;top:8px;right:8px;padding:3px 9px;border-radius:999px;font-size:10px;font-weight:700;background:rgba(0,0,0,.68);color:#fff}

/* ---------- svg icons inside existing components ---------- */
.mood-card .mi{color:var(--acc);display:flex;justify-content:center;margin-bottom:8px}
.fb-react .e{color:var(--acc);display:flex;justify-content:center;margin-bottom:6px}
.chip{display:inline-flex;align-items:center;gap:8px}
.empty .icon{color:rgba(255,255,255,.4);display:flex;justify-content:center;margin-bottom:10px}

/* ============================================================
   FEEDBACK (modern) + TILE FIX + ACCOUNT BOX + CURSOR EFFECTS
   ============================================================ */
.fb2{display:grid;grid-template-columns:minmax(340px,1.15fr) minmax(300px,1fr);gap:22px;align-items:start}
@media(max-width:1000px){.fb2{grid-template-columns:1fr}}
.fb2-form{position:relative;background:rgba(10,12,22,.70);border:1px solid rgba(255,255,255,.09);border-radius:26px;padding:26px;
backdrop-filter:blur(22px);-webkit-backdrop-filter:blur(22px);box-shadow:0 16px 44px rgba(0,0,0,.30)}
.fb2-sec{display:grid;grid-template-columns:36px 1fr;column-gap:16px;padding:20px 0;border-bottom:1px solid rgba(255,255,255,.08)}
.fb2-sec:first-child{padding-top:0}
.fb2-num{grid-row:1/3;width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;
color:#fff;background:linear-gradient(135deg,var(--acc),var(--acc2));box-shadow:0 6px 16px rgba(var(--acc-rgb),.35)}
.fb2-head{grid-column:2}
.fb2-head h4{margin:0;font-size:16px;font-weight:600;color:#fff}
.fb2-head p{margin:2px 0 12px;font-size:12.5px;color:rgba(255,255,255,.55)}
.fb2-body{grid-column:2}
.fb2-body .form-group{margin-bottom:12px}
.fb2-submit{margin-top:22px}
.fb2-submit .gold{width:100%;padding:15px!important;font-size:15px!important;letter-spacing:.3px}
.fb-stars{display:flex;gap:6px}
.fb-star{font-size:38px;line-height:1;color:rgba(255,255,255,.18);cursor:pointer;transition:.15s;user-select:none}
.fb-star:hover{transform:scale(1.15);color:rgba(251,191,36,.7)}
.fb-star.on{color:#fbbf24;text-shadow:0 0 16px rgba(251,191,36,.45)}
.fb-hint{margin-top:8px;font-size:13px;color:rgba(255,255,255,.7);min-height:18px}
.fb-react-row{display:grid;grid-template-columns:repeat(3,1fr);gap:10px}
.fb-react{display:flex;flex-direction:column;align-items:center;gap:6px;padding:14px 8px;border-radius:14px;font-size:13px;font-weight:600;
color:rgba(255,255,255,.82);cursor:pointer;transition:.18s;text-align:center}
.fb-react .e{display:flex;color:rgba(255,255,255,.7)}
.fb-react.on .e{color:var(--acc)}
.fb-tags{display:flex;flex-wrap:wrap;gap:8px}
.fb-tag{padding:8px 15px;border-radius:999px;font-size:12.5px;font-weight:500;cursor:pointer;transition:.15s;color:rgba(255,255,255,.82)}
.fb-tags-static{margin-top:6px}
.fb-tags-static .fb-tag{cursor:default}
.fb-board{position:relative;border-radius:26px;padding:24px;backdrop-filter:blur(22px);box-shadow:0 16px 44px rgba(0,0,0,.30)}
.fb-board-head{font-size:16px;font-weight:600;color:#fff;margin-bottom:16px}
.fb-top{display:flex;align-items:center;gap:22px;margin-bottom:18px;flex-wrap:wrap}
.fb-ring{--p:0;position:relative;width:118px;height:118px;border-radius:50%;flex:0 0 118px;display:flex;align-items:center;justify-content:center;
background:conic-gradient(var(--acc) calc(var(--p) * 1%),rgba(255,255,255,.10) 0)}
.fb-ring::before{content:"";position:absolute;inset:10px;border-radius:50%;background:#0b0d18}
.fb-ring span{position:relative;font-size:30px;font-weight:700;color:#fff}
.fb-kpis{flex:1;min-width:200px;display:grid;grid-template-columns:repeat(3,1fr);gap:10px}
.fb-kpis div{background:rgba(255,255,255,.05);border-radius:14px;padding:12px 8px;text-align:center}
.fb-kpis b{display:block;font-size:20px;color:#fff;font-weight:700}
.fb-kpis span{font-size:10.5px;color:rgba(255,255,255,.55)}
.fb-sub-title{margin:16px 0 8px;font-size:12px;font-weight:600;letter-spacing:.5px;color:rgba(255,255,255,.6)}
.fb-wall{margin-top:18px;display:grid;gap:10px}
.fb-item{position:relative;display:grid;grid-template-columns:44px 1fr;gap:14px;padding:14px;border-radius:16px;
background:rgba(255,255,255,.05)!important;border:1px solid rgba(255,255,255,.09)!important}
.fb-av{width:44px;height:44px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:16px;color:#fff;
background:linear-gradient(135deg,var(--acc),var(--acc2))}
.fb-item-top{display:flex;justify-content:space-between;align-items:center;gap:10px}
.fb-item-stars{color:#fbbf24;letter-spacing:2px;font-size:14px}
.fb-badge{padding:3px 11px;border-radius:999px;font-size:11px;font-weight:600;background:rgba(255,255,255,.10);color:rgba(255,255,255,.8)}
.fb-badge.good{background:rgba(52,211,153,.16);color:#6ee7b7}
.fb-badge.mid{background:rgba(251,191,36,.16);color:#fcd34d}
.fb-badge.bad{background:rgba(248,113,113,.16);color:#fca5a5}
.fb-item-part{font-size:12px;color:rgba(255,255,255,.55);margin-top:3px}
.fb-item-tags{font-size:12px;color:var(--acc);margin-top:5px}
.fb-item-note{font-size:13px;color:rgba(255,255,255,.82);margin-top:6px;line-height:1.5}
.fb-empty{margin-top:16px;padding:26px;text-align:center;color:rgba(255,255,255,.55);border:1px dashed rgba(255,255,255,.18);border-radius:18px;font-size:13px}

/* ---------- dashboard tiles: keep text inside the box ---------- */
.ftiles{grid-template-columns:repeat(auto-fit,minmax(215px,1fr))!important}
.ftile{position:relative;overflow:hidden}
.ft-ico{width:42px;height:42px;flex:0 0 42px}
.ft-text{min-width:0;flex:1}
.ft-text b{font-size:14px;overflow-wrap:anywhere;hyphens:auto}
.ft-text span{display:block;overflow-wrap:anywhere;line-height:1.35}

/* ---------- account box (name + logout in one menu) ---------- */
.acct{position:relative;margin-top:18px}
.acct-btn{display:flex;align-items:center;gap:12px;padding:10px 12px;border-radius:16px;cursor:pointer;transition:.18s;
background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.10)}
.acct-btn:hover{background:rgba(255,255,255,.10)}
.acct-av{width:38px;height:38px;flex:0 0 38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;
background:linear-gradient(135deg,var(--acc),var(--acc2))}
.acct-name{flex:1;min-width:0}
.acct-name b{display:block;font-size:14px;color:#fff;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.acct-name small{font-size:9.5px;letter-spacing:1.5px;color:rgba(255,255,255,.5)}
.acct-chev{display:flex;opacity:.6;transform:rotate(-90deg);transition:.2s}
.acct.open .acct-chev{transform:rotate(90deg)}
.acct-menu{position:absolute;left:0;right:0;bottom:calc(100% + 8px);padding:8px;border-radius:16px;z-index:5;
background:rgba(14,16,28,.97);border:1px solid rgba(255,255,255,.12);box-shadow:0 18px 40px rgba(0,0,0,.55);
opacity:0;transform:translateY(8px) scale(.98);pointer-events:none;transition:.18s}
.acct.open .acct-menu{opacity:1;transform:none;pointer-events:auto}
.acct-label{padding:6px 10px 8px;font-size:11px;color:rgba(255,255,255,.5)}
.acct-item{display:flex;align-items:center;gap:10px;padding:10px;border-radius:10px;cursor:pointer;font-size:13.5px;color:rgba(255,255,255,.88);transition:.15s}
.acct-item:hover{background:rgba(255,255,255,.08)}
.acct-item.danger{color:#ff6b6b}
.acct-item.danger:hover{background:rgba(255,80,80,.14)}

/* ---------- cursor effects (app + login) ---------- */
.mr-fx-glow{position:fixed;left:0;top:0;width:560px;height:560px;margin:-280px 0 0 -280px;border-radius:50%;pointer-events:none;z-index:9990;
background:radial-gradient(circle,rgba(255,45,74,.17) 0%,rgba(255,45,74,.06) 38%,transparent 70%);mix-blend-mode:screen;will-change:transform}
.card,.ftile,.reco-row,.fb2-form,.fb-board,.fb-item,.mood-card{position:relative}
.card::after,.ftile::after,.reco-row::after,.fb2-form::after,.fb-board::after,.fb-item::after,.mood-card::after{
content:"";position:absolute;inset:0;border-radius:inherit;pointer-events:none;opacity:0;transition:opacity .25s;
background:radial-gradient(280px circle at var(--mx,50%) var(--my,50%),rgba(255,255,255,.10),transparent 65%)}
.card:hover::after,.ftile:hover::after,.reco-row:hover::after,.fb2-form:hover::after,.fb-board:hover::after,.fb-item:hover::after,.mood-card:hover::after{opacity:1}
/* gentle parallax from mouse position */
.mr-bg{translate:calc(var(--px,0) * -16px) calc(var(--py,0) * -10px);scale:1.06;transition:translate .25s ease-out}
.mr-orb.o1{translate:calc(var(--px,0) * 34px) calc(var(--py,0) * 22px);transition:translate .3s ease-out}
.mr-orb.o2{translate:calc(var(--px,0) * -28px) calc(var(--py,0) * -18px);transition:translate .3s ease-out}
.hero2-art img{translate:calc(var(--px,0) * -12px) calc(var(--py,0) * -8px);scale:1.06;transition:translate .25s ease-out}
.hero2-copy{translate:calc(var(--px,0) * 6px) calc(var(--py,0) * 4px);transition:translate .25s ease-out}
@media (prefers-reduced-motion: reduce){.mr-bg,.mr-orb,.hero2-art img,.hero2-copy{translate:none;scale:none}}

/* ---------- About: methods box ---------- */
.methods{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:14px;margin-top:8px}
.method{position:relative;display:flex;gap:14px;padding:16px;border-radius:16px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.09)}
.m-ico{width:42px;height:42px;flex:0 0 42px;border-radius:12px;display:flex;align-items:center;justify-content:center;color:var(--acc);
background:rgba(var(--acc-rgb),.14)}
.method b{display:block;color:#fff;font-size:14px;margin-bottom:3px}
.method p{margin:0;font-size:12px;color:rgba(255,255,255,.62);line-height:1.5}

/* ---------- top bar: one row, nothing selectable ---------- */
.top{flex-wrap:nowrap!important;gap:12px!important}
.toptabs{flex-wrap:nowrap;min-width:0}
.toptab{padding:9px 16px;font-size:13.5px;white-space:nowrap}
.top-right{margin-left:auto;gap:10px;flex:0 0 auto}
.topbar-search{flex:0 0 auto;width:210px}
.topbar-search .form-group{margin:0}
.topbar-search input{width:100%}
.bgdot{width:20px;height:20px}
.bg-picker{gap:6px;margin-right:6px}
@media(max-width:1180px){.top{flex-wrap:wrap!important}.top-right{margin-left:0}}
.toptab,.navitem,.bgdot,.ftile,.acct-btn,.acct-item,.hero2-btn,.viewall,.mood-card,.chip,.fb-star,.fb-react,.fb-tag,.pc-img,.cardbtn{
-webkit-user-select:none;user-select:none}

/* ---------- background fallbacks (look right even if the image file is missing) ---------- */
.cinema.bg-crimson{background-image:url('backgrounds/crimson.jpg'),radial-gradient(1100px 650px at 82% 18%,#5c0a1c 0%,#1a050b 45%,#06060c 80%)}
.cinema.bg-nebula{background-image:url('backgrounds/nebula.jpg'),radial-gradient(1000px 650px at 20% 80%,#0f766e 0%,#4c1d95 40%,#12061f 80%)}
.cinema.bg-aurora{background-image:url('backgrounds/aurora.jpg'),radial-gradient(1000px 650px at 30% 70%,#0f766e 0%,#3730a3 45%,#050a18 80%)}
.cinema.bg-sunset{background-image:url('backgrounds/sunset.jpg'),radial-gradient(1000px 650px at 70% 30%,#c2410c 0%,#9d174d 40%,#12061a 80%)}
.cinema.bg-midnight{background-image:url('backgrounds/midnight.jpg'),radial-gradient(1000px 650px at 50% 20%,#1e3a8a 0%,#312e81 40%,#050816 80%)}
.bgdot.crimson{background-image:url('backgrounds/crimson.jpg'),linear-gradient(135deg,#ff2d4a,#5c0a1c)}
.bgdot.nebula{background-image:url('backgrounds/nebula.jpg'),linear-gradient(135deg,#e11d74,#4c1d95)}
.bgdot.aurora{background-image:url('backgrounds/aurora.jpg'),linear-gradient(135deg,#2dd4bf,#3730a3)}
.bgdot.sunset{background-image:url('backgrounds/sunset.jpg'),linear-gradient(135deg,#fb923c,#9d174d)}
.bgdot.midnight{background-image:url('backgrounds/midnight.jpg'),linear-gradient(135deg,#3b82f6,#312e81)}

/* ---------- top bar: Home | colour dots | search | avatar ---------- */
.top{display:flex!important;align-items:center;justify-content:space-between;flex-wrap:nowrap!important;gap:18px!important;padding:8px 14px!important}
.toptabs{flex:0 0 auto}
.toptab.home{display:flex;align-items:center;gap:10px;padding:12px 26px;font-size:15px;font-weight:700;color:#fff;
background:linear-gradient(135deg,#ff3b57,#c40a26)!important;box-shadow:0 10px 28px rgba(255,45,74,.45);border-radius:999px}
.toptab.home:hover{filter:brightness(1.12)}
.bg-picker{flex:1;min-width:0;display:flex;align-items:center;justify-content:center;gap:16px;margin:0!important}
.bg-picker::before,.bg-picker::after{content:"";flex:1;height:1px;min-width:20px}
.bg-picker::before{background:linear-gradient(90deg,transparent,rgba(var(--acc-rgb),.7))}
.bg-picker::after{background:linear-gradient(90deg,rgba(var(--acc2-rgb),.7),transparent)}
.bgdot{width:22px!important;height:22px!important;flex:0 0 22px;border-radius:50%;border:2px solid rgba(255,255,255,.9)!important;
background-image:none!important;cursor:pointer;transition:.18s;box-shadow:0 0 0 0 transparent}
.bgdot.crimson{background:#ff2d4a!important}
.bgdot.nebula{background:#a855f7!important}
.bgdot.aurora{background:#22d3ee!important}
.bgdot.sunset{background:#fb923c!important}
.bgdot.midnight{background:#3b82f6!important}
.bgdot:hover{transform:scale(1.2)}
.bgdot.on{box-shadow:0 0 0 4px rgba(255,255,255,.22),0 0 14px rgba(255,255,255,.35);transform:scale(1.1)}
.top-right{flex:0 0 auto;display:flex;align-items:center;gap:14px;margin-left:0!important}
.topbar-search{width:300px!important}
.hero2-script .sw{color:#ff2d4a}
@media(max-width:1100px){.topbar-search{width:200px!important}.bg-picker::before,.bg-picker::after{display:none}}
@media(max-width:820px){.top{flex-wrap:wrap!important}.bg-picker{order:3;flex:1 0 100%}}

/* ---------- Home hero from supplied artwork ---------- */
.hero3{position:relative;border-radius:30px;overflow:hidden;margin-bottom:18px;line-height:0;
border:1px solid rgba(255,255,255,.08);box-shadow:0 26px 70px rgba(0,0,0,.5)}
.hero3 img{width:100%;height:auto;display:block}
.hero3 .hs{position:absolute;display:block;border-radius:999px;cursor:pointer;transition:.18s}
.hero3 .hs:hover{background:rgba(255,255,255,.07);box-shadow:0 0 0 2px rgba(255,255,255,.55),0 0 26px rgba(255,59,87,.65);transform:translateY(-2px)}
)---"

# ============================================================
# PAGES (UI)
# ============================================================
title_choices <- sort(movies$title)
mood_names <- names(mood_defs)

card <- function(...) div(class = "card", ...)

hero_poster_url <- sub("/w500/", "/w780/", leo_poster_url, fixed = TRUE)
leo_id <- movies$movie_id[movies$title == "Leo"][1]

feature_tile <- function(cls, icon, title, sub, page) {
  div(class = paste("ftile", cls), onclick = sprintf("mrNav('%s')", page),
      span(class = "ft-ico", ic(icon, 30)),
      div(class = "ft-text", tags$b(title), tags$span(sub)))
}

# Home hero: uses the supplied artwork (www/hero/leo_home.jpg) when it exists;
# the three buttons drawn in the artwork are made clickable. Otherwise the
# built-in LEO hero below is used.
# The image is searched for in www/hero, www and the project folder, so a
# wrongly placed file is still found. It is copied once to a temp folder and
# served from there.
find_hero_image <- function() {
  pat <- "^leo_home.*\\.(jpg|jpeg|png|webp)$"
  for (d in c(file.path("www", "hero"), "www", ".")) {
    if (!dir.exists(d)) next
    f <- list.files(d, pattern = pat, ignore.case = TRUE, full.names = TRUE,
                    recursive = (d != "."))
    f <- f[file.exists(f) & !dir.exists(f)]          # real files only (skip folders)
    if (length(f)) return(normalizePath(f[1]))
  }
  NA_character_
}
hero_dir <- file.path(tempdir(), "mrhero")
dir.create(hero_dir, showWarnings = FALSE, recursive = TRUE)
hero_src <- NA_character_
home_hero_img <- FALSE
hero_url_path <- ""

# 1) Embedded copy: hero_data.R placed next to this app file (no folders needed).
if (file.exists("hero_data.R")) {
  embedded_ok <- tryCatch({
    env <- new.env()
    sys.source("hero_data.R", envir = env)
    writeBin(jsonlite::base64_dec(paste(env$hero_b64, collapse = "")), file.path(hero_dir, "leo_home.jpg"))
    file.exists(file.path(hero_dir, "leo_home.jpg"))
  }, error = function(e) FALSE)
  if (isTRUE(embedded_ok)) {
    shiny::addResourcePath("mrhero", hero_dir)
    hero_url_path <- "mrhero/leo_home.jpg?v=embedded1"
    home_hero_img <- TRUE
    message("MOVIEREC [home hero v3]: using the embedded image from hero_data.R")
  }
}

# 2) Otherwise look for a loose image file (www/hero, www, project folder).
if (!home_hero_img) {
  hero_src <- find_hero_image()
  if (!is.na(hero_src)) {
    hero_ext <- tolower(tools::file_ext(hero_src))
    copied <- file.copy(hero_src, file.path(hero_dir, paste0("leo_home.", hero_ext)), overwrite = TRUE)
    if (isTRUE(copied)) {
      shiny::addResourcePath("mrhero", hero_dir)
      hero_url_path <- paste0("mrhero/leo_home.", hero_ext, "?v=", as.integer(file.mtime(hero_src)))
      home_hero_img <- TRUE
      message("MOVIEREC [home hero v3]: image FOUND -> ", hero_src)
    }
  }
}
if (!home_hero_img) {
  message("MOVIEREC [home hero v3]: hero image NOT FOUND. Working folder is: ", getwd(),
          "\n  Put hero_data.R in that same folder (next to your app file) and restart the app.")
}

dashboard_hero <- function() {
  if (home_hero_img) {
    hot <- function(cls, l, t, w, h, href = "#", ...) {
      tags$a(class = paste("hs", cls), href = href,
             style = sprintf("left:%s%%;top:%s%%;width:%s%%;height:%s%%", l, t, w, h), ...)
    }
    return(div(class = "hero3",
               tags$img(src = hero_url_path, alt = "LEO - Bloody Sweet"),
               hot("hs-explore", 5.39, 76.38, 17.49, 7.73, `aria-label` = "Explore Leo",
                   onclick = "Shiny.setInputValue('hero_explore', Date.now(), {priority:'event'});return false;"),
               hot("hs-details", 23.76, 76.27, 16.29, 7.95, `aria-label` = "View Details",
                   onclick = sprintf("Shiny.setInputValue('details_click', %d, {priority:'event'});return false;", leo_id)),
               hot("hs-trailer", 5.45, 86.2, 17.87, 7.17, `aria-label` = "Watch trailer",
                   href = leo_trailer_url, target = "_blank", rel = "noopener")))
  }
  tagList(
    note_box(HTML(paste0("<b>Home artwork not found.</b> Put <code>hero_data.R</code> in <code>", htmltools::htmlEscape(getwd()),
                         "</code> (the same folder as your app file) and restart the app. Showing the built-in hero for now."))),
    div(class = "hero2",
            div(class = "hero2-bg", style = paste0("background-image:url('", hero_poster_url, "')")),
            div(class = "hero2-art",
                tags$img(src = hero_poster_url, alt = "LEO poster", onerror = "this.style.display='none';")),
            div(class = "hero2-shade"),
            div(class = "hero2-copy",
                div(class = "hero2-kicker", span("FEATURED"), span(class = "hk-line")),
                div(class = "hero2-title", "LEO"),
                div(class = "hero2-script", span("Bloody"), span(class = "sw", " Sweet")),
                tags$p(class = "hero2-tag",
                       "Power. Past. Punishment.", tags$br(),
                       "Dive into the world of Leo and explore more Kollywood favourites."),
                div(class = "hero2-meta", HTML("2023 &nbsp;&bull;&nbsp; ACTION &nbsp;&bull;&nbsp; CRIME &nbsp;&bull;&nbsp; THRILLER")),
                div(class = "hero2-actions",
                    actionButton("hero_explore", tagList(ic("play", 18), "Explore Leo"), class = "hero2-btn primary"),
                    tags$a(class = "hero2-btn ghost", href = "#",
                           onclick = sprintf("Shiny.setInputValue('details_click', %d, {priority:'event'});return false;", leo_id),
                           ic("info", 18), "View Details"),
                    tags$a(class = "hero2-btn ghost", href = leo_trailer_url, target = "_blank", rel = "noopener",
                           ic("play", 18), "WATCH TRAILER")))))
}

# ------------------------------------------------------------
# NEON HOME PAGE (no posters) - hero, feature cards, live app
# snapshot, mood tiles and quick genre access. Everything is drawn
# with CSS/SVG and computed from the app's own data.
# ------------------------------------------------------------
# ---- data prepared once for the home page (all from the app's own dataset) ----
nh_year_levels <- seq(min(movies$year), max(movies$year))
nh_per_year    <- as.integer(table(factor(movies$year, levels = nh_year_levels)))
nh_avg_year    <- as.numeric(tapply(movies$rating, factor(movies$year, levels = nh_year_levels), mean))
nh_avg_year[is.na(nh_avg_year)] <- mean(movies$rating)
nh_cum_movies  <- cumsum(nh_per_year)
nh_cum_genres  <- vapply(nh_year_levels, function(y) length(unique(unlist(genre_list[movies$year <= y]))), numeric(1))

nh_reel_svg <- paste0(
  '<svg class="nh-reel-svg" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">',
  '<defs><linearGradient id="nhg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#e040fb"/>',
  '<stop offset="1" stop-color="#4f46e5"/></linearGradient></defs>',
  '<g fill="none" stroke="url(#nhg)" stroke-width="3">',
  '<circle cx="100" cy="100" r="90"/><circle cx="100" cy="100" r="78" stroke-opacity=".45"/>',
  '<circle cx="100" cy="100" r="14"/></g>',
  '<g fill="url(#nhg)" fill-opacity=".18" stroke="url(#nhg)" stroke-width="3">',
  '<circle cx="100" cy="46" r="20"/><circle cx="100" cy="154" r="20"/>',
  '<circle cx="46" cy="100" r="20"/><circle cx="154" cy="100" r="20"/>',
  '<circle cx="62" cy="62" r="14"/><circle cx="138" cy="62" r="14"/>',
  '<circle cx="62" cy="138" r="14"/><circle cx="138" cy="138" r="14"/></g></svg>')

# small area-line chart drawn inside a stat card (wipes in from the left)
nh_spark <- function(v, color) {
  v <- as.numeric(v)
  n <- length(v)
  rng <- range(v)
  d <- if (diff(rng) == 0) 1 else diff(rng)
  x <- seq(0, 100, length.out = n)
  y <- 29 - (v - rng[1]) / d * 24
  pts <- paste0(round(x, 2), ",", round(y, 2), collapse = " ")
  area <- paste0("0,32 ", pts, " 100,32")
  gid <- paste0("sg", gsub("[^a-z0-9]", "", tolower(color)))
  HTML(sprintf(paste0(
    "<svg class='nh-sp' viewBox='0 0 100 32' preserveAspectRatio='none' aria-hidden='true'>",
    "<defs><linearGradient id='%s' x1='0' y1='0' x2='0' y2='1'>",
    "<stop offset='0' stop-color='%s' stop-opacity='.4'/><stop offset='1' stop-color='%s' stop-opacity='0'/>",
    "</linearGradient></defs><polygon points='%s' fill='url(#%s)'/>",
    "<polyline points='%s' fill='none' stroke='%s' stroke-width='2' vector-effect='non-scaling-stroke' ",
    "stroke-linecap='round' stroke-linejoin='round'/></svg>"),
    gid, color, color, area, gid, pts, color))
}

nh_stat_cards <- function() {
  yr <- range(movies$year)
  avg <- round(mean(movies$rating), 2)
  mk <- function(cls, rgb, col, ico, big, label, spark, delay) {
    div(class = paste("nh-stat nh-rv", cls),
        style = sprintf("--sc:%s;--sr:%s;--rd:%dms", col, rgb, delay),
        span(class = "nh-stat-ico", ic(ico, 24)),
        div(class = "nh-stat-t", big, span(label)),
        spark)
  }
  div(class = "nh-stats",
      mk("s1", "224,64,251", "#e040fb", "film",
         tags$b(class = "nh-num", `data-count` = as.character(nrow(movies)), `data-dec` = "0", nrow(movies)),
         "Tamil movies", nh_spark(nh_cum_movies, "#e040fb"), 0L),
      mk("s2", "56,189,248", "#38bdf8", "layers",
         tags$b(class = "nh-num", `data-count` = as.character(length(all_genres)), `data-dec` = "0", length(all_genres)),
         "Genres", nh_spark(nh_cum_genres, "#38bdf8"), 90L),
      mk("s3", "244,114,182", "#f472b6", "calendar",
         tags$b(tags$span(class = "nh-num", `data-count` = as.character(yr[1]), `data-from` = as.character(yr[1] - 25), `data-dec` = "0", yr[1]),
                HTML("&nbsp;&ndash;&nbsp;"),
                tags$span(class = "nh-num", `data-count` = as.character(yr[2]), `data-from` = as.character(yr[2] - 25), `data-dec` = "0", yr[2])),
         "Years of cinema", nh_spark(nh_per_year, "#f472b6"), 180L),
      mk("s4", "251,146,60", "#fb923c", "star",
         tags$b(class = "nh-num", `data-count` = as.character(avg), `data-dec` = "2", format(avg, nsmall = 2)),
         "Avg rating", nh_spark(nh_avg_year, "#fb923c"), 270L))
}

nh_hero_art <- function() {
  top <- movies[which.max(movies$rating), ]
  gt <- sort(table(unlist(genre_list)), decreasing = TRUE)
  newest <- movies[order(movies$year, movies$rating, decreasing = TRUE), ][1, ]
  fc <- function(cls, rgb, col, ico, big, small) {
    div(class = paste("nh-fc", cls), style = sprintf("--cc:%s;--cr:%s", col, rgb),
        span(class = "nh-fc-ico", ic(ico, 26)),
        div(tags$b(big), tags$span(small)))
  }
  ribbon <- paste0(
    '<svg class="nh-ribbon" viewBox="0 0 600 220" preserveAspectRatio="none" aria-hidden="true">',
    '<defs><linearGradient id="nhrb" x1="0" x2="1"><stop offset="0" stop-color="#7c3aed" stop-opacity="0"/>',
    '<stop offset=".5" stop-color="#a855f7"/><stop offset="1" stop-color="#e040fb" stop-opacity=".25"/></linearGradient></defs>',
    '<path d="M-20 170 C 120 70, 260 220, 420 120 S 600 60, 640 80" fill="none" stroke="#0b0420" stroke-width="32"/>',
    '<path d="M-20 170 C 120 70, 260 220, 420 120 S 600 60, 640 80" fill="none" stroke="url(#nhrb)" stroke-width="28" opacity=".75"/>',
    '<path class="nh-film" d="M-20 170 C 120 70, 260 220, 420 120 S 600 60, 640 80" fill="none" stroke="#0b0420" stroke-width="28"/>',
    '</svg>')
  div(class = "nh-art",
      div(class = "nh-orbit o1", tags$i()),
      div(class = "nh-orbit o2", tags$i()),
      HTML(ribbon),
      div(class = "nh-reel", HTML(nh_reel_svg)),
      div(class = "nh-script", HTML("Data<br>Meets<br>Cinema")),
      fc("c1", "251,191,36", "#fbbf24", "star", format(top$rating, nsmall = 1), paste("Top rated -", top$title)),
      fc("c2", "255,77,141", "#ff4d8d", "reel", names(gt)[1], paste0(gt[[1]], " movies - most common genre")),
      fc("c3", "34,211,238", "#22d3ee", "calendar", newest$year, paste("Latest -", newest$title)),
      fc("c4", "168,85,247", "#c084fc", "bot", "Hybrid", "content + rating-pattern engine"))
}

nh_strip <- function() {
  f <- function(rgb, col, ico, title, sub, page) {
    div(class = "nh-fs", style = sprintf("--fc:%s;--fr:%s", col, rgb),
        onclick = sprintf("mrNav('%s')", page),
        span(class = "nh-fs-ico", ic(ico, 34)),
        div(class = "nh-fs-t", tags$b(title), tags$span(sub)))
  }
  div(class = "nh-strip nh-rv", style = "--rd:200ms",
      f("167,139,250", "#a78bfa", "bot", "Personalised Recommendations", "Suggestions that match your taste", "ForYou"),
      f("255,77,141", "#ff4d8d", "smile", "Explore by Mood", "Find the right movie for how you feel", "Mood"),
      f("34,211,238", "#22d3ee", "reel", "Dive into Genres", paste0("Discover movies across ", length(all_genres), " genres"), "Genres"),
      f("251,191,36", "#fbbf24", "chart", "Stay Updated", "Explore trending and recent Tamil releases", "NewReleases"))
}

nh_trending <- function() {
  idx <- top_by(trending_score, 5)
  div(class = "nh-panel nh-rv nh-trend", style = "--rd:120ms",
      div(class = "nh-ph", span("TRENDING NOW"),
          tags$a(href = "#", onclick = "mrNav('Trending');return false;", HTML("View All &rarr;"))),
      lapply(seq_along(idx), function(k) {
        r <- movies[idx[k], ]
        div(class = if (k == 1) "nh-tr first" else "nh-tr", style = sprintf("--i:%d", k),
            onclick = sprintf("Shiny.setInputValue('details_click', %d, {priority:'event'})", r$movie_id),
            span(class = "nh-tr-rank", k),
            div(class = "nh-tr-t", tags$b(r$title),
                span(paste0(r$year, "  -  rating ", format(r$rating, nsmall = 1)))),
            div(class = "nh-tr-thumb", photo_layer(r$title, r$movie_id)))
      }),
      div(class = "nh-note", "App ranking: rating + recency + demo-user likes."))
}

nh_donut <- function() {
  tab <- sort(table(unlist(genre_list)), decreasing = TRUE)
  tot <- sum(tab)
  top <- head(tab, 5)
  vals <- c(as.numeric(top), tot - sum(as.numeric(top)))
  labs <- c(names(top), "Others")
  pc <- vals / tot * 100
  cols <- c("#ff4d8d", "#a78bfa", "#e040fb", "#38bdf8", "#fb923c", "#8b93a7")
  circ <- 2 * pi * 46
  cum <- c(0, cumsum(pc))[seq_along(pc)]
  segs <- vapply(seq_along(pc), function(i) {
    len <- max(pc[i] - 1.4, 0.2) / 100 * circ
    sprintf(paste0("<circle class='nh-seg' cx='60' cy='60' r='46' fill='none' stroke='%s' stroke-width='13' ",
                   "stroke-dasharray='%.2f %.2f' stroke-dashoffset='%.2f' style='animation-delay:%dms;--c:%.2f'/>"),
            cols[i], len, circ - len, -cum[i] / 100 * circ, 250 * i, circ)
  }, character(1))
  svg <- paste0("<svg class='nh-donut' viewBox='0 0 120 120' aria-hidden='true'><g transform='rotate(-90 60 60)'>",
                "<circle cx='60' cy='60' r='46' fill='none' stroke='rgba(255,255,255,.07)' stroke-width='13'/>",
                paste(segs, collapse = ""), "</g></svg>")
  div(class = "nh-donut-wrap",
      div(class = "nh-donut-box", HTML(svg),
          div(class = "nh-donut-c",
              tags$b(class = "nh-num", `data-count` = as.character(length(all_genres)), `data-dec` = "0", length(all_genres)),
              span("GENRES"))),
      div(class = "nh-legend", lapply(seq_along(pc), function(i)
        div(span(class = "nh-lg-dot", style = paste0("background:", cols[i])), span(class = "nh-lg-n", labs[i]),
            tags$b(paste0(round(pc[i]), "%"))))))
}

nh_years <- function() {
  mx <- max(nh_per_year)
  n <- length(nh_per_year)
  div(class = "nh-years",
      div(class = "nh-bars",
          lapply(seq_len(n), function(i)
            tags$i(style = sprintf("--h:%d%%;--n:%d", round(100 * nh_per_year[i] / mx), i),
                   title = paste0(nh_year_levels[i], ": ", nh_per_year[i], " movies")))),
      div(class = "nh-axis", span(nh_year_levels[1]), span(nh_year_levels[ceiling(n / 2)]), span(nh_year_levels[n])))
}

page_dashboard <- function() {
  slide <- function(on, up, kicker, l1, l2, l3 = NULL, lead) {
    div(class = paste("nh-slide", if (up) "up", if (on) "on"),
        div(class = "nh-kicker", HTML(kicker)),
        tags$h1(class = "nh-title",
                span(class = "ln l1", l1), span(class = "ln l2", l2),
                if (!is.null(l3)) span(class = "ln l3", l3)),
        tags$p(class = "nh-lead", lead))
  }
  particles <- lapply(1:18, function(i)
    tags$i(class = "nh-pt",
           style = sprintf("left:%d%%;--s:%dpx;--d:%ds;--dl:-%ds", (i * 37) %% 100, 2 + (i %% 3), 9 + (i * 7) %% 9, (i * 5) %% 11)))
  tabPanelBody("Dashboard",
    div(class = "nh",
        # ------------------------------ HERO ------------------------------
        div(class = "nh-hero",
            div(class = "nh-aurora a1"), div(class = "nh-aurora a2"), div(class = "nh-beam"), div(class = "nh-grid"),
            div(class = "nh-parts", particles),
            div(class = "nh-copy",
                uiOutput("dash_hello"),
                div(class = "nh-slides",
                    slide(TRUE, TRUE, "DISCOVER &nbsp;&bull;&nbsp; EXPLORE &nbsp;&bull;&nbsp; GET RECOMMENDATIONS",
                          "Your next", "Favourite film", "Starts here",
                          tagList("A personalised movie recommendation system for ",
                                  span(class = "nh-hl", "Kollywood lovers"), " using Data Science and R Shiny.")),
                    slide(FALSE, FALSE, "MOVIES &nbsp;&bull;&nbsp; DATA &nbsp;&bull;&nbsp; MOODS &nbsp;&bull;&nbsp; YOU",
                          "Discover Stories", "That Match Your World", NULL,
                          tagList("A personalised ", span(class = "nh-hl", "Tamil movie"),
                                  " recommendation system powered by Data Science and a hybrid recommender.")),
                    slide(FALSE, FALSE, "MOVIES &nbsp;&bull;&nbsp; EMOTIONS &nbsp;&bull;&nbsp; RECOMMENDATIONS",
                          "Find Movies", "That Feel Like You", NULL,
                          tagList("Personalised Tamil movie recommendations based on your ",
                                  span(class = "nh-hl", "taste, mood and viewing history"), " using Data Science."))),
                div(class = "nh-uline"),
                div(class = "nh-cta",
                    tags$a(class = "nh-btn primary", href = "#", onclick = "mrNav('ForYou');return false;",
                           ic("play", 18), "Get Recommendations", span(class = "nh-btn-arrow", ic("arrow", 18))),
                    tags$a(class = "nh-btn ghost", href = "#", onclick = "mrNav('Explorer');return false;",
                           ic("compass", 18), "Explore Movies"))),
            nh_hero_art(),
            nh_strip(),
            div(class = "nh-foot",
                div(class = "nh-dashes",
                    tags$button(type = "button", class = "nh-dash on", `aria-label` = "Slide 1"),
                    tags$button(type = "button", class = "nh-dash", `aria-label` = "Slide 2"),
                    tags$button(type = "button", class = "nh-dash", `aria-label` = "Slide 3")),
                div(class = "nh-scroll",
                    onclick = "var e=document.querySelector('.nh-stats');if(e){e.scrollIntoView({behavior:'smooth',block:'start'});}",
                    span(ic("mouse", 22)), span("Scroll to Explore"), span(class = "nh-scroll-ar", ic("arrow", 16))))),
        
        # ------------------------- STATS WITH SPARKLINES --------------------------
        nh_stat_cards(),
        
        # ------------------- PREFERENCES AT A GLANCE + TRENDING -------------------
        div(class = "nh-main",
            div(class = "nh-panel nh-rv",
                div(class = "nh-ph", span("YOUR PREFERENCES AT A GLANCE"),
                    tags$a(href = "#", onclick = "mrNav('Prefs');return false;", HTML("My Preferences &rarr;"))),
                div(class = "nh-sub3",
                    div(class = "nh-box", tags$h5("Top genres"), uiOutput("dash_prefs")),
                    div(class = "nh-box", tags$h5("Genre distribution"), nh_donut()),
                    div(class = "nh-box", tags$h5("Movies by year"), nh_years()))),
            nh_trending()),
        
        # --------------------- MOODS + QUICK GENRES -----------------------
        div(class = "nh-two",
            div(class = "nh-panel nh-rv",
                div(class = "nh-ph", span("EXPLORE BY MOOD"),
                    tags$a(href = "#", onclick = "mrNav('Mood');return false;", HTML("View All &rarr;"))),
                uiOutput("dash_moods")),
            div(class = "nh-panel nh-rv", style = "--rd:120ms",
                div(class = "nh-ph", span("QUICK GENRE ACCESS"),
                    tags$a(href = "#", onclick = "mrNav('Genres');return false;", HTML("View All &rarr;"))),
                uiOutput("dash_genres"))),
        
        # ------------------------- EXPLORE YOUR WAY --------------------------
        div(class = "nh-panel nh-rv",
            div(class = "nh-ph", span("EXPLORE YOUR WAY"), span(class = "nh-ph-sub", "Different ways to find the perfect movie for you.")),
            uiOutput("dash_ways")))
  )
}

home_css <- r"---(
/* ================= ANIMATED HOME ================= */
.nh{--p1:#e040fb;--p2:#a855f7;--p3:#6366f1;--bl:#2f9bff;--cy:#22d3ee;--pk:#ff4d8d;--or:#fb923c;
color:#f3efff;font-family:'Poppins','Inter',system-ui,sans-serif;padding-bottom:30px}
.nh *{box-sizing:border-box}

/* scroll-reveal (JS adds .in when the block enters the screen) */
.nh-js .nh-rv:not(.in){opacity:0}
.nh-js .nh-rv.in{animation:nh-rise .85s cubic-bezier(.2,.8,.2,1) backwards;animation-delay:var(--rd,0ms)}
@keyframes nh-rise{from{opacity:0;transform:translateY(30px)}}
@keyframes nh-pop{from{opacity:0;transform:translateY(16px) scale(.9)}}
@keyframes nh-slidein{from{opacity:0;transform:translateX(26px)}}
@keyframes nh-scalex{from{transform:scaleX(0)}}
@keyframes nh-grow{from{transform:scaleY(.04);opacity:0}}
@keyframes nh-wipe{to{clip-path:inset(0 0 0 0)}}
@keyframes nh-spin{to{transform:rotate(360deg)}}
@keyframes nh-bob{50%{transform:translateY(-10px)}}
@keyframes nh-pulse{50%{opacity:.35}}
@keyframes nh-float{0%,100%{transform:translate(0,0)}50%{transform:translate(30px,24px)}}
@keyframes nh-glow{0%,100%{opacity:.55;transform:scale(.94)}50%{opacity:1;transform:scale(1.06)}}
@keyframes nh-shine{to{background-position:200% 0}}
@keyframes nh-sweep{0%,60%{left:-60%}100%{left:140%}}
@keyframes nh-fly{0%{transform:translateY(0);opacity:0}15%{opacity:.9}100%{transform:translateY(-640px);opacity:0}}
@keyframes nh-beam{0%,100%{opacity:.55;transform:rotate(-3deg)}50%{opacity:1;transform:rotate(3deg)}}
@keyframes nh-film{to{stroke-dashoffset:-34}}
@keyframes nh-fill{to{transform:scaleX(1)}}
@keyframes nh-bounce{0%,100%{transform:translateY(0) rotate(90deg)}50%{transform:translateY(5px) rotate(90deg)}}
@keyframes nh-nudge{50%{transform:translateX(5px)}}
@keyframes nh-seg{from{stroke-dasharray:0 var(--c)}}
@keyframes nh-tilt{0%,100%{transform:rotate(-6deg)}50%{transform:rotate(6deg)}}

/* ---------------- hero ---------------- */
.nh-hero{position:relative;overflow:hidden;border-radius:30px;padding:clamp(22px,3.2vw,44px);margin-bottom:18px;
display:grid;grid-template-columns:minmax(0,1.2fr) minmax(0,.8fr);
grid-template-areas:"copy art" "strip strip" "foot foot";gap:24px 30px;align-items:center;
background:linear-gradient(135deg,#12042e 0%,#0a0220 55%,#14053a 100%);
border:1px solid rgba(168,85,247,.32);box-shadow:0 30px 80px rgba(0,0,0,.55),0 0 70px rgba(124,58,237,.22)}
.nh-aurora{position:absolute;border-radius:50%;filter:blur(90px);pointer-events:none;animation:nh-float 14s ease-in-out infinite}
.nh-aurora.a1{width:520px;height:520px;left:-120px;top:-170px;background:#a21caf;opacity:.38}
.nh-aurora.a2{width:560px;height:560px;right:-150px;bottom:-230px;background:#4f46e5;opacity:.5;animation-delay:-6s}
.nh-beam{position:absolute;top:-30%;right:14%;width:42%;height:150%;pointer-events:none;transform-origin:50% 0;
background:linear-gradient(180deg,rgba(216,180,254,.26),transparent 72%);clip-path:polygon(42% 0,58% 0,100% 100%,0 100%);
filter:blur(16px);animation:nh-beam 8s ease-in-out infinite}
.nh-grid{position:absolute;inset:0;pointer-events:none;opacity:.5;
background-image:linear-gradient(rgba(168,85,247,.09) 1px,transparent 1px),linear-gradient(90deg,rgba(168,85,247,.09) 1px,transparent 1px);
background-size:46px 46px;-webkit-mask-image:radial-gradient(ellipse at 30% 40%,#000 10%,transparent 72%);mask-image:radial-gradient(ellipse at 30% 40%,#000 10%,transparent 72%)}
.nh-parts{position:absolute;inset:0;pointer-events:none;overflow:hidden}
.nh-pt{position:absolute;bottom:-12px;width:var(--s);height:var(--s);border-radius:50%;background:#e9d5ff;opacity:0;
box-shadow:0 0 10px #c084fc;animation:nh-fly var(--d) linear infinite;animation-delay:var(--dl)}
.nh-copy{grid-area:copy;position:relative;z-index:2;min-width:0}
.nh-art{grid-area:art}
.nh-strip{grid-area:strip}
.nh-foot{grid-area:foot}
.nh-hello{display:inline-flex;align-items:center;gap:9px;font-size:12px;font-weight:600;color:#e9d5ff;padding:7px 14px;
border-radius:999px;background:rgba(124,58,237,.18);border:1px solid rgba(168,85,247,.4);margin-bottom:18px}
.nh-dot{width:7px;height:7px;border-radius:50%;background:var(--p1);box-shadow:0 0 10px var(--p1);animation:nh-pulse 2s infinite}

/* rotating headline slides */
.nh-slides{display:grid}
.nh-slide{grid-area:1/1;pointer-events:none;min-width:0}
.nh-slide.on{pointer-events:auto}
.nh-slide .nh-kicker,.nh-slide .ln,.nh-slide .nh-lead{opacity:0;transform:translateX(-34px);filter:blur(6px);
transition:opacity .55s ease,transform .7s cubic-bezier(.2,.8,.2,1),filter .55s ease}
.nh-slide.on .nh-kicker,.nh-slide.on .ln,.nh-slide.on .nh-lead{opacity:1;transform:none;filter:none}
.nh-slide.on .l1{transition-delay:.12s}.nh-slide.on .l2{transition-delay:.24s}.nh-slide.on .l3{transition-delay:.36s}
.nh-slide.on .nh-lead{transition-delay:.48s}
.nh-kicker{font-size:12px;letter-spacing:.3em;color:#cfc8ee;font-weight:500;margin-bottom:12px}
.nh-title{margin:0;font-weight:800;line-height:1.05;font-size:clamp(30px,3.9vw,60px);letter-spacing:-.01em;text-wrap:balance}
.nh-title .ln{display:block}
.nh-slide.up .ln.l1,.nh-slide.up .ln.l2{text-transform:uppercase}
.nh-title .l1{color:#fff}
.nh-title .l2{background:linear-gradient(90deg,#c13bff,#a855f7,#e040fb,#6366f1,#c13bff);background-size:200% 100%;
-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent;
animation:nh-shine 7s linear infinite;padding-bottom:.06em}
.nh-title .l3{color:#fff;font-weight:300;letter-spacing:.34em;font-size:.44em;margin-top:12px;text-transform:uppercase}
.nh-uline{width:56px;height:4px;border-radius:4px;margin:20px 0 18px;background:linear-gradient(90deg,var(--p1),var(--p3));box-shadow:0 0 14px var(--p1)}
.nh-lead{max-width:540px;font-size:16px;line-height:1.7;color:#d6d0ee;margin:14px 0 0}
.nh-hl{color:var(--p1);font-weight:600;text-shadow:0 0 14px rgba(224,64,251,.5)}
.nh-cta{display:flex;flex-wrap:wrap;gap:14px}
.nh-btn{position:relative;overflow:hidden;display:inline-flex;align-items:center;gap:11px;height:54px;padding:0 28px;border-radius:999px;
font-size:15px;font-weight:700;cursor:pointer;text-decoration:none!important;transition:transform .2s,box-shadow .25s,background .25s;user-select:none}
.nh-btn.primary{color:#fff!important;background:linear-gradient(90deg,#e040fb,#8b5cf6 55%,#4f6df5);box-shadow:0 12px 34px rgba(168,85,247,.55)}
.nh-btn.primary:after{content:'';position:absolute;top:0;left:-60%;width:40%;height:100%;
background:linear-gradient(100deg,transparent,rgba(255,255,255,.5),transparent);transform:skewX(-20deg);animation:nh-sweep 4s ease-in-out infinite}
.nh-btn.primary:hover{transform:translateY(-3px);box-shadow:0 18px 46px rgba(217,70,239,.7)}
.nh-btn-arrow{display:inline-flex}
.nh-btn.primary:hover .nh-btn-arrow{animation:nh-nudge .7s ease-in-out infinite}
.nh-btn.ghost{color:#fff!important;background:rgba(255,255,255,.04);border:1.5px solid rgba(196,181,253,.5)}
.nh-btn.ghost:hover{transform:translateY(-3px);background:rgba(168,85,247,.18);box-shadow:0 0 26px rgba(168,85,247,.45)}

/* hero art: reel + orbits + floating cards */
.nh-art{position:relative;z-index:2;min-height:440px;height:100%}
.nh-reel{position:absolute;left:50%;top:48%;width:min(290px,64%);aspect-ratio:1;transform:translate(-50%,-50%);z-index:1;
filter:drop-shadow(0 0 30px rgba(168,85,247,.7));
translate:calc(var(--px,0) * -12px) calc(var(--py,0) * -8px);transition:translate .3s ease-out}
.nh-reel:before{content:'';position:absolute;inset:-18%;border-radius:50%;background:radial-gradient(circle,rgba(168,85,247,.5),transparent 66%);
filter:blur(14px);animation:nh-glow 4.5s ease-in-out infinite}
.nh-reel-svg{position:relative;width:100%;height:100%;animation:nh-spin 26s linear infinite}
.nh-orbit{position:absolute;left:50%;top:48%;transform:translate(-50%,-50%);aspect-ratio:1;border-radius:50%;pointer-events:none}
.nh-orbit.o1{width:min(400px,92%)}
.nh-orbit.o2{width:min(500px,118%)}
.nh-orbit i{position:absolute;inset:0;border-radius:50%;border:1px dashed rgba(196,181,253,.32);animation:nh-spin 36s linear infinite reverse}
.nh-orbit.o2 i{border-color:rgba(224,64,251,.2);animation-duration:55s;animation-direction:normal}
.nh-orbit i:after{content:'';position:absolute;left:50%;top:-5px;width:10px;height:10px;margin-left:-5px;border-radius:50%;background:var(--cy);box-shadow:0 0 14px var(--cy)}
.nh-orbit.o2 i:after{background:var(--p1);box-shadow:0 0 14px var(--p1)}
.nh-ribbon{position:absolute;left:-8%;bottom:-6%;width:116%;height:46%;pointer-events:none;opacity:.85;z-index:0}
.nh-film{stroke-dasharray:6 12;animation:nh-film 2.2s linear infinite}
.nh-script{position:absolute;right:3%;top:0;z-index:3;font-family:'Kaushan Script',cursive;font-size:28px;line-height:1.05;text-align:right;
color:#e9d5ff;transform:rotate(-8deg);text-shadow:0 0 18px rgba(217,70,239,.65);animation:nh-bob 7s ease-in-out infinite}
.nh-fc{position:absolute;z-index:3;display:flex;align-items:center;gap:12px;padding:12px 16px;border-radius:16px;max-width:215px;
background:rgba(24,8,60,.62);border:1px solid var(--cc);box-shadow:0 0 22px rgba(var(--cr),.32);
backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);animation:nh-bob 6s ease-in-out infinite;
translate:calc(var(--px,0) * var(--k,10) * 1px) calc(var(--py,0) * var(--k,10) * .7px);transition:translate .3s ease-out}
.nh-fc-ico{color:var(--cc);display:grid;place-items:center;filter:drop-shadow(0 0 8px rgba(var(--cr),.9))}
.nh-fc b{display:block;font-size:22px;font-weight:700;line-height:1.1;color:var(--cc);text-shadow:0 0 14px rgba(var(--cr),.7)}
.nh-fc span{display:block;font-size:11px;line-height:1.3;color:#c9c1e6;margin-top:2px}
.nh-fc.c1{left:0;top:10%;--k:16}
.nh-fc.c2{right:0;top:30%;animation-delay:-1.5s;--k:-12}
.nh-fc.c3{left:2%;bottom:12%;animation-delay:-3s;--k:12}
.nh-fc.c4{right:3%;bottom:2%;animation-delay:-4.5s;--k:-16}

/* feature strip */
.nh-strip{position:relative;z-index:2;display:grid;grid-template-columns:repeat(4,minmax(0,1fr));border-radius:22px;overflow:hidden;
background:rgba(20,8,48,.58);border:1px solid rgba(168,85,247,.3);backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px)}
.nh-fs{position:relative;display:flex;gap:16px;align-items:center;padding:20px 22px;cursor:pointer;transition:background .25s}
.nh-fs+.nh-fs:before{content:'';position:absolute;left:0;top:22%;bottom:22%;width:1px;background:rgba(196,181,253,.22)}
.nh-fs:hover{background:rgba(var(--fr),.12)}
.nh-fs-ico{flex:0 0 auto;color:var(--fc);display:grid;place-items:center;filter:drop-shadow(0 0 10px rgba(var(--fr),.8));transition:transform .3s}
.nh-fs:hover .nh-fs-ico{animation:nh-tilt .8s ease-in-out infinite}
.nh-fs-t{min-width:0}
.nh-fs-t b{display:block;font-size:14.5px;font-weight:600;color:#fff;line-height:1.25}
.nh-fs-t span{display:block;font-size:12px;color:#b9b1d8;line-height:1.45;margin-top:4px}

/* footer of hero: progress dashes + scroll cue */
.nh-foot{position:relative;z-index:2;display:flex;align-items:center;justify-content:space-between;gap:20px}
.nh-dashes{display:flex;gap:10px}
.nh-dash{appearance:none;-webkit-appearance:none;border:0;padding:0;width:58px;height:4px;border-radius:4px;background:rgba(255,255,255,.2);
position:relative;overflow:hidden;cursor:pointer}
.nh-dash:after{content:'';position:absolute;inset:0;transform:scaleX(0);transform-origin:left;background:linear-gradient(90deg,var(--p1),var(--p3))}
.nh-dash.on:after{animation:nh-fill 6s linear forwards}
.nh-hero.hold .nh-dash.on:after{animation-play-state:paused}
.nh-scroll{display:flex;align-items:center;gap:12px;color:#cfc8ee;font-size:13px;cursor:pointer;transition:color .2s}
.nh-scroll:hover{color:#fff}
.nh-scroll-ar{display:inline-flex;animation:nh-bounce 1.6s ease-in-out infinite}

/* ---------------- stats with sparklines ---------------- */
.nh-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin-bottom:18px}
.nh-stat{position:relative;display:flex;align-items:flex-start;gap:14px;padding:20px 20px 52px;border-radius:20px;overflow:hidden;
background:linear-gradient(160deg,rgba(var(--sr),.16),rgba(12,5,38,.88) 72%);border:1px solid rgba(var(--sr),.42);
transition:transform .25s,box-shadow .25s}
.nh-stat:hover{transform:translateY(-4px);box-shadow:0 14px 36px rgba(var(--sr),.32)}
.nh-stat-ico{width:48px;height:48px;border-radius:50%;display:grid;place-items:center;flex:0 0 48px;color:var(--sc);
background:rgba(var(--sr),.14);border:1px solid rgba(var(--sr),.5);box-shadow:0 0 18px rgba(var(--sr),.4)}
.nh-stat-t{position:relative;z-index:1;min-width:0}
.nh-stat-t b{display:block;font-size:28px;font-weight:700;line-height:1.1;color:#fff;white-space:nowrap;text-shadow:0 0 16px rgba(var(--sr),.6)}
.nh-stat-t span{display:block;font-size:11px;letter-spacing:.16em;color:#b6aed6;text-transform:uppercase;margin-top:4px}
.nh-sp{position:absolute;left:0;bottom:0;width:100%;height:44px;clip-path:inset(0 100% 0 0)}
.nh-stat.in .nh-sp{animation:nh-wipe 1.7s .4s cubic-bezier(.4,0,.2,1) forwards}

/* ---------------- panels ---------------- */
.nh-main{display:grid;grid-template-columns:minmax(0,1.9fr) minmax(280px,1fr);gap:16px;margin-bottom:16px}
.nh-two{display:grid;grid-template-columns:minmax(0,1.55fr) minmax(0,1fr);gap:16px;margin-bottom:16px}
.nh-panel{padding:20px;border-radius:22px;background:linear-gradient(160deg,rgba(32,12,74,.6),rgba(10,4,30,.88));
border:1px solid rgba(168,85,247,.28);box-shadow:0 0 30px rgba(124,58,237,.12)}
.nh-ph{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:16px;padding-bottom:12px;border-bottom:1px solid rgba(168,85,247,.2)}
.nh-ph span{font-size:12.5px;font-weight:600;letter-spacing:.2em;color:#f3efff}
.nh-ph .nh-ph-sub{font-size:12px;font-weight:400;letter-spacing:.02em;color:#a79fcb}
.nh-ph a{font-size:12px;color:#c9c0ee!important;text-decoration:none!important}
.nh-ph a:hover{color:var(--p1)!important}
.nh-note{font-size:10.5px;color:#8f86b4;margin-top:8px}
.nh-sub3{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:14px}
.nh-box{padding:16px;border-radius:16px;background:rgba(255,255,255,.035);border:1px solid rgba(168,85,247,.2)}
.nh-box h5{margin:0 0 12px;font-size:13px;font-weight:600;color:#fff}
.nh-gb{margin:0 0 13px}
.nh-gb-top{display:flex;justify-content:space-between;font-size:12.5px;color:#e6e0ff;margin-bottom:5px}
.nh-gb-top b{color:#fff;font-weight:600}
.nh-gb-track{height:8px;border-radius:8px;background:rgba(255,255,255,.1);overflow:hidden}
.nh-gb-fill{height:100%;width:var(--w);border-radius:8px;transform-origin:left;background:linear-gradient(90deg,#7c3aed,#e040fb);box-shadow:0 0 10px rgba(224,64,251,.5)}
.nh-rv.in .nh-gb-fill{animation:nh-scalex 1.1s cubic-bezier(.2,.8,.2,1) backwards;animation-delay:calc(var(--i,0) * 110ms + 300ms)}
.nh-gb-note{font-size:10.5px;color:#8f86b4;margin-top:6px;line-height:1.5}

/* donut */
.nh-donut-box{position:relative;width:128px;height:128px;margin:0 auto 12px}
.nh-donut{width:100%;height:100%}
.nh-seg{transition:stroke-width .2s}
.nh-rv.in .nh-seg{animation:nh-seg 1.1s cubic-bezier(.2,.8,.2,1) backwards}
.nh-seg:hover{stroke-width:16}
.nh-donut-c{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center}
.nh-donut-c b{font-size:26px;font-weight:700;line-height:1;color:#fff}
.nh-donut-c span{font-size:9.5px;letter-spacing:.2em;color:#a79fcb;margin-top:3px}
.nh-legend{display:grid;gap:5px}
.nh-legend div{display:flex;align-items:center;gap:8px;font-size:12px;color:#d9d2f2}
.nh-lg-dot{width:9px;height:9px;border-radius:50%;flex:0 0 9px}
.nh-lg-n{flex:1}
.nh-legend b{color:#fff;font-weight:600}

/* bars: movies by year */
.nh-bars{display:flex;align-items:flex-end;gap:4px;height:130px}
.nh-bars i{flex:1;border-radius:4px 4px 2px 2px;height:var(--h);min-height:6px;background:linear-gradient(180deg,var(--p1),var(--p3));
box-shadow:0 0 10px rgba(168,85,247,.45);transform-origin:bottom;transition:filter .2s}
.nh-bars i:hover{filter:brightness(1.5)}
.nh-rv.in .nh-bars i{animation:nh-grow .9s cubic-bezier(.2,.8,.2,1) backwards;animation-delay:calc(var(--n,1) * 38ms + 250ms)}
.nh-axis{display:flex;justify-content:space-between;font-size:10px;color:#8f86b4;margin-top:7px;letter-spacing:.1em}

/* trending list */
.nh-tr{position:relative;display:flex;align-items:center;gap:12px;padding:10px 12px;border-radius:14px;margin-bottom:9px;cursor:pointer;overflow:hidden;
background:rgba(255,255,255,.04);border:1px solid rgba(168,85,247,.18);transition:transform .22s,border-color .22s,background .22s}
.nh-rv.in .nh-tr{animation:nh-slidein .6s cubic-bezier(.2,.8,.2,1) backwards;animation-delay:calc(var(--i,0) * 90ms + 200ms)}
.nh-tr:hover{transform:translateX(5px);border-color:var(--p1);background:rgba(168,85,247,.12)}
.nh-tr-rank{position:relative;z-index:2;width:30px;height:30px;flex:0 0 30px;border-radius:50%;display:grid;place-items:center;font-size:13px;font-weight:600;
color:#fff;border:1.5px solid rgba(255,255,255,.35)}
.nh-tr.first .nh-tr-rank{background:linear-gradient(135deg,#e040fb,#6366f1);border-color:transparent;box-shadow:0 0 14px rgba(224,64,251,.6)}
.nh-tr-t{position:relative;z-index:2;min-width:0;flex:1}
.nh-tr-t b{display:block;font-size:14px;font-weight:600;color:#fff;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.nh-tr-t span{display:block;font-size:11px;color:#b6aed6;margin-top:2px;white-space:pre}
.nh-tr-thumb{position:absolute;right:0;top:0;bottom:0;width:46%;z-index:1;opacity:.8;
-webkit-mask-image:linear-gradient(90deg,transparent,#000 62%);mask-image:linear-gradient(90deg,transparent,#000 62%);transition:transform .4s,opacity .3s}
.nh-tr:hover .nh-tr-thumb{transform:scale(1.08);opacity:1}
.nh-tr-thumb .photo-layer{position:absolute;inset:0}
.nh-tr-thumb .photo-layer-fb span{display:none}

/* moods + genres */
.nh-moods{display:grid;grid-template-columns:repeat(auto-fill,minmax(112px,1fr));gap:12px}
.nh-mood{position:relative;height:112px;border-radius:16px;cursor:pointer;overflow:hidden;padding:12px;display:flex;flex-direction:column;
justify-content:flex-end;background:linear-gradient(145deg,rgba(var(--mr),.55),rgba(10,4,30,.92) 85%);border:1px solid rgba(var(--mr),.55);
transition:transform .2s,box-shadow .25s}
.nh-rv.in .nh-mood,.nh-rv.in .nh-gen,.nh-rv.in .nh-way{animation:nh-pop .55s cubic-bezier(.2,.8,.2,1) backwards;animation-delay:calc(var(--i,0) * 70ms + 200ms)}
.nh-mood:hover{transform:translateY(-4px) scale(1.03);box-shadow:0 12px 30px rgba(var(--mr),.5)}
.nh-mood:after{content:'';position:absolute;top:0;left:-70%;width:40%;height:100%;transform:skewX(-20deg);
background:linear-gradient(100deg,transparent,rgba(255,255,255,.25),transparent);transition:left .6s}
.nh-mood:hover:after{left:130%}
.nh-mood-ico{position:absolute;right:-8px;top:-8px;width:76px;height:76px;display:grid;place-items:center;color:rgba(var(--mr),1);opacity:.28;animation:nh-tilt 7s ease-in-out infinite}
.nh-mood-ico svg{width:70px;height:70px}
.nh-mood-i2{color:#fff;margin-bottom:6px;filter:drop-shadow(0 0 8px rgba(var(--mr),1))}
.nh-mood b{font-size:13.5px;font-weight:600;color:#fff;position:relative}
.nh-mood small{font-size:10px;color:#d8d0f3;opacity:.85;position:relative;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.nh-gens{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px 8px}
.nh-gen{display:flex;flex-direction:column;align-items:center;gap:9px;cursor:pointer}
.nh-gen-ring{width:62px;height:62px;border-radius:50%;display:grid;place-items:center;color:var(--gc);
background:rgba(var(--gr),.1);border:1.5px solid var(--gc);box-shadow:0 0 18px rgba(var(--gr),.5),inset 0 0 12px rgba(var(--gr),.18);transition:transform .2s,box-shadow .25s}
.nh-gen:hover .nh-gen-ring{transform:translateY(-4px) scale(1.07);box-shadow:0 0 28px rgba(var(--gr),.85)}
.nh-gen span{font-size:12.5px;color:#e6e0ff}
.nh-gen small{font-size:10px;color:#9d94c4;margin-top:-6px}

/* explore your way */
.nh-ways{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px}
.nh-way{position:relative;display:flex;align-items:center;gap:14px;padding:18px;border-radius:18px;cursor:pointer;overflow:hidden;
background:linear-gradient(135deg,rgba(var(--wr),.22),rgba(12,5,38,.9) 78%);border:1px solid rgba(var(--wr),.4);transition:transform .22s,box-shadow .25s}
.nh-way:hover{transform:translateY(-4px);box-shadow:0 14px 34px rgba(var(--wr),.38)}
.nh-way-ico{flex:0 0 46px;height:46px;border-radius:14px;display:grid;place-items:center;color:var(--wc);background:rgba(var(--wr),.16);
border:1px solid rgba(var(--wr),.45);transition:box-shadow .25s,transform .25s}
.nh-way:hover .nh-way-ico{box-shadow:0 0 22px rgba(var(--wr),.8);transform:rotate(-6deg) scale(1.08)}
.nh-way-t{flex:1;min-width:0}
.nh-way-t b{display:block;font-size:14px;font-weight:600;color:#fff}
.nh-way-t span{display:block;font-size:11.5px;color:#b6aed6;margin-top:2px}
.nh-way-go{color:#fff;opacity:.7;display:inline-flex;transition:transform .2s,opacity .2s}
.nh-way:hover .nh-way-go{transform:translateX(5px);opacity:1}

/* ---------------- responsive ---------------- */
@media(max-width:1200px){.nh-stats,.nh-ways{grid-template-columns:repeat(2,minmax(0,1fr))}
.nh-main,.nh-two{grid-template-columns:1fr}.nh-strip{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:900px){.nh-hero{grid-template-columns:1fr;grid-template-areas:"copy" "art" "strip" "foot"}.nh-art{min-height:400px}}
@media(max-width:560px){.nh-stats,.nh-ways,.nh-strip{grid-template-columns:1fr}.nh-gens{grid-template-columns:repeat(2,1fr)}
.nh-scroll{display:none}.nh-fc{max-width:170px;padding:10px 12px}.nh-script{font-size:22px}}
@media(prefers-reduced-motion:reduce){
.nh *,.nh *:before,.nh *:after{animation:none!important}
.nh-sp{clip-path:none!important}.nh-js .nh-rv:not(.in){opacity:1}}
)---"

home_js <- r"---(
(function(){
  if (window.__mrHomeJs) { return; }
  window.__mrHomeJs = true;
  document.documentElement.classList.add('nh-js');
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function countUp(el){
    var to = parseFloat(el.getAttribute('data-count'));
    var dec = parseInt(el.getAttribute('data-dec') || '0', 10);
    var from = el.hasAttribute('data-from') ? parseFloat(el.getAttribute('data-from')) : 0;
    if (reduce || isNaN(to)) { return; }
    var t0 = null, dur = 1500;
    function step(ts){
      if (t0 === null) { t0 = ts; }
      var p = Math.min((ts - t0) / dur, 1), e = 1 - Math.pow(1 - p, 3);
      el.textContent = (from + (to - from) * e).toFixed(dec);
      if (p < 1) { window.requestAnimationFrame(step); } else { el.textContent = to.toFixed(dec); }
    }
    var dl = parseInt(el.getAttribute('data-delay') || '0', 10);
    setTimeout(function(){ window.requestAnimationFrame(step); }, dl);
  }

  var io = null;
  if ('IntersectionObserver' in window && !reduce) {
    io = new IntersectionObserver(function(entries){
      entries.forEach(function(e){
        if (!e.isIntersecting) { return; }
        var el = e.target;
        io.unobserve(el);
        if (el.classList.contains('nh-rv')) { el.classList.add('in'); }
        if (el.hasAttribute('data-count')) { countUp(el); }
      });
    }, {threshold: 0.12});
  }

  function initHero(){
    var root = document.querySelector('.nh-hero');
    if (!root || root.__ok) { return; }
    root.__ok = true;
    var slides = root.querySelectorAll('.nh-slide');
    var dashes = root.querySelectorAll('.nh-dash');
    var copy = root.querySelector('.nh-copy');
    var cur = 0, timer = null;
    function show(n){
      cur = (n + slides.length) % slides.length;
      Array.prototype.forEach.call(slides, function(s, i){ s.classList.toggle('on', i === cur); });
      Array.prototype.forEach.call(dashes, function(d, i){ d.classList.toggle('on', i === cur); });
    }
    function stop(){ if (timer) { clearInterval(timer); timer = null; } }
    function start(){
      stop();
      if (reduce) { return; }
      timer = setInterval(function(){
        if (!document.body.contains(root)) { stop(); return; }
        if (root.classList.contains('hold')) { return; }
        show(cur + 1);
      }, 6000);
    }
    Array.prototype.forEach.call(dashes, function(d, i){
      d.addEventListener('click', function(){ show(i); start(); });
    });
    if (copy) {
      copy.addEventListener('mouseenter', function(){ root.classList.add('hold'); });
      copy.addEventListener('mouseleave', function(){ root.classList.remove('hold'); });
    }
    start();
  }

  function scan(){
    var els = document.querySelectorAll('.nh-rv:not([data-o]),[data-count]:not([data-o])');
    Array.prototype.forEach.call(els, function(el){
      el.setAttribute('data-o', '1');
      if (io) { io.observe(el); } else { el.classList.add('in'); }
    });
    initHero();
  }
  var queued = false;
  new MutationObserver(function(){
    if (queued) { return; }
    queued = true;
    window.requestAnimationFrame(function(){ queued = false; scan(); });
  }).observe(document.documentElement, {childList: true, subtree: true});
  scan();
})();
)---"



pref_css <- r"---(
/* ===== site-wide slider look (gradient bar, glowing handle) ===== */
.irs--shiny{--g1:#7c3aed;--g2:#e040fb;--hc:168,85,247}
.irs--shiny .irs-line{background:rgba(255,255,255,.11)!important;border:0!important;height:9px;top:26px;border-radius:9px}
.irs--shiny .irs-bar{background:linear-gradient(90deg,var(--g1),var(--g2))!important;border:0!important;height:9px;top:26px;border-radius:9px;
box-shadow:0 0 14px rgba(var(--hc),.45)}
.irs--shiny .irs-handle{top:18px;width:25px;height:25px;border:0!important;border-radius:50%;
background:#f4f0ff!important;box-shadow:0 0 0 5px rgba(var(--hc),.32),0 0 16px rgba(var(--hc),.9)!important;transition:box-shadow .2s,transform .2s}
.irs--shiny .irs-handle:hover,.irs--shiny .irs-handle.state_hover{transform:scale(1.12);background:#fff!important;
box-shadow:0 0 0 7px rgba(var(--hc),.38),0 0 22px rgba(var(--hc),1)!important}
.irs--shiny .irs-handle>i{display:none}
.irs--shiny .irs-single,.irs--shiny .irs-from,.irs--shiny .irs-to{background:linear-gradient(135deg,#3b82f6,#6366f1)!important;color:#fff!important;
border-radius:999px;font-weight:600;font-size:12px;padding:2px 10px}
.irs--shiny .irs-single:before,.irs--shiny .irs-from:before,.irs--shiny .irs-to:before{display:none}
.irs--shiny .irs-min,.irs--shiny .irs-max{background:rgba(255,255,255,.08)!important;color:#c9c0ee!important;border-radius:999px}
.irs--shiny .irs-grid-text{color:#a79fcb!important;font-size:11px}
.irs--shiny .irs-grid-pol{background:rgba(255,255,255,.22)}

/* ===== Preferences page ===== */
.pf{font-family:'Poppins','Inter',system-ui,sans-serif;color:#f3efff;padding-bottom:24px}
.pf-hero{position:relative;display:flex;align-items:center;justify-content:space-between;gap:20px;min-height:200px;margin-bottom:18px;overflow:hidden}
.pf-copy{position:relative;z-index:2;max-width:760px}
.pf-kicker{font-size:11.5px;letter-spacing:.38em;color:#b9b1d8;margin-bottom:8px;animation:pf-in .7s both}
.pf-title{margin:0;font-weight:700;font-size:clamp(30px,3.6vw,54px);line-height:1.08;color:#fff;animation:pf-in .7s .1s both}
.pf-grad{background:linear-gradient(90deg,#c9a3ff,#a855f7,#e040fb,#6366f1,#c9a3ff);background-size:200% 100%;-webkit-background-clip:text;background-clip:text;
color:transparent;-webkit-text-fill-color:transparent;animation:pf-shine 7s linear infinite}
.pf-lead{max-width:600px;margin:12px 0 0;font-size:15.5px;line-height:1.6;color:#d6d0ee;animation:pf-in .7s .2s both}
.pf-art{position:absolute;right:-10px;top:-30px;width:300px;height:300px;z-index:1;pointer-events:none}
.pf-reel{position:absolute;inset:14%;filter:drop-shadow(0 0 28px rgba(168,85,247,.75));animation:pf-float 7s ease-in-out infinite}
.pf-reel svg{width:100%;height:100%;animation:pf-spin 24s linear infinite}
.pf-glow{position:absolute;inset:0;border-radius:50%;background:radial-gradient(circle,rgba(217,70,239,.35),transparent 65%);filter:blur(18px);animation:pf-pulse 4.5s ease-in-out infinite}
.pf-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
.pf-card{--g1:#7c3aed;--g2:#6366f1;--hc:139,92,246;--cr:139,92,246;position:relative;padding:20px 24px 18px;border-radius:20px;
background:linear-gradient(160deg,rgba(var(--cr),.12),rgba(10,5,30,.9) 70%);border:1px solid rgba(var(--cr),.3);
box-shadow:0 14px 40px rgba(0,0,0,.35);animation:pf-in .7s calc(var(--i) * 90ms + 250ms) both;transition:transform .25s,box-shadow .25s,border-color .25s}
.pf-card:hover{transform:translateY(-3px);border-color:rgba(var(--cr),.7);box-shadow:0 18px 44px rgba(var(--cr),.25)}
.pf-card.c1{--g1:#7c3aed;--g2:#6366f1;--hc:139,92,246;--cr:139,92,246}
.pf-card.c2{--g1:#ff2d78;--g2:#ff5c9a;--hc:255,77,141;--cr:255,77,141}
.pf-card.c3{--g1:#fb923c;--g2:#fbbf24;--hc:251,146,60;--cr:251,146,60}
.pf-card.c4{--g1:#10b981;--g2:#34d399;--hc:52,211,153;--cr:52,211,153}
.pf-card.c5{--g1:#6366f1;--g2:#22d3ee;--hc:56,189,248;--cr:99,102,241}
.pf-card.c6{--g1:#a855f7;--g2:#e040fb;--hc:168,85,247;--cr:168,85,247}
.pf-head{display:flex;align-items:center;gap:16px;margin-bottom:6px}
.pf-ico{flex:0 0 56px;height:56px;border-radius:16px;display:grid;place-items:center;color:rgb(var(--hc));
background:rgba(var(--cr),.16);border:1px solid rgba(var(--cr),.4);box-shadow:0 0 20px rgba(var(--cr),.35);transition:transform .3s}
.pf-card:hover .pf-ico{transform:rotate(-6deg) scale(1.08)}
.pf-t{flex:1;min-width:0}
.pf-t b{display:block;font-size:17px;font-weight:600;color:#fff}
.pf-t span{display:block;font-size:13px;color:#b9b1d8;margin-top:2px}
.pf-val{min-width:84px;text-align:center;padding:8px 18px;border-radius:12px;font-size:22px;font-weight:700;color:rgb(var(--hc));
background:rgba(var(--cr),.16);border:1px solid rgba(var(--cr),.5);box-shadow:0 0 16px rgba(var(--cr),.3);transition:transform .2s}
.pf-body .shiny-input-container{width:100%!important;margin:0!important}
.pf-body .form-group{margin-bottom:0}
.pf-card .irs{margin-top:2px}
.pf-card .irs--shiny .irs-single,.pf-card .irs--shiny .irs-min,.pf-card .irs--shiny .irs-max{display:none}
.pf-card.c5 .irs--shiny .irs-from,.pf-card.c5 .irs--shiny .irs-to{display:block}
.pf-body select,.pf-body .selectize-input{height:52px!important;border-radius:14px!important;font-size:16px!important;display:flex;align-items:center}
.pf-body .selectize-control{margin-top:6px}
.pf-foot{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-top:20px;animation:pf-in .7s .9s both}
.pf-status{flex:1;text-align:center;font-size:12.5px;color:#b9b1d8}
.pf-btn,.pf-btn.btn{display:inline-flex!important;align-items:center;gap:12px;height:58px;padding:0 32px!important;border-radius:999px!important;font-size:16px!important;
font-weight:600!important;cursor:pointer;position:relative;overflow:hidden;transition:transform .2s,box-shadow .25s}
.pf-btn.ghost{background:rgba(255,255,255,.04)!important;color:#fff!important;border:1.5px solid rgba(196,181,253,.45)!important}
.pf-btn.ghost:hover{transform:translateY(-2px);background:rgba(168,85,247,.18)!important;box-shadow:0 0 24px rgba(168,85,247,.4)}
.pf-btn.ghost:hover svg{animation:pf-spin .8s linear}
.pf-btn.primary{background:linear-gradient(90deg,#e040fb,#8b5cf6 55%,#4f6df5)!important;color:#fff!important;border:0!important;box-shadow:0 12px 34px rgba(168,85,247,.55)}
.pf-btn.primary:hover{transform:translateY(-3px);box-shadow:0 18px 46px rgba(217,70,239,.7)}
.pf-btn.primary:after{content:'';position:absolute;top:0;left:-60%;width:40%;height:100%;background:linear-gradient(100deg,transparent,rgba(255,255,255,.5),transparent);
transform:skewX(-20deg);animation:pf-sweep 4s ease-in-out infinite}
@keyframes pf-in{from{opacity:0;transform:translateY(22px)}}
@keyframes pf-shine{to{background-position:200% 0}}
@keyframes pf-spin{to{transform:rotate(360deg)}}
@keyframes pf-float{50%{transform:translateY(-12px)}}
@keyframes pf-pulse{50%{opacity:.5;transform:scale(1.08)}}
@keyframes pf-sweep{0%,60%{left:-60%}100%{left:140%}}
@media(max-width:1000px){.pf-grid{grid-template-columns:1fr}.pf-art{opacity:.35}}
@media(max-width:560px){.pf-foot{flex-direction:column}.pf-btn{width:100%;justify-content:center}.pf-val{font-size:18px;min-width:64px}}
@media(prefers-reduced-motion:reduce){.pf *,.pf-card{animation:none!important}}
)---"

pref_js <- r"---(
$(document).on('shiny:inputchanged', function(e){
  var el = document.querySelector('.pf-val[data-for="' + e.name + '"]');
  if (el && e.value !== null && e.value !== undefined) { el.textContent = e.value + (el.getAttribute('data-suf') || ''); }
});
)---"

page_reco <- function() {
  tabPanelBody("Recommendations",
    page_head("Recommendations", "Pick a movie you like. The engine returns the closest matches using the hybrid model (genre cosine similarity + rating-pattern similarity)."),
    card(
      h3("Hybrid Recommendation Engine"),
      selectizeInput("movie", "Select Movie", title_choices, selected = "Vikram"),
      fluidRow(
        column(4, sliderInput("n", "Recommendations", 5, 15, 10)),
        column(4, sliderInput("cw", "Content Weight", 0, 1, .5, .1)),
        column(4, sliderInput("mrating", "Minimum Rating", 0, 9, 0, .5))),
      fluidRow(
        column(4, sliderInput("ymin", "Minimum Year", 2007, 2026, 2007, sep = "")),
        column(4, sliderInput("ymax", "Maximum Year", 2007, 2026, 2026, sep = "")),
        column(4, selectInput("gfilter", "Genre", c("All", all_genres)))),
      actionButton("rec", HTML("GENERATE RECOMMENDATIONS"), class = "gold")),
    uiOutput("reco_cards"),
    card(h3("Result table"), tableOutput("rectable"), br(),
         downloadButton("csv", "Download CSV")),
    card(h3("Why was the top movie recommended?"), uiOutput("why")),
    card(h3("Save selected movie"),
         actionButton("add", "Add to Favorites"), br(), br(), textOutput("favmsg"))
  )
}

page_foryou <- function() {
  tabPanelBody("ForYou",
    page_head("Personalized For You", "Recommendations built from your favorites, watchlist and ratings in this session. With nothing saved yet, the catalog's top-rated movie is used as the starting point."),
    card(radioButtons("fy_top", "How many?", c("Top 5" = 5, "Top 10" = 10, "Top 20" = 20), selected = 5, inline = TRUE),
         uiOutput("fy_info")),
    uiOutput("fy_cards")
  )
}

page_trending <- function() {
  tabPanelBody("Trending",
    page_head("Trending Movies", "Cinematic rankings computed inside this app."),
    note_box(HTML("<b>Application / demo rankings.</b> These are computed from the catalog rating, release year and the 50 synthetic demo users. They are not live real-world popularity data.")),
    uiOutput("trend_ui")
  )
}

page_newrel <- function() {
  tabPanelBody("NewReleases",
    page_head("New Releases", "Newest films in the dataset, sorted by release year."),
    card(sliderInput("nr_n", "How many to show", 6, 60, 24, 6), uiOutput("nr_ui"))
  )
}

page_gems <- function() {
  tabPanelBody("Gems",
    page_head("Hidden Gems", "Strong ratings, lower profile."),
    note_box(HTML("<b>Computed in-app.</b> Hidden Gems = movies rated 7.5 or higher in the dataset that have a low popularity score (few demo-user ratings and rarely appear in other movies' Top-10). It is not an external popularity ranking.")),
    card(uiOutput("gems_ui"))
  )
}

page_surprise <- function() {
  tabPanelBody("Surprise",
    page_head("Surprise Me", "Let the engine pick something worth watching."),
    card(actionButton("surprise", HTML("SURPRISE ME"), class = "gold big-surprise"),
         uiOutput("surprise_ui"))
  )
}

page_mood <- function() {
  tabPanelBody("Mood",
    page_head(HTML("MOOD STUDIO"), "Choose a mood. Moods are mapped to genres that exist in the catalog - they are not a detected emotional state."),
    card(uiOutput("mood_chips"), uiOutput("mood_cards"))
  )
}

page_genres <- function() {
  tabPanelBody("Genres",
    page_head("Genre Explorer", "Tap a genre to see its movies."),
    card(uiOutput("genre_chips"),
         fluidRow(column(4, selectInput("gx_sort", "Sort by", c("Highest rated", "Newest", "A-Z")))),
         uiOutput("genre_cards"))
  )
}

page_taste <- function() {
  tabPanelBody("Taste",
    page_head("Taste Profile", "Calculated from your favorites (weight 1), watchlist (0.5) and ratings (3+ stars) in this session."),
    uiOutput("taste_ui")
  )
}

page_prefs <- function() {
  pcard <- function(i, cls, ico, title, sub, val = NULL, ...) {
    div(class = paste("pf-card", cls), style = sprintf("--i:%d", i),
        div(class = "pf-head",
            span(class = "pf-ico", ic(ico, 28)),
            div(class = "pf-t", tags$b(title), tags$span(sub)),
            val),
        div(class = "pf-body", ...))
  }
  pval <- function(id, txt, suf = "") span(class = "pf-val", `data-for` = id, `data-suf` = suf, txt)
  tabPanelBody("Prefs",
    div(class = "pf",
        div(class = "pf-hero",
            div(class = "pf-copy",
                div(class = "pf-kicker", "PERSONALIZE YOUR EXPERIENCE"),
                tags$h2(class = "pf-title", span("Set Your"), tags$br(), span(class = "pf-grad", "Recommendation Preferences")),
                tags$p(class = "pf-lead", "Adjust the importance of each factor to get movie recommendations that match your taste.")),
            div(class = "pf-art", div(class = "pf-reel", HTML(nh_reel_svg)), div(class = "pf-glow"))),
        div(class = "pf-grid",
            pcard(0, "c1", "film", "Content Weight", "Focus on genre, keywords and storyline", pval("pref_cw", "70%"),
                  sliderInput("pref_cw", NULL, 0, 100, 70, 5, post = "%", width = "100%")),
            pcard(1, "c2", "star", "Rating Pattern Weight", "Focus on your rating behaviour", pval("pref_kw", "30%"),
                  sliderInput("pref_kw", NULL, 0, 100, 30, 5, post = "%", width = "100%")),
            pcard(2, "c3", "trophy", "Top N Recommendations", "Number of movies to show", pval("pref_n", "10"),
                  sliderInput("pref_n", NULL, 3, 20, 10, width = "100%")),
            pcard(3, "c4", "star", "Minimum Rating", "Show only movies above this rating", pval("pref_min", "0"),
                  sliderInput("pref_min", NULL, 0, 9, 0, .5, width = "100%")),
            pcard(4, "c5", "calendar", "Year Range", "Select release year range", NULL,
                  sliderInput("pref_years", NULL, 2007, 2026, c(2007, 2026), sep = "", width = "100%")),
            pcard(5, "c6", "smile", "Genre", "Choose your preferred genre", NULL,
                  selectInput("pref_genre", NULL, c("All Genres" = "All", all_genres), width = "100%"))),
        div(class = "pf-foot",
            actionButton("pref_reset", tagList(ic("sliders", 18), "Reset to Default"), class = "pf-btn ghost"),
            div(class = "pf-status", textOutput("pref_status")),
            actionButton("pref_gen", tagList(ic("spark", 18), "Generate Recommendations", ic("arrow", 18)), class = "pf-btn primary")))
  )
}

page_mymovies <- function() {
  tabPanelBody("MyMovies",
    page_head("My Movies", "Everything you have saved or viewed in this session."),
    div(class = "mm-tabs",
        tabsetPanel(
          id = "mm_tabs",
          tabPanel("Favorites", value = "fav", br(), uiOutput("mm_fav")),
          tabPanel("Watchlist", value = "watch", br(), uiOutput("mm_watch")),
          tabPanel("Recently Viewed", value = "recent", br(), uiOutput("mm_recent")),
          tabPanel("Watch History", value = "hist", br(), uiOutput("mm_hist")),
          tabPanel("My Ratings", value = "ratings", br(), uiOutput("mm_ratings")))),
    card(h3("Export (CSV)"),
         div(class = "btn-row",
             downloadButton("dl_recs", "Recommendations CSV"),
             downloadButton("dl_favs", "Favorites CSV"),
             downloadButton("dl_watch", "Watchlist CSV"),
             downloadButton("dl_hist", "Recommendation History CSV")))
  )
}

page_explorer <- function() {
  tabPanelBody("Explorer",
    page_head("Movie Explorer", "Browse and search the 120-movie catalog (Tamil films, 2007-2026)."),
    card(textInput("search", "Search Movie", placeholder = "Type a movie name..."),
         fluidRow(
           column(3, selectInput("egenre", "Genre", c("All", all_genres))),
           column(3, sliderInput("erating", "Minimum Rating", 0, 9, 0, .5)),
           column(3, sliderInput("eyear", "From Year", 2007, 2026, 2007, sep = "")),
           column(3, selectInput("esort", "Sort By", c("Highest Rated", "Newest", "A-Z"))))),
    card(h3("Browse"), uiOutput("explorecards")),
    card(h3("Full Results"), tableOutput("exploretable"))
  )
}

page_advanced <- function() {
  tabPanelBody("Advanced",
    page_head("Advanced Search", "Combine filters, then press Apply Filters."),
    card(
      fluidRow(
        column(4, textInput("adv_q", "Movie search", placeholder = "Title contains...")),
        column(4, selectInput("adv_genre", "Genre", c("All", all_genres))),
        column(4, selectInput("adv_sort", "Sort by", c("Rating", "Year", "Title", "Recommendation Score")))),
      fluidRow(
        column(4, sliderInput("adv_years", "Year range", 2007, 2026, c(2007, 2026), sep = "")),
        column(4, sliderInput("adv_rmin", "Minimum rating", 0, 10, 0, .1)),
        column(4, sliderInput("adv_rmax", "Maximum rating", 0, 10, 10, .1))),
      actionButton("adv_apply", "APPLY FILTERS", class = "gold"),
      actionButton("adv_reset", "RESET FILTERS", class = "ghost-btn"),
      p(class = "muted", style = "font-size:10.5px;margin-top:10px",
        "Recommendation Score = hybrid score against your reference profile (your favorites/high ratings, or the catalog's top-rated movie if none).")),
    uiOutput("adv_count"),
    card(uiOutput("adv_cards"))
  )
}

page_compare <- function() {
  tabPanelBody("Compare",
    page_head("Compare Movies", "Side by side, plus a Movie Match % based on genre cosine similarity."),
    card(fluidRow(
      column(6, selectInput("a", "Movie A", title_choices, selected = "Vikram")),
      column(6, selectInput("b", "Movie B", title_choices, selected = "Kaithi")))),
    card(fluidRow(
      column(5, uiOutput("cardA")),
      column(2, div(style = "text-align:center;font-size:26px;color:var(--acc);padding-top:120px;font-weight:900", "VS")),
      column(5, uiOutput("cardB"))),
      uiOutput("comparebar")),
    card(h3("Details"), tableOutput("comparetable"), plotOutput("compareplot", height = "300px"))
  )
}

page_battle <- function() {
  tabPanelBody("Battle",
    page_head(HTML("MOVIE BATTLE"), "Pick two movies and a metric. The winner is decided on that metric."),
    card(fluidRow(
      column(4, selectInput("bt_a", "Movie A", title_choices, selected = "Vikram")),
      column(4, selectInput("bt_b", "Movie B", title_choices, selected = "Kaithi")),
      column(4, selectInput("bt_metric", "Winner decided by",
                            c("Rating", "Year (newest)", "Content similarity", "Rating-pattern similarity", "Hybrid score"),
                            selected = "Rating"))),
      actionButton("bt_go", HTML("FIGHT"), class = "gold")),
    uiOutput("bt_ui")
  )
}

page_details <- function() {
  tabPanelBody("Details",
    page_head("Movie Details"),
    card(selectizeInput("det_movie", "Select movie", title_choices, selected = "Leo")),
    uiOutput("det_ui"),
    card(h3("Rate this movie"),
         fluidRow(column(4, selectInput("det_rate", "Your rating (1-5)", 5:1, selected = 4)),
                  column(8, div(style = "padding-top:25px",
                                actionButton("det_rate_btn", "RATE MOVIE", class = "gold"),
                                actionButton("det_watched", "MARK AS WATCHED", class = "ghost-btn"))))),
    card(h3("Similar movies"), uiOutput("det_similar"))
  )
}

page_an_movies <- function() {
  tabPanelBody("AnMovies",
    page_head("Movie Analytics", "Summary of the 120-movie dataset."),
    uiOutput("anm_stats"),
    card(h3("Movies per year"), plotOutput("anm_year", height = "340px"))
  )
}
page_an_genres <- function() {
  tabPanelBody("AnGenres",
    page_head("Genre Analytics"),
    div(class = "two-col",
        card(h3("Genre distribution"), plotOutput("ang_dist", height = "340px")),
        card(h3("Average rating by genre"), plotOutput("ang_avg", height = "340px"))),
    card(h3("Most common genre combinations"), tableOutput("ang_combo"))
  )
}
page_an_ratings <- function() {
  tabPanelBody("AnRatings",
    page_head("Rating Analytics"),
    uiOutput("anr_stats"),
    card(h3("Rating distribution"), plotOutput("anr_hist", height = "340px")),
    card(h3("Top-rated movies"), uiOutput("anr_top"))
  )
}
page_an_years <- function() {
  tabPanelBody("AnYears",
    page_head("Year Trends"),
    div(class = "two-col",
        card(h3("Movies per year"), plotOutput("any_count", height = "340px")),
        card(h3("Average rating by year"), plotOutput("any_avg", height = "340px")))
  )
}
page_an_reco <- function() {
  tabPanelBody("AnReco",
    page_head("Recommendation Analytics", "How the model behaves across the whole catalog (50/50 hybrid)."),
    note_box(HTML("Scores are averaged over every other movie used as a seed. Rating-pattern scores come from <b>synthetic demonstration data</b>, so they illustrate the method rather than real viewer behaviour.")),
    card(h3("Most recommended movies (appearances in other movies' Top-10)"), uiOutput("anx_cards")),
    card(h3("Component scores"), tableOutput("anx_table")),
    div(class = "two-col",
        card(h3("Content vs rating-pattern vs hybrid"), plotOutput("anx_components", height = "380px")),
        card(h3("Average hybrid score"), plotOutput("anx_hybrid", height = "380px"))),
    div(class = "two-col",
        card(h3("Content similarity distribution"), plotOutput("anx_hist_c", height = "300px")),
        card(h3("Rating-pattern similarity distribution"), plotOutput("anx_hist_k", height = "300px"))),
    card(h3("Your recommendation history"), tableOutput("histtable"))
  )
}

page_lab <- function() {
  tabPanelBody("Lab",
    page_head("Recommendation Lab - Hybrid Model", "Change the weights, press RUN MODEL, and the same recommendation logic is re-run."),
    card(
      selectizeInput("lab_movie", "Seed movie", title_choices, selected = "Vikram"),
      fluidRow(
        column(6, sliderInput("lab_cw", "Content Weight (%)", 0, 100, 70, 5, post = "%")),
        column(6, sliderInput("lab_kw", "Rating Pattern Weight (%)", 0, 100, 30, 5, post = "%"))),
      fluidRow(
        column(4, sliderInput("lab_n", "Top N", 3, 20, 8)),
        column(4, sliderInput("lab_min", "Minimum Rating", 0, 9, 0, .5)),
        column(4, sliderInput("lab_years", "Year Range", 2007, 2026, c(2007, 2026), sep = ""))),
      actionButton("lab_run", HTML("&#9654; RUN MODEL"), class = "gold"),
      uiOutput("lab_bars")),
    uiOutput("lab_results"),
    card(h3("Explain score"), uiOutput("labexplain")),
    card(h3("Weight sensitivity"), plotOutput("weightplot", height = "380px"))
  )
}

page_content <- function() {
  tabPanelBody("Content",
    page_head("Content Similarity", "Movies are described by a 0/1 genre vector. Similarity between two movies is the cosine of the angle between their vectors."),
    card(HTML(paste0(
      "<b>Genre feature matrix</b> - one row per movie, one column per genre (",
      length(all_genres), " genres). <b>Cosine similarity</b> = (A . B) / (|A| x |B|); 1 means identical genre mix, 0 means nothing in common.")),
      br(), br(),
      selectizeInput("ci_movie", "Select movie", title_choices, selected = "Vikram"),
      sliderInput("ci_n", "Most similar movies to show", 4, 16, 8),
      h4(style = "color:var(--acc);font-size:13px", "Genre vector of the selected movie"),
      tableOutput("ci_matrix")),
    uiOutput("ci_results")
  )
}

page_collab <- function() {
  tabPanelBody("Collab",
    page_head("Collaborative (Rating-Pattern) Similarity", "Two movies are similar when the same demo users rate them in a similar way."),
    note_box(HTML("This is cosine similarity between movie rows of the 50-user <b>synthetic demonstration</b> rating matrix. It is a rating-pattern method; it is <b>not</b> a formal UBCF/IBCF or matrix-factorization model.")),
    card(selectizeInput("co_movie", "Select movie", title_choices, selected = "Vikram"),
         sliderInput("co_n", "Similar movies to show", 4, 16, 8)),
    uiOutput("co_results")
  )
}

page_explain <- function() {
  tabPanelBody("Explain",
    page_head("Explain Recommendation", "See exactly how a recommendation score is built."),
    card(fluidRow(
      column(4, selectizeInput("ex_seed", "You liked", title_choices, selected = "Vikram")),
      column(4, selectInput("ex_target", "Explain why this was recommended", choices = NULL)),
      column(4, sliderInput("ex_w", "Content weight", 0, 1, .5, .1)))),
    uiOutput("ex_ui")
  )
}

page_model <- function() {
  tabPanelBody("Model",
    page_head("Model Analysis", "Technical description of the recommender used in this app."),
    card(h3("Pipeline"),
         div(class = "pipe",
             lapply(list(
               c("USER", "chooses a movie, or a profile of favorites"),
               c("MOVIE DATA", "120 Tamil movies: genres, year, rating"),
               c("FEATURE EXTRACTION", "genre -> 0/1 feature matrix"),
               c("CONTENT SIMILARITY", "cosine similarity between genre vectors"),
               c("RATING-PATTERN SIMILARITY", "cosine similarity between rating vectors (synthetic demo users)"),
               c("NORMALIZATION", "min-max scaling to 0-1 for each score"),
               c("HYBRID SCORE", "w x content + (1 - w) x rating-pattern"),
               c("TOP-N RANKING", "sort, filter by rating/year/genre, keep N"),
               c("RECOMMENDATION", "poster cards with scores and reasons")),
               function(s) tagList(
                 div(class = "pipe-step", s[1], tags$small(s[2])),
                 if (s[1] != "RECOMMENDATION") div(class = "pipe-arrow", HTML("&#8595;")))))),
    card(h3("What each stage does"), uiOutput("model_text")),
    card(h3("Score summary (50/50 hybrid, all seeds)"), tableOutput("model")),
    card(h3(HTML("Data Simulator <span class='demo-tag'>SYNTHETIC DEMONSTRATION DATA</span>")),
         p(class = "muted", "Generate a fresh demonstration rating matrix and see the rating-pattern similarity it produces. These are random, not real users, and the main recommendation model is not changed by this tool."),
         fluidRow(
           column(3, sliderInput("sim_users", "Number of users", 10, 500, 50, 10)),
           column(3, sliderInput("sim_density", "Rating density (%)", 5, 90, 55, 5, post = "%")),
           column(3, numericInput("sim_seed", "Random seed", 123, min = 1, step = 1)),
           column(3, selectizeInput("sim_movie", "Movie", title_choices, selected = "Vikram"))),
         actionButton("sim_run", "GENERATE DEMO DATA", class = "gold"),
         uiOutput("sim_summary"),
         plotOutput("sim_plot", height = "280px"),
         uiOutput("sim_cards")),
    card(h3(HTML("Model Evaluation <span class='demo-tag'>HOLD-OUT TEST ON SYNTHETIC DATA</span>")),
         p(class = "muted", "Hide a share of the demo ratings, predict them back with the model, and measure the error. ",
           "Lower RMSE and MAE mean better predictions."),
         fluidRow(
           column(3, sliderInput("ev_frac", "Hidden ratings (%)", 10, 40, 20, 5, post = "%")),
           column(3, sliderInput("ev_k", "Neighbours (k)", 3, 30, 10, 1)),
           column(3, sliderInput("ev_w", "Content weight (hybrid)", 0, 1, .5, .1)),
           column(3, numericInput("ev_seed", "Random seed", 42, min = 1, step = 1))),
         actionButton("ev_run", "RUN EVALUATION", class = "gold"),
         uiOutput("ev_summary"),
         tableOutput("ev_table"),
         plotOutput("ev_plot", height = "340px"))
  )
}

page_top <- function() {
  tabPanelBody("TopRated",
    page_head("Top Rated", "Highest-rated movies in the dataset."),
    card(sliderInput("tr_n", "How many", 6, 36, 12, 6), uiOutput("top_ui")))
}
page_popular <- function() {
  tabPanelBody("Popular",
    page_head("Popular Movies"),
    note_box(HTML("<b>Application-based popularity.</b> Score = 50% share of demo-user ratings + 50% frequency in other movies' Top-10 recommendations. Synthetic demonstration data; not real-world popularity.")),
    card(uiOutput("pop_ui")))
}
page_critics <- function() {
  tabPanelBody("Critics",
    page_head("Critics' Picks"),
    note_box(HTML("<b>Curated in-app category.</b> Includes movies tagged \"Critics Pick\" in this app's catalog plus every movie rated 8.5 or higher. These are not actual critics' scores from any publication.")),
    card(uiOutput("crit_ui")))
}
page_fans <- function() {
  tabPanelBody("Fans",
    page_head("Fan Favorites"),
    note_box(HTML("<b>Computed from application interactions.</b> Score = demo users who gave 4 or 5 stars, plus a bonus for movies you favorited in this session.")),
    card(uiOutput("fan_ui")))
}
page_leader <- function() {
  tabPanelBody("Leaderboard",
    page_head("Leaderboard", "Application data only."),
    uiOutput("lb_ui"))
}

page_feedback <- function() {
  reactions <- list(
    list(v = "Not useful", e = ic("sad", 26)),
    list(v = "Somewhat useful", e = ic("neutral", 26)),
    list(v = "Very useful", e = ic("smile", 26)))
  stand_out <- c("Accurate picks", "Real posters", "Fresh discoveries", "Clear explanations",
                 "Easy to use", "Too similar", "Missing movies", "Felt slow")
  sec <- function(n, title, hint, ...) {
    div(class = "fb2-sec",
        div(class = "fb2-num", n),
        div(class = "fb2-head", tags$h4(title), tags$p(hint)),
        div(class = "fb2-body", ...))
  }
  tabPanelBody("Feedback",
    page_head("Feedback", "Help us improve MOVIEREC. Your response is stored for this session only."),
    div(class = "fb2",
        div(class = "fb2-form",
            sec("1", "Overall rating", "How would you rate your experience?",
                div(class = "fb-stars",
                    lapply(1:5, function(i) span(class = "fb-star", `data-v` = i,
                                                 onclick = sprintf("mrStar(%d)", i), HTML("&#9733;")))),
                div(class = "fb-hint", id = "fb_star_hint", "Select a rating")),
            sec("2", "Recommendation quality", "Were the recommendations useful to you?",
                div(class = "fb-react-row",
                    lapply(reactions, function(r)
                      div(class = "fb-react", `data-v` = r$v, onclick = sprintf("mrReact('%s')", r$v),
                          span(class = "e", r$e), r$v)))),
            sec("3", "What stood out?", "Select all that apply.",
                div(class = "fb-tags",
                    lapply(stand_out, function(t) div(class = "fb-tag", onclick = "mrTag(this)", t)))),
            sec("4", "Details", "Tell us which part you are rating and add any comments.",
                selectInput("fb_feature", NULL,
                            c("Overall app", "Recommendations", "Posters and design",
                              "Explanations", "Mood Studio", "Hybrid Lab"), width = "100%"),
                textAreaInput("fb_comment", NULL, width = "100%",
                              placeholder = "What worked well? What could be better?")),
            div(class = "fb2-submit",
                actionButton("fb_submit", "Submit feedback", class = "gold"))),
        div(class = "fb2-side",
            uiOutput("fb_summary"),
            uiOutput("fb_wall")))
  )
}

page_settings <- function() {
  tabPanelBody("Settings",
    page_head("Settings"),
    card(h3("Appearance and defaults"),
         fluidRow(
           column(3, selectInput("set_theme", "Theme accent", c("Gold (default)" = "theme-gold", "Crimson" = "theme-crimson",
                                                                "Emerald" = "theme-emerald", "Violet" = "theme-violet"))),
           column(3, sliderInput("set_n", "Number of recommendations", 3, 20, 10)),
           column(3, selectInput("set_genre", "Default genre", c("All", all_genres))),
           column(3, sliderInput("set_weight", "Default content weight", 0, 1, .5, .1))),
         actionButton("set_apply", "APPLY SETTINGS", class = "gold"),
         p(class = "muted", style = "font-size:10.5px;margin-top:10px", "The dark cinematic base is always kept; the theme only changes the accent color.")),
    card(h3("Profile"), uiOutput("profile_ui")),
    card(h3("Export"),
         p(class = "muted", "CSV files for this session."),
         div(class = "btn-row",
             downloadButton("dl_recs", "Recommendations CSV"),
             downloadButton("dl_favs", "Favorites CSV"),
             downloadButton("dl_watch", "Watchlist CSV"),
             downloadButton("dl_hist", "Recommendation History CSV")))
  )
}

page_about <- function() {
  methods <- list(
    list("reel", "Genre feature matrix", "Every movie becomes a 0/1 vector over the genres in the catalog."),
    list("compass", "Cosine similarity", "Compares two genre vectors: 1 means the same genre mix, 0 means nothing in common."),
    list("foryou", "Rating-pattern similarity", "Compares how the same demo users rated two movies, using cosine similarity."),
    list("sliders", "Min-max normalization", "Rescales every similarity vector to 0-1 so the two scores can be combined fairly."),
    list("flask", "Hybrid scoring", "Final score = w x content + (1 - w) x rating pattern, with w set by you."),
    list("trophy", "Top-N ranking", "Filters by rating, year and genre, sorts by hybrid score and returns the best N."),
    list("chart", "Hold-out evaluation", "Hides some demo ratings, predicts them back and reports RMSE and MAE (see Model Analysis)."))
  tabPanelBody("About",
    page_head("About MOVIEREC", "Kollywood Movie Intelligence"),
    card(
      h3("What this is"),
      p("An explainable hybrid movie recommendation and analytics platform for Tamil cinema, built with R and Shiny."),
      h3("Data"),
      p("120 embedded Tamil movies released 2007-2026 and 50 generated demonstration user-rating patterns (synthetic; not real users)."),
      h3("Posters"),
      p("Posters are loaded once from local files in www/posters/, an optional poster_cache.csv and a short list of verified direct URLs. Posters belong to their respective owners.")),
    card(h3("Methods used"),
         div(class = "methods",
             lapply(methods, function(m)
               div(class = "method",
                   span(class = "m-ico", ic(m[[1]], 22)),
                   div(tags$b(m[[2]]), tags$p(m[[3]]))))),
         note_box("Ratings used for rating-pattern similarity and for evaluation are synthetic demonstration data.")),
    card(h3("Ideas for later"),
         tags$ul(tags$li("A larger real-world rating dataset"), tags$li("Real user profiles"),
                 tags$li("Evaluation on real user ratings"), tags$li("Cloud deployment"))),
    card(h3("Poster validation"), uiOutput("poster_validation"))
  )
}

main_ui <- function(user, theme_class = "") {
  initial <- toupper(substr(if (nzchar(user)) user else "G", 1, 1))
  div(
    class = paste("cinema", theme_class),
    cinema_backdrop(),
    div(
      class = "sidebar",
      brand_banner(),
      sidebar_nav(),
      div(class = "acct", id = "acct",
          div(class = "acct-menu",
              div(class = "acct-label", paste("Signed in as", user)),
              div(class = "acct-item", onclick = "mrNav('Feedback');mrAcctClose()", ic("chat", 18), "Feedback"),
              div(class = "acct-item danger",
                  onclick = "Shiny.setInputValue('logout', Date.now(), {priority:'event'})",
                  ic("logout", 18), "Logout")),
          div(class = "acct-btn", onclick = "mrAcct(event)",
              div(class = "acct-av", initial),
              div(class = "acct-name", tags$b(user), tags$small("MOVIEREC MEMBER")),
              span(class = "acct-chev", ic("chevron", 16))))
    ),
    div(
      class = "main",
      div(class = "top",
          div(class = "toptabs",
              div(class = "toptab home active", `data-page` = "Dashboard", onclick = "mrNav('Dashboard')",
                  ic("home", 20), "Home")),
          div(class = "bg-picker",
              lapply(c("crimson", "nebula", "aurora", "sunset", "midnight"), function(b)
                div(class = paste("bgdot", b, if (b == "crimson") "on" else ""), title = paste(b, "theme"),
                    onclick = sprintf("mrBg('%s')", b)))),
          div(class = "top-right",
              div(class = "topbar-search",
                  span(class = "t-ico", ic("search", 16)),
                  textInput("topsearch", NULL, placeholder = "Search movies...")),
              div(class = "avatar-chip", title = user, div(class = "av-circle", initial)))),
      tags$script(HTML("try{var b=localStorage.getItem('mr_bg'); if(b){mrBg(b);}}catch(e){}")),
      tags$script(HTML(
        "if(!window.__mrTopSearch){window.__mrTopSearch=1;
         document.addEventListener('keydown',function(e){
           if(e.key==='Enter'&&e.target&&e.target.id==='topsearch'){
             Shiny.setInputValue('topsearch_go', e.target.value, {priority:'event'});
           }});}")),
      tabsetPanel(
        id = "tabs", type = "hidden",
        page_dashboard(), page_reco(), page_foryou(), page_trending(), page_newrel(), page_gems(),
        page_surprise(), page_mood(), page_genres(), page_prefs(),
        page_explorer(), page_compare(), page_mymovies(),
        page_top(), page_popular(), page_fans(), page_leader(),
        page_lab(), page_explain(), page_model(), page_an_reco(),
        page_feedback(), page_about(),
        # opened from the "Details" button on any poster card
        page_details()),
      div(class = "footer",
          tags$b(HTML("MOVIEREC")), br(),
          "Kollywood Movie Intelligence", br(),
          "Discover  -  Recommend  -  Analyze", br(),
          "R / Shiny  -  Posters belong to their respective owners")
    )
  )
}

# --------------------------- UI ------------------------------
ui <- fluidPage(
  tags$head(
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = "anonymous"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Anton&family=Bebas+Neue&family=Kaushan+Script&family=Permanent+Marker&family=Poppins:wght@400;500;600;700;800&display=swap"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    tags$style(HTML(cinema_css)),
    tags$style(HTML(login_css)),
    tags$style(HTML(login_neon_css)),
    tags$style(HTML(lg_css)),
    tags$script(HTML(lg_js)),
    tags$style(HTML(extra_css)),
    tags$style(HTML(home_css)),
    tags$script(HTML(mr_js)),
    tags$script(HTML(home_js)),
    tags$style(HTML(pref_css)),
    tags$script(HTML(pref_js))
  ),
  uiOutput("app")
)

# ============================================================
# SERVER
# ============================================================
server <- function(input, output, session) {
  
  # ---------------- session state ----------------
  logged_in    <- reactiveVal(FALSE)
  current_user <- reactiveVal("")
  favorites    <- reactiveVal(integer(0))     # movie_ids
  watchlist    <- reactiveVal(integer(0))
  viewed       <- reactiveVal(integer(0))     # most recent first
  user_ratings <- reactiveVal(data.frame(movie_id = integer(), rating = numeric(),
                                         time = character(), stringsAsFactors = FALSE))
  activity     <- reactiveVal(data.frame(time = character(), action = character(),
                                         movie_id = integer(), stringsAsFactors = FALSE))
  history_data <- reactiveVal(data.frame(Movie = character(), Weight = numeric(),
                                         Time = character(), stringsAsFactors = FALSE))
  feedback_df  <- reactiveVal(data.frame(Time = character(), Stars = integer(), Useful = character(),
                                         Tags = character(), Part = character(), Comment = character(),
                                         stringsAsFactors = FALSE))
  mood_sel     <- reactiveVal("Adrenaline")
  genre_sel    <- reactiveVal("Action")
  surprise_id  <- reactiveVal(NULL)
  theme_class  <- reactiveVal("bg-crimson")
  
  log_activity <- function(action, id) {
    activity(rbind(activity(), data.frame(time = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                                          action = action, movie_id = id, stringsAsFactors = FALSE)))
  }
  mark_viewed <- function(id) {
    viewed(head(c(id, setdiff(viewed(), id)), 40))
  }
  
  goto <- function(page, sub = NULL) {
    updateTabsetPanel(session, "tabs", selected = page)
    if (!is.null(sub)) updateTabsetPanel(session, "mm_tabs", selected = sub)
    session$sendCustomMessage("mr_active", if (is.null(sub)) page else paste0(page, ":", sub))
  }
  
  # ---------------- login / logout ----------------
  observeEvent(input$login, {
    if (nzchar(trimws(input$uname)) && nzchar(trimws(input$pwd))) {
      current_user(trimws(input$uname))
      logged_in(TRUE)
    } else {
      showNotification("Please enter username and password.", type = "error")
    }
  })
  observeEvent(input$guest, {
    current_user("Guest")
    logged_in(TRUE)
  })
  observeEvent(input$logout, {
    logged_in(FALSE)
    current_user("")
    showNotification("Logged out. See you at the movies!", type = "message")
  })
  
  output$app <- renderUI({
    if (!logged_in()) return(login_screen())
    main_ui(current_user(), isolate(theme_class()))
  })
  
  output$breadcrumb <- renderText({
    if (is.null(input$tabs)) "" else paste(">", input$tabs)
  })
  
  # ---------------- navigation ----------------
  observeEvent(input$nav, {
    parts <- strsplit(input$nav, ":", fixed = TRUE)[[1]]
    updateTabsetPanel(session, "tabs", selected = parts[1])
    if (length(parts) > 1) updateTabsetPanel(session, "mm_tabs", selected = parts[2])
  })
  observeEvent(input$hero_explore, {
    updateSelectizeInput(session, "movie", selected = "Leo")
    goto("Recommendations")
  })
  observeEvent(input$dash_surprise, goto("Surprise"))
  observeEvent(input$dash_reco, goto("ForYou"))
  observeEvent(input$dash_explore, goto("Explorer"))
  observeEvent(input$fav_explore, goto("Explorer"))
  observeEvent(input$watch_explore, goto("Explorer"))
  observeEvent(input$topsearch_go, {
    updateTextInput(session, "search", value = input$topsearch_go)
    goto("Explorer")
  })
  observeEvent(input$mood_pick, {
    mood_sel(input$mood_pick)
    goto("Mood")
  })
  observeEvent(input$genre_pick, {
    genre_sel(input$genre_pick)
    goto("Genres")
  })
  
  # ---------------- card actions (shared by every poster card) ----------------
  observeEvent(input$fav_click, {
    id <- input$fav_click
    title <- movies$title[movies$movie_id == id]
    if (!length(title)) return()
    if (id %in% favorites()) {
      showNotification(paste0(title, " is already in your Favorites"), type = "warning")
    } else {
      favorites(c(favorites(), id))
      log_activity("Favorited", id)
      showNotification(paste0("Added '", title, "' to Favorites"), type = "message")
    }
  })
  observeEvent(input$watch_click, {
    id <- input$watch_click
    title <- movies$title[movies$movie_id == id]
    if (!length(title)) return()
    if (id %in% watchlist()) {
      showNotification(paste0(title, " is already on your Watchlist"), type = "warning")
    } else {
      watchlist(c(watchlist(), id))
      log_activity("Added to watchlist", id)
      showNotification(paste0("Added '", title, "' to Watchlist"), type = "message")
    }
  })
  observeEvent(input$remove_fav, {
    favorites(setdiff(favorites(), input$remove_fav))
    showNotification("Removed from Favorites", type = "warning")
  })
  observeEvent(input$remove_watch, {
    watchlist(setdiff(watchlist(), input$remove_watch))
    showNotification("Removed from Watchlist", type = "warning")
  })
  observeEvent(input$details_click, {
    id <- input$details_click
    if (!any(movies$movie_id == id)) return()
    mark_viewed(id)
    log_activity("Viewed", id)
    updateSelectizeInput(session, "det_movie", selected = movies$title[movies$movie_id == id])
    goto("Details")
  })
  
  # ---------------- reference profile / preferences ----------------
  default_seed <- which.max(movies$rating)
  ref_seeds <- reactive({
    hi <- user_ratings()$movie_id[user_ratings()$rating >= 4]
    s <- unique(c(favorites(), hi))
    if (length(s)) s else default_seed
  })
  ref_label <- reactive({
    if (length(favorites()) || any(user_ratings()$rating >= 4)) "your favorites and high ratings"
    else paste0("the catalog's top-rated movie (", movies$title[default_seed], ")")
  })
  taste <- reactive(compute_taste(favorites(), watchlist(), user_ratings()))
  
  prefs <- reactive({
    list(genre = or_default(input$pref_genre, "All"),
         years = or_default(input$pref_years, c(year_lo, year_hi)),
         min   = or_default(input$pref_min, 0),
         n     = or_default(input$pref_n, 10),
         w     = { cw <- or_default(input$pref_cw, 50); kw <- or_default(input$pref_kw, 50)
                   if (cw + kw <= 0) 0.5 else cw / (cw + kw) })
  })
  
  # Single entry point for recommendations. One seed uses the original
  # recommend_movies() unchanged; several seeds use the profile average.
  get_recs <- function(seeds, n, w, min_rating = 0, y0 = 2007, y1 = 2026, genre = "All") {
    if (length(seeds) == 1) {
      with_ids(recommend_movies(movies$title[seeds], n, w, min_rating, y0, y1, genre))
    } else {
      recommend_profile(seeds, n, w, min_rating, y0, y1, genre)
    }
  }
  
  pref_recs <- function(n = NULL, w = NULL) {
    p <- prefs()
    get_recs(ref_seeds(), or_default(n, p$n), or_default(w, p$w), p$min, p$years[1], p$years[2], p$genre)
  }
  
  save_pref_msg <- reactiveVal("")
  observeEvent(input$pref_cw, updateSliderInput(session, "pref_kw", value = 100 - input$pref_cw))
  observeEvent(input$pref_kw, updateSliderInput(session, "pref_cw", value = 100 - input$pref_kw))
  observeEvent(input$pref_gen, {
    save_pref_msg("Preferences saved for this session.")
    showNotification("Preferences saved", type = "message")
    goto("ForYou")
  })
  observeEvent(input$pref_reset, {
    updateSliderInput(session, "pref_cw", value = 70)
    updateSliderInput(session, "pref_kw", value = 30)
    updateSliderInput(session, "pref_n", value = 10)
    updateSliderInput(session, "pref_min", value = 0)
    updateSliderInput(session, "pref_years", value = c(2007, 2026))
    updateSelectInput(session, "pref_genre", selected = "All")
    save_pref_msg("Preferences reset to default.")
  })
  output$pref_status <- renderText(save_pref_msg())
  
  # ============================ DASHBOARD ============================
  output$dash_kpis <- renderUI({
    div(class = "stats",
        div(class = "stat", tags$b(nrow(movies)), tags$span("TOTAL MOVIES")),
        div(class = "stat", tags$b(number_of_users), tags$span("DEMO USERS"), tags$small("synthetic")),
        div(class = "stat", tags$b(length(all_genres)), tags$span("GENRES")),
        div(class = "stat", tags$b(round(mean(movies$rating), 2)), tags$span("AVG RATING")),
        div(class = "stat", tags$b(length(favorites())), tags$span("FAVORITES")),
        div(class = "stat", tags$b(length(watchlist())), tags$span("WATCHLIST")))
  })
  
  output$dash_motd <- renderUI({
    pool <- which(movies$rating >= 7.5)
    id <- pool[(as.integer(Sys.Date()) %% length(pool)) + 1]
    r <- movies[id, ]
    sc <- profile_scores(setdiff(ref_seeds(), id), 0.5)
    if (!length(setdiff(ref_seeds(), id))) sc <- profile_scores(default_seed, 0.5)
    hs <- sc$hybrid[id]
    div(class = "motd",
        poster_movie_card(r$movie_id, badge = "MOVIE OF THE DAY"),
        div(tags$h2(toupper(r$title)),
            div(class = "reco-meta", paste0(r$year, "  -  ", pretty_genre(r$genre), "  -  Rating ", format(r$rating, nsmall = 1))),
            bar_row(paste0("Hybrid match to ", ref_label()), hs),
            p(class = "muted", style = "font-size:11px",
              "Picked by date from catalog movies rated 7.5 or higher; it changes every day."),
            div(class = "reco-why", tags$h4("Why this pick"), why_ui(id, ref_seeds()))))
  })
  
  output$dash_rails <- renderUI({
    seeds <- ref_seeds()
    recs <- get_recs(seeds, 8, 0.5)
    tagList(
      poster_rail("Trending Now", "app ranking (demo)", movies$movie_id[top_by(trending_score, 10)], compact = TRUE, more = "Trending"),
      poster_rail("New Releases", "newest in dataset", movies$movie_id[order(movies$year, movies$rating, decreasing = TRUE)][1:10], compact = TRUE, more = "NewReleases"),
      poster_rail("Top Rated", "highest catalog ratings", movies$movie_id[top_by(movies$rating, 10)], compact = TRUE, more = "TopRated"),
      poster_rail("Hidden Gems", "computed in-app", movies$movie_id[top_by(gem_score, 10)], compact = TRUE, more = "Gems"),
      if (!is.null(recs)) poster_rail("Personalized For You", paste("based on", ref_label()),
                                      recs$movie_id, scores = recs$Hybrid_Score, compact = TRUE, more = "ForYou")
    )
  })
  
  output$dash_hello <- renderUI({
    div(class = "nh-hello", span(class = "nh-dot"), paste0("Welcome, ", current_user()))
  })
  
  output$dash_prefs <- renderUI({
    t <- taste()
    if (is.null(t)) {
      cnt <- sort(table(unlist(genre_list)), decreasing = TRUE)
      top <- head(cnt, 5)
      labs <- names(top)
      vals <- as.numeric(top) / nrow(movies)
      note <- "Catalog share. Favourite or rate a few movies to see your own taste here."
    } else {
      p <- head(sort(t$pct[t$pct > 0], decreasing = TRUE), 5)
      labs <- names(p)
      vals <- as.numeric(p) / 100
      note <- "Built from your favourites, watchlist and ratings."
    }
    tagList(
      lapply(seq_along(labs), function(i)
        div(class = "nh-gb", style = sprintf("--i:%d", i - 1),
            div(class = "nh-gb-top", span(labs[i]), tags$b(paste0(round(vals[i] * 100), "%"))),
            div(class = "nh-gb-track", div(class = "nh-gb-fill", style = sprintf("--w:%d%%", round(vals[i] * 100)))))),
      div(class = "nh-gb-note", note))
  })
  
  output$dash_ways <- renderUI({
    nw <- length(watchlist())
    pal <- c("129,140,248", "251,146,60", "52,211,153", "255,77,141",
             "168,85,247", "244,114,182", "34,211,238", "251,191,36")
    cols <- c("#818cf8", "#fb923c", "#34d399", "#ff4d8d", "#a855f7", "#f472b6", "#22d3ee", "#fbbf24")
    tiles <- list(
      list("Explorer", "compass", "Explore Movies", "Browse the entire collection"),
      list("Trending", "flame", "Trending", "See what's popular"),
      list("Genres", "reel", "Browse by Genre", "Find your favourite type"),
      list("Mood", "smile", "Discover by Mood", "Movies for every mood"),
      list("NewReleases", "spark", "New Releases", "Explore recent additions"),
      list("MyMovies:watch", "bookmark", "My Watchlist",
           if (nw) paste(nw, "saved to watch") else "Keep track of what to watch"),
      list("Compare", "scale", "Compare Movies", "Compare and decide"),
      list("AnReco", "chart", "Analytics", "Deep insights from data"))
    div(class = "nh-ways", lapply(seq_along(tiles), function(i) {
      t <- tiles[[i]]
      div(class = "nh-way", style = sprintf("--wc:%s;--wr:%s;--i:%d", cols[i], pal[i], i - 1),
          onclick = sprintf("mrNav('%s')", t[[1]]),
          span(class = "nh-way-ico", ic(t[[2]], 24)),
          div(class = "nh-way-t", tags$b(t[[3]]), tags$span(t[[4]])),
          span(class = "nh-way-go", ic("chevron", 18)))
    }))
  })
  
  output$dash_moods <- renderUI({
    pal <- c("251,191,36", "239,68,68", "255,77,141", "96,165,250", "168,85,247",
             "34,211,238", "52,211,153", "251,146,60", "129,140,248")
    div(class = "nh-moods", lapply(seq_along(mood_names), function(i) {
      m <- mood_names[i]
      div(class = "nh-mood", style = paste0("--mr:", pal[(i - 1) %% length(pal) + 1], ";--i:", i - 1),
          onclick = sprintf("Shiny.setInputValue('mood_pick','%s',{priority:'event'})", m),
          span(class = "nh-mood-ico", ic(mood_defs[[m]]$icon, 70)),
          span(class = "nh-mood-i2", ic(mood_defs[[m]]$icon, 22)),
          tags$b(m), tags$small(paste(head(mood_defs[[m]]$genres, 2), collapse = " / ")))
    }))
  })
  output$dash_genres <- renderUI({
    cnt <- sort(table(unlist(strsplit(movies$genre, "|", fixed = TRUE))), decreasing = TRUE)
    top <- head(names(cnt), 6)
    gic <- c(Action = "bolt", Drama = "smile", Comedy = "smile", Thriller = "eye", Romance = "heart",
             Crime = "flame", Adventure = "compass", "Sci-Fi" = "rocket", Family = "heart", Fantasy = "spark",
             Mystery = "eye", Horror = "eye", Musical = "star", Sport = "trophy")
    pal <- list(c("#ff4d8d", "255,77,141"), c("#a78bfa", "167,139,250"), c("#22d3ee", "34,211,238"),
                c("#60a5fa", "96,165,250"), c("#e040fb", "224,64,251"), c("#fb923c", "251,146,60"))
    div(class = "nh-gens", lapply(seq_along(top), function(i) {
      g <- top[i]; p <- pal[[(i - 1) %% length(pal) + 1]]
      ico <- if (g %in% names(gic)) gic[[g]] else "reel"
      div(class = "nh-gen", style = paste0("--gc:", p[1], ";--gr:", p[2], ";--i:", i - 1),
          onclick = sprintf("Shiny.setInputValue('genre_pick','%s',{priority:'event'})", g),
          div(class = "nh-gen-ring", ic(ico, 26)), span(g), tags$small(paste(cnt[[g]], "movies")))
    }))
  })
  
  # ============================ RECOMMENDATIONS ============================
  results <- eventReactive(input$rec, {
    r <- with_ids(recommend_movies(input$movie, input$n, input$cw, input$mrating,
                                   input$ymin, input$ymax, input$gfilter))
    if (!is.null(r)) {
      history_data(rbind(history_data(),
                         data.frame(Movie = input$movie, Weight = input$cw,
                                    Time = format(Sys.time(), "%H:%M:%S"), stringsAsFactors = FALSE)))
      mark_viewed(movies$movie_id[movies$title == input$movie][1])
    }
    r
  })
  observeEvent(input$rec, {
    if (is.null(results())) showNotification("No movies match these filters.", type = "warning")
  })
  
  output$reco_cards <- renderUI({
    r <- results()
    if (is.null(r)) return(card(empty_state("Choose a movie and press GENERATE RECOMMENDATIONS.")))
    seed <- movies$movie_id[movies$title == input$movie][1]
    reco_rows(r, seed, taste())
  })
  output$rectable <- renderTable({
    r <- results()
    if (is.null(r)) data.frame(Message = "Generate recommendations to see results.")
    else r[, setdiff(names(r), "movie_id")]
  })
  output$csv <- downloadHandler(
    filename = function() paste0("MovieRec_", Sys.Date(), ".csv"),
    content = function(f) {
      r <- results()
      if (is.null(r)) r <- data.frame(Message = "No recommendation results yet.")
      else r <- r[, setdiff(names(r), "movie_id")]
      write.csv(r, f, row.names = FALSE)
    })
  output$why <- renderUI({
    r <- results()
    if (is.null(r)) return(div(class = "explain", "Generate recommendations to see the explanation."))
    i <- which(movies$title == input$movie)[1]
    j <- r$movie_id[1]
    shared <- intersect(genre_list[[i]], genre_list[[j]])
    shared <- if (length(shared)) paste(shared, collapse = ", ") else "No exact shared genre"
    div(class = "explain",
        h3(r$Movie[1], style = "color:var(--acc)"),
        p(HTML(paste0("<b>Selected:</b> ", htmltools::htmlEscape(input$movie),
                      "<br><b>Shared genres:</b> ", htmltools::htmlEscape(shared)))),
        bar_row("Content score", r$Content_Score[1]),
        bar_row("Rating-pattern score", r$Collaborative_Score[1]),
        bar_row("Hybrid score", r$Hybrid_Score[1]),
        p(style = "margin-top:10px", "The ranking uses normalized content and rating-pattern similarity combined with the selected content weight."))
  })
  observeEvent(input$add, {
    id <- movies$movie_id[movies$title == input$movie][1]
    if (!is.na(id) && !(id %in% favorites())) {
      favorites(c(favorites(), id))
      log_activity("Favorited", id)
      showNotification(paste0("Added '", input$movie, "' to Favorites"), type = "message")
    }
  })
  output$favmsg <- renderText(paste("Saved favorites:", length(favorites())))
  
  # ============================ PERSONALIZED FOR YOU ============================
  output$fy_info <- renderUI({
    p(class = "muted", style = "font-size:11.5px",
      HTML(paste0("Reference profile: <b>", ref_label(), "</b>. Preferences from <i>My Preferences</i> are applied.")))
  })
  output$fy_cards <- renderUI({
    n <- as.integer(or_default(input$fy_top, 5))
    r <- pref_recs(n = n)
    reco_rows(r, ref_seeds(), taste())
  })
  
  # ============================ TRENDING / NEW / GEMS ============================
  output$trend_ui <- renderUI({
    fan <- demo_likes + 10 * (movies$movie_id %in% favorites())
    card(
      poster_rail("TRENDING NOW", "rating + recency + demo likes", movies$movie_id[top_by(trending_score, 12)]),
      poster_rail("TOP RATED", "catalog rating", movies$movie_id[top_by(movies$rating, 12)]),
      poster_rail("FAN FAVORITES", "demo 4-5 star ratings + your favorites", movies$movie_id[top_by(fan, 12)]),
      poster_rail("MOST RECOMMENDED", "appearances in other movies' Top-10", movies$movie_id[top_by(reco_freq, 12)]),
      poster_rail("HIDDEN GEMS", "high rating, low popularity score", movies$movie_id[top_by(gem_score, 12)])
    )
  })
  output$nr_ui <- renderUI({
    ord <- order(movies$year, movies$rating, decreasing = TRUE)
    ids <- movies$movie_id[head(ord, or_default(input$nr_n, 24))]
    poster_grid(ids)
  })
  output$gems_ui <- renderUI({
    idx <- top_by(gem_score, 18)
    idx <- idx[gem_score[idx] > 0]
    poster_grid(movies$movie_id[idx],
                reasons = sprintf("Rated %.1f, %d demo ratings", movies$rating[idx], demo_n_ratings[idx]))
  })
  
  # ============================ SURPRISE ME ============================
  pick_surprise <- function() {
    p <- prefs()
    ok <- movies$rating >= max(p$min, 7) & movies$year >= p$years[1] & movies$year <= p$years[2]
    if (p$genre != "All") ok <- ok & grepl(p$genre, movies$genre, fixed = TRUE)
    pool <- which(ok)
    if (!length(pool)) pool <- which(movies$rating >= 7)
    id <- pool[sample.int(length(pool), 1)]
    surprise_id(id)
    mark_viewed(id)
    log_activity("Surprise pick", id)
  }
  observeEvent(input$surprise, pick_surprise())
  observeEvent(input$surprise_again, pick_surprise())
  
  output$surprise_ui <- renderUI({
    id <- surprise_id()
    if (is.null(id)) return(empty_state("Press SURPRISE ME for a random pick (rated 7+, using your preferences).", ""))
    r <- movies[id, ]
    seeds <- setdiff(ref_seeds(), id)
    if (!length(seeds)) seeds <- default_seed
    sc <- profile_scores(seeds, 0.5)
    div(class = "surprise-box",
        poster_movie_card(r$movie_id, badge = "SURPRISE PICK"),
        div(tags$h2(toupper(r$title)),
            div(class = "reco-meta", paste0(r$year, "  -  ", pretty_genre(r$genre), "  -  Rating ", format(r$rating, nsmall = 1))),
            div(class = "reco-match", paste0("Recommendation score: ", pct(sc$hybrid[id]))),
            bar_row("Content similarity", sc$content[id]),
            bar_row("Rating-pattern similarity", sc$collab[id]),
            div(class = "reco-why", tags$h4("Why this movie"),
                tags$ul(class = "why-list",
                        tags$li(HTML("&#10003;&nbsp;"), "Randomly drawn from movies rated 7 or higher that fit your preferences"),
                        lapply(why_items(id, seeds), function(x) tags$li(HTML("&#10003;&nbsp;"), x)))),
            div(class = "btn-row",
                tags$a(class = "gold btn", href = get_trailer_url(r$title), target = "_blank", rel = "noopener", HTML("&#9654; WATCH TRAILER")),
                div(class = "cardbtn", onclick = sprintf("Shiny.setInputValue('fav_click', %d, {priority:'event'})", r$movie_id), "ADD FAVORITE"),
                div(class = "cardbtn", onclick = sprintf("Shiny.setInputValue('watch_click', %d, {priority:'event'})", r$movie_id), "ADD WATCHLIST"),
                actionButton("surprise_again", "SHOW ANOTHER", class = "gold"))))
  })
  
  # ============================ MOOD STUDIO ============================
  output$mood_chips <- renderUI({
    sel <- mood_sel()
    div(class = "mood-grid", lapply(mood_names, function(m)
      div(class = paste("mood-card", if (identical(m, sel)) "sel" else ""),
          onclick = sprintf("Shiny.setInputValue('mood_pick','%s',{priority:'event'})", m),
          span(class = "mi", ic(mood_defs[[m]]$icon, 30)), m)))
  })
  output$mood_cards <- renderUI({
    m <- mood_sel()
    gs <- mood_defs[[m]]$genres
    p <- prefs()
    hits <- vapply(genre_list, function(g) sum(g %in% gs), numeric(1))
    ok <- hits > 0 & movies$rating >= p$min & movies$year >= p$years[1] & movies$year <= p$years[2]
    idx <- which(ok)
    if (!length(idx)) return(empty_state("No movies match this mood with your current preferences."))
    sc <- hits[idx] + movies$rating[idx] / 10
    idx <- head(idx[order(sc, decreasing = TRUE)], 12)
    tagList(
      note_box(HTML(paste0("<b>", m, "</b> maps to: ", paste(gs, collapse = ", "),
                           ". Ranked by number of matching genres, then rating."))),
      poster_grid(movies$movie_id[idx],
                  reasons = paste0("Matches your ", m, " mood")))
  })
  
  # ============================ GENRE EXPLORER ============================
  output$genre_chips <- renderUI({
    sel <- genre_sel()
    div(class = "mood-grid", lapply(all_genres, function(g) {
      n <- sum(vapply(genre_list, function(x) g %in% x, logical(1)))
      avg <- mean(movies$rating[vapply(genre_list, function(x) g %in% x, logical(1))])
      div(class = paste("mood-card genre-card", if (identical(g, sel)) "sel" else ""),
          onclick = sprintf("Shiny.setInputValue('genre_pick','%s',{priority:'event'})", g),
          g, tags$small(paste0(n, " movies - avg ", round(avg, 1))))
    }))
  })
  output$genre_cards <- renderUI({
    g <- genre_sel()
    d <- movies[vapply(genre_list, function(x) g %in% x, logical(1)), ]
    d <- switch(or_default(input$gx_sort, "Highest rated"),
                "Highest rated" = d[order(d$rating, decreasing = TRUE), ],
                "Newest" = d[order(d$year, decreasing = TRUE), ],
                "A-Z" = d[order(d$title), ], d)
    tagList(h3(style = "color:var(--acc)", paste0(g, " (", nrow(d), " movies)")), poster_grid(d$movie_id))
  })
  
  # ============================ TASTE PROFILE ============================
  output$taste_ui <- renderUI({
    t <- taste()
    if (is.null(t)) {
      return(card(empty_state("Favorite, watchlist or rate a few movies to build your taste profile.", "")))
    }
    pct_g <- sort(t$pct[t$pct > 0], decreasing = TRUE)
    liked <- unique(t$ids)
    yrs <- movies$year[liked]
    rt <- user_ratings()
    avg_rating <- if (nrow(rt)) paste0(round(mean(rt$rating), 2), " / 5 (your ratings)")
    else paste0(round(mean(movies$rating[liked]), 2), " (catalog rating of your picks)")
    tagList(
      div(class = "stats",
          div(class = "stat", tags$b(names(pct_g)[1]), tags$span("FAVORITE GENRE")),
          div(class = "stat", tags$b(if (length(yrs)) paste0(min(yrs), "-", max(yrs)) else "-"), tags$span("PREFERRED YEARS")),
          div(class = "stat", tags$b(nrow(rt)), tags$span("MOVIES RATED")),
          div(class = "stat", tags$b(length(favorites())), tags$span("FAVORITES")),
          div(class = "stat", tags$b(length(watchlist())), tags$span("WATCHLIST"))),
      card(h3("Average rating"), p(avg_rating)),
      card(h3("Genre preference"),
           lapply(names(pct_g), function(g) bar_row(g, pct_g[[g]] / 100))),
      card(h3("Movies shaping your profile"), poster_grid(head(liked, 12)))
    )
  })
  
  # ============================ MY MOVIES ============================
  removable <- function(ids, input_id, color) {
    lapply(ids, function(id)
      div(style = "text-align:center;padding:6px 0",
          tags$a(style = paste0("font-size:11px;cursor:pointer;color:", color),
                 onclick = sprintf("Shiny.setInputValue('%s',%d,{priority:'event'})", input_id, id),
                 "Remove")))
  }
  output$mm_fav <- renderUI({
    f <- favorites()
    if (!length(f)) return(div(empty_state("Your favorites collection is empty."), 
                               actionButton("fav_explore", "EXPLORE MOVIES", class = "gold")))
    poster_grid(f, extras = removable(f, "remove_fav", "#f87171"))
  })
  output$mm_watch <- renderUI({
    w <- watchlist()
    if (!length(w)) return(div(empty_state("Your watchlist is empty.", ""),
                               actionButton("watch_explore", "EXPLORE MOVIES", class = "gold")))
    poster_grid(w, extras = removable(w, "remove_watch", "#60a5fa"))
  })
  output$mm_recent <- renderUI({
    v <- viewed()
    if (!length(v)) return(empty_state("Movies you open (Details, Surprise Me) show up here.", ""))
    poster_grid(v)
  })
  output$mm_hist <- renderUI({
    a <- activity()
    if (!nrow(a)) return(empty_state("Your activity log is empty.", ""))
    a <- a[nrow(a):1, ]
    a$Movie <- movies$title[a$movie_id]
    tagList(
      p(class = "muted", "Activity this session (views, saves, ratings). Most recent first."),
      poster_grid(head(unique(a$movie_id), 12)),
      h3(style = "margin-top:20px", "Activity log"),
      renderTable_inline(a[, c("time", "action", "Movie")]))
  })
  renderTable_inline <- function(df) {
    tags$table(class = "table",
               tags$thead(tags$tr(lapply(c("Time", "Action", "Movie"), tags$th))),
               tags$tbody(lapply(seq_len(nrow(df)), function(i)
                 tags$tr(lapply(df[i, ], function(x) tags$td(as.character(x)))))))
  }
  output$mm_ratings <- renderUI({
    r <- user_ratings()
    if (!nrow(r)) return(empty_state("Rate a movie on its Movie Details page.", ""))
    r <- r[nrow(r):1, ]
    r <- r[!duplicated(r$movie_id), ]
    poster_grid(r$movie_id,
                reasons = paste0("You rated it ", r$rating, " / 5"),
                badges = paste0(r$rating, " STARS"))
  })
  
  # ============================ EXPLORER ============================
  explore_filtered <- reactive({
    d <- movies
    q <- or_default(input$search, "")
    if (nzchar(q)) d <- d[grepl(q, d$title, ignore.case = TRUE, fixed = FALSE), ]
    if (or_default(input$egenre, "All") != "All") d <- d[grepl(input$egenre, d$genre, fixed = TRUE), ]
    d <- d[d$rating >= or_default(input$erating, 0) & d$year >= or_default(input$eyear, 2007), ]
    switch(or_default(input$esort, "Highest Rated"),
           "Highest Rated" = d[order(d$rating, decreasing = TRUE), ],
           "Newest" = d[order(d$year, decreasing = TRUE), ],
           "A-Z" = d[order(d$title), ], d)
  })
  output$explorecards <- renderUI({
    d <- explore_filtered()
    if (!nrow(d)) return(empty_state("No movies match these filters.", ""))
    tagList(p(class = "muted", paste0(nrow(d), " movies found",
                                      if (nrow(d) > 24) " - showing the first 24 (see table below for all)" else "")),
            poster_grid(head(d$movie_id, 24)))
  })
  output$exploretable <- renderTable({
    d <- explore_filtered()[, c("movie_id", "title", "genre", "year", "rating")]
    names(d) <- c("ID", "Movie", "Genre", "Year", "Rating")
    d
  })
  
  # ============================ ADVANCED SEARCH ============================
  adv_default <- list(q = "", genre = "All", years = c(2007, 2026), rmin = 0, rmax = 10, sort = "Rating")
  adv_params <- reactiveVal(adv_default)
  observeEvent(input$adv_apply, {
    adv_params(list(q = trimws(or_default(input$adv_q, "")), genre = input$adv_genre,
                    years = input$adv_years, rmin = input$adv_rmin, rmax = input$adv_rmax,
                    sort = input$adv_sort))
  })
  observeEvent(input$adv_reset, {
    updateTextInput(session, "adv_q", value = "")
    updateSelectInput(session, "adv_genre", selected = "All")
    updateSliderInput(session, "adv_years", value = c(2007, 2026))
    updateSliderInput(session, "adv_rmin", value = 0)
    updateSliderInput(session, "adv_rmax", value = 10)
    updateSelectInput(session, "adv_sort", selected = "Rating")
    adv_params(adv_default)
  })
  adv_results <- reactive({
    p <- adv_params()
    d <- movies
    if (nzchar(p$q)) d <- d[grepl(p$q, d$title, ignore.case = TRUE), ]
    if (p$genre != "All") d <- d[grepl(p$genre, d$genre, fixed = TRUE), ]
    d <- d[d$year >= p$years[1] & d$year <= p$years[2] & d$rating >= p$rmin & d$rating <= p$rmax, ]
    if (nrow(d)) {
      sc <- profile_scores(ref_seeds(), 0.5)$hybrid
      d$score <- sc[d$movie_id]
      d <- switch(p$sort,
                  "Rating" = d[order(d$rating, decreasing = TRUE), ],
                  "Year" = d[order(d$year, decreasing = TRUE), ],
                  "Title" = d[order(d$title), ],
                  "Recommendation Score" = d[order(d$score, decreasing = TRUE), ], d)
    }
    d
  })
  output$adv_count <- renderUI({
    d <- adv_results()
    div(class = "note-box", paste0(nrow(d), " movies match your filters."))
  })
  output$adv_cards <- renderUI({
    d <- adv_results()
    if (!nrow(d)) return(empty_state("No movies match. Try Reset Filters.", ""))
    poster_grid(head(d$movie_id, 36),
                scores = if (identical(adv_params()$sort, "Recommendation Score")) head(d$score, 36) else NULL)
  })
  
  # ============================ COMPARE ============================
  idx_of <- function(title) which(movies$title == title)[1]
  output$cardA <- renderUI(poster_movie_card(movies$movie_id[idx_of(input$a)]))
  output$cardB <- renderUI(poster_movie_card(movies$movie_id[idx_of(input$b)]))
  output$comparebar <- renderUI({
    a <- idx_of(input$a); b <- idx_of(input$b)
    s <- cosine_similarity(genre_matrix[a, ], genre_matrix[b, ])
    k <- cosine_similarity(rating_matrix[a, ], rating_matrix[b, ])
    common <- intersect(genre_list[[a]], genre_list[[b]])
    tagList(
      h3(style = "margin-top:20px", "MOVIE MATCH"),
      bar_row("Genre (content) similarity", s),
      bar_row("Rating-pattern similarity (demo users)", k),
      p(style = "font-size:12px;color:#cbd0d9",
        if (length(common)) paste("Common genres:", paste(common, collapse = ", "))
        else "Common genres: none"))
  })
  output$comparetable <- renderTable({
    a <- idx_of(input$a); b <- idx_of(input$b)
    s <- cosine_similarity(genre_matrix[a, ], genre_matrix[b, ])
    data.frame(
      Attribute = c("Movie", "Genre", "Year", "Rating", "Cosine similarity (A vs B)"),
      Movie_A = c(movies$title[a], movies$genre[a], movies$year[a], movies$rating[a], round(s, 3)),
      Movie_B = c(movies$title[b], movies$genre[b], movies$year[b], movies$rating[b], round(s, 3)),
      stringsAsFactors = FALSE)
  })
  output$compareplot <- renderPlot({
    a <- idx_of(input$a); b <- idx_of(input$b)
    s <- cosine_similarity(genre_matrix[a, ], genre_matrix[b, ])
    k <- cosine_similarity(rating_matrix[a, ], rating_matrix[b, ])
    dark_par()
    barplot(c(s, k), ylim = c(0, 1), names.arg = c("Genre similarity", "Rating-pattern similarity"),
            col = c(gold, indigo), main = paste(input$a, "vs", input$b), ylab = "Cosine similarity")
  }, bg = "transparent")
  
  # ============================ MOVIE BATTLE ============================
  battle <- eventReactive(input$bt_go, {
    a <- idx_of(input$bt_a); b <- idx_of(input$bt_b)
    list(a = a, b = b, metric = input$bt_metric)
  }, ignoreNULL = FALSE)
  output$bt_ui <- renderUI({
    bt <- battle()
    a <- bt$a; b <- bt$b
    if (a == b) return(card(empty_state("Pick two different movies.", "")))
    seeds <- setdiff(ref_seeds(), c(a, b))
    if (!length(seeds)) seeds <- setdiff(order(movies$rating, decreasing = TRUE), c(a, b))[1]
    sc <- profile_scores(seeds, 0.5)
    vals <- list(
      "Rating" = c(movies$rating[a], movies$rating[b]),
      "Year (newest)" = c(movies$year[a], movies$year[b]),
      "Content similarity" = sc$content[c(a, b)],
      "Rating-pattern similarity" = sc$collab[c(a, b)],
      "Hybrid score" = sc$hybrid[c(a, b)])
    v <- vals[[bt$metric]]
    winner <- if (v[1] > v[2]) a else if (v[2] > v[1]) b else NA
    rows <- list(
      list("Year", movies$year[a], movies$year[b]),
      list("Genre", pretty_genre(movies$genre[a]), pretty_genre(movies$genre[b])),
      list("Rating", movies$rating[a], movies$rating[b]),
      list("Content similarity", pct(sc$content[a]), pct(sc$content[b])),
      list("Rating-pattern similarity", pct(sc$collab[a]), pct(sc$collab[b])),
      list("Hybrid score", pct(sc$hybrid[a]), pct(sc$hybrid[b])))
    tagList(
      card(div(class = "battle",
               div(class = "battle-card", poster_movie_card(movies$movie_id[a])),
               div(class = "vs", "VS"),
               div(class = "battle-card", poster_movie_card(movies$movie_id[b]))),
           tags$table(class = "table cmp-table", style = "margin-top:18px",
                      tags$thead(tags$tr(tags$th("Metric"), tags$th(movies$title[a]), tags$th(movies$title[b]))),
                      tags$tbody(lapply(rows, function(r) tags$tr(tags$td(r[[1]]), tags$td(r[[2]]), tags$td(r[[3]]))))),
           p(class = "muted", style = "font-size:10.5px;margin-top:8px",
             paste0("Similarity metrics are measured against ", if (length(ref_seeds()) && !identical(ref_seeds(), default_seed)) "your favorites/high ratings" else "the catalog's top-rated movie", ".")),
           div(class = "winner", h3(HTML("MATCH RESULT")),
               div(class = "wn", if (is.na(winner)) "IT'S A TIE" else toupper(movies$title[winner])),
               p(class = "muted", paste("Decided by:", bt$metric))))
    )
  })
  
  # ============================ MOVIE DETAILS ============================
  det_id <- reactive(movies$movie_id[idx_of(or_default(input$det_movie, "Leo"))])
  observeEvent(input$det_movie, {
    id <- movies$movie_id[idx_of(input$det_movie)]
    if (!is.na(id)) mark_viewed(id)
  }, ignoreInit = TRUE)
  
  output$det_ui <- renderUI({
    id <- det_id()
    r <- movies[id, ]
    seeds <- setdiff(ref_seeds(), id)
    if (!length(seeds)) seeds <- setdiff(order(movies$rating, decreasing = TRUE), id)[1]
    sc <- profile_scores(seeds, 0.5)
    card(div(class = "motd",
             poster_movie_card(id, show_actions = FALSE),
             div(tags$h2(toupper(r$title)),
                 div(class = "reco-meta", paste0(r$year, "  -  ", pretty_genre(r$genre), "  -  Rating ", format(r$rating, nsmall = 1))),
                 div(class = "reco-match", paste0("Recommendation score: ", pct(sc$hybrid[id]))),
                 bar_row("Content similarity", sc$content[id]),
                 bar_row("Rating-pattern similarity", sc$collab[id]),
                 bar_row("Hybrid score", sc$hybrid[id]),
                 p(class = "muted", style = "font-size:10.5px", paste0("Measured against ", ref_label(), ".")),
                 div(class = "reco-why", tags$h4("Why you may like it"), why_ui(id, seeds)),
                 div(class = "btn-row",
                     tags$a(class = "gold btn", href = get_trailer_url(r$title), target = "_blank", rel = "noopener", HTML("&#9654; WATCH TRAILER")),
                     div(class = "cardbtn", onclick = sprintf("Shiny.setInputValue('fav_click', %d, {priority:'event'})", id), "ADD TO FAVORITES"),
                     div(class = "cardbtn", onclick = sprintf("Shiny.setInputValue('watch_click', %d, {priority:'event'})", id), "ADD TO WATCHLIST")))))
  })
  output$det_similar <- renderUI({
    id <- det_id()
    h <- 0.5 * content_norm[id, ] + 0.5 * collab_norm[id, ]
    h[id] <- -1
    top <- order(h, decreasing = TRUE)[1:6]
    poster_grid(movies$movie_id[top], scores = h[top])
  })
  observeEvent(input$det_rate_btn, {
    id <- det_id()
    user_ratings(rbind(user_ratings(), data.frame(movie_id = id, rating = as.numeric(input$det_rate),
                                                  time = format(Sys.time(), "%H:%M:%S"), stringsAsFactors = FALSE)))
    log_activity(paste0("Rated ", input$det_rate, "/5"), id)
    showNotification(paste0("Rated '", movies$title[id], "' ", input$det_rate, "/5"), type = "message")
  })
  observeEvent(input$det_watched, {
    id <- det_id()
    log_activity("Marked watched", id)
    showNotification(paste0("Marked '", movies$title[id], "' as watched"), type = "message")
  })
  
  # ============================ ANALYTICS ============================
  output$anm_stats <- renderUI({
    div(class = "stats",
        div(class = "stat", tags$b(nrow(movies)), tags$span("TOTAL MOVIES")),
        div(class = "stat", tags$b(round(mean(movies$rating), 2)), tags$span("AVERAGE RATING")),
        div(class = "stat", tags$b(max(movies$rating)), tags$span("HIGHEST"), tags$small(movies$title[which.max(movies$rating)])),
        div(class = "stat", tags$b(min(movies$rating)), tags$span("LOWEST"), tags$small(movies$title[which.min(movies$rating)])),
        div(class = "stat", tags$b(length(unique(movies$year))), tags$span("RELEASE YEARS")))
  })
  year_count_plot <- function() {
    dark_par()
    barplot(table(movies$year), las = 2, col = gold, border = NA, main = "Movies per release year",
            xlab = "", ylab = "Movies", cex.names = .7)
  }
  output$anm_year <- renderPlot(year_count_plot(), bg = "transparent")
  output$any_count <- renderPlot(year_count_plot(), bg = "transparent")
  output$any_avg <- renderPlot({
    a <- tapply(movies$rating, movies$year, mean)
    dark_par()
    plot(as.numeric(names(a)), a, type = "b", pch = 19, col = gold, lwd = 2, ylim = c(4, 10),
         main = "Average rating by year", xlab = "Year", ylab = "Average rating")
    abline(h = mean(movies$rating), lty = 2, col = indigo)
  }, bg = "transparent")
  
  genre_tab <- reactive({
    g <- unlist(genre_list)
    data.frame(Genre = all_genres,
               Movies = vapply(all_genres, function(x) sum(g == x), numeric(1)),
               Avg = vapply(all_genres, function(x) mean(movies$rating[vapply(genre_list, function(z) x %in% z, logical(1))]), numeric(1)),
               stringsAsFactors = FALSE)
  })
  output$ang_dist <- renderPlot({
    d <- genre_tab(); d <- d[order(d$Movies, decreasing = TRUE), ]
    dark_par(mar = c(6, 4.5, 3.5, 1))
    barplot(d$Movies, names.arg = d$Genre, las = 2, col = gold, border = NA, main = "Movies per genre", ylab = "Movies")
  }, bg = "transparent")
  output$ang_avg <- renderPlot({
    d <- genre_tab(); d <- d[order(d$Avg, decreasing = TRUE), ]
    dark_par(mar = c(6, 4.5, 3.5, 1))
    barplot(d$Avg, names.arg = d$Genre, las = 2, col = indigo, border = NA, ylim = c(0, 10),
            main = "Average rating by genre", ylab = "Average rating")
  }, bg = "transparent")
  output$ang_combo <- renderTable({
    t <- sort(table(movies$genre), decreasing = TRUE)
    d <- data.frame(Combination = gsub("|", " - ", names(t), fixed = TRUE), Movies = as.integer(t))
    head(d, 12)
  })
  
  output$anr_stats <- renderUI({
    div(class = "stats",
        div(class = "stat", tags$b(round(mean(movies$rating), 2)), tags$span("AVERAGE RATING")),
        div(class = "stat", tags$b(median(movies$rating)), tags$span("MEDIAN")),
        div(class = "stat", tags$b(sum(movies$rating >= 8)), tags$span("RATED 8.0 OR HIGHER")),
        div(class = "stat", tags$b(sum(movies$rating < 6)), tags$span("RATED BELOW 6.0")))
  })
  output$anr_hist <- renderPlot({
    dark_par()
    hist(movies$rating, breaks = seq(4.5, 9.5, 0.5), col = gold, border = "#0c121c",
         main = "Rating distribution", xlab = "Rating", ylab = "Movies")
  }, bg = "transparent")
  output$anr_top <- renderUI(poster_grid(movies$movie_id[top_by(movies$rating, 6)]))
  
  # ---- Recommendation analytics ----
  output$anx_cards <- renderUI({
    idx <- top_by(reco_freq, 6)
    poster_grid(movies$movie_id[idx], scores = avg_hybrid[idx],
                reasons = paste0("In ", reco_freq[idx], " Top-10 lists"))
  })
  anx_top <- reactive({
    idx <- top_by(reco_freq, 10)
    data.frame(Movie = movies$title[idx], Top10_Appearances = reco_freq[idx],
               Content_Score = round(avg_content[idx], 3), Pattern_Score = round(avg_collab[idx], 3),
               Hybrid_Score = round(avg_hybrid[idx], 3), stringsAsFactors = FALSE)
  })
  output$anx_table <- renderTable(anx_top())
  output$anx_components <- renderPlot({
    d <- anx_top()
    dark_par(mar = c(8, 4.5, 3.5, 1))
    barplot(rbind(d$Content_Score, d$Pattern_Score, d$Hybrid_Score), beside = TRUE,
            names.arg = d$Movie, las = 2, col = c(gold, indigo, "#10b981"), border = NA, ylim = c(0, 1),
            main = "Average component scores", ylab = "Score (0-1)")
    legend("topright", c("Content", "Rating pattern", "Hybrid"), fill = c(gold, indigo, "#10b981"),
           bty = "n", text.col = "#cbd0d9", cex = .8)
  }, bg = "transparent")
  output$anx_hybrid <- renderPlot({
    dark_par()
    hist(avg_hybrid, breaks = 15, col = gold, border = "#0c121c", main = "Average hybrid score per movie",
         xlab = "Average hybrid score", ylab = "Movies")
  }, bg = "transparent")
  output$anx_hist_c <- renderPlot({
    v <- content_raw[row(content_raw) != col(content_raw)]
    dark_par()
    hist(v, breaks = 20, col = gold, border = "#0c121c", main = "Content similarity (cosine, all pairs)",
         xlab = "Cosine similarity", ylab = "Movie pairs")
  }, bg = "transparent")
  output$anx_hist_k <- renderPlot({
    v <- collab_raw[row(collab_raw) != col(collab_raw)]
    dark_par()
    hist(v, breaks = 20, col = indigo, border = "#0c121c", main = "Rating-pattern similarity (cosine, all pairs)",
         xlab = "Cosine similarity", ylab = "Movie pairs")
  }, bg = "transparent")
  output$histtable <- renderTable({
    h <- history_data()
    if (!nrow(h)) data.frame(Message = "No recommendation history yet.") else h
  })
  
  # ============================ RECOMMENDATION LAB ============================
  observeEvent(input$lab_cw, updateSliderInput(session, "lab_kw", value = 100 - input$lab_cw))
  observeEvent(input$lab_kw, updateSliderInput(session, "lab_cw", value = 100 - input$lab_kw))
  
  lab_w <- reactive({
    tot <- input$lab_cw + input$lab_kw
    if (tot <= 0) 0.5 else input$lab_cw / tot
  })
  lab_res <- eventReactive(input$lab_run, {
    w <- lab_w()
    r <- with_ids(recommend_movies(input$lab_movie, input$lab_n, w, input$lab_min,
                                   input$lab_years[1], input$lab_years[2], "All"))
    list(r = r, w = w, seed = input$lab_movie)
  }, ignoreNULL = FALSE)
  output$lab_bars <- renderUI({
    w <- lab_w()
    tagList(bar_row("Content weight", w), bar_row("Rating-pattern weight", 1 - w))
  })
  output$lab_results <- renderUI({
    x <- lab_res()
    seed <- movies$movie_id[movies$title == x$seed][1]
    tagList(note_box(HTML(paste0("Model run for <b>", htmltools::htmlEscape(x$seed), "</b> with content weight <b>",
                                 round(x$w * 100), "%</b> and rating-pattern weight <b>", round((1 - x$w) * 100), "%</b>."))),
            reco_rows(x$r, seed, taste()))
  })
  output$labexplain <- renderUI({
    x <- lab_res()
    i <- which(movies$title == x$seed)[1]
    best <- which.max(replace(x$w * content_norm[i, ] + (1 - x$w) * collab_norm[i, ], i, -1))
    h <- x$w * content_norm[i, best] + (1 - x$w) * collab_norm[i, best]
    div(class = "explain",
        h4(style = "color:var(--acc);margin-top:0", paste0("Best match for '", x$seed, "' at this weight: ", movies$title[best])),
        p(HTML(paste0("<b>Content contribution:</b> ", round(x$w * content_norm[i, best], 3),
                      "<br><b>Rating-pattern contribution:</b> ", round((1 - x$w) * collab_norm[i, best], 3),
                      "<br><b>Final hybrid score:</b> ", round(h, 3)))))
  })
  output$weightplot <- renderPlot({
    x <- lab_res()
    i <- which(movies$title == x$seed)[1]
    w <- seq(0, 1, .1)
    best <- vapply(w, function(z) max(replace(z * content_norm[i, ] + (1 - z) * collab_norm[i, ], i, -1)), numeric(1))
    dark_par()
    plot(w, best, type = "b", pch = 19, col = gold, lwd = 2, ylim = c(0, 1),
         main = paste("Weight sensitivity -", x$seed), xlab = "Content weight", ylab = "Highest hybrid score")
    abline(v = x$w, lty = 2, col = indigo)
  }, bg = "transparent")
  
  # ============================ CONTENT SIMILARITY ============================
  output$ci_matrix <- renderTable({
    i <- idx_of(input$ci_movie)
    m <- genre_matrix[i, , drop = FALSE]
    rownames(m) <- movies$title[i]
    as.data.frame(m)
  }, rownames = TRUE, digits = 0)
  output$ci_results <- renderUI({
    i <- idx_of(input$ci_movie)
    s <- content_raw[i, ]
    s[i] <- -1
    top <- order(s, movies$rating, decreasing = TRUE)[seq_len(input$ci_n)]
    card(h3(paste("Most similar to", input$ci_movie, "by genre")),
         p(class = "muted", style = "font-size:11px", "Raw cosine similarity. Ties are broken by catalog rating."),
         poster_grid(movies$movie_id[top], scores = s[top],
                     reasons = paste0("Cosine ", round(s[top], 2), " - shared: ",
                                      vapply(top, function(j) paste(intersect(genre_list[[i]], genre_list[[j]]), collapse = "/"), character(1)))))
  })
  
  # ============================ COLLABORATIVE SIMILARITY ============================
  output$co_results <- renderUI({
    i <- idx_of(input$co_movie)
    s <- collab_raw[i, ]
    s[i] <- -1
    top <- order(s, decreasing = TRUE)[seq_len(input$co_n)]
    card(h3(HTML(paste0("Similar rating patterns to ", htmltools::htmlEscape(input$co_movie),
                        " <span class='demo-tag'>SYNTHETIC DEMONSTRATION DATA</span>"))),
         poster_grid(movies$movie_id[top], scores = s[top],
                     reasons = paste0("Rating-pattern cosine ", round(s[top], 2))))
  })
  
  # ============================ EXPLAIN RECOMMENDATION ============================
  ex_recs <- reactive({
    w <- or_default(input$ex_w, 0.5)
    with_ids(recommend_movies(input$ex_seed, 10, w))
  })
  observeEvent(list(input$ex_seed, input$ex_w), {
    r <- ex_recs()
    if (!is.null(r)) updateSelectInput(session, "ex_target", choices = r$Movie, selected = r$Movie[1])
  })
  output$ex_ui <- renderUI({
    r <- ex_recs()
    req(r, input$ex_target, input$ex_target %in% r$Movie)
    k <- which(r$Movie == input$ex_target)
    w <- or_default(input$ex_w, 0.5)
    i <- idx_of(input$ex_seed); j <- r$movie_id[k]
    common <- intersect(genre_list[[i]], genre_list[[j]])
    card(h3(paste0("WHY WAS ", toupper(input$ex_target), " RECOMMENDED?")),
         div(class = "motd",
             poster_movie_card(j, score = r$Hybrid_Score[k]),
             div(
               bar_row("Genre similarity (content)", r$Content_Score[k]),
               bar_row("Rating pattern match", r$Collaborative_Score[k]),
               bar_row("Hybrid score", r$Hybrid_Score[k]),
               h4(style = "color:var(--acc);font-size:12px;margin-top:16px", "CONTRIBUTIONS TO THE HYBRID SCORE"),
               bar_row(paste0("Content contribution (weight ", round(w * 100), "%)"), w * r$Content_Score[k], right = round(w * r$Content_Score[k], 3)),
               bar_row(paste0("Rating-pattern contribution (weight ", round((1 - w) * 100), "%)"), (1 - w) * r$Collaborative_Score[k], right = round((1 - w) * r$Collaborative_Score[k], 3)),
               h4(style = "color:var(--acc);font-size:12px;margin-top:16px", "COMMON GENRES"),
               p(if (length(common)) paste(common, collapse = ", ") else "None"),
               h4(style = "color:var(--acc);font-size:12px", "USER PREFERENCE MATCH"),
               p(preference_match(j, taste())),
               div(class = "reco-why", tags$h4("Reasons"), why_ui(j, i)))))
  })
  
  # ============================ MODEL ANALYSIS ============================
  output$model_text <- renderUI({
    items <- list(
      paste0("<b>Data</b> - ", nrow(movies), " Tamil movies with genre, year and rating; ", number_of_users,
             " synthetic users with 0-5 ratings (0 = not rated)."),
      paste0("<b>Feature engineering / genre matrix</b> - a ", nrow(movies), " x ", length(all_genres),
             " 0/1 matrix with one column per genre."),
      "<b>Cosine similarity</b> - cos(A, B) = (A . B) / (|A| |B|), applied to genre vectors (content) and to rating vectors (rating pattern).",
      "<b>Rating-pattern similarity</b> - cosine similarity between two movies' rating vectors across the demo users.",
      "<b>Normalization</b> - for a chosen seed movie, each similarity vector is min-max scaled to 0-1.",
      "<b>Hybrid score</b> - w x content + (1 - w) x rating-pattern, with w set by the Content Weight slider.",
      "<b>Ranking</b> - candidates are filtered by rating, year and genre, sorted by hybrid score, and the top N are returned.")
    tags$ul(lapply(items, function(x) tags$li(HTML(x))))
  })
  output$model <- renderTable({
    data.frame(
      Metric = c("Average content score", "Maximum content score", "Average rating-pattern score",
                 "Maximum rating-pattern score", "Average hybrid score", "Maximum hybrid score"),
      Value = round(c(mean(content_norm), max(content_norm), mean(collab_norm), max(collab_norm),
                      mean(0.5 * content_norm + 0.5 * collab_norm), max(0.5 * content_norm + 0.5 * collab_norm)), 3))
  })
  
  sim_data <- eventReactive(input$sim_run, {
    u <- input$sim_users; d <- input$sim_density / 100
    m <- with_seed(input$sim_seed, {
      matrix(sample(0:5, nrow(movies) * u, replace = TRUE,
                    prob = c(1 - d, rep(d / 5, 5))), nrow = nrow(movies), ncol = u)
    })
    list(m = m, movie = input$sim_movie, users = u)
  }, ignoreNULL = FALSE)
  output$sim_summary <- renderUI({
    x <- sim_data(); m <- x$m
    div(class = "stats", style = "margin-top:16px",
        div(class = "stat", tags$b(x$users), tags$span("SIMULATED USERS")),
        div(class = "stat", tags$b(sum(m > 0)), tags$span("RATINGS GENERATED")),
        div(class = "stat", tags$b(paste0(round(mean(m > 0) * 100), "%")), tags$span("ACTUAL DENSITY")),
        div(class = "stat", tags$b(round(mean(m[m > 0]), 2)), tags$span("AVERAGE RATING")))
  })
  output$sim_plot <- renderPlot({
    m <- sim_data()$m
    dark_par()
    barplot(table(factor(m[m > 0], levels = 1:5)), col = gold, border = NA,
            main = "Simulated rating distribution (synthetic)", xlab = "Stars", ylab = "Ratings")
  }, bg = "transparent")
  output$sim_cards <- renderUI({
    x <- sim_data()
    i <- idx_of(x$movie)
    s <- vapply(seq_len(nrow(movies)), function(j) if (j == i) -1 else cosine_similarity(x$m[i, ], x$m[j, ]), numeric(1))
    top <- order(s, decreasing = TRUE)[1:6]
    tagList(h3(style = "margin-top:18px", paste("Rating-pattern neighbours of", x$movie, "in the simulated data")),
            note_box("Synthetic demonstration data - not real users."),
            poster_grid(movies$movie_id[top], scores = s[top], reasons = paste0("Cosine ", round(s[top], 2))))
  })
  
  # ---- hold-out evaluation ----
  ev_res <- eventReactive(input$ev_run, {
    evaluate_holdout(input$ev_frac / 100, input$ev_k, input$ev_w, input$ev_seed)
  }, ignoreNULL = FALSE)
  output$ev_summary <- renderUI({
    r <- ev_res()
    best <- r$table$Method[which.min(r$table$RMSE)]
    tagList(
      div(class = "stats", style = "margin-top:16px",
          div(class = "stat", tags$b(r$n_obs), tags$span("OBSERVED RATINGS")),
          div(class = "stat", tags$b(r$n_train), tags$span("TRAINING RATINGS")),
          div(class = "stat", tags$b(r$n_test), tags$span("HIDDEN TEST RATINGS")),
          div(class = "stat", tags$b(sprintf("%.3f", min(r$table$RMSE))), tags$span("BEST RMSE"), tags$small(best))),
      note_box(HTML(paste0(
        "<b>How to read this.</b> The demo ratings are randomly generated, so movie similarity carries no real signal. ",
        "Do not expect the neighbour methods to beat the movie-mean baseline by much; this demonstrates the ",
        "evaluation procedure, not real-world accuracy. Coverage is the share of hidden ratings the neighbours could ",
        "predict (the rest fall back to the movie mean)."))))
  })
  output$ev_table <- renderTable({
    t <- ev_res()$table
    t$RMSE <- round(t$RMSE, 3)
    t$MAE <- round(t$MAE, 3)
    t$Coverage <- paste0(round(100 * t$Coverage), "%")
    t
  })
  output$ev_plot <- renderPlot({
    t <- ev_res()$table
    dark_par(mar = c(10, 4.5, 3.5, 1))
    barplot(rbind(t$RMSE, t$MAE), beside = TRUE, names.arg = t$Method, las = 2,
            col = c(gold, indigo), border = NA, ylim = c(0, max(t$RMSE, t$MAE) * 1.15),
            main = "Prediction error on hidden ratings", ylab = "Error (rating points)")
    legend("topright", c("RMSE", "MAE"), fill = c(gold, indigo), bty = "n", text.col = "#cbd0d9", cex = .85)
  }, bg = "transparent")
  
  # ============================ RANKINGS ============================
  output$top_ui <- renderUI(poster_grid(movies$movie_id[top_by(movies$rating, or_default(input$tr_n, 12))]))
  output$pop_ui <- renderUI({
    idx <- top_by(popularity_score, 18)
    poster_grid(movies$movie_id[idx], scores = popularity_score[idx],
                reasons = paste0(demo_n_ratings[idx], " demo ratings, ", reco_freq[idx], " Top-10 lists"))
  })
  output$crit_ui <- renderUI(poster_grid(head(movies$movie_id[critics_ids], 24), badges = rep("CRITICS PICK", min(24, length(critics_ids)))))
  output$fan_ui <- renderUI({
    fan <- demo_likes + 10 * (movies$movie_id %in% favorites())
    idx <- top_by(fan, 18)
    poster_grid(movies$movie_id[idx], reasons = paste0(demo_likes[idx], " demo fans",
                                                       ifelse(movies$movie_id[idx] %in% favorites(), " + your favorite", "")))
  })
  output$lb_ui <- renderUI({
    board <- function(title, sub, idx, value) {
      div(class = "card",
          h3(title), p(class = "muted", style = "font-size:10.5px", sub),
          poster_rail("", "", movies$movie_id[idx]),
          tags$ol(lapply(seq_along(idx), function(k) tags$li(HTML(paste0(
            "<b>", htmltools::htmlEscape(movies$title[idx[k]]), "</b> - ", value[k]))))))
    }
    fav_score <- demo_five + 5 * (movies$movie_id %in% favorites())
    watch_score <- demo_n_ratings + 5 * (movies$movie_id %in% watchlist())
    i1 <- top_by(reco_freq, 5); i2 <- top_by(movies$rating, 5)
    i3 <- top_by(fav_score, 5); i4 <- top_by(watch_score, 5)
    tagList(
      board("Most Recommended", "Appearances in other movies' Top-10 lists (50/50 hybrid).", i1, paste0(reco_freq[i1], " lists")),
      board("Highest Rated", "Catalog rating.", i2, format(movies$rating[i2], nsmall = 1)),
      board("Most Favorited", "Demo users' 5-star ratings (a proxy for favorites) plus your own favorites.", i3, paste0(fav_score[i3], " favorites")),
      board("Most Added to Watchlist", "Proxy: number of demo users who rated the movie, plus your own watchlist.", i4, paste0(watch_score[i4], " interested")))
  })
  
  # ============================ FEEDBACK ============================
  observeEvent(input$fb_submit, {
    stars <- input$fb_stars
    if (is.null(stars)) {
      showNotification("Please tap a star rating first.", type = "warning")
      return()
    }
    tg <- input$fb_tags
    tg <- if (is.null(tg) || identical(tg, "")) "" else paste(unlist(tg), collapse = ", ")
    feedback_df(rbind(feedback_df(),
                      data.frame(Time = format(Sys.time(), "%H:%M:%S"), Stars = as.integer(stars),
                                 Useful = or_default(input$fb_react, "Not answered"), Tags = tg,
                                 Part = or_default(input$fb_feature, "Overall app"),
                                 Comment = or_default(input$fb_comment, ""), stringsAsFactors = FALSE)))
    updateTextAreaInput(session, "fb_comment", value = "")
    session$sendCustomMessage("mr_fb_reset", TRUE)
    showNotification("Ticket torn! Your feedback was recorded for this session.", type = "message")
  })
  stars_html <- function(n) HTML(paste0(strrep("&#9733;", n), strrep("&#9734;", 5 - n)))
  output$fb_summary <- renderUI({
    f <- feedback_df()
    n <- nrow(f)
    avg <- if (n) mean(f$Stars) else 0
    dist <- vapply(5:1, function(k) sum(f$Stars == k), numeric(1))
    very <- if (n) round(100 * mean(f$Useful == "Very useful")) else 0
    tag_counts <- sort(table(unlist(strsplit(f$Tags[nzchar(f$Tags)], ", ", fixed = TRUE))), decreasing = TRUE)
    div(class = "fb-board",
        div(class = "fb-board-head", "Feedback overview"),
        div(class = "fb-top",
            div(class = "fb-ring", style = sprintf("--p:%d", round(avg / 5 * 100)),
                span(if (n) sprintf("%.1f", avg) else "-")),
            div(class = "fb-kpis",
                div(tags$b(n), tags$span("Total feedback")),
                div(tags$b(if (n) round(avg, 2) else "-"), tags$span("Average feedback")),
                div(tags$b(paste0(very, "%")), tags$span("Very useful")))),
        div(class = "fb-sub-title", "Rating breakdown"),
        lapply(seq_along(dist), function(i)
          bar_row(paste0(6 - i, " stars"), if (n) dist[i] / n else 0, right = dist[i])),
        if (length(tag_counts)) tagList(
          div(class = "fb-sub-title", "Most mentioned"),
          div(class = "fb-tags fb-tags-static",
              lapply(head(names(tag_counts), 5), function(t)
                div(class = "fb-tag on", paste0(t, " (", tag_counts[[t]], ")"))))))
  })
  output$fb_wall <- renderUI({
    f <- feedback_df()
    if (!nrow(f)) return(div(class = "fb-empty", "No feedback yet. Be the first to share your thoughts."))
    f <- f[nrow(f):1, ]
    badge_cls <- function(u) switch(u, "Very useful" = "good", "Somewhat useful" = "mid", "Not useful" = "bad", "")
    div(class = "fb-wall",
        div(class = "fb-sub-title", "Recent feedback"),
        lapply(seq_len(min(6, nrow(f))), function(i)
          div(class = "fb-item",
              div(class = "fb-av", f$Stars[i]),
              div(
                div(class = "fb-item-top",
                    span(class = "fb-item-stars", stars_html(f$Stars[i])),
                    span(class = paste("fb-badge", badge_cls(f$Useful[i])), htmltools::htmlEscape(f$Useful[i]))),
                div(class = "fb-item-part", htmltools::htmlEscape(f$Part[i]), " - ", f$Time[i]),
                if (nzchar(f$Tags[i])) div(class = "fb-item-tags", htmltools::htmlEscape(f$Tags[i])),
                if (nzchar(f$Comment[i])) div(class = "fb-item-note", htmltools::htmlEscape(f$Comment[i]))))))
  })
  
  # ============================ SETTINGS / PROFILE ============================
  observeEvent(input$set_apply, {
    theme_class(input$set_theme)
    session$sendCustomMessage("mr_theme", input$set_theme)
    updateSliderInput(session, "n", value = min(15, max(5, input$set_n)))
    updateSliderInput(session, "pref_n", value = input$set_n)
    updateSliderInput(session, "lab_n", value = input$set_n)
    updateSelectInput(session, "gfilter", selected = input$set_genre)
    updateSelectInput(session, "pref_genre", selected = input$set_genre)
    updateSliderInput(session, "cw", value = input$set_weight)
    updateSliderInput(session, "ex_w", value = input$set_weight)
    updateSliderInput(session, "lab_cw", value = round(input$set_weight * 100))
    showNotification("Settings applied", type = "message")
  })
  output$profile_ui <- renderUI({
    t <- taste()
    fav_g <- if (is.null(t)) "-" else names(sort(t$pct, decreasing = TRUE))[1]
    rec <- viewed()
    tagList(
      div(class = "stats",
          div(class = "stat", tags$b(current_user()), tags$span("USERNAME")),
          div(class = "stat", tags$b(fav_g), tags$span("FAVORITE GENRE")),
          div(class = "stat", tags$b(nrow(user_ratings())), tags$span("MOVIES RATED")),
          div(class = "stat", tags$b(length(favorites())), tags$span("FAVORITES")),
          div(class = "stat", tags$b(length(watchlist())), tags$span("WATCHLIST")),
          div(class = "stat", tags$b(length(rec)), tags$span("RECENTLY VIEWED"))),
      if (length(rec)) poster_grid(head(rec, 6)))
  })
  
  # ============================ EXPORT ============================
  output$dl_recs <- downloadHandler(
    filename = function() paste0("MovieRec_recommendations_", Sys.Date(), ".csv"),
    content = function(f) {
      r <- tryCatch(results(), error = function(e) NULL)
      if (is.null(r)) r <- pref_recs()
      if (is.null(r)) r <- data.frame(Message = "No recommendations yet.")
      else r <- r[, setdiff(names(r), "movie_id")]
      write.csv(r, f, row.names = FALSE)
    })
  movie_table <- function(ids) {
    if (!length(ids)) return(data.frame(Message = "Nothing saved yet."))
    d <- movies[match(ids, movies$movie_id), c("title", "genre", "year", "rating")]
    names(d) <- c("Movie", "Genre", "Year", "Rating")
    d
  }
  output$dl_favs <- downloadHandler(
    filename = function() paste0("MovieRec_favorites_", Sys.Date(), ".csv"),
    content = function(f) write.csv(movie_table(favorites()), f, row.names = FALSE))
  output$dl_watch <- downloadHandler(
    filename = function() paste0("MovieRec_watchlist_", Sys.Date(), ".csv"),
    content = function(f) write.csv(movie_table(watchlist()), f, row.names = FALSE))
  output$dl_hist <- downloadHandler(
    filename = function() paste0("MovieRec_history_", Sys.Date(), ".csv"),
    content = function(f) {
      h <- history_data()
      if (!nrow(h)) h <- data.frame(Message = "No recommendation history yet.")
      write.csv(h, f, row.names = FALSE)
    })
  
  # ============================ ABOUT: POSTER VALIDATION ============================
  output$poster_validation <- renderUI({
    r <- poster_report()
    tagList(
      div(class = "stats",
          div(class = "stat", tags$b(r$total_movies), tags$span("MOVIES IN DATASET")),
          div(class = "stat", tags$b(r$mapped), tags$span("POSTER MAPPINGS")),
          div(class = "stat", tags$b(length(r$missing)), tags$span("MISSING POSTERS")),
          div(class = "stat", tags$b(r$local_files), tags$span("LOCAL FILES")),
          div(class = "stat", tags$b(r$remote_urls), tags$span("REMOTE URLS"))),
      p(class = "muted", paste0("Posters folder checked: ", normalizePath(file.path("www", "posters"), mustWork = FALSE),
                                " - ", length(poster_files()), " image files found there.")),
      p(paste0("Duplicate titles: ", if (length(r$duplicate_titles)) paste(r$duplicate_titles, collapse = ", ") else "none",
               ". Missing local files: ", length(r$missing_local_files), ". Invalid paths: ", length(r$invalid_paths),
               ". Every movie id resolves in the poster table: ", if (r$all_ids_resolve) "yes" else "NO", ".")),
      if (length(r$missing)) note_box(HTML(paste0(
        "<b>", length(r$missing), " movies have no poster yet.</b> They display a flat 'POSTER UNAVAILABLE' card. ",
        "Run <code>fetch_posters.R</code> once to download them into <code>www/posters/</code>.<br><br>",
        htmltools::htmlEscape(paste(r$missing, collapse = ", "))))))
  })
}

# -------------------------- RUN APP --------------------------
shinyApp(ui, server)
