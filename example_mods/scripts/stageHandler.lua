--[[
Plans -
	Figure out pixel stage shenanigans / 90%
]]--

---@param variable any The `variable` you want to check.
---@param ifNil any What should be returned if the `variable` is `nil`.
---@param shouldBe? 'number'|'string'|'boolean' What should be the `variable` type be?
---@return any ifNil Shall return `ifNil`.
local function checkVarData(variable, ifNil, shouldBe)
	if shouldBe == 'number' then
		local nilTest = tonumber(variable)
		return type(nilTest) ~= 'number' and ifNil or nilTest
	elseif shouldBe == 'string' then return tostring(variable)
	elseif shouldBe == 'boolean' then
		if type(variable) == 'boolean' then return variable
		elseif type(variable) == 'string' then
			local nilTest = stringTrim(variable:lower())
			if nilTest == 'true' then return true -- screw coding
			elseif nilTest == 'false' then return false end
			return ifNil
		elseif type(variable) == 'number' then
			if variable >= 1 then return true -- screw coding
			elseif variable <= 0 then return false end
			return ifNil -- jic
		else return ifNil end
	end
	local nilTest = variable
	if type(variable) == 'nil' then nilTest = ifNil end
	return nilTest
end

---@param stage string Stage file name.
---@param isJson? boolean If true, it should add the json file typing.
---@return string
local function stageScript(stage, isJson)
	local hehePath = 'stages/' .. stage
	if checkVarData(isJson, false, 'boolean') then
		if checkFileExists(hehePath .. '.json') then
			return hehePath .. '.json'
		end
	else
		if checkFileExists(hehePath .. '.lua') then
			return hehePath .. '.lua'
		end
		if checkFileExists(hehePath .. '.hx') then
			return hehePath .. '.hx'
		end
	end
	return 'aww shit'
end

---@param name string Callback name.
---@param args any[] Function arguments.
local function callFunc(name, args)
	if getPropertyFromClass('states.PlayState', 'chartingMode') and name ~= 'precacheStage' then
		local fileToString = getTextFromFile(stageScript(curStage))
		if not string.find(fileToString, 'onStageCreation') or not string.find(fileToString, 'onStageDestruction') then
			debugPrint('Where tf is "' .. name .. '"?? You need that!!!')
		end
	end
	callOnScripts(name, args, true, true, {scriptName}, nil)
end

---@param character string Character tag.
---@param x number X position.
---@param y number Y position.
local function changeCharXY(character, x, y)
	-- setProperty(character .. '.x', 0)
	-- setProperty(character .. '.y', 0)
	setProperty(character .. 'Group.x', x)
	setProperty(character .. 'Group.y', y)
end

---@param path string Script path.
---@param ignoreAlreadyRunning? boolean If true, it will add the script again if it's already added.
local function addScript(path, ignoreAlreadyRunning)
	ignoreAlreadyRunning = checkVarData(ignoreAlreadyRunning, false, 'boolean')
	if checkFileExists(path .. '.lua') then
		addLuaScript(path, ignoreAlreadyRunning)
	end
	if checkFileExists(path .. '.hx') then
		addHScript(path, ignoreAlreadyRunning)
	end
end
---@param path string Script path.
---@param ignoreAlreadyRunning? boolean If true, it will remove the script again, even if one doesn't exist.
local function removeScript(path, ignoreAlreadyRunning)
	ignoreAlreadyRunning = checkVarData(ignoreAlreadyRunning, false, 'boolean')
	if checkFileExists(path .. '.lua') then
		removeLuaScript(path, ignoreAlreadyRunning)
	end
	if checkFileExists(path .. '.hx') then
		removeHScript(path, ignoreAlreadyRunning)
	end
end

--- Is just makeLuaSprite.
---@param tag string Sprite tag name.
---@param image string Sprite image.
---@param x number X position.
---@param y number Y position.
function makeStageSprite(tag, image, x, y)
	makeLuaSprite(tag, image, x, y)
	applyStageOffsets(tag)
end
--- Is just makeAnimatedLuaSprite.
---@param tag string Sprite tag name.
---@param image string Sprite image.
---@param x number X position.
---@param y number Y position.
---@param spriteType 'tex'|'texture'|'textureatlas'|'texture_noaa'|'textureatlass_noaa'|'tex_noaa'|'packer'|'packeratlas'|'pac' The type of sprite to load.
function makeAnimatedStageSprite(tag, image, x, y, spriteType)
	makeAnimatedLuaSprite(tag, image, x, y, spriteType)
	applyStageOffsets(tag)
end
--- Quickly apply `stageOffsets` to any object.
---@param tag string Sprite tag name.
function applyStageOffsets(tag)
	setProperty(tag .. '.x', getProperty(tag .. '.x') + stageOffsets.x)
	setProperty(tag .. '.y', getProperty(tag .. '.y') + stageOffsets.y)
