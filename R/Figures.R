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
library(xlsx)

#------------------------------------------------------------------------------
# Load results 
#------------------------------------------------------------------------------
# Load all data into 'dat' and select data of one species into 'd'
load("RData/dat.RData")
res <- data.frame(Species = names(table(dat$species)))
res$NumInd <- tapply(dat$bird_id, dat$species, function(x) length(unique(x)))
res$CSR <- as.vector(round(tapply(dat$bird_id[dat$sex=="M"], dat$species[dat$sex=="M"], function(x) length(unique(x))) / res$NumInd,3))

# Compile results
for(spec in 1:11) {
  load(paste0("Ressim/mod_", spec, ".RData"))
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

# Correlations
t.test(res$P_m / res$P_f, mu = 1)
t.test(res$Phi_m / res$Phi_f, mu = 1)
t.test(res$Lambda_m / res$Lambda_f, mu = 1)

cor.test(res$CSR, res$P_m / res$P_f)
cor.test(res$CSR, res$Phi_m / res$Phi_f)
cor.test(res$CSR, res$Lambda_m / res$Lambda_f)

#------------------------------------------------------------------------------
# Figure: Survival
#------------------------------------------------------------------------------
pdf("Results/survival.pdf", width = 6, height = 4.5)
par(mar = c(5, 5, 2, 2))
plot(NA, ylim = c(0,1), xlim = c(0,1), axes = FALSE,
     xlab = "Female survival", 
     ylab = "Male survival")
axis(1, pos = 0)
axis(2, pos = 0, las = 1)
lines(c(0,1), c(0,1), lty = 2)
for(spec in 1:11) {
  load(paste0("Ressim//mod_", spec, ".RData"))
  f <- c(mod[[1]][,"phi[2]"],mod[[2]][,"phi[2]"])
  m <- c(mod[[1]][,"phi[1]"],mod[[2]][,"phi[1]"])
  segments(mean(f), quantile(m, probs = 0.025), mean(f), quantile(m, probs = 0.975), lwd = 0.5, col = "black")
  segments(quantile(f, probs = 0.025), mean(m), quantile(f, probs = 0.975), mean(m), lwd = 0.5, col = "black")
  points(mean(f), mean(m), pch = 16, cex = 0.8, col = "black")
  text(mean(f)+0.04, mean(m)+0.03, paste(res$Species[spec]), cex = 0.4)
}
dev.off()

#------------------------------------------------------------------------------
# Figure: Site fidelity
#------------------------------------------------------------------------------
pdf("Results/Site_fidelity.pdf", width = 6, height = 4.5)
par(mar = c(5, 5, 2, 2))
plot(NA, ylim = c(0,1), xlim = c(0,1), axes = FALSE,
     xlab = "Female site fidelity", 
     ylab = "Male site fidelity")
axis(1, pos = 0)
axis(2, pos = 0, las = 1)
lines(c(0,1), c(0,1), lty = 2)
for(spec in 1:11) {
  load(paste0("Ressim//mod_", spec, ".RData"))
  f <- c(mod[[1]][,"lambda[2]"],mod[[2]][,"lambda[2]"])
  m <- c(mod[[1]][,"lambda[1]"],mod[[2]][,"lambda[1]"])
  segments(mean(f), quantile(m, probs = 0.025), mean(f), quantile(m, probs = 0.975), lwd = 0.5, col = "black")
  segments(quantile(f, probs = 0.025), mean(m), quantile(f, probs = 0.975), mean(m), lwd = 0.5, col = "black")
  points(mean(f), mean(m), pch = 16, cex = 0.8, col = "black")
  text(mean(f)+0.04, mean(m)+0.03, paste(res$Species[spec]), cex = 0.4)
}
dev.off()

#------------------------------------------------------------------------------
# Figure: Detection probability
#------------------------------------------------------------------------------
pdf("Results/Detection_probability.pdf", width = 6, height = 4.5)
par(mar = c(5, 5, 2, 2))
plot(NA, ylim = c(0,0.1), xlim = c(0,0.1), axes = FALSE,
     xlab = "Female detection probability", 
     ylab = "Male detection probability")
axis(1, pos = 0)
axis(2, pos = 0, las = 1)
lines(c(0,0.1), c(0,0.1), lty = 2)
for(spec in 1:11) {
  load(paste0("Ressim//mod_", spec, ".RData"))
  f <- c(mod[[1]][,"p[2]"],mod[[2]][,"p[2]"])
  m <- c(mod[[1]][,"p[1]"],mod[[2]][,"p[1]"])
  segments(mean(f), quantile(m, probs = 0.025), mean(f), quantile(m, probs = 0.975), lwd = 0.5, col = "black")
  segments(quantile(f, probs = 0.025), mean(m), quantile(f, probs = 0.975), mean(m), lwd = 0.5, col = "black")
  points(mean(f), mean(m), pch = 16, cex = 0.8, col = "black")
  text(mean(f)+0.004, mean(m)+0.003, paste(res$Species[spec]), cex = 0.4)
}
dev.off()
