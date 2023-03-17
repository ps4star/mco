O_COMP := odin
RUN := run

SRC_DIR := src/mc
OUT_DIR := out/bin

BIN_NAME := mc_odin
ifeq ($(PLATFORM),windows)
	BIN_EXT := .exe
else
	BIN_EXT :=
endif

ifeq ($(ODIN_DIR),)
	ODIN_DIR := ~/git/Odin
endif

COLL_MCO_NAME := mco
COLL_MCO_COM_MOJANG_NAME := mco_com_mojang
COLL_MCO_JAVA_NAME := mco_java
COLL_MCO_EXTERN_NAME := mco_extern
COLLECTIONS := -collection:$(COLL_MCO_NAME)=src -collection:$(COLL_MCO_COM_MOJANG_NAME)=src/extern/com_mojang -collection:$(COLL_MCO_JAVA_NAME)=src/java -collection:$(COLL_MCO_EXTERN_NAME)=src/extern

DEFINES := -define:DEBUG=true

COMMON_FLAGS := -no-dynamic-literals
STD_OCOMP := $(O_COMP) $(RUN) $(SRC_DIR) $(DEFINES) $(COLLECTIONS) $(COMMON_FLAGS) -out:$(OUT_DIR)/$(BIN_NAME)$(BIN_EXT)
compile_src :
	$(STD_OCOMP)

GIT_CLONE := git clone
DEP_GLFW_NAME := OdinGLFW
DEP_GLFW := https://github.com/ps4star/$(DEP_GLFW_NAME)
pull_deps :
	$(GIT_CLONE) $(DEP_GLFW) $(ODIN_DIR)/shared/$(DEP_GLFW_NAME)