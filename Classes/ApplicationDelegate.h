//
//  ApplicationDelegate.h
//  BrainBoy
//
//  WillR
//  Copyright 2012 Will Russell. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@class SampleOFDelegate;

@interface ApplicationDelegate : NSObject 
{
    SampleOFDelegate *ofDelegate;

  @private 
    UIWindow *mWindow;
    SPView *mSparrowView;

}

@end
