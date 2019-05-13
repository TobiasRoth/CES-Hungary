# *Appendix A:* Formal description of the model

This appendix contains a formal description of the model we used to analyze data from the constant effort bird ringing scheme of Hungary. We start with a formal description of the data. We use the word 'observe' to make explicit if a variable describes data as opposed to latent variables that contain unobserved (unknown) quantities. We use the word 'mark' to refer to individuals that were captured the first time and where thus marked with a metal ring, and we use the word 'capture' to refer to individuals that were *re*captured. Accordingly, the 'site of marking' is the site were an individual was marked, and all other ringing sites are potential 'sites of capture'.

### Formal description of the data

The study lasted $T$ years and we index each year with $t=1,...,T$. Birds were ringed at $C$ different sites with index $c=1,...,C$. Over the entire study period, a total of $N$ individuals were marked and we index the individuals with $i=1,...,N$. We express the observed capture histories with the matrix $y_{i,t}$ with $y_{i,t}=1$ if individual $i$ was captured during year $t$ and $y_{i,t}=0$ otherwise. Note that the capture histories start only from the year after an individual $i$ was marked ($m_i$), meaning that the part of the matrix with $y_{i, t \leqslant m_i}$ is not used in the analyses.

We express the partly observed state histories with the matrix $z_{i,t}=s$ indicating that individual $i$ during year $t$ was in state $s$. We consider three different states: $s=1$ for alive individuals that are still at the site where they were marked; $s=2$ for individuals dispersed from the site where they were marked; and $s=3$ for dead individuals. Note again that state histories start only from the year an individual $i$ was marked ($m_i$), meaning that the part of the matrix with $y_{i, t <m_i}$ is not used in the analyses. However, after the year an individual was marked, the state of an individual is only known for the years it was captured (i.e. $y_{i,t}=1$). In our model, the entire state-histories with $z_{i,t \geqslant m_i}$ are used in the analyses, though only part of the state-history is observed (for the years in which an individual was captured). Finally, note that during the year an individual was marked, it has state 1 by definition (i.e. $z_{i,m_i}=1$) and that the observation $z_{i,t}=3$ is not possible because we consider only individuals that were captured alive (thus $s\neq3$).

Additionally to the fully observed capture-histories $y_{i,t}$ and the partly observed state-histories $z_{i,t}$ we also observed for each individual $i$ the sex $S_i$ (with $S_i=1$ for males and $S_i=2$ for females). Finally, we specified for each ringing site $c$ the number of days with capture activities per year (i.e. the number of capture occasions $O_{c,t}$).

### Biological process model

The biological process in which we are interested is how the individuals changed states between years. In the following we describe our model, and as explained in main body of the paper, we explicitly state assumptions we are aware of. This set of assumptions is the model that we use in the present study, and we do not claim those assumptions are justified; in fact all of them are open to criticism and to further investigation, which is why we try to make them explicit.

We assume that the biological process can be described using only two parameters, that is the average probability that an individual survives from one year to the next (survival probability $\phi_s$ or mortality $1-\phi_g$) and the average probability that an individual that was present at the site of marking during one year remains at the site of marking also in the next year given it survived (site fidelity $\lambda_g$ or dispersal probability $1-\lambda_g$). We assumed that both parameters are sex specific, which we indicated with the subscript $g$. For an individual that was at the site of marking in year $t-1$ (i.e. $z_{i,t-1}=1$), all three states are possible during year $t$: the individual will be at the site of marking if it survived and did not disperse, that is $z_{i,t}=1$ with probability $\phi_g \lambda_g$; the individual will be outside the site of marking if it survived and dispersed, that is $z_{i,t}=2$ with probability $\phi_g (1-\lambda_g)$; and the individual will be dead if it did not survive, that is $z_{i,t}=3$ with probability $1-\phi_g $. For an individual that already dispersed from the site of marking in year $t-1$ (i.e. $z_{i,t-1}=2$) we assume that it was not possible to return to the site of marking in year $t$ and thus only state 2 and 3 are possible: the individual will remain in state 2 if it survived, that is $z_{i,t}=2$ with probability $\phi_s $; and it will be dead if it did not survive, that is $z_{i,t}=3$ with probability $1-\phi_g$. Quite obviously, an individual that was dead in year $t-1$ (i.e. $z_{i,t-1}=3$) remained dead in year $t$, thus the probability for $z_{i,t}=3$ was 1. These transition probabilities of states between two consecutive years can concisely be described using the state transition  matrix  $T$ with  rows  representing  states  at year $t-1$ and  columns  states  at year $t$.

