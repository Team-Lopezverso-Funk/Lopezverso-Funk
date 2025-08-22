import haxe.Json;
import backend.StageData;
import flixel.FlxG;

var eventOptions:Map<String, Dynamic> = [
	/*
	* Do you want run a specific callback to the stage script when it's added? (similar to onCreate or onDestroy)
	*
	* onCreate() does work when adding a new stage, but onCreatePost will not since it's ran in PlayState itself 
	* and not when the script is made.
	*/
	"runCustomCallback" => true,
	
	/*
	* The custom callback name. In your script, add this callback and it will be ran when the stage is created!
	* Do note that this callback will be ran across ALL scripts (of the type specified in value2) that are active in the song.
	*/
	"customCallback" => "onStageAdded"
];

function onEvent(name:String, value1:String, value2:String) {
	if(name == "Change Stage") {
		//Parse the stage
		if(value2 == null || value2 == "") {
			game.addTextToDebug("Change Stage.hx:Error - Value 2 must be specified as 'lua' or 'hx'!", 0xFFFF0000);
			return;
		} else if(value1 == null || value1 == "") {
			game.addTextToDebug("Change Stage.hx:Error - Value 1 must be the name of a stage file!", 0xFFFF0000);
			return;
		}
		
		var newStageData = StageData.getStageFile(value1);
		
		// Camera's new zoom
		PlayState.instance.defaultCamZoom = newStageData.defaultZoom;
		FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
		//PlayState.instance.isPixelStage = newStageData.isPixelStage; //Cannot set this since isPixelStage is a read-only
		
		//This stuff is for the StageUI. It breaks the script with jsons without the variable. You can add it back if it doesn't affect your stage
		/*
		if (newStageData.stageUI != null && newStageData.stageUI.trim().length > 0) PlayState.instance.stageUI = newStageData.stageUI;
		else if (newStageData.isPixelStage) PlayState.instance.stageUI = "pixel";
		else PlayState.instance.stageUI = "normal";
		game.addTextToDebug("New Stage: " + PlayState.instance.stageUI);
		*/
		
		// Camera's new speed
		if(newStageData.camera_speed != null) PlayState.instance.cameraSpeed = newStageData.camera_speed;
		
		//Setting the new positions of the characters (And hiding gf if set to true)
		PlayState.instance.boyfriend.setPosition(newStageData.boyfriend[0], newStageData.boyfriend[1]);
		PlayState.instance.gf.setPosition(newStageData.girlfriend[0], newStageData.girlfriend[1]);
		PlayState.instance.dad.setPosition(newStageData.opponent[0], newStageData.opponent[1]);
		PlayState.instance.gf.visible = !newStageData.hide_girlfriend;
		
		PlayState.instance.BF_X = newStageData.boyfriend[0];
		PlayState.instance.BF_Y = newStageData.boyfriend[1];
		PlayState.instance.GF_X = newStageData.girlfriend[0];
		PlayState.instance.GF_Y = newStageData.girlfriend[1];
		PlayState.instance.DAD_X = newStageData.opponent[0];
		PlayState.instance.DAD_Y = newStageData.opponent[1];
		
		//Camera offsets
		PlayState.instance.boyfriendCameraOffset = newStageData.camera_boyfriend;
		if(PlayState.instance.boyfriendCameraOffset == null) PlayState.instance.boyfriendCameraOffset = [0, 0];

		PlayState.instance.opponentCameraOffset = newStageData.camera_opponent;
		if(PlayState.instance.opponentCameraOffset == null) PlayState.instance.opponentCameraOffset = [0, 0];

		PlayState.instance.girlfriendCameraOffset = newStageData.camera_girlfriend;
		if(PlayState.instance.girlfriendCameraOffset == null) PlayState.instance.girlfriendCameraOffset = [0, 0];
		
		if(value2 == "lua") PlayState.instance.startLuasNamed('stages/' + value1 + '.lua');
		else if(value2 == "hx") PlayState.instance.startHScriptsNamed('stages/' + value1 + '.hx');
		
		if(eventOptions.get("runCustomCallback")) {
			if(value2 == "lua") PlayState.instance.callOnLuas(eventOptions.get("customCallback"), []);
			else if(value2 == "hx") PlayState.instance.callOnHScript(eventOptions.get("customCallback"), []);
		}
	}
}