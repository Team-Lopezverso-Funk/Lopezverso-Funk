function onStepHit()
    if curStep == 32 then
      makeLuaSprite('imagethingy', 'Cardsongs/El-Prota', 0, 0)
      setProperty('imagethingy.alpha', 1)
      setProperty('imagethingy.camera', instanceArg('camOther'), false, true)
      screenCenter('imagethingy')
      addLuaSprite('imagethingy', true)
      runTimer('shit', 2)
    end
  end
  
  function onTimerCompleted(tag)
    if tag == 'shit' then
      setProperty('imagethingy.alpha', 0)
    end
  end