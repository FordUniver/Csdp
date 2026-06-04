#
# This Makefile can be used to automatically build the entire package.  
#
# If you make changes in the Makefile or code under any subdirectory, you can
# rebuild the system with "make clean" followed by "make all".
#
#
# You can change the C compiler by setting CC=... (CC=gcc where clang is absent).
#
# CFLAGS/LIBS are passed in by the build scripts in flagalgebra.rs.wrapper
# (build-csdp.sh for Linux/z3, rebuild-csdp.sh for macOS). The canonical, MEASURED
# settings are below; reasons noted (do not silently revert):
#   -O3       not -Ofast: -ffast-math is unsafe in a barrier IPM (NaN/Inf tests, tiny
#             gaps); and -Ofast measured == -O3 here (work is in BLAS, not CSDP's C).
#   OpenMP    OFF (no -DUSEOPENMP/-DSETNUMTHREADS): measured net-neutral-to-worse;
#             throughput comes from solving many points in parallel + a threaded BLAS.
#   no -ansi  the CSDP_DEBUG tracing macro uses C99 variadic macros; -ansi breaks it.
#   -DBIT64   64-bit index arithmetic; -DNOSHORTS int (not short) sparse indices: both
#             needed for large (n>=8) problems.
#
# Linux/z3:  export CFLAGS=-O3 -march=native -DBIT64 -DNOSHORTS -DUSESIGTERM -DUSEGETTIME -I../include
#            export LIBS=-L../lib -lsdp -llapack -lopenblas -lm
# macOS:     export CFLAGS=-O3 -mcpu=native -DBIT64 -DNOSHORTS -DUSESIGTERM -DUSEGETTIME -I../include
#            export LIBS=-L../lib -lsdp -framework Accelerate -lm
#
#
# On most systems, this should handle everything.
#
all:
	cd lib; make libsdp.a
	cd solver; make csdp
	cd theta; make all
	cd example; make all

#
# Perform a unitTest
#

unitTest:
	cd test; make all

#
# Install the executables in /usr/local/bin.
#

install:
	cp -f solver/csdp /usr/local/bin
	cp -f theta/theta /usr/local/bin
	cp -f theta/graphtoprob /usr/local/bin
	cp -f theta/complement /usr/local/bin
	cp -f theta/rand_graph /usr/local/bin

#
# Clean out all of the directories.
# 

clean:
	cd lib; make clean
	cd solver; make clean
	cd theta; make clean
	cd test; make clean
	cd example; make clean








