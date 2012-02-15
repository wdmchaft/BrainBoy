//
//  Game.mm
//  BrainBoy
//
//  WillR
//  Copyright 2012 Will Russell. All rights reserved.
//

#import "Game.h" 

@implementation Game

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super initWithWidth:width height:height]))
    {
                
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];

        // At the start of the game, call:
        [Media initTextures];
        [Media initAudio];
        
        //autorotate garbage
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDeviceOrientationChanged:)
                                                     name:@"UIDeviceOrientationDidChangeNotification" 
                                                   object:nil];
        

   
        gamecontents = [[SPSprite alloc] init];
        [self addChild:gamecontents]; 
        [gamecontents release];

        
        //parallax, load generic skyline in background
        mContents = [[SPSprite alloc] init];
		mContents.rotation = SP_D2R(90);
		mContents.x = 320;
        mContents.y = 0;
		[gamecontents addChild:mContents];
		[mContents release];
		clocksandbacking = [BEParallaxSprite parallexSpriteWithTexture:[SPTexture textureWithContentsOfFile:@"clocksandbacking.png"]
                                                                 speed:1
                                                             direction:BE_PARALLAX_DIRECTION_LEFT];
		[mContents addChild:clocksandbacking];
		mountainsfancy = [BEParallaxSprite parallexSpriteWithTexture:[SPTexture textureWithContentsOfFile:@"mountainsfancy.png"]
                                                               speed:3
                                                           direction:BE_PARALLAX_DIRECTION_LEFT];
		[mContents addChild:mountainsfancy];
        cloudsfancy = [BEParallaxSprite parallexSpriteWithTexture:[SPTexture textureWithContentsOfFile:@"cloudsfancy.png"]
                                                            speed:2
                                                        direction:BE_PARALLAX_DIRECTION_LEFT];
		[mContents addChild:cloudsfancy];
        space = [BEParallaxSprite parallexSpriteWithTexture:[SPTexture textureWithContentsOfFile:@"space.png"]
                                                            speed:1
                                                        direction:BE_PARALLAX_DIRECTION_LEFT];
        space.alpha = 0.0f;
		[mContents addChild:space]; 
        
        audiobuttontexture = [SPTexture textureWithContentsOfFile:@"audio-on.png"];
        
        audiobutton = [SPButton buttonWithUpState:audiobuttontexture];
        
        audiobutton.x = 0;
        audiobutton.y = 430;
    
        [audiobutton addEventListener:@selector(handleChannel:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        [self addChild:audiobutton];
        
        
        backingtrack = [SPSound soundWithContentsOfFile:@"starfighter.aifc"]; 
        
        backingtrackchannel = [[backingtrack createChannel]retain];
        backingtrackchannel.loop = YES;
        backingtrackchannel.volume = 0.8f;

        [backingtrackchannel play]; 
            
        
        
        
        
        level1track = [SPSound soundWithContentsOfFile:@"spacemonkey.aifc"]; 
        
        level1trackchannel = [[level1track createChannel]retain];
        level1trackchannel.loop = YES;
        level1trackchannel.volume = 0.8f;        
        
        
        Menu *menuScene = [[Menu alloc] init];
        [menuScene release];
        [self showScene:menuScene];

    }
    return self;
}

-(void)handleChannel:(SPEvent*)event
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"audio"] == YES)  {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"audio"];
        [audiobutton setUpState:[SPTexture textureWithContentsOfFile:@"audio-off.png"]];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"level1"] == YES)  {
            [level1trackchannel pause]; 
        } else {
        [backingtrackchannel pause]; 
        }


    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"audio"] == NO) {
        [audiobutton setUpState:[SPTexture textureWithContentsOfFile:@"audio-on.png"]];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"audio"];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"level1"] == YES)  {
            [level1trackchannel play]; 
        } else {
            [backingtrackchannel play]; 
        }


    }
    
}


