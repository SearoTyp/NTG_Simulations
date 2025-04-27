###############################################################################
################### MOOSE Application Standard Makefile #######################
###############################################################################
#
# Optional Environment variables
# MOOSE_DIR        - Root directory of the MOOSE project
#
###############################################################################
# Use the MOOSE submodule if it exists and MOOSE_DIR is not set
MOOSE_SUBMODULE    := $(CURDIR)/moose
ifneq ($(wildcard $(MOOSE_SUBMODULE)/framework/Makefile),)
  MOOSE_DIR        ?= $(MOOSE_SUBMODULE)
else
  MOOSE_DIR        ?= $(shell dirname `pwd`)/moose
endif

# framework
FRAMEWORK_DIR      := $(MOOSE_DIR)/framework
include $(FRAMEWORK_DIR)/build.mk
include $(FRAMEWORK_DIR)/moose.mk

################################## MODULES ####################################
# To use certain physics included with MOOSE, set variables below to
# yes as needed.  Or set ALL_MODULES to yes to turn on everything (overrides
# other set variables).

ALL_MODULES                 := Yes

CHEMICAL_REACTIONS          := Yes
CONTACT                     := Yes
ELECTROMAGNETICS            := Yes
EXTERNAL_PETSC_SOLVER       := Yes
FLUID_PROPERTIES            := Yes
FSI                         := Yes
FUNCTIONAL_EXPANSION_TOOLS  := Yes
GEOCHEMISTRY                := Yes
HEAT_TRANSFER               := Yes
LEVEL_SET                   := Yes
MISC                        := Yes
NAVIER_STOKES               := Yes
OPTIMIZATION                := Yes
PERIDYNAMICS                := Yes
PHASE_FIELD                 := Yes
POROUS_FLOW                 := Yes
RAY_TRACING                 := Yes
REACTOR                     := Yes
RDG                         := Yes
RICHARDS                    := Yes
SOLID_MECHANICS             := Yes
STOCHASTIC_TOOLS            := Yes
THERMAL_HYDRAULICS          := Yes
XFEM                        := Yes

include $(MOOSE_DIR)/modules/modules.mk
###############################################################################

# dep apps
APPLICATION_DIR    := $(CURDIR)
APPLICATION_NAME   := ntg__sims
BUILD_EXEC         := yes
GEN_REVISION       := no
include            $(FRAMEWORK_DIR)/app.mk

###############################################################################
# Additional special case targets should be added here
