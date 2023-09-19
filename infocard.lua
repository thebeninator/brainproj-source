local Infocard = Class:extend("Infocard") 

function Infocard:init(parent, x, y, image) 
	self.parent = parent
	self.x = x 
	self.y = y
	self.sx = x 
	self.sy = y
	self.visible = false
	self.image = image 
	self.widgets = {} 
	self.timer = Timer.new()
end

function Infocard:addWidget(widget, ...)
	local w = widget(self, ...)
	table.insert(self.widgets, w) 
end

function Infocard:draw() 
	if not self.visible then return end 
	
	love.graphics.draw(self.image, self.x, self.y) 
	
	for _, widget in pairs(self.widgets) do 
		widget:draw()
	end
end

function Infocard:update(dt)
	if not self.visible then return end 
	self.timer:update(dt) 
	
	for _, widget in pairs(self.widgets) do 
		widget:update()
	end
end

function Infocard:enter(tx, ty) 
	if _G.ActiveInfocard then
		_G.ActiveInfocard:exit()
		_G.ActiveInfocard = nil 
	end

	if not self.visible then
		self.visible = true 
		self.timer:tween(1.5, self, {x = tx, y = ty}, "in-out-quad")
		_G.ActiveInfocard = self 
	end
end

function Infocard:exit()  
	self.timer:tween(1, self, {x = self.sx, y = self.sy}, "in-out-quad", function()
		self.visible = false 
	end)
end




return Infocard