$$
T = \begin{bmatrix}
\phi_g \lambda_g & \phi_g(1-\lambda_s) & 1-\phi_g \\
0        & \phi_g       & 1-\phi_g \\
0        & 0          & 1
\end{bmatrix}
$$

Individuals need always to be in one of the three states and thus the sum of the probabilities in each line of the state transition matrix $T$ need to sum to 1, which is the case. We can now express the state of an individual $i$ at year $t$ using a categorical distribution with the probabilities for the three states, depending on the state of the individual in the previous year (i.e. $z_{i,t-1}$): if  $z_{i,t-1}=1$ then the probabilities are according to the first line of the state transition matrix $T$, if  $z_{i,t-1}=2$ then the probabilities are according to the second line and if $z_{i,t-1}=3$ the probabilities are according to the third line. 
$$
z_{i,t} \sim Categorical(T_{z_{i,t-1},.})
$$

Equation (2) formally describes how individuals change states between years using the state transition matrix T of equation (1). Thus, the biological process is described by two sex-specific parameters only.

### Capture process model

To estimate the unobserved states in the state histories matrix ($z_{i,t}$) and to obtain estimates for the two parameters in the state-transition matrix, we need to link the state histories ($z_{i,t}$) with the capture histories ($y_{i,t}$). This is done using the capture process model. We assume that whether an individual $i$ is captured in year $t$ (i.e. $y_{i,t}$) depends on the state-specific capture probability $P_{z_{i,t}}$ and can be described using a Bernoulli distribution.
$$
y_{i,t} \sim Bernoulli(P_{z_{i,t}})
$$
We assume that the probability that an individual in state 1 is captured in a given year (i.e. $P_1$) can be described using $P_1=1-(1-p_g)^{O_{c,t}}$ with $p_g$ being the sex specific probability to capture an individual during a capture occasion and $O_{c,t}$ being the number of capture occasions. The probability that an individual in state 2 is captured (i.e. $P_2$) may mainly depend on the probability whether the individual dispersed to another ringing site which we described with the additional parameter $\psi$, thus $P_2=\psi$. However, if an individual is in state 3 (i.e. it is dead), its capture probability is zero, thus $P_3=0$. 

Equations (1) to (3) are the formal description of the model that we applied to the data of the constant effort ringing sites in Hungary. It is a relatively simplistic model that contains only four parameters, three of which are sex-specific: survival probability $\phi_s$, site fidelity $\lambda_g$, capture probability of state 1 individuals during a capture occasion $p_g$ and capture probability of state 2 individuals $\psi$. 

### Implementation in BUGS language

We implemented the model as described above in the BUGS language (Fig. 1; we also provide all data and R- and BUGS-scripts to run the model on https://github.com/TobiasRoth/CES-Hungary). Lines 3 to 7 of the BUGS model in Fig.1 describe the assumed priors for the four parameters of the model (psi, phi, lambda and p); lines 10 to 18 describe the state transition matrix and thus correspond to eq. (1); line 23 to 25 describe the state-specific detection probability $P_{z_{i,t}}$; line 34 describes the biological process model of eq. (2); and line 35 describes the capture process model of eq. (3).

````R
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
 
 # Likelihood (biological and capture process model)
 for(i in 1:N) {
  z[i,m[i]] <- 1
  for(t in (m[i]+1):T) {
   z[i,t] ~ dcat(T[z[i,t-1],,S[i]])
   y[i,t] ~ dbern(P[K[i], t, z[i,t],S[i]])
  }
 }
}
````

**Figure 1:** Model formulation in BUGS language.

