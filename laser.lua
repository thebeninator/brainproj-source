local Laser = Class:extend("Laser") 

function Laser:init()
	self.x = 0 
	self.y = 0 
	self.sx = 0
	self.sy = 0
	self.tx = 0
	self.ty = 0
	self.timer = Timer.new() 
	self.firing = false 
end

function Laser:draw() 
	if not self.firing then return end 
	
	laserGlow(function() 
		love.graphics.setLineWidth(3) 
		love.graphics.setColor(RGB(255, 0, 0))
		love.graphics.line(self.sx, self.sy, self.x, self.y)
		love.graphics.circle("fill", self.x, self.y, 6) 
	end)
end

function Laser:update(dt) 
	if not self.firing then return end 
	
	self.timer:update(dt) 
end 

function Laser:fire(x, y, tx, ty)	
	if self.firing then return end 
	
	self.firing = true
	
	self.x = x
	self.y = y
	self.sx = x 
	self.sy = y 
	self.tx = tx
	self.ty = ty 
	
	self.timer:tween(3, self, {x = tx, y = ty}, "in-linear", function()
		self.firing = false 
		self.timer:clear()
	end) 
end

return Laser 