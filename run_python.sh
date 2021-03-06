#!/bin/bash

#SBATCH -J Test #Single job name for the entire JobArray

#SBATCH -o slurm.out #standard output

#SBATCH -e slurm.err #standard error

#SBATCH -p general #partition

#SBATCH -t 00:10:00 #running time

#SBATCH --mail-type=BEGIN

#SBATCH --mail-type=END

#SBATCH --mail-user=iancze@gmail.com

#SBATCH --mem 1000 #memory request per node

#SBATCH -N 1 #ensure all jobs are on the same node

#SBATCH -n 8

## Call cpu_list to get the currently running CPUS

echo "numactl says"
numactl --show

CPUMASTER=`./cpu_list_numa.py --which first`

CPULIST=`./cpu_list_numa.py --which rest`

echo "Master CPU is $CPUMASTER"
echo "Worker CPUs are $CPULIST"

#Constrain the brain process to start on CPUMASTER, then add the workers in using AffinityManager.
# taskset -c $CPUMASTER ./add_workers_manager.jl $CPULIST
emcee_parallel.py

# numactl -C $CPUMASTER ./add_workers_manager.jl --cpus $CPULIST
