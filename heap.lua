
--Priority queue implemented as a binary heap.
--Written by Cosmin Apreutesei. Public Domain.

--heap algorithm working over abstract API that counts from one.

local assert, floor = assert, math.floor

local function heap(add, rem, get, set, length, cmp)

	local function swap(i1, i2)
		local v1 = get(i1)
		set(i1, get(i2))
		set(i2, v1)
	end

	cmp = cmp or function(a, b) return a < b end

	local function less(i1, i2)
		return cmp(get(i1), get(i2))
	end

	local function push(val)
		add(val)
		local child = length()
		local parent = floor(child / 2)
		while child > 1 and less(child, parent) do
			swap(child, parent)
			child = parent
			parent = floor(child / 2)
		end
	end

	local function pop()
		if length() < 2 then
			return rem()
		end
		local val = get(1)
		set(1, rem()) --replace root with last value
		local root = 1
		local last = length()
		if last > 1 then --move root back to its place
			local child = root * 2
			while child <= last do
				if child + 1 <= last and less(child + 1, child) then
					child = child + 1
				end
				if less(child, root) then
					swap(root, child)
					root = child
				else
					break
				end
				child = root * 2
			end
		end
		return val
	end

	return push, pop
end

--cdata heap working over a cdata array

local ffi

local function cdataheap(h)
	ffi = ffi or require'ffi'
	assert(h and h.size, 'size expected')
	assert(h.size > 1, 'invalid size')
	assert(h.data or h.ctype, 'data or ctype expected')
	h.data = h.data or ffi.new(ffi.typeof('$[?]', ffi.typeof(h.ctype)), h.size)
	local t, n, maxn = h.data, (h.length or 0)-1, h.size-1
	local function add(v) assert(n < maxn, 'buffer overflow'); n=n+1; t[n]=v end
	local function rem() assert(n >= 0, 'buffer underflow'); local v=t[n]; n=n-1; return v end
	local function get(i) return t[i-1] end
	local function set(i, v) t[i-1]=v end
	local function length() return n end
	local push, pop = heap(add, rem, get, set, length, h.cmp)
	function h:push(val) push(val) end
	function h:pop() return pop(pop) end
	function h:peek() return get(0) end
	h.length = length
	return h
end

--value heap working over a Lua table

local function valueheap(h)
	h = h or {}
	local t, tins, trem = h, table.insert, table.remove
	local function add(v) assert(v ~= nil, 'invalid value'); tins(t, v) end
	local function rem() assert(#t > 0, 'buffer underflow'); return trem(t) end
	local function get(i) return t[i] end
	local function set(i, v) t[i]=v end
	local function length() return #t end
	local push, pop = heap(add, rem, get, set, length, h.cmp)
	function h:push(val) push(val) end
	function h:pop() return pop(pop) end
	function h:peek() return get(1) end
	h.length = length
	return h
end

--test

if not ... then
	local size = 100000
	local function test(h)
		for i = 1, size do
		    h:push(math.random(1, size))
		end
		local v0 = h:pop()
		for i=2,size do
			local v = h:pop()
			assert(v >= v0)
			v0 = v
		end
	end
	test(valueheap())
	test(cdataheap{ctype = 'int', size = size})
end

return {
	heap = heap,
	valueheap = valueheap,
	cdataheap = cdataheap,
}
