function onCreate()
    dir = "PLaya456/"
    local objects = {
        {name = "fondillo", image = "fondirijillo", x = -402, y = -141},
        {name = "Paredes", image = "PAredes", x = -402, y = -141},
        {name = "Arcos", image = "Arcos", x = -402, y = -141}
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
