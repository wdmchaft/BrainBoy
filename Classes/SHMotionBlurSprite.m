//
//  SHMotionBlurSprite.m
//  Sparrow
//
//  Created by Shilo White on 1/14/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SHMotionBlurSprite.h"
#import "SPEnterFrameEvent.h"
#import "SPRenderTexture.h"
#import "SPImage.h"

@implementation SHMotionBlurSprite

@synthesize blurDuration = mBlurDuration;
@synthesize blurAlpha = mBlurAlpha;

- (id)init
{
	return [self initWithBlurDuration:1.0f blurAlpha:0.5f width:320 height:480];
}

- (id)initWithBlurDuration:(float)blurDuration
{
	return [self initWithBlurDuration:blurDuration blurAlpha:0.5f width:320 height:480];
}

- (id)initWithBlurAlpha:(float)blurAlpha
{
	return [self initWithBlurDuration:1.0f blurAlpha:blurAlpha width:320 height:480];
}

- (id)initWithWidth:(float)width height:(float)height
{
	return [self initWithBlurDuration:1.0f blurAlpha:0.5f width:width height:height];
}

- (id)initWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha
{
	return [self initWithBlurDuration:blurDuration blurAlpha:blurAlpha width:320 height:480];
}

- (id)initWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha width:(float)width height:(float)height
{
	if (self = [super init]) 
    {
        mBlurDuration = blurDuration;
		mBlurAlpha = blurAlpha;
		
		mRenderTexture[0] = [[SPRenderTexture alloc] initWithWidth:width height:height];
		mRenderTexture[1] = [[SPRenderTexture alloc] initWithWidth:width height:height];
		mImage[0] = [SPImage imageWithTexture:mRenderTexture[0]];
		mImage[1] = [SPImage imageWithTexture:mRenderTexture[1]];
		mImage[0].visible = NO;
		mImage[1].visible = NO;
		[super addChild:mImage[0] atIndex:0];
		[super addChild:mImage[1] atIndex:1];
		
		mContainer = [SPSprite sprite];
		[super addChild:mContainer atIndex:2];
		if (mBlurDuration != SH_MOTION_BLUR_NONE) [self addEventListener:@selector(blurObjects:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }    
    return self;
}

+ (SHMotionBlurSprite *)motionBlurSprite
{
	return [[[SHMotionBlurSprite alloc] initWithBlurDuration:1.0f blurAlpha:0.5f width:320 height:480] autorelease];
}

+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurDuration:(float)blurDuration
{
	return [[[SHMotionBlurSprite alloc] initWithBlurDuration:blurDuration blurAlpha:0.5f width:320 height:480] autorelease];
}

+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurAlpha:(float)blurAlpha
{
	return [[[SHMotionBlurSprite alloc] initWithBlurDuration:1.0f blurAlpha:blurAlpha width:320 height:480] autorelease];
}

+ (SHMotionBlurSprite *)motionBlurSpriteWithWidth:(float)width height:(float)height
{
	return [[[SHMotionBlurSprite alloc] initWithBlurDuration:1.0f blurAlpha:0.5f width:width height:height] autorelease];
}

+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha
{
	return [[[SHMotionBlurSprite alloc] initWithBlurDuration:blurDuration blurAlpha:blurAlpha width:320 height:480] autorelease];
}

+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha width:(float)width height:(float)height
{
	return [[[SHMotionBlurSprite alloc] initWithBlurDuration:blurDuration blurAlpha:blurAlpha width:width height:height] autorelease];
}

- (void)blurObjects:(SPEnterFrameEvent *)event
{
	if (mImage[0].visible) {
		[mRenderTexture[0] drawObject:mContainer];
		mImage[0].alpha = 1.0f - (event.passedTime/mBlurDuration);
		
		[mRenderTexture[1] clearWithColor:0x0 alpha:1.0f];
		[mRenderTexture[1] drawObject:mImage[0]];
		mImage[1].alpha = mBlurAlpha;
		mImage[1].visible = YES;
		
		mImage[0].visible = NO;
	} else {
		[mRenderTexture[1] drawObject:mContainer];
		mImage[1].alpha = 1.0f - (event.passedTime/mBlurDuration);
		
		[mRenderTexture[0] clearWithColor:0x0 alpha:1.0f];
		[mRenderTexture[0] drawObject:mImage[1]];
		mImage[0].alpha = mBlurAlpha;
		mImage[0].visible = YES;
		
		mImage[1].visible = NO;
	}
}

- (void)setBlurDuration:(float)blurDuration
{
	if (blurDuration != mBlurDuration)
	{
		if (mBlurDuration == SH_MOTION_BLUR_NONE)
		{
			[self addEventListener:@selector(blurObjects:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		}
		else if (blurDuration == SH_MOTION_BLUR_NONE)
		{
			[self removeEventListener:@selector(blurObjects:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		}
		mBlurDuration = blurDuration;
	}
}

- (void)addChild:(SPDisplayObject *)child
{
	[mContainer addChild:child];
}

- (void)addChild:(SPDisplayObject *)child atIndex:(int)index
{
    [mContainer addChild:child atIndex:index];
}

- (BOOL)containsChild:(SPDisplayObject *)child
{
	return [mContainer containsChild:child];
}

- (SPDisplayObject *)childAtIndex:(int)index
{
    return [mContainer childAtIndex:index];
}

- (SPDisplayObject *)childByName:(NSString *)name
{
	return [mContainer childByName:name];
}

- (int)childIndex:(SPDisplayObject *)child
{
	return [mContainer childIndex:child];
}

- (void)removeChild:(SPDisplayObject *)child
{
	[mContainer removeChild:child];
}

- (void)removeChildAtIndex:(int)index
{
	[mContainer removeChildAtIndex:index];
}

- (void)swapChild:(SPDisplayObject*)child1 withChild:(SPDisplayObject*)child2
{
    [mContainer swapChild:child1 withChild:child2];
}

- (void)swapChildAtIndex:(int)index1 withChildAtIndex:(int)index2
{
	[mContainer swapChildAtIndex:index1 withChildAtIndex:index2];
}

- (void)removeAllChildren
{
	[mContainer removeAllChildren];
}

- (int)numChildren
{
	return [mContainer numChildren];
}

- (SPRectangle*)boundsInSpace:(SPDisplayObject*)targetCoordinateSpace
{    
	return [mContainer boundsInSpace:targetCoordinateSpace];
}

- (SPDisplayObject*)hitTestPoint:(SPPoint*)localPoint forTouch:(BOOL)isTouch
{
	return [mContainer hitTestPoint:localPoint forTouch:isTouch];
}

- (void)dispatchEventOnChildren:(SPEvent *)event
{
	[mContainer dispatchEventOnChildren:event];
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
	return [mContainer countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)dealloc
{
	if (mBlurDuration != SH_MOTION_BLUR_NONE) [self removeEventListener:@selector(blurObjects:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	[super removeChildAtIndex:[super childIndex:mContainer]];
	[super removeChildAtIndex:[super childIndex:mImage[0]]];
	[super removeChildAtIndex:[super childIndex:mImage[1]]];
	[mRenderTexture[0] release];
	[mRenderTexture[1] release];
	[super dealloc];
}
@end