--colors
phillyLightsColors = {0x31a2fd, 0x31fd8c, 0xfb33f5, 0xfd4531, 0xfba633}

--some options
windowBG = false --if true forces the windows from the philly stage into any other stage (looks cool)
blackBG = true
gradient = true
particles = true

bgTransparency = 1 --how transparent the black bg will be
noGf = false --if true makes gf not appear when the event is active


--variables
local curLightEvent = 1

local gradientOrY = 0
local gradientOrH = 0
local gradientIntendedA = 1

local partArray = {}

local active = false

local orBfOrder = 0
local orGfOrder = 0
local orDadOrder = 0

local chars = {'boyfriend', 'gf', 'dad'}

local yOffset = 0
local gfWasVisible = true

local ClientPrefs = 'ClientPrefs'
local data = ''
local PlayState = 'PlayState'

function onCreate()

	if stringStartsWith(version, '1.0.4') then
		ClientPrefs = 'backend.ClientPrefs'
		data = 'data.'
		PlayState = 'states.PlayState'
	end

	makeLuaSprite('phillyGlowBlack', '', screenWidth * -0.5, screenHeight * -0.5)
	makeGraphic('phillyGlowBlack', screenWidth * 2, screenHeight * 2, '000000')
	setProperty('phillyGlowBlack.visible', false)
	setScrollFactor('phillyGlowBlack', 0, 0)
	setProperty('phillyGlowBlack.alpha', bgTransparency)
	addLuaSprite('phillyGlowBlack', true)
	
	makeLuaSprite('phillyGlowGradient', 'philly/gradient', -400, 225)
	setGraphicSize('phillyGlowGradient', 2000, 400)
	setScrollFactor('phillyGlowGradient', 0, 0.75)
	updateHitbox('phillyGlowGradient')
	setProperty('phillyGlowGradient.visible', false)
	addLuaSprite('phillyGlowGradient', true)

	if getPropertyFromClass(ClientPrefs, data..'flashing') == false then
		gradientIntendedA = 0.7
	end
	
	local curStage = getPropertyFromClass(PlayState, 'curStage')
	
	if curStage == 'limo' then
		yOffset = 200
	end
	
	gradientOrY = getProperty('phillyGlowGradient.y')
	gradientOrH = getProperty('phillyGlowGradient.height')
	
	--for philly stage (background windows)
	makeLuaSprite('phillyWindowEvent', 'philly/window', 10, 0)
	setProperty('phillyWindowEvent.scale.x', 0.85)
	setProperty('phillyWindowEvent.scale.y', 0.85)
	setScrollFactor('phillyWindowEvent', 0.3, 0.3)
	updateHitbox('phillyWindowEvent')
	setProperty('phillyWindowEvent.visible', false)
	addLuaSprite('phillyWindowEvent', true)
	
end

