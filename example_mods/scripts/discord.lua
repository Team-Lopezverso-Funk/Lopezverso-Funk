-- Better Discord RPC by @Smartbread https://gamebanana.com/mods/399144
-- revived by mimi @slugetta
-- settings (for <0.7.2 psych guys)
rpcEnabled = true -- fast way to turn on/off the mod
showPopup = true -- turns off and turns on pop up
adjustX = 0
forcefullyHideTimer = false -- if false, forces time to be hidden
smallcaps = false -- for compression, DISABLE IT IF YOU THINK IT'S UGLEEE!!!!
popupTime = 2 -- for how long popup will stay
showChartingMode = true -- should discord show whenever you are in charting mode or not
-- \/ only for psych 0.6.1-0.6.3 \/
defaultID = '863222024192262205' -- taken from source
clientID = '' -- custom client ID, leave '', false or nil to use default
-- for psych 0.7+ use discordRPC in pack.json cuz changing it here isnt really supported
-- also this thing is wacky so use at your own risk, recommended to change only if you are using this mod as a tool for your own mod

-- settings ends HERE, all vars below are for coders that use this mod as a tool
-- you can change not local variables using outside scripts using setGlobalFromScript
-- also, forces means basically overrides
forcedClientID = false -- if its '' or false, clientID will be used, use event or scripts to change that, updates automatically
iconIgnoresCutscenes = false -- during cutscenes icon disappears, set this value to true to prevent that
whosIcon = '' -- obviously
inForcedCutscene = false -- forces script to display if player is in cutscene or not
-- for example, if you dont want to set inCustcene true but you need to tell the script that player is, usually mid cutscenes
pause = "" -- pause text
daWeeksName = "" -- week name text (makes automatically)
forcedPlaying = false -- forces script to stop updating playingString
playingString = "Playing: " -- i think you know what does it means, change if idk lol
time = false -- time formula, have to be var because it will show time during pause so yeah
enableTimer = false -- to turn off and turn on timer
forcedAccuracy = false -- forces script to stop updating yourAccuracy (turn this on if you want to change yourAccuracy)
yourAccuracy = 0 -- accuracy calculated by this script
playingAsOpponent = false -- obviously
hp = '' -- obviously
forcedMissesOrRatingFC = false -- forces script to stop updating missesOrRatingFC (turn this on if you want to change missesOrRatingFC)
missesOrRatingFC = "" -- "SFC" etc or "Misses: 1"
inCountdown = false -- obviously
-- display texts
truetexts = {'Story Mode','Freeplay','Charting Mode','Autoplay','Practice Mode','Initialising song...','In a Cutscene','Game Over','Blueballed','Paused','Song Starting','Health','HP','Score/Acc | Miss/Combo'}
smalltexts= {
	'Sᴛᴏʀʏ Mᴏᴅᴇ',				--1
	'Fʀᴇᴇᴘʟᴀʏ',					--2
	'Cʜᴀʀᴛɪɴɢ Mᴏᴅᴇ',			--3
	'Aᴜᴛᴏᴘʟᴀʏ',					--4
	'Pʀᴀᴄᴛɪᴄᴇ Mᴏᴅᴇ',			--5
	'Iɴɪᴛɪᴀʟɪsɪɴɢ Sᴏɴɢ…',		--6
	'Iɴ ᴀ Cᴜᴛsᴄᴇɴᴇ',			--7
	'Gᴀᴍᴇ Oᴠᴇʀ',				--8
	'Bʟᴜᴇʙᴀʟʟᴇᴅ',				--9
	'Pᴀᴜsᴇᴅ',					--10
	'Sᴏɴɢ Sᴛᴀʀᴛɪɴɢ',			--11
	'Hᴇᴀʟᴛʜ',					--12
	'HP',						--13
	'Sᴄᴏʀᴇ/Aᴄᴄ | Mɪss/Cᴏᴍʙᴏ',	--14
}

-- EVENT SHIT (can be modified by outside scripts as well)
setDetails = false
daSetDetails = ''
setState = false
daSetState = ''
setIcon = false
daSetIcon = ''
--

