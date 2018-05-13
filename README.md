# Analyses of constant effort sites (CES) from Hungary

Adult sex ratios and true survival of male and female birds. Analyses of constant effort sites (CES) from Hungary.

## General R-Files to process data and results
The following files are available in the `R` folder:

- `Data_processing.R`: This script is loading the original data, is doing some data tests and saves the preparade data in `RData/dat.RData`. To run this script one needs acces to the excel File with the orginal data (`CES 2004_2015.xlsx`)

- `Compile_Results.R`: Loads the mcmc results for all species from the `Ressim` folder and calculates some summary statistics that were partly used in the manuscript.

- `Figures.R`: Loads the mcmc results for all species from the `Ressim` folder and produces the figures presented in the manuscript. The resulting pdfs of the figures are saved in the `Results` folder.


## Files to run Bugsmodel for each species
The files needed to run the model in JAGS (from R using `rjags`) are available in the `JAGS` folder:

- `CES.R`: For one speices this prepares the data for jags, all the seetings for jags (including initial valus, burn-in etc.), starts JAGS. As soon the run in JAGS is terminated the file also saves the mcmc results in the `Ressim` folder. 

- `Model.R`: Contains the formulation of the multi-state capture-recapture model (inclduing priors) in BUGS-language.

- `Make_Files.R` and `job.sh` are needed to run the analyses for all 11 species at the clusters of [sciCORE](https://scicore.unibas.ch) of the University of Basel. 

