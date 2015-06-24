---
tagline: priority queues
---

## `local heap = require'heap'`

Priority queue implemented as a binary heap.

## API

--------------------------------------------------------- ----------------------------------------------------
__algorithm__
heap.heap(add, rem, get, set, less, length) -> push, pop  create a heap from an abstract array API
__cdata heap__
heap.cdataheap{cmp=f, size=n, ctype=ct|data=cdata} -> h   create a fixed-sized cdata-based heap
__value heap__
heap.valueheap{cmp=f[, elem1, ...]} -> h                  create a heap for arbitrary Lua values (except nil)
__common API__
h:push(val)                                               push a value
h:pop() -> val                                            pop highest value
h:peek() -> val                                           get highest value without popping it
h:length() -> n                                           number of elements in heap
--------------------------------------------------------- ----------------------------------------------------

## API Notes

  * pushing and popping is O(log(n)).
  * a cdata heap can store size-1 elements.
  * trying to push nil into a value heap raises an error.
  * values with the same priority are popped in random order.

## Example:

	local h = heap.valueheap{cmp = function(a, b)
			return a.priority < b.priority
		end}
	h:push{priority = 20, etc = 'bar'}
	h:push{priority = 10, etc = 'foo'}
	assert(h:pop().priority == 10)
