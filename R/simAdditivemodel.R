simAdditivemodel <- function(beta1, beta2, unmeasured =  FALSE, timevarying = FALSE, samp = 1000){

  status <- c(1:samp)*0

  pr <- function(x) exp(x) / (1 + exp(x))
  lambda  <- function(a, l, u){ 0.2 + beta1 * a + beta2 * l + 0.05 * u }
  l <- function(lp, ap, k, u){ 0.8 * lp - ap + 0.1 * k + u + rnorm(samp)}
  a <- function(ap, l) pr(-2 + 0.5 * l + ap)
  converttext <- function(x) eval(parse(text = x), envir = parent.frame())

  if(!unmeasured)U <- 0
  if(unmeasured)U <- rnorm(samp, 0, 0.1)


  # Time 0
  L0 <- 1*(pr(0.2) > runif(samp))
  A0 <- 1*(pr(-2 + 0.5 * L0) > runif(samp))
  V <- runif(samp)
  Tstar0 <- -log(V)/(lambda(A0, L0, U));rm(V)

  eventtime_T0 <- Tstar0
  eventtime_T0[Tstar0 >= 1] <- 1
  status_0 <- status
  status_0[Tstar0 < 1] <- 1

  varList0 <- data.frame(id = 1:samp,
                         Time0 = 0,
                         Time1 = eventtime_T0,
                         status = status_0,
                         L = L0,
                         A = A0)

  #rm(L0);rm(A0);rm(Tstar0);rm(eventtime_T0);rm(status_0)
  dataSim <- data.frame(rbind(varList0));rm(varList0)

  if(is.numeric(timevarying) & timevarying > 0){
    for(i in 1:timevarying){

      converttext(paste0("L", i," <- L", i-1))
      converttext(paste0("A", i, "<- A",i-1," + 1*(a(A", i-1, ", L",i ,") > runif(samp))"))
      V <- runif(samp)
      converttext(paste0("Tstar", i," <- -log(V)/(lambda(A", i,", L", i,", U))"));rm(V)
      converttext(paste0("eventtime_T", i," <- Tstar", i))
      converttext(paste0("eventtime_T", i,"[Tstar", i," >= 1] <- 1"))
      converttext(paste0("status_", i," <- status"))
      converttext(paste0("status_", i,"[Tstar", i," < 1] <- 1"))

      eventtime <- function(x) paste0("(", paste0("eventtime_T", 0:x, collapse = " + "),")")
      survivalstatus <- function(x) paste0("(", paste0("Tstar", 0:max(x-1,0), " >= 1", collapse = " & "),")")

      varList <- data.frame(id = 1:samp,
                            Time0 = converttext(paste0(eventtime(i-1), " * ", ifelse(i-1==0,"1", survivalstatus(i-1)))),
                            Time1 = converttext(paste0(eventtime(i), " * ", survivalstatus(i))),
                            status = converttext(paste0("status_", i)),
                            L = converttext(paste0("L", i)),
                            A = converttext(paste0("A", i)))
      dataSim <- rbind(dataSim, varList); rm(varList)

    }
  }
  dataSim <- dataSim[order(dataSim$id), ]
  dataSim <- data.frame(dataSim[with(dataSim, Time0 < Time1), ] %>% rename("var1" = "A", "var2" = "L"))

  dataSim

}
