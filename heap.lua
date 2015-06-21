
--Priority queue implemented as a binary heap.
--Written by Cosmin Apreutesei. Public Domain.

local assert, floor, insert, remove =
	assert, math.floor, table.insert, table.remove

local function heapfactory(add, remove)

end

local heap = {}
heap.__index = heap

function heap:push(val)
	assert(val ~= nil, 'invalid value')
	local t = self.t
	self:_add(t, val)
	local child = self:length()
	local parent = floor(child / 2)
	while child > 1 and self.cmp(t[child], t[parent]) do
		t[child], t[parent] = t[parent], t[child]
		child = parent
		parent = floor(child / 2)
	end
end

function heap:pop()
	local t = self.t
	if self:length() < 2 then
		return self:_remove(t)
	end
	local root = 1
	local val = t[root]
	t[root] = self:_remove(t) --replace root with last value
	local size = self:length()
	if size > 1 then --move root back to its place
		local child = 2 * root
		while child <= size do
			if child + 1 <= size and self.cmp(t[child+1], t[child]) then
				child = child + 1
			end
			if self.cmp(t[child], t[root]) then
				t[root], t[child] = t[child], t[root]
				root = child
			else
				break
			end
			child = 2 * root
		end
	end
	return val
end

function heap:peek()
	return self.t[1]
end

--Lua value heap

local vheap = {push = heap.push, pop = heap.pop, peek = heap.peek}

function vheap:length() return #self.t end
function vheap:_add(t, val) insert(t, val) end
function vheap:_remove(t) remove(t) end

local function new_vheap(t, cmp)
	t = t or {}
	cmp = cmp or function(a, b) return a < b end
	local self = {t = t, cmp = cmp}
	return setmetatable(self, {__index = vheap})
end

--cdata heap

local dheap = {push = heap.push, pop = heap.pop, peek = heap.peek}

function dheap:_init(ctype, size)
	self._len = size
	self.t = ffi.new(ffi.typeof('$[?]', ffi.typeof(ctype)), size + 1)
end

function dheap:length()
	return self._len
end

function dheap:_add(t, val)
	self._len = self._len + 1
	t[self.len] = val
end

function dheap:_remove(t)
	self._len = self._len - 1
end



--unit test

if not ... then
	local h = new_vheap()
	for i = 1, 100000 do
	    h:push(math.random(1, 100000))
	end
	local t = {}
	repeat
		local n = h:pop()
		table.insert(t, n)
	until not n
	for i = 1, #t-1 do
		assert(t[i] <= t[i+1])
	end
end

return {
	valueheap = new_vheap,
}