-- you dont need that
local savePos = 0
local offset = 0
local songPos = 0
local init = true
local songRateSpeed = ''
local grandma = {}
local versionInt = 0
local preForcedClientID = forcedClientID -- for detecting changes
local curClientID = nil -- easier to track
function onCreatePost()
	-- luaDebugMode = true -- if you have bugs and you know what you are doing, turn this thing on
	-- version stuff
	versionInt = version:gsub("%D", "") -- has to be 2 seperated operations
	versionInt = tonumber(versionInt)
	if rpcEnabled then
		if versionInt >= 70 then
			if not getPropertyFromClass('backend.ClientPrefs', 'data.discordRPC') then
				close()
				return Function_Stop;
			end
		end
	else
		close()
		return Function_Stop;
	end
	if forcedClientID and forcedClientID ~= '' then
		preForcedClientID = forcedClientID
		if versionInt >= 70 then
			changeDiscordClientID(forcedClientID)
			curClientID = forcedClientID
		end
	end
	if versionInt < 70 and versionInt >= 61 then
		addHaxeLibrary('DiscordClient')
		addHaxeLibrary('DiscordRpc', 'discord_rpc')
		if clientID and clientID ~= '' then
			runHaxeCode([[
				DiscordClient.shutdown();
				DiscordRpc.start({clientID: "]]..(preForcedClientID or clientID)..[["});
			]])
			curClientID = preForcedClientID or clientID
		end
	end
	if versionInt >= 72 then
		setProperty('autoUpdateRPC', false) -- less of unexpected shit
		-- mod settings stuff
		showPopup = getModSetting('showPopup') == nil and showPopup or getModSetting('showPopup')
		adjustX = getModSetting('adjustX') == nil and adjustX or getModSetting('adjustX')
		smallcaps = getModSetting('customFont') == nil and smallcaps or getModSetting('customFont')
		forcefullyHideTimer = getProperty('hideTimer') == nil and forcefullyHideTimer or getProperty('hideTimer')
		popupTime = getModSetting('popupTime') == nil and popupTime or getModSetting('popupTime')
		showChartingMode = getModSetting('showChartingMode') == nil and showChartingMode or getModSetting('showChartingMode')
	end
	if versionInt >= 70 then -- im not sure if all vers have stringStartsWith sooo
		grandma = {
			'backend.',
			'states.',
			'data.'
		}
	end
	if versionInt < 60 then
		playAnim = objectPlayAnimation
	end
	-- the rpc ig

	if showPopup then
		makeAnimatedLuaSprite('discrpcpopup', 'popup', 0, 0)
		setProperty('discrpcpopup.x', screenWidth-getProperty('discrpcpopup.width')-32+adjustX)
		setProperty('discrpcpopup.y', downscroll and -getProperty('discrpcpopup.height') or screenHeight)
		setProperty('discrpcpopup.alpha', 0)
		addAnimationByPrefix('discrpcpopup', 'idle', downscroll and 'downscroll' or 'upscroll', 12, true)
		playAnim('discrpcpopup', 'idle')
		setObjectCamera('discrpcpopup', 'camHUD')
		addLuaSprite('discrpcpopup')
	end
	if smallcaps then
		for i=1,#truetexts do
			truetexts[i] = smalltexts[i]
		end
	end
-------------------
	if getPropertyFromClass((grandma[2] or '') .. 'PlayState', 'deathCounter') < 1 then
		bbdisplay = ""
	else
		bbdisplay = " | "..truetexts[9]..": " .. getPropertyFromClass((grandma[2] or '') .. 'PlayState', 'deathCounter')
	end
	if isStoryMode then
		mode = truetexts[1]
		daWeeksName = ': ' .. week .. ' - '
	else
		mode = truetexts[2]
		daWeeksName = ": "
	end
	if versionInt >= 63 then
		if playbackRate ~= 1 then
			songRateSpeed = 'x'..(playbackRate)..'' 
		end
	else		
		songRateSpeed = '' 
	end
	difficultything = getProperty('storyDifficultyText')
	if not forcedPlaying then
		playingString = truetexts[6] end
end
function onDestroy()
	if curClientID and curClientID ~= '' then
		if versionInt < 70 and versionInt >= 61 then
			runHaxeCode([[
				DiscordClient.shutdown();
				DiscordRpc.start({clientID: "]]..defaultID..[["});
			]])
		elseif versionInt >= 70 then
			changeDiscordClientID(nil)
		end
	end
