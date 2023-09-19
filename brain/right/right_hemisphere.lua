local RightHemisphere = Hemisphere:extend("RightHemisphere") 

function RightHemisphere:init(x, y) 
	self.name = "Right Hemisphere"
	self.internal = "RIGHT" 
	self.components = {}
	self.image = Assets.Brain_Right_Hemisphere
	self.interactPoint = InteractionPoint(self, self.x + 158 - 32 + 60, self.y + 40, true, self.w / 2 + self.x, self.y + self.h / 2) 
	self.infoCard = Infocard(self, 1024, 170, Assets.RightHemiInfocard)

	self.infoCard:addWidget(Button, 35, 335, Assets.InspectButton)

	Hemispheres["RIGHT"] = self 
end

function RightHemisphere:onInteract()
	--Signal.emit("hemisphere-entered", self.internal)
	self.infoCard:enter(1024 - 207 - 50, 170)
end

return RightHemisphere