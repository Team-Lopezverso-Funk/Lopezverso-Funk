-- 
local debug = false;

function onCreate()
	if debug then debugPrint("View Gallery") end
end
function onStartCountdown()
	playMusic(getVar("galleryMusic"), 1, true)
	fuckHud()
	setProperty('dad.visible', false)
	return Function_Stop;
end

function onUpdate()
	if keyJustPressed('back') then
		loadSong("Gallery")
	end

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') then
		restartSong()
	end
end

function fuckHud()
		setProperty('scoreTxt.visible', false)
        setProperty('healthBar.visible', false)
        setProperty('healthBarBG.visible', false)
        setProperty('iconP1.visible', false)
        setProperty('iconP2.visible', false)
end