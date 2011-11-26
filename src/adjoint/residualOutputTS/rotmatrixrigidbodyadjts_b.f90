   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
   !  
   !  Differentiation of rotmatrixrigidbodyadjts in reverse (adjoint) mode:
   !   gradient, with respect to input variables: rotpointadj rotationpointadj
   !   of linear combination of output variables: rotpointadj rotationpointadj
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          rotMatrixRigidBodyAdj.f90                       *
   !      * Author:        Edwin van der Weide ,C.A.(Sandy) Mader          *
   !      * Starting date: 12-15-2003                                      *
   !      * Last modified: 06-12-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE ROTMATRIXRIGIDBODYADJTS_B(tnew, told, rotationmatrix, &
   &  rotationpointadj, rotationpointadjb, rotpointadj, rotpointadjb)
   USE flowvarrefstate
   USE inputmotion
   USE monitor
   IMPLICIT NONE
   REAL(KIND=REALTYPE) :: rotationmatrix(3, 3)
   REAL(KIND=REALTYPE) :: rotationpointadj(3), rotationpointadjb(3)
   REAL(KIND=REALTYPE) :: rotpointadj(3), rotpointadjb(3)
   REAL(KIND=REALTYPE), INTENT(IN) :: tnew
   REAL(KIND=REALTYPE), INTENT(IN) :: told
   REAL(KIND=REALTYPE) :: cosx, cosy, cosz, sinx, siny, sinz
   INTEGER(KIND=INTTYPE) :: i, j
   REAL(KIND=REALTYPE) :: mnew(3, 3), mold(3, 3)
   REAL(KIND=REALTYPE) :: phi
   REAL(KIND=REALTYPE) :: RIGIDROTANGLEADJ
   INTRINSIC COS, SIN
   rotpointadjb(3) = rotpointadjb(3) + lref*rotationpointadjb(3)
   rotationpointadjb(3) = 0.0
   rotpointadjb(2) = rotpointadjb(2) + lref*rotationpointadjb(2)
   rotationpointadjb(2) = 0.0
   rotpointadjb(1) = rotpointadjb(1) + lref*rotationpointadjb(1)
   rotationpointadjb(1) = 0.0
   END SUBROUTINE ROTMATRIXRIGIDBODYADJTS_B