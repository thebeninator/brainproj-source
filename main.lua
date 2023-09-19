--[[

THIS WAS MADE IN LIKE 2.5 DAYS SO THE CODE IS PRETTY BADLY STRUCTURED  

--]]

-- global game objects 
_G.Assets = {} 

-- libraries 
Class = require "libs.atlaslib.class" 
RGB = require "libs.atlaslib.rgb" 
Timer = require "libs.hump.timer" 
Camera = require "libs.hump.camera" 
Moonshine = require "libs.moonshine"
Signal = require "libs.hump.signal" 
Gamestate = require "libs.hump.gamestate"
Anim8 = require "libs.anim8" 
Laser = require "laser" 
Infocard = require "infocard" 
Button = require "button"

Hemisphere = require "brain.hemisphere" 
HemisphereInspect = require "brain.hemisphere_inspect" 
BrainComponent = require "brain.brain_component"
InteractionPoint = require "interaction_point"

-- shaders 
_G.brainGlow = nil 
_G.brainTubeRays = nil 
_G.interactButtonGlow = nil
_G.laserGlow = nil 

-- fonts
Assets.defaultFont = love.graphics.newFont("VideoTerminalScreen.ttf", 16)
Assets.title = love.graphics.newFont("VideoTerminalScreen.ttf", 32)

-- game states 
START = require "states.start" 
MAIN_MENU = require "states.mainmenu" 
BRAIN_VIEW = require "states.brainview"

function love.load() 
	local function addAsset(name, file) 
		Assets[name] = love.graphics.newImage(file)
	end

	-- load assets 
	love.graphics.setFont(Assets.defaultFont)
	love.graphics.setDefaultFilter("nearest", "nearest")
	addAsset("Brain_Left_Hemisphere", "img/brain_left.png")
	addAsset("Brain_Right_Hemisphere", "img/brain_right.png")
	addAsset("Background_Brain_Left", "img/background_brain_left.png") 
	addAsset("Background_Brain_Right", "img/background_brain_right.png") 
	addAsset("Background_BrainView", "img/background_brainview.png")
	addAsset("Interaction_Button_Unlit", "img/interaction_button_unlit.png")
	addAsset("Interaction_Button_Lit", "img/interaction_button_lit.png")
	addAsset("BrainTube1", "img/braintube_1.png") 
	addAsset("BrainTube2", "img/braintube_2.png") 
	addAsset("BrainTubeAnimated", "img/braintube_animated.png")
	addAsset("LeftHemiInfocard", "img/lefthemi_infocard.png")
	addAsset("RightHemiInfocard", "img/righthemi_infocard.png")
	addAsset("InspectButton", "img/inspect_button.png")
	addAsset("BrainLeftInspect", "img/brain_left_inspect.png")
	addAsset("BrainRightInspect", "img/brain_right_inspect.png")
	addAsset("FrontalLobeInfocard", "img/frontallobe_infocard.png")
	addAsset("BrainstemInfocard", "img/brainstem_infocard.png")
	addAsset("MotorCortexInfocard", "img/motorcortex_infocard.png")
	addAsset("SensorCortexInfocard", "img/sensorcortex_infocard.png")
	addAsset("ParietalLobeInfocard", "img/parietallobe_infocard.png")
	addAsset("OccipitalLobeInfocard", "img/occipitallobe_infocard.png")
	addAsset("CerebellumInfocard", "img/cerebellum_infocard.png")
	addAsset("TemporalLobeInfocard", "img/temporallobe_infocard.png")
	addAsset("BrocasInfocard", "img/brocas_infocard.png")
	addAsset("WernickesInfocard", "img/wernickes_infocard.png")
	addAsset("PlayButton", "img/playbutton.png") 


	local g = Anim8.newGrid(224, 294, Assets.BrainTubeAnimated:getWidth(), Assets.BrainTubeAnimated:getHeight(), 0, 0)
	Assets.BRAIN_TUBE_ANIMATED = Anim8.newAnimation(g('1-2', 1), 0.8)
	
	-- create shaders
	-- nts: these murder perf 
	brainGlow = Moonshine(Moonshine.effects.glow)
	brainGlow.glow.strength = 5
	brainGlow.glow.min_luma = 0.8
	
	interactButtonGlow = Moonshine(Moonshine.effects.glow)
	interactButtonGlow.glow.strength = 15
	
	brainTubeRays = Moonshine(Moonshine.effects.glow).chain(Moonshine.effects.godsray)
	brainTubeRays.disable("glow") -- this looks stupid tbd 
	brainTubeRays.godsray.exposure = 0.15
	brainTubeRays.godsray.weight = 0.25
	brainTubeRays.godsray.density = 0.2
	brainTubeRays.godsray.decay = 0.95
	brainTubeRays.godsray.light_position = {0.5, -0.1}
	brainTubeRays.glow.min_luma = 0.0
	brainTubeRays.glow.strength = 8
	
	laserGlow = Moonshine(Moonshine.effects.glow)
	laserGlow.glow.strength = 20
	laserGlow.glow.min_luma = 0.2

	Gamestate.registerEvents()
    Gamestate.switch(START)
end
