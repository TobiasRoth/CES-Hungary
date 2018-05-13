#!/bin/bash
#$ -N R1
#$ -cwd
# mail at the end of the job
#$ -m e
# mail to
#$ -M t.roth@unibas.ch

MODEL="1262_JAGS.R"
CURDIR=`pwd`
ID=$$
TEMPDIR=/tmp/$USER/$ID
mkdir -p $TEMPDIR

module load R/3.3.1-goolf-1.7.20

R --vanilla < $CURDIR/$MODEL > $TEMPDIR/${MODEL}.out

cp  $TEMPDIR/${MODEL}.out $CURDIR && rm -rf $TEMPDIR

