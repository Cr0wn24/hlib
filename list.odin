package hampuslib__list

import "base:intrinsics"

get_member_ptr_by_string :: proc(s: ^$T, $M: typeid, $member: string) -> ^M
where intrinsics.type_has_field(T, member) {
  result := cast(^M)intrinsics.ptr_offset(cast(^u8)s, offset_of_by_string(T, member))
  return result
}

//////////////////////////////////////////////////////////////////////
// Doubly-Linked-Lists (DLL)
//////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Insertion after

dll_insert_after__first_last_np :: proc(first, last: ^^$T, before, node: ^T, $next, $prev: string)
where intrinsics.type_has_field(T, next), intrinsics.type_has_field(T, prev) {
  assert(first != nil)
  assert(last != nil)
  assert(node != nil)

  if last^ == nil {
    last^ = node
    first^ = node
  } else {
    if before == last^ {
      last^ = node
    }

    next_of_before := get_member_ptr_by_string(before, ^T, next)
    if next_of_before^ != nil {
      prev_of_next_of_before := get_member_ptr_by_string(next_of_before^, ^T, prev)
      prev_of_next_of_before^ = node
    }

    next_of_node := get_member_ptr_by_string(node, ^T, next)
    prev_of_node := get_member_ptr_by_string(node, ^T, prev)
    next_of_node^ = next_of_before^
    prev_of_node^ = before

    next_of_before^ = node
  }
}

dll_insert_after__first_last :: proc(first, last: ^^$T, before, node: ^T) {
  dll_insert_after__first_last_np(first, last, before, node, "next", "prev")
}

dll_insert_after__list_np :: proc(list: ^$T, before, node: ^$M, $next, $prev: string) {
  first := get_member_ptr_by_string(list, ^M, "first")
  last := get_member_ptr_by_string(list, ^M, "last")
  dll_insert_after__first_last_np(first, last, before, node, next, prev)
}

dll_insert_after__list :: proc(list: ^$T, before, node: ^$M) {
  dll_insert_after__list_np(list, before, node, "next", "prev")
}

////////////////////////////////////////
// Insertion before

dll_insert_before__first_last_np :: proc(first, last: ^^$T, after, node: ^T, $next, $prev: string)
where intrinsics.type_has_field(T, next), intrinsics.type_has_field(T, prev) {
  assert(first != nil)
  assert(last != nil)
  assert(node != nil)

  if last^ == nil {
    last^ = node
    first^ = node
  } else {
    if after == first^ {
      first^ = node
    }

    prev_of_after := get_member_ptr_by_string(after, ^T, prev)
    if prev_of_after^ != nil {
      next_of_prev_of_after := get_member_ptr_by_string(prev_of_after^, ^T, next)
      next_of_prev_of_after^ = node
    }

    next_of_node := get_member_ptr_by_string(node, ^T, next)
    prev_of_node := get_member_ptr_by_string(node, ^T, prev)
    prev_of_node^ = prev_of_after^
    next_of_node^ = after

    prev_of_after^ = node
  }
}

dll_insert_before__first_last :: proc(first, last: ^^$T, after, node: ^T) {
  dll_insert_before__first_last_np(first, last, after, node, "next", "prev")
}

dll_insert_before__list_np :: proc(list: ^$T, after, node: ^$M, $next, $prev: string) {
  first := get_member_ptr_by_string(list, ^M, "first")
  last := get_member_ptr_by_string(list, ^M, "last")
  dll_insert_before__first_last_np(first, last, after, node, next, prev)
}

dll_insert_before__list :: proc(list: ^$T, after, node: ^$M) {
  dll_insert_before__list_np(list, after, node, "next", "prev")
}

////////////////////////////////////////
// Push back

dll_push_back__first_last_np :: proc(first, last: ^^$T, node: ^T, $next, $prev: string)
where intrinsics.type_has_field(T, next), intrinsics.type_has_field(T, prev) {
  dll_insert_after__first_last_np(first, last, last^, node, next, prev)
}

dll_push_back__first_last :: proc(first, last: ^^$T, node: ^T) {
  dll_push_back__first_last_np(first, last, node, "next", "prev")
}

dll_push_back__list_np :: proc(list: ^$T, node: ^$M, $next, $prev: string) {
  first := get_member_ptr_by_string(list, ^M, "first")
  last := get_member_ptr_by_string(list, ^M, "last")
  dll_push_back__first_last_np(first, last, node, next, prev)
}

dll_push_back__list :: proc(list: ^$T, node: ^$M) {
  dll_push_back__list_np(list, node, "next", "prev")
}

////////////////////////////////////////
// Push front

