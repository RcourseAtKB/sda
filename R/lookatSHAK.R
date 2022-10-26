lookatSHAK <- function(x) {
  if(is.character(x)){
    if(nchar(x)>3){
      DF <- helpreadshak()
      return(DF[DF$Shak %in% substr(x, 1, 4),])
    } else{
      warning("The string has to be a least 4 characters.")
    }
  } else{
    warning("Input has to be a character.")
  }
}
