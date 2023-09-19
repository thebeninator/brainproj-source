local Hemisphere = Class:extend("Hemisphere")  

_G.Hemispheres = {}

function Hemisphere:init(x, y) 
	self.name = ""
	self.internal = ""
	self.image = nil 
	self.timer = Timer.new() 
	self.x = x 
	self.y = y 
	self.w = 158
	self.h = 325
	self.visible = true
	self.entered = false 	
	self.infoCard = nil
end

function Hemisphere:onInteract()
	--Signal.emit("hemisphere-entered", self.internal)
end

function Hemisphere:enter() 
	_G.ActiveInfocard = nil 
	self.visible = true
	local _, winH = love.graphics.getDimensions()
	local brainHeight = math.floor(winH / 2 - (325 / 2))
	self.timer:tween(3, self, {y = brainHeight}, "in-out-quad", function() 
		self.entered = false
		self.interactPoint.visible = true 
		self:float(brainHeight)
	end)
end

function Hemisphere:exit() 
	_G.ActiveInfocard = nil 

	for _, v in pairs(Hemispheres) do  
		v.timer:clear() 
		v.interactPoint.visible = false 
		local xOffset = 5
		
		if v.internal == "RIGHT" then xOffset = -xOffset end
		
		Timer.tween(1, v, {x = v.x - xOffset}, "in-out-quad") 
		
		Timer.tween(5, v, {y = 1200}, "in-out-quad", function()
			v.entered = true
			v.visible = false 
		end) 
	end
end

function Hemisphere:draw() 
	if not self.visible then return end
	
	self.infoCard:draw()

	brainGlow(function()
		love.graphics.draw(self.image, self.x, self.y)
	end)
end

function Hemisphere:update(dt) 
	if not self.visible then return end
	
	self.infoCard:update(dt)
	self.timer:update(dt)
end

function Hemisphere:float(resting) 		
	self.timer:script(function(wait) 
		local t = 0.85
					
		while true do
			if not self.entered then
				self.timer:tween(t, self, {y = resting - 10}, "in-out-quad")
				wait(t) 
				self.timer:tween(t, self, {y = resting}, "in-out-quad") 
				wait(t * 1.5)
			end
		end
	end)	
end

return Hemisphere