end
function onSongStart()
	offset = getPropertyFromClass((grandma[1] or '') .. 'ClientPrefs', (grandma[3] or '') .. 'noteOffset')
	enableTimer = true
	inCountdown = false
end
function onExitSong()
	enableTimer = false
	time = false
end
function onEndSong()
	enableTimer = false
	time = false
end
------------------- ord turned on pop up 
local countdownGo = {'3…','2…','1…','Go!',' '}
function onCountdownStarted()
	init = false
	inCountdown = true
end
local alphathingy = false
function onCountdownTick(counter)
	if counter == 1 and showPopup then
		doTweenY('discrpcpopupin', 'discrpcpopup', downscroll and 0 or screenHeight-getProperty('discrpcpopup.height'), downscroll and .7 or .5, 'expoOut')
		if getProperty('camHUD.visible') == false or getProperty('camHUD.alpha') < 0.3 or getProperty('camHUD.zoom') > 1.1 then
			setObjectCamera('discrpcpopup', 'camOther')
		end
		doTweenAlpha('discrpcpopupinAlpha', 'discrpcpopup', 1, downscroll and .7 or .5, 'CubeOut')
		runTimer('popupshowtime', popupTime)
	end
	if not forcedPlaying then
		for counts = 0,4 do
			if counts == counter then
				if counts < 4 then
					playingString = truetexts[11]..': '..countdownGo[counts+1]
				end
			end
		end
	end
end
function onTimerCompleted(tag)
	if tag == 'popupshowtime' then
		doTweenY('discrpcpopupout', 'discrpcpopup', downscroll and -getProperty('discrpcpopup.height') or screenHeight, 0.7, 'CubeIn')
		doTweenAlpha('discrpcpopupinAlpha', 'discrpcpopup', 0, downscroll and .7 or .5, 'CubeIn')
	elseif tag == 'PlayAsOppAdjustment' then
        playingAsOpponent = true
    end
end
function onTweenCompleted(tag)
	if tag == 'discrpcpopupout' then
		removeLuaSprite('discrpcpopup')
	end
end

function onEvent(name, v1, v2)
	if name == 'DiscordRPC' then
		if v1 == 'Cutscene' then
			inForcedCutscene = v2 == 'true'
		elseif v1 == 'Change Details' then
			if v2 == '' then
				setDetails = false
			else
				setDetails = true
				daSetDetails = v2
			end
		elseif v1 == 'Change State' then
			if v2 == '' then
				setState = false
			else
				setState = true
				daSetState = v2
			end
		elseif v1 == 'Change Icon' then
			if v2 == '' then
				setIcon = false
			else
				setIcon = true
				daSetIcon = v2
			end
		elseif v1 == 'Change Client ID' then
			forcedClientID = v2
		elseif v1 == 'Enable Timer' then
			enableTimer = v2 == 'true'
		end
	end
end

function onUpdate()
	if not inGameOver then
		if preForcedClientID ~= forcedClientID then -- updates forcedClientID
			if forcedClientID == false or forcedClientID == '' then
				if not clientID or clientID == '' then forcedClientID = nil
				else forcedClientID = clientID end
			end
			if versionInt < 70 and versionInt >= 61 then -- older psych doesnt have default id sooo
				if forcedClientID == nil then
					forcedClientID = defaultID end
				runHaxeCode([[
					DiscordClient.shutdown();
					DiscordRpc.start({clientID: "]]..forcedClientID..[["});
				]])
			elseif versionInt >= 70 then
				changeDiscordClientID(forcedClientID)
			end
			preForcedClientID = forcedClientID
			curClientID = forcedClientID
		end
		if (getProperty('inCutscene') == true or inForcedCutscene or getProperty('inCutscene')) and not iconIgnoresCutscenes then
			whosIcon = 'incutscene'
		else
			if not setIcon then
				if not playingAsOpponent then
					whosIcon = getProperty('dad.healthIcon')
				else
					whosIcon = getProperty('boyfriend.healthIcon')
				end
			else
				whosIcon = daSetIcon
			end
		end
		if not forcedAccuracy then
			yourAccuracy = (math.floor((getProperty('ratingPercent')*100) * 100) / 100) .. '%' end
		if not forcedMissesOrRatingFC then
			if misses == 0 then
				missesOrRatingFC = '/' .. yourAccuracy .. ' | ' .. ratingFC .. '/x'.. getProperty('combo')
			else
				missesOrRatingFC = '/' .. yourAccuracy .. ' | ' .. misses .. '/x'.. getProperty('combo')
			end
		end
		if getProperty('health') <= 2 then -- BRO THIS THING makes the memory go up CRAZYYY in game over if it's outside this if statement
			hp = "" .. math.ceil(getProperty('health') * 50) .. "%"
		end
	end
