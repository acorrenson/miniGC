#ifndef VM_H
#define VM_H

#include <stdbool.h>

#define MAX_STACK_SIZE 512

/**
 * @brief Types of objects manipulated by the VM
 *
 */
typedef enum { OBJ_INT, OBJ_PAIR } t_Object;

/**
 * @brief Object values
 *
 */
typedef struct s_object {
  bool marked;
  t_Object type;
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
  Object *first_object;
} VM;

VM *new_VM(unsigned int gc_thresh);

Object *new_object(VM *vm, t_Object type);

void push(VM *vm, Object *value);

Object *pop(VM *vm);

void push_int(VM *vm, int int_value);

Object *push_pair(VM *vm);

#endif