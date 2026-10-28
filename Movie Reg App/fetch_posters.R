# ============================================================
# fetch_posters.R - run this ONCE, by hand. It is NOT part of the app.
#
# What it does
#   Downloads one real poster per movie (all 120, 2007-2026) from TMDB into www/posters/
#   (www/posters/<slug>.jpg), so MOVIEREC can show every poster from a
#   local file with no network access at runtime.
#
# Requirements
#   * A free TMDB API key: https://www.themoviedb.org/settings/api
#   * R package jsonlite (installed below if missing)
#
# How to run (from the MOVIEREC project folder, where app.R lives)
#   Sys.setenv(TMDB_API_KEY = "paste_your_key_here")
#   source("fetch_posters.R")
#
# Safety
#   * Strictly sequential, with a pause between requests.
#   * Skips movies that already have a local poster.
#   * Stops after repeated failures instead of looping (no 429 storms).
#   * Only accepts a match when TMDB says the film is Tamil-language, or
#     when the title AND release year both match. Anything uncertain is
#     left unresolved and listed in poster_fetch_report.csv so you can add
#     the file by hand rather than getting a wrong poster.
# ============================================================

api_key <- Sys.getenv("TMDB_API_KEY", unset = "")
if (!nzchar(api_key)) stop("Set your key first: Sys.setenv(TMDB_API_KEY = \"...\")")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite", repos = "https://cloud.r-project.org")

# Read the `movies` table out of app.R without launching the app.
exprs <- parse("app.R")
is_movies_assign <- function(e) {
  is.call(e) && identical(e[[1]], as.name("<-")) && identical(e[[2]], as.name("movies"))
}
hit <- which(vapply(as.list(exprs), is_movies_assign, logical(1)))
if (!length(hit)) stop("Could not find the `movies` data frame in app.R")
movies <- eval(exprs[[hit[1]]])

poster_slug <- function(title) {
  s <- gsub("[^a-z0-9]+", "_", tolower(title))
  gsub("^_+|_+$", "", s)
}
has_local <- function(slug) {
  any(file.exists(file.path("www", "posters", paste0(slug, c(".jpg", ".jpeg", ".png", ".webp")))))
}
norm_title <- function(x) gsub("[^a-z0-9]", "", tolower(x))

dir.create(file.path("www", "posters"), recursive = TRUE, showWarnings = FALSE)

# ---- Connection method ------------------------------------------------
# Some PCs let the browser reach TMDB but block R's default connection.
# So we test the methods R offers and use the first one that works.
options(timeout = 60)
get_json <- function(url, method) {
  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp))
  utils::download.file(url, tmp, method = method, quiet = TRUE, mode = "wb")
  jsonlite::fromJSON(tmp)
}
candidate_methods <- if (.Platform$OS.type == "windows") c("wininet", "libcurl") else c("libcurl", "curl")
http_method <- NULL
test_url <- paste0("https://api.themoviedb.org/3/configuration?api_key=", api_key)
for (m in candidate_methods) {
  message("Testing connection method: ", m, " ...")
  ok <- tryCatch({ get_json(test_url, m); TRUE },
                 error = function(e) FALSE, warning = function(w) FALSE)
  if (ok) { http_method <- m; break }
}
if (is.null(http_method)) {
  stop("R could not reach TMDB with any method (", paste(candidate_methods, collapse = ", "), ").\n",
       "Your browser works, so a proxy/firewall/antivirus is blocking R. Try: turn off VPN/antivirus web shield, ",
       "use a phone hotspot, or allow R (Rgui.exe / rsession.exe) through Windows Firewall.")
}
message("Using connection method: ", http_method)

search_tmdb <- function(title, year) {
  url <- paste0("https://api.themoviedb.org/3/search/movie?api_key=", api_key,
                "&query=", utils::URLencode(title, reserved = TRUE), "&include_adult=false")
  res <- get_json(url, http_method)
  if (!is.data.frame(res$results) || !nrow(res$results)) return(NULL)
  r <- res$results
  r <- r[!is.na(r$poster_path) & nzchar(r$poster_path), , drop = FALSE]
  if (!nrow(r)) return(NULL)
  yr <- suppressWarnings(as.integer(substr(r$release_date, 1, 4)))
  year_ok <- !is.na(yr) & abs(yr - year) <= 1
  tamil <- r$original_language == "ta"
  title_ok <- norm_title(r$title) == norm_title(title) | norm_title(r$original_title) == norm_title(title)
  good <- tamil & (year_ok | title_ok)
  if (!any(good)) return(NULL)
  r[which(good)[1], , drop = FALSE]
}

report <- data.frame(movie = movies$title, year = movies$year, status = "", matched_title = "",
                     stringsAsFactors = FALSE)
failures <- 0

for (i in seq_len(nrow(movies))) {
  slug <- poster_slug(movies$title[i])
  if (has_local(slug)) {
    report$status[i] <- "already local"
    next
  }
  hit_row <- tryCatch(search_tmdb(movies$title[i], movies$year[i]), error = function(e) e)
  if (inherits(hit_row, "error")) {
    failures <- failures + 1
    report$status[i] <- paste("error:", conditionMessage(hit_row))
    message("Error on '", movies$title[i], "': ", conditionMessage(hit_row))
    if (failures >= 3) {
      message("Three failures in a row - stopping so we do not hammer the API. Re-run later; finished posters are kept.")
      break
    }
    Sys.sleep(5)
    next
  }
  failures <- 0
  if (is.null(hit_row)) {
    report$status[i] <- "no confident match - add www/posters/" 
    report$status[i] <- paste0(report$status[i], slug, ".jpg by hand")
    message("No confident match: ", movies$title[i])
  } else {
    dest <- file.path("www", "posters", paste0(slug, ".jpg"))
    ok <- tryCatch({
      utils::download.file(paste0("https://image.tmdb.org/t/p/w500", hit_row$poster_path[1]),
                           dest, mode = "wb", quiet = TRUE, method = http_method)
      file.exists(dest) && file.info(dest)$size > 1000
    }, error = function(e) FALSE, warning = function(w) FALSE)
    report$status[i] <- if (isTRUE(ok)) "downloaded" else "download failed"
    report$matched_title[i] <- hit_row$title[1]
    if (!isTRUE(ok) && file.exists(dest)) unlink(dest)
    message(sprintf("[%3d/%d] %s -> %s", i, nrow(movies), movies$title[i], report$status[i]))
  }
  Sys.sleep(0.4)
}

utils::write.csv(report, "poster_fetch_report.csv", row.names = FALSE)
message("\nDone. Downloaded: ", sum(report$status == "downloaded"),
        " | already local: ", sum(report$status == "already local"),
        " | unresolved: ", sum(!report$status %in% c("downloaded", "already local")))
message("Check poster_fetch_report.csv (matched_title column) to eyeball matches, then restart the app.")
