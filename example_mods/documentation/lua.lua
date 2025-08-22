--[[ Variables ]]--

--- The current stage.
---@type string
curStage = getPropertyFromClass('states.PlayState', 'curStage')
--- The stage position offset.
---@type {x:number, y:number}
stageOffsets = {x = 0, y = 0}



--[[ Callbacks ]]--

--- Called when a stage needs to be precached.
function precacheStage()
	-- precache stage object images
end
--- Called when a stage is created.
---@param snapChanges boolean
function onStageCreation(snapChanges)
	if curStage == 'name' then
		-- create stage objects
	end
end
--- Called when a stage is destroyed.
---@param snapChanges boolean
function onStageDestruction(snapChanges)
	if curStage == 'name' then
		-- destroy stage objects
	end
end



--[[ Functions ]]--

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