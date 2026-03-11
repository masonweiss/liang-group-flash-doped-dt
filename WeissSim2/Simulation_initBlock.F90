!!****if* source/Simulation/SimulationMain/WeissSim2/Simulation_initBlock
!!
!! NAME
!!
!!  Simulation_initBlock
!!
!!
!! SYNOPSIS
!!
!!  call Simulation_initBlock(integer(IN) :: blockID) 
!!                       
!!
!!
!!
!! DESCRIPTION
!!
!!  Initializes fluid data (density, pressure, velocity, etc.) for
!!  a specified block.
!! 
!! ARGUMENTS
!!
!!  blockID -        the number of the block to initialize
!!  
!!
!!
!!***

subroutine Simulation_initBlock(blockId)
  use Simulation_data
  use Grid_interface, ONLY : Grid_getBlkIndexLimits, &
    Grid_getCellCoords, Grid_putPointData

  implicit none


#include "constants.h"
#include "Flash.h"

  ! compute the maximum length of a vector in each coordinate direction 
  ! (including guardcells)

  integer, intent(in) :: blockId
  
  integer :: i, j, k, n
  integer :: blkLimits(2, MDIM)
  integer :: blkLimitsGC(2, MDIM)
  integer :: axis(MDIM)
  real, allocatable :: xcent(:), ycent(:), zcent(:)
  real :: tradActual
  real :: rho, tele, trad, tion, r
  integer :: species

#ifndef DT_SPEC
  integer :: DT_SPEC = 1, SHELL_SPEC = 2
#endif

  ! Get index limits
  call Grid_getBlkIndexLimits(blockId, blkLimits, blkLimitsGC)

  ! Always get radial coordinate (IAXIS)
  allocate(xcent(blkLimitsGC(HIGH, IAXIS)))
  call Grid_getCellCoords(IAXIS, blockId, CENTER, .true., &
       xcent, blkLimitsGC(HIGH, IAXIS))

  ! Only allocate y/z if dimensionality requires it
  if (NDIM >= 2) then
     allocate(ycent(blkLimitsGC(HIGH, JAXIS)))
     call Grid_getCellCoords(JAXIS, blockId, CENTER, .true., &
          ycent, blkLimitsGC(HIGH, JAXIS))
  end if

  if (NDIM >= 3) then
     allocate(zcent(blkLimitsGC(HIGH, KAXIS)))
     call Grid_getCellCoords(KAXIS, blockId, CENTER, .true., &
          zcent, blkLimitsGC(HIGH, KAXIS))
  end if

    !------------------------------------------------------------------------------

  ! Loop over cells and set the initial state
  do k = blkLimits(LOW,KAXIS),blkLimits(HIGH,KAXIS)
     do j = blkLimits(LOW,JAXIS),blkLimits(HIGH,JAXIS)
        do i = blkLimits(LOW,IAXIS),blkLimits(HIGH,IAXIS)

           axis(IAXIS) = i
           axis(JAXIS) = j
           axis(KAXIS) = k

           r = xcent(i)   ! in 1D spherical, x is radius
           
           ! Default: exterior/ambient (treat as DT gas for now, or define a third ambient set)
           rho  = sim_rhoDTgas
           tele = sim_teleDTgas
           tion = sim_tionDTgas
           trad = sim_tradDTgas
           species = DT_SPEC   ! map DT gas to "chamber species index"
           
           if (r >= sim_targetIRadius .and. r <= sim_targetORadius) then
               rho  = sim_rhoShell
               tele = sim_teleShell
               tion = sim_tionShell
               trad = sim_tradShell
               species = SHELL_SPEC  ! map shell to "target species index"
           end if

           call Grid_putPointData(blockId, CENTER, DENS_VAR, EXTERIOR, axis, rho)
           call Grid_putPointData(blockId, CENTER, TEMP_VAR, EXTERIOR, axis, tele)

           if (NSPECIES > 0) then
              ! Fill mass fractions in solution array if we have any SPECIES defined.
              ! We put nearly all the mass into either the Xe material if XE_SPEC is defined,
              ! or else into the first species.
              do n = SPECIES_BEGIN,SPECIES_END
                 if (n==species) then
                    call Grid_putPointData(blockID, CENTER, n, EXTERIOR, axis, 1.0e0-(NSPECIES-1)*sim_smallX)
                 else
                    call Grid_putPointData(blockID, CENTER, n, EXTERIOR, axis, sim_smallX)
                 end if
              enddo
           end if

#ifdef BDRY_VAR
           call Grid_putPointData(blockId, CENTER, BDRY_VAR, EXTERIOR, axis, -1.0)
#endif
         enddo
     enddo
  enddo

  deallocate(xcent)
  if (allocated(ycent)) deallocate(ycent)
  if (allocated(zcent)) deallocate(zcent)
end subroutine Simulation_initBlock
