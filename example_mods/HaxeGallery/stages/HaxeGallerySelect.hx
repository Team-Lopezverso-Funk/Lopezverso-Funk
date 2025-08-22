/*
By UpDown LeftRight

    [-v 1.0.1-]
- Select Gallery
- View gallery
- PhotoMode
*/
import flixel.util.FlxSave;
import states.PlayState;
import sys.io.File;
import tjson.TJSON;

import objects.Alphabet;

import flixel.FlxSprite;

import flixel.group.FlxTypedSpriteGroup;
import flixel.group.FlxTypedGroup;

import flixel.sound.FlxSound;

import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;

import flixel.addons.display.FlxBackdrop;

import flixel.math.FlxMath;

import flixel.FlxG;

import backend.Song;

import sys.FileSystem;

import StringTools;
import Reflect;
import Std;

// gallery path
var path = "gallery/";

// arrays for galleries and images
var testMass = [];
var galleries:FlxTypedGroup;
var grpText:FlxTypedGroup;

var noGalleries = false;



// some variables
var currentGallery = 0; // always 0 because SScript was removed in psych 1.0
// if no galleries were found
var galNameE:Alphabet = new Alphabet(0, 0, "No galleries found", true, false);
var galNameS:Alphabet = new Alphabet(0, 0, "Please add them", true, false);
var galNameB:Alphabet = new Alphabet(0, 0, "And re-enter the gallery", true, false);
galNameE.cameras = [PlayState.instance.camHUD];
galNameS.cameras = [PlayState.instance.camHUD];
galNameB.cameras = [PlayState.instance.camHUD];

//cool randomHexColor function
function getRandomHexColor(){
    var red = Std.random(256);
    var green = Std.random(256);
    var blue = Std.random(256);
    
    return (red << 16) | (green << 8) | blue;
}

var save = new FlxSave();

function onCreate(){

    
    save.bind('HscriptGallery', "ShadowMario/PsychEngine/VanyaB_gallery");
    currentGallery = save.data.currentGallery;
    
    setVar("gallerySelected", false);
    

    var files = FileSystem.readDirectory(Paths.mods("gallery"));
    
    var folderPathsRead = FileSystem.readDirectory(Paths.mods());
    for (folder in folderPathsRead) {
       if (FileSystem.isDirectory(Paths.mods() + folder) && (FileSystem.exists(Paths.mods() + folder + "/gallery/"))){
        
            var newPath = FileSystem.readDirectory(Paths.mods() + folder + "/gallery");
            for(newFolder in newPath){
                
                    if (StringTools.endsWith(Paths.mods() + folder + "/gallery/" + newFolder, ".json")) {
                        var jsonData = Paths.getTextFromFile(folder + "/gallery/" + newFolder, false);
                        var local = TJSON.parse(jsonData);

                        testMass = testMass.concat(local);
                    
                    }
                    
            }

            
       }
    }

     var background = new FlxBackdrop(Paths.image("menuDesat"));
    add(background);
    background.color = getRandomHexColor();
    background.scrollFactor.set();
    background.alpha = 0.4;
    background.velocity.x = ((4) * 10) * -1;
    background.cameras = [PlayState.instance.camHUD];


    if(testMass.length <= 0) noGalleries = true;

    galleries = new FlxTypedGroup();
    galleries.cameras = [PlayState.instance.camHUD];

    for(i in 0...testMass.length){
        var newGal =  new FlxSprite();
        if(testMass[i].icon != null){
            if(testMass[i].animationName == null){
                newGal.loadGraphic(Paths.image("gallery/selectGallery/" + testMass[i].icon));
            }else{
                newGal.frames = Paths.getSparrowAtlas(testMass[i].icon);
                newGal.animation.addByPrefix('idle', testMass[i].animationName, 24, true);
                newGal.animation.play('idle');
            }
        }else{
            newGal.loadGraphic(Paths.image("gallery/selectGallery/template"));
        }
        if(testMass[i].antialiasing != null)
            newGal.antialiasing = testMass[i].antialiasing;
        else
            newGal.antialiasing = false;
        newGal.screenCenter();
        newGal.y -= 50;
        newGal.x += i * 100;
        newGal.ID = i;
        galleries.add(newGal);
    }


    
    

    if(noGalleries){
        
        //if no galleries were found
        galNameE.screenCenter();
        galNameS.screenCenter();
        galNameB.screenCenter();
        galNameE.y -= galNameS.height + 5;
        //galNameS.y += galNameS.height + 10;
        galNameB.y += galNameB.height + 10;
        add(galNameE);
        add(galNameS);
        add(galNameB);
        return;
    }

    grpText = new FlxTypedGroup();
    grpText.cameras = [PlayState.instance.camHUD];
        

         for (i in 0...testMass.length)
         {

            var galName = new Alphabet(0, FlxG.height - 125, (testMass[i].name != null) ? testMass[i].name : "null name", true, false);
            if(testMass[i].textColor != null){
                if(testMass[i].textColor == "random"){
                    galName.color = getRandomHexColor();
                }else{
                    galName.color = Std.int("0x" + testMass[i].textColor);
                }
            }else{
                galName.color = 0xFFFFFF;
            }

            galName.ID = i;
           grpText.add(galName);
        }


    //pushing galleries info
    // for(gal in gallery){
    //     for (key in Reflect.fields(gal)){
    //         var galleryObject = Reflect.field(gal, key);
    //         galleries.push(galleryObject);
    //     }   
    // }
    
    add(galleries);
    add(grpText);

    updateGallery(0);


}

