function onCreate()
    dir = "VallartaNeo/"
    local objects = {
        {name = "neopiso", image = "marneo", x = -402, y = -141},
        {name = "neosuelo", image = "sueloneo", x = -402, y = -141},
        {name = "NeoBG", image = "cieloneo", x = -402, y = -141},
        {name = "neoArco", image = "Arcosneo", x = -402, y = -139}
    }
    
    for _, obj in ipairs(objects) do
        makeLuaSprite(obj.name, dir .. obj.image, obj.x, obj.y)
        scaleObject(obj.name, 1, 1)
        setProperty(obj.name .. ".antialiasing", true)
        setProperty(obj.name .. ".flipX", false)
        setProperty(obj.name .. ".flipY", false)
        setProperty(obj.name .. ".alpha", 1)
        setProperty(obj.name .. ".scrollFactor.x", 1)
        setProperty(obj.name .. ".scrollFactor.y", 1)
        addLuaSprite(obj.name)
    end
end
