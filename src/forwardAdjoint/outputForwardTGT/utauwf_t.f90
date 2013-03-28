   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.7 (r4786) - 21 Feb 2013 15:53
   !
   !  Differentiation of utauwf in forward (tangent) mode (with options debugTangent i4 dr8 r8):
   !   variations   of useful results: *fw *(*viscsubface.tau)
   !   with respect to varying inputs: *w *rlv *si *sj *sk *fw *(*viscsubface.tau)
   !                *(*bcdata.norm)
   !   Plus diff mem management of: w:in rlv:in si:in sj:in sk:in
   !                fw:in viscsubface:in *viscsubface.tau:in bcdata:in
   !                *bcdata.norm:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          utauWF.f90                                      *
   !      * Author:        Georgi Kalitzin, Edwin van der Weide            *
   !      * Starting date: 10-01-2003                                      *
   !      * Last modified: 06-12-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE UTAUWF_T(rfilv)
   USE FLOWVARREFSTATE
   USE BLOCKPOINTERS_D
   USE BCTYPES
   USE INPUTPHYSICS
   USE DIFFSIZES
   !  Hint: ISIZE3OFDrfDrfbcdata_norm should be the size of dimension 3 of array **bcdata%norm
   !  Hint: ISIZE2OFDrfDrfbcdata_norm should be the size of dimension 2 of array **bcdata%norm
   !  Hint: ISIZE1OFDrfDrfbcdata_norm should be the size of dimension 1 of array **bcdata%norm
   !  Hint: ISIZE1OFDrfbcdata should be the size of dimension 1 of array *bcdata
   !  Hint: ISIZE3OFDrfDrfviscsubface_tau should be the size of dimension 3 of array **viscsubface%tau
   !  Hint: ISIZE2OFDrfDrfviscsubface_tau should be the size of dimension 2 of array **viscsubface%tau
   !  Hint: ISIZE1OFDrfDrfviscsubface_tau should be the size of dimension 1 of array **viscsubface%tau
   !  Hint: ISIZE1OFDrfviscsubface should be the size of dimension 1 of array *viscsubface
   !  Hint: ISIZE4OFDrffw should be the size of dimension 4 of array *fw
   !  Hint: ISIZE3OFDrffw should be the size of dimension 3 of array *fw
   !  Hint: ISIZE2OFDrffw should be the size of dimension 2 of array *fw
   !  Hint: ISIZE1OFDrffw should be the size of dimension 1 of array *fw
   !  Hint: ISIZE4OFDrfsk should be the size of dimension 4 of array *sk
   !  Hint: ISIZE3OFDrfsk should be the size of dimension 3 of array *sk
   !  Hint: ISIZE2OFDrfsk should be the size of dimension 2 of array *sk
   !  Hint: ISIZE1OFDrfsk should be the size of dimension 1 of array *sk
   !  Hint: ISIZE4OFDrfsj should be the size of dimension 4 of array *sj
   !  Hint: ISIZE3OFDrfsj should be the size of dimension 3 of array *sj
   !  Hint: ISIZE2OFDrfsj should be the size of dimension 2 of array *sj
   !  Hint: ISIZE1OFDrfsj should be the size of dimension 1 of array *sj
   !  Hint: ISIZE4OFDrfsi should be the size of dimension 4 of array *si
   !  Hint: ISIZE3OFDrfsi should be the size of dimension 3 of array *si
   !  Hint: ISIZE2OFDrfsi should be the size of dimension 2 of array *si
   !  Hint: ISIZE1OFDrfsi should be the size of dimension 1 of array *si
   !  Hint: ISIZE3OFDrfrlv should be the size of dimension 3 of array *rlv
   !  Hint: ISIZE2OFDrfrlv should be the size of dimension 2 of array *rlv
   !  Hint: ISIZE1OFDrfrlv should be the size of dimension 1 of array *rlv
   !  Hint: ISIZE4OFDrfw should be the size of dimension 4 of array *w
   !  Hint: ISIZE3OFDrfw should be the size of dimension 3 of array *w
   !  Hint: ISIZE2OFDrfw should be the size of dimension 2 of array *w
   !  Hint: ISIZE1OFDrfw should be the size of dimension 1 of array *w
   IMPLICIT NONE
   !
   !      ******************************************************************
   !      *                                                                *
   !      * utauWF substitutes the wall shear stress with values from a    *
   !      * look-up table, if desired.                                     *
   !      *                                                                *
   !      ******************************************************************
   !
   !
   !      Subroutine argument.
   !
   REAL(kind=realtype), INTENT(IN) :: rfilv
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: i, j, nn
   REAL(kind=realtype) :: fact
   REAL(kind=realtype) :: tauxx, tauyy, tauzz
   REAL(kind=realtype) :: tauxxd, tauyyd, tauzzd
   REAL(kind=realtype) :: tauxy, tauxz, tauyz
   REAL(kind=realtype) :: tauxyd, tauxzd, tauyzd
   REAL(kind=realtype) :: rbar, ubar, vbar, wbar, vx, vy, vz
   REAL(kind=realtype) :: rbard, ubard, vbard, wbard, vxd, vyd, vzd
   REAL(kind=realtype) :: fmx, fmy, fmz, frhoe
   REAL(kind=realtype) :: fmxd, fmyd, fmzd, frhoed
   REAL(kind=realtype) :: veln, velnx, velny, velnz, tx, ty, tz
   REAL(kind=realtype) :: velnd, velnxd, velnyd, velnzd, txd, tyd, tzd
   REAL(kind=realtype) :: veltx, velty, veltz, veltmag
   REAL(kind=realtype) :: veltxd, veltyd, veltzd, veltmagd
   REAL(kind=realtype) :: txnx, txny, txnz, tynx, tyny, tynz
   REAL(kind=realtype) :: txnxd, txnyd, txnzd, tynxd, tynyd, tynzd
   REAL(kind=realtype) :: tznx, tzny, tznz
   REAL(kind=realtype) :: tznxd, tznyd, tznzd
   REAL(kind=realtype) :: tautn, tauwall, utau, re
   REAL(kind=realtype) :: tautnd, tauwalld, utaud, red
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww1, ww2
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww1d, ww2d
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ss, rres
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ssd, rresd
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: norm
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: normd
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rrlv2, dd2wall2
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rrlv2d
   !
   !      Function definition.
   !
   REAL(kind=realtype) :: CURVEUPRE
   REAL(kind=realtype) :: CURVEUPRE_T
   REAL(kind=realtype) :: arg1
   REAL(kind=realtype) :: arg1d
   INTRINSIC MAX
   REAL(kind=realtype) :: x1
   EXTERNAL DEBUG_TGT_HERE
   LOGICAL :: DEBUG_TGT_HERE
   REAL(kind=realtype) :: max1d
   REAL(kind=realtype) :: x1d
   INTEGER :: ii1
   INTRINSIC SQRT
   REAL(kind=realtype) :: max1
   REAL(kind=realtype) :: y1
   REAL(kind=realtype) :: y1d
   IF (.TRUE. .AND. DEBUG_TGT_HERE('entry', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                        ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                        ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_REAL8ARRAY('si', si, sid, ISIZE1OFDrfsi*ISIZE2OFDrfsi&
   &                        *ISIZE3OFDrfsi*ISIZE4OFDrfsi)
   CALL DEBUG_TGT_REAL8ARRAY('sj', sj, sjd, ISIZE1OFDrfsj*ISIZE2OFDrfsj&
   &                        *ISIZE3OFDrfsj*ISIZE4OFDrfsj)
   CALL DEBUG_TGT_REAL8ARRAY('sk', sk, skd, ISIZE1OFDrfsk*ISIZE2OFDrfsk&
   &                        *ISIZE3OFDrfsk*ISIZE4OFDrfsk)
   CALL DEBUG_TGT_REAL8ARRAY('fw', fw, fwd, ISIZE1OFDrffw*ISIZE2OFDrffw&
   &                        *ISIZE3OFDrffw*ISIZE4OFDrffw)
   DO ii1=1,ISIZE1OFDrfviscsubface
   CALL DEBUG_TGT_REAL8ARRAY('viscsubface', viscsubface(ii1)%tau, &
   &                          viscsubfaced(ii1)%tau, &
   &                          ISIZE1OFDrfDrfviscsubface_tau*&
   &                          ISIZE2OFDrfDrfviscsubface_tau*&
   &                          ISIZE3OFDrfDrfviscsubface_tau)
   END DO
   DO ii1=1,ISIZE1OFDrfbcdata
   CALL DEBUG_TGT_REAL8ARRAY('bcdata', bcdata(ii1)%norm, bcdatad(ii1)&
   &                          %norm, ISIZE1OFDrfDrfbcdata_norm*&
   &                          ISIZE2OFDrfDrfbcdata_norm*&
   &                          ISIZE3OFDrfDrfbcdata_norm)
   END DO
   CALL DEBUG_TGT_DISPLAY('entry')
   END IF
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Return immediately if no wall functions must be used.
   IF (.NOT.wallfunctions) THEN
   IF (.TRUE. .AND. DEBUG_TGT_HERE('exit', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('fw', fw, fwd, ISIZE1OFDrffw*&
   &                          ISIZE2OFDrffw*ISIZE3OFDrffw*ISIZE4OFDrffw)
   DO ii1=1,ISIZE1OFDrfviscsubface
   CALL DEBUG_TGT_REAL8ARRAY('viscsubface', viscsubface(ii1)%tau, &
   &                            viscsubfaced(ii1)%tau, &
   &                            ISIZE1OFDrfDrfviscsubface_tau*&
   &                            ISIZE2OFDrfDrfviscsubface_tau*&
   &                            ISIZE3OFDrfDrfviscsubface_tau)
   END DO
   CALL DEBUG_TGT_DISPLAY('exit')
   END IF
   RETURN
   ELSE
   ! Loop over the viscous subfaces of this block.
   viscsubfaces:DO nn=1,nviscbocos
   ! Set a bunch of variables depending on the face id to make
   ! a generic treatment possible.
   SELECT CASE  (bcfaceid(nn)) 
   CASE (imin) 
   fact = -one
   ssd => sid(1, :, :, :)
   ss => si(1, :, :, :)
   rresd => fwd(2, 1:, 1:, :)
   rres => fw(2, 1:, 1:, :)
   ww2d => wd(2, 1:, 1:, :)
   ww2 => w(2, 1:, 1:, :)
   ww1d => wd(1, 1:, 1:, :)
   ww1 => w(1, 1:, 1:, :)
   dd2wall2 => d2wall(2, :, :)
   rrlv2d => rlvd(2, 1:, 1:)
   rrlv2 => rlv(2, 1:, 1:)
   CASE (imax) 
   !===========================================================
   fact = one
   ssd => sid(il, :, :, :)
   ss => si(il, :, :, :)
   rresd => fwd(il, 1:, 1:, :)
   rres => fw(il, 1:, 1:, :)
   ww2d => wd(il, 1:, 1:, :)
   ww2 => w(il, 1:, 1:, :)
   ww1d => wd(ie, 1:, 1:, :)
   ww1 => w(ie, 1:, 1:, :)
   dd2wall2 => d2wall(il, :, :)
   rrlv2d => rlvd(il, 1:, 1:)
   rrlv2 => rlv(il, 1:, 1:)
   CASE (jmin) 
   !===========================================================
   fact = -one
   ssd => sjd(:, 1, :, :)
   ss => sj(:, 1, :, :)
   rresd => fwd(1:, 2, 1:, :)
   rres => fw(1:, 2, 1:, :)
   ww2d => wd(1:, 2, 1:, :)
   ww2 => w(1:, 2, 1:, :)
   ww1d => wd(1:, 1, 1:, :)
   ww1 => w(1:, 1, 1:, :)
   dd2wall2 => d2wall(:, 2, :)
   rrlv2d => rlvd(1:, 2, 1:)
   rrlv2 => rlv(1:, 2, 1:)
   CASE (jmax) 
   !===========================================================
   fact = one
   ssd => sjd(:, jl, :, :)
   ss => sj(:, jl, :, :)
   rresd => fwd(1:, jl, 1:, :)
   rres => fw(1:, jl, 1:, :)
   ww2d => wd(1:, jl, 1:, :)
   ww2 => w(1:, jl, 1:, :)
   ww1d => wd(1:, je, 1:, :)
   ww1 => w(1:, je, 1:, :)
   dd2wall2 => d2wall(:, jl, :)
   rrlv2d => rlvd(1:, jl, 1:)
   rrlv2 => rlv(1:, jl, 1:)
   CASE (kmin) 
   !===========================================================
   fact = -one
   ssd => skd(:, :, 1, :)
   ss => sk(:, :, 1, :)
   rresd => fwd(1:, 1:, 2, :)
   rres => fw(1:, 1:, 2, :)
   ww2d => wd(1:, 1:, 2, :)
   ww2 => w(1:, 1:, 2, :)
   ww1d => wd(1:, 1:, 1, :)
   ww1 => w(1:, 1:, 1, :)
   dd2wall2 => d2wall(:, :, 2)
   rrlv2d => rlvd(1:, 1:, 2)
   rrlv2 => rlv(1:, 1:, 2)
   CASE (kmax) 
   !===========================================================
   fact = one
   ssd => skd(:, :, kl, :)
   ss => sk(:, :, kl, :)
   rresd => fwd(1:, 1:, kl, :)
   rres => fw(1:, 1:, kl, :)
   ww2d => wd(1:, 1:, kl, :)
   ww2 => w(1:, 1:, kl, :)
   ww1d => wd(1:, 1:, ke, :)
   ww1 => w(1:, 1:, ke, :)
   dd2wall2 => d2wall(:, :, kl)
   rrlv2d => rlvd(1:, 1:, kl)
   rrlv2 => rlv(1:, 1:, kl)
   END SELECT
   IF (.TRUE. .AND. DEBUG_TGT_HERE('middle', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                            ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                            ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_REAL8ARRAY('si', si, sid, ISIZE1OFDrfsi*&
   &                            ISIZE2OFDrfsi*ISIZE3OFDrfsi*ISIZE4OFDrfsi)
   CALL DEBUG_TGT_REAL8ARRAY('sj', sj, sjd, ISIZE1OFDrfsj*&
   &                            ISIZE2OFDrfsj*ISIZE3OFDrfsj*ISIZE4OFDrfsj)
   CALL DEBUG_TGT_REAL8ARRAY('sk', sk, skd, ISIZE1OFDrfsk*&
   &                            ISIZE2OFDrfsk*ISIZE3OFDrfsk*ISIZE4OFDrfsk)
   CALL DEBUG_TGT_REAL8ARRAY('fw', fw, fwd, ISIZE1OFDrffw*&
   &                            ISIZE2OFDrffw*ISIZE3OFDrffw*ISIZE4OFDrffw)
   DO ii1=1,ISIZE1OFDrfviscsubface
   CALL DEBUG_TGT_REAL8ARRAY('viscsubface', viscsubface(ii1)%tau&
   &                              , viscsubfaced(ii1)%tau, &
   &                              ISIZE1OFDrfDrfviscsubface_tau*&
   &                              ISIZE2OFDrfDrfviscsubface_tau*&
   &                              ISIZE3OFDrfDrfviscsubface_tau)
   END DO
   DO ii1=1,ISIZE1OFDrfbcdata
   CALL DEBUG_TGT_REAL8ARRAY('bcdata', bcdata(ii1)%norm, bcdatad(&
   &                              ii1)%norm, ISIZE1OFDrfDrfbcdata_norm*&
   &                              ISIZE2OFDrfDrfbcdata_norm*&
   &                              ISIZE3OFDrfDrfbcdata_norm)
   END DO
   CALL DEBUG_TGT_DISPLAY('middle')
   END IF
   ! Set the pointer for the unit outward normals.
   normd => bcdatad(nn)%norm
   norm => bcdata(nn)%norm
   ! Loop over the quadrilateral faces of the subface. Note
   ! that the nodal range of BCData must be used and not the
   ! cell range, because the latter may include the halo's in i
   ! and j-direction. The offset +1 is there, because inBeg and
   ! jnBeg refer to nodal ranges and not to cell ranges.
   DO j=bcdata(nn)%jnbeg+1,bcdata(nn)%jnend
   DO i=bcdata(nn)%inbeg+1,bcdata(nn)%inend
   ! Store the viscous stress tensor a bit easier.
   tauxxd = viscsubfaced(nn)%tau(i, j, 1)
   tauxx = viscsubface(nn)%tau(i, j, 1)
   tauyyd = viscsubfaced(nn)%tau(i, j, 2)
   tauyy = viscsubface(nn)%tau(i, j, 2)
   tauzzd = viscsubfaced(nn)%tau(i, j, 3)
   tauzz = viscsubface(nn)%tau(i, j, 3)
   tauxyd = viscsubfaced(nn)%tau(i, j, 4)
   tauxy = viscsubface(nn)%tau(i, j, 4)
   tauxzd = viscsubfaced(nn)%tau(i, j, 5)
   tauxz = viscsubface(nn)%tau(i, j, 5)
   tauyzd = viscsubfaced(nn)%tau(i, j, 6)
   tauyz = viscsubface(nn)%tau(i, j, 6)
   ! Compute the velocities at the wall face; these are only
   ! non-zero for moving a block. Also compute the density,
   ! which is needed to compute the wall shear stress via
   ! wall functions.
   rbard = half*(ww2d(i, j, irho)+ww1d(i, j, irho))
   rbar = half*(ww2(i, j, irho)+ww1(i, j, irho))
   ubard = half*(ww2d(i, j, ivx)+ww1d(i, j, ivx))
   ubar = half*(ww2(i, j, ivx)+ww1(i, j, ivx))
   vbard = half*(ww2d(i, j, ivy)+ww1d(i, j, ivy))
   vbar = half*(ww2(i, j, ivy)+ww1(i, j, ivy))
   wbard = half*(ww2d(i, j, ivz)+ww1d(i, j, ivz))
   wbar = half*(ww2(i, j, ivz)+ww1(i, j, ivz))
   ! Compute the velocity difference between the internal cell
   ! and the wall.
   vxd = ww2d(i, j, ivx) - ubard
   vx = ww2(i, j, ivx) - ubar
   vyd = ww2d(i, j, ivy) - vbard
   vy = ww2(i, j, ivy) - vbar
   vzd = ww2d(i, j, ivz) - wbard
   vz = ww2(i, j, ivz) - wbar
   ! Compute the normal velocity of the internal cell.
   velnd = vxd*norm(i, j, 1) + vx*normd(i, j, 1) + vyd*norm(i, j&
   &            , 2) + vy*normd(i, j, 2) + vzd*norm(i, j, 3) + vz*normd(i, j&
   &            , 3)
   veln = vx*norm(i, j, 1) + vy*norm(i, j, 2) + vz*norm(i, j, 3)
   velnxd = velnd*norm(i, j, 1) + veln*normd(i, j, 1)
   velnx = veln*norm(i, j, 1)
   velnyd = velnd*norm(i, j, 2) + veln*normd(i, j, 2)
   velny = veln*norm(i, j, 2)
   velnzd = velnd*norm(i, j, 3) + veln*normd(i, j, 3)
   velnz = veln*norm(i, j, 3)
   ! Compute the tangential velocity, its magnitude and its
   ! unit vector of the internal cell.
   veltxd = vxd - velnxd
   veltx = vx - velnx
   veltyd = vyd - velnyd
   velty = vy - velny
   veltzd = vzd - velnzd
   veltz = vz - velnz
   arg1d = 2*veltx*veltxd + 2*velty*veltyd + 2*veltz*veltzd
   arg1 = veltx**2 + velty**2 + veltz**2
   IF (arg1 .EQ. 0.0_8) THEN
   y1d = 0.0_8
   ELSE
   y1d = arg1d/(2.0*SQRT(arg1))
   END IF
   y1 = SQRT(arg1)
   IF (eps .LT. y1) THEN
   veltmagd = y1d
   veltmag = y1
   ELSE
   veltmag = eps
   veltmagd = 0.0_8
   END IF
   txd = (veltxd*veltmag-veltx*veltmagd)/veltmag**2
   tx = veltx/veltmag
   tyd = (veltyd*veltmag-velty*veltmagd)/veltmag**2
   ty = velty/veltmag
   tzd = (veltzd*veltmag-veltz*veltmagd)/veltmag**2
   tz = veltz/veltmag
   ! Compute some coefficients needed for the transformation
   ! between the cartesian frame and the frame defined by the
   ! tangential direction (tx,ty,tz) and the normal direction.
   ! The minus sign is present, because for this transformation
   ! the normal direction should be inward pointing and norm
   ! is outward pointing.
   txnxd = -(txd*norm(i, j, 1)+tx*normd(i, j, 1))
   txnx = -(tx*norm(i, j, 1))
   txnyd = -(txd*norm(i, j, 2)+tx*normd(i, j, 2))
   txny = -(tx*norm(i, j, 2))
   txnzd = -(txd*norm(i, j, 3)+tx*normd(i, j, 3))
   txnz = -(tx*norm(i, j, 3))
   tynxd = -(tyd*norm(i, j, 1)+ty*normd(i, j, 1))
   tynx = -(ty*norm(i, j, 1))
   tynyd = -(tyd*norm(i, j, 2)+ty*normd(i, j, 2))
   tyny = -(ty*norm(i, j, 2))
   tynzd = -(tyd*norm(i, j, 3)+ty*normd(i, j, 3))
   tynz = -(ty*norm(i, j, 3))
   tznxd = -(tzd*norm(i, j, 1)+tz*normd(i, j, 1))
   tznx = -(tz*norm(i, j, 1))
   tznyd = -(tzd*norm(i, j, 2)+tz*normd(i, j, 2))
   tzny = -(tz*norm(i, j, 2))
   tznzd = -(tzd*norm(i, j, 3)+tz*normd(i, j, 3))
   tznz = -(tz*norm(i, j, 3))
   ! Compute the tn component of the wall shear stress
   ! tensor. Normally this is the only nonzero shear
   ! stress component in the t-n frame.
   tautnd = tauxxd*txnx + tauxx*txnxd + tauyyd*tyny + tauyy*tynyd&
   &            + tauzzd*tznz + tauzz*tznzd + tauxyd*(txny+tynx) + tauxy*(&
   &            txnyd+tynxd) + tauxzd*(txnz+tznx) + tauxz*(txnzd+tznxd) + &
   &            tauyzd*(tynz+tzny) + tauyz*(tynzd+tznyd)
   tautn = tauxx*txnx + tauyy*tyny + tauzz*tznz + tauxy*(txny+&
   &            tynx) + tauxz*(txnz+tznx) + tauyz*(tynz+tzny)
   ! Compute the Reynolds number using the velocity, density,
   ! laminar viscosity and wall distance. Note that an offset
   ! of -1 must be used in dd2Wall2, because the original array
   ! d2Wall starts at 2.
   red = (dd2wall2(i-1, j-1)*(ww2d(i, j, irho)*veltmag+ww2(i, j, &
   &            irho)*veltmagd)*rrlv2(i, j)-ww2(i, j, irho)*veltmag*dd2wall2&
   &            (i-1, j-1)*rrlv2d(i, j))/rrlv2(i, j)**2
   re = ww2(i, j, irho)*veltmag*dd2wall2(i-1, j-1)/rrlv2(i, j)
   CALL DEBUG_TGT_CALL('CURVEUPRE', .TRUE., .FALSE.)
   x1d = CURVEUPRE_T(re, red, x1)
   CALL DEBUG_TGT_EXIT()
   IF (x1 .LT. eps) THEN
   max1 = eps
   max1d = 0.0_8
   ELSE
   max1d = x1d
   max1 = x1
   END IF
   ! Determine the friction velocity from the table and
   ! compute the wall shear stress from it.
   utaud = (veltmagd*max1-veltmag*max1d)/max1**2
   utau = veltmag/max1
   tauwalld = (rbard*utau+rbar*utaud)*utau + rbar*utau*utaud
   tauwall = rbar*utau*utau
   ! Compute the correction to the wall shear stress tautn and
   ! transform this correction back to the cartesian frame.
   ! Take rFilv into account, such that the correction to the
   ! stress tensor is computed correctly.
   tautnd = rfilv*tauwalld - tautnd
   tautn = rfilv*tauwall - tautn
   tauxxd = two*(tautnd*txnx+tautn*txnxd)
   tauxx = two*tautn*txnx
   tauyyd = two*(tautnd*tyny+tautn*tynyd)
   tauyy = two*tautn*tyny
   tauzzd = two*(tautnd*tznz+tautn*tznzd)
   tauzz = two*tautn*tznz
   tauxyd = tautnd*(txny+tynx) + tautn*(txnyd+tynxd)
   tauxy = tautn*(txny+tynx)
   tauxzd = tautnd*(txnz+tznx) + tautn*(txnzd+tznxd)
   tauxz = tautn*(txnz+tznx)
   tauyzd = tautnd*(tynz+tzny) + tautn*(tynzd+tznyd)
   tauyz = tautn*(tynz+tzny)
   ! Compute the correction to the viscous flux at the wall.
   fmxd = tauxxd*ss(i, j, 1) + tauxx*ssd(i, j, 1) + tauxyd*ss(i, &
   &            j, 2) + tauxy*ssd(i, j, 2) + tauxzd*ss(i, j, 3) + tauxz*ssd(&
   &            i, j, 3)
   fmx = tauxx*ss(i, j, 1) + tauxy*ss(i, j, 2) + tauxz*ss(i, j, 3&
   &            )
   fmyd = tauxyd*ss(i, j, 1) + tauxy*ssd(i, j, 1) + tauyyd*ss(i, &
   &            j, 2) + tauyy*ssd(i, j, 2) + tauyzd*ss(i, j, 3) + tauyz*ssd(&
   &            i, j, 3)
   fmy = tauxy*ss(i, j, 1) + tauyy*ss(i, j, 2) + tauyz*ss(i, j, 3&
   &            )
   fmzd = tauxzd*ss(i, j, 1) + tauxz*ssd(i, j, 1) + tauyzd*ss(i, &
   &            j, 2) + tauyz*ssd(i, j, 2) + tauzzd*ss(i, j, 3) + tauzz*ssd(&
   &            i, j, 3)
   fmz = tauxz*ss(i, j, 1) + tauyz*ss(i, j, 2) + tauzz*ss(i, j, 3&
   &            )
   frhoed = (ubard*tauxx+ubar*tauxxd+vbard*tauxy+vbar*tauxyd+&
   &            wbard*tauxz+wbar*tauxzd)*ss(i, j, 1) + (ubar*tauxx+vbar*&
   &            tauxy+wbar*tauxz)*ssd(i, j, 1) + (ubard*tauxy+ubar*tauxyd+&
   &            vbard*tauyy+vbar*tauyyd+wbard*tauyz+wbar*tauyzd)*ss(i, j, 2)&
   &            + (ubar*tauxy+vbar*tauyy+wbar*tauyz)*ssd(i, j, 2) + (ubard*&
   &            tauxz+ubar*tauxzd+vbard*tauyz+vbar*tauyzd+wbard*tauzz+wbar*&
   &            tauzzd)*ss(i, j, 3) + (ubar*tauxz+vbar*tauyz+wbar*tauzz)*ssd&
   &            (i, j, 3)
   frhoe = (ubar*tauxx+vbar*tauxy+wbar*tauxz)*ss(i, j, 1) + (ubar&
   &            *tauxy+vbar*tauyy+wbar*tauyz)*ss(i, j, 2) + (ubar*tauxz+vbar&
   &            *tauyz+wbar*tauzz)*ss(i, j, 3)
   ! Add them to the residual. Note that now the factor rFilv
   ! is already taken into account via tau. Fact is present to
   ! take inward/outward pointing normals into account
   rresd(i, j, imx) = rresd(i, j, imx) - fact*fmxd
   rres(i, j, imx) = rres(i, j, imx) - fact*fmx
   rresd(i, j, imy) = rresd(i, j, imy) - fact*fmyd
   rres(i, j, imy) = rres(i, j, imy) - fact*fmy
   rresd(i, j, imz) = rresd(i, j, imz) - fact*fmzd
   rres(i, j, imz) = rres(i, j, imz) - fact*fmz
   rresd(i, j, irhoe) = rresd(i, j, irhoe) - fact*frhoed
   rres(i, j, irhoe) = rres(i, j, irhoe) - fact*frhoe
   ! Store the friction velocity for later use.
   viscsubface(nn)%utau(i, j) = utau
   ! Also add the correction to the wall stress tensor.
   viscsubfaced(nn)%tau(i, j, 1) = viscsubfaced(nn)%tau(i, j, 1) &
   &            + tauxxd
   viscsubface(nn)%tau(i, j, 1) = viscsubface(nn)%tau(i, j, 1) + &
   &            tauxx
   viscsubfaced(nn)%tau(i, j, 2) = viscsubfaced(nn)%tau(i, j, 2) &
   &            + tauyyd
   viscsubface(nn)%tau(i, j, 2) = viscsubface(nn)%tau(i, j, 2) + &
   &            tauyy
   viscsubfaced(nn)%tau(i, j, 3) = viscsubfaced(nn)%tau(i, j, 3) &
   &            + tauzzd
   viscsubface(nn)%tau(i, j, 3) = viscsubface(nn)%tau(i, j, 3) + &
   &            tauzz
   viscsubfaced(nn)%tau(i, j, 4) = viscsubfaced(nn)%tau(i, j, 4) &
   &            + tauxyd
   viscsubface(nn)%tau(i, j, 4) = viscsubface(nn)%tau(i, j, 4) + &
   &            tauxy
   viscsubfaced(nn)%tau(i, j, 5) = viscsubfaced(nn)%tau(i, j, 5) &
   &            + tauxzd
   viscsubface(nn)%tau(i, j, 5) = viscsubface(nn)%tau(i, j, 5) + &
   &            tauxz
   viscsubfaced(nn)%tau(i, j, 6) = viscsubfaced(nn)%tau(i, j, 6) &
   &            + tauyzd
   viscsubface(nn)%tau(i, j, 6) = viscsubface(nn)%tau(i, j, 6) + &
   &            tauyz
   END DO
   END DO
   END DO viscsubfaces
   END IF
   IF (.TRUE. .AND. DEBUG_TGT_HERE('exit', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('fw', fw, fwd, ISIZE1OFDrffw*ISIZE2OFDrffw&
   &                        *ISIZE3OFDrffw*ISIZE4OFDrffw)
   DO ii1=1,ISIZE1OFDrfviscsubface
   CALL DEBUG_TGT_REAL8ARRAY('viscsubface', viscsubface(ii1)%tau, &
   &                          viscsubfaced(ii1)%tau, &
   &                          ISIZE1OFDrfDrfviscsubface_tau*&
   &                          ISIZE2OFDrfDrfviscsubface_tau*&
   &                          ISIZE3OFDrfDrfviscsubface_tau)
   END DO
   CALL DEBUG_TGT_DISPLAY('exit')
   END IF
   END SUBROUTINE UTAUWF_T
