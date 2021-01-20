#ifndef VM_H
#define VM_H

#include <stdbool.h>

#define MAX_STACK_SIZE 512

/**
 * @brief Types of objects manipulated by the VM
 *
 */
typedef enum { OBJ_INT, OBJ_PAIR } t_object;

/**
 * @brief Object values
 *
 */
typedef struct s_object {
  bool marked;
  t_object type;
  struct s_object *next;
  union {
    int value;
    struct {
      struct s_object *left;
      struct s_object *right;
    };
  };
} Object;

/**
 * @brief VM data
 *
 */
typedef struct {
  Object *stack[MAX_STACK_SIZE];
  unsigned int stack_size;
  unsigned int num_objects;
  unsigned int max_objects;
  bool gc_on;
  Object *first_object;
} VM;

VM *new_VM(unsigned int gc_thresh);

void vm_gc_off(VM *vm);

void vm_gc_on(VM *vm);

Object *new_object(VM *vm, t_object type);

void push(VM *vm, Object *value);

Object *pop(VM *vm);

void push_int(VM *vm, int int_value);

Object *push_pair(VM *vm);

void vsum(VM *vm);

void debug_object(Object *obj);

void debug(VM *vm);

#endif