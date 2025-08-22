function updateHealthBar(step, graphic, filler)
    if curStep == step then
        loadGraphic('healthBar.bg', graphic)
        updateHitbox('healthBar.bg')
        screenCenter('healthBar.bg', 'x')
        setProperty('healthBar.bg.offset.y', getProperty('healthBar.bg.offset.y') + 50)
        
        for _, v in ipairs({'left', 'right'}) do
            local barName = 'healthBar' .. v .. 'Bar'
            makeLuaSprite(barName, filler, getProperty('healthBar.bg.x'), getProperty('healthBar.bg.y'))
            setObjectCamera(barName, 'hud')
            scaleObject(barName, 0.7, 0.7)
            setObjectOrder(barName, getObjectOrder('healthBar.bg', 'uiGroup') + 1, 'uiGroup')
            setProperty(barName .. '.color', getProperty('healthBar.' .. v .. 'Bar.color'))
            setProperty(barName .. '.visible', true) -- Ahora los fillers serán visibles
            setProperty(barName .. '.offset.y', getProperty(barName .. '.offset.y') + 50)
        end
    end
end

function onStepHit()
    updateHealthBar(1088, 'NeoBar', 'NeoFiller')
    updateHealthBar(1384, 'Lopezbar', 'fillerBar')
end
