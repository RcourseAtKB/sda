helpreadshak <-  function() {
  if(url.exists("https://sor-filer.sundhedsdata.dk/sor_produktion/data/shak/shakregion/SHAKregion.txt")){
    SHAK <- suppressMessages(read_delim("https://sor-filer.sundhedsdata.dk/sor_produktion/data/shak/shakregion/SHAKregion.txt",
                                        delim = "\t", escape_double = FALSE,
                                        col_names = FALSE, trim_ws = TRUE, locale = locale(encoding = "latin1")))
    colnames(SHAK) <- c("K_SGH", "V_SGHNAVN", "K_FRADTO", "D_TILDTO", "C_SGHTYPE", "C_INSTART", "C_REGION", "C_SORID")
  
    SHAK <- data.frame(SHAK)
    SHAK <- SHAK %>% mutate(Region = NA_character_,
                            Region = if_else(C_REGION %in% 1081, "Nordjylland", Region),
                            Region = if_else(C_REGION %in% 1082, "Midtjylland", Region),
                            Region = if_else(C_REGION %in% 1083, "Syddanmark", Region),
                            Region = if_else(C_REGION %in% 1084, "Hovedstaden", Region),
                            Region = if_else(C_REGION %in% 1085, "Sj\u00e6lland", Region),
                            Institution = NA_character_,
                            Institution = if_else(C_SGHTYPE %in% 1, "Offentlig", Institution),
                            Institution = if_else(C_SGHTYPE %in% 2, "Privat", Institution),
                            Institution = if_else(C_SGHTYPE %in% 3, "\u00d8vrige", Institution))
    SHAK$C_REGION <- NULL
    SHAK$C_SGHTYPE <- NULL
  } else {warning("The link does not work.")}

  return(SHAK)
}
