# FLASH Simulations of High-Z Doped DT


## WeissSim2
Parameters:
- No pressure drive
- Gamma EOS for both DT and HDC Shell

```
module purge
module load slurm
module load cpu/0.17.3b
module load gcc/10.2.0/npcyll4
module load openmpi/4.1.3/oq3qvsv
module load hdf5/1.10.7/5o4oibc
module load hypre/2.23.0/yfgkuad
module load openblas/0.3.18/w4zdqc3
```

```
cd $HOME/flash/FLASH4.8
./setup -auto WeissSim2 -1d +spherical -nxb=64 +hdf5typeio species=dt,hdc -parfile=flash.par
```

```
cd object
echo "ALL_OBJS += Simulation_data.o" > Makefile.h
```
Editing the setup-created Makefile is generally not recommended but seemed to be the only thing that worked.

```
make -j
```
This can take a long time.