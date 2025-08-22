function onStartCountdown()
    loadGraphic("healthBar.bg", "Multi64")
    scaleObject("healthBar.bg", 0.7, 0.7)
    screenCenter("healthBar.bg",'x')
    setProperty("healthBar.bg.offset.y", getProperty('healthBar.bg.offset.y') + 50)
    for i,v in ipairs ({'left','right'}) do
        makeLuaSprite("healthBar"..v..'Bar','Filler64',getProperty('healthBar.bg.x'),getProperty('healthBar.bg.y'))
        setObjectCamera("healthBar"..v..'Bar','hud')
        scaleObject("healthBar"..v..'Bar', 0.7, 0.7)
        setObjectOrder("healthBar"..v..'Bar', getObjectOrder("healthBar.bg",'uiGroup') + 1 ,'uiGroup')
        setProperty("healthBar"..v..'Bar.color',getProperty("healthBar."..v..'Bar.color'))
        setProperty('healthBar.'..v..'Bar.visible',false)
        setProperty('healthBar'..v..'Bar.offset.y',getProperty('healthBar'..v..'Bar.offset.y') + 50)
    end
    runHaxeCode([[
        game.updateIconsPosition = function() 
        {
           iconP1.x = healthBar.bg.x + healthBar.bg.width;
           iconP2.x = healthBar.bg.x - (iconP2.width);
           iconP2.origin.x = 0;
           iconP1.origin.x = 0;
        }
    ]])
end

function onUpdatePost()
    setProperty("healthBarleftBar._frame.frame.width", math.max(0.001, (1 - getProperty("healthBar.percent") * 0.01) * getProperty("healthBarleftBar.frameWidth")))
    if getProperty('healthBarleftBar.color') == getProperty('healthBar.leftBar.color') then
        setProperty('healthBarleftBar.color',getProperty('healthBar.leftBar.color'))
    end
    if getProperty('healthBarrightBar.color') == getProperty('healthBar.rightBar.color') then
        setProperty('healthBarrightBar.color',getProperty('healthBar.rightBar.color'))
    end
end