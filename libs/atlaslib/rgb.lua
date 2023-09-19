local function rgb(r, g, b, a) 

	if a ~= nil then 
		return {r/255, g/255, b/255, a/255}
	end

	return {r/255, g/255, b/255}
end

return rgb 