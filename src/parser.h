#ifndef PARSER_H
#define PARSER_H

#include <stdbool.h>
#include <stdio.h>

bool accept(char *input, char *str);

char *readline(FILE *f);

char *next(char *input, int skip);

#endif