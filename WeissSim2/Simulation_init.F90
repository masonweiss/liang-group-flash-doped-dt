!!****if* source/Simulation/SimulationMain/WeissSim2/Simulation_init
!!
!! NAME
!!
!!  Simulation_init
!!
!!
!! SYNOPSIS
!!
!!  Simulation_init()
!!
!!
!! DESCRIPTION
!!
!!  Initializes all the parameters needed for a particular simulation
!!
!!
!! ARGUMENTS
!!
!!  
!!
!! PARAMETERS
!!
!!***

subroutine Simulation_init()
  use Simulation_data
  use RuntimeParameters_interface, ONLY : RuntimeParameters_get
  use Logfile_interface, ONLY : Logfile_stamp
  
  implicit none

#include "constants.h"
#include "Flash.h"

  real :: xmin, xmax
  integer :: lrefine_max, nblockx
  character(len=MAX_STRING_LENGTH) :: str

  call RuntimeParameters_get('sim_targetIRadius', sim_targetIRadius)
  call RuntimeParameters_get('sim_targetORadius', sim_targetORadius)
  
  call RuntimeParameters_get('sim_rhoDTgas', sim_rhoDTgas)
  call RuntimeParameters_get('sim_teleDTgas', sim_teleDTgas)
  call RuntimeParameters_get('sim_tionDTgas', sim_tionDTgas)
  call RuntimeParameters_get('sim_tradDTgas', sim_tradDTgas)

  call RuntimeParameters_get('sim_rhoShell', sim_rhoShell)
  call RuntimeParameters_get('sim_teleShell', sim_teleShell)
  call RuntimeParameters_get('sim_tionShell', sim_tionShell)
  call RuntimeParameters_get('sim_tradShell', sim_tradShell)
  call RuntimeParameters_get('sim_smallX', sim_smallX)

end subroutine Simulation_init
