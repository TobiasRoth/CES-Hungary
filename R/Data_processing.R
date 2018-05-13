#******************************************************************************
#
# ANALYSES OF HUNGARIAN CES-DATA - Data handling
#		
#******************************************************************************

rm(list=ls(all=TRUE))

#------------------------------------------------------------------------------
# Settings
#------------------------------------------------------------------------------
# Libraries
library(tidyverse)
library(openxlsx)

#------------------------------------------------------------------------------
# Read data and data preparation
#------------------------------------------------------------------------------
dat <- read.xlsx("Data/CES 2004_2015.xlsx")

# Add sex if an individual is captured several times, but not always sexed
tt <- tapply(dat$sex, dat$bird_id, function(x) x[x!="U"][1])
dat$sex <- tt[match(dat$bird_id, names(tt))]

# Select species with less than 5% missing sex identification
tt <-tapply(dat$sex, dat$species, function(x) mean(is.na(x)))
selspec <- names(tt)[tt<0.05]
dat <- dat[!is.na(match(dat$species, selspec)), ]

# remove individuals with missing sex 
dat <- dat[!is.na(dat$sex),]

#------------------------------------------------------------------------------
# Describe data 
#------------------------------------------------------------------------------
# Number of capturing event by species
table(dat$species)

# Number of captured individuals by species
tapply(dat$bird_id, dat$species, function(x) length(unique(x)))

# Proportion of recaptures by species
tapply(dat$bird_id, dat$species, function(x) {tt <- table(x); round(100 * sum(tt>1) / length(tt), 1)} ) 
mean(table(dat$bird_id)>1)

# Number of recaptures from different sites per species
tt <- tapply(
  tapply(dat$site_code, dat$bird_id, function(x) length(unique(x))),
  tapply(dat$species, dat$bird_id, function(x) x[1]),
  function(x) sum(x > 1))
tt; sum(tt)
tt / tapply(dat$bird_id, dat$species, function(x) length(unique(x)))

# Number of recaptures from different years per species
tt <- tapply(
  tapply(dat$year, dat$bird_id, function(x) length(unique(x))),
  tapply(dat$species, dat$bird_id, function(x) x[1]),
  function(x) sum(x > 1))
tt / tapply(dat$bird_id, dat$species, function(x) length(unique(x)))

# Species captured in two (or more) sites per year
tt <- tapply(dat$site_code, paste0(dat$bird_id, dat$year), function(x) length(unique(x)))
tt[tt>1]

# Sex-ratio of captures by species
tapply(dat$sex, dat$species, function(x) mean(x=="M"))
mean(tapply(dat$sex, dat$species, function(x) mean(x=="M")))

# Capturing sites and dispersers
plot(dat$longitude, dat$latitude, pch = 16, cex = 0.3)
tt <- tapply(dat$site_code, dat$bird_id, function(x) length(unique(x)))
tt <- tt[tt>1]
spec <- res <- character(0)
for(i in names(tt)) {
  d <- dat[dat$bird_id==i,]
  spec <- c(spec, d$species[1])
  res <- c(res, d$sex[1])
  for(x in 2:nrow(d)) {
    tchit <- runif(1, -0.1, 0.1)
    lines(c(d$longitude[x-1]+ tchit, d$longitude[x] + tchit), c(d$latitude[x-1], d$latitude[x]), col = "red", lwd = 1)
  }
}
hist(rbinom(1000, size = length(res), prob = 0.5)/length(res), xlim = c(0,1))
abline(v=mean(res=="F"))

d <- data.frame(y =as.integer(res=="F"), spec = spec)
library(arm)
summary(glmer(y ~ 1 + (1|spec), data = d, family = "binomial"))

length(unique(dat$site_code))
length(unique(paste0(dat$longitude, dat$latitude)))

# Have a look at recaptures from different sites
tt <- tapply(dat$year, dat$bird_id, function(x) length(unique(x)))
tt <- dat[!is.na(match(dat$bird_id, names(tt[tt>1]))), ]
tt[order(tt$bird_id), ]
tt <- names(tapply(tt$year, tt$bird_id, max))[(tapply(tt$year, tt$bird_id, max) - tapply(tt$year, tt$bird_id, min)) > 5]
dat[!is.na(match(dat$bird_id, tt)), ]

#------------------------------------------------------------------------------
# Some controls of data
#------------------------------------------------------------------------------
sum(tapply(dat$species, dat$bird_id, function(x) length(unique(x)))>1)
sum(tapply(dat$ringnumber, dat$bird_id, function(x) length(unique(x)))>1)
sum(tapply(dat$sex, dat$bird_id, function(x) length(unique(x[x != "U"])))>1)

#------------------------------------------------------------------------------
# Save data
#------------------------------------------------------------------------------
dat <- dat %>% as.tibble %>% dplyr::select(bird_id, capture_id, type, ringnumber, species, sex, site_code, year, month_day)
save(dat, file = "RData/dat.RData")



