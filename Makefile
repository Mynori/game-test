# Build commands
CC		= rgbasm
LINK	= rgblink
FIX		= rgbfix

# Directories 
OBJDIR		= obj
BUILDDIR	= bin
VPATH 		:= src
GFXDIRSRC	= gfx
GFXDIROBJ	= $(OBJDIR)/gfx

# Name and sources of the projet
NAME 	= game.gb
SOURCES = main.z80
GFXSRC	= $(GFXDIRSRC)/test.png

# Graphical builder
$(GFXDIROBJ)/%.bin: $(GFXDIRSRC)/%.png
	mkdir -p $(GFXDIROBJ)
	rgbgfx -o $@ $<

# Compiler 
$(OBJDIR)/%.obj: %.z80
	mkdir -p $(OBJDIR)
	$(CC) -o$@ $<

# Linkers
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
GFX		= $(GFXSRC:$(GFXDIRSRC)/%.png=$(GFXDIROBJ)/%.bin)
OBJECTS	= $(SOURCES:%.z80=$(OBJDIR)/%.obj)
MAPS	= $(OBJECTS:$(OBJDIR)/%.obj=$(OBJDIR)/%.map)
SYMBOLS = $(OBJECTS:$(OBJDIR)/%.obj=$(OBJDIR)/%.sym)
BINARY 	= $(OBJECTS:$(OBJDIR)/%.obj=$(BUILDDIR)/%.gb)

# Rules
all: $(GFX) $(OBJECTS) $(MAPS) $(SYMBOLS) $(BINARY)

build: $(GFX) $(OBJECTS) $(BINARY)

clean:
	rm -rf $(GFX) $(OBJECTS) $(MAPS) $(SYMBOLS) $(GFXDIROBJ) $(OBJDIR)

fclean:	clean
	rm -rf $(BINARY) $(BUILDDIR)

re: fclean all

test:
	mgba -4 $(BUILDDIR)/$(NAME)