end

function onCreatePost()
	if stageOffsets == nil then setOnScripts('stageOffsets', {x = 0, y = 0}) end
	setOnScripts('curStage', curStage)
	runHaxeCode(getTextFromFile('scripts/backend/callbacks.hx'))
	addScript('stages/' .. curStage)
	callFunc('precacheStage', {})
	callFunc('onStageCreation', {true})
end

function onEventPushed(name, value1, value2)
	if name == 'Starting Stage Offsets' then
		setOnScripts('stageOffsets', {x = tonumber(value1), y = tonumber(value2)})
	end

	if name == 'Change The Stage' then
		---@type {v1:string[], v2:string[]}
		local valueContents = {v1 = {}, v2 = {}}
		valueContents.v1 = textSplit(value1, ',')
		valueContents.v2 = textSplit(value2, ',')

		if checkFileExists(stageScript(valueContents.v1[1])) and valueContents.v1[1] ~= curStage then
			addScript('stages/' .. valueContents.v1[1])
			callFunc('precacheStage', {})
			-- removeScript('stages/' .. valueContents.v1[1]) -- can't do this for some reason
		end
	end
end

---@class StageFile
local stageBase = {
	---@type string
	directory = '',
	---@type number
	defaultZoom = 0.9,
	---@type boolean
	isPixelStage = false,
	---@type string
	stageUI = 'normal',

	---@type number[]
	boyfriend = {770, 100},
	---@type number[]
	girlfriend = {400, 130},
	---@type number[]
	opponent = {100, 100},
	---@type boolean
	hide_girlfriend = false,

	---@type number[]
	camera_boyfriend = {0, 0},
	---@type number[]
	camera_opponent = {0, 0},
	---@type number[]
	camera_girlfriend = {0, 0},
	---@type number
	camera_speed = 1
}

--- Checks if gf is `nil`.
---@return boolean result If true, gf is `nil`.
local function isGfNil()
	return runHaxeFunction('isGfNull', {})
end

