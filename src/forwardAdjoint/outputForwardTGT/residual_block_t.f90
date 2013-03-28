   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.7 (r4786) - 21 Feb 2013 15:53
   !
   !  Differentiation of residual_block in forward (tangent) mode (with options debugTangent i4 dr8 r8):
   !   variations   of useful results: *p *dw *w *(*viscsubface.tau)
   !   with respect to varying inputs: *rev *p *sfacei *sfacej *gamma
   !                *sfacek *dw *w *rlv *x *vol *si *sj *sk *(*bcdata.norm)
   !                *radi *radj *radk timeref rhoinf pinfcorr rgas
   !   Plus diff mem management of: rev:in p:in sfacei:in sfacej:in
   !                gamma:in sfacek:in dw:in w:in rlv:in x:in vol:in
   !                si:in sj:in sk:in fw:in viscsubface:in *viscsubface.tau:in
   !                bcdata:in *bcdata.norm:in radi:in radj:in radk:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          residual.f90                                    *
   !      * Author:        Edwin van der Weide, Steve Repsher (blanking)   *
   !      * Starting date: 03-15-2003                                      *
   !      * Last modified: 10-29-2007                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE RESIDUAL_BLOCK_T()
   USE ITERATION
   USE FLOWVARREFSTATE
   USE INPUTITERATION
   USE CGNSGRID
   USE BLOCKPOINTERS_D
   USE INPUTTIMESPECTRAL
   USE INPUTDISCRETIZATION
   USE DIFFSIZES
   !  Hint: ISIZE1OFDrfviscsubface should be the size of dimension 1 of array *viscsubface
   !  Hint: ISIZE3OFDrfradk should be the size of dimension 3 of array *radk
   !  Hint: ISIZE2OFDrfradk should be the size of dimension 2 of array *radk
   !  Hint: ISIZE1OFDrfradk should be the size of dimension 1 of array *radk
   !  Hint: ISIZE3OFDrfradj should be the size of dimension 3 of array *radj
   !  Hint: ISIZE2OFDrfradj should be the size of dimension 2 of array *radj
   !  Hint: ISIZE1OFDrfradj should be the size of dimension 1 of array *radj
   !  Hint: ISIZE3OFDrfradi should be the size of dimension 3 of array *radi
   !  Hint: ISIZE2OFDrfradi should be the size of dimension 2 of array *radi
   !  Hint: ISIZE1OFDrfradi should be the size of dimension 1 of array *radi
   !  Hint: ISIZE3OFDrfDrfbcdata_norm should be the size of dimension 3 of array **bcdata%norm
   !  Hint: ISIZE2OFDrfDrfbcdata_norm should be the size of dimension 2 of array **bcdata%norm
   !  Hint: ISIZE1OFDrfDrfbcdata_norm should be the size of dimension 1 of array **bcdata%norm
   !  Hint: ISIZE1OFDrfbcdata should be the size of dimension 1 of array *bcdata
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
   !  Hint: ISIZE3OFDrfvol should be the size of dimension 3 of array *vol
   !  Hint: ISIZE2OFDrfvol should be the size of dimension 2 of array *vol
   !  Hint: ISIZE1OFDrfvol should be the size of dimension 1 of array *vol
   !  Hint: ISIZE4OFDrfx should be the size of dimension 4 of array *x
   !  Hint: ISIZE3OFDrfx should be the size of dimension 3 of array *x
   !  Hint: ISIZE2OFDrfx should be the size of dimension 2 of array *x
   !  Hint: ISIZE1OFDrfx should be the size of dimension 1 of array *x
   !  Hint: ISIZE3OFDrfrlv should be the size of dimension 3 of array *rlv
   !  Hint: ISIZE2OFDrfrlv should be the size of dimension 2 of array *rlv
   !  Hint: ISIZE1OFDrfrlv should be the size of dimension 1 of array *rlv
   !  Hint: ISIZE4OFDrfw should be the size of dimension 4 of array *w
   !  Hint: ISIZE3OFDrfw should be the size of dimension 3 of array *w
   !  Hint: ISIZE2OFDrfw should be the size of dimension 2 of array *w
   !  Hint: ISIZE1OFDrfw should be the size of dimension 1 of array *w
   !  Hint: ISIZE4OFDrfdw should be the size of dimension 4 of array *dw
   !  Hint: ISIZE3OFDrfdw should be the size of dimension 3 of array *dw
   !  Hint: ISIZE2OFDrfdw should be the size of dimension 2 of array *dw
   !  Hint: ISIZE1OFDrfdw should be the size of dimension 1 of array *dw
   !  Hint: ISIZE3OFDrfsfacek should be the size of dimension 3 of array *sfacek
   !  Hint: ISIZE2OFDrfsfacek should be the size of dimension 2 of array *sfacek
   !  Hint: ISIZE1OFDrfsfacek should be the size of dimension 1 of array *sfacek
   !  Hint: ISIZE3OFDrfgamma should be the size of dimension 3 of array *gamma
   !  Hint: ISIZE2OFDrfgamma should be the size of dimension 2 of array *gamma
   !  Hint: ISIZE1OFDrfgamma should be the size of dimension 1 of array *gamma
   !  Hint: ISIZE3OFDrfsfacej should be the size of dimension 3 of array *sfacej
   !  Hint: ISIZE2OFDrfsfacej should be the size of dimension 2 of array *sfacej
   !  Hint: ISIZE1OFDrfsfacej should be the size of dimension 1 of array *sfacej
   !  Hint: ISIZE3OFDrfsfacei should be the size of dimension 3 of array *sfacei
   !  Hint: ISIZE2OFDrfsfacei should be the size of dimension 2 of array *sfacei
   !  Hint: ISIZE1OFDrfsfacei should be the size of dimension 1 of array *sfacei
   !  Hint: ISIZE3OFDrfp should be the size of dimension 3 of array *p
   !  Hint: ISIZE2OFDrfp should be the size of dimension 2 of array *p
   !  Hint: ISIZE1OFDrfp should be the size of dimension 1 of array *p
   !  Hint: ISIZE3OFDrfrev should be the size of dimension 3 of array *rev
   !  Hint: ISIZE2OFDrfrev should be the size of dimension 2 of array *rev
   !  Hint: ISIZE1OFDrfrev should be the size of dimension 1 of array *rev
   !  Hint: ISIZE3OFDrfDrfviscsubface_tau should be the size of dimension 3 of array **viscsubface%tau
   !  Hint: ISIZE2OFDrfDrfviscsubface_tau should be the size of dimension 2 of array **viscsubface%tau
   !  Hint: ISIZE1OFDrfDrfviscsubface_tau should be the size of dimension 1 of array **viscsubface%tau
   IMPLICIT NONE
   !
   !      ******************************************************************
   !      *                                                                *
   !      * residual computes the residual of the mean flow equations on   *
   !      * the current MG level.                                          *
   !      *                                                                *
   !      ******************************************************************
   !
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: sps, nn, discr
   INTEGER(kind=inttype) :: i, j, k, l
   LOGICAL :: finegrid
   REAL(realtype) :: result1
   EXTERNAL DEBUG_TGT_HERE
   LOGICAL :: DEBUG_TGT_HERE
   INTRINSIC REAL
   INTEGER :: ii1
   IF (.TRUE. .AND. DEBUG_TGT_HERE('entry', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('rev', rev, revd, ISIZE1OFDrfrev*&
   &                        ISIZE2OFDrfrev*ISIZE3OFDrfrev)
   CALL DEBUG_TGT_REAL8ARRAY('p', p, pd, ISIZE1OFDrfp*ISIZE2OFDrfp*&
   &                        ISIZE3OFDrfp)
   CALL DEBUG_TGT_REAL8ARRAY('sfacei', sfacei, sfaceid, &
   &                        ISIZE1OFDrfsfacei*ISIZE2OFDrfsfacei*&
   &                        ISIZE3OFDrfsfacei)
   CALL DEBUG_TGT_REAL8ARRAY('sfacej', sfacej, sfacejd, &
   &                        ISIZE1OFDrfsfacej*ISIZE2OFDrfsfacej*&
   &                        ISIZE3OFDrfsfacej)
   CALL DEBUG_TGT_REAL8ARRAY('gamma', gamma, gammad, ISIZE1OFDrfgamma*&
   &                        ISIZE2OFDrfgamma*ISIZE3OFDrfgamma)
   CALL DEBUG_TGT_REAL8ARRAY('sfacek', sfacek, sfacekd, &
   &                        ISIZE1OFDrfsfacek*ISIZE2OFDrfsfacek*&
   &                        ISIZE3OFDrfsfacek)
   CALL DEBUG_TGT_REAL8ARRAY('dw', dw, dwd, ISIZE1OFDrfdw*ISIZE2OFDrfdw&
   &                        *ISIZE3OFDrfdw*ISIZE4OFDrfdw)
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                        ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                        ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_REAL8ARRAY('x', x, xd, ISIZE1OFDrfx*ISIZE2OFDrfx*&
   &                        ISIZE3OFDrfx*ISIZE4OFDrfx)
   CALL DEBUG_TGT_REAL8ARRAY('vol', vol, vold, ISIZE1OFDrfvol*&
   &                        ISIZE2OFDrfvol*ISIZE3OFDrfvol)
   CALL DEBUG_TGT_REAL8ARRAY('si', si, sid, ISIZE1OFDrfsi*ISIZE2OFDrfsi&
   &                        *ISIZE3OFDrfsi*ISIZE4OFDrfsi)
   CALL DEBUG_TGT_REAL8ARRAY('sj', sj, sjd, ISIZE1OFDrfsj*ISIZE2OFDrfsj&
   &                        *ISIZE3OFDrfsj*ISIZE4OFDrfsj)
   CALL DEBUG_TGT_REAL8ARRAY('sk', sk, skd, ISIZE1OFDrfsk*ISIZE2OFDrfsk&
   &                        *ISIZE3OFDrfsk*ISIZE4OFDrfsk)
   DO ii1=1,ISIZE1OFDrfbcdata
   CALL DEBUG_TGT_REAL8ARRAY('bcdata', bcdata(ii1)%norm, bcdatad(ii1)&
   &                          %norm, ISIZE1OFDrfDrfbcdata_norm*&
   &                          ISIZE2OFDrfDrfbcdata_norm*&
   &                          ISIZE3OFDrfDrfbcdata_norm)
   END DO
   CALL DEBUG_TGT_REAL8ARRAY('radi', radi, radid, ISIZE1OFDrfradi*&
   &                        ISIZE2OFDrfradi*ISIZE3OFDrfradi)
   CALL DEBUG_TGT_REAL8ARRAY('radj', radj, radjd, ISIZE1OFDrfradj*&
   &                        ISIZE2OFDrfradj*ISIZE3OFDrfradj)
   CALL DEBUG_TGT_REAL8ARRAY('radk', radk, radkd, ISIZE1OFDrfradk*&
   &                        ISIZE2OFDrfradk*ISIZE3OFDrfradk)
   CALL DEBUG_TGT_REAL8('timeref', timeref, timerefd)
   CALL DEBUG_TGT_REAL8('rhoinf', rhoinf, rhoinfd)
   CALL DEBUG_TGT_REAL8('pinfcorr', pinfcorr, pinfcorrd)
   CALL DEBUG_TGT_REAL8('rgas', rgas, rgasd)
   CALL DEBUG_TGT_DISPLAY('entry')
   END IF
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Add the source terms from the level 0 cooling model.
   ! Set the value of rFil, which controls the fraction of the old
   ! dissipation residual to be used. This is only for the runge-kutta
   ! schemes; for other smoothers rFil is simply set to 1.0.
   ! Note the index rkStage+1 for cdisRK. The reason is that the
   ! residual computation is performed before rkStage is incremented.
   IF (smoother .EQ. rungekutta) THEN
   rfil = cdisrk(rkstage+1)
   ELSE
   rfil = one
   END IF
   ! Initialize the local arrays to monitor the massflows to zero.
   ! Set the value of the discretization, depending on the grid level,
   ! and the logical fineGrid, which indicates whether or not this
   ! is the finest grid level of the current mg cycle.
   discr = spacediscrcoarse
   IF (currentlevel .EQ. 1) discr = spacediscr
   finegrid = .false.
   IF (currentlevel .EQ. groundlevel) finegrid = .true.
   CALL DEBUG_TGT_CALL('INVISCIDCENTRALFLUX', .TRUE., .FALSE.)
   CALL INVISCIDCENTRALFLUX_T()
   CALL DEBUG_TGT_EXIT()
   ! Compute the artificial dissipation fluxes.
   ! This depends on the parameter discr.
   SELECT CASE  (discr) 
   CASE (dissscalar) 
   ! Standard scalar dissipation scheme.
   IF (finegrid) THEN
   CALL DEBUG_TGT_CALL('INVISCIDDISSFLUXSCALAR', .TRUE., .FALSE.)
   CALL INVISCIDDISSFLUXSCALAR_T()
   CALL DEBUG_TGT_EXIT()
   ELSE
   CALL DEBUG_TGT_CALL('INVISCIDDISSFLUXSCALARCOARSE', .TRUE., &
   &                    .FALSE.)
   CALL INVISCIDDISSFLUXSCALARCOARSE_T()
   CALL DEBUG_TGT_EXIT()
   END IF
   CASE (dissmatrix) 
   !===========================================================
   ! Matrix dissipation scheme.
   IF (finegrid) THEN
   IF (.TRUE. .AND. DEBUG_TGT_HERE('middle', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('rev', rev, revd, ISIZE1OFDrfrev*&
   &                            ISIZE2OFDrfrev*ISIZE3OFDrfrev)
   CALL DEBUG_TGT_REAL8ARRAY('p', p, pd, ISIZE1OFDrfp*ISIZE2OFDrfp*&
   &                            ISIZE3OFDrfp)
   CALL DEBUG_TGT_REAL8ARRAY('sfacei', sfacei, sfaceid, &
   &                            ISIZE1OFDrfsfacei*ISIZE2OFDrfsfacei*&
   &                            ISIZE3OFDrfsfacei)
   CALL DEBUG_TGT_REAL8ARRAY('sfacej', sfacej, sfacejd, &
   &                            ISIZE1OFDrfsfacej*ISIZE2OFDrfsfacej*&
   &                            ISIZE3OFDrfsfacej)
   CALL DEBUG_TGT_REAL8ARRAY('gamma', gamma, gammad, &
   &                            ISIZE1OFDrfgamma*ISIZE2OFDrfgamma*&
   &                            ISIZE3OFDrfgamma)
   CALL DEBUG_TGT_REAL8ARRAY('sfacek', sfacek, sfacekd, &
   &                            ISIZE1OFDrfsfacek*ISIZE2OFDrfsfacek*&
   &                            ISIZE3OFDrfsfacek)
   CALL DEBUG_TGT_REAL8ARRAY('dw', dw, dwd, ISIZE1OFDrfdw*&
   &                            ISIZE2OFDrfdw*ISIZE3OFDrfdw*ISIZE4OFDrfdw)
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                            ISIZE3OFDrfw*ISIZE4OFDrfw)
   CALL DEBUG_TGT_REAL8ARRAY('rlv', rlv, rlvd, ISIZE1OFDrfrlv*&
   &                            ISIZE2OFDrfrlv*ISIZE3OFDrfrlv)
   CALL DEBUG_TGT_REAL8ARRAY('x', x, xd, ISIZE1OFDrfx*ISIZE2OFDrfx*&
   &                            ISIZE3OFDrfx*ISIZE4OFDrfx)
   CALL DEBUG_TGT_REAL8ARRAY('vol', vol, vold, ISIZE1OFDrfvol*&
   &                            ISIZE2OFDrfvol*ISIZE3OFDrfvol)
   CALL DEBUG_TGT_REAL8ARRAY('si', si, sid, ISIZE1OFDrfsi*&
   &                            ISIZE2OFDrfsi*ISIZE3OFDrfsi*ISIZE4OFDrfsi)
   CALL DEBUG_TGT_REAL8ARRAY('sj', sj, sjd, ISIZE1OFDrfsj*&
   &                            ISIZE2OFDrfsj*ISIZE3OFDrfsj*ISIZE4OFDrfsj)
   CALL DEBUG_TGT_REAL8ARRAY('sk', sk, skd, ISIZE1OFDrfsk*&
   &                            ISIZE2OFDrfsk*ISIZE3OFDrfsk*ISIZE4OFDrfsk)
   DO ii1=1,ISIZE1OFDrfbcdata
   CALL DEBUG_TGT_REAL8ARRAY('bcdata', bcdata(ii1)%norm, bcdatad(&
   &                              ii1)%norm, ISIZE1OFDrfDrfbcdata_norm*&
   &                              ISIZE2OFDrfDrfbcdata_norm*&
   &                              ISIZE3OFDrfDrfbcdata_norm)
   END DO
   CALL DEBUG_TGT_REAL8('pinfcorr', pinfcorr, pinfcorrd)
   CALL DEBUG_TGT_DISPLAY('middle')
   END IF
   CALL DEBUG_TGT_CALL('INVISCIDDISSFLUXMATRIX', .TRUE., .FALSE.)
   CALL INVISCIDDISSFLUXMATRIX_T()
   CALL DEBUG_TGT_EXIT()
   ELSE
   CALL DEBUG_TGT_CALL('INVISCIDDISSFLUXMATRIXCOARSE', .TRUE., &
   &                    .FALSE.)
   CALL INVISCIDDISSFLUXMATRIXCOARSE_T()
   CALL DEBUG_TGT_EXIT()
   END IF
   CASE (disscusp) 
   !===========================================================
   ! Cusp dissipation scheme.
   IF (finegrid) THEN
   CALL INVISCIDDISSFLUXCUSP()
   fwd = 0.0_8
   ELSE
   CALL INVISCIDDISSFLUXCUSPCOARSE()
   fwd = 0.0_8
   END IF
   CASE (upwind) 
   CALL DEBUG_TGT_CALL('INVISCIDUPWINDFLUX', .TRUE., .FALSE.)
   !===========================================================
   ! Dissipation via an upwind scheme.
   CALL INVISCIDUPWINDFLUX_T(finegrid)
   CALL DEBUG_TGT_EXIT()
   CASE DEFAULT
   fwd = 0.0_8
   END SELECT
   ! Compute the viscous flux in case of a viscous computation.
   IF (viscous) THEN
   CALL DEBUG_TGT_CALL('VISCOUSFLUX', .TRUE., .FALSE.)
   CALL VISCOUSFLUX_T()
   CALL DEBUG_TGT_EXIT()
   ELSE
   DO ii1=1,ISIZE1OFDrfviscsubface
   viscsubfaced(ii1)%tau = 0.0_8
   END DO
   END IF
   ! Add the dissipative and possibly viscous fluxes to the
   ! Euler fluxes. Loop over the owned cells and add fw to dw.
   ! Also multiply by iblank so that no updates occur in holes
   ! or on the overset boundary.
   DO l=1,nwf
   DO k=2,kl
   DO j=2,jl
   DO i=2,il
   result1 = REAL(iblank(i, j, k), realtype)
   dwd(i, j, k, l) = result1*(dwd(i, j, k, l)+fwd(i, j, k, l))
   dw(i, j, k, l) = (dw(i, j, k, l)+fw(i, j, k, l))*result1
   END DO
   END DO
   END DO
   END DO
   IF (.TRUE. .AND. DEBUG_TGT_HERE('exit', .FALSE.)) THEN
   CALL DEBUG_TGT_REAL8ARRAY('p', p, pd, ISIZE1OFDrfp*ISIZE2OFDrfp*&
   &                        ISIZE3OFDrfp)
   CALL DEBUG_TGT_REAL8ARRAY('dw', dw, dwd, ISIZE1OFDrfdw*ISIZE2OFDrfdw&
   &                        *ISIZE3OFDrfdw*ISIZE4OFDrfdw)
   CALL DEBUG_TGT_REAL8ARRAY('w', w, wd, ISIZE1OFDrfw*ISIZE2OFDrfw*&
   &                        ISIZE3OFDrfw*ISIZE4OFDrfw)
   DO ii1=1,ISIZE1OFDrfviscsubface
   CALL DEBUG_TGT_REAL8ARRAY('viscsubface', viscsubface(ii1)%tau, &
   &                          viscsubfaced(ii1)%tau, &
   &                          ISIZE1OFDrfDrfviscsubface_tau*&
   &                          ISIZE2OFDrfDrfviscsubface_tau*&
   &                          ISIZE3OFDrfDrfviscsubface_tau)
   END DO
   CALL DEBUG_TGT_DISPLAY('exit')
   END IF
   END SUBROUTINE RESIDUAL_BLOCK_T