function makePhillyParticle(x, y, color)

	local obj = 'phillyParticle'..(#partArray + 1)
	
	makeLuaSprite(obj, 'philly/particle', x, y + yOffset)
	setProperty(obj..'.color', color)
	addLuaSprite(obj, true)
	
	setObjectOrder(obj, getObjectOrder('phillyGlowGradient') + 1)
	
	local orScale = getRandomFloat(0.75, 1)
	setProperty(obj..'.scale.x', orScale)
	setProperty(obj..'.scale.y', orScale)
	
	setScrollFactor(obj, getRandomFloat(0.3, 0.75), getRandomFloat(0.65, 0.75))
	setProperty(obj..'.velocity.x', getRandomFloat(-40, 40))
	setProperty(obj..'.velocity.y', getRandomFloat(-175, -250))
	setProperty(obj..'.acceleration.x', getRandomFloat(-10, 10))
	setProperty(obj..'.acceleration.y', 25)

	partArray[#partArray + 1] = {name = obj, lifeTime = getRandomFloat(0.6, 0.9), decay = getRandomFloat(0.8, 1), scale = orScale}
	
	if not (getPropertyFromClass(ClientPrefs, data..'flashing')) then
		partArray[#partArray].decay = partArray[#partArray].decay * 0.5
		setProperty(obj..'.alpha', 0.5)
	end
	
end

function updateOrder()

	setObjectOrder('phillyGlowBlack', 100000)
	setObjectOrder('phillyWindowEvent', 100000)
	setObjectOrder('phillyGlowGradient', 100000)
	
	for i, j in pairs(partArray) do
		setObjectOrder(partArray[i].name, 100000)
	end
	
	--i don't know how to detect if a character is besides or in-front of another, so this will work for now
	setObjectOrder('gf', 100000)
	setObjectOrder('dad', 100000)
	setObjectOrder('boyfriend', 100000)

end

function onUpdatePost(elapsed)

	if active then
	
		updateOrder()

		--gradient height
		local newHeight = math.ceil(getProperty('phillyGlowGradient.height') - 1000 * elapsed)
		if newHeight > 0 then
			setProperty('phillyGlowGradient.alpha', gradientIntendedA)
			setGraphicSize('phillyGlowGradient', 2000, newHeight)
			updateHitbox('phillyGlowGradient')
			setProperty('phillyGlowGradient.y', (gradientOrY + yOffset) + (gradientOrH - getProperty('phillyGlowGradient.height')))
		else
			setProperty('phillyGlowGradient.alpha', 0)
			setProperty('phillyGlowGradient.y', -5000)
		end

		--particle stuff
		for i, j in pairs(partArray) do
		
			if luaSpriteExists(partArray[i].name) then
			
				partArray[i].lifeTime = partArray[i].lifeTime - elapsed
				
				if partArray[i].lifeTime <= 0 then
				
					partArray[i].lifeTime = 0
					setProperty(partArray[i].name..'.alpha', getProperty(partArray[i].name..'.alpha') - (partArray[i].decay * elapsed))
					
					if getProperty(partArray[i].name..'.alpha') > 0 then
						setProperty(partArray[i].name..'.scale.x', partArray[i].scale * getProperty(partArray[i].name..'.alpha'))
						setProperty(partArray[i].name..'.scale.y', partArray[i].scale * getProperty(partArray[i].name..'.alpha'))
					end
					
				end
				
				--remove the particle
				if getProperty(partArray[i].name..'.alpha') <= 0 then
					removeLuaSprite(partArray[i].name, true)
					partArray[i] = nil
				end
				
			end
			
		end
	
	end

end

function onEvent(tag, value1, value2)
	
	if tag == 'Philly Glow Recreation' then
	
		local lightId = tonumber(value1)
		if lightId == nil then lightId = 0 end
		
		if not (value2 == '0' or value2 == nil or value2 == '') then
			yOffset = tonumber(value2)
		end
		
		if lightId == 0 then
			
			if active then
			
				if not (getProperty('gf') == nil) then
				
					setObjectOrder('gf', orGfOrder)
					
					if noGf then
						setProperty('gf.visible', gfWasVisible)
					end
					
				end
				setObjectOrder('dad', orDadOrder)
				setObjectOrder('boyfriend', orBfOrder)
			
				cameraFlash('camGame', 'FFFFFF', 0.15)
				
				if getPropertyFromClass(ClientPrefs, data..'camZooms') then
					setPropertyFromClass('flixel.FlxG', 'camera.zoom', getPropertyFromClass('flixel.FlxG', 'camera.zoom') + 0.5)
					setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.1)
				end
				
				setProperty('phillyGlowBlack.visible', false)
				setProperty('phillyGlowGradient.visible', false)
				setProperty('phillyWindowEvent.visible', false)
				
				for i, j in pairs(partArray) do
		
					if luaSpriteExists(partArray[i].name) then
						removeLuaSprite(partArray[i].name, true)
					end
					
				end
				
				partArray = {}
				
				for i = 1, #chars do
					setProperty(chars[i]..'.color', 0xffffff)				

					end
				
				active = false
				
			end
			
		end
		
		if lightId == 1 then
		
			curLightEvent = getRandomInt(1, #phillyLightsColors, tostring(curLightEvent))
			local color = phillyLightsColors[curLightEvent]
			
			if active == false then

				orBfOrder = getObjectOrder('boyfriend')
				orGfOrder = getObjectOrder('gf')
				orDadOrder = getObjectOrder('dad')

				if not (getProperty('gf') == nil) and noGf then
					gfWasVisible = getProperty('gf.visible')
					setProperty('gf.visible', false)
				end

				setProperty('camZooming', true)
			
				cameraFlash('camGame', 'FFFFFF', 0.15)
				
				if getPropertyFromClass(ClientPrefs, data..'camZooms') then
					setPropertyFromClass('flixel.FlxG', 'camera.zoom', getPropertyFromClass('flixel.FlxG', 'camera.zoom') + 0.5)
					setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.1)
				end
				
				if blackBG then
					setProperty('phillyGlowBlack.visible', true)
				end
				
				if gradient then
					setProperty('phillyGlowGradient.visible', true)
				end

				if getPropertyFromClass(PlayState, 'curStage') == 'philly' or windowBG then
					setProperty('phillyWindowEvent.visible', true)
				end
			
				active = true
			
			end
			
			for i = 1, #chars do
				setProperty(chars[i]..'.color', color)
			end

			setProperty('phillyGlowGradient.color',color)
			setProperty('phillyWindowEvent.color', color)
			
			for i, j in pairs(partArray) do

				if luaSpriteExists(partArray[i].name) then
					setProperty(partArray[i].name..'.color',color)
				end
				
			end
			
		end
		
		if lightId == 2 then
		
			if active then
		
				if getPropertyFromClass(ClientPrefs, data..'lowQuality') == false and particles then
				
					--spawn partArray
					local partArrayNum = getRandomInt(8, 12)
					local width = (2000 / partArrayNum)
					local color = phillyLightsColors[curLightEvent]
					
					for j = 0, 3 do
						
						for i = 0, partArrayNum do
							makePhillyParticle(-400 + width * i + getRandomFloat(-width / 5, width / 5), gradientOrY + 200 + (getRandomFloat(0, 125) + j * 40), color)
						end
						
					end
					
				end
				
				gradientBop()
			
			end
			
		end
	
	end
	
	if tag == 'Change Character' then
	
		if active then

			for i, j in pairs(partArray) do

				if luaSpriteExists(partArray[i].name) then
					setObjectOrder(partArray[i].name, getObjectOrder('phillyGlowGradient') + 1)
				end
				
			end
			
			for i = 1, #chars do
				setProperty(chars[i]..'.color', phillyLightsColors[curLightEvent])
			end
		
		end
		
	end
	
end

function gradientBop()
	setGraphicSize('phillyGlowGradient', 2000, gradientOrH)
	updateHitbox('phillyGlowGradient')
	setProperty('phillyGlowGradient.alpha', gradientIntendedA)
	setProperty('phillyGlowGradient.y', gradientOrY + yOffset)
end