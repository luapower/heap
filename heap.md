---
tagline: priority queues
---

## `local heap = require'heap'`

Priority queue implemented as a binary heap. Binary heaps are arrays
for which t[i] <= t[2*i+1] and t[i] <= t[2*i+2] for all indices.

## API

------------------------- ----------------------------------------------------
heap([t]) -> h            create a heap
h:push(val)               push a value
h:pop() -> val            pop highest value
h:peek() -> val           get highest value without popping
h:length()                number of elements
------------------------- ----------------------------------------------------

The arg `t` is a pre-sorted binary heap array.
A comparison function for sorting elements can also be given as `t.cmp`:

	local h = heap{cmp = function(a, b)
			return a.priority < b.priority
		end}

	h:push{priority = 10, etc = 'foo'}
	h:push{priority = 20, etc = 'bar'}

Pushing and popping is O(log(n)).

Trying to push nil results in error.

Popping values with the same priority does not guarantee insert order.
For that, provide the elements with an insert counter and use a comparison
function that compares equal-priority elements against the counter.
