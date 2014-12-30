######################################
# VARIABLES
######################################
SHAREDLIB = ib
TARGETS = ib

CC = gcc
ARCH = -m64 -march=native -mtune=native

CFLAGS += -Wall -Wno-switch -std=c11 -O3 -g3 -fPIC $(ARCH)
LDFLAGS += -rdynamic -Xlinker --no-as-needed
INCLUDEDIRS += . .. ../include
LIBSFOLDERS += 
LIBFILES += stdc++ dl nsl m pthread rt

# Create the objects based on targets
OBJECTS = $(foreach TARGET,$(TARGETS),$(TARGET).o)
INCLUDES = $(foreach FOLDER,$(INCLUDEDIRS),-I$(FOLDER))
LIBDIRS = $(foreach FOLDER,$(LIBSFOLDERS),-L$(FOLDER))
LIBS = $(foreach LIB,$(LIBFILES),-l$(LIB))

#default all so all is called or whatever
all :
allmore :
installmore :

######################################
# DEFAULT COMPILATIONS
######################################
# default compilation commands
# Created depends as .d so that we have automated detection of changes in header files
%.o : %.cpp
	$(CXX) $(INCLUDES) $(CFLAGS) -c $< -o $@
	$(CXX) $(INCLUDES) $(CFLAGS) -MM $< > $*.d
	@cp -f $*.d $*.d.tmp
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
	  sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
	@rm -f $*.d.tmp
%.o : %.c
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
	$(CC) $(INCLUDES) $(CFLAGS) -MM $< > $*.d
	@cp -f $*.d $*.d.tmp
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
	  sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
	@rm -f $*.d.tmp

-include $(OBJECTS:.o=.d)

# if the target is a shared lib (C++)
ifdef SHAREDLIB
SHAREDNAME = $(SHAREDLIB).so
INSTALLFOLDER = $(BASEDIR)/lib

all : $(SHAREDNAME)
$(SHAREDNAME) : $(OBJECTS)
	$(CXX) -shared -Wl,-soname,$(SHAREDNAME) $(CFLAGS) $(INCLUDES) $(LIBDIRS) $(OBJECTS) $(LIBS) -o $(SHAREDNAME)

install : 
	mkdir -p $(INSTALLFOLDER)
	cp $(SHAREDMINOR) $(INSTALLFOLDER)
endif