- (void)onDeviceOrientationChanged:(UIEvent *)event 
{	
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation;
    
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft ||
        deviceOrientation == UIDeviceOrientationLandscapeRight)
        
    {  
        
        [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation];
        
        // update your game contents here, as described above
        NSLog(@"Device Orientation changed: %i", deviceOrientation);
       
        if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        {  
            gamecontents.rotation = SP_D2R(-180);
            gamecontents.x = 320;
            gamecontents.y = 480;
            
            [OpenFeint setDashboardOrientation:UIInterfaceOrientationLandscapeLeft];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];

            
        }
        else {
            gamecontents.rotation = SP_D2R(0);
            gamecontents.x = 0;
            gamecontents.y = 0;
            
            [OpenFeint setDashboardOrientation:UIInterfaceOrientationLandscapeRight];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            
        }
    }
}

- (void)showScene:(SPSprite *)scene {
    if ([gamecontents containsChild:currentScene]) {
        [gamecontents removeChild:currentScene];
    }
    
    [gamecontents addChild:scene];
    currentScene = scene;
}

-(void)LevelTwo
{

    SPTween *tween = [SPTween tweenWithTarget:cloudsfancy time:2.0f];
    [tween animateProperty:@"alpha" targetValue:0.0f];        
    [[SPStage mainStage].stage.juggler addObject:tween];

    SPTween *tween2 = [SPTween tweenWithTarget:mountainsfancy time:2.0f];
    [tween2 animateProperty:@"alpha" targetValue:0.5f];        
    [[SPStage mainStage].stage.juggler addObject:tween2];
    
    SPTween *tween3 = [SPTween tweenWithTarget:space time:2.0f];
    [tween3 animateProperty:@"alpha" targetValue:0.2f];        
    [[SPStage mainStage].stage.juggler addObject:tween3];
}
-(void)LevelThree
{
    
    SPTween *tween = [SPTween tweenWithTarget:cloudsfancy time:2.0f];
    [tween animateProperty:@"alpha" targetValue:0.0f];        
    [[SPStage mainStage].stage.juggler addObject:tween];
    
    SPTween *tween2 = [SPTween tweenWithTarget:mountainsfancy time:2.0f];
    [tween2 animateProperty:@"alpha" targetValue:0.3f];        
    [[SPStage mainStage].stage.juggler addObject:tween2];
    
    SPTween *tween3 = [SPTween tweenWithTarget:space time:2.0f];
    [tween3 animateProperty:@"alpha" targetValue:0.5f];        
    [[SPStage mainStage].stage.juggler addObject:tween3];
}
-(void)LevelFour
{
    
    SPTween *tween2 = [SPTween tweenWithTarget:mountainsfancy time:2.0f];
    [tween2 animateProperty:@"alpha" targetValue:0.2f];        
    [[SPStage mainStage].stage.juggler addObject:tween2];
    
    SPTween *tween3 = [SPTween tweenWithTarget:space time:2.0f];
    [tween3 animateProperty:@"alpha" targetValue:0.8f];        
    [[SPStage mainStage].stage.juggler addObject:tween3];
}
-(void)pausesound
{
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"audio"] == YES) {
    [level1trackchannel pause]; 
     }

}
-(void)unpausesound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"audio"] == YES) {
        [level1trackchannel play]; 
    }
    
}
-(void)resetLevel
{
    SPTween *tween = [SPTween tweenWithTarget:cloudsfancy time:1.0f];
    [tween animateProperty:@"alpha" targetValue:1.0f];        
    [[SPStage mainStage].stage.juggler addObject:tween];
    
    SPTween *tween2 = [SPTween tweenWithTarget:mountainsfancy time:1.0f];
    [tween2 animateProperty:@"alpha" targetValue:1.0f];        
    [[SPStage mainStage].stage.juggler addObject:tween2];
    
    SPTween *tween3 = [SPTween tweenWithTarget:space time:1.0f];
    [tween3 animateProperty:@"alpha" targetValue:0.0f];        
    [[SPStage mainStage].stage.juggler addObject:tween3];

}
-(void)AboutScreen:(SPEvent *)event
{
    About *aboutScene = [[About alloc] init];    
    
    //initialize the splash screen with an idle time of 5.0f and default transitions
    SHSplashScreen *splashScreen = [SHSplashScreen splashScreenWithTime:0.0f];
    
    //initialize and add an image to the splash screen
    SPImage *logo = [SPImage imageWithContentsOfFile:@"loading.png"];
    [splashScreen addChild:logo];
    
    //add the splash screen to the stage, it will automatically start and automatically remove itself from the stage when finished.
    [self addChild:splashScreen];
    
    clocksandbacking.speed = 1;
    mountainsfancy.speed = 5;
    cloudsfancy.speed = 3;
    
    [self showScene:aboutScene];
    [aboutScene release];
}

