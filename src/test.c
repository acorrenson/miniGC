#include "parser.h"
#include "vm.h"
#include <stdio.h>

int main() {
  printf("Hello GC !\n");
  VM *vm = new_VM(1);

  push_int(vm, 1);
  push_int(vm, 2);
  push_instance(vm, 2, "MaClasse");
  pop(vm);
  gc(vm);
  debug(vm);

  // FILE *f = fopen("../compil/code.minigc", "r");

  // if (f == NULL) {
  //   perror("Open failed");
  //   exit(1);
  // }

  // char line[256];
  // int x;

  // while (!feof(f)) {
  //   fscanf(f, "%s", line);
  //   if (accept(line, "Push_int")) {
  //     fscanf(f, "%d", &x);
  //     printf("Push_int %d\n", x);
  //     push_int(vm, x);
  //   } else if (accept(line, "Push_vec")) {
  //     printf("Push_vec\n");
  //     push_pair(vm);
  //   } else if (accept(line, "Push_vsum")) {
  //     printf("Push_vsum\n");
  //     vsum(vm);
  //   }
  // }

  debug(vm);

  return 0;
}