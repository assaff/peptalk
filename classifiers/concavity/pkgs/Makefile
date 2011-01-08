#
# Makefile for GAPS pkgs
#

KERN=$(shell uname -s)

opt:
	$(MAKE) target "TARGET=$@"

debug:
	$(MAKE) target "TARGET=$@"

clean:
	$(MAKE) target "TARGET=$@"

release:
	mkdir -p ../release/pkgs
	cp Makefile ../release/pkgs
	$(MAKE) target "TARGET=$@"


ifeq ("$(KERN)","Darwin")
target: 
	cd RNBasics; $(MAKE) $(TARGET)
	cd R2Shapes; $(MAKE) $(TARGET)
	cd R3Shapes; $(MAKE) $(TARGET)
	cd R3Graphics; $(MAKE) $(TARGET)
	cd PDB; $(MAKE) $(TARGET)
else
target: 
	cd RNBasics; $(MAKE) $(TARGET)
	cd R2Shapes; $(MAKE) $(TARGET)
	cd R3Shapes; $(MAKE) $(TARGET)
	cd R3Graphics; $(MAKE) $(TARGET)
	cd PDB; $(MAKE) $(TARGET)
	cd freeglut; $(MAKE) $(TARGET)
endif





