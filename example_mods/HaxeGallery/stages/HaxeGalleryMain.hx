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

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

import flixel.addons.display.FlxBackdrop;

import flixel.sound.FlxSound;

import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;

import sys.FileSystem;

import StringTools;
import Reflect;
import Std;

// gallery path
var path = "gallery/";

// arrays for galleries and images
var images:FlxTypedGroup;

var noGalleries = false;


// some variables
var currentGallery = 0;
var curImage = 0;
var photoModeEnabled = false;
var inPhotoMode = false;

var background;

var leftArrow;
var rightArrow;

var photoModeIcon;

var topBar;
var bottomBar;
var logo;

var pageText;
var descriptionText;

// if no galleries were found
var galNameE:Alphabet = new Alphabet(0, 0, "No images found", true, false);
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

var gallery = [];
var styleData = {};
var image;

var bgColorDef;
var curRandCol;

var arrows;

var uiItems;

var save = new FlxSave();

function onCreate(){
    save.bind('HscriptGallery', "ShadowMario/PsychEngine/VanyaB_gallery");
    currentGallery = save.data.currentGallery;

    // var files = FileSystem.readDirectory(Paths.modFolders("gallery"));


    //  for (file in files) {
    //     if (StringTools.endsWith(file, ".json")) {
    //         var jsonData = Paths.getTextFromFile(path + file);
    //         var local = TJSON.parse(jsonData);

    //         gallery = gallery.concat(local);

           
    //     }
    //  }

    var files = FileSystem.readDirectory(Paths.mods("gallery"));
    
    var folderPathsRead = FileSystem.readDirectory(Paths.mods());
    for (folder in folderPathsRead) {
       if (FileSystem.isDirectory(Paths.mods() + folder) && (FileSystem.exists(Paths.mods() + folder + "/gallery/"))){
        
            var newPath = FileSystem.readDirectory(Paths.mods() + folder + "/gallery");
            for(newFolder in newPath){
                    if (StringTools.endsWith(Paths.mods() + folder + "/gallery/" + newFolder, ".json")) {
                        var jsonData = Paths.getTextFromFile(folder + "/gallery/" + newFolder, false);
                        var local = TJSON.parse(jsonData);

                        gallery = gallery.concat(local);

                    
                    }
                    
            }

            
       }
    }

    var folderStyleRead = FileSystem.readDirectory(Paths.mods());
        for(st in folderStyleRead){
            if (FileSystem.isDirectory(Paths.mods() + st) && (FileSystem.exists(Paths.mods() + st + "/gallery/styles/"))){
                var newStyle = FileSystem.readDirectory(Paths.mods() + st + "/gallery/styles");
                for(sta in newStyle){
                    if(sta.split('.').slice(0, -1).join('.') == gallery[currentGallery].style){
                        var jsonData = Paths.getTextFromFile(st + "/gallery/styles/" + sta, false);
                        var local = TJSON.parse(jsonData);

                        styleData = local;
                    }
                }
            }
        }

        if(styleData == null){
            var jsonData = Paths.getTextFromFile("/gallery/styles/default.json", false);
            var local = TJSON.parse(jsonData);

            styleData = local;  
        }

     if(gallery[currentGallery].images.length <= 0) noGalleries = true;

     photoModeEnabled = gallery[currentGallery].enablePhotoMode;

    setVar("galleryMusic", gallery[currentGallery].music);

    FlxG.stage.window.title = gallery[currentGallery].name;
    curRandCol = getRandomHexColor();
    if(styleData.background != null){
    bgColorDef = (styleData.background.color == null) ? 0xAAffffff : ((styleData.background.color == "random") ? getRandomHexColor() : Std.int("0xAA" + styleData.background.color));
    

    
    background = new FlxBackdrop();
    if(styleData.background.path != null){
        if(styleData.background.animationName != null){
            background.frames = Paths.getSparrowAtlas(styleData.background.path);
            background.animation.addByPrefix('idle', styleData.background.animationName, (styleData.background.animationSpeed == null) ? 24 : styleData.background.animationSpeed, true);
            background.animation.play('idle');
        }else{
            background.loadGraphic(Paths.image(styleData.background.path));
        }
    }
    
    add(background);
    background.color = bgColorDef;
    background.alpha = 0.4;
    background.scale.x = styleData.background.scale[0];
    background.scale.y = styleData.background.scale[1];
    
    background.x = styleData.background.offset[0];
    background.y = styleData.background.offset[1];

    background.flipX = styleData.background.flipX;
    background.flipY = styleData.background.flipY;

    if(styleData.background.scrolling.enabled){
        background.velocity.x = ((styleData.background.scrolling.speed) * 10) * -1;
    }
    background.cameras = [PlayState.instance.camHUD];
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

    uiItems = new FlxTypedGroup();
    uiItems.cameras = [PlayState.instance.camHUD];


    images = new FlxTypedGroup();
    images.cameras = [PlayState.instance.camHUD];

    for(i in 0...gallery[currentGallery].images.length){
        var newImage = new FlxSprite();
        
        if(gallery[currentGallery].images[i].animationName == null){
            newImage.loadGraphic(Paths.image("gallery/" + gallery[currentGallery].images[i].name));
        }else{
            newImage.frames = Paths.getSparrowAtlas(gallery[currentGallery].images[i].name);
            newImage.animation.addByPrefix('idle', gallery[currentGallery].images[i].animationName, 24, true);
            newImage.animation.play('idle');
        }

        if(gallery[currentGallery].images[i].antialiasing == null){
            newImage.antialiasing = true;
        }else{
            newImage.antialiasing = gallery[currentGallery].images[i].antialiasing;
        }
        
         newImage.screenCenter();
         newImage.y -= 0;
         newImage.ID = i;
         images.add(newImage);
    }


    if(styleData.arrows != null){
    arrows = new FlxTypedGroup();
    arrows.cameras = [PlayState.instance.camHUD];

    leftArrow = new FlxSprite();
    if(styleData.arrows.leftArrow.path != null){
         if(styleData.arrows.leftArrow.animations == null || styleData.arrows.leftArrow.animations.length <= 0){
            leftArrow.loadGraphic(Paths.image(styleData.arrows.leftArrow.path));
         }else{
            leftArrow.frames = Paths.getSparrowAtlas(styleData.arrows.leftArrow.path);
            leftArrow.animation.addByPrefix('static', styleData.arrows.leftArrow.animations.static.prefix, styleData.arrows.leftArrow.animations.static.speed, true);
            leftArrow.animation.addByPrefix('pressed', styleData.arrows.leftArrow.animations.pressed.prefix, styleData.arrows.leftArrow.animations.pressed.speed, false);
            leftArrow.animation.play('static');
         }
         leftArrow.flipX = styleData.arrows.leftArrow.flipX;
         leftArrow.flipY = styleData.arrows.leftArrow.flipY;

        leftArrow.scale.x = styleData.arrows.leftArrow.scale[0];
        leftArrow.scale.y = styleData.arrows.leftArrow.scale[1];

        leftArrow.x = styleData.arrows.leftArrow.pos[0];
        leftArrow.y = styleData.arrows.leftArrow.pos[1];

        leftArrow.antialiasing = styleData.arrows.leftArrow.antialiasing;
        arrows.add(leftArrow);
    }

    

    rightArrow = new FlxSprite();
    if(styleData.arrows.rightArrow.path != null){
         if(styleData.arrows.rightArrow.animations == null || styleData.arrows.rightArrow.animations.length <= 0){
            rightArrow.loadGraphic(Paths.image(styleData.arrows.rightArrow.path));
         }else{
            rightArrow.frames = Paths.getSparrowAtlas(styleData.arrows.rightArrow.path);
            rightArrow.animation.addByPrefix('static', styleData.arrows.rightArrow.animations.static.prefix, styleData.arrows.rightArrow.animations.static.speed, true);
            rightArrow.animation.addByPrefix('pressed', styleData.arrows.rightArrow.animations.pressed.prefix, styleData.arrows.rightArrow.animations.pressed.speed, false);

            //rightArrow.addOffset("static", styleData.arrows.rightArrow.animations.static.offset[0], styleData.arrows.rightArrow.animations.static.offset[1]);
            //rightArrow.addOffset("pressed", styleData.arrows.rightArrow.animations.pressed.offset[0], styleData.arrows.rightArrow.animations.pressed.offset[1]);
            //rightArrow.animation.addOffset('static', 10, 10);

            rightArrow.animation.play('static');
         }
         rightArrow.flipX = styleData.arrows.rightArrow.flipX;
         rightArrow.flipY = styleData.arrows.rightArrow.flipY;

         rightArrow.scale.x = styleData.arrows.rightArrow.scale[0];
         rightArrow.scale.y = styleData.arrows.rightArrow.scale[1];

         rightArrow.x = styleData.arrows.rightArrow.pos[0];
         rightArrow.y = styleData.arrows.rightArrow.pos[1];
         
         rightArrow.antialiasing = styleData.arrows.rightArrow.antialiasing;
         arrows.add(rightArrow);
    }
}
    if(styleData.bottomBar != null){
    bottomBar = new FlxBackdrop(null, 0x1);
    if(styleData.bottomBar.path != null){
        if(styleData.bottomBar.animationName == null){
            bottomBar.loadGraphic(Paths.image(styleData.bottomBar.path));
         }else{
            bottomBar.frames = Paths.getSparrowAtlas(styleData.bottomBar.path);
            bottomBar.animation.addByPrefix('idle', styleData.bottomBar.animationName, styleData.bottomBar.animationSpeed, true);
            bottomBar.animation.play('idle');
         }

        bottomBar.flipX = styleData.bottomBar.flipX;
        bottomBar.flipY = styleData.bottomBar.flipY;

        bottomBar.scale.x = styleData.bottomBar.scale[0];
        bottomBar.scale.y = styleData.bottomBar.scale[1];

        bottomBar.x = styleData.bottomBar.pos[0];
        bottomBar.y = styleData.bottomBar.pos[1];

        bottomBar.antialiasing = styleData.bottomBar.antialiasing;

        if(styleData.bottomBar.scrolling.enabled){
            bottomBar.velocity.x = ((styleData.bottomBar.scrolling.speed) * 10) * -1;
        }
        uiItems.add(bottomBar);
    }
}

    if(styleData.logo != null){
        logo = new FlxBackdrop();
        if(styleData.logo.path != null){
            if(styleData.logo.animationName == null){
                logo.loadGraphic(Paths.image(styleData.logo.path));
            }else{
                logo.frames = Paths.getSparrowAtlas(styleData.logo.path);
                logo.animation.addByPrefix('idle', styleData.logo.animationName, styleData.logo.animationSpeed, true);
                logo.animation.play('idle');
            }

            logo.flipX = styleData.logo.flipX;
            logo.flipY = styleData.logo.flipY;

            logo.scale.x = styleData.logo.scale[0];
            logo.scale.y = styleData.logo.scale[1];

            logo.x = styleData.logo.pos[0];
            logo.y = styleData.logo.pos[1];

            logo.antialiasing = styleData.logo.antialiasing;

            uiItems.add(logo);
        }
    }
if(styleData.topBar != null){
    topBar = new FlxBackdrop(null, 0x1);
    if(styleData.topBar.path != null){
        if(styleData.topBar.animationName == null){
            topBar.loadGraphic(Paths.image(styleData.topBar.path));
         }else{
            topBar.frames = Paths.getSparrowAtlas(styleData.topBar.path);
            topBar.animation.addByPrefix('idle', styleData.topBar.animationName, styleData.topBar.animationSpeed, true);
            topBar.animation.play('idle');
         }

         topBar.flipX = styleData.topBar.flipX;
         topBar.flipY = styleData.topBar.flipY;

         topBar.scale.x = styleData.topBar.scale[0];
        topBar.scale.y = styleData.topBar.scale[1];

        topBar.x = styleData.topBar.pos[0];
        topBar.y = styleData.topBar.pos[1];

        topBar.antialiasing = styleData.topBar.antialiasing;

        if(styleData.topBar.scrolling.enabled){
            topBar.velocity.x = ((styleData.topBar.scrolling.speed) * 10) * -1;
        }
        uiItems.add(topBar);
    }
}

    if(styleData.photoMode != null){
        photoModeIcon = new FlxSprite();
        photoModeIcon.cameras = [PlayState.instance.camHUD];
        if(styleData.photoMode.path != null){
            if(styleData.photoMode.animations.length <= 0){
                photoModeIcon.loadGraphic(Paths.image(styleData.photoMode.path));
            }else{
                if(styleData.photoMode.animations.type == "singleImage"){
                    photoModeIcon.loadGraphic(Paths.image(styleData.photoMode.path), true, styleData.photoMode.animations.width, styleData.photoMode.animations.height);
                    photoModeIcon.animation.add('disabled', styleData.photoMode.animations.disabled.prefix, styleData.photoMode.animations.disabled.speed, true);
                    photoModeIcon.animation.add('enabled', styleData.photoMode.animations.enabled.prefix, styleData.photoMode.animations.enabled.speed, true);
                    photoModeIcon.animation.play('disabled');
                }else if(styleData.photoMode.animations.type == "sparrow"){
                    photoModeIcon.frames = Paths.getSparrowAtlas(styleData.photoMode.path);
                    photoModeIcon.animation.add('disabled', styleData.photoMode.animations.disabled.prefix, styleData.photoMode.animations.disabled.speed, true);
                    photoModeIcon.animation.add('enabled', styleData.photoMode.animations.enabled.prefix, styleData.photoMode.animations.enabled.speed, true);
                    photoModeIcon.animation.play('disabled');
                }
            }

            photoModeIcon.flipX = styleData.photoMode.flipX;
            photoModeIcon.flipY = styleData.photoMode.flipY;

            photoModeIcon.scale.x = styleData.photoMode.scale[0];
            photoModeIcon.scale.y = styleData.photoMode.scale[1];

            photoModeIcon.x = styleData.photoMode.pos[0];
            photoModeIcon.y = styleData.photoMode.pos[1];

            photoModeIcon.antialiasing = styleData.photoMode.antialiasing;
        }
    }

    if(styleData.descriptionText != null){
        descriptionText = new FlxText(0, 0, 0, 'asd', 20);
        descriptionText.setFormat(Paths.font(styleData.descriptionText.font + ".ttf"), 100, Std.int("0xFF" + styleData.descriptionText.color), "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        descriptionText.borderSize = 1.6;
        uiItems.add(descriptionText);
    }

    if(styleData.pageText != null){
        pageText = new FlxText(0, 0, 0, 'asd', 20);
        pageText.setFormat(Paths.font(styleData.pageText.font + ".ttf"), 100, Std.int("0xFF" + styleData.pageText.color), "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        pageText.borderSize = 1.6;
        uiItems.add(pageText);
    }

    add(images);
    

    add(uiItems);
    add(arrows);
    add(photoModeIcon);
    
    updImg(0);

}

var idkwhy = 0;
function onUpdate(elapsed){
    idkwhy += elapsed;

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
    if(styleData.background != null){
    FlxTween.color(background, 0.2, background.color, 
        (gallery[currentGallery].images[curImage].bgColor == null) ? 0xAAffffff :
        ((gallery[currentGallery].images[curImage].bgColor == "default") ? bgColorDef : ((gallery[currentGallery].images[curImage].bgColor == "random") ? Std.int("0xAA" + curRandCol) : Std.int("0xAA" + gallery[currentGallery].images[curImage].bgColor)))
        );
    }

    updateImagePos(elapsed);

    if(arrows != null){
        
        if(Reflect.fields(styleData.arrows.leftArrow.animations).length > 0){
            var temp = leftArrow.animation.name;

            if(leftArrow.animation.finished){
                leftArrow.animation.play('static', true);
                leftArrow.centerOffsets();
                leftArrow.centerOrigin();
            }

        }
        
        if(Reflect.fields(styleData.arrows.rightArrow.animations).length > 0){
            var temp = rightArrow.animation.name;
            if(rightArrow.animation.finished){
                rightArrow.animation.play('static', true);
                rightArrow.centerOffsets();
                rightArrow.centerOrigin();
            }
            
        }
    }

    if(styleData.descriptionText != null){
        descriptionText.x = ((FlxG.width/2) - (descriptionText.width/2)) + styleData.descriptionText.pos[0];
        descriptionText.y = styleData.descriptionText.pos[1];
    }

    if(styleData.pageText != null){
        pageText.x = ((FlxG.width/2) - (pageText.width/2)) + styleData.pageText.pos[0];
        pageText.y = ((FlxG.height) - (pageText.width)) + styleData.pageText.pos[1];
    }
    // if(getVar("gallerySelected")) return;
    inputReg();
}

function inputReg(){
    var moveSpd = 2;
    var imageSpd = (FlxG.keys.pressed.SHIFT) ? moveSpd * 2 : moveSpd;
    var scaleSpd = (FlxG.keys.pressed.SHIFT) ? 0.005 * 2 : 0.005;

    if(!inPhotoMode){
        if (controls.UI_RIGHT_P){
            updImg(1);
        }else if (controls.UI_LEFT_P){
            updImg(-1);
        }
    }else{
        if(controls.UI_RIGHT)
        {
            images.members[curImage].offset.x -= imageSpd;
        }else if(controls.UI_LEFT){
            images.members[curImage].offset.x += imageSpd;
        }

        if(controls.UI_DOWN)
        {
            images.members[curImage].offset.y -= imageSpd;
        }else if(controls.UI_UP){
            images.members[curImage].offset.y += imageSpd;
        }

        if(FlxG.keys.pressed.E){
            if (images.members[curImage].scale.x >= 2 || images.members[curImage].scale.y >= 2) return;
            images.members[curImage].scale.set(images.members[curImage].scale.x + scaleSpd, images.members[curImage].scale.y + scaleSpd);
        }else if(FlxG.keys.pressed.Q){
            if (images.members[curImage].scale.x <= 0.1 || images.members[curImage].scale.y <= 0.1) return;
            images.members[curImage].scale.set(images.members[curImage].scale.x - scaleSpd, images.members[curImage].scale.y - scaleSpd);
        }
    }

    if(photoModeEnabled){
        if (FlxG.keys.justPressed.C){
            var photoModeSfx = new FlxSound();
            photoModeSfx.loadEmbedded(Paths.sound((!inPhotoMode) ? "fav" : "unfav"));
            photoModeSfx.play();

            inPhotoMode = !inPhotoMode;
            if(photoModeIcon != null){
                photoModeIcon.animation.play((inPhotoMode) ? "enabled" : "disabled", true);
            }
        }
    }
}

function updImg(idk:Int = 0){
    // FunkinSound.playOnce(Paths.sound('scrollMenu'));
    var scrollSnd = new FlxSound();
    scrollSnd.loadEmbedded(Paths.sound("scrollMenu"));
    scrollSnd.play();
    
    curImage = FlxMath.wrap(curImage + idk, 0, images.length - 1);

    if(styleData.descriptionText != null && descriptionText != null){
        descriptionText.text = gallery[currentGallery].images[curImage].description;
    }

    if(styleData.pageText != null && pageText != null){
        pageText.text = (curImage + 1) + "!" + images.length;
    }

    if(arrows != null){
        if(idk < 0){
            if(Reflect.fields(styleData.arrows.leftArrow.animations).length > 0){
                leftArrow.animation.play('pressed', true);
                leftArrow.centerOffsets();
                leftArrow.centerOrigin();
            }else{
                leftArrow.color = 0xFF909090;
                FlxTween.color(leftArrow, 0.2, leftArrow.color, 0xFFFFFFFF);
            }
        }else if (idk > 0){
            if(Reflect.fields(styleData.arrows.rightArrow.animations).length > 0){
                rightArrow.animation.play('pressed', true);
                rightArrow.centerOffsets();
                rightArrow.centerOrigin();
            }else{
                rightArrow.color = 0xFF606060;
                FlxTween.color(rightArrow, 0.2, rightArrow.color, 0xFFFFFFFF);
            }
        }
    }

    //debugPrint(Reflect.fields(styleData.arrows.leftArrow.animations).length);
    
}

function updateImagePos(elapsed){
    var speed = 6;
    var change = 0;
    var scaleUnselected = 0.7;
    if(!inPhotoMode){
        for(d in images){
            d.x = FlxMath.lerp(d.x, ((FlxG.width - d.width) / 2 + (change++ - curImage) * 780) + (d.ID * 780), spdCalc(elapsed * speed, 0, 1));

            d.offset.x = FlxMath.lerp(d.offset.x,0, spdCalc(elapsed * speed, 0, 1));
            d.offset.y = FlxMath.lerp(d.offset.y, 0, spdCalc(elapsed * speed, 0, 1));

            d.alpha = FlxMath.lerp(d.alpha, (d.ID != curImage) ? 0.25 : 1, 0.1);
            d.scale.x = FlxMath.lerp(d.scale.x, (d.ID != curImage) ? gallery[currentGallery].images[d.ID].scaleUnSelected[0] : gallery[currentGallery].images[d.ID].scaleSelected[0], 0.1);
            d.scale.y = FlxMath.lerp(d.scale.y, (d.ID != curImage) ? gallery[currentGallery].images[d.ID].scaleUnSelected[1] : gallery[currentGallery].images[d.ID].scaleSelected[1], 0.1);
        }
    }else{
        for(d in images){
            d.alpha = FlxMath.lerp(d.alpha, (d.ID != curImage) ? 0 : 1, 0.1);
        }
    }
    for(d in uiItems){
        d.alpha = FlxMath.lerp(d.alpha, (inPhotoMode) ? 0 : 1, 0.1);
    }
    for(d in arrows){
        d.alpha = FlxMath.lerp(d.alpha, (inPhotoMode) ? 0 : 1, 0.1);
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