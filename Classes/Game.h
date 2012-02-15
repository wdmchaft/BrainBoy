//
//  Game.h
//  BrainBoy
//
//  WillR
//  Copyright 2012 Will Russell. All rights reserved.
//
//  Main Libraries
#import <Foundation/Foundation.h>
#import "Sparrow.h"

//  Import level play
#import "Level1Play.h"
#import "About.h"
#import "Menu.h"
#import "Media.h"
#import "BEParallaxSprite.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFHighScoreService.h"
#import "SampleOFDelegate.h"
#import "SHSplashScreen.h"
#import "SHAnimatableColor.h"

@interface Game : SPStage {
        
    SPSprite *currentScene;
    SPSprite *gamecontents;
    
    //universal parallax
    
    BEParallaxSprite *clocksandbacking;
	BEParallaxSprite *cloudsfancy;
    BEParallaxSprite *mountainsfancy;
    BEParallaxSprite *space;

	SPSprite *mContents;  
    About *aboutScene;
    Level1Play *playScene;
    Menu *menuScene;
    
    SPSound *backingtrack;
    SPSoundChannel *backingtrackchannel;
    
    SPSound *level1track;
    SPSoundChannel *level1trackchannel;
    
    SPImage *moon;
    uint level2color;
    
    SPTexture *audiobuttontexture;
    SPButton *audiobutton;
    
}

- (void)showScene:(SPSprite *)scene;
- (void)AboutScreen:(SPEvent *)event;
- (void)AboutScreenCompleted:(SPEvent *)event;
- (void)PlayScreen:(SPEvent *)event;
- (void)PlayScreenCompleted:(SPEvent *)event;
 
- (void)handleChannel:(SPEvent *)event;


// do the level changes
- (void)LevelTwo;
- (void)resetLevel;
- (void)LevelThree;

- (void)LevelFour;
- (void)pausesound;
- (void)unpausesound;


@end
