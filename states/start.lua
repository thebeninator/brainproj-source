local this = {}
local winW, winH = love.graphics.getDimensions()

function this:draw() 
	brainGlow(function()
		love.graphics.draw(Assets.PlayButton, winW/2 - 32, winH/2 - 32)
	end)
end

function this:mousepressed(x, y, btn) 
	if btn == 1 then
		local radius = 32
		local dist = math.sqrt((winW/2 - x)^2 + (winH/2 - y)^2)
	
		if dist < radius then
			Gamestate.switch(MAIN_MENU)
		end
	end
end

return this 