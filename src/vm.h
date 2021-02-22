#ifndef VM_H
#define VM_H

#include <stdbool.h>

#define MAX_STACK_SIZE 512

/**
 * @brief Types of objects manipulated by the VM
 *
 */
typedef enum { OBJ_INT, OBJ_PAIR, OBJ_CLASS } t_object;

/**
 * @brief Object values
 *
 */
typedef struct s_object {
  bool marked;
  t_object type;
  struct s_object *next;
  // Instance of ? (if class instance)
  char *class;
  // Number of local variables (if class instance)
  int num_locals;
  union {
    int value;
    // Local variables (if class instance)
    struct s_object **locals;
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

/**
 * @brief Initialise a new VM
 *
 * @param gc_thresh Garbage Collector threshold
 * @return VM*
 */
VM *new_VM(unsigned int gc_thresh);

/**
 * @brief Disable the GC
 *
 * @param vm
 */
void vm_gc_off(VM *vm);

/**
 * @brief Enable the GC
 *
 * @param vm
 */
void vm_gc_on(VM *vm);

/**
 * @brief Allocate a new object on the heap
 *
 * @param vm
 * @param type
 * @return Object*
 */
Object *new_object(VM *vm, t_object type);

/**
 * @brief Push an object on the stack
 *
 * @param vm
 * @param value
 */
void push(VM *vm, Object *value);

/**
 * @brief Prop on object from the stack
 *
 * @param vm
 * @return Object*
 */
Object *pop(VM *vm);

/**
 * @brief Allocate an integer and push it to the stack
 *
 * @param vm
 * @param int_value
 */
void push_int(VM *vm, int int_value);

Object *push_instance(VM *vm, int num_params, const char *class_name);

/**
 * @brief Pop 2 values from the stack, make a pair out of them and push it back
 *
 * @param vm
 * @return Object*
 */
Object *push_pair(VM *vm);

/**
 * @brief Pop two values and push vector sum
 *
 * @param vm
 */
void vsum(VM *vm);

/**
 * @brief Print informations about an object
 *
 * @param obj
 */
void debug_object(Object *obj);

/**
 * @brief Print informations about the current VM state
 *
 * @param obj
 */
void debug(VM *vm);

#endif