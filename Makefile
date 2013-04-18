# defines source files and vpaths
include Sources
INTERFACES = -H -Hdimport
OUTPUT = -of./lib/libnoise-d.lib
FLAGS = -O -release -inline

all:
	dmd $(SOURCES) $(OUTPUT) $(FLAGS) $(INTERFACES) -lib
