#include "vm.h"
#include <stdio.h>

int main() {
  printf("Hello GC !\n");
  VM *vm = new_VM(3);

  push_int(vm, 0);
  push_int(vm, 1);
  push_int(vm, 2);
  push_pair(vm);
  pop(vm);
  push_int(vm, 3);
  push_int(vm, 4);
  push_int(vm, 5);
  debug(vm);

  return 0;
}