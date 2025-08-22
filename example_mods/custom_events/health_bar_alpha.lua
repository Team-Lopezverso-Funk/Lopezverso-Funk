function onEvent(n,v1,v2)
if n == 'health_bar_alpha' then
doTweenAlpha('healthBar_alpha', 'healthBar', v1, v2, 'sineInOut')
doTweenAlpha('iconP1_alpha', 'iconP1', v1, v2, 'sineInOut')
doTweenAlpha('iconP2_alpha', 'iconP2', v1, v2, 'sineInOut')
end
end