dll_push_front__first_last_np :: proc(first, last: ^^$T, node: ^T, $next, $prev: string)
where intrinsics.type_has_field(T, next), intrinsics.type_has_field(T, prev) {
  dll_insert_before__first_last_np(first, last, first^, node, next, prev)
}

dll_push_front__first_last :: proc(first, last: ^^$T, node: ^T) {
  dll_push_front__first_last_np(first, last, node, "next", "prev")
}

dll_push_front__list_np :: proc(list: ^$T, node: ^$M, $next, $prev: string) {
  first := get_member_ptr_by_string(list, ^M, "first")
  last := get_member_ptr_by_string(list, ^M, "last")
  dll_push_front__first_last_np(first, last, node, next, prev)
}

dll_push_front__list :: proc(list: ^$T, node: ^$M) {
  dll_push_front__list_np(list, node, "next", "prev")
}

////////////////////////////////////////
// Removal

dll_remove__first_last_np ::proc(first, last: ^^$T, node: ^T, $next, $prev: string)
where intrinsics.type_has_field(T, next), intrinsics.type_has_field(T, prev) {
  assert(first^ != nil)
  assert(last^ != nil)
  assert(node != nil)

  prev_of_node := get_member_ptr_by_string(node, ^T, prev)
  next_of_node := get_member_ptr_by_string(node, ^T, next)

  if node == first^ {
    first^ = next_of_node^
  }

  if node == last^ {
    last^ = prev_of_node^
  }

  if prev_of_node^ != nil {
    next_of_prev_of_node := get_member_ptr_by_string(prev_of_node^, ^T, next)
    next_of_prev_of_node^ = next_of_node^
  }

  if next_of_node^ != nil {
    prev_of_next_of_node := get_member_ptr_by_string(next_of_node^, ^T, prev)
    prev_of_next_of_node^ = prev_of_node^
  }
}

dll_remove__first_last ::proc(first, last: ^^$T, node: ^T) {
  dll_remove__first_last_np(first, last, node, "next", "prev")
}

dll_remove__list_np ::proc(list: ^$T, node: ^$M, $next, $prev: string) {
  first := get_member_ptr_by_string(list, ^M, "first")
  last := get_member_ptr_by_string(list, ^M, "last")
  dll_remove__first_last_np(first, last, node, next, prev)
}

dll_remove__list ::proc(list: ^$T, node: ^$M) {
  dll_remove__list_np(list, node, "next", "prev")
}

//////////////////////////////////////////////////////////////////////
// Singly-Linked-Lists (SLL) for stacks
//////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Push front

sll_stack_push_front__n :: proc(first: ^^$T, node: ^T, $next: string)
where intrinsics.type_has_field(T, next) {
  if first^ == nil {
    first^ = node
  } else {
    next_of_node := get_member_ptr_by_string(node, ^T, next)
    next_of_node^ = first^
    first^ = node
  }
}

sll_stack_push_front :: proc(first: ^^$T, node: ^T) {
  sll_stack_push_front__n(first, node, "next")
}

////////////////////////////////////////
// Pop front

sll_stack_pop_front__n :: proc(first: ^^$T, $next: string) -> ^T
where intrinsics.type_has_field(T, next) {
  assert(first != nil)
  assert(first^ != nil)
  result := first^
  next_of_first := get_member_ptr_by_string(first^, ^T, next)
  first^ = next_of_first^
  return result
}

sll_stack_pop_front :: proc(first: ^^$T) -> ^T {
  result := sll_stack_pop_front__n(first, "next")
  return result
}

//////////////////////////////////////////////////////////////////////
// Singly-Linked-Lists (SLL) for queues
//////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Push back

sll_queue_push_back__n :: proc(first, last: ^^$T, node: ^T, $next: string) {
  if first^ == nil {
    first^ = node
  } else {
    next_of_last := get_member_ptr_by_string(last^, ^T, next)
    next_of_last^ = node
  }

  last^ = node
}

sll_queue_push_back :: proc(first, last: ^^$T, node: ^T) {
  sll_queue_push_back__n(first, last, node, "next")
}

////////////////////////////////////////
// Pop front

sll_queue_pop_front__n :: proc(first, last: ^^$T, $next: string) -> ^T
where intrinsics.type_has_field(T, next) {
  assert(first != nil)
  assert(first^ != nil)
  result := first^
  next_of_first := get_member_ptr_by_string(first^, ^T, next)
  first^ = next_of_first^
  return result
}

sll_queue_pop_front :: proc(first, last: ^^$T) -> ^T {
  result := sll_queue_pop_front__n(first, last, "next")
  return result
}

dll_insert_after :: proc{dll_insert_after__list, dll_insert_after__list_np, dll_insert_after__first_last, dll_insert_after__first_last_np}
dll_insert_before :: proc{dll_insert_before__list, dll_insert_before__list_np, dll_insert_before__first_last, dll_insert_before__first_last_np}
dll_push_back :: proc{dll_push_back__list, dll_push_back__list_np, dll_push_back__first_last, dll_push_back__first_last_np}
dll_push_front :: proc{dll_push_front__list, dll_push_front__list_np, dll_push_front__first_last, dll_push_front__first_last_np}
dll_remove :: proc{dll_remove__list, dll_remove__list_np, dll_remove__first_last, dll_remove__first_last_np}

stack_push :: proc{sll_stack_push_front, sll_stack_push_front__n}
stack_pop :: proc{sll_stack_pop_front, sll_stack_pop_front__n}

queue_push :: proc{sll_queue_push_back, sll_queue_push_back__n}
queue_pop :: proc{sll_queue_pop_front, sll_queue_pop_front__n}

import "core:testing"
@(test)
lists_test :: proc(_: ^testing.T) {

  { // DLL test with list-variant of procedures
    DLL_Node :: struct {
      next: ^DLL_Node,
      prev: ^DLL_Node,
      v: u64,
    }

    DLL_List :: struct {
      first: ^DLL_Node,
      last: ^DLL_Node,
    }

    list: DLL_List

    // n0
    n0 := new(DLL_Node)
    n0.v = 4
    dll_push_back(&list, n0)
    assert(n0.prev == nil && n0.next == nil)
    assert(list.first == n0 && list.last == n0)

    // n1 <-> n0
    n1 := new(DLL_Node)
    n1.v = 3
    dll_push_front(&list, n1)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == nil)
    assert(list.first == n1 && list.last == n0)

    // n1 <-> n0 <-> n2
    n2 := new(DLL_Node)
    n2.v = 2
    dll_insert_after(&list, n0, n2)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == n2 && n2.prev == n0 && n2.next == nil)
    assert(list.first == n1 && list.last == n2)

    // n1 <-> n0 <-> n3 <-> n2
    n3 := new(DLL_Node)
    n3.v = 2
    dll_insert_before(&list, n2, n3)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == n3 && n3.prev == n0 && n3.next == n2 && n2.prev == n3 && n2.next == nil)
    assert(list.first == n1 && list.last == n2)

    // n1 <-> n0 <-> n2
    dll_remove(&list, n3)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == n2 && n2.prev == n0 && n2.next == nil)
    assert(list.first == n1 && list.last == n2)

    // n1 <-> n0
    dll_remove(&list, n2)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == nil)
    assert(list.first == n1 && list.last == n0)

    // n0
    dll_remove(&list, n1)
    assert(n0.prev == nil && n0.next == nil)
    assert(list.first == n0 && list.last == n0)
  }

  { // DLL test of procedures with first-last
    DLL_Node :: struct {
      next: ^DLL_Node,
      prev: ^DLL_Node,
      v: u64,
    }

    first: ^DLL_Node
    last: ^DLL_Node

    // n0
    n0 := new(DLL_Node)
    n0.v = 4
    dll_push_back(&first, &last, n0)
    assert(n0.prev == nil && n0.next == nil)
    assert(first == n0 && last == n0)

    // n1 <-> n0
    n1 := new(DLL_Node)
    n1.v = 3
    dll_push_front(&first, &last, n1)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == nil)
    assert(first == n1 && last == n0)

    // n1 <-> n0 <-> n2
    n2 := new(DLL_Node)
    n2.v = 2
    dll_insert_after(&first, &last, n0, n2)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == n2 && n2.prev == n0 && n2.next == nil)
    assert(first == n1 && last == n2)

    // n1 <-> n0 <-> n3 <-> n2
    n3 := new(DLL_Node)
    n3.v = 2
    dll_insert_before(&first, &last, n2, n3)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == n3 && n3.prev == n0 && n3.next == n2 && n2.prev == n3 && n2.next == nil)
    assert(first == n1 && last == n2)

    // n1 <-> n0 <-> n2
    dll_remove(&first, &last, n3)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == n2 && n2.prev == n0 && n2.next == nil)
    assert(first == n1 && last == n2)

    // n1 <-> n0
    dll_remove(&first, &last, n2)
    assert(n1.prev == nil && n1.next == n0 && n0.prev == n1 && n0.next == nil)
    assert(first == n1 && last == n0)

    // n0
    dll_remove(&first, &last, n1)
    assert(n0.prev == nil && n0.next == nil)
    assert(first == n0 && last == n0)
  }

  { // DLL test of procedures with first-last and named 'next' and 'prev'.
    DLL_Node :: struct {
      hash_next: ^DLL_Node,
      hash_prev: ^DLL_Node,
      v: u64,
    }

    first: ^DLL_Node
    last: ^DLL_Node

    // n0
    n0 := new(DLL_Node)
    n0.v = 4
    dll_push_back(&first, &last, n0, "hash_next", "hash_prev")
    assert(n0.hash_prev == nil && n0.hash_next == nil)
    assert(first == n0 && last == n0)

    // n1 <-> n0
    n1 := new(DLL_Node)
    n1.v = 3
    dll_push_front(&first, &last, n1, "hash_next", "hash_prev")
    assert(n1.hash_prev == nil && n1.hash_next == n0 && n0.hash_prev == n1 && n0.hash_next == nil)
    assert(first == n1 && last == n0)

    // n1 <-> n0 <-> n2
    n2 := new(DLL_Node)
    n2.v = 2
    dll_insert_after(&first, &last, n0, n2, "hash_next", "hash_prev")
    assert(n1.hash_prev == nil && n1.hash_next == n0 && n0.hash_prev == n1 && n0.hash_next == n2 && n2.hash_prev == n0 && n2.hash_next == nil)
    assert(first == n1 && last == n2)

    // n1 <-> n0 <-> n3 <-> n2
    n3 := new(DLL_Node)
    n3.v = 2
    dll_insert_before(&first, &last, n2, n3, "hash_next", "hash_prev")
    assert(n1.hash_prev == nil && n1.hash_next == n0 && n0.hash_prev == n1 && n0.hash_next == n3 && n3.hash_prev == n0 && n3.hash_next == n2 && n2.hash_prev == n3 && n2.hash_next == nil)
    assert(first == n1 && last == n2)

    // n1 <-> n0 <-> n2
    dll_remove(&first, &last, n3, "hash_next", "hash_prev")
    assert(n1.hash_prev == nil && n1.hash_next == n0 && n0.hash_prev == n1 && n0.hash_next == n2 && n2.hash_prev == n0 && n2.hash_next == nil)
    assert(first == n1 && last == n2)

    // n1 <-> n0
    dll_remove(&first, &last, n2, "hash_next", "hash_prev")
    assert(n1.hash_prev == nil && n1.hash_next == n0 && n0.hash_prev == n1 && n0.hash_next == nil)
    assert(first == n1 && last == n0)

    // n0
    dll_remove(&first, &last, n1, "hash_next", "hash_prev")
    assert(n0.hash_prev == nil && n0.hash_next == nil)
    assert(first == n0 && last == n0)
  }

  // The stack and the queue procedures also have variant for naming the 'next' members. stack_push(&stack_top, n, "hash_next"), stack_pop(&stack_top, "hash_next") and so on.

  { // Stack test
    Stack_Node :: struct {
      next: ^Stack_Node,
      v: u64,
    }

    stack_top: ^Stack_Node

    // n0
    n0 := new(Stack_Node)
    n0.v = 1
    stack_push(&stack_top, n0)

    assert(stack_top == n0)

    // n1 -> n0
    n1 := new(Stack_Node)
    n1.v = 2
    stack_push(&stack_top, n1)
    assert(stack_top == n1 && n1.next == n0)


    // n0
    top := stack_pop(&stack_top)
    assert(top == n1 && stack_top == n0)
  }

  { // Queue test
    Queue_Node :: struct {
      next: ^Queue_Node,
      v: u64,
    }

    queue_first: ^Queue_Node
    queue_last: ^Queue_Node

    // n0
    n0 := new(Queue_Node)
    n0.v = 1
    queue_push(&queue_first, &queue_last, n0)
    assert(queue_first == n0 && queue_last == n0)

    // n0 -> n1
    n1 := new(Queue_Node)
    n1.v = 1
    queue_push(&queue_first, &queue_last, n1)
    assert(queue_first == n0 && queue_last == n1)
    assert(n0.next == n1 && n1.next == nil)

    // n0 -> n1 -> n2
    n2 := new(Queue_Node)
    n2.v = 1
    queue_push(&queue_first, &queue_last, n2)
    assert(queue_first == n0 && queue_last == n2)
    assert(n0.next == n1 && n1.next == n2 && n2.next == nil)

    // n1 -> n2
    n := queue_pop(&queue_first, &queue_last)
    assert(n == n0)
    assert(queue_first == n1 && queue_last == n2 && n1.next == n2)

    // n2
    n = queue_pop(&queue_first, &queue_last)
    assert(n == n1)
    assert(queue_first == n2 && queue_last == n2 && n2.next == nil)
  }

  free_all(context.allocator)
}