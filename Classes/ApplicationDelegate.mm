//
//  ApplicationDelegate.mm
//  BrainBoy
//
//  WillR
//  Copyright 2012 Will Russell. All rights reserved.
//
//
#import "ApplicationDelegate.h"
#import "SampleOFDelegate.h"
#import "Game.h" 


@implementation ApplicationDelegate

- (id)init
{
    if ((self = [super init]))
    {
        mWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mSparrowView = [[SPView alloc] initWithFrame:mWindow.bounds]; 
        [mWindow addSubview:mSparrowView];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
    

    [SPAudioEngine start];
    
    
    SP_CREATE_POOL(pool);    
    
    [SPStage setSupportHighResolutions:YES]; // that one's just like before
    
    // force high resolution if we're on the iPad:
    if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location == 0)
        [SPStage setContentScaleFactor:2.0f];


    
    Game *game = [[Game alloc] init];        
    mSparrowView.stage = game;
    mSparrowView.multipleTouchEnabled = NO;
    mSparrowView.frameRate = 30.0f;
    [game release];
    
    [mWindow makeKeyAndVisible];
    [mSparrowView start];
    
    SP_RELEASE_POOL(pool);
    
    //appirater
   // [Appirater appLaunched];

    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"firstLaunch",nil]];
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"audio",nil]];
    

}

- (void)applicationWillResignActive:(UIApplication *)application 
{    

    [mSparrowView stop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{

	[mSparrowView start];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"firstLaunch",nil]];

    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [SPPoint purgePool];
    [SPRectangle purgePool];
    [SPMatrix purgePool];    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults] synchronize]; // Add for OpenFeint
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

}

- (void)dealloc 
{
    [SPAudioEngine stop];
    [mSparrowView release];
    [mWindow release]; 
    [ofDelegate release];
    [super dealloc];
    
}



@end
