SRCDIRS = `find * -prune\
	  -type d 	\
	  ! -name CVS	\
          ! -name neuron-modules \
          ! -name build-\* \
	  ! -name .` neuron-modules
