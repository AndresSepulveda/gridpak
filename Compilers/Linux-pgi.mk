#
# Include file for PGI Fortran compiler on Linux
# -----------------------------------------------------------------
#
# ARPACK_LIBDIR  ARPACK libary directory
# FC             Name of the fortran compiler to use
# FFLAGS         Flags to the fortran compiler
# CPP            Name of the C-preprocessor
# CPPFLAGS       Flags to the C-preprocessor
# CLEAN          Name of cleaning executable after C-preprocessing
# NETCDF_INCDIR  NetCDF include directory
# NETCDF_LIBDIR  NetCDF libary directory
# LD             Program to load the objects into an executable
# LDFLAGS        Flags to the loader
# RANLIB         Name of ranlib command
# MDEPFLAGS      Flags for sfmakedepend  (-s if you keep .f files)
#
# First the defaults
#
               FC := pgf90
           FFLAGS :=
              CPP := /usr/bin/cpp
         CPPFLAGS := -P -traditional -DLINUX
            CLEAN := Bin/cpp_clean
#               LD := ncargf90
               LD := ${FC}
          LDFLAGS := 
               AR := ar
          ARFLAGS := r
	    MKDIR := mkdir -p
               RM := rm -f
           RANLIB := ranlib
	     PERL := perl
	     TEST := test

        MDEPFLAGS := --cpp --fext=f90 --file=-

#
# Library locations, can be overridden by environment variables.
#

        NC_CONFIG ?= nc-config
    NETCDF_INCDIR ?= $(shell $(NC_CONFIG) --prefix)/include
             LIBS := $(shell $(NC_CONFIG) --flibs)

         CPPFLAGS += -I$(NETCDF_INCDIR)

ifdef ARPACK
    ARPACK_LIBDIR ?= /opt/pgisoft/ARPACK
             LIBS += -L$(ARPACK_LIBDIR) -larpack_LINUX
endif

ifdef MPI
         CPPFLAGS += -DMPI
             LIBS += -lfmpi-pgi -lmpi-pgi 
endif

ifdef OpenMP
         CPPFLAGS += -D_OPENMP
endif

ifdef DEBUG
           FFLAGS += -g
else
#           FFLAGS += -u -Bstatic -fastsse -Mipa=fast
           FFLAGS += -O2
endif

       clean_list += ifc* work.pc*