---@type string
local lastGf = getPropertyFromClass('states.PlayState', 'SONG.gfVersion')
---@type number
local lastAlpha = 1
function onEvent(name, value1, value2)
	if name == 'Change Character' then
		if value1 == 'gf' or value1 == 'girlfriend' or value1 == '1' then
			if isGfNil() then
				lastGf = value2
			end
		elseif value1 == 'dad' or value1 == 'opponent' or value1 == '0' then
		else -- le bf
		end
	end

	if name == 'Change The Stage' then
		---@type {v1:string[], v2:string[]}
		local valueContents = {v1 = {}, v2 = {}}
		valueContents.v1 = textSplit(value1, ',')
		---@type boolean
		local snapChanges = checkVarData(valueContents.v1[2], false, 'boolean')
		---@type boolean
		local snapCamera = checkVarData(valueContents.v1[3], false, 'boolean')
		valueContents.v2 = textSplit(value2, ',')
		for i = 1, 2 do valueContents.v2[i] = checkVarData(valueContents.v2[i], 0, 'number') end

		---@type string, string
		local oldStage, newStage = curStage, valueContents.v1[1]
		if checkFileExists(stageScript(newStage, true)) then
			if checkFileExists(stageScript(oldStage)) then -- Stage Removal
				callFunc('onStageDestruction', {snapChanges})
				-- removeScript('stages/' .. oldStage) -- can't do this for some reason
			end

			if getPropertyFromClass('states.PlayState', 'chartingMode') then -- Stupid print cause yes
				debugPrint('Changing stage from "' .. oldStage .. '" to "' .. newStage .. '".')
			end

			-- Stage Elements
			---@type StageFile
			local stageGet = runHaxeFunction('parseJson', {stageScript(newStage, true):gsub('.json', '')})
			---@type StageFile
			local jsonFile = {
				directory = checkVarData(stageGet.directory, stageBase.directory, 'string'),
				defaultZoom = checkVarData(stageGet.defaultZoom, stageBase.defaultZoom, 'number'),
				isPixelStage = checkVarData(stageGet.isPixelStage, stageBase.isPixelStage, 'boolean'),
				stageUI = checkVarData(stageGet.stageUI, stageBase.stageUI, 'string'),

				boyfriend = stageGet.boyfriend,
				girlfriend = stageGet.girlfriend,
				opponent = stageGet.opponent,
				hide_girlfriend = checkVarData(stageGet.hide_girlfriend, stageBase.hide_girlfriend, 'boolean'),

				camera_boyfriend = stageGet.camera_boyfriend,
				camera_opponent = stageGet.camera_boyfriend,
				camera_girlfriend = stageGet.camera_boyfriend,
				camera_speed = checkVarData(stageGet.camera_speed, stageBase.camera_speed, 'number')
			}

			setOnScripts('stageOffsets', {x = valueContents.v2[1], y = valueContents.v2[2]})

			if jsonFile.hide_girlfriend then
				if not isGfNil() then
					lastGf = gfName
					lastAlpha = getProperty('gf.alpha')
					runHaxeCode([[
						if (!game.gfMap.exists(gf.curCharacter)) game.gfMap.set(game.gf.curCharacter, game.gf);
						game.gf.alpha = 0.00001;
						game.gf = null;
					]])
					setOnScripts('gfName', nil)
				end
			else
				if isGfNil() then
					runHaxeCode([[
						var prevGf:String = ']] .. lastGf .. [[';
						if (!game.gfMap.exists(prevGf)) game.addCharacterToList(prevGf, 2);
						game.gf = game.gfMap.get(prevGf);
						game.gf.alpha = ]] .. lastAlpha .. [[;
					]])
					setOnScripts('gfName', lastGf)
				end
			end

			setOnScripts('defaultOpponentX', checkVarData(stageOffsets.x + jsonFile.opponent[1], 100, 'number'))
			setOnScripts('defaultOpponentY', checkVarData(stageOffsets.y + jsonFile.opponent[2], 100, 'number'))
			setProperty('DAD_X', defaultOpponentX)
			setProperty('DAD_Y', defaultOpponentY)
			setOnScripts('defaultGirlfriendX', checkVarData(stageOffsets.x + jsonFile.girlfriend[1], 400, 'number'))
			setOnScripts('defaultGirlfriendY', checkVarData(stageOffsets.y + jsonFile.girlfriend[2], 130, 'number'))
			setProperty('GF_X', defaultGirlfriendX)
			setProperty('GF_Y', defaultGirlfriendY)
			setOnScripts('defaultBoyfriendX', checkVarData(stageOffsets.x + jsonFile.boyfriend[1], 770, 'number'))
			setOnScripts('defaultBoyfriendY', checkVarData(stageOffsets.y + jsonFile.boyfriend[2], 100, 'number'))
			setProperty('BF_X', defaultBoyfriendX)
			setProperty('BF_Y', defaultBoyfriendY)

			changeCharXY('dad', defaultOpponentX, defaultOpponentY)
			if not isGfNil() then changeCharXY('gf', defaultGirlfriendX, defaultGirlfriendY) end
			changeCharXY('boyfriend', defaultBoyfriendX, defaultBoyfriendY)

			setProperty('opponentCameraOffset[0]', checkVarData(jsonFile.camera_opponent[1], 0, 'number'))
			setProperty('opponentCameraOffset[1]', checkVarData(jsonFile.camera_opponent[2], 0, 'number'))
			setProperty('girlfriendCameraOffset[0]', checkVarData(jsonFile.camera_girlfriend[1], 0, 'number'))
			setProperty('girlfriendCameraOffset[1]', checkVarData(jsonFile.camera_girlfriend[2], 0, 'number'))
			setProperty('boyfriendCameraOffset[0]', checkVarData(jsonFile.camera_boyfriend[1], 0, 'number'))
			setProperty('boyfriendCameraOffset[1]', checkVarData(jsonFile.camera_boyfriend[2], 0, 'number'))

			setProperty('cameraSpeed', checkVarData(jsonFile.camera_speed, 1, 'number'))

			runHaxeCode('game.moveCameraSection();')
			setProperty('defaultCamZoom', checkVarData(jsonFile.defaultZoom, 0.9, 'number'))
            if snapCamera then
                runHaxeCode('FlxG.camera.snapToTarget();')
				setProperty('camGame.zoom', getProperty('defaultCamZoom'))
			end
			setPropertyFromClass('states.PlayState', 'stageUI', checkVarData(jsonFile.stageUI, jsonFile.isPixelStage and 'pixel' or 'normal', 'string'))

			setOnScripts('curStage', newStage) -- Stage Addition
			if checkFileExists(stageScript(newStage)) then
				-- addScript('stages/' .. newStage) -- basically useless rn
				callFunc('onStageCreation', {snapChanges})
			end
		else
			if getPropertyFromClass('states.PlayState', 'chartingMode') then
				debugPrint('Stage "' .. newStage .. '" doesn\'t exist.')
			end
		end
	end
end

--- Split's a `string` into a `string[]`
---@param str string
---@param delimiter string
---@return string[]
function textSplit(str, delimiter)
	---@type string[]
	local splitTxt = stringSplit(str, delimiter)
	for index, value in pairs(splitTxt) do
		splitTxt[index] = stringTrim(value)
	end
	return splitTxt
end