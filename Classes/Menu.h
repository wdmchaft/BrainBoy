//
//  menu.h
//  BrainBoy
//

//import libraries
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SXParticleSystem.h"
#import "OpenFeint/OpenFeint.h"

#import "OpenFeint/OFHighScoreService.h"
#import "OpenFeint/OpenFeint+UserOptions.h"
#import "SampleOFDelegate.h"

//import level play
#import "Level1Play.h"
#import "About.h"

@interface Menu : SPSprite
{
    
    SPImage *spaceship;    
    SPImage *background;
    SPImage *speechbubble;

    SPTexture *brainboytexture;
    SPImage *brainboy;
    SPTexture *brainboyeyestexture;
    SPImage *brainboyeyes;
    
    SPTexture *playButtonTexture;
    SPButton *playButton;
    
    SPTexture *optionButtonTexture;
    SPButton *optionButton;
    
    SPTexture *achieveTexture;
    SPButton *achieve;
    
    SPButton *tempeyes;
    
    SXParticleSystem *mParticleSystem;
    SXParticleSystem *galaxy1;   
    SXParticleSystem *snowParticle;   

    NSDate *d;
    NSTimer *blink;
    
}

-(void)onTick:(NSTimer *)timer;
-(void)viewscores:(SPEvent*)event;
-(void)eyes:(SPEvent*)event;
-(void)eyes;
-(void)showAchievements:(SPEvent*)event;
-(void)OnOptionButtonTriggered:(SPEvent*)event;
-(void)onPlayButtonTriggered:(SPEvent*)event;  

@end
