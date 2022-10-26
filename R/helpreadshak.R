helpreadshak <-  function() {
  SHAK <- suppressMessages(read_delim("https://sor-filer.sundhedsdata.dk/sor_produktion/data/shak/shakregion/SHAKregion.txt",
                                      delim = "\t", escape_double = FALSE,
                                      col_names = FALSE, trim_ws = TRUE, locale = locale(encoding = "latin1")))
  colnames(SHAK) <- c("Shak", "Place", "Valid from", "Valid to", "X5", "Area", "X7", "X8")
  SHAK <- data.frame(SHAK)
  SHAK <- SHAK %>% mutate(Region = NA_character_,
                          Region = if_else(X7 %in% 1081, "Nordjylland", Region),
                          Region = if_else(X7 %in% 1082, "Midtjylland", Region),
                          Region = if_else(X7 %in% 1083, "Syddanmark", Region),
                          Region = if_else(X7 %in% 1084, "Hovedstaden", Region),
                          Region = if_else(X7 %in% 1085, "Sj\u00e6lland", Region))
  SHAK$X7 <- NULL
  return(SHAK)
}
