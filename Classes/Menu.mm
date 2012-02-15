//
//  menu.mm
//  BrainBoy
//
//  Created by Will Russell on 10/30/10.
//  Copyright 31LL.com 2010. All rights reserved.
//


#import "Menu.h" 
#import "Game.h" 



// --- class implementation ------------------------------------------------------------------------

@implementation Menu


- (id)init {
    if ((self = [super init])) {
     
        //timer
        d = [NSDate dateWithTimeIntervalSinceNow: 2.0];
        blink = [[NSTimer alloc] initWithFireDate: d
                                                  interval: arc4random_uniform(10) 
                                                    target: self
                                                  selector:@selector(onTick:)
                                                  userInfo:nil repeats:YES];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:blink forMode: NSDefaultRunLoopMode];
        [blink release]; 
        

        //add particle system
        snowParticle = [[SXParticleSystem alloc] initWithContentsOfFile:@"snow.pex"];    
        snowParticle.emitterY = 400;
        snowParticle.emitterX = -120;
        snowParticle.alpha = 0.15f;
        snowParticle.rotation = SP_D2R(270);
        snowParticle.pivotX = snowParticle.width / 2.0f;
        snowParticle.pivotY = snowParticle.height / 2.0f;
        
        // add it to the stage and the juggler
        [self addChild:snowParticle];
        [[SPStage mainStage].juggler addObject:snowParticle];
        
        [snowParticle start];
        [snowParticle release];
        
        //brain logo
        SPTextField *textField = [SPTextField textFieldWithWidth:210 height:80 text:@"BRAINBOY" fontName:@"Funky" fontSize:35.0f color:0xffffff];
        textField.x = 315;
        textField.rotation = SP_D2R(90);
        textField.y = -300;
        [self addChild:textField];
        
        SPTween *brainboytexttween = [SPTween tweenWithTarget:textField time:6.0f];
        [brainboytexttween animateProperty:@"y" targetValue:20];
        brainboytexttween.loop = SPLoopTypeNone;
        
        [[SPStage mainStage].juggler addObject:brainboytexttween];

        
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
        
        
        //load backing
        background = [[SPImage alloc] initWithContentsOfFile:@"backgroundmenu.png"];
        background.x = 0;
        background.y = 0;
        [self addChild:background]; 
        [background release];
        
              //playbutton loader
        playButtonTexture = [Media atlasTexture:@"play"];
        playButton = [[SPButton alloc] initWithUpState:playButtonTexture text:@""];
        playButton.alpha = 1.0f;
        playButton.x = 200;
        playButton.y = 280;
        [playButton addEventListener:@selector(onPlayButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:playButton]; 
        [playButton release];

        SPTween *playbuttontween = [SPTween tweenWithTarget:playButton time:1.0f];
        [playbuttontween animateProperty:@"scaleX" targetValue:1.2f];
        [playbuttontween animateProperty:@"scaleY" targetValue:1.2f];
        playbuttontween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:playbuttontween];
        
        //options loader
        optionButtonTexture = [Media atlasTexture:@"options"];
        optionButton = [[SPButton alloc] initWithUpState:optionButtonTexture text:@""];
        optionButton.alpha = 1.0f;
        optionButton.x = 145;
        optionButton.y = 280;
        [optionButton addEventListener:@selector(OnOptionButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:optionButton]; 
        [optionButton release];
        
        SPTween *optionbuttontween = [SPTween tweenWithTarget:optionButton time:1.0f];
        [optionbuttontween animateProperty:@"scaleX" targetValue:1.2f];
        [optionbuttontween animateProperty:@"scaleY" targetValue:1.2f];
        optionbuttontween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:optionbuttontween];

        
        //achievement loader
        SPTexture *achieveButtonTexture = [Media atlasTexture:@"achievements"];
        achieve = [[SPButton alloc] initWithUpState:achieveButtonTexture text:@""];
        achieve.alpha = 1.0f;
        achieve.x = 88;
        achieve.y = 250;
        [achieve addEventListener:@selector(showAchievements:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:achieve];  
        [achieve release];

        SPTween *achievebuttontween = [SPTween tweenWithTarget:achieve time:1.0f];
        [achievebuttontween animateProperty:@"scaleX" targetValue:1.2f];
        [achievebuttontween animateProperty:@"scaleY" targetValue:1.2f];
        achievebuttontween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:achievebuttontween];
        
        //load eyes
        brainboyeyes = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"closedeyes"]];
        brainboyeyes.x = 163;
        brainboyeyes.y = 83;
        brainboyeyes.alpha = 0.0f;
        [self addChild:brainboyeyes]; 
        [brainboyeyes release];

        
        //eye clicker
        SPTexture *tempButtonTexture = [SPTexture textureWithContentsOfFile:@"trans.png"];
        tempeyes= [[SPButton alloc] initWithUpState:tempButtonTexture text:@""];
        tempeyes.x = 80;
        tempeyes.y = 25;
        [tempeyes addEventListener:@selector(eyes:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:tempeyes];  
        [tempeyes release];
        
        

    }
    return self;
}

-(void)viewscores:(SPEvent*)event{
    
    [OpenFeint launchDashboard];
    
}

-(void)onTick:(NSTimer *)timer
{
    
    brainboyeyes = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"closedeyes"]];
    brainboyeyes.x = 163;
    brainboyeyes.y = 83;
    brainboyeyes.alpha = 1.0f;
    [self addChild:brainboyeyes]; 
    [brainboyeyes release];

    SPTween *eyesopen = [SPTween tweenWithTarget:brainboyeyes time:0.25f];
    [eyesopen animateProperty:@"alpha" targetValue:0.0f];
    
    [[SPStage mainStage].juggler addObject:eyesopen];
}



-(void)eyes:(SPEvent *)event {
    brainboyeyes = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"closedeyes"]];
    brainboyeyes.x = 163;
    brainboyeyes.y = 83;
    brainboyeyes.alpha = 1.0f;
    [self addChild:brainboyeyes]; 
    [brainboyeyes release];

    SPTween *eyesopen = [SPTween tweenWithTarget:brainboyeyes time:0.25f];
    [eyesopen animateProperty:@"alpha" targetValue:0.0f];
    
    [[SPStage mainStage].juggler addObject:eyesopen];
}

-(void)eyes {
    brainboyeyes = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"closedeyes"]];
    brainboyeyes.x = 163;
    brainboyeyes.y = 83;
    brainboyeyes.alpha = 1.0f;
    [self addChild:brainboyeyes]; 
    [brainboyeyes release];

    SPTween *eyesopen = [SPTween tweenWithTarget:brainboyeyes time:0.25f];
    [eyesopen animateProperty:@"alpha" targetValue:0.0f];
    
    [[SPStage mainStage].juggler addObject:eyesopen];
}


-(void)showAchievements:(SPEvent *)event {
    
    [OpenFeint launchDashboard];

}

-(void)OnOptionButtonTriggered:(SPEvent *)event {
    
    [(Game *)self.stage AboutScreen:(SPEvent *)event];
}


- (void)onPlayButtonTriggered:(SPEvent *)event
{

    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [(Game *)self.stage PlayScreen:(SPEvent *)event];

    
}



- (void) dealloc
{

    [super dealloc];
    
}



@end