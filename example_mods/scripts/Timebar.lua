function onCreatePost()
    left = getCharHbColor('dad')
    right = getCharHbColor('bf')
    setTimeBarColors(left, right)
    end
    
    function onEvent(n,v,vv)
        if n == 'Change Character' then
        left = getCharHbColor('dad')
        right = getCharHbColor('bf')
        setTimeBarColors(left, right)
        end
    end
    
    function rgbToHex(rgb) -- https://www.codegrepper.com/code-examples/lua/rgb+to+hex+lua
        rgbT = rgb or {0,0,0}
        return string.format('%02x%02x%02x', math.floor(rgbT[1]), math.floor(rgbT[2]), math.floor(rgbT[3]))
    end -- color stuffs not by cherry anymore idr who tho
    
    function getCharHbColor(char)
        if char == 'bf' then char = 'boyfriend' end
            hbColor = rgbToHex(getProperty(char..'.healthColorArray'))
        return hbColor
    end