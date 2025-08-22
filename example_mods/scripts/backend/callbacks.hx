import backend.Mods;
import tjson.TJSON as Json;

function parseJson(directory:String, ?printWarming:Bool, ?ignoreMods:Bool):Dynamic {
	if (printWarming == null) printWarming = false;
	if (ignoreMods == null) ignoreMods = false;

	final funnyPath:String = directory + '.json';
	final jsonContents:String = Paths.getTextFromFile(funnyPath, ignoreMods);
	final realPath:String = (ignoreMods ? '' : Paths.modFolders(Mods.currentModDirectory)) + '/' + funnyPath;
	final jsonExists:Bool = Paths.fileExists(realPath, null, ignoreMods);
	if (jsonContents != null || jsonExists) return Json.parse(jsonContents);
	else if (!jsonExists && printWarming) debugPrint('parseJson: "' + realPath + '" doesn\'t exist!', 0xff0000);
}

function isGfNull():Bool {
	return game.gf == null;
}

function createCallbackForOthers(name:String, func:Dynamic):Void {
	for (script in game.luaArray)
		if (script != null && script.lua != null && !script.closed)
			if (parentLua.scriptName != script.scriptName)
				script.addLocalCallback(name, func);
	game.setOnHScript(name, func);
}

createGlobalCallback('precacheImage', function(key:String, ?allowGPU:Bool) {
	Paths.image(key, null, allowGPU == null ? true : allowGPU);
});
createCallbackForOthers('makeStageSprite', function(tag:String, ?image:String = null, ?x:Float = 0, ?y:Float = 0) {
	parentLua.call('makeStageSprite', [tag, image, x, y]);
});
createCallbackForOthers('makeAnimatedStageSprite', function(tag:String, ?image:String = null, ?x:Float = 0, ?y:Float = 0, ?spriteType:String = 'sparrow') {
	parentLua.call('makeAnimatedStageSprite', [tag, image, x, y, spriteType]);
});
createCallbackForOthers('applyStageOffsets', function(tag:String) {
	parentLua.call('applyStageOffsets', [tag]);
});