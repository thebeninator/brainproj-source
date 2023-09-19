local Button = Class:extend("Button")

_G.Buttons = {} 

function Button:init(parent, x, y, image) 
	self.parent = parent
	self.x = x
	self.y = y
	self.relx = x + parent.x
	self.rely = y + parent.y 
	self.image = image 
	self.lit = false
	
	table.insert(Buttons, self) 
end

function Button:draw()
	if not self.parent.visible then return end 

	love.graphics.draw(self.image, self.relx, self.rely) 
end

function Button:update() 
	if not self.parent.visible then return end 
	
	local mx, my = love.mouse.getPosition()	
	local w, h = self.image:getWidth(), self.image:getHeight()
	local rx, ry = self.relx, self.rely
	local rw, rh = rx + w, ry + h 
	
	if  mx >= rx and 
		my >= ry and 
		mx <= rw and 
		my <= rh 
	then
		self.lit = true 
	else
		self.lit = false
	end
	
	self.relx = self.x + self.parent.x 
	self.rely = self.y + self.parent.y 
end

Signal.register("m1-pressed", function() 	
	for _, button in pairs(_G.Buttons) do 
		if button.lit then
			Signal.emit("hemisphere-entered", button.parent.parent.internal)
		end
	end
end) 

return Button