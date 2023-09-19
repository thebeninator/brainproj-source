local HemisphereInspect = Class:extend("HemisphereInspect") 

function HemisphereInspect:init(x, y, image) 
	self.x = x
	self.y = y 
	self.w = 330
	self.h = 301
	self.components = {} 
	self.image = image
	self.visible = false 
	self.timer = Timer.new() 
	self.exiting = false 
	self.finishedEntering = false 
end

function HemisphereInspect:draw()
	if not self.visible then return end 
	
	for _, v in pairs(self.components) do 
		v:draw()
	end

	brainGlow(function() 
		love.graphics.draw(self.image, self.x, self.y) 
	end)
end

function HemisphereInspect:update(dt) 
	if not self.visible then return end 
	
	for _, v in pairs(self.components) do 
		v:update(dt)
	end
	
	self.timer:update(dt)
end

function HemisphereInspect:enter(tx, ty) 
	self.visible = true 
	self.exiting = false 
	_G.ActiveInfocard = nil 

	self.timer:tween(3, self, {x = tx, y = ty}, "in-out-quad", function() self:float(); self.finishedEntering = true end)
end

function HemisphereInspect:exit() 
	for _, v in pairs(self.components) do 
		v.infoCard.visible = false 
	end 

	self.exiting = true 
	self.finishedEntering = false
	self.timer:clear()
	_G.ActiveInfocard = nil 

	Timer.tween(5, self, {y = 1200}, "in-out-quad", function()
		self.visible = false 
	end) 
end

function HemisphereInspect:float() 		
	local winW, winH = love.graphics.getDimensions()
	local brainHeight = math.floor(winH / 2 - (325 / 2))

	self.timer:script(function(wait) 
		local t = 0.85
					
		while true do
			if not self.exiting then
				self.timer:tween(t, self, {y = brainHeight - 10}, "in-out-quad")
				wait(t) 
				self.timer:tween(t, self, {y = brainHeight}, "in-out-quad") 
				wait(t * 1.5)
			end
		end
	end)	
end


return HemisphereInspect