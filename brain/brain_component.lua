local BrainComponent = Class:extend("BrainComponent")

function BrainComponent:init(parent, name, x, y, tx, ty, image, captionDown)
	self.parent = parent
	self.name = name
	self.x = x 
	self.y = y
	self.w = 330
	self.h = 301
	self.interactPoint = InteractionPoint(self, x, y, true, tx, ty, captionDown) 
	self.infoCard = Infocard(self, 1024, 170, image) 
	self.visible = false
end


function BrainComponent:draw()
	if not self.visible then return end 

	self.infoCard:draw()
end

function BrainComponent:update(dt)
	self.visible = self.parent.visible and self.parent.finishedEntering
	if not self.visible then return end 
	
	self.infoCard:update(dt)
end

function BrainComponent:onInteract() 
	self.infoCard:enter(1024 - 207 - 50, 170)
end

return BrainComponent