#******************************************************************************
#
# Make files to run one jobs per species on clustr
#
#******************************************************************************

rm(list=ls(all=TRUE))

setwd("/scicore/home/amrhein/rothto00/CES")

# for(s in 1:11) {
for(s in c(6, 9, 10)) {
    #try(dir.create(paste0("Spec_", s), showWarnings = FALSE))
  sim <- readLines("1006_CES_v3.R", n = -1)
  sim[17] <- paste("spec <- ", s, sep = "")
  writeLines(text=sim, con=paste0("R_", s, ".R", sep=""))
  job <- readLines("job.sh", n = -1)
  job[2] <- paste("#$ -N ", "Sp_", s, sep="")
  job[9] <- paste0("MODEL=\"R_", s, ".R\"")
  writeLines(text=job, con=paste0("job_", s, ".sh"))
  system(paste0("qsub job_", s, ".sh"))
}

