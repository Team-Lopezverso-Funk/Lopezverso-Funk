function onCreate()
    -- Stage 1: playavallarta
    makeLuaSprite('fondo', 'PLaya456/fondirijillo', -402, -141)
    setScrollFactor('fondo', 1.0, 1.0);
    scaleObject('fondo', 1, 1);
    addLuaSprite('fondo', false)
    setProperty('fondo.visible', true);

    makeLuaSprite('paredes', 'PLaya456/PAredes', -402, -141)
    setScrollFactor('paredes', 1.0, 1.0);
    scaleObject('paredes', 1, 1);
    addLuaSprite('paredes', false)
    setProperty('paredes.visible', true);

    makeLuaSprite('arcos', 'PLaya456/Arcos', -402, -141)
    setScrollFactor('arcos', 1.0, 1.0);
    scaleObject('arcos', 1, 1);
    addLuaSprite('arcos', false)
    setProperty('arcos.visible', true);

    -- Stage 2: VallartaNeon
    makeLuaSprite('fondo2', 'VallartaNeo/cieloneo', -402, -141)
    setScrollFactor('fondo2', 1.0, 1.0)
    scaleObject('fondo2', 1, 1);
    addLuaSprite('fondo2', false)
    setProperty('fondo2.visible', false);

    makeLuaSprite('marneo', 'VallartaNeo/marneo', -402, -141)
    setScrollFactor('marneo', 1.0, 1.0);
    scaleObject('marneo', 1, 1);
    addLuaSprite('marneo', false)
    setProperty('marneo.visible', false);

    makeLuaSprite('arcosneo', 'VallartaNeo/Arcosneo', -402, -141)
    setScrollFactor('arcosneo', 1.0, 1.0);
    scaleObject('arcosneo', 1, 1);
    addLuaSprite('arcosneo', false)
    setProperty('arcosneo.visible', false);

    makeLuaSprite('sueloneo', 'VallartaNeo/sueloneo', -402, -141)
    setScrollFactor('sueloneo', 1.0, 1.0);
    scaleObject('sueloneo', 1, 1);
    addLuaSprite('sueloneo', false)
    setProperty('sueloneo.visible', false)
    
    close(true)
end
