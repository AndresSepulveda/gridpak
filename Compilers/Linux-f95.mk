#
# Include file for Sun F95 compiler on Linux
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
               FC := f95
           FFLAGS := -native -u
              CPP := /usr/bin/cpp
         CPPFLAGS := -P -traditional
            CLEAN := Bin/cpp_clean
               LD := $(FC)
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

ifdef LARGE
           FFLAGS += -m64
    NETCDF_INCDIR ?= /usr/local/include
    NETCDF_LIBDIR ?= /usr/local/lib64
else
    NETCDF_INCDIR ?= /usr/local/include
    NETCDF_LIBDIR ?= /usr/local/lib
endif
         CPPFLAGS += -I$(NETCDF_INCDIR)
             LIBS := -L$(NETCDF_LIBDIR) -lnetcdf

ifdef ARPACK
 ifdef MPI
   PARPACK_LIBDIR ?= /usr/local/lib
             LIBS += -L$(PARPACK_LIBDIR) -lparpack
 endif
    ARPACK_LIBDIR ?= /usr/local/lib
             LIBS += -L$(ARPACK_LIBDIR) -larpack
endif

ifdef MPI
         CPPFLAGS += -DMPI
               FC := tmf90
               LD := $(FC)
             LIBS += -lmpi
endif

ifdef OpenMP
         CPPFLAGS += -D_OPENMP
           FFLAGS += -openmp
endif

ifdef DEBUG
           FFLAGS += -g -C
else
           FFLAGS += -O3
endif