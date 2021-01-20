#include "vm.h"
#include <stdio.h>
#include <stdlib.h>

void mark(Object *object) {
  if (object->marked)
    return;
  // fprintf(stderr, "GC : marking object @ %p\n", object);
  object->marked = true;
  if (object->type == OBJ_PAIR) {
    mark(object->left);
    mark(object->right);
  }
}

void mark_all(VM *vm) {
  for (unsigned int i = 0; i < vm->stack_size; i++)
    mark(vm->stack[i]);
}

void sweep(VM *vm) {
  Object **object = &vm->first_object;
  while (*object) {
    if (!(*object)->marked) {
      fprintf(stderr, "GC : sweeping object @ %p\n", *object, (*object)->value);
      Object *unreached = *object;
      *object = unreached->next;
      vm->num_objects--;
      free(unreached);
    } else {
      (*object)->marked = false;
      object = &(*object)->next;
    }
  }
}

void gc(VM *vm) {
  // fprintf(stderr, "GC : Trigger\n");
  mark_all(vm);
  sweep(vm);
}