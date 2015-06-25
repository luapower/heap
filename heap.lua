
--Priority queue implemented as a binary heap.
--Written by Cosmin Apreutesei. Public Domain.

if not ... then require'heap_test'; return end

--heap algorithm working over abstract API that counts from one.

local assert, floor = assert, math.floor

local function heap(add, remove, rootval, swap, length, cmp)

	local function push(val)
		add(val)
		local child = length()
		local parent = floor(child / 2)
		while child > 1 and cmp(child, parent) do
			swap(child, parent)
			child = parent
			parent = floor(child / 2)
		end
	end

	local function pop()
		if length() < 2 then
			local val = rootval()
			remove()
			return val
		end
		local val = rootval()
		local root, last = 1, length()
		swap(root, last)
		remove()
		last = last - 1
		if last > 1 then --move root back to its place
			local child = root * 2
			while child <= last do
				if child + 1 <= last and cmp(child + 1, child) then
					child = child + 1
				end
				if cmp(child, root) then
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
	assert(h.size >= 2, 'size too small')
	assert(h.ctype, 'ctype expected')
	local ctype = ffi.typeof(h.ctype)
	h.data = h.data or ffi.new(ffi.typeof('$[?]', ctype), h.size)
	local t, n, maxn = h.data, h.length or 0, h.size-1
	local function add(v) assert(n < maxn, 'buffer overflow'); n=n+1; t[n]=v; end
	local function rem() assert(n > 0, 'buffer underflow'); n=n-1; end
	local function rootval() return ffi.new(ctype, t[1]) end
	local function swap(i, j) t[0]=t[i]; t[i]=t[j]; t[j]=t[0] end
	local function length() return n end
	local cmp = h.cmp and
		function(i, j) return h.cmp(t[i], t[j]) end or
		function(i, j) return t[i] < t[j] end
	local push, pop = heap(add, rem, rootval, swap, length, cmp)
	function h:push(val) push(val) end
	function h:pop() return pop(pop) end
	function h:peek() return rootval() end
	h.length = length
	return h
end

--value heap working over a Lua table

local function valueheap(h)
	h = h or {}
	local t, n = h, 0
	local function add(v) assert(v ~= nil, 'invalid value'); n=n+1; t[n]=v; end
	local function rem() assert(n > 0, 'buffer underflow'); t[n]=nil; n=n-1 end
	local function rootval() return t[1] end
	local function swap(i, j) t[i], t[j] = t[j], t[i] end
	local function length() return n end
	local cmp = h.cmp and
		function(i, j) return h.cmp(t[i], t[j]) end or
		function(i, j) return t[i] < t[j] end
	local push, pop = heap(add, rem, rootval, swap, length, cmp)
	function h:push(val) push(val) end
	function h:pop() return pop(pop) end
	function h:peek() return rootval() end
	h.length = length
	return h
end

return {
	heap = heap,
	valueheap = valueheap,
	cdataheap = cdataheap,
}
