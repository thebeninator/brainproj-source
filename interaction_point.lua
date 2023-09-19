local InteractionPoint = Class:extend("InteractionPoint") 

_G.InteractionPoints = {} 
	
function InteractionPoint:init(parent, x, y, drawLine, tx, ty, captionDown) 
	self.parent = parent
	self.scale = 1
	self.imageUnlit = Assets.Interaction_Button_Unlit
	self.imageLit =  Assets.Interaction_Button_Lit
	self.lit = false  
	self.drawLine = drawLine
	self.x = x
	self.y = y
	self.tx = tx or 0 
	self.ty = ty or 0
	self.w = 32
	self.h = 32 
	self.centre = {x = self.x + self.w * self.scale / 2, y = self.y + self.h * self.scale / 2}
	self.visible = true
	self.captionDown = captionDown or false 
	self.caption = parent.name 

	table.insert(_G.InteractionPoints, self)
end
	
function InteractionPoint:update(dt) 	
end

function InteractionPoint:onHover() 
	if not self.visible then return end
	if not self.parent.visible then return end 

	local mx, my = love.mouse.getPosition()	
	local radius = self.w * self.scale / 2 
	local dist = math.sqrt((self.centre.x  - mx)^2 + (self.centre.y  - my)^2)
	
	if dist < radius then
		self.lit = true 
		return
	end
	
	self.lit = false 
end
	
function InteractionPoint:draw()
	if not self.visible then return end
	if not self.parent.visible then return end 

	interactButtonGlow(function() 
		local toDraw = self.imageUnlit
		local color = RGB(255, 255, 255)

		if self.lit then 
			toDraw = self.imageLit
			color = RGB(255, 249, 128)
			
			local yOffset = 20 
			
			if self.captionDown then yOffset = -20 * 2 end 
			
			love.graphics.print(self.parent.name, self.x - love.graphics.getFont():getWidth(self.parent.name) / 2 + 16, self.y - yOffset) 
		end
		
		if self.drawLine then 
			love.graphics.setColor(color)
			love.graphics.setLineWidth(2)
			love.graphics.line(self.centre.x, self.centre.y, self.tx, self.ty) 
		end
		
		love.graphics.draw(toDraw, self.x, self.y)
	end)
end

Signal.register("m1-pressed", function() 	
	for _, interactionButton in pairs(_G.InteractionPoints) do 
		if interactionButton.lit and interactionButton.visible then 
			interactionButton.parent:onInteract() 
		end
	end
end) 
	
return InteractionPoint 