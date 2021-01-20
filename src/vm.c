#include "vm.h"
#include <stdio.h>
#include <stdlib.h>

void fail(char *msg) {
  fprintf(stderr, "VM error : %s\n", msg);
  exit(1);
}

/**
 * @brief Initialize a new VM with empty stack
 *
 */
VM *new_VM(unsigned int gc_thresh) {
  VM *vm = malloc(sizeof(VM));
  vm->stack_size = 0;
  vm->num_objects = 0;
  vm->max_objects = gc_thresh;
  vm->first_object = NULL;
  vm->gc_on = true;
  return vm;
}

/**
 * @brief Allocate a new object on the heap
 *
 * @param vm
 * @param type
 * @return Object*
 */
Object *new_object(VM *vm, t_object type) {
  if (vm->num_objects >= vm->max_objects && vm->gc_on)
    gc(vm);

  Object *object = malloc(sizeof(Object));
  object->type = type;
  object->marked = false;
  object->next = vm->first_object;
  vm->first_object = object;
  vm->num_objects++;

  return object;
}

void vm_gc_off(VM *vm) { vm->gc_on = false; }

void vm_gc_on(VM *vm) { vm->gc_on = true; }

/**
 * @brief Push a value on the stack
 *
 * @param vm
 * @param value
 */
void push(VM *vm, Object *value) {
  if (vm->stack_size >= MAX_STACK_SIZE)
    fail("Stack overflow !");
  vm->stack[vm->stack_size++] = value;
}

/**
 * @brief Pop a value from the stack
 *
 * @param vm
 * @return Object*
 */
Object *pop(VM *vm) {
  if (vm->stack_size <= 0)
    fail("Stack underflow !");
  return vm->stack[--vm->stack_size];
}

/**
 * @brief Push an integer on the stack
 *
 * @param vm
 * @param int_value
 */
void push_int(VM *vm, int int_value) {
  Object *obj = new_object(vm, OBJ_INT);
  obj->value = int_value;
  push(vm, obj);
}

/**
 * @brief Pop 2 objects from the stack, make a pair out of them and push it back
 * to the stack
 *
 * @param vm
 * @return Object*
 */
Object *push_pair(VM *vm) {
  Object *obj = new_object(vm, OBJ_PAIR);
  obj->right = pop(vm);
  obj->left = pop(vm);
  push(vm, obj);
  return obj;
}

void vsum(VM *vm) {
  Object *v1 = pop(vm);
  Object *v2 = pop(vm);
  vm_gc_off(vm);
  if (v1->type != OBJ_PAIR || v2->type != OBJ_PAIR) {
    fail("Dynamic type error, trying to perform vectorial sum on non vector "
         "objects");
    // TODO : check that v1 & v2 contains integers
  }
  push_int(vm, v1->left->value + v2->left->value);
  push_int(vm, v1->right->value + v2->right->value);
  vm_gc_on(vm);
  push_pair(vm);
}

void debug_object(Object *obj) {
  if (obj->type == OBJ_INT) {
    fprintf(stderr, "obj @ %p is Int(%d)\n", obj, obj->value);
  } else if (obj->type == OBJ_PAIR) {
    if (obj->left->type == OBJ_INT && obj->right->type == OBJ_INT) {
      fprintf(stderr, "obj @ %p is Pair(%d, %d)\n", obj, obj->left->value,
              obj->right->value);
    } else {
      fprintf(stderr, "obj @ %p is Pair(%p, %p)\n", obj, obj->left, obj->right);
    }
  }
}

void debug(VM *vm) {
  fprintf(stderr, "VM : stack_size = %d\n", vm->stack_size);
  for (unsigned int i = 0; i < vm->stack_size; i++) {
    debug_object(vm->stack[i]);
  }
}