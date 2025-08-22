function onStepHit()
	if curStep == 0 then -- Vallarta
		setProperty('fondo.visible', true);
		setProperty('paredes.visible', true);
		setProperty('arcos.visible', true);
		setProperty('fondo2.visible', false);
		setProperty('marneo.visible', false);
		setProperty('arcosneo.visible', false);
		setProperty('sueloneo.visible', false);
	end

	if curStep == 1088 then -- Neon
		setProperty('fondo.visible', false);
		setProperty('paredes.visible', false);
		setProperty('arcos.visible', false);
		setProperty('fondo2.visible', true);
		setProperty('marneo.visible', true);
		setProperty('arcosneo.visible', true);
		setProperty('sueloneo.visible', true);
	end

	if curStep == 1384 then -- Vallarta
		setProperty('fondo.visible', true);
		setProperty('paredes.visible', true);
		setProperty('arcos.visible', true);
		setProperty('fondo2.visible', false);
		setProperty('marneo.visible', false);
		setProperty('arcosneo.visible', false);
		setProperty('sueloneo.visible', false);
	end
end
