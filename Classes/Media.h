//
//  Media.h
//  BrainBoy
//
//  Created by Me on 22/10/11.
//  Copyright (c) 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject 

+ (void)initTextures;
+ (void)releaseTextures;
+ (SPTexture *)atlasTexture:(NSString *)name;

+ (void)initAudio;
+ (void)releaseAudio;

+ (void)playSound:(NSString *)soundName;
+ (SPSoundChannel *)soundChannel:(NSString *)soundName;

@end
