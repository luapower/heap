local heap = require'heap'

local function bench(h, size)
	for i=1,size do
	    h:push(math.random(1, size))
	end
	local v0 = h:pop()
	for i=2,size do
		local v = h:pop()
		assert(v >= v0)
		v0 = v
	end
end

local function example1()
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
end

local function example2()
	local h = heap.valueheap{cmp = function(a, b)
	      return a.priority < b.priority
	   end}
	h:push{priority = 20, etc = 'bar'}
	h:push{priority = 10, etc = 'foo'}
	assert(h:pop().priority == 10)
	assert(h:pop().priority == 20)
end

bench(heap.valueheap{size=100000}, 100000)
bench(heap.cdataheap{ctype = 'int', size = 100000+1}, 100000)
example1()
example2()
