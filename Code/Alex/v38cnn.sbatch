#!/bin/bash
#SBATCH --export=ALL
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --partition=csl
#SBATCH --mail-user=asilador@illinois.edu
#SBATCH --mail-type=BEGIN,END

module load anaconda/2020-Jul/3

python Part2NNet_thetaz_v38.py

