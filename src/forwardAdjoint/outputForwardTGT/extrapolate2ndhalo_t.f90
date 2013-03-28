   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.7 (r4786) - 21 Feb 2013 15:53
   !
   !  Differentiation of extrapolate2ndhalo in forward (tangent) mode (with options debugTangent i4 dr8 r8):
   !   variations   of useful results: *rev *p *gamma *w *rlv
   !   with respect to varying inputs: *rev *p *gamma *w *rlv rgas
   !   Plus diff mem management of: rev:in p:in gamma:in w:in rlv:in
   !                bcdata:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          extrapolate2ndHalo.f90                          *
   !      * Author:        Edwin van der Weide                             *
   !      * Starting date: 03-10-2003                                      *
   !      * Last modified: 06-12-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE EXTRAPOLATE2NDHALO_T(nn, correctfork)
   USE CONSTANTS
   USE ITERATION
   USE FLOWVARREFSTATE
   USE BLOCKPOINTERS_D
   USE BCTYPES
   USE INPUTPHYSICS
   USE DIFFSIZES
   !  Hint: ISIZE3OFDrfrlv should be the size of dimension 3 of array *rlv
   !  Hint: ISIZE2OFDrfrlv should be the size of dimension 2 of array *rlv
   !  Hint: ISIZE1OFDrfrlv should be the size of dimension 1 of array *rlv
   !  Hint: ISIZE4OFDrfw should be the size of dimension 4 of array *w
   !  Hint: ISIZE3OFDrfw should be the size of dimension 3 of array *w
   !  Hint: ISIZE2OFDrfw should be the size of dimension 2 of array *w
   !  Hint: ISIZE1OFDrfw should be the size of dimension 1 of array *w
   !  Hint: ISIZE3OFDrfp should be the size of dimension 3 of array *p
   !  Hint: ISIZE2OFDrfp should be the size of dimension 2 of array *p
   !  Hint: ISIZE1OFDrfp should be the size of dimension 1 of array *p
   !  Hint: ISIZE3OFDrfrev should be the size of dimension 3 of array *rev
   !  Hint: ISIZE2OFDrfrev should be the size of dimension 2 of array *rev
   !  Hint: ISIZE1OFDrfrev should be the size of dimension 1 of array *rev
   !  Hint: ISIZE3OFDrfgamma should be the size of dimension 3 of array *gamma
   !  Hint: ISIZE2OFDrfgamma should be the size of dimension 2 of array *gamma
   !  Hint: ISIZE1OFDrfgamma should be the size of dimension 1 of array *gamma
   IMPLICIT NONE
   !
   !      ******************************************************************
   !      *                                                                *
   !      * extrapolate2ndHalo determines the states of the second layer   *
   !      * halo cells for the given subface of the block. It is assumed   *
   !      * that the pointers in blockPointers are already set to the      *
   !      * correct block on the correct grid level.                       *
   !      *                                                                *
   !      ******************************************************************
   !
   !
   !      Subroutine arguments.
   !
   INTEGER(kind=inttype), INTENT(IN) :: nn
   LOGICAL, INTENT(IN) :: correctfork
   !
   !      Local parameter.
   !
   REAL(kind=realtype), PARAMETER :: factor=0.5_realType
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: i, j, l, idim, ddim
   INTEGER(kind=inttype), DIMENSION(3, 2) :: crange
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww0, ww1, ww2
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww0d, ww1d, ww2d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: pp0, pp1, pp2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: pp0d, pp1d, pp2d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv0, rlv1
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv0d, rlv1d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rev0, rev1
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rev0d, rev1d
   INTERFACE 
   SUBROUTINE SETBCPOINTERS_T(nn, ww1, ww1d, ww2, ww2d, pp1, pp1d, &
   &        pp2, pp2d, rlv1, rlv1d, rlv2, rlv2d, rev1, rev1d, rev2, rev2d, &
   &        offset)
   USE BLOCKPOINTERS_D
   INTEGER(kind=inttype), INTENT(IN) :: nn, offset
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww1, ww2
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww1d, ww2d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: pp1, pp2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: pp1d, pp2d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv1, rlv2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv1d, rlv2d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rev1, rev2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rev1d, rev2d
   END SUBROUTINE SETBCPOINTERS_T
   END INTERFACE
      INTRINSIC MAX
   INTERFACE 
   SUBROUTINE SETBCPOINTERS(nn, ww1, ww2, pp1, pp2, rlv1, rlv2, &
   &        rev1, rev2, offset)
   USE BLOCKPOINTERS_D
   INTEGER(kind=inttype), INTENT(IN) :: nn, offset
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww1, ww2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: pp1, pp2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rlv1, rlv2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rev1, rev2
   END SUBROUTINE SETBCPOINTERS
   END INTERFACE
      EXTERNAL DEBUG_TGT_HERE
   LOGICAL :: DEBUG_TGT_HERE
   IF (.TRUE. .AND. DEBUG_TGT_HERE('entry', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('rev', rev, revd, ISIZE1OFDrfrev*&
   &                        ISIZE2OFDrfrev*ISIZE3OFDrfrev)
   CALL DEBUG_TGT_REAL8ARRAY('p', p, pd, ISIZE1OFDrfp*ISIZE2OFDrfp*&
   &                        ISIZE3OFDrfp)
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                        ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                        ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_REAL8('rgas', rgas, rgasd)
   CALL DEBUG_TGT_DISPLAY('entry')
   END IF
   CALL DEBUG_TGT_CALL('SETBCPOINTERS', .TRUE., .FALSE.)
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Nullify the pointers and set them to the correct subface.
   ! They are nullified first, because some compilers require that.
   ! Note that rlv0 and rev0 are used here as dummies.
   !nullify(ww1, ww2, pp1, pp2, rlv1, rlv0, rev1, rev0)
   CALL SETBCPOINTERS_T(nn, ww1, ww1d, ww2, ww2d, pp1, pp1d, pp2, pp2d, &
   &                 rlv1, rlv1d, rlv0, rlv0d, rev1, rev1d, rev0, rev0d, 0)
   CALL DEBUG_TGT_EXIT()
   !_intType)
   ! Set a couple of additional variables needed for the
   ! extrapolation. This depends on the block face on which the
   ! subface is located.
   SELECT CASE  (bcfaceid(nn)) 
   CASE (imin) 
   ww0d => wd(0, 1:, 1:, :)
   ww0 => w(0, 1:, 1:, :)
   pp0d => pd(0, 1:, 1:)
   pp0 => p(0, 1:, 1:)
   IF (viscous) THEN
   rlv0d => rlvd(0, 1:, 1:)
   rlv0 => rlv(0, 1:, 1:)
   END IF
   IF (eddymodel) THEN
   rev0d => revd(0, 1:, 1:)
   rev0 => rev(0, 1:, 1:)
   END IF
   idim = 1
   ddim = 0
   CASE (imax) 
   ww0d => wd(ib, 1:, 1:, :)
   ww0 => w(ib, 1:, 1:, :)
   pp0d => pd(ib, 1:, 1:)
   pp0 => p(ib, 1:, 1:)
   IF (viscous) THEN
   rlv0d => rlvd(ib, 1:, 1:)
   rlv0 => rlv(ib, 1:, 1:)
   END IF
   IF (eddymodel) THEN
   rev0d => revd(ib, 1:, 1:)
   rev0 => rev(ib, 1:, 1:)
   END IF
   idim = 1
   ddim = ib
   CASE (jmin) 
   ww0d => wd(1:, 0, 1:, :)
   ww0 => w(1:, 0, 1:, :)
   pp0d => pd(1:, 0, 1:)
   pp0 => p(1:, 0, 1:)
   IF (viscous) THEN
   rlv0d => rlvd(1:, 0, 1:)
   rlv0 => rlv(1:, 0, 1:)
   END IF
   IF (eddymodel) THEN
   rev0d => revd(1:, 0, 1:)
   rev0 => rev(1:, 0, 1:)
   END IF
   idim = 2
   ddim = 0
   CASE (jmax) 
   ww0d => wd(1:, jb, 1:, :)
   ww0 => w(1:, jb, 1:, :)
   pp0d => pd(1:, jb, 1:)
   pp0 => p(1:, jb, 1:)
   IF (viscous) THEN
   rlv0d => rlvd(1:, jb, 1:)
   rlv0 => rlv(1:, jb, 1:)
   END IF
   IF (eddymodel) THEN
   rev0d => revd(1:, jb, 1:)
   rev0 => rev(1:, jb, 1:)
   END IF
   idim = 2
   ddim = jb
   CASE (kmin) 
   ww0d => wd(1:, 1:, 0, :)
   ww0 => w(1:, 1:, 0, :)
   pp0d => pd(1:, 1:, 0)
   pp0 => p(1:, 1:, 0)
   IF (viscous) THEN
   rlv0d => rlvd(1:, 1:, 0)
   rlv0 => rlv(1:, 1:, 0)
   END IF
   IF (.TRUE. .AND. DEBUG_TGT_HERE('middle', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('rev', rev, revd, ISIZE1OFDrfrev*&
   &                          ISIZE2OFDrfrev*ISIZE3OFDrfrev)
   CALL DEBUG_TGT_REAL8ARRAY('p', p, pd, ISIZE1OFDrfp*ISIZE2OFDrfp*&
   &                          ISIZE3OFDrfp)
   CALL DEBUG_TGT_REAL8ARRAY('gamma', gamma, gammad, ISIZE1OFDrfgamma&
   &                          *ISIZE2OFDrfgamma*ISIZE3OFDrfgamma)
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                          ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                          ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_REAL8('rgas', rgas, rgasd)
   CALL DEBUG_TGT_DISPLAY('middle')
   END IF
   IF (eddymodel) THEN
   rev0d => revd(1:, 1:, 0)
   rev0 => rev(1:, 1:, 0)
   END IF
   idim = 3
   ddim = 0
   CASE (kmax) 
   ww0d => wd(1:, 1:, kb, :)
   ww0 => w(1:, 1:, kb, :)
   pp0d => pd(1:, 1:, kb)
   pp0 => p(1:, 1:, kb)
   IF (viscous) THEN
   rlv0d => rlvd(1:, 1:, kb)
   rlv0 => rlv(1:, 1:, kb)
   END IF
   IF (eddymodel) THEN
   rev0d => revd(1:, 1:, kb)
   rev0 => rev(1:, 1:, kb)
   END IF
   idim = 3
   ddim = kb
   END SELECT
   ! Loop over the generic subface to set the state in the halo's.
   DO j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
   DO i=bcdata(nn)%icbeg,bcdata(nn)%icend
   ! Extrapolate the density, momentum and pressure.
   ! Make sure that a certain threshold is kept.
   ww0d(i, j, irho) = two*ww1d(i, j, irho) - ww2d(i, j, irho)
   ww0(i, j, irho) = two*ww1(i, j, irho) - ww2(i, j, irho)
   IF (factor*ww1(i, j, irho) .LT. ww0(i, j, irho)) THEN
   ww0(i, j, irho) = ww0(i, j, irho)
   ELSE
   ww0d(i, j, irho) = factor*ww1d(i, j, irho)
   ww0(i, j, irho) = factor*ww1(i, j, irho)
   END IF
   ww0d(i, j, ivx) = two*ww1d(i, j, ivx) - ww2d(i, j, ivx)
   ww0(i, j, ivx) = two*ww1(i, j, ivx) - ww2(i, j, ivx)
   ww0d(i, j, ivy) = two*ww1d(i, j, ivy) - ww2d(i, j, ivy)
   ww0(i, j, ivy) = two*ww1(i, j, ivy) - ww2(i, j, ivy)
   ww0d(i, j, ivz) = two*ww1d(i, j, ivz) - ww2d(i, j, ivz)
   ww0(i, j, ivz) = two*ww1(i, j, ivz) - ww2(i, j, ivz)
   IF (factor*pp1(i, j) .LT. two*pp1(i, j) - pp2(i, j)) THEN
   pp0d(i, j) = two*pp1d(i, j) - pp2d(i, j)
   pp0(i, j) = two*pp1(i, j) - pp2(i, j)
   ELSE
   pp0d(i, j) = factor*pp1d(i, j)
   pp0(i, j) = factor*pp1(i, j)
   END IF
   ! Extrapolate the turbulent variables. Use constant
   ! extrapolation.
   DO l=nt1mg,nt2mg
   ww0d(i, j, l) = ww1d(i, j, l)
   ww0(i, j, l) = ww1(i, j, l)
   END DO
   ! The laminar and eddy viscosity, if present. These values
   ! are simply taken constant. Their values do not matter.
   IF (viscous) THEN
   rlv0d(i, j) = rlv1d(i, j)
   rlv0(i, j) = rlv1(i, j)
   END IF
   IF (eddymodel) THEN
   rev0d(i, j) = rev1d(i, j)
   rev0(i, j) = rev1(i, j)
   END IF
   END DO
   END DO
   ! Set the range for the halo cells for the energy computation.
   crange(1, 1) = icbeg(nn)
   crange(1, 2) = icend(nn)
   crange(2, 1) = jcbeg(nn)
   crange(2, 2) = jcend(nn)
   crange(3, 1) = kcbeg(nn)
   crange(3, 2) = kcend(nn)
   crange(idim, 1) = ddim
   crange(idim, 2) = ddim
   CALL DEBUG_TGT_CALL('COMPUTEETOT', .TRUE., .FALSE.)
   ! Compute the energy for this halo range.
   CALL COMPUTEETOT_T(crange(1, 1), crange(1, 2), crange(2, 1), crange(2&
   &               , 2), crange(3, 1), crange(3, 2), correctfork)
   CALL DEBUG_TGT_EXIT()
   IF (.TRUE. .AND. DEBUG_TGT_HERE('exit', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('rev', rev, revd, ISIZE1OFDrfrev*&
   &                        ISIZE2OFDrfrev*ISIZE3OFDrfrev)
   CALL DEBUG_TGT_REAL8ARRAY('p', p, pd, ISIZE1OFDrfp*ISIZE2OFDrfp*&
   &                        ISIZE3OFDrfp)
   CALL DEBUG_TGT_REAL8ARRAY('gamma', gamma, gammad, ISIZE1OFDrfgamma*&
   &                        ISIZE2OFDrfgamma*ISIZE3OFDrfgamma)
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                        ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                        ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_DISPLAY('exit')
   END IF
   END SUBROUTINE EXTRAPOLATE2NDHALO_T
