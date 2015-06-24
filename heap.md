---
tagline: priority queues
---

## `local heap = require'heap'`

Priority queues implemented as binary heaps.

## API

-------------------------------- ----------------------------------------------------
`heap.heap(...) -> push, pop`    create a heap API from a stack API
`heap.cdataheap(h) -> h`         create a fixed-capacity cdata-based heap
`heap.valueheap([h]) -> h`       create a heap for Lua values
`h:push(val)`                    push a value
`h:pop() -> val`                 pop highest value
`h:peek() -> val`                get highest value without popping it
`h:length() -> n`                number of elements in heap
-------------------------------- ----------------------------------------------------

__NOTE__:

  * pushing and popping is O(log(n)).
  * a cdata heap can hold size-1 elements (element 0 is used for swapping).
  * trying to push nil into a value heap raises an error.
  * values that compare equally are popped in random order.

### `heap.heap(push, pop, rootval, len, cmp) -> push, pop`

Create a heap API from a stack API:

	push(v)              add a value to the top of the stack
	pop()                remove the value at the top of the stack
	rootval() -> v       get the root value (the value at index 1)
	swap(i, j)           swap two values (indices start at 1)
	len() -> n           number of elements in stack
   cmp(i, j) -> bool    compare elements

### `heap.cdataheap(h) -> h`

Create a cdata heap over table `h` which must contain:

  * `size`: heap capacity (required).
  * `ctype`: element type (required).
  * `data`, `length`: a pre-allocated heap (optional).
  * `cmp`: a comparison function (optional).

#### Example:

~~~{.lua}
local h = heap.cdataheap{
	size = 100,
	ctype = [[
		struct {
			int priority;
			int order;
		}
	]],
	cmp = function(a, b)
		if a.priority == b.priority then
			return a.order > b.order
		end
		return a.priority < b.priority
	end}
h:push{priority = 20, order = 1}
h:push{priority = 10, order = 2}
h:push{priority = 10, order = 3}
h:push{priority = 20, order = 4}
assert(h:pop().order == 3)
assert(h:pop().order == 2)
assert(h:pop().order == 4)
assert(h:pop().order == 1)
~~~

Note: the `order` field in this example is used to stabilize
the order in which elements with the same priority are popped.

### `heap.valueheap([h]) -> h`

Create a value heap from table `h`, which can contain:

  * `cmp`: a comparison function (optional).
  * a pre-allocated heap in the array part of the table (optional).

#### Example:

~~~{.lua}
local h = heap.valueheap{cmp = function(a, b)
		return a.priority < b.priority
	end}
h:push{priority = 20, etc = 'bar'}
h:push{priority = 10, etc = 'foo'}
assert(h:pop().priority == 10)
assert(h:pop().priority == 20)
~~~
