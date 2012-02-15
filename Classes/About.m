//
//  About.m
//  BrainBoy
//
//  Created by Me on 29/10/11.
//  Copyright (c) 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "About.h"
#import "Game.h" 

@implementation About

- (id)init {
    if ((self = [super init])) {
        
        //load about
        about = [[SPImage alloc] initWithContentsOfFile:@"about.png"];
        about.x = 400;
        about.y = 0;
        [self addChild:about]; 
        [about release];

        SPTween *abouttween = [SPTween tweenWithTarget:about time:2.0f];
        [abouttween animateProperty:@"x" targetValue:0];        
        [[SPStage mainStage].stage.juggler addObject:abouttween];
        
        
        // create particle system
        mParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"rocketthrust.pex"];    
        mParticleSystem.emitterX = 254;
        mParticleSystem.emitterY = -40;
        
        mParticleSystem.pivotX = mParticleSystem.width / 2.0f;
        mParticleSystem.pivotY = mParticleSystem.height / 2.0f;
        
        // add it to the stage and the juggler
        [self addChild:mParticleSystem];
        [[SPStage mainStage].juggler addObject:mParticleSystem];
        
        [mParticleSystem start];
        [mParticleSystem release];
        
        //put spaceship over the top of it
        spaceship = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"spaceship"]];
        
        spaceship.x = 230;
        spaceship.y = -80;
        
        spaceship.scaleX = 0.5f;
        spaceship.scaleY = 0.5f;
        
        [self addChild:spaceship];
        
        [spaceship release];

        SPTween *tween1 = [SPTween tweenWithTarget:spaceship time:15.0f];
        [tween1 animateProperty:@"y" targetValue:spaceship.y + 750];
        tween1.loop = SPLoopTypeRepeat;
        [[SPStage mainStage].juggler addObject:tween1];
        
        
        SPTween *tween2 = [SPTween tweenWithTarget:mParticleSystem time:15.0f];
        [tween2 animateProperty:@"y" targetValue:mParticleSystem.emitterY + 750];
        tween2.loop = SPLoopTypeRepeat;
        [[SPStage mainStage].juggler addObject:tween2];
        
        
        
        backtomenuTexture = [Media atlasTexture:@"backtomenuiphone"];
        
        
        backtomenu = [[SPButton alloc] initWithUpState:backtomenuTexture text:@""];
        backtomenu.alpha = 1.0f;
        backtomenu.x = -5;
        backtomenu.y = 180;
        [backtomenu addEventListener:@selector(onBackMenuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:backtomenu];
        [backtomenu release];

        
    }
return self;
}

- (void)onBackMenuButtonTriggered:(SPEvent *)event
{
    
    SPTween *abouttween = [SPTween tweenWithTarget:about time:2.5f];
    [abouttween animateProperty:@"x" targetValue:400];        
    [[SPStage mainStage].stage.juggler addObject:abouttween];
        [abouttween addEventListener:@selector(onCountdownFin:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    
    
    SPTween *tween3 = [SPTween tweenWithTarget:spaceship time:2.5f];
    [tween3 animateProperty:@"alpha" targetValue:0.0f];
    [[SPStage mainStage].juggler addObject:tween3];
    
    
    SPTween *tween4 = [SPTween tweenWithTarget:mParticleSystem time:2.5f];
    [tween4 animateProperty:@"alpha" targetValue:0.0f];
    [[SPStage mainStage].juggler addObject:tween4];
    
     [backtomenu removeEventListener:@selector(onBackMenuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    
}

- (void)onCountdownFin:(SPEvent *)event
{
    
    [(Game *)self.stage AboutScreenCompleted:(SPEvent *)event];

    
}
- (void) dealloc
{
    

    [super dealloc];
    
}

@end