-(void)AboutScreenCompleted:(SPEvent *)event
{
    Menu *menuScene = [[Menu alloc] init];     
    
    //initialize the splash screen with an idle time of 5.0f and default transitions
    SHSplashScreen *splashScreen = [SHSplashScreen splashScreenWithTime:0.0f];
    
    //initialize and add an image to the splash screen
    SPImage *logo = [SPImage imageWithContentsOfFile:@"loading.png"];
    [splashScreen addChild:logo];
    
    //add the splash screen to the stage, it will automatically start and automatically remove itself from the stage when finished.
    [self addChild:splashScreen];
    
    clocksandbacking.speed = 1;
    mountainsfancy.speed = 3;
    cloudsfancy.speed = 2;
    
    [self showScene:menuScene]; 
    [menuScene release];

}

-(void)PlayScreen:(SPEvent *)event
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        
        //initialize the splash screen with an idle time of 5.0f and default transitions
        SHSplashScreen *startScreen = [SHSplashScreen splashScreenWithTime:4.0f];
        startScreen.startTransition = SHSplashScreenTransitionSlideLeft;

        startScreen.endTransition = SHSplashScreenTransitionSlideRight;
        
        //initialize and add an image to the splash screen
        SPImage *startscreen = [SPImage imageWithContentsOfFile:@"startupscreen.png"];
        [startScreen addChild:startscreen];
        
        //add the splash screen to the stage, it will automatically start and automatically remove itself from the stage when finished.
        [self addChild:startScreen];
    }
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"level1",nil]];
    
    
    [backingtrackchannel stop]; 

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"audio"] == YES)  {
        
        [level1trackchannel play]; 

    }
    

    Level1Play *playScene = [[Level1Play alloc] init];
    
    clocksandbacking.speed = 2;
    mountainsfancy.speed = 7;
    cloudsfancy.speed = 5;
    
    [self showScene:playScene];

    
    [playScene release];

}

-(void)PlayScreenCompleted:(SPEvent *)event
{ 
    
    [level1trackchannel pause]; 
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"level1"];

    
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"audio"] == YES)  {
        
        [backingtrackchannel play]; 
        
    }

    Menu *menuScene = [[Menu alloc] init];
    
    //initialize the splash screen with an idle time of 5.0f and default transitions
    SHSplashScreen *splashScreen = [SHSplashScreen splashScreenWithTime:0.0f];
    
    //initialize and add an image to the splash screen
    SPImage *logo = [SPImage imageWithContentsOfFile:@"loading.png"];
    [splashScreen addChild:logo];
    
    //add the splash screen to the stage, it will automatically start and automatically remove itself from the stage when finished.
    [self addChild:splashScreen];
    
    space.alpha = 0.0f;
    mountainsfancy.alpha = 1.0f;
    cloudsfancy.alpha = 1.0f;
    
    clocksandbacking.speed = 1;
    mountainsfancy.speed = 3;
    cloudsfancy.speed = 2;
    
    [self showScene:menuScene];

    [menuScene release];

}

-(void)dealloc{
    
    // and at the end, release all data.
    [Media releaseTextures];
    [Media releaseAudio];
    
}

@end
