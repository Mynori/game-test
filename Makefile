COMPILE = rgbasm
LINK = rgblink
FIX = rgbfix

NAME = game.gb

%.obj: %.z80
	$(COMPILE) -o$@ $<

SOURCES = src/game.z80

OBJECTS = $(SOURCES:.z80=.obj)

$(NAME): $(OBJECTS)
	$(LINK) -o $(NAME) $(OBJECTS)
	$(FIX) -p0 -v $(NAME)

all: $(NAME)

clean:
	rm -rf *.obj *.sym *.map

fclean:	clean
	rm -rf *.gb

re: fclean all

test:
	bgb $(NAME)