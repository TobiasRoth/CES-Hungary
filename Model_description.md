# Model description

### Formal description of the data

Let's assume that the study lasted $T​$ years and we index each year with $t=1,...,T​$. Furthermore, let's assume that over the entire study period $N​$ individuals were marked in total and that we index the individuals with $i=1,...,N​$. We can thus express the capturing-histories with the matrix $y_{i,t}​$ with $y_{i,t}=1​$ if individual $i​$ was captured during year $t​$ and $y_{i,t}=0​$ otherwise. 

Similarly, we express the state-histories with the matrix  $z_{i,t}=s$  indicating that individual $i$ during year $t$ was in state $s$. We consider three different states: $s=1$ for alive individuals that are still at the site where they were marked; $s=2$ for individuals dispersed from the site where they were marked; and $s=3$ for dead individuals. Note, that the state of an individual is only known for the years it was captured  (i.e. $y_{i,t}=1$). Thus,  the state-histories  matrix  $z_{i,t}$  is only partly  known. Also note, that in the data $z_{i,t}=3$  was not possible because the state is known only from captured individuals that are alive thus $s\neq3$.

Additionally to the fully observed capturing-histories $y_{i,t}​$ and the partly observed state-histories $z_{i,t}​$ we also observed for each individual $i​$ the year $t​$ when it was marked ($m_i=t​$) and the sex ($S_i=1​$ for males and $S_i=2​$ for females). Further, we know for each capturing site $c​$  the number of days with capturing activities  in each year (i.e. the number of capturing occasions $o_{c,t}​$).

### Biological process model

How the individuals changed states between years is the biological process we were interested in. We assume that this biological process can be described with only two parameters, that ist the average probability that an individual survives from one year to the next (survival probability $\phi_s$ or mortality $1-\phi_s$) and the average probability that an individual that was present at the capturing site during one year remains at the capturing site also in the next year given its survival (site fidelity $\lambda_s$ or dispersal probability $1-\lambda_s$). Note, that we assumed that both parameters were sex specific, which we indicated with  the subscript $s$. For an individual that was at the capturing site in year $t-1$ (i.e. $z_{i,t-1}=1$) all three states were possible during year $t$: the individual will be at the marking site if it survived and did not disperse that is  $z_{i,t}=1$ with probability $\phi_s \lambda_s$, the individual will be outside the marking site if it survived and dispersed that is  $z_{i,t}=2$ with probability $\phi_s (1-\lambda_s)$ and the individual will be dead if it had not survived, that is  $z_{i,t}=3$ with probability $1-\phi_s $. For  an individual that already dispersed from the capturing site in year $t-1$ (i.e. $z_{i,t-1}=2$) we made the important assumption that it was not possible that this individual went back to the capturing site in year $t$ and thus only state 2 and 3 were possible: the individual will remain in state 2 if it survives that is $z_{i,t}=2$ with probability $\phi_s $ and it will be dead if it had not survived, that is  $z_{i,t}=3$ with probability $1-\phi_s $. Quite obviously, an individuals that was dead in year $t-1$  (i.e. $z_{i,t-1}=3$) remained dead in year $t$ thus the probability for $z_{i,t}=3$ was 1. These transition probabilities of states between two consecutive years can concisely be described using the state transition matrix $T$ with rows representing states at year $t-1$  and columns states at year $t$.

$$
T = \begin{bmatrix}
\phi_s \lambda_s & \phi_s(1-\lambda_s) & 1-\phi_s \\
0                & \phi_s              & 1-\phi_s \\
0                & 0                   & 1
\end{bmatrix}
$$

Note, that individuals need always to be in one of the three states and thus the sum of the probabilities in each line of the state transition matrix $T$ need to sum to 1, which is the case. We can now express the state of an individual $i$ at year $t$ using a categorical distribution with the probabilities for the three states depending on the state of the individual in the previous year (i.e. $z_{i,t-1}$): if   $z_{i,t-1}=1$ then the probabilities are according to the first line of the state transition matrix $T$, if   $z_{i,t-1}=2$ the probabilities of the second line and if $z_{i,t-1}=3$ the probabilities of the third line. 
$$
    z_{i,t} \sim Categorical(T_{z_{i,t-1},.})
$$

### Capturing process model

Whether an individual $i$ is captured in year $t$ (i.e.  $y_{i,t}$) depends on the state of the individual in the same year (i.e. $z_{i,t}​$). 



y[i,t] ~ dbern(P[firstcapsite[i], t, z[i,t],sex[i]])







 Further, note that whenever the state of an individual was unknown, all three states were possible except for individuals that were previously captured outside the marking site and thus s=1 was not possible.

### Implementation in BUGS language



````R
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
````

**Figure 1:** Model formulation in BUGS language.