var idkwhy = 0;
function onUpdate(elapsed){
    idkwhy += elapsed;
    // currentGallery = setVar("currentGallery", currentGallery);
    // currentImage = setVar("currentImage", currentImage);
    // photoModeEnabled = setVar("photoModeEnabled", photoModeEnabled);
    // inGallerySelect = setVar("inGallerySelect", inGallerySelect);

    if(noGalleries){
        for (i in 0...galNameE.length){
            galNameE.members[i].y +=( Math.sin((idkwhy + i)* 20))/8;
            galNameE.members[i].x +=( Math.cos((idkwhy + i)* 20))/8;
        }
        for (i in 3...11){
            galNameB.members[i].y +=( Math.sin((idkwhy + i)* 20))/8;
            galNameB.members[i].x +=( Math.cos((idkwhy + i)* 20))/8;
            galNameB.members[i].color = 0xFF0000;
        }
        return;
    }

    for(i in 0...galleries.length){
        grpText.members[i].x = galleries.members[i].x + (galleries.members[i].width / 2) - (grpText.members[i].width / 2);
    }

    updateGallPos(elapsed);

    if(getVar("gallerySelected")) return;
    inputReg();
}

function inputReg(){
    if(!getVar("gallerySelected"))


    if(testMass.length > 1){
        if (controls.UI_RIGHT_P){
            updateGallery(1);
        }else if (controls.UI_LEFT_P){
            updateGallery(-1);
        }
    }
    if(controls.ACCEPT){
        setVar("gallerySelected", true);
        save.data.currentGallery = currentGallery;
        save.flush();
        // PlayState.SONG = Song.loadFromJson("Haxe-Gallery-Main", "Haxe-Gallery-Main");
        // FlxG.switchState(new PlayState());
        FlxFlicker.flicker(galleries.members[currentGallery], 0.8, 0.1, true, true);
        var accepted = new FlxSound();
        accepted.play(accepted.loadEmbedded(Paths.sound("confirmMenu")));
        new FlxTimer().start(1.5, ()->{
            PlayState.SONG = Song.loadFromJson("Haxe-Gallery-Main", "Haxe-Gallery-Main");
            FlxG.switchState(new PlayState());
            
        });
        
        //setVar("currentGallery", 2);
        //SScript.globalVariables["currentGallery"] = currentGallery;
		return;
    }
}

function updateGallery(idk:Int = 0){
    // FunkinSound.playOnce(Paths.sound('scrollMenu'));
    var scrollSnd = new FlxSound();
    scrollSnd.loadEmbedded(Paths.sound("scrollMenu"));
    scrollSnd.play();
    
    currentGallery = FlxMath.wrap(currentGallery + idk, 0, galleries.length - 1);
}

function updateGallPos(elapsed){
    var speed = 6;
    var change = 0;
    var scaleUnselected = 0.7;

    for(d in galleries){
        d.x = FlxMath.lerp(d.x, ((FlxG.width - d.width) / 2 + (change++ - currentGallery) * 780) + (d.ID * 780), spdCalc(elapsed * speed, 0, 1));
        d.alpha = FlxMath.lerp(d.alpha, (d.ID != currentGallery) ? 0.25 : 1, 0.1);
        d.scale.x = FlxMath.lerp(d.scale.x, (d.ID != currentGallery) ? scaleUnselected : ((testMass[d.ID].scale != null) ? ((testMass[d.ID].scale[0] != null) ? testMass[d.ID].scale[0] : 1.0) : 1.0), 0.1);
        d.scale.y = FlxMath.lerp(d.scale.y, (d.ID != currentGallery) ? scaleUnselected : ((testMass[d.ID].scale != null) ? ((testMass[d.ID].scale[1] != null) ? testMass[d.ID].scale[1] : 1.0) : 1.0), 0.1);
    }
    for(d in grpText){
        d.alpha = FlxMath.lerp(d.alpha, (d.ID != currentGallery) ? 0.25 : 1, 0.1);
    }
        
}

function spdCalc(val, min, max) {
    var newValue = val;
    if(newValue < min){
        newValue = min;
    }else if(newValue > max) {
        newValue = max;
    }
    return newValue;
}