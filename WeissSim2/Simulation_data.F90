!!****if* source/Simulation/SimulationMain/WeissSim2/Simulation_data
!!
!! NAME
!!  Simulation_data
!!
!! SYNOPSIS
!!  Use Simulation_data
!!
!! DESCRIPTION
!!
!!  Store the simulation data
!!
!! 
!!***
module Simulation_data

  implicit none

#include "constants.h"

  !! *** Runtime Parameters *** !!  
  real, save :: sim_targetIRadius
  real, save :: sim_targetORadius

  real,    save :: sim_rhoDTgas  
  real,    save :: sim_teleDTgas 
  real,    save :: sim_tionDTgas 
  real,    save :: sim_tradDTgas 
  character(len=MAX_STRING_LENGTH), save :: sim_eosDT

  real,    save :: sim_rhoShell  
  real,    save :: sim_teleShell 
  real,    save :: sim_tionShell 
  real,    save :: sim_tradShell 
  character(len=MAX_STRING_LENGTH), save :: sim_eosShell

  real, save :: sim_smallX = 1.0e-99


end module Simulation_data


