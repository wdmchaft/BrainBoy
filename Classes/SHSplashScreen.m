//
//  SHSplashScreen.m
//  Sparrow
//
//  Created by Shilo White on 3/25/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#define PI 3.14159265359f
#define SP_D2R(deg) ((deg) / 180.0f * PI)

#import "SHSplashScreen.h"
#import "SPEvent.h"
#import "SPTouchEvent.h"
#import "SPTween.h"
#import "SPStage.h"
#import "SPJuggler.h"
#import "SPPoint.h"

@interface SHSplashScreen ()
- (void)beginStartTransition;
- (void)beginEndTransition;
- (void)dispatchEventWithPhase:(SHSplashScreenPhase)phase;
@end

@implementation SHSplashScreen

@synthesize startTransition = mStartTransition;
@synthesize endTransition = mEndTransition;
@synthesize time = mTime;
@synthesize startTransitionTime = mStartTransitionTime;
@synthesize endTransitionTime = mEndTransitionTime;
@synthesize skipOnTouch = mSkipOnTouch;
@synthesize transitionOnTouch = mTransitionOnTouch;

- (id)init {
	return [self initWithTime:2.0f];
}

- (id)initWithTime:(float)time {
	if (self = [super init]) {
		mStartTransition = SHSplashScreenTransitionFade;
		mEndTransition = SHSplashScreenTransitionFade;
		mTime = time;
		mStartTransitionTime = 0.0f;
		mEndTransitionTime = 0.5f;
		mTransitionOnTouch = YES;
		[self addEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	}
	return self;
}

+ (SHSplashScreen *)splashScreen {
	return [[[SHSplashScreen alloc] init] autorelease];
}

+ (SHSplashScreen *)splashScreenWithTime:(float)time {
	return [[[SHSplashScreen alloc] initWithTime:time] autorelease];
}

- (void)setSkipOnTouch:(BOOL)skipOnTouch {
	if (skipOnTouch != mSkipOnTouch) {
		mSkipOnTouch = skipOnTouch;
		if (mSkipOnTouch) {
			mTransitionOnTouch = NO;
		}
	}
}

- (void)setTransitionOnTouch:(BOOL)transitionOnTouch {
	if (transitionOnTouch != mTransitionOnTouch) {
		mTransitionOnTouch = transitionOnTouch;
		if (mTransitionOnTouch) {
			mSkipOnTouch = NO;
		}
	}
}

- (void)onAddedToStage:(SPEvent *)event {
	[self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	[self.stage addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
	[self beginStartTransition];
}

- (void)onTouch:(SPTouchEvent *)event {
	SPTouch *touch = [[event touchesWithTarget:self.stage andPhase:SPTouchPhaseBegan] anyObject];
	if (touch) {
		if (mSkipOnTouch) {
			[self.stage removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
			[self.stage.juggler removeTweensWithTarget:self];
			[self dispatchEventWithPhase:SHSplashScreenPhaseEnded];
			[self removeFromParent];
		} else if (mTransitionOnTouch) {
			[self.stage removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
			[self.stage.juggler removeTweensWithTarget:self];
			[self beginEndTransition];
		}
	}
}

- (void)beginStartTransition {
	[self dispatchEventWithPhase:SHSplashScreenPhaseBegan];
	if (!mStartTransitionTime) {
		[[self.stage.juggler delayInvocationAtTarget:self byTime:mTime] beginEndTransition];
		return;
	}
	
	SPTween *startTween = [SPTween tweenWithTarget:self time:mStartTransitionTime];
	switch (mStartTransition) {
		case SHSplashScreenTransitionFade:
			self.alpha = 0;
			[startTween animateProperty:@"alpha" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoom:;
			SPPoint *centerPoint = [self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]];
			self.x = centerPoint.x;
			self.y = centerPoint.y;
			self.width = self.height = 1;
			[startTween animateProperty:@"x" targetValue:0];
			[startTween animateProperty:@"y" targetValue:0];
			[startTween animateProperty:@"scaleX" targetValue:1.0f];
			[startTween animateProperty:@"scaleY" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionSlideUp:
			self.y = [self globalToLocal:[SPPoint pointWithX:0 y:self.stage.height]].y;
			[startTween animateProperty:@"y" targetValue:0];
			break;
		case SHSplashScreenTransitionSlideDown:
			self.y = -self.height;
			[startTween animateProperty:@"y" targetValue:0];
			break;
		case SHSplashScreenTransitionSlideLeft:
			self.x = [self globalToLocal:[SPPoint pointWithX:self.stage.width y:self.stage.height]].x;
			[startTween animateProperty:@"x" targetValue:0];
			break;
		case SHSplashScreenTransitionSlideRight:
			self.x = -self.width;
			[startTween animateProperty:@"x" targetValue:0];
			break;
		case SHSplashScreenTransitionFadeUp:
			NSLog(@"hi");
			self.alpha = 0;
			self.y = [self globalToLocal:[SPPoint pointWithX:0 y:self.stage.height]].y;
			[startTween animateProperty:@"alpha" targetValue:1.0f];
			[startTween animateProperty:@"y" targetValue:0];
			break;
		case SHSplashScreenTransitionFadeDown:
			self.alpha = 0;
			self.y = -self.height;
			[startTween animateProperty:@"alpha" targetValue:1.0f];
			[startTween animateProperty:@"y" targetValue:0];
			break;
		case SHSplashScreenTransitionFadeLeft:
			self.alpha = 0;
			self.x = [self globalToLocal:[SPPoint pointWithX:self.stage.width y:self.stage.height]].x;
			[startTween animateProperty:@"alpha" targetValue:1.0f];
			[startTween animateProperty:@"x" targetValue:0];
			break;
		case SHSplashScreenTransitionFadeRight:
			self.alpha = 0;
			self.x = -self.width;
			[startTween animateProperty:@"alpha" targetValue:1.0f];
			[startTween animateProperty:@"x" targetValue:0];
			break;
		case SHSplashScreenTransitionZoomUp:
			self.x = [self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].x;
			self.y = [self globalToLocal:[SPPoint pointWithX:0 y:self.stage.height]].y;
			self.width = self.height = 1;
			[startTween animateProperty:@"x" targetValue:0];
			[startTween animateProperty:@"y" targetValue:0];
			[startTween animateProperty:@"scaleX" targetValue:1.0f];
			[startTween animateProperty:@"scaleY" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoomDown:
			self.x = [self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].x;
			self.y = 0;
			self.width = self.height = 1;
			[startTween animateProperty:@"x" targetValue:0];
			[startTween animateProperty:@"y" targetValue:0];
			[startTween animateProperty:@"scaleX" targetValue:1.0f];
			[startTween animateProperty:@"scaleY" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoomLeft:
			self.x = [self globalToLocal:[SPPoint pointWithX:self.stage.width y:self.stage.height]].x;
			self.y = [self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].y;
			self.width = self.height = 1;
			[startTween animateProperty:@"x" targetValue:0];
			[startTween animateProperty:@"y" targetValue:0];
			[startTween animateProperty:@"scaleX" targetValue:1.0f];
			[startTween animateProperty:@"scaleY" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoomRight:
			self.x = 0;
			self.y = [self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].y;
			self.width = self.height = 1;
			[startTween animateProperty:@"x" targetValue:0];
			[startTween animateProperty:@"y" targetValue:0];
			[startTween animateProperty:@"scaleX" targetValue:1.0f];
			[startTween animateProperty:@"scaleY" targetValue:1.0f];
			break;
	}
	[startTween addEventListener:@selector(onStartTransitionCompleted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];	
	[self.stage.juggler addObject:startTween];
}

- (void)onStartTransitionCompleted:(SPEvent *)event {
	[self dispatchEventWithPhase:SHSplashScreenPhaseStartTransitionEnded];
	[[self.stage.juggler delayInvocationAtTarget:self byTime:mTime] beginEndTransition];
}

- (void)beginEndTransition {
	if (!mEndTransitionTime) {
		[self dispatchEventWithPhase:SHSplashScreenPhaseEnded];
		[self removeFromParent];
		return;
	}
	[self dispatchEventWithPhase:SHSplashScreenPhaseEndTransitionBegan];
	if (mTransitionOnTouch) [self.stage removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
	
	SPTween *endTween = [SPTween tweenWithTarget:self time:mEndTransitionTime];
	switch (mEndTransition) {
		case SHSplashScreenTransitionFade:
			[endTween animateProperty:@"alpha" targetValue:0];
			break;
		case SHSplashScreenTransitionZoom:;
			SPPoint *centerPoint = [self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]];
			[endTween animateProperty:@"x" targetValue:centerPoint.x];
			[endTween animateProperty:@"y" targetValue:centerPoint.y];
			[endTween animateProperty:@"width" targetValue:1.0f];
			[endTween animateProperty:@"height" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionSlideUp:
			[endTween animateProperty:@"y" targetValue:-self.height];
			break;
		case SHSplashScreenTransitionSlideDown:
			[endTween animateProperty:@"y" targetValue:[self globalToLocal:[SPPoint pointWithX:0 y:self.stage.height]].y];
			break;
		case SHSplashScreenTransitionSlideLeft:
			[endTween animateProperty:@"x" targetValue:-self.width];
			break;
		case SHSplashScreenTransitionSlideRight:
			[endTween animateProperty:@"x" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width y:self.stage.height]].x];
			break;
		case SHSplashScreenTransitionFadeUp:
			[endTween animateProperty:@"alpha" targetValue:0];
			[endTween animateProperty:@"y" targetValue:-self.height];
			break;
		case SHSplashScreenTransitionFadeDown:
			[endTween animateProperty:@"alpha" targetValue:0];
			[endTween animateProperty:@"y" targetValue:[self globalToLocal:[SPPoint pointWithX:0 y:self.stage.height]].y];
			break;
		case SHSplashScreenTransitionFadeLeft:
			[endTween animateProperty:@"alpha" targetValue:0];
			[endTween animateProperty:@"x" targetValue:-self.width];
			break;
		case SHSplashScreenTransitionFadeRight:
			[endTween animateProperty:@"alpha" targetValue:0];
			[endTween animateProperty:@"x" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width y:self.stage.height]].x];
			break;
		case SHSplashScreenTransitionZoomUp:
			[endTween animateProperty:@"x" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].x];
			[endTween animateProperty:@"y" targetValue:0];
			[endTween animateProperty:@"width" targetValue:1.0f];
			[endTween animateProperty:@"height" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoomDown:
			[endTween animateProperty:@"x" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].x];
			[endTween animateProperty:@"y" targetValue:[self globalToLocal:[SPPoint pointWithX:0 y:self.stage.height]].y];
			[endTween animateProperty:@"width" targetValue:1.0f];
			[endTween animateProperty:@"height" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoomLeft:
			[endTween animateProperty:@"x" targetValue:0];
			[endTween animateProperty:@"y" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].y];
			[endTween animateProperty:@"width" targetValue:1.0f];
			[endTween animateProperty:@"height" targetValue:1.0f];
			break;
		case SHSplashScreenTransitionZoomRight:
			[endTween animateProperty:@"x" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width y:self.stage.height]].x];
			[endTween animateProperty:@"y" targetValue:[self globalToLocal:[SPPoint pointWithX:self.stage.width/2 y:self.stage.height/2]].y];
			[endTween animateProperty:@"width" targetValue:1.0f];
			[endTween animateProperty:@"height" targetValue:1.0f];
			break;
	}
	[endTween addEventListener:@selector(onEndTransitionCompleted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];	
	[self.stage.juggler addObject:endTween];
}

- (void)onEndTransitionCompleted:(SPEvent *)event {
	[self dispatchEventWithPhase:SHSplashScreenPhaseEnded];
	[self removeFromParent];
}

- (void)dispatchEventWithPhase:(SHSplashScreenPhase)phase {
	SHSplashScreenEvent *event = [[SHSplashScreenEvent alloc] initWithType:SH_EVENT_TYPE_SPLASH_SCREEN phase:phase];
	[self dispatchEvent:event];
	[event release];
}

- (void)dealloc {
	[self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	[self.stage removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
	[super dealloc];
}
@end

@implementation SHSplashScreenEvent

@synthesize phase = mPhase;

- (id)initWithType:(NSString *)type phase:(SHSplashScreenPhase)phase {
	return [self initWithType:type phase:phase bubbles:YES];
}

- (id)initWithType:(NSString *)type phase:(SHSplashScreenPhase)phase bubbles:(BOOL)bubbles {
	if (self = [super initWithType:type bubbles:bubbles]) {        
		mPhase = phase;
    }
    return self;
}

+ (SHSplashScreenEvent *)eventWithType:(NSString *)type phase:(SHSplashScreenPhase)phase {
	return [[[SHSplashScreenEvent alloc] initWithType:type phase:phase bubbles:YES] autorelease];
}

+ (SHSplashScreenEvent *)eventWithType:(NSString *)type phase:(SHSplashScreenPhase)phase bubbles:(BOOL)bubbles {
	return [[[SHSplashScreenEvent alloc] initWithType:type phase:phase bubbles:bubbles] autorelease];
}
@end