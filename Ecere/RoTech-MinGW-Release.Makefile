.PHONY: all objdir clean realclean

# CONTENT

MODULE := RoTech
CONFIG := release
COMPILER := minGW
TARGET_TYPE = executable

OBJ = obj/$(CONFIG).$(PLATFORM)/

RES = 

ifeq "$(TARGET_TYPE)" "executable"
CONSOLE = -mwindows
endif

TARGET = obj/$(CONFIG).$(PLATFORM)/RoTech$(E)

OBJECTS = \
	$(OBJ)mainform.o \
	$(OBJ)$(MODULE).main$(O)

COBJECTS = \
	$(OBJ)mainform.c

SYMBOLS = \
	$(OBJ)mainform.sym

IMPORTS = \
	$(OBJ)mainform.imp

SOURCES = \
	mainform.ec

RESOURCES =


# HOST PLATFORM DETECTION
ifeq "$(OS)" "Windows_NT"
   WINDOWS = defined
else
ifeq "$(OSTYPE)" "FreeBSD"
   BSD = defined
else
ifeq "$(shell uname)" "Darwin"
   OSX = defined
else
   LINUX = defined
endif
endif
endif

# PLATFORM (TARGET)
ifndef PLATFORM
ifdef WINDOWS
   PLATFORM := win32
else
ifdef OSX
   PLATFORM := apple
else
   PLATFORM := linux
endif
endif
endif

# MISC STRING TOOLS
empty :=
space := $(empty) $(empty)
fixspace = $(subst $(space),\$(space),$1)
hidspace = $(subst $(space),^,$1)
shwspace = $(subst ^,$(space),$1)

# PATH SEPARATOR STRING TOOLS
ifdef WINDOWS
ifndef MSYSCON
   WIN_PS_TOOLS := defined
endif
endif
ifdef WIN_PS_TOOLS
   fixps = $(subst \,/,$(1))
   psep = $(subst \\,/,$(subst /,\,$(1)))
   PS := $(strip \)
else
   fixps = $(1)
   PS := $(strip /)
   psep = $(1)
endif

# PREFIXES AND EXTENSIONS
.SUFFIXES: .c .ec .sym .imp .o
S := .sym
I := .imp
O := .o
A := .a
ifeq "$(PLATFORM)" "win32"
   E := .exe
ifeq "$(TARGET_TYPE)" "staticlib"
   LP := lib
else
   LP :=
endif
   SO := .dll
else
ifeq "$(PLATFORM)" "apple"
   E :=
   LP := lib
   SO := .dylib
else
   E :=
   LP := lib
   SO := .so
endif
endif

# SUPER TOOLS
ifdef CCACHE
   CCACHE_COMPILE := ccache
ifdef DISTCC
   DISTCC_COMPILE := distcc
endif
else
ifdef DISTCC
   DISTCC_COMPILE := distcc
endif
endif

# TOOLCHAIN
export CC      = $(CCACHE_COMPILE) $(DISTCC_COMPILE) gcc
export CPP     = $(CCACHE_COMPILE) $(DISTCC_COMPILE) cpp
export ECP     = ecp
export ECC     = ecc
export ECS     = ecs
export EAR     = ear
export AS      = as
export LD      = ld
export AR      = ar
export STRIP   = strip
UPX := upx

# SHELL COMMANDS
ifdef WINDOWS
ifndef MSYSCON
   WIN_SHELL_COMMANDS := defined
endif
endif
ifdef WIN_SHELL_COMMANDS
   echo = $(if $(1),echo $(1))
   cpq = $(if $(1),@cmd /c for %%I in ($(call psep,$(1))) do @copy /y %%I $(call psep,$(2)) > nul 2>&1)
   rmq = $(if $(1),-@del /f /q $(call psep,$(1)) > nul 2>&1)
   rmrq = $(if $(1),-@rmdir /q /s $(call psep,$(1)) > nul 2>&1)
   mkdirq = $(if $(1),-@mkdir $(call psep,$(1)) > nul 2>&1)
   rmdirq = $(if $(1),-@rmdir /q $(call psep,$(1)) > nul 2>&1)
else
   echo = $(if $(1),echo "$(1)")
   cpq = $(if $(1),@cp $(1) $(2))
   rmq = $(if $(1),-@rm -f $(1))
   rmrq = $(if $(1),-@rm -f -r $(1))
   mkdirq = $(if $(1),-@mkdir -p $(1))
   rmdirq = $(if $(1),-@rmdir $(1))
endif

# COMPILER OPTIONS
ifeq "$(TARGET_TYPE)" "sharedlib"
   ECSLIBOPT := -dynamiclib
else
ifeq "$(TARGET_TYPE)" "staticlib"
   ECSLIBOPT := -staticlib
else
   ECSLIBOPT :=
endif
endif
ifdef WINDOWS
   FVISIBILITY :=
   FPIC :=
ifeq "$(TARGET_TYPE)" "executable"
   EXECUTABLE := $(CONSOLE)
else
   EXECUTABLE :=
endif
else
   FVISIBILITY := -fvisibility=hidden
   FPIC := -fPIC
   EXECUTABLE :=
endif
ifdef OSX
ifeq "$(TARGET_TYPE)" "sharedlib"
   INSTALLNAME := -install_name $(LP)$(MODULE)$(SO)
