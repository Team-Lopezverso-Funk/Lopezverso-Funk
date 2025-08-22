function onCreatePost()
	makeLuaText('lyrics', '', 0, 0, 0)
	setTextAlignment('lyrics', 'center')
	setTextSize('lyrics', 25)
	setTextFont('lyrics', 'vcr.ttf') --replace vcr with whatever font you want!
	setTextWidth('lyrics', 500)
	screenCenter('lyrics', 'x')
	if downscroll then
		setProperty('lyrics.y', getProperty('scoreTxt.y')+35)
	else
		setProperty('lyrics.y', getProperty('healthBar.y')-110)
    end
	addLuaText('lyrics')
end
function onEvent(name, value1, value2)
	if name == 'Lyrics' then
		setTextString('lyrics', (value1));
		if value2 == '' then
			setTextColor('lyrics', 'FFFFFF') --defaults to white if val 2 is blank
		else
			setTextColor('lyrics', (value2))
		end
	end
end