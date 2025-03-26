# Variables
CC = gcc
BISON = bison
FLEX = flex
EXEC = prog
SOURCES = lex.yy.c miniC.tab.c
TARGET = $(EXEC)

# Règle par défaut
all: $(TARGET)

# Générer l'analyseur syntaxique avec Bison
miniC.tab.c miniC.tab.h: miniC.y
	$(BISON) -d miniC.y

# Générer l'analyseur lexical avec Flex
lex.yy.c: ANSI-C.l miniC.tab.h
	$(FLEX) ANSI-C.l

# Compiler le programme
$(TARGET): $(SOURCES)
	$(CC) -o $(TARGET) $(SOURCES)

# Nettoyer les fichiers générés
clean:
	rm -f $(TARGET) lex.yy.c miniC.tab.c miniC.tab.h

# Règle pour éviter les conflits avec des fichiers nommés "clean"
.PHONY: all clean