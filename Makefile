ROOT_DIR    = .
HEADERS_DIR = Headers
SOURCE_DIR  = Source
TOOLS_DIR   = Tools
PARSER_DIR  = $(TOOLS_DIR)/Parser
TESTER_DIR  = $(TOOLS_DIR)/Tester

LIB_SHEENBIDI = sheenbidi
LIB_PARSER    = sheenbidiparser
EXEC_TESTER   = sheenbiditester

ifndef CC
	CC = gcc
endif
ifndef CXX
	CXX = g++
endif

AR = ar
ARFLAGS = -r
CFLAGS = -ansi -pedantic -Wall -I$(HEADERS_DIR)
CXXFLAGS = -std=c++11 -g -Wall
DEBUG_FLAGS = -DDEBUG -g -O0
RELEASE_FLAGS = -DNDEBUG -DSB_CONFIG_UNITY -Os

DEBUG = Debug
RELEASE = Release

DEBUG_SOURCES = $(SOURCE_DIR)/BidiChain.c \
                $(SOURCE_DIR)/BidiTypeLookup.c \
                $(SOURCE_DIR)/BracketQueue.c \
                $(SOURCE_DIR)/GeneralCategoryLookup.c \
                $(SOURCE_DIR)/IsolatingRun.c \
                $(SOURCE_DIR)/LevelRun.c \
                $(SOURCE_DIR)/PairingLookup.c \
                $(SOURCE_DIR)/RunQueue.c \
                $(SOURCE_DIR)/SBAlgorithm.c \
                $(SOURCE_DIR)/SBBase.c \
                $(SOURCE_DIR)/SBCodepointSequence.c \
                $(SOURCE_DIR)/SBLine.c \
                $(SOURCE_DIR)/SBLog.c \
                $(SOURCE_DIR)/SBMirrorLocator.c \
                $(SOURCE_DIR)/SBParagraph.c \
                $(SOURCE_DIR)/SBScriptLocator.c \
                $(SOURCE_DIR)/ScriptLookup.c \
                $(SOURCE_DIR)/ScriptStack.c \
                $(SOURCE_DIR)/StatusStack.c
RELEASE_SOURCES = $(SOURCE_DIR)/SheenBidi.c

DEBUG_OBJECTS   = $(DEBUG_SOURCES:$(SOURCE_DIR)/%.c=$(DEBUG)/%.o)
RELEASE_OBJECTS = $(RELEASE_SOURCES:$(SOURCE_DIR)/%.c=$(RELEASE)/%.o)

DEBUG_TARGET   = $(DEBUG)/lib$(LIB_SHEENBIDI).a
PARSER_TARGET  = $(DEBUG)/lib$(LIB_PARSER).a
TESTER_TARGET  = $(DEBUG)/$(EXEC_TESTER)
RELEASE_TARGET = $(RELEASE)/lib$(LIB_SHEENBIDI).a

all:     release
release: $(RELEASE) $(RELEASE_TARGET)
debug:   $(DEBUG) $(DEBUG_TARGET)

check: tester
	./Debug/sheenbiditester Tools/Unicode

clean: parser_clean tester_clean
	$(RM) $(DEBUG)/*.o
	$(RM) $(DEBUG_TARGET)
	$(RM) $(RELEASE)/*.o
	$(RM) $(RELEASE_TARGET)

$(DEBUG):
	mkdir $(DEBUG)

$(RELEASE):
	mkdir $(RELEASE)

$(DEBUG_TARGET): $(DEBUG_OBJECTS)
	$(AR) $(ARFLAGS) $(DEBUG_TARGET) $(DEBUG_OBJECTS)

$(RELEASE_TARGET): $(RELEASE_OBJECTS)
	$(AR) $(ARFLAGS) $(RELEASE_TARGET) $(RELEASE_OBJECTS)

$(DEBUG)/%.o: $(SOURCE_DIR)/%.c
	$(CC) $(CFLAGS) $(EXTRA_FLAGS) $(DEBUG_FLAGS) -c $< -o $@

$(RELEASE)/%.o: $(SOURCE_DIR)/%.c
	$(CC) $(CFLAGS) $(EXTRA_FLAGS) $(RELEASE_FLAGS) -c $< -o $@

.PHONY: all check clean compiler debug parser release tester

include $(PARSER_DIR)/Makefile
include $(TESTER_DIR)/Makefile
