model {

  # Priors
  psi ~ dunif(0,1)
  for(s in 1:2) {
    phi[s] ~ dunif(0,1)
    lambda[s] ~ dunif(0,1)
    p[s] ~ dunif(0,1)
    
    # State transition matrix
    T[1,1,s] <- phi[s] * lambda[s]
    T[1,2,s] <- phi[s] * (1-lambda[s])
    T[1,3,s] <- (1-phi[s])
    T[2,1,s] <- 0
    T[2,2,s] <- phi[s]
    T[2,3,s] <- (1-phi[s])
    T[3,1,s] <- 0
    T[3,2,s] <- 0
    T[3,3,s] <- 1
    
    # Detection probability given state
    for(c in 1:ncapsite) {
      for(t in 1:nyears) {
        P[c,t,1,s] <- 1 - (pow((1-p[s]), ncapoc[c,t]))
        P[c,t,2,s] <- psi 
        P[c,t,3,s] <- 0
      }
    }

  }
  
  # Likelihood
  for(i in 1:N) {
    z[i,capyear[i]] ~ dbern(1)
    for(t in (capyear[i]+1):nyears) {
      z[i,t] ~ dcat(T[z[i,t-1],,sex[i]])
      y[i,t] ~ dbern(P[firstcapsite[i], t, z[i,t],sex[i]])
    }
  }
    
}
