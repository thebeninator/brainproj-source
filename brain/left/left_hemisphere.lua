local LeftHemisphere = Hemisphere:extend("LeftHemisphere") 

function LeftHemisphere:init(x, y) 
	self.name = "Left Hemisphere"
	self.internal = "LEFT" 
	self.components = {}
	self.image = Assets.Brain_Left_Hemisphere
	self.interactPoint = InteractionPoint(self, self.x - 60, self.y + 40, true, self.w / 2 + self.x, self.y + self.h / 2) 
	self.infoCard = Infocard(self, -207, 170, Assets.LeftHemiInfocard)
	
	self.infoCard:addWidget(Button, 35, 335, Assets.InspectButton)
	
	Hemispheres["LEFT"] = self 
end


function LeftHemisphere:onInteract()
	--Signal.emit("hemisphere-entered", self.internal)
	self.infoCard:enter(50, 170)
end

return LeftHemisphere