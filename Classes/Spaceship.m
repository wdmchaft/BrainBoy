//
//  Ball.m
//  ParallaxSprite Demo
//
//  Created by Brian Ensor on 1/23/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "Spaceship.h"

@implementation Spaceship



- (id)init {
    if (self = [super init]) {
	
        
        // create particle system
        mParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"rocketthrust.pex"];    
        mParticleSystem.emitterX = 164;
        mParticleSystem.emitterY = 65;
        mParticleSystem.pivotX = mParticleSystem.width / 2.0f;
        mParticleSystem.pivotY = mParticleSystem.height / 2.0f;
        
        // add it to the stage and the juggler
        [self addChild:mParticleSystem];
        [[SPStage mainStage].juggler addObject:mParticleSystem];
        
        [mParticleSystem start];
        [mParticleSystem release];
        
        //put spaceship over the top of it
        spaceship = [[[SPImage alloc] initWithContentsOfFile:@"spaceship2.png"] autorelease];
        
        spaceship.x = 140;
        spaceship.y = 40;
        spaceship.scaleX = 0.5f;
        spaceship.scaleY = 0.5f;
        
        [self addChild:spaceship];
        
	}
    return self;
}
- (void)dealloc {
    [super dealloc];
}

@end