else
   INSTALLNAME :=
endif
else
   INSTALLNAME :=
endif

# LINKER OPTIONS
ifdef OSX
ifeq "$(TARGET_TYPE)" "sharedlib"
   SHAREDLIB := -dynamiclib -single_module -multiply_defined suppress
   LINKOPT :=
else
   SHAREDLIB :=
   LINKOPT :=
endif
ifeq "$(TARGET_TYPE)" "sharedlib"
   STRIPOPT := -x
else
   STRIPOPT := -u -r
endif
else
ifeq "$(TARGET_TYPE)" "sharedlib"
   SHAREDLIB := -shared
else
   SHAREDLIB :=
endif
   LINKOPT :=
   STRIPOPT := -x
endif
ifdef WINDOWS
   SODESTDIR := obj/$(PLATFORM)/bin/
else
   SODESTDIR := obj/$(PLATFORM)/lib/
endif

# COMMON LIBRARIES DETECTION

ifdef WINDOWS

_SSL_CONF = $(call hidspace,$(call fixps,$(OPENSSL_CONF)))
_SSL_BIN = $(_SSL_CONF:$(notdir $(_SSL_CONF))=$(empty))
OPEN_SSL_INCLUDE_DIR = $(call fixspace,$(call shwspace,$(subst /bin,/include,$(_SSL_BIN))))
OPEN_SSL_LIB_DIR = $(call fixspace,$(call shwspace,$(subst /bin,/lib,$(_SSL_BIN))))
OPEN_SSL_BIN_DIR = $(call fixspace,$(call shwspace,$(_SSL_BIN)))

endif

# FLAGS

CFLAGS = -fmessage-length=0 -O2 -ffast-math -m32 $(FPIC) -Wall

CECFLAGS =

ECFLAGS =

OFLAGS =
ifneq "$(TARGET_TYPE)" "staticlib"
OFLAGS += -m32 \
	 -LE:/Software/Portable-Ecere-SDK-0.44-Ryoanji-MinGW/bin \
	 -LE:/Software/Portable-Ecere-SDK-0.44-Ryoanji-MinGW/lib \
	 -LE:/Software/Portable-Ecere-SDK-0.44-Ryoanji-MinGW/mingw/lib
endif

LIBS =
ifneq "$(TARGET_TYPE)" "staticlib"
LIBS += -lecere
endif
LIBS += $(SHAREDLIB) $(EXECUTABLE) $(LINKOPT)

UPXFLAGS = -9

# HARD CODED PLATFORM-SPECIFIC OPTIONS
ifdef LINUX
OFLAGS += -Wl,--no-undefined
endif

ifdef OSX
OFLAGS += -framework cocoa -framework OpenGL
endif

# TARGETS

all: objdir $(TARGET)

objdir:
	$(if $(wildcard $(OBJ)),,$(call mkdirq,$(OBJ)))

$(OBJ)$(MODULE).main.ec: $(SYMBOLS) $(COBJECTS)
	$(ECS) $(ECSLIBOPT) $(SYMBOLS) $(IMPORTS) -symbols obj/$(CONFIG).$(PLATFORM) -o $(OBJ)$(MODULE).main.ec

$(OBJ)$(MODULE).main.c: $(OBJ)$(MODULE).main.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c $(OBJ)$(MODULE).main.ec -o $(OBJ)$(MODULE).main.sym -symbols $(OBJ)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)$(MODULE).main.ec -o $(OBJ)$(MODULE).main.c -symbols $(OBJ)

$(SYMBOLS): | objdir
$(OBJECTS): | objdir
$(TARGET): $(SOURCES) $(RESOURCES) $(SYMBOLS) $(OBJECTS) | objdir
ifneq "$(TARGET_TYPE)" "staticlib"
	$(CC) $(OFLAGS) $(OBJECTS) $(LIBS) -o $(TARGET) $(INSTALLNAME)
ifndef NOSTRIP
	$(STRIP) $(STRIPOPT) $(TARGET)
endif
else
	$(AR) rcs $(TARGET) $(OBJECTS) $(LIBS)
endif

# SYMBOL RULES

$(OBJ)mainform.sym: mainform.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c mainform.ec -o $(OBJ)mainform.sym

# C OBJECT RULES

$(OBJ)mainform.c: mainform.ec $(OBJ)mainform.sym | $(SYMBOLS)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c mainform.ec -o $(OBJ)mainform.c -symbols $(OBJ)

# OBJECT RULES

$(OBJ)mainform.o: $(OBJ)mainform.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)mainform.c -o $(OBJ)mainform.o

$(OBJ)$(MODULE).main$(O): $(OBJ)$(MODULE).main.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)$(MODULE).main.c -o $(OBJ)$(MODULE).main$(O)

clean: objdir
	$(call rmq,$(OBJ)$(MODULE).main.c $(OBJ)$(MODULE).main.ec $(OBJ)$(MODULE).main$(I) $(OBJ)$(MODULE).main$(S) $(TARGET))
	$(call rmq,$(OBJECTS))
	$(call rmq,$(COBJECTS))
	$(call rmq,$(IMPORTS))
	$(call rmq,$(SYMBOLS))

realclean: clean
	$(call rmrq,$(OBJ))
