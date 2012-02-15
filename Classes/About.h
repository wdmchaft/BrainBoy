//
//  About.h
//  BrainBoy
//
//  Created by Me on 29/10/11.
//  Copyright (c) 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "SPSprite.h"
#import "SXParticleSystem.h"

#import "Menu.h"



@interface About : SPSprite

{
    SPImage *about;
    SPImage *spaceship;    
    SXParticleSystem *mParticleSystem;

    
    SPTexture *backtomenuTexture;
    SPButton *backtomenu;

}
- (void)onBackMenuButtonTriggered:(SPEvent *)event;
- (void)onCountdownFin:(SPEvent *)event;

@end
