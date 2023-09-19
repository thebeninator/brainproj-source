--[[

Copyright (c) 2023 Benjamin Nguyen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--]]

local Class = {}
Class._type = "Class" 
Class.__index = Class
Class.__call = function(self, ...) 
	local o = setmetatable({}, self) 
	
	if o._super and o._super.init then
		o._super.init(o, ...)
	end
	
	if o.init then o:init(...) end 
	
	return o 
end

function Class:extend(type) 
	local o = {_type = type, _super = self}
	o.__index = o
	o.__call = self.__call 
	
	setmetatable(o, self) 
	
	return o 
end

function Class:typeOf(type)
	return self._type == type
end

function Class:type() 
	return self._type 
end

function Class:derivedFrom(type) 
	return self._super._type == type 
end

function Class:super() 
	return self._super
end

return Class 