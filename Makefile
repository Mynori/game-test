# Build commands
CC = rgbasm
LINK = rgblink
FIX = rgbfix

# Directories 
OBJDIR = obj
BUILDDIR = bin
VPATH := src

# Name and sources of the projet
NAME =		game.gb
SOURCES =	main.z80

# Compiler 
$(OBJDIR)/%.obj: %.z80
	mkdir -p $(OBJDIR)
	$(CC) -o$@ $<

# Linker
$(OBJDIR)/%.map: $(OBJDIR)/%.obj
	$(LINK) -m$@ $<

$(OBJDIR)/%.sym: $(OBJDIR)/%.obj
	$(LINK) -n$@ $<

# Builder
$(BUILDDIR)/%.gb: $(OBJDIR)/%.obj
	mkdir -p $(BUILDDIR)
	$(LINK) -o$(BUILDDIR)/$(NAME) $<
	$(FIX) -p0 -v $(BUILDDIR)/$(NAME)

# Object and binary files
OBJECTS = $(SOURCES:%.z80=$(OBJDIR)/%.obj)
MAPS = $(OBJECTS:$(OBJDIR)/%.obj=$(OBJDIR)/%.map)
SYMBOLS = $(OBJECTS:$(OBJDIR)/%.obj=$(OBJDIR)/%.sym)
BINARY = $(OBJECTS:$(OBJDIR)/%.obj=$(BUILDDIR)/%.gb)

#
all: $(OBJECTS) $(MAPS) $(SYMBOLS) $(BINARY)

build: $(OBJECTS) $(BINARY)

clean:
	rm -rf $(OBJECTS) $(MAPS) $(SYMBOLS) $(OBJDIR)

fclean:	clean
	rm -rf $(BINARY) $(BUILDDIR)

re: fclean all

test:
	bgb $(BUILDDIR)/$(NAME)