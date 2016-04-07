!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
!  differentiation of bcturbinterface in reverse (adjoint) mode (with options i4 dr8 r8 noisize):
!   gradient     of useful results: *bvtj1 *bvtj2 *w *bvtk1 *bvtk2
!                *bvti1 *bvti2
!   with respect to varying inputs: *bvtj1 *bvtj2 *w *bvtk1 *bvtk2
!                *bvti1 *bvti2
!   plus diff mem management of: bvtj1:in bvtj2:in w:in bvtk1:in
!                bvtk2:in bvti1:in bvti2:in bcdata:in
!
!      ******************************************************************
!      *                                                                *
!      * file:          bcturbinterface.f90                             *
!      * author:        georgi kalitzin, edwin van der weide            *
!      * starting date: 01-09-2004                                      *
!      * last modified: 06-12-2005                                      *
!      *                                                                *
!      ******************************************************************
!
subroutine bcturbinterface_b(nn)
!
!      ******************************************************************
!      *                                                                *
!      * bcturbinterface applies the halo treatment for interface halo  *
!      * cells, sliding mesh interface and domain interface. as these   *
!      * are not really boundary conditions, the variable bvt is simply *
!      * set to keep the current value.                                 *
!      *                                                                *
!      ******************************************************************
!
  use blockpointers
  use bctypes
  use flowvarrefstate
  implicit none
! note that the original code had an error in the pointers...they
! were pointing to {il,jl,kl} and not {ie, je, ke}.
!
!      subroutine arguments.
!
  integer(kind=inttype), intent(in) :: nn
!
!      local variables.
!
  integer(kind=inttype) :: i, j, l
  integer :: branch
!
!      ******************************************************************
!      *                                                                *
!      * begin execution                                                *
!      *                                                                *
!      ******************************************************************
!
! loop over the faces of the subfaces and set the values of
! bvt to keep the current value.
  do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
    do i=bcdata(nn)%icbeg,bcdata(nn)%icend
      do l=nt1,nt2
        select case  (bcfaceid(nn)) 
        case (imin) 
          call pushcontrol3b(5)
        case (imax) 
          call pushcontrol3b(4)
        case (jmin) 
          call pushcontrol3b(3)
        case (jmax) 
          call pushcontrol3b(2)
        case (kmin) 
          call pushcontrol3b(1)
        case (kmax) 
          call pushcontrol3b(0)
        case default
          call pushcontrol3b(6)
        end select
      end do
    end do
  end do
  do j=bcdata(nn)%jcend,bcdata(nn)%jcbeg,-1
    do i=bcdata(nn)%icend,bcdata(nn)%icbeg,-1
      do l=nt2,nt1,-1
        call popcontrol3b(branch)
        if (branch .lt. 3) then
          if (branch .eq. 0) then
            wd(i, j, ke, l) = wd(i, j, ke, l) + bvtk2d(i, j, l)
            bvtk2d(i, j, l) = 0.0_8
          else if (branch .eq. 1) then
            wd(i, j, 1, l) = wd(i, j, 1, l) + bvtk1d(i, j, l)
            bvtk1d(i, j, l) = 0.0_8
          else
            wd(i, je, j, l) = wd(i, je, j, l) + bvtj2d(i, j, l)
            bvtj2d(i, j, l) = 0.0_8
          end if
        else if (branch .lt. 5) then
          if (branch .eq. 3) then
            wd(i, 1, j, l) = wd(i, 1, j, l) + bvtj1d(i, j, l)
            bvtj1d(i, j, l) = 0.0_8
          else
            wd(ie, i, j, l) = wd(ie, i, j, l) + bvti2d(i, j, l)
            bvti2d(i, j, l) = 0.0_8
          end if
        else if (branch .eq. 5) then
          wd(1, i, j, l) = wd(1, i, j, l) + bvti1d(i, j, l)
          bvti1d(i, j, l) = 0.0_8
        end if
      end do
    end do
  end do
end subroutine bcturbinterface_b
