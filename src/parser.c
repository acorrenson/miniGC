
#include "parser.h"
#include <string.h>

bool accept(char *input, char *str) {
  int l = strlen(str);
  int i = 0;
  while (i < l && input[i] == str[i]) {
    i++;
  }
  return (i == l);
}

char *readline(FILE *f) {
  char *buff = NULL;
  size_t n = 0;
  getline(&buff, &n, f);
  return buff;
}

int find_space(char *input) {
  int i = 0;
  while (input[i] != ' ') {
    i++;
  }
  return i;
}

char *next(char *input, int skip) {
  char *dest = malloc(256);
  dest[strlen(input)] = '\0';
  strcpy(dest, input + skip);
  printf("test  : %d @ %p, %s\n", strlen(dest), dest, dest);
  return dest;
}

int read_int(char *input) {
  int val = 0;
  sscanf(input, "%d", &val);
  return val;
}