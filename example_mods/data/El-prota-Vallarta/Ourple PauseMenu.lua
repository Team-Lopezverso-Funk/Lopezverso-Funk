local buttons = {"resume", "options", "restart", "exit"}
local characters = {"Amlex"} --bg characters
local option = 0

function onPause()
    openCustomSubstate("ourplePause", true)
    return Function_Stop;
end

function onCustomSubstateCreate(n)
    playSound("pause", 0, "pause")
    soundFadeIn("pause", 2, 0, 1)
    local char = randomCharacter()

    makeLuaSprite("b", nil)
    makeGraphic("b", screenWidth, screenHeight, "000000")
    setProperty("b.alpha", 0.50)
    setProperty('"b".camera', instanceArg('camOther'), false, true)
    insertToCustomSubstate("b")

    makeLuaSprite("bgChar", "ogPause/characters/" .. char, 600, 25)
    scaleObject("bgChar", 0.65, 0.65)
    setProperty('"bgChar".camera', instanceArg('camOther'), false, true)
    insertToCustomSubstate("bgChar")

    makeLuaSprite("bg", "ogPause/pmbg", -300, 0)
    scaleObject("bg", 1.5, 1.5)
    setProperty('"bg".camera', instanceArg('camOther'), false, true)
    insertToCustomSubstate("bg")

    for _, button in ipairs(buttons) do
        makeAnimatedLuaSprite(button, "ogPause/pause_" .. button, 50, 700)
        addAnimationByPrefix(button, "off", "pm_" .. button .. "idle", 24, true)
        addAnimationByPrefix(button, "on", "pm_" .. button .. "c", 24, true)
        setProperty('button.camera', instanceArg('camOther'), false, true)
        setProperty(button .. ".alpha", 0)
        scaleObject(button, 1.50, 1.50)
        insertToCustomSubstate(button)
    end

    doTweenX("charTX", "bgChar", 35, 0.1, "linear")
    doTweenX("bgTX", "bg", 0, 0.1, "linear")
    runTimer("delay", 0.001)
end

function onSoundFinished(t)
    if t == "pause" then
        playSound("pause", 1, "pause")
    end
end

function mostrarOpciones()
    for i, button in ipairs(buttons) do
        runTimer("show" .. button, 0.05 * i)
    end
end

function onTimerCompleted(t)
    if t == "delay" then
        mostrarOpciones()
    else
        for i, button in ipairs(buttons) do
            if t == "show" .. button then
                doTweenAlpha(button..'TA', button, 1, 0.3, "linear")
                doTweenY(button..'TY', button, -30 + (i - 1) * 5, 0.25, "backOut")
            end
        end
    end
end

function onCustomSubstateUpdate(n)
    if n == "ourplePause" then
        if keyJustPressed("accept") then
            optionSelected()
        end

        optionSelection()
    end
end

function optionSelection()
    if keyJustPressed("up") or getPropertyFromClass("flixel.FlxG", "keys.justPressed.W") or getPropertyFromClass("flixel.FlxG", "keys.justPressed.UP") then
        option = option - 1
        playSound("scrollMenu")

        if option < 1 then
            option = #buttons
        end
    end

    if keyJustPressed("down") or getPropertyFromClass("flixel.FlxG", "keys.justPressed.S") or getPropertyFromClass("flixel.FlxG", "keys.justPressed.DOWN") then
        option = option + 1
        playSound("scrollMenu")

        if option > #buttons then
            option = 1
        end
    end

    for i, button in ipairs(buttons) do
        if option == i then
            playAnim(button, "on")
        else
            playAnim(button, "off")
        end
    end
end

function optionSelected()
    if option == 1 then
        closeCustomSubstate()
    elseif option == 2 then
        runHaxeCode([[import options.OptionsState;
            import backend.MusicBeatState;
            game.paused = true;
            game.vocals.volume = 0;
            MusicBeatState.switchState(new OptionsState());
            if (ClientPrefs.data.pauseMusic != 'None') {
                FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), game.modchartSounds('pauseMusic').volume);
                FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
                FlxG.sound.music.time = game.modchartSounds('pauseMusic').time;
            }
            OptionsState.onPlayState = true;
        ]])
    elseif option == 3 then
        restartSong()
    elseif option == 4 then
        exitSong()
    end
end

function onCustomSubstateDestroy(n)
    if n == "ourplePause" then
        stopSound("pause")
    end
end

function randomCharacter()
    local randomIndex = getRandomInt(1, #characters)
    return characters[randomIndex]
end