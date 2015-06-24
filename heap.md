---
tagline: priority queues
---

## `local heap = require'heap'`

Priority queues implemented as binary heaps.

## API

------------------------------ ----------------------------------------------------
heap.heap(...) -> push, pop    create a heap API from a stack API
heap.cdataheap(h) -> h         create a fixed-capacity cdata-based heap
heap.valueheap([h]) -> h       create a heap for Lua values
h:push(val)                    push a value
h:pop() -> val                 pop highest value
h:peek() -> val                get highest value without popping it
h:length() -> n                number of elements in heap
------------------------------ ----------------------------------------------------

## API Notes

  * pushing and popping is O(log(n)).
  * a cdata heap can store size-1 elements (the first element is not used).
  * trying to push nil into a value heap raises an error.
  * values with the same priority are popped in random order.

### `heap.heap(add, rem, get, set, len[, cmp]) -> push, pop`

Create a heap API from a stack API:

	add(v)         add a value to the end
	rem(v)         remove a failue from the end
	get(i) -> v    get value at index (first index is 1)
	set(i, v)      set value at index
	len() -> n     stack size
   cmp(v1, v2)    comparison function (optional)

### `heap.cdataheap(h) -> h`

Create a cdata heap. The arg `h` must contain:
	* `size`: heap capacity.
	* `ctype`: element type, or
	* `data`, `length`: the pre-allocated heap itself.
	* `cmp`: a comparison function (optional).

### `heap.valueheap([h]) -> h`

Create a value heap. The arg `h` can contain:
	* `cmp`: a comparison function (optional).
   * the pre-allocated heap itself, in the array part of the table.

## Example:

	local h = heap.valueheap{cmp = function(a, b)
			return a.priority < b.priority
		end}
	h:push{priority = 20, etc = 'bar'}
	h:push{priority = 10, etc = 'foo'}
	assert(h:pop().priority == 10)
