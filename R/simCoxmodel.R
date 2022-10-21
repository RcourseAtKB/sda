simCoxmodel <- function(beta1, beta2, beta3, rateC = 0.2, unmeasured =  FALSE, timevarying = FALSE, samp = 1000){

  converttext <- function(x) eval(parse(text = x), envir = parent.frame())

  # CREATING g() AND g^-1()
  g.inv <- sqrt
  g <- function(x) { x^2 }

  # CREATING THE TIME SCALE AND TRANSFORMED TIME SCALE
  t <- 0:199
  t.diff <- (t[-1] - t[1:(length(t) - 1)])[-(length(t) - 1)]
  g.inv.t <- g.inv(t)
  g.inv.t.diff <- (g.inv(t[-1]) - g.inv(t[1:(length(t) - 1)]))[-(length(t) - 1)]
  #CREATING THE BOUNDS OF TRUNCATION
  t.min <- 1
  t.max <- 150
  g.inv.t.max <- g.inv(t.max)
  g.inv.t.min <- g.inv(t.min)

  #DATA GENERATING PROCESS FOR COVARIATE
  var2fct <- function(N) {
    vec <- c()
    ssh <- c(80, 20);ssh <- ssh/sum(ssh)
    if(timevarying){
      vec[1] <- sample(c(0,1), 1, prob = ssh, replace = T)
      for(i in 2:N){
        vec[i] <- max(vec[i-1], sample(c(0,1), 1, prob = ssh, replace = T))
      }
    } else {
      vec <- rep(sample(c(0,1), 1, prob = ssh, replace = T), len = N)
    }
    return(vec)
  }

  #CREATING DATA VECTOR
  z.list <- list()
  for(i in 1:samp) {
    var1 <- sample(x=c(0, 1, 2), size=1, replace=TRUE, prob=c(0.3, 0.4, 0.3))
    var2 <- var2fct(length(t))
    var3 <- sample(x=c(0, 1), size=1, replace=TRUE, prob=c(0.5, 0.5))
    z.list[[i]] <- cbind(var1, var2, var3, exp(beta1 * var1 + beta2 * var2 + beta3 * var3))
  };rm(i)
  rm(list = c("var1", "var2", "var3","var2fct"))

  #GENERATING DATA USING ACCEPT-REJECT METHOD
  k <- function(x, m, M, rates, t){
    ifelse(x <= m | x >= M, 0, dpexp(x, rates, t))
  }
  gen.y <- function(x) {
    x1 <- x[, 4]
    d <- ppexp(g.inv.t.max, x1, g.inv.t) - ppexp(g.inv.t.min, x1, g.inv.t)
    M <- 1 / d
    r <- 60
    repeat{
      y <- rpexp(r, x1, g.inv.t)
      u <- runif(r)
      t <- M * ((k(y, g.inv.t.min, g.inv.t.max, x1, g.inv.t) / d / dpexp(y, x1, g.inv.t)))
      y <- y[u <= t][1]
      if (!is.na(y)) break
    }
    y
  }

  y <- sapply(z.list, gen.y)
  g.y <- g(y)

  #CREATING CENSORING INDICATOR
  C <- rexp(n=samp, rate=rateC)

  d <- as.numeric(g.y <= C)
  g.ystar <- pmin(g.y, C);rm(g.y);rm(C)
  #CREATING DATASET
  dataSim <- NULL
  for (i in 1:samp){
    id.temp <- rep(i, ceiling(g.ystar[i]))
    time1.temp <- c(1:ceiling(g.ystar[i]))
    time0.temp <- 0:ceiling(g.ystar[i] - 1)
    d.temp <- c(rep(0, length(time1.temp) - 1), d[i])
    z.temp <- z.list[[i]][1:(ceiling(g.ystar[i])), c(1,2,3), drop=F]
    data.temp <- cbind(id.temp, time0.temp, time1.temp, d.temp, z.temp)
    data.temp <- data.frame(data.temp)
    data.temp <- data.table(data.temp %>% rename("id" = "id.temp", "time1" = "time1.temp", "time0" = "time0.temp", "status" = "d.temp"))
    data.temp <- data.temp[,list(Time0 = min(time0), Time1 = max(time1), status = max(status)), by=.(id, var1, var2, var3)]
    data.temp <- data.temp %>% mutate(time = Time1 - Time0)
    rm(id.temp);rm(time0.temp);rm(time1.temp);rm(d.temp);rm(z.temp)
    dataSim <- rbind(dataSim, data.temp)
  };rm(i)

  dataSim
}
