//
//  SHMotionBlurSprite.h
//  Sparrow
//
//  Created by Shilo White on 1/14/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#define SH_MOTION_BLUR_INFINITE -1
#define SH_MOTION_BLUR_NONE 0

#import "SPSprite.h"
@class SPEnterFrameEvent;
@class SPRenderTexture;
@class SPImage;

@interface SHMotionBlurSprite : SPSprite {
	SPSprite *mContainer;
	SPRenderTexture *mRenderTexture[2];
	SPImage *mImage[2];
	float mBlurDuration;
	float mBlurAlpha;
}

@property (nonatomic, assign) float blurDuration;
@property (nonatomic, assign) float blurAlpha;

- (id)initWithBlurDuration:(float)blurDuration;
- (id)initWithBlurAlpha:(float)blurAlpha;
- (id)initWithWidth:(float)width height:(float)height;
- (id)initWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha;
- (id)initWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha width:(float)width height:(float)height;

+ (SHMotionBlurSprite *)motionBlurSprite;
+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurDuration:(float)blurDuration;
+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurAlpha:(float)blurAlpha;
+ (SHMotionBlurSprite *)motionBlurSpriteWithWidth:(float)width height:(float)height;
+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha;
+ (SHMotionBlurSprite *)motionBlurSpriteWithBlurDuration:(float)blurDuration blurAlpha:(float)blurAlpha width:(float)width height:(float)height;
@end
