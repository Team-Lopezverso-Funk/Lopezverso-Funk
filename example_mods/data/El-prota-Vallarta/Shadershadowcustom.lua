function onCreatePost()
	if shadersEnabled == true then
		-- Shadow colors (RGB Normalized)
		local shadowColorBF = {1, 1, 1}
		local shadowColorGF = {1, 1, 1}
		local shadowColorDAD = {1, 1, 1}

		-- Lighting setup
		local hueBF = -46
		local saturationBF = -20
		local contrastBF = -25
		local brightnessBF = -46

		local hueGF = -46
		local saturationGF = -20
		local contrastGF = -25
		local brightnessGF = -46

		local hueDAD = -46
		local saturationDAD = -20
		local contrastDAD = -25
		local brightnessDAD = -46

		-- Shadow intensity
		local distanceBF = 15
		local distanceGF = 15
		local distanceDAD = 15

      -- Don't touch anything down here!! Only if you know what you're doing!
   

		runHaxeCode([[
			import flixel.math.FlxAngle;
			function setShaderFrameInfo(objectName:String) {
				var object:FlxSprite;
				switch (objectName) {
					case 'boyfriend':
						object = game.boyfriend;
					case 'dad':
						object = game.dad;
					case 'gf':
						object = game.gf;
					default:
						object = game.getLuaObject(objectName);
				}

				var originalCallback = object.animation.callback;

				object.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) {
					if (object.shader != null && object.frame != null) {
						object.shader.setFloatArray('uFrameBounds', [
							object.frame.uv.x, 
							object.frame.uv.y, 
							object.frame.uv.width, 
							object.frame.uv.height
						]);
						object.shader.setFloat('angOffset', object.frame.angle * FlxAngle.TO_RAD);
					}

					if (originalCallback != null) {
						originalCallback(name, frameNumber, frameIndex);
					}
				}
			}
		]])

		initLuaShader('dropShadow')

		for _, object in ipairs({'boyfriend', 'dad', 'gf'}) do
			if getProperty(object .. '.visible') == true then
				setSpriteShader(object, 'dropShadow')

				local hue, saturation, contrast, brightness = 0, 0, 0, 0
				local shadowColor = shadowColorBF
				local angleValue = 75
				local thresholdValue = 0.1
				local currentDistance = distanceBF

				if object == 'boyfriend' then
					hue = hueBF
					saturation = saturationBF
					contrast = contrastBF
					brightness = brightnessBF
					shadowColor = shadowColorBF
					currentDistance = distanceBF
					angleValue = 75

				elseif object == 'dad' then
					hue = hueDAD
					saturation = saturationDAD
					contrast = contrastDAD
					brightness = brightnessDAD
					shadowColor = shadowColorDAD
					currentDistance = distanceDAD
					angleValue = 135

				elseif object == 'gf' then
					hue = hueGF
					saturation = saturationGF
					contrast = contrastGF
					brightness = brightnessGF
					shadowColor = shadowColorGF
					currentDistance = distanceGF
					angleValue = 75
				end

				setShaderFloat(object, 'hue', hue)
				setShaderFloat(object, 'saturation', saturation)
				setShaderFloat(object, 'contrast', contrast)
				setShaderFloat(object, 'brightness', brightness)

				setShaderFloat(object, 'ang', math.rad(angleValue))
				setShaderFloat(object, 'str', 1)
				setShaderFloat(object, 'dist', currentDistance)
				setShaderFloat(object, 'thr', thresholdValue)
				setShaderFloatArray(object, 'dropColor', shadowColor)

				runHaxeFunction('setShaderFrameInfo', {object})

				local imgPath = getProperty(object .. '.imageFile') or ''
				local parts = stringSplit(imgPath, '/')
				local imgName = parts[#parts] or 'missing'
				local maskPath = 'characters/masks/' .. imgName .. '_mask'

				if checkFileExists('images/' .. maskPath .. '.png') then
					setShaderSampler2D(object, 'altMask', maskPath)
					setShaderFloat(object, 'thr2', 1)
					setShaderBool(object, 'useMask', true)
				else
					setShaderBool(object, 'useMask', false)
				end
			end
		end
	end
end