//
//  SHSplashScreen.h
//  Sparrow
//
//  Created by Shilo White on 3/25/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

typedef enum {
    SHSplashScreenTransitionFade,
    SHSplashScreenTransitionZoom,
    SHSplashScreenTransitionSlideUp,
	SHSplashScreenTransitionSlideDown,
	SHSplashScreenTransitionSlideLeft,
	SHSplashScreenTransitionSlideRight,
	SHSplashScreenTransitionFadeUp,
	SHSplashScreenTransitionFadeDown,
	SHSplashScreenTransitionFadeLeft,
	SHSplashScreenTransitionFadeRight,
	SHSplashScreenTransitionZoomUp,
	SHSplashScreenTransitionZoomDown,
	SHSplashScreenTransitionZoomLeft,
	SHSplashScreenTransitionZoomRight
} SHSplashScreenTransition;

typedef enum {    
	SHSplashScreenPhaseBegan,
	SHSplashScreenPhaseStartTransitionEnded,
	SHSplashScreenPhaseEndTransitionBegan,
	SHSplashScreenPhaseEnded,
} SHSplashScreenPhase;

#define SH_EVENT_TYPE_SPLASH_SCREEN @"splashScreen"

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "SPEvent.h"

@interface SHSplashScreen : SPSprite {
	SHSplashScreenTransition mStartTransition;
	SHSplashScreenTransition mEndTransition;
	float mTime;
	float mStartTransitionTime;
	float mEndTransitionTime;
	BOOL mSkipOnTouch;
	BOOL mTransitionOnTouch;
}

@property (nonatomic, assign) SHSplashScreenTransition startTransition;
@property (nonatomic, assign) SHSplashScreenTransition endTransition;
@property (nonatomic, assign) float time;
@property (nonatomic, assign) float startTransitionTime;
@property (nonatomic, assign) float endTransitionTime;
@property (nonatomic, assign) BOOL skipOnTouch;
@property (nonatomic, assign) BOOL transitionOnTouch;

- (id)initWithTime:(float)time;
+ (SHSplashScreen *)splashScreen;
+ (SHSplashScreen *)splashScreenWithTime:(float)time;
@end

@interface SHSplashScreenEvent : SPEvent {
	SHSplashScreenPhase mPhase;
}

@property (nonatomic, readonly) SHSplashScreenPhase phase;

- (id)initWithType:(NSString *)type phase:(SHSplashScreenPhase)phase;
- (id)initWithType:(NSString *)type phase:(SHSplashScreenPhase)phase bubbles:(BOOL)bubbles;
+ (SHSplashScreenEvent *)eventWithType:(NSString *)type phase:(SHSplashScreenPhase)phase;
+ (SHSplashScreenEvent *)eventWithType:(NSString *)type phase:(SHSplashScreenPhase)phase bubbles:(BOOL)bubbles;
@end