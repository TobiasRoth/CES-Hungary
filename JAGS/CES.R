#******************************************************************************
#
# ANALYSES OF HUNGARIAN CES-DATA - Bugs analyses to estimate true survival
#		
#******************************************************************************

rm(list=ls(all=TRUE))

#------------------------------------------------------------------------------
# General settings
#------------------------------------------------------------------------------
local <- TRUE
spec <- 10

# Maia settings
if(!local) {
  options(max.print=1000)
  setwd("/scicore/home/amrhein/rothto00/CES")
  .libPaths("/scicore/home/amrhein/rothto00/R-packages") 
}

# JAGS Settings
if(local) {
  t.n.thin <-       2
  t.n.chains <-      2
  t.n.burnin <-  200
  t.n.iter <-    200
}
if(!local) {
  t.n.thin <-       50
  t.n.chains <-      2
  t.n.burnin <-  50000
  t.n.iter <-    50000
}

# Libraries
library(rjags)

#------------------------------------------------------------------------------
# Data preparation
#------------------------------------------------------------------------------
# Load all data into 'dat' and select data of one species into 'd'
load("RData/dat.RData")
dat$yr <- dat$year -  min(dat$year) + 1

# Match close sites
dat$site_code[dat$site_code == 28] <- 27
dat$site_code[dat$site_code == 3] <- 4
dat$site_code[dat$site_code == 14] <- 15
dat$site_code[dat$site_code == 38] <- 39
dat$site_code <- as.integer(factor(dat$site_code))

d <- dat[dat$species == names(table(dat$species)[spec]), ]
d <- d[order(d$bird_id, d$year), ]
d$bird_id <- as.integer(factor(d$bird_id))

# Prepare data for bugs
ind <- sort(unique(d$bird_id))
sex <- tapply(d$sex, d$bird_id, function(x) x[1]) 
sex <- sex[order(as.integer(names(sex)))]
sex <- as.integer(sex == "F") + 1
years <- min(dat$year) : max(dat$year)
firstcapsite <- tapply(d$site_code, d$bird_id, function(x) x[1])
y <- z <- array(NA, dim = c(length(ind), length(years)))
for(i in 1:length(ind)) {
  td <- d[d$bird_id == i, ]
  tt <- tapply(td$site_code, td$yr, function(x) x[length(x)]) != firstcapsite[i]
  z[i,unique(td$yr)] <- as.integer(tapply(td$site_code, td$yr, function(x) x[1]) != firstcapsite[i]) + 1
  #z[i, min(which(z[i,] == 1)):max(which(z[i,] == 1))] <- 1
}
y[is.na(z)] <- 0
y[!is.na(z)] <- 1
capyear <- apply(y, 1, function(x) min(which(x>0)))

# Select only data of individuals that were captured the first time before the last year
ind <- ind[capyear < length(years)]
sex <- sex[capyear < length(years)]
firstcapsite <- firstcapsite[capyear < length(years)]
y <- y[capyear < length(years),]
z <- z[capyear < length(years),]
capyear <- capyear[capyear < length(years)]

# Number of capturing occations per site and year
ncapoc <- data.frame(array(0, dim = c(length(unique(dat$site_code)), length(years))))
for(t in 1:ncol(y)) {
  tt <- tapply(dat$month_day[dat$yr == t], dat$site_code[dat$yr == t], function(x) length(unique(x)))
  ncapoc[names(tt),t] <- tt
}

bugsdat <- list(y=y, z=z, sex=sex, N = nrow(y), nyears = ncol(y), capyear = capyear, ncapsite=nrow(ncapoc), ncapoc=ncapoc, firstcapsite=as.vector(firstcapsite))

#------------------------------------------------------------------------------
# Run Model
#------------------------------------------------------------------------------
# Function to create initial values
t.z <- array(NA, dim = c(nrow(y), ncol(y)))
for(i in 1:nrow(y)) {
  tt <- 1
  for(t in (capyear[i]+1):ncol(y)) {
    if(is.na(z[i,t])) t.z[i,t] <- tt
    if(!is.na(z[i,t]) & z[i,t]==2) tt <- 2
  }
}

inits <- function() {
  list(
    phi = runif(2,0.5,0.9),
    lambda = runif(2,0.3,0.8),
    p = runif(2,0.1,0.2),
    psi = runif(1,0,0.01),
    z = t.z
  )
}

# Run JAGS
if(local) jagres <- jags.model('JAGS/Model.R',data = bugsdat, n.chains = t.n.chains, inits = inits, n.adapt = t.n.burnin)
if(!local) jagres <- jags.model('Model.R',data = bugsdat, n.chains = t.n.chains, inits = inits, n.adapt = t.n.burnin)

params <- c("lambda", "phi", "p", "psi")
mod <- coda.samples(jagres, params, n.iter=t.n.iter, thin=t.n.thin)
summary(mod)
save(mod, file = paste0("mod_", spec, ".RData"))

