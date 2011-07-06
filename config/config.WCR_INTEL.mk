#      ******************************************************************
#      *                                                                *
#      * File:          config.ALC_LINUX.mk                             *
#      * Author:        Edwin van der Weide                             *
#      * Starting date: 04-25-2005                                      *
#      * Last modified: 02-23-2006                                      *
#      *                                                                *
#      ******************************************************************

#      ******************************************************************
#      *                                                                *
#      * Description: Defines the compiler settings and other commands  *
#      *              to have "make" function correctly. This file      *
#      *              defines the settings for a parallel Linux         *
#      *              executable on the LLNL ALC machine.               *
#      *                                                                *
#      ******************************************************************

#      ==================================================================

#      ******************************************************************
#      *                                                                *
#      * Possibly overrule the make command to allow for parallel make. *
#      *                                                                *
#      ******************************************************************

#MAKE       = make -j 2

#      ******************************************************************
#      *                                                                *
#      * Suffix of the executable such that binaries of multiple        *
#      * platforms can be stored in the bin directory.                  *
#      *                                                                *
#      ******************************************************************

EXEC_SUFFIX = _wcr_intel

#      ******************************************************************
#      *                                                                *
#      * F90 and C compiler definitions.                                *
#      *                                                                *
#      ******************************************************************

FF90 = /share/apps/mvapich/intel/bin/mpif90
CC = /share/apps/mvapich/intel/bin/mpicc

#FF90 = mpiifort
#CC   = mpicc

#      ******************************************************************
#      *                                                                *
#      * CGNS include and linker flags.                                 *
#      *                                                                *
#      ******************************************************************

#CGNS_INCLUDE_FLAGS = -I$(HOME)/CGNS2.4/include
#CGNS_LINKER_FLAGS  = -L$(HOME)/CGNS2.4/lib -lcgns.LINUX

#      ******************************************************************
#      *                                                                *
#      * Precision flags. When nothing is specified 4 byte integer and  *
#      * and 8 byte real types are used. The flag -DUSE_LONG_INT sets   *
#      * the 8 byte integer to the standard integer type. The flag      *
#      * -DUSE_SINGLE_PRECISION sets the 4 byte real to the standard    *
#      * real type and -DUSE_QUADRUPLE_PRECISION will make 16 byte      *
#      * reals the default type. The latter option may not work on all  *
#      * platforms.                                                     *
#      *                                                                *
#      ******************************************************************

#FF90_INTEGER_PRECISION_FLAG = -DUSE_LONG_INT
#CC_INTEGER_PRECISION_FLAG   = -DUSE_LONG_INT

#FF90_REAL_PRECISION_FLAG = -DUSE_SINGLE_PRECISION
#FF90_REAL_PRECISION_FLAG = -DUSE_QUADRUPLE_PRECISION
#CC_REAL_PRECISION_FLAG   = -DUSE_SINGLE_PRECISION
#CC_REAL_PRECISION_FLAG   = -DUSE_QUADRUPLE_PRECISION

FF90_PRECISION_FLAGS = $(FF90_INTEGER_PRECISION_FLAG) \
		       $(FF90_REAL_PRECISION_FLAG)
CC_PRECISION_FLAGS   = $(CC_INTEGER_PRECISION_FLAG) \
		       $(CC_REAL_PRECISION_FLAG)

#      ******************************************************************
#      *                                                                *
#      * Compiler flags. It is assumed that mpif90 is based on the      *
#      * intel compiler ifort and mpicc on the gcc gnu compiler.        *
#      *                                                                *
#      ******************************************************************

COMMAND_SEARCH_PATH_MODULES = -I

FF90_GEN_FLAGS = -DUSE_NO_SIGNALS -DUSE_NO_CGNS
CC_GEN_FLAGS   = -DUSE_NO_SIGNALS -DUSE_NO_CGNS

#FF90_OPTFLAGS   = -O3 -ipo -ipo_obj
FF90_OPTFLAGS   = -O2 -tpp7 -xW -unroll -ip
#CC_OPTFLAGS     = -O3 -fexpensive-optimizations -frerun-cse-after-loop \
		  -fthread-jumps -funroll-loops -finline-functions
CC_OPTFLAGS     = -O

#FF90_DEBUGFLAGS = -g -tpp7 -xW -ip -unroll
#FF90_DEBUGFLAGS = -g -CA -CB -CS -CU -implicitnone -DDEBUG_MODE
#FF90_DEBUGFLAGS = -g -implicitnone -DDEBUG_MODE
#CC_DEBUGFLAGS   = -g -Wall -pedantic -DDEBUG_MODE
#CC_DEBUGFLAGS   = -g 

FF90_FLAGS = $(FF90_GEN_FLAGS) $(FF90_OPTFLAGS) $(FF90_DEBUGFLAGS)
CC_FLAGS   = $(CC_GEN_FLAGS)   $(CC_OPTFLAGS)   $(CC_DEBUGFLAGS)

#      ******************************************************************
#      *                                                                *
#      * pV3 and pvm3 linker flags.                                     *
#      *                                                                *
#      ******************************************************************

#PV3_FLAGS          = -DUSE_PV3
#PV3_LINKER_FLAGS   = -L/usr/local/pV3/clients/LINUX-INTEL -lpV3
#PVM3_LINKER_FLAGS  = -L/usr/local/pvm3/lib/LINUX -lgpvm3 -lpvm3
#PV3_INT_SRC_DIR    = src/pv3Interface

#      ******************************************************************
#      *                                                                *
#      * Archiver and archiver flags.                                   *
#      *                                                                *
#      ******************************************************************

AR       = ar
AR_FLAGS = -rvs

#      ******************************************************************
#      *                                                                *
#      * Linker and linker flags.                                       *
#      *                                                                *
#      ******************************************************************

#      Intel compiler version 8.1

LINKER       = $(FF90)
LINKER_FLAGS = $(FF90_OPTFLAGS) -nofor_main 
#	       -L/usr/lib/mpi/mpi_intel/lib -lmpio

#      Intel compiler version 7.1

#LINKER       = $(FF90)
#LINKER_FLAGS = $(FF90_OPTFLAGS)
