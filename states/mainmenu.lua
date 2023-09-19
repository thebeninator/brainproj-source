local this = {} 
local winW, winH = love.graphics.getDimensions()

local labels = {
	titleX = -350, -- 20
	authorX = -350, -- 24
	playX = -350 -- 24
}

local brainTube = {
	y = -300 -- winH / 2 - 294 / 2
} 

local camZoom = {1}

local loadDone = false
local loadingNext = false 
local camera = nil

function this:enter()
	camera = Camera(winW/2, winH/2) 
	camera.smoother = Camera.smooth.damped(25)

	Timer.tween(3, brainTube, {y = winH / 2 - 294 / 2}, "in-quint", function() 
		loadDone = true 
		
		local ox, oy = camera:position()
		Timer.during(0.3, 
			function()
				camera:lookAt(ox + math.random(-3, 3), oy + math.random(-3, 3))
			end, 
			
			function()
				camera:lookAt(ox, oy)
			end
		)
		
		Timer.tween(1, labels, {playX = 24}, "out-cubic")
	end)
	
	Timer.tween(1, labels, {titleX = 20, authorX = 24}, "out-cubic")
end

function this:exit() 
	Timer.clear()
end

function this:update(dt)
	Assets.BRAIN_TUBE_ANIMATED:update(dt)
	Timer.update(dt)
	
	if loadingNext then
		camera:lockPosition(winW / 2, winH / 2 + 15)
		camera:zoomTo(camZoom[1])
	end
end

function this:keypressed(key)
    if key == 'up' or key == "w" and loadDone and not loadingNext then
		loadingNext = true 
		
		Timer.tween(6, camZoom, {80}, "in-quad", function()
		    Gamestate.switch(BRAIN_VIEW)
		end) 
	end
end

function this:draw()
	brainTubeRays(function()
		camera:attach()
		Assets.BRAIN_TUBE_ANIMATED:draw(Assets.BrainTubeAnimated, winW / 2 - 224 / 2 , brainTube.y)
		camera:detach()
	end)
	
	interactButtonGlow(function()
		camera:attach()
		love.graphics.print("Press [UP ARROW] or [W] to enter", labels.playX, winH / 3 + 140) 
		camera:detach()
	end)
	
	camera:attach()	
	
	love.graphics.print("The Human Brain", Assets.title, labels.titleX, winH / 3 + 35) 
	love.graphics.print("Coding & artwork by Benjamin Nguyen", labels.authorX, winH / 3 + 70) 
	love.graphics.draw(Assets.BrainTube2, winW / 2 - 224 / 2 , brainTube.y)
	
	camera:detach()
end


return this 
