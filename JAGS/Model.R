model {
  # Priors
  psi ~ dunif(0,1)
  for(g in 1:2) {
    phi[g] ~ dunif(0,1)
    lambda[g] ~ dunif(0,1)
    p[g] ~ dunif(0,1)
    
    # State transition matrix
    T[1,1,g] <- phi[g] * lambda[g]
    T[1,2,g] <- phi[g] * (1-lambda[g])
    T[1,3,g] <- (1-phi[g])
    T[2,1,g] <- 0
    T[2,2,g] <- phi[g]
    T[2,3,g] <- (1-phi[g])
    T[3,1,g] <- 0
    T[3,2,g] <- 0
    T[3,3,g] <- 1
    
    # Detection probability given state
    for(c in 1:C) {
      for(t in 1:T) {
        P[c,t,1,g] <- 1 - (pow((1-p[g]), O[c,t]))
        P[c,t,2,g] <- psi 
        P[c,t,3,g] <- 0
      }
    }
  }
  
  # Likelihood
  for(i in 1:N) {
    z[i,m[i]] <- 1
    for(t in (m[i]+1):T) {
      z[i,t] ~ dcat(T[z[i,t-1],,S[i]])
      y[i,t] ~ dbern(P[K[i], t, z[i,t],S[i]])
    }
  }
}
