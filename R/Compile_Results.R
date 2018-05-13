#******************************************************************************
#
# ANALYSES OF HUNGARIAN CES-DATA - Bugs analyses to estimate true survival
#
#******************************************************************************

rm(list=ls(all=TRUE))

#------------------------------------------------------------------------------
# General settings
#------------------------------------------------------------------------------
# Libraries
library(rjags)

#------------------------------------------------------------------------------
# Data preparation
#------------------------------------------------------------------------------
# Load all data into 'dat' and select data of one species into 'd'
load("RData/dat.RData")
res <- data.frame(Species = names(table(dat$species)))
res$NumInd <- tapply(dat$bird_id, dat$species, function(x) length(unique(x)))
res$CSR <- as.vector(round(tapply(dat$bird_id[dat$sex=="M"], dat$species[dat$sex=="M"], function(x) length(unique(x))) / res$NumInd,3))

# Compile results
for(spec in 1:11) {
  load(paste0("Ressim//mod_", spec, ".RData"))
  res[spec, "P"] <- round(mean(c(mod[[1]][,"p[1]"],mod[[2]][,"p[1]"]) > c(mod[[1]][,"p[2]"],mod[[2]][,"p[2]"])), 3)
  res[spec, "Phi"] <- round(mean(c(mod[[1]][,"phi[1]"],mod[[2]][,"phi[1]"]) > c(mod[[1]][,"phi[2]"],mod[[2]][,"phi[2]"])), 3)
  res[spec, "Lambda"] <- round(mean(c(mod[[1]][,"lambda[1]"],mod[[2]][,"lambda[1]"]) > c(mod[[1]][,"lambda[2]"],mod[[2]][,"lambda[2]"])), 3)
}

res
apply(res[, c("CSR", "P", "Phi", "Lambda")], 2, mean)

cor.test(res$CSR, res$P)
cor.test(res$CSR, res$Phi)
cor.test(res$CSR, res$Lambda)

#------------------------------------------------------------------------------
# Load results on parameters
#------------------------------------------------------------------------------
# Load all data into 'dat' and select data of one species into 'd'
load("RData/dat.RData")
res <- data.frame(Species = names(table(dat$species)))
res$NumInd <- tapply(dat$bird_id, dat$species, function(x) length(unique(x)))
res$CSR <- as.vector(round(tapply(dat$bird_id[dat$sex=="M"], dat$species[dat$sex=="M"], function(x) length(unique(x))) / res$NumInd,3))

# Compile results
for(spec in 1:11) {
  load(paste0("Ressim//mod_", spec, ".RData"))
  res[spec, "P_m"] <- round(mean(c(mod[[1]][,"p[1]"],mod[[2]][,"p[1]"])), 3)
  res[spec, "P_f"] <- round(mean(c(mod[[1]][,"p[2]"],mod[[2]][,"p[2]"])), 3)
  res[spec, "Phi_m"] <- round(mean(c(mod[[1]][,"phi[1]"],mod[[2]][,"phi[1]"])), 3)
  res[spec, "Phi_f"] <- round(mean(c(mod[[1]][,"phi[2]"],mod[[2]][,"phi[2]"])), 3)
  res[spec, "Lambda_m"] <- round(mean(c(mod[[1]][,"lambda[1]"],mod[[2]][,"lambda[1]"])), 3)
  res[spec, "Lambda_f"] <- round(mean(c(mod[[1]][,"lambda[2]"],mod[[2]][,"lambda[2]"])), 3)
}

res
apply(res[, c("P_m", "Phi_m", "Lambda_m")], 2, mean)
apply(res[, c("P_f", "Phi_f", "Lambda_f")], 2, mean)