--	changemyass(pause .. mode .. daWeeksName .. songName .. ' (' .. difficultything .. ') '..songRateSpeed, playingString .. bbdisplay, whosIcon, enableTimer, time) -- can't fix icons because even psych engine can't use them properly 
end
function onUpdatePost(elapsed)
	if not inGameOver then -- APPARENTLY there's something causing a huge memory leak.. i hope it's not the huge waterfall of if-else statements LMAO (probably is)
		if not setState and not forcedPlaying then --if inGameOver theno its not gameover its custom state
			if getProperty('inCutscene') or inForcedCutscene or getProperty('inCutscene') then
				playingString = truetexts[7]
			else
				if inCountdown == false then
					if init then
						playingString = truetexts[6]
					else
						if getPropertyFromClass((grandma[2] or '') ..'PlayState', 'chartingMode') and showChartingMode then
							playingString = truetexts[3]
						else
							if botPlay then
								playingString = truetexts[4] .. ' | '..truetexts[12]..': ' ..hp
							else
								if practice then
									playingString = truetexts[5] .. ' | '..truetexts[12]..': ' ..hp
								else
									if score == 0 then
										playingString = truetexts[14]..' | '..truetexts[13]..': '..hp
									else 
										playingString = score .. missesOrRatingFC  .. ' | ' ..hp
									end
								end
							end
						end
					end
				end
			end
			songPos = getSongPosition() -- safer??
			if savePos < songPos - 100 then
				onResume()	-- this thing fixes custom menu that done in .lua, if 100ms elapsed during pause game will count it as resume
			end -- custom menus without cutsom subsate were so abused back then because some sonic.balls mod used it smh

			if enableTimer and not forcefullyHideTimer then
				time = songLength - songPos - offset -- literally from source code
			else
				time = false
			end
		end
		if not setDetails then
			rpcDetails = pause .. mode .. daWeeksName .. songName .. ' (' .. difficultything .. ') '..songRateSpeed
		else
			rpcDetails = daSetDetails
		end
		if not setState then
			rpcState = playingString .. bbdisplay
		else
			rpcState = daSetState
		end
	end
	changemyass(rpcDetails, rpcState, whosIcon, enableTimer and not forcefullyHideTimer, time) -- can't fix icons because even psych engine can't use them properly
end
function changemyass(details, state, smallImageKey, hasStartTimestamp, endTimestamp) -- i know i cant do chandeDiscordPrescence = changePrescense but gofuckyourself
	if grandma[1] then
		changeDiscordPresence(details,state,smallImageKey,hasStartTimestamp,endTimestamp)
	else
		changePresence(details,state,smallImageKey,hasStartTimestamp,endTimestamp)
	end
end
function onGameOver()
	if not inGameOver then
		hp = "" .. math.floor(getProperty('health') * 50) .. "%"
		whosIcon = 'gameover'
		if not forcedPlaying then
			if score ~= 0 then
				playingString = truetexts[8].." | " .. playingString -- .. missesOrRatingFC
			else
				playingString = truetexts[8]
			end
		end
		pause = ""
		enableTimer = false
		time = false
		daWeeksName = ": "
		savePos = songPos
		difficultything = getProperty('storyDifficultyText')
		bbdisplay = " | "..truetexts[9]..": " .. getPropertyFromClass((grandma[2] or '') .. 'PlayState', 'deathCounter') + 1
	end
end
function onPause()
	if not inGameOver then
		pause = "("..truetexts[10]..") "
		enableTimer = false
		savePos = songPos
	end
end
function onResume()
	if not inGameOver then
		pause = ""
		if curStep > 0 then
			enableTimer = true
		end
	end
end