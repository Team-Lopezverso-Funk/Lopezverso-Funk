function onCreatePost()
    shaderCoordFix();
        initLuaShader('shader')
        makeLuaSprite('SHADER_CHIDO')
        setSpriteShader('SHADER_CHIDO', 'shader')
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr){
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData3 = spr.__cacheBitmapData2 = spr.__cacheBitmapData = null;
            spr.__cacheBitmapColorTransform = null;
        }
        fixShaderCoordFix = function(?_){
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
    ]]);
  end

function onBeatHit()
    if curBeat == 208 then -- el beat en el q comienza el shadr
        runHaxeCode('game.camGame.setFilters([new ShaderFilter(game.getLuaObject("SHADER_CHIDO").shader)]);')
    end
    if curBeat == 272 then -- el beat en el q acaba el shadr
        runHaxeCode('game.camGame.setFilters([]);')
    end
end

function onEndSong()
        runHaxeCode('game.camGame.setFilters([]);')
end