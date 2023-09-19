local this = {} 

-- scene objects 
local LeftBrain = nil 
local RightBrain = nil
local LeftBrainInspect = nil
local RightBrainInspect = nil 

local camera = nil
local laser = Laser() 
_G.ActiveInfocard = nil 

local winW, winH = love.graphics.getDimensions()
local doneZooming = false
local camZoom = {1}
local brainHeight = 0 
local laserFired = false

local LeftHemisphere = require "brain.left.left_hemisphere" 
local RightHemisphere = require "brain.right.right_hemisphere" 

function this:init() 
	camZoom = {1.7}
end

Signal.register("hemisphere-entered", function(id)
	_G.ActiveInfocard:exit() 
	_G.ActiveInfocard = nil 
	
	local wait = 1
	
	if not laserFired then
		wait = 3.2 
		laser:fire(winW/2, 0, winW/2, 840)	
		laserFired = true 
	end
	
	Timer.after(wait, function()	
		LeftBrain:exit()
		RightBrain:exit()
		
		Timer.after(3, function() 
			if id == "LEFT" then
				LeftBrainInspect:enter(winW / 2 - 165, math.floor(winH / 2 - (325 / 2))) 
			end
			
			if id == "RIGHT" then
				RightBrainInspect:enter(winW / 2 - 165, math.floor(winH / 2 - (325 / 2))) 
			end
		end)
	end)
end) 

function this:enter() 
	camera = Camera(winW/2, winH/2, camZoom[1])
	
	brainHeight = math.floor(winH / 2 - (325 / 2))

	LeftBrain = LeftHemisphere(winW / 2 - (158), brainHeight)
	RightBrain = RightHemisphere(winW / 2, brainHeight)
	
	LeftBrainInspect = HemisphereInspect(winW / 2 - 165, 790, Assets.BrainLeftInspect) 
	
	LeftBrainInspect.components = {
		BrainComponent(LeftBrainInspect, "Frontal Lobe", 325, 195, 422, 286, Assets.FrontalLobeInfocard),
		BrainComponent(LeftBrainInspect, "Motor Cortex", 552, 155, 509, 265, Assets.MotorCortexInfocard),
		BrainComponent(LeftBrainInspect, "Sensory Cortex", 625, 194, 536, 276, Assets.SensorCortexInfocard),
		BrainComponent(LeftBrainInspect, "Parietal Lobe", 688, 273, 591, 300, Assets.ParietalLobeInfocard),
		BrainComponent(LeftBrainInspect, "Occipital Lobe", 728, 440, 638, 385, Assets.OccipitalLobeInfocard, true),
		BrainComponent(LeftBrainInspect, "Cerebellum", 644, 519, 578, 451, Assets.CerebellumInfocard, true),
		BrainComponent(LeftBrainInspect, "Brainstem", 472, 495, 533, 460, Assets.BrainstemInfocard, true),
		BrainComponent(LeftBrainInspect, "Temporal Lobe", 397, 469, 481, 379, Assets.TemporalLobeInfocard, true),
		BrainComponent(LeftBrainInspect, "Broca's Area", 320, 412, 424, 335, Assets.BrocasInfocard, true),
		BrainComponent(LeftBrainInspect, "Wernicke's Area", 728, 375, 580, 359, Assets.WernickesInfocard)
	}
	
	RightBrainInspect = HemisphereInspect(winW / 2 - 165, 790, Assets.BrainRightInspect) 
	RightBrainInspect.components = {
		BrainComponent(RightBrainInspect, "Frontal Lobe", 325, 195, 422, 286, Assets.FrontalLobeInfocard),
		BrainComponent(RightBrainInspect, "Motor Cortex", 552, 155, 509, 265, Assets.MotorCortexInfocard),
		BrainComponent(RightBrainInspect, "Sensory Cortex", 625, 194, 536, 276, Assets.SensorCortexInfocard),
		BrainComponent(RightBrainInspect, "Parietal Lobe", 688, 273, 591, 300, Assets.ParietalLobeInfocard),
		BrainComponent(RightBrainInspect, "Occipital Lobe", 728, 440, 638, 385, Assets.OccipitalLobeInfocard, true),
		BrainComponent(RightBrainInspect, "Cerebellum", 644, 519, 578, 451, Assets.CerebellumInfocard, true),
		BrainComponent(RightBrainInspect, "Brainstem", 472, 495, 533, 460, Assets.BrainstemInfocard, true),
		BrainComponent(RightBrainInspect, "Temporal Lobe", 397, 469, 481, 379, Assets.TemporalLobeInfocard, true),
	}
	
	Timer.tween(3, camZoom, {1}, "out-back") 
	
	LeftBrain:float(brainHeight)
	RightBrain:float(brainHeight)
end

function this:update(dt)
	laser:update(dt)
	LeftBrain:update(dt)
	RightBrain:update(dt)
	LeftBrainInspect:update(dt)
	RightBrainInspect:update(dt)
	
	for _, interactionbuttons in pairs(_G.InteractionPoints) do 
		interactionbuttons:onHover()
	end
	
	Timer.update(dt)
	
	camera:zoomTo(camZoom[1])
end

function this:draw()
	love.graphics.draw(Assets.Background_BrainView, 0, 0)
	love.graphics.draw(Assets.Background_Brain_Left, 0, 0)
	love.graphics.draw(Assets.Background_Brain_Right, winW - 200, 0)
	
	if LeftBrainInspect.finishedEntering or RightBrainInspect.finishedEntering then
		local text = "Press [Q] or [DOWN ARROW] to return to Hemisphere View"
		
		love.graphics.print(text, winW/2 - love.graphics.getFont():getWidth(text) / 2, 5)
	end
	
	camera:attach()
	
	LeftBrain:draw() 
	RightBrain:draw()
	LeftBrainInspect:draw()
	RightBrainInspect:draw()
	laser:draw()
		
	for _, interactionButton in pairs(_G.InteractionPoints) do 
		interactionButton:draw()
	end
	
	camera:detach() 
end

function this:keypressed(key)
    if (key == 'down' or key == "q") and (LeftBrainInspect.finishedEntering or RightBrainInspect.finishedEntering) then
		LeftBrainInspect:exit()
		RightBrainInspect:exit() 
		
		Timer.after(2, function() 
			LeftBrain:enter()
			RightBrain:enter()
		end)
	end
end

function this:mousepressed(x, y, button)
	if button == 1 then Signal.emit("m1-pressed") end
end

return this 