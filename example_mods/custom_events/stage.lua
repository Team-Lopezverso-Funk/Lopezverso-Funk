function onEvent(name, value1, value2)
    if name == 'Change Stage' then
        -- Cambia el stage al especificado en value1
        setPropertyFromClass('PlayState', 'curStage', 'stages/' .. value1)
        
        -- Si el stage tiene un archivo .json, cargarlo desde la carpeta Stage/
        if value1 ~= nil and value1 ~= '' then
            loadStage('stages/' .. value1)
        end
    end
end
