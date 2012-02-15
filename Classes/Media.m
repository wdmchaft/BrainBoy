//
//  Media.m
//  BrainBoy
//
//  Created by Me on 22/10/11.
//  Copyright (c) 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "Media.h"

@implementation Media

static SPTextureAtlas *atlas = NULL;
static NSMutableDictionary *sounds = NULL;

#pragma mark Texture Atlas

+ (void)initTextures
{
    [atlas release];
    atlas = [[SPTextureAtlas alloc] initWithContentsOfFile:@"maintexture.xml"];
}

+ (void)releaseTextures
{
    [atlas release];
    atlas = nil;
}

+ (SPTexture *)atlasTexture:(NSString *)name
{
    if (!atlas)
        [NSException raise:NSGenericException format:@"call 'initTextures:' first"];
    return [atlas textureByName:name];
}

#pragma mark Audio

+ (void)initAudio
{
    if (sounds) return;
    
    [SPAudioEngine start];
    sounds = [[NSMutableDictionary alloc] init];
    
    // enumerate all sounds
    
    NSString *soundDir = [[NSBundle mainBundle] resourcePath];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager]
                                      enumeratorAtPath:soundDir];   
    
    NSString *filename;
    while (filename = [dirEnum nextObject])
    {
        if ([[filename pathExtension] isEqualToString: @"wav"])
        {
            SPSound *sound = [[SPSound alloc] initWithContentsOfFile:filename];
            SPSoundChannel *channel = [sound createChannel];
            [sounds setObject:channel forKey:filename];
            [sound release];
        }
    }
}

+ (void)releaseAudio
{
    [sounds release];
    sounds = nil;
    [SPAudioEngine stop];
}

+ (void)playSound:(NSString *)soundName
{
    [[sounds objectForKey:soundName] play];
}

+ (SPSoundChannel *)soundChannel:(NSString *)soundName
{
    return [sounds objectForKey:soundName];
